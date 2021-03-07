unit fMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Types,
  System.UITypes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Cairo.Types,
  Cairo.Base,
  Cairo.Interfaces,
  Cairo.FtFontManager,
  Vcl.ComCtrls;

type

  TForm16 = class(TForm)
    Button2: TButton;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    PaintBox1: TPaintBox;
    TabSheet2: TTabSheet;
    PaintBox2: TPaintBox;
    TabSheet3: TTabSheet;
    PaintBox3: TPaintBox;
    TabSheet4: TTabSheet;
    PaintBox4: TPaintBox;
    TabSheet5: TTabSheet;
    PaintBoxLeft: TPaintBox;
    TabSheet6: TTabSheet;
    Image1: TImage;
    TabSheet7: TTabSheet;
    PaintBox5: TPaintBox;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    TabSheet8: TTabSheet;
    PaintBoxFreetype: TPaintBox;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure PaintBox3Paint(Sender: TObject);
    procedure PaintBox4Paint(Sender: TObject);
    procedure PaintBox5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox5Paint(Sender: TObject);
    procedure PaintBoxFreetypePaint(Sender: TObject);
    procedure PaintBoxLeftPaint(Sender: TObject);
    procedure TabSheet5Resize(Sender: TObject);

  private
    fMetaSurface: ICairoSurface;
    fActualViewMatrix: TCairoMatrix;
    fActualInverseViewMatrix: TCairoMatrix;

    { Private-Deklarationen }
    procedure PaintCurves(Cairo: ICairoContext);
    procedure PaintLines(Cairo: ICairoContext);
    procedure PaintPattern(Cairo: ICairoContext);
    procedure PaintText(Cairo: ICairoContext);

    procedure PaintCanvas(Canvas: TCanvas; Offsetx: Integer);

    procedure PaintFreeType(Cairo: ICairoContext);

    procedure MetaFileTest;
    procedure MetaFileTest2;
    procedure MetaFileTest3;

  protected

  public
  end;

var
  Form16: TForm16;

implementation

uses
  //Winapi.SHFolder,
  System.Math,
  System.Math.Vectors,
  System.ioUtils,
  Clipbrd,
  Vcl.Imaging.pngImage,
  Cairo.Font,
  Cairo.Stream,
  Cairo.dll,
  Cairo.Canvas,
  Cairo.Surface,
  Cairo.FreeType,
  Cairo.Emf,
  Cairo.Emf.worker,
  Cairo.Emf.Implementations,
  Cairo.EmftoCairo,
  TestClass,
  testExport;

{$R *.dfm}

procedure TForm16.FormResize(Sender: TObject);
begin
  PaintBox1.width := ClientRect.width; // div 2;
end;

procedure TForm16.PaintBox1Paint(Sender: TObject);
var
  lCanvas: ICairoContext;
  lSurface: ICairoSurface;
const
  crossh = 40.5;

begin
  lSurface := CairoFactory.createGDI_with_format(PaintBox1.Canvas.Handle, CAIRO_FORMAT_ARGB32);
  try
    lCanvas := CairoFactory.CreateContext(lSurface);
    try
      PaintLines(lCanvas);
    finally
      lSurface.flush;
      lCanvas := nil;
    end;
  finally
    lSurface := nil;
  end;
end;

procedure TForm16.PaintBox2Paint(Sender: TObject);
var
  lCanvas: ICairoContext;
  lSurface: ICairoSurface;

begin
  lSurface := CairoFactory.createGDI_with_format(PaintBox2.Canvas.Handle, CAIRO_FORMAT_ARGB32);
  try
    lCanvas := CairoFactory.CreateContext(lSurface);
    try
      PaintCurves(lCanvas);
    finally
      lSurface.flush;
      lCanvas := nil;
    end;
  finally
    lSurface := nil;
  end;
end;

procedure TForm16.PaintBox3Paint(Sender: TObject);
var
  lCanvas: ICairoContext;
  lSurface: ICairoSurface;

begin
  // lSurface := TcaGdiSurface.create(PaintBox3.Canvas.Handle);
  GdiFlush;
  lSurface := CairoFactory.createGDI_with_format(PaintBox3.Canvas.Handle, CAIRO_FORMAT_ARGB32);
  try
    lCanvas := CairoFactory.CreateContext(lSurface);
    try
      PaintPattern(lCanvas);
      lSurface.flush;
    finally
      lCanvas := nil;
    end;
  finally
    lSurface := nil;
  end;
end;

procedure TForm16.PaintBox4Paint(Sender: TObject);
var
  lCanvas: ICairoContext;
  lSurface: ICairoSurface;
  lSize: Tsize;

begin
  SetTextAlign(PaintBox4.Canvas.Handle, TA_BASELINE);
  PaintBox4.Canvas.TextOut(0, 24, 'GDI Text on 0, 24');
  lSize := PaintBox4.Canvas.TextExtent('GDI Text on 0, 240');
  PaintBox4.Canvas.Brush.Style := bsClear;
  PaintBox4.Canvas.Rectangle(0, 0, lSize.cx, lSize.cy);
  GdiFlush;
  lSurface := CairoFactory.createGDI_with_format(PaintBox4.Canvas.Handle, CAIRO_FORMAT_ARGB32);
  try
    lCanvas := CairoFactory.CreateContext(lSurface);
    try
      PaintText(lCanvas);
      lSurface.flush;
    finally
      lCanvas := nil;
    end;
  finally
    lSurface := nil;
  end;
end;

procedure TForm16.PaintBoxLeftPaint(Sender: TObject);
var
  fCairo: TCairoCanvas;
begin
  PaintCanvas(PaintBoxLeft.Canvas, 10);
  fCairo := TCairoCanvas.CreateGdi(PaintBoxLeft.Canvas.Handle);
  fCairo.Aliasing := caBest;
  PaintCanvas(fCairo, PaintBoxLeft.width div 2);
  fCairo.Free;
end;

procedure TForm16.PaintLines(Cairo: ICairoContext);

var
  lps: TCairoLineStyle;
  // X,
  Y: double;
  old: double;

const
  offsety: double = 10.5;
  offsX: double = 340.5;

  function inc(var Value: double; offset: Integer): double;
  begin
    Value := Value + offset;
    result := Value;
  end;

begin
  Cairo.line_width := 0.1;
  Cairo.setcolor(clBlack);
  // Default Black width 1
  Cairo.move_to(10, offsety + 10);
  Cairo.line_to(100, offsety + 10);
  Cairo.stroke;
  Cairo.line_width := 0.3;
  Cairo.setcolor(clBlue);
  Cairo.move_to(100, offsety + 10.1);
  Cairo.line_to(200, offsety + 10.1);
  Cairo.stroke;

  // Abgewinkelte rote Linie
  Cairo.setcolor(clred);
  Cairo.line_width := 5;

  Cairo.move_to(10, offsety + 20);
  Cairo.line_to(300, offsety + 20);
  Cairo.line_to(300, offsety + 130);
  Cairo.stroke;
  // Dottet und co
  Cairo.line_width := 1;
  Cairo.setcolor(clBlue);
  Y := offsety + 40;
  for lps := lsSolid to lsDashDotDot do
  begin
    Cairo.setLineStyle(lps);

    Cairo.move_to(10, Y);

    Cairo.line_to(300, Y);
    inc(Y, 20);
    Cairo.stroke;
  end;

  // Dottet und co mit Linewidth > 1
  Cairo.line_width := 7;
  Cairo.setcolor(clBlack);

  Y := offsety + 160;
  for lps := lsSolid to lsDashDotDot do
  begin
    Cairo.setLineStyle(lps);
    Cairo.move_to(10, Y);
    Cairo.line_to(300, Y);
    inc(Y, 20);
    Cairo.stroke;
  end;

  Y := offsety;

  Cairo.setLineStyle(lsSolid);
  Cairo.setcolor(clBlue);
  Cairo.line_width := 15;
  Cairo.line_cap := CAIRO_LINE_CAP_BUTT;
  Cairo.move_to(offsX, Y);
  Cairo.line_to(offsX + 300, Y);
  inc(Y, 20);
  Cairo.stroke;

  Cairo.line_cap := CAIRO_LINE_CAP_ROUND;

  // cairo_set_line_cap(Cairo.Handle, CAIRO_LINE_CAP_ROUND);
  Cairo.move_to(offsX, Y);
  Cairo.line_to(offsX + 300, Y);
  inc(Y, 20);
  Cairo.stroke;

  Cairo.line_cap := CAIRO_LINE_CAP_SQUARE;
  Cairo.move_to(offsX, Y);
  Cairo.line_to(offsX + 300, Y);

  Cairo.stroke;

  Y := offsety + 200;

  Cairo.line_cap := CAIRO_LINE_CAP_BUTT;

  // Line Join

  Cairo.setcolor(clred);
  old := Cairo.miter_limit;

  Cairo.line_join := CAIRO_LINE_JOIN_ROUND;
  Cairo.move_to(offsX, Y);
  Cairo.rel_line_to(50, -140);
  Cairo.rel_line_to(150, 140);
  inc(Y, 70);
  Cairo.stroke;

  Cairo.setcolor(clOlive);
  Cairo.line_join := CAIRO_LINE_JOIN_BEVEL;
  Cairo.move_to(offsX, Y);
  Cairo.rel_line_to(50, -140);
  Cairo.rel_line_to(150, 140);
  inc(Y, 70);
  Cairo.stroke;

  Cairo.setcolor(clGreen);

  Cairo.line_join := CAIRO_LINE_JOIN_MITER;
  Cairo.move_to(offsX, Y);
  Cairo.rel_line_to(50, -140);
  Cairo.rel_line_to(150, 140);
  inc(Y, 70);
  Cairo.stroke;

  Cairo.setcolor(clWebLavender);
  Cairo.line_join := CAIRO_LINE_JOIN_MITER;
  Cairo.miter_limit := 1;
  Cairo.move_to(offsX, Y);
  Cairo.rel_line_to(50, -140);
  Cairo.rel_line_to(150, 140);
  inc(Y, 70);
  Cairo.stroke;
  Cairo.miter_limit := old;

end;

procedure TForm16.PaintCurves(Cairo: ICairoContext);
var
  // X,
  Y: double;

const
  offsety: double = 110.5;
  offsX: double = 340.5;

  function inc(var Value: double; offset: Integer): double;
  begin
    Value := Value + offset;
    result := Value;
  end;

begin
  Y := offsety;
  // Arcs
  Cairo.line_width := 0.5;
  Cairo.setcolor(clBlack);
  Cairo.setLineStyle(lsSolid);
  Cairo.arc(100.5, Y, 100, 0, pi * 2);
  Cairo.stroke;
  Cairo.arc(200.5, Y, 100, pi, pi * 2);
  Cairo.stroke;

  Cairo.setcolor(clGray);
  Cairo.line_width := 1;

  inc(Y, 120);
  Cairo.move_to(200.5, Y);
  Cairo.rel_line_to(100, 0);
  Cairo.stroke;
  Cairo.move_to(200.5, Y);
  Cairo.rel_line_to(100, -100);
  Cairo.stroke;
  Cairo.line_width := 5;
  Cairo.setcolor(clred, 0.3);
  Cairo.move_to(200.5, Y);
  Cairo.arc_negative(200.5, Y, 100, degToRad(315), degToRad(270));
  Cairo.rel_line_to(0, 100);
  // Cairo.close_path;
  Cairo.stroke;

  inc(Y, 100);
  Cairo.move_to(10, Y);
  Cairo.curve_to(200, Y, 200, Y - 100, 10, Y - 100);
  Cairo.line_width := 1;
  Cairo.stroke;
  // Cairo.close_path;
  // Cairo.setColor(clSilver,0.2);
  // Cairo.fill;

  Cairo.Rectangle(10, Y, 5, 5);
  Cairo.Rectangle(200, Y, 5, 5);
  Cairo.Rectangle(200, Y - 100, 5, 5);
  Cairo.Rectangle(10, Y - 100, 5, 5);
  Cairo.setcolor(clBlack, 0.9);
  Cairo.fill;

end;

procedure TForm16.PaintPattern(Cairo: ICairoContext);
var
  X, Y: double;
  lPattern: ICairoPattern;
  ta: TCairoColor;
  // ref : Cardinal;
  // ext : cairo_extend_t;

const
  offsety: double = 10.5;
  offsX: double = 40.5;

  function inc(var Value: double; offset: Integer): double;
  begin
    Value := Value + offset;
    result := Value;
  end;

begin
  X := offsX;
  Y := offsety;
  Cairo.Rectangle(X, Y, 200, 100);
  // Fill solid
  Cairo.setcolor(clSilver);
  Cairo.fill_preserve;
  Cairo.setcolor(clBlack);
  Cairo.setLineStyle(lsDash);
  Cairo.line_width := 1;
  Cairo.stroke;
  Cairo.setLineStyle(lsSolid);
  inc(Y, 120);
  Cairo.Rectangle(X, Y, 200, 100);
  ta.Color := TColorRec.Darkorange;
  lPattern := CairoFactory.Patterncreate_rgb(ta.Red, ta.Green, ta.Blue);
  Cairo.set_source(lPattern);
  Cairo.fill;

  inc(Y, 40);
  Cairo.Rectangle(X + 40, Y, 200, 100);
  ta.Color := TColorRec.Lightcoral;
  ta.Alpha := 0.5;
  lPattern := CairoFactory.Patterncreate_rgbaColor(ta);
  Cairo.set_source(lPattern);
  Cairo.fill;
  Cairo.setcolor(clSilver);

  inc(Y, 120);
  Cairo.Rectangle(X, Y, 200, 100);

  lPattern := CairoFactory.Patterncreate_linearWH(X, Y, 200, 100);

  ta.Color := TColorRec.Black;
  // Ta.Alpha := 0.1;
  lPattern.add_color_stop_rgbA(0.1, ta);

  ta.Color := TColorRec.Seashell;
  // Ta.Alpha := 0.2;
  lPattern.add_color_stop_rgbA(0.5, ta);

  ta.Color := TColorRec.Black;
  // Ta.Alpha := 0.2;
  lPattern.add_color_stop_rgbA(0.9, ta);
  Cairo.set_source(lPattern);
  Cairo.fill_preserve;
  Cairo.setcolor(clBlack);
  Cairo.stroke;

  inc(Y, 120);
  Cairo.Rectangle(X, Y, 200, 100);

  lPattern := CairoFactory.Patterncreate_linearWH(X, Y, 0, 100);

  ta.Color := TColorRec.Black;
  // Ta.Alpha := 0.1;
  lPattern.add_color_stop_rgbA(0.9, ta);

  ta.Color := TColorRec.Seashell;
  // Ta.Alpha := 0.2;
  lPattern.add_color_stop_rgbA(0.99, ta);

  // ta.Color := TColorRec.Black;
  // // Ta.Alpha := 0.2;
  // TGradientPattern(lPattern).add_color_stop_rgbA(0.9, ta);
  Cairo.set_source(lPattern);
  Cairo.fill;

  //

  lPattern := CairoFactory.Patterncreate_linearWH(X, Y, 200, 0);
  Cairo.Rectangle(X, Y, 200, 90);

  ta.Color := TColorRec.Black;
  // Ta.Alpha := 0.1;
  lPattern.add_color_stop_rgbA(0.8, ta);

  ta.Color := TColorRec.Seashell;
  // Ta.Alpha := 0.2;
  lPattern.add_color_stop_rgbA(0.99, ta);

  // ta.Color := TColorRec.Black;
  // // Ta.Alpha := 0.2;
  // TGradientPattern(lPattern).add_color_stop_rgbA(0.9, ta);
  Cairo.set_source(lPattern);
  Cairo.fill;

  Cairo.Rectangle(X, Y, 190, 90);

  Cairo.setcolor(clYellow);
  Cairo.fill_preserve;

  Cairo.setcolor(clBlack);

  Cairo.stroke;
  X := offsX + 300;
  Y := offsety;

  // x := 0.5;
  // y := 0.5;

  Cairo.Rectangle(X, Y, 200, 100);

  // lPattern := TMeshPattern.Create;
  //
  // TMeshPattern(lPattern).test;
  // lPattern.Translate(-X, -Y);
  // Cairo.set_source(lPattern);
  // Cairo.fill_preserve;
  //
  Cairo.setcolor(clBlack);
  Cairo.stroke;

  inc(Y, 120);

  Cairo.Rectangle(X, Y, 200, 100);
  // Cairo.setColor(clWebPeachPuff, 0.4);
  // Cairo.fill_preserve;

  ta.Color := TColorRec.DarkBlue;
  ta.Alpha := 0.7;
  lPattern := CairoFactory.CreateCrossPattern(5, ta, 0.1);
  lPattern.Rotate(45);

  Cairo.arc(X + 100, Y + 100, 50, 0, degToRad(180));
  Cairo.set_source(lPattern);
  Cairo.fill; // _preserve;
  Cairo.setcolor(clBlack);

  Cairo.Rectangle(X, Y, 200, 100);
  Cairo.stroke;
  // Cairo.arc(x +100,y+100, 50, 0, DegToRad(180));
  // Cairo.stroke;

  inc(Y, 120);
  Cairo.Rectangle(X, Y, 200, 100);
  Cairo.clip_preserve;
  ta.Alpha := 1;
  lPattern := CairoFactory.Create2LinePattern(10, ta, lsDashDot, 0.3);
  lPattern.Rotate(-30);
  Cairo.set_source(lPattern);
  Cairo.fill_preserve;
  // Ü cairo.line_width := 20;
  // Cairo.stroke;
  Cairo.setcolor(clBlack);
  // Cairo.rectangle(X, Y, 200, 100);
  Cairo.line_width := 1;
  Cairo.stroke;
  Cairo.reset_clip;
  inc(Y, 120);
  Cairo.Rectangle(X, Y, 200, 100);
  Cairo.new_sub_path;
  Cairo.Circle(X + 50, Y + 110, 30);
  Cairo.close_path;

  Cairo.new_sub_path;
  Cairo.circle_negative(X + 150, Y + 110, 40);
  Cairo.close_path;

  Cairo.fill_rule := CAIRO_FILL_RULE_WINDING;

  Cairo.setcolor(clBlue);
  Cairo.fill_preserve;
  Cairo.setcolor(clBlack);
  Cairo.stroke;

end;

procedure TForm16.PaintText(Cairo: ICairoContext);
var
  lFont: ICairoFont;
  X, Y: double;
  lExtents: cairo_text_extents_t;
  lFontExtend, lFontExtend2: cairo_font_extents_t;
  lPattern: ICairoPattern;
  lc: TCairoColor;
  lt: Tfont;

  s: string; // = 'Font Face Size 18 Alias g'+#0;
  ns: string; // = '23,25';
  fs: double;

begin
  s := ' Font Face Size 18 Alias';
  ns := '23,25';

  X := 10.5;

  fs := 72.00001 * 96 / 72;
  fs := 96.000001;
  fs := 3 * 24;

   lt := Tfont.Create;
   lt.Name := 'Arial';

   lFont := TScaledWinFont.create_for_hfont(lt.Handle, 72);
   lt.Free;

  try
    Cairo.SetCairoFont(lFont);
    lExtents := lFont.text_extents(s);

    Y := lExtents.height + 40.5;

    Cairo.Rectangle(X + lExtents.x_bearing, Y + lExtents.y_bearing, lExtents.width, lExtents.height);
    Cairo.setcolor(clLtGray);
    Cairo.fill_preserve;

    Cairo.setcolor(clBlack);
    Cairo.line_width := 1;
    Cairo.stroke;

    Y := round(Y) + 1.5;
    Cairo.move_to(X, Y);
    Cairo.setcolor(clBlue);
    // 'Font Face Size 18 Alias g'+#0;
    Cairo.text_path(s);
    Cairo.fill;

    lc.Color := clred;
    lPattern := CairoFactory.Patterncreate_rgbColor(lc);
    Cairo.set_source(lPattern);

    Cairo.arc(X, Y, 5, 0, pi * 2);
    Cairo.stroke;

    lc.Color := clFuchsia;
    lPattern := CairoFactory.Patterncreate_rgbColor(lc);
    Cairo.set_source(lPattern);

    // Top
    Cairo.arc(X + lExtents.x_bearing, Y + lExtents.y_bearing, 5, 0, pi * 2);
    Cairo.stroke;

    // Right
    Cairo.setcolor(clMoneyGreen);
    Cairo.arc(X + lExtents.x_advance, Y + lExtents.y_advance, 5, 0, pi * 2);
    Cairo.fill;

    Cairo.setcolor(clBlack);
    Cairo.move_to(X + lExtents.x_advance, Y + lExtents.y_advance);
    Cairo.rel_line_to(0, -lExtents.height);
    Cairo.stroke;

    lFontExtend := lFont.extents;

    lc.Color := clSkyBlue;
    lPattern := CairoFactory.Patterncreate_rgbColor(lc);
    Cairo.set_source(lPattern);

    Cairo.arc(X, Y - lFontExtend.ascent, 5, 0, pi * 2);
    Cairo.stroke;
    Cairo.move_to(X, Y - lFontExtend.ascent);
    Cairo.rel_line_to(200, 0);
    Cairo.stroke;

    lc.Color := clLime;
    lPattern := CairoFactory.Patterncreate_rgbColor(lc);
    Cairo.set_source(lPattern);

    Cairo.arc(X, Y + lFontExtend.descent, 5, 0, pi * 2);
    Cairo.stroke;

  finally
    lFont := nil;
  end;

  lt := Tfont.Create;
  lt.Name := 'Arial';

  lFont := TScaledWinFont.create_for_hfont(lt.Handle, 36.00001 * 96 / 72);
  lt.Free;

  try
    Cairo.SetCairoFont(lFont);
    lExtents := lFont.text_extents(ns);
    lFontExtend2 := lFont.extents;
    Y := Y + 20;
    // lExtents.height+
    Y := Y + lFontExtend.descent + lFontExtend2.ascent;

    Cairo.Rectangle(X + lExtents.x_bearing, Y + lExtents.y_bearing, lExtents.width, lExtents.height);

    Cairo.setcolor(clLtGray);
    Cairo.fill_preserve;

    Cairo.setcolor(clBlack);

    Cairo.line_width := 1;
    Cairo.stroke;

    // y := round(y)+1.5;
    Cairo.move_to(X, Y);
    Cairo.setcolor(clBlue);
    Cairo.text_path(ns);
    Cairo.fill;

    lc.Color := clred;
    lPattern := CairoFactory.Patterncreate_rgbColor(lc);
    Cairo.set_source(lPattern);

    Cairo.arc(X, Y, 5, 0, pi * 2);
    Cairo.stroke;
    Cairo.arc(X + lExtents.x_advance, Y + lExtents.y_advance, 5, 0, pi * 2);
    Cairo.stroke;

    Cairo.arc(X + lExtents.x_bearing, Y + lExtents.y_bearing, 5, 0, pi * 2);
    Cairo.stroke;

    lFontExtend := lFont.extents;

    lc.Color := clGreen;
    lPattern := CairoFactory.Patterncreate_rgbColor(lc);
    Cairo.set_source(lPattern);

    Cairo.arc(X, Y - lFontExtend.ascent, 5, 0, pi * 2);
    Cairo.stroke;
    Cairo.arc(X, Y + lFontExtend.descent, 5, 0, pi * 2);
    Cairo.stroke;

    // Cairo.move_to(x+lExtents.x_advance,y+lExtents.y_advance);
    // Cairo.text_path('Anschluss');
    // Cairo.Fill;
  finally
    lFont := nil;
  end;

end;

procedure TForm16.TabSheet5Resize(Sender: TObject);
begin
  PaintBoxLeft.width := TabSheet5.ClientWidth div 2;
end;

procedure TForm16.PaintCanvas(Canvas: TCanvas; Offsetx: Integer);
Var
  X, Y: Integer;
  cPoints: TArray<TPoint>;
  I: Integer;
begin
  X := Offsetx;
  Y := 0;
  Canvas.Refresh;

  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Style := Vcl.Graphics.psSolid;
  Canvas.Pen.width := 1;
  Canvas.Pen.Color := clBlack;

  Canvas.Brush.Color := clLime;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);

  inc(Y, 60);
  Canvas.Brush.Color := clYellow;
  Canvas.Brush.Style := TBrushStyle.bsHorizontal;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);

  inc(Y, 60);
  Canvas.Brush.Color := clGreen;
  Canvas.Brush.Style := TBrushStyle.bsVertical;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);

  inc(Y, 60);
  Canvas.Pen.Color := clred;
  Canvas.Brush.Color := clGreen;
  Canvas.Brush.Style := TBrushStyle.bsFDiagonal;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);

  inc(Y, 60);
  Canvas.Brush.Color := clGreen;
  Canvas.Brush.Style := TBrushStyle.bsBDiagonal;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);

  inc(Y, 60);
  Canvas.Brush.Color := clGreen;
  Canvas.Brush.Style := TBrushStyle.bsCross;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);

  inc(Y, 60);
  Canvas.Brush.Color := clGreen;
  Canvas.Brush.Style := TBrushStyle.bsDiagCross;
  Canvas.Rectangle(X, Y, X + 200, Y + 50);
  Canvas.Pen.Color := clred;
  Canvas.MoveTo(Offsetx, 0);
  Canvas.LineTo(Offsetx + 200, 100);

  Canvas.Pen.width := 5;
  Canvas.MoveTo(Offsetx + 0, 100);
  Canvas.LineTo(Offsetx + 200, 200);

  Canvas.Pen.width := 3;
  Canvas.Pen.Color := clBlue;
  Canvas.LineTo(Offsetx + 100, 300);

  Canvas.Pen.width := 0;
  Canvas.Pen.Style := Vcl.Graphics.psDash;
  Canvas.LineTo(Offsetx + 0, 300);

  Canvas.Pen.width := 0;
  Canvas.Pen.Style := Vcl.Graphics.psDot;
  Canvas.LineTo(Offsetx + 100, 100);

  Canvas.AngleArc(Offsetx + 50, 50, 50, 0, 360);

  Y := 200;
  Canvas.Pen.Style := Vcl.Graphics.psSolid;
  Canvas.arc(X, Y, X + 200, Y + 50, X, Y, X, Y);
  Y := 300;
  Canvas.Pen.Style := Vcl.Graphics.psSolid;
  Canvas.Brush.Style := bsSolid;
  Canvas.Ellipse(X, Y, X + 200, Y + 50);

  Y := 400;
  Canvas.Pen.Style := Vcl.Graphics.psSolid;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clLtGray;

  Canvas.Pie(X, Y, X + 200, Y + 50, X, Y, X + 50, Y);
  Y := 350;
  Canvas.Chord(X, Y, X + 200, Y + 50, X, Y, X + 50, Y + 50);

  Y := Y + 100;
  Canvas.Brush.Color := clWebCoral;
  Canvas.Pen.width := 1;
  Canvas.Pen.Style := Vcl.Graphics.psDashDotDot;

  Canvas.RoundRect(X, Y, X + 200, Y + 70, 20, 20);

  Canvas.Pen.width := 1;
  Canvas.Pen.Style := Vcl.Graphics.psSolid;

  inc(Y, 80);
  Canvas.MoveTo(X, Y);

  setlength(cPoints, 4);
  cPoints[0] := TPoint.Create(X, Y);
  cPoints[3] := TPoint.Create(X + 200, Y + 30);
  cPoints[1] := TPoint.Create(X, Y + 100);
  cPoints[2] := TPoint.Create(X + 200, Y + 100);
  Canvas.PolyBezier(cPoints);

  for I := Low(cPoints) to High(cPoints) do
  begin
    with cPoints[I] do
      Canvas.Ellipse(X - 3, Y - 3, X + 3, Y + 3);
  end;

  Canvas.Pen.Style := psDot;
  Canvas.Brush.Style := bsClear;
  Canvas.Polygon(cPoints);

  Canvas.Pen.Style := psSolid;
  inc(Y, 120);
  Canvas.MoveTo(X, Y);

  setlength(cPoints, 3);
  cPoints[1] := TPoint.Create(X + 200, Y + 30);
  cPoints[0] := TPoint.Create(X, Y + 100);
  cPoints[2] := TPoint.Create(X + 200, Y + 100);
  Canvas.PolyBezierTo(cPoints);

  Canvas.Brush.Color := clWebCoral;
  for I := Low(cPoints) to High(cPoints) do
    with cPoints[I] do
      Canvas.Ellipse(X - 3, Y - 3, X + 3, Y + 3);
  Canvas.Ellipse(X - 3, Y - 3, X + 3, Y + 3);

  Canvas.Pen.Style := psDot;
  Canvas.MoveTo(X, Y);
  for I := Low(cPoints) to High(cPoints) do
    with cPoints[I] do
      Canvas.LineTo(X, Y);

  Canvas.LineTo(X, Y);

  Canvas.Pen.width := 1;

  Y := 120;
  X := Offsetx + 200;
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 44;
  Canvas.Font.Color := clBlack;
  Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic, fsUnderline, fsStrikeOut];

  Canvas.TextOut(X, Y, 'Font ' + Canvas.Font.PixelsPerInch.ToString);

  Canvas.Pen.Style := Vcl.Graphics.psDashDotDot;
  Canvas.MoveTo(X, Y);
  Canvas.LineTo(X + Canvas.TextWidth('Font ' + Canvas.Font.PixelsPerInch.ToString), Y);

  Y := Y + Canvas.TextHeight('T');
  Canvas.MoveTo(X, Y);
  Canvas.LineTo(X + Canvas.TextWidth('Font ' + Canvas.Font.PixelsPerInch.ToString), Y);

  Y := Y + 200;
  inc(X, 100);

  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := clLtGray;
  Canvas.Brush.Color := clLtGray;
  for I := 1 to 5 do
  begin
    dec(X);
    dec(Y);
    Canvas.RoundRect(X, Y, X + 300, Y + 100, 20, 20);
  end;
  dec(X);
  dec(Y);

  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := clGray;
  Canvas.Brush.Color := clLtGray;
  Canvas.RoundRect(X, Y, X + 300, Y + 100, 20, 20);

  if Canvas is TCairoCanvas then
  begin
    Canvas.Font.Size := 24;
    Canvas.Pen.Style := Vcl.Graphics.psSolid;
    Canvas.Ellipse(X - 10, Y - 10, X + 10, Y + 10);
    TCairoCanvas(Canvas).TextOutf(X, Y, 90, 24, 'TestText');
    Canvas.Font.Color := clLime;
    TCairoCanvas(Canvas).TextOutf(X, Y, 180, 24, 'TestText');
    Canvas.Font.Color := clSkyBlue;
    TCairoCanvas(Canvas).TextOutf(X, Y, 270, 24, 'TestText');

    Canvas.Font.Color := clred;
    TCairoCanvas(Canvas).TextOutf(X, Y, 0, 24, 'TestText');

    Canvas.Font.Color := clBlue;
    TCairoCanvas(Canvas).TextOutf(X, Y, 45, 14, 'TestText');
  end;

end;


procedure TForm16.Button2Click(Sender: TObject);
begin
  doPdf;
  DoSvgAll;
end;

procedure TForm16.FormCreate(Sender: TObject);
begin
  MetaFileTest;
end;

procedure TForm16.Button7Click(Sender: TObject);
begin
  MetaFileTest3;
end;

procedure TForm16.PaintFreeType(Cairo: ICairoContext);
Var
  lp: FT_Library;
  FTE: FT_Error;
  FFace: FT_Face;
  la: UTF8String;
  ct: Pcairo_font_face_t;
  lUnitext: String;
  lPath: String;
  lFontName: String;

begin
  lFontName := 'din1451alt.ttf';
  lPath := Tpath.Combine(Tpath.GetLibraryPath, 'Fonts');
  la := Tpath.Combine(lPath, lFontName);

  lp := default (FT_Library);
  FTE := FT_Init_FreeType(lp);
  if FTE = FT_ERR_BASE then
  begin
    FTE := FT_New_Face(lp, pAnsichar(la), 0, FFace);
    if FTE = FT_ERR_BASE then
    begin
      Cairo.setcolor(clWhite);
      Cairo.paint_with_alpha(1.0);
      ct := cairo_ft_font_face_create_for_ft_face(FFace, 0);
      cairo_set_font_face(Cairo.Handle, ct);
      // ce := cairo.status;
      if Cairo.status = CAIRO_STATUS_SUCCESS then
      begin

        Cairo.set_font_size(60);
        Cairo.move_to(10, 100);
        Cairo.text_path(format('Freetype Font [%s]', [Tpath.GetFileName(la)]));
        Cairo.set_font_size(40);
        Cairo.move_to(10, 200);
        Cairo.text_path('1234567890');
        Cairo.move_to(10, 300);
        Cairo.text_path('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

        Cairo.move_to(10, 400);
        Cairo.text_path('()[]{}ÄÖÜäöü');

        Cairo.move_to(10, 500);
        lUnitext := Char($F2B9);
        Cairo.text_path(lUnitext);

        Cairo.setcolor(clBlue, 0.2);
        // Cairo.fill_preserve;
        Cairo.setcolor(clBlack);
        Cairo.line_width := 0.5;
        Cairo.fill;

      end;
      FT_Done_Face(FFace);
    end;

    FT_Done_FreeType(lp);
  end;

end;

procedure TForm16.MetaFileTest;
Var
  lfilename: String;
  lemf: IEmfEnum;
  R: TRect;
  mf: Tmetafile;
  p: Pointer;

  lRecoding: iCairoRecordingSurface;
  lContext: ICairoContext;
  lExtends: cairo_rectangle_t;
  lx, ly, lw, lh: double;
begin
  fMetaSurface := CairoFactory.CreateRecording(nil);
  lContext := CairoFactory.CreateContext(fMetaSurface);

  mf := Image1.Picture.Metafile;

  R.Left := 0;
  R.Top := 0;
  R.Right := mf.width;
  R.Bottom := mf.height;

  lemf := TEmfEnum.Create(lContext);
  p := Pointer(lemf);
  EnumEnhMetaFile(getDc(0), mf.Handle, @EnumEmfCairoFunc, p, R);

  if supports(fMetaSurface, iCairoRecordingSurface, lRecoding) then
  begin
    lRecoding.ink_extents(lx, ly, lw, lh);
    // showmessage(Format(' %f %f %f %f  ',[lx, ly, lw, lh]));
  end;
  PaintBox5.Invalidate;
end;

procedure TForm16.MetaFileTest2;
Var
  ltemp: TEmfToCairoClass;
  lCairo: Pcairo_surface_t;
  lRes: Boolean;

begin
  ltemp := TEmfToCairoClass.Create;
  try
    lRes := ltemp.CreateCairo(Image1.Picture.Metafile.Handle, lCairo);
    if lRes then
      fMetaSurface := CairoFactory.CreateRecording(lCairo);
  finally
    ltemp.Free;
  end;

  PaintBox5.Invalidate;
end;

procedure TForm16.MetaFileTest3;
Var
  lfilename: String;
  lemf: IEmfEnum;
  R: TRect;
  mf: Tmetafile;
  p: Pointer;

  lRecoding: iCairoRecordingSurface;
  lContext: ICairoContext;
  lExtends: cairo_rectangle_t;
  lx, ly, lw, lh: double;

  ltemp: TEmfToCairoClass;
  lCairo: Pcairo_surface_t;
  lRes: Boolean;

begin

  if clipboard.HasFormat(CF_ENHMETAFILE) then
  begin
    mf := Tmetafile.Create;
    try
      mf.Assign(clipboard);
      // Clipboard.

      ltemp := TEmfToCairoClass.Create;
      try
        lRes := ltemp.CreateCairo(mf.Handle, lCairo);
        if lRes then
          fMetaSurface := CairoFactory.CreateRecording(lCairo);
      finally
        ltemp.Free;
      end;

      PaintBox5.Invalidate;
    finally
      mf.Free;
    end;
  end;
end;

procedure TForm16.PaintBox5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  lx, ly: double;
  lix, liy: double;

begin
  lx := X;
  ly := Y;
  fActualViewMatrix.transform_point(lx, ly);
  lix := lx;
  liy := ly;
  fActualInverseViewMatrix.transform_point(lix, liy);

  Label1.Caption := format('Pos: %d / %d  Scaled: %8.3f / %8.3f  and Back: %8.3f / %8.3f ', [X, Y, lx, ly, lix, liy]);
end;

procedure TForm16.PaintBox5Paint(Sender: TObject);
const
  Border = 40;
  // lScale = 2.90;
  lScale = 1;

var
  fCairo: ICairoContext;
  fTarget: ICairoSurface;
  ftemp: iCairoRecordingSurface;
  // lx, ly, lh, lw : Double;
  lScaleTrans: cairo_rectangle_t;
  lw, lh: double;
  lmatrix: cairo_matrix_t;

  function getScaleAndTranslation(aWidth, aHeight: Integer; Var ST: cairo_rectangle_t): Boolean;
  Var
    lt: cairo_rectangle_t;
    lx, ly: double;
    lfx, lfy: double;
  begin
    result := false;
    lt := ST;
    lx := Abs(ST.width - ST.X);
    ly := Abs(ST.height - ST.Y);

    lx := Abs(ST.width);
    ly := Abs(ST.height);

    lfx := aWidth / lx;
    lfy := aHeight / ly;

    if lfx < lfy then
      lfy := lfx
    else
      lfx := lfy;

    lt.width := lfx;
    lt.height := lfy;
    lt.Y := -(ST.Y);
    lt.X := -(ST.X);

    ST := lt;
    result := true;

  end;

begin
  // PaintCanvas(PaintBoxLeft.Canvas, 0);
  if fMetaSurface <> nil then
    if fMetaSurface.status = CAIRO_STATUS_SUCCESS then
      if supports(fMetaSurface, iCairoRecordingSurface, ftemp) then
      begin
        ftemp.ink_extents(lScaleTrans.X, lScaleTrans.Y, lScaleTrans.width, lScaleTrans.height);
        if (lScaleTrans.width * lScaleTrans.height) > 0 then
        begin
          Label2.Caption := format('X: %5.1f Y: %5.1f W: %5.1f H: %5.1f', [lScaleTrans.X, lScaleTrans.Y, lScaleTrans.width, lScaleTrans.height]);

          lw := lScaleTrans.width;
          lh := lScaleTrans.height;
          fTarget := CairoFactory.CreateGdi(PaintBox5.Canvas.Handle);
          fCairo := CairoFactory.CreateContext(fTarget);
          // fCairo.translate(Border div 2, Border div 2);

          getScaleAndTranslation(PaintBox5.width - Border, PaintBox5.height - Border, lScaleTrans);

          // Nullpunkt Mitte Screen
          fCairo.translate(PaintBox5.width / 2, PaintBox5.height / 2);
          // fcairo.scale(lScale, lScale);
          // Skaliere
          fCairo.scale(lScaleTrans.width * lScale, lScaleTrans.height * lScale);
          // Verschiebe Nullpunkt
          fCairo.translate(lScaleTrans.X, lScaleTrans.Y);
          // und Noch mal
          fCairo.translate(-lw / 2, -lh / 2);
          fCairo.get_matrix(@lmatrix);
          fActualViewMatrix.initWithMatrix(lmatrix);
          fActualInverseViewMatrix := fActualViewMatrix;
          fActualInverseViewMatrix.invert;

          // fCairo.translate(-0, -50);

          fCairo.set_source_surface(ftemp, 0, 0);
          fCairo.paint;

          {$IFDEF DOOUT }
          fTarget := tCaImageSurface.Create(CAIRO_FORMAT_ARGB32, PaintBox5.width, PaintBox5.height);
          fCairo := CairoFactory.CreateContext(fTarget);
          fCairo.set_matrix(@lmatrix);
          fCairo.setcolor(clWhite);
          fCairo.paint;

          fCairo.set_source_surface(ftemp, 0, 0);
          fCairo.paint;

          (fTarget as tCaImageSurface).write_to_png('D:\Test\Cairo.png');
          {$ENDIF}

        end;
      end;

end;

procedure TForm16.PaintBoxFreetypePaint(Sender: TObject);
var
  lCanvas: ICairoContext;
  lSurface: ICairoSurface;
  lftm: TFtFontmanager;
  lCount: Integer;
begin
  lSurface := CairoFactory.createGDI_with_format(PaintBoxFreetype.Canvas.Handle, CAIRO_FORMAT_ARGB32);
  try
    lCanvas := CairoFactory.CreateContext(lSurface);
    try
      PaintFreeType(lCanvas);
    finally
      lSurface.flush;
      lCanvas := nil;
    end;
  finally
    lSurface := nil;
  end;
end;

end.
