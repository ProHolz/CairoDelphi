unit Cairo.Canvas;

interface

{$IFDEF DEBUG}
{$HINTS ON}
{$ENDIF}

uses
  Winapi.Windows,
  System.Sysutils,
  System.Types,
  System.UITypes,
  System.Classes,
  Vcl.Graphics,
  Cairo.Types,
  Cairo.Interfaces,
  Cairo.Base,
  Cairo.Font;


type
  TCairoCanvasType = (cctGDI, cctPDF);

  TCairoPdfSize = (A4, A3, A2, A1, A0);

  TPathStates = (cpsMovepos);
  TPathState = set of TPathStates;

  TCairoGraphicsObject = class(TInterfacedPersistent)
  private
    FOnChange: TNotifyEvent;
    FOwnerLock: PRTLCriticalSection;

  protected
    procedure Changed; virtual;
    procedure Lock;
    procedure Unlock;

  public
    property OwnerCriticalSection: PRTLCriticalSection read FOwnerLock write FOwnerLock;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TCairoPen = class(TCairoGraphicsObject)
  private

    FMode: TPenMode;
    FStyle: TPenStyle;
    FWidth: Integer;
    FColor: TColor;
    fAlpha: single;
    function GetMode: TPenMode;

  protected // Cairo

    procedure SetToCairo(Cairo: ICairoContext);

  protected
    function GetColor: TColor; inline;
    procedure SetColor(const Value: TColor);
    procedure SetMode(const Value: TPenMode);
    function GetStyle: TPenStyle;
    procedure SetStyle(const Value: TPenStyle);
    function GetWidth: Integer; inline;
    procedure SetWidth(const Value: Integer);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    // published
    property Color: TColor read GetColor write SetColor default clBlack;
    property Mode: TPenMode read FMode write SetMode default pmCopy;
    property Style: TPenStyle read GetStyle write SetStyle;
    property Width: Integer read GetWidth write SetWidth default 1;
    property Alpha: single read fAlpha write fAlpha;
  end;

  TCairoFontGdi = class(TCairoGraphicsObject)
  private
    FFont: TFont;
    fCairoFont: ICairoFont;
    function GetColor: TColor;
    function GetName: string;
    function GetSize: Integer;
    procedure SetColor(const Value: TColor);
    procedure SetHeight(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetSize(const Value: Integer);
    function getHeight: Integer;
    function getFont: TFont;
    procedure setFont(const Value: TFont);

  protected // Cairo

    procedure SetToCairo(Cairo: ICairoContext);
    // procedure Test; virtual; abstract;

  public
    constructor Create;
    destructor Destroy; override;


    function AdjustYpos: Integer;

    property Color: TColor read GetColor write SetColor default clBlack;
    property name: string read GetName write SetName;
    property Height: Integer read getHeight write SetHeight;
    property Font: TFont read getFont write setFont;

    property CairoFont: ICairoFont read fCairoFont;

  end;

  TCairoBrush = class(TCairoGraphicsObject)
  private
    FStyle: TBrushStyle;
    FColor: TColor;

    function GetColor: TColor;
    function GetStyle: TBrushStyle;
    procedure SetColor(const Value: TColor);
    procedure SetStyle(const Value: TBrushStyle);

  protected
    procedure SetToCairo(Cairo: ICairoContext);

  public
    property Color: TColor read GetColor write SetColor;
    property Style: TBrushStyle read GetStyle write SetStyle;

  end;

  TCairoAliasing = ( //
    caDefault, // CAIRO_ANTIALIAS_DEFAULT = 0,
    caNone, // CAIRO_ANTIALIAS_NONE = 1,
    caGray, // CAIRO_ANTIALIAS_GRAY = 2,
    caSubpixel, // CAIRO_ANTIALIAS_SUBPIXEL = 3,
    caFast, // CAIRO_ANTIALIAS_FAST = 4,
    caGood, // CAIRO_ANTIALIAS_GOOD = 5,
    caBest); // CAIRO_ANTIALIAS_BEST = 6);

  TCairoCanvas = class(TCanvas)
  private type
    TPointD = record
      x, y: double;
    end;

    // From Custom Canvas
  var
    FLock: TRTLCriticalSection;
    FLockCount: Integer;
    FTextFlags: Longint;
    FHandle: HDC;
    State: TCanvasState;
    // Cairo
    Cairo: ICairoContext;
    Surface: ICairoSurface;
    FPenPos: TPointD;
    fPathState: TPathState;
    fAliasing: TCairoAliasing;
    fCanvasType: TCairoCanvasType;
    fPdfSize: TCairoPdfSize;
    fFilename: string;

    fBrush: TCairoBrush;
    fPen: TCairoPen;
    FFont: TCairoFontGdi;


    procedure CreateBrush;
    procedure CreateFont;
    procedure CreatePen;
    procedure BrushChanged(ABrush: TObject);
    procedure DeselectHandles;
    procedure FontChanged(AFont: TObject);
    procedure PenChanged(APen: TObject);

    procedure SetColor(const aColor: TColor);

  private
    // Internals
    function _POS(Value: Integer): double; inline;
    procedure RequiredPathState(ReqState: TPathState);
    procedure SetAliasingMode;
    procedure setAliasing(const Value: TCairoAliasing);

    procedure FillAndStrokePenBrush();

    procedure FillAndStroke(doLine: boolean = true; doFill: boolean = false; fAlpha: single = 1.0);
    procedure FillSolid(fAlpha: single);
    procedure Fill(preserve: boolean = false);
    procedure Stroke(preserve: boolean = false);

  protected
    function GetCanvasOrientation: TCanvasOrientation; override;
    function GetClipRect: TRect; override;

    function GetPixel(x, y: Integer): TColor; override;
    function GetHandle: HDC;
    procedure SetHandle(Value: HDC);
    procedure SetPixel(x, y: Integer; Value: TColor); override;
    procedure CreateHandle; override;
    procedure RequiredState(ReqState: TCanvasState); override;

    // Obsolete in Cairo
    function GetPenPos: TPoint; override;
    procedure SetPenPos(Value: TPoint); override;

    // New in Cairo
    procedure MoveToF(x, y: single);
    procedure LineTof(x, y: single);
    procedure CurveToC(X1, Y1, X2, Y2, X3, Y3: single);

  public
    constructor Create;
    constructor CreateGdi(aHDC: HDC);

    constructor CreatePdf(const aFilename: string; aSize: TCairoPdfSize);

    destructor Destroy; override;

    // Move and Position
    procedure MoveTo(x, y: Integer); overload; override;
    procedure MoveTo(x, y: double); reintroduce; overload;

    // Arcs
    procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); override;
    procedure ArcTo(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); override;
    procedure AngleArc(x, y: Integer; Radius: Cardinal; StartAngle, SweepAngle: single); override;
    procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); override;
    procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); override;
    procedure Ellipse(X1, Y1, X2, Y2: Integer); overload; override;
    procedure Ellipse(X1, Y1, X2, Y2: double; doStroke: boolean); overload;

    // Lines
    procedure LineTo(x, y: Integer); overload; override;
    procedure LineTo(x, y: Integer; const doStroke: boolean); reintroduce; overload;
    procedure LineTo(x, y: double; const doStroke: boolean); reintroduce; overload;

    procedure Polyline(const Points: array of TPoint); override;

    // Rectangles and Polygon
    procedure DrawFocusRect(const Rect: TRect); override;
    procedure FillRect(const Rect: TRect); override;
    procedure FloodFill(x, y: Integer; Color: TColor; FillStyle: TFillStyle); override;
    procedure FrameRect(const Rect: TRect); override;
    procedure Rectangle(X1, Y1, X2, Y2: Integer); override;
    procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer); override;
    procedure Polygon(const Points: array of TPoint); override;

    // Rectangles and Polygon Floats
    procedure Rectanglef(X1, Y1, X2, Y2: double);

    // Bezier
    procedure PolyBezier(const Points: array of TPoint); override;
    procedure PolyBezierTo(const Points: array of TPoint); override;

    // Graphics
    procedure StretchDraw(const Rect: TRect; Graphic: TGraphic); override;
    procedure Draw(x, y: Integer; Graphic: TGraphic); overload; override;
    procedure Draw(x, y: Integer; Graphic: TGraphic; Opacity: Byte); overload; override;

    // Texts
    function TextExtent(const Text: string): TSize; override;

    procedure TextOut(x, y: Integer; const Text: string); override;
    procedure TextRect(var Rect: TRect; var Text: string; TextFormat: TTextFormat = []); overload; override;
    procedure TextRect(Rect: TRect; x, y: Integer; const Text: string); overload; override;

    // not Implemented
    procedure BrushCopy(const Dest: TRect; Bitmap: TBitmap; const Source: TRect; Color: TColor); override;
    procedure CopyRect(const Dest: TRect; Canvas: TCairoCanvas; const Source: TRect);

    // State
    function HandleAllocated: boolean;
    procedure Refresh; override;
    property Handle: HDC read GetHandle write SetHandle;

  public // Cairo only
    procedure flush;
    procedure TextOutf(x, y, d, H: double; const Text: string);
    procedure PNGDraw(const aDestRect: TRect; aRotation: double; const Data: TBytes);
    procedure Save;
    procedure Restore;

    property Aliasing: TCairoAliasing read fAliasing write setAliasing;

  published
  end;

implementation

uses
  System.Math,
  System.ConvUtils,
  System.StdConvs,
  Cairo.Stream;


const
  csAllValid = [csHandleValid .. csBrushValid];

  { TCairoCanvas }

constructor TCairoCanvas.Create;
begin
  inherited Create;
  fCanvasType := cctGDI;
  InitializeCriticalSection(FLock);
  FFont := TCairoFontGdi.Create;
  FFont.name := 'Arial';
  FFont.Color := clBlack;
  FFont.SetSize(14);
  FFont.OwnerCriticalSection := @FLock;
  fPen := TCairoPen.Create;
  fPen.OwnerCriticalSection := @FLock;
  fBrush := TCairoBrush.Create;
  fBrush.OwnerCriticalSection := @FLock;

  Brush.OnChange := BrushChanged;
  Pen.OnChange := PenChanged;
  Font.OnChange := FontChanged;

  State := [];
end;

destructor TCairoCanvas.Destroy;
begin
  SetHandle(0);
  FFont.Free;
  fPen.Free;
  fBrush.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TCairoCanvas.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid, csBrushValid]);
  Cairo.ArcDraw(acArc, X1, Y1, X2 - 1, Y2 - 1, X3, Y3, X4, Y4);
  FillAndStroke;
  Changed;
end;

procedure TCairoCanvas.ArcTo(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid, csBrushValid]);
  Cairo.ArcDraw(acArcTo, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  FillAndStroke;
  Changed;
end;

procedure TCairoCanvas.AngleArc(x, y: Integer; Radius: Cardinal; StartAngle, SweepAngle: single);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid, csBrushValid]);
  Cairo.move_to(FPenPos.x, FPenPos.y);
  Cairo.arc_negative(_POS(x), _POS(y), Radius, degtoRad(-StartAngle), degtoRad(-(StartAngle + SweepAngle)));
  FillAndStroke;
  Changed;
end;

procedure TCairoCanvas.BrushCopy(const Dest: TRect; Bitmap: TBitmap; const Source: TRect; Color: TColor);

begin
  // Not Implemented
end;

procedure TCairoCanvas.Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid, csBrushValid]);
  Cairo.ArcDraw(acChoord, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  FillAndStrokePenBrush;
  Changed;
end;

procedure TCairoCanvas.CopyRect(const Dest: TRect; Canvas: TCairoCanvas; const Source: TRect);
begin
  // Changing;
  // RequiredState([csHandleValid, csFontValid, csBrushValid]);
  // Canvas.RequiredState([csHandleValid, csBrushValid]);
  // StretchBlt(FHandle, Dest.Left, Dest.Top, Dest.Right - Dest.Left, Dest.Bottom - Dest.Top, Canvas.FHandle, Source.Left, Source.Top, Source.Right - Source.Left,
  // Source.Bottom - Source.Top, CopyMode);
  // Changed;
end;

procedure TCairoCanvas.Draw(x, y: Integer; Graphic: TGraphic);
begin
  // if (Graphic <> nil) and not Graphic.Empty then
  // begin
  // Changing;
  // RequiredState([csHandleValid]);
  // SetBkColor(FHandle, ColorToRGB(FBrush.GetColor));
  // SetTextColor(FHandle, ColorToRGB(FFont.Color));
  // // Graphic.Draw(Self, Rect(X, Y, X + Graphic.Width, Y + Graphic.Height));
  // // Not implemented
  // Changed;
  // end;
end;

procedure TCairoCanvas.Draw(x, y: Integer; Graphic: TGraphic; Opacity: Byte);
begin
  // if (Graphic <> nil) and not Graphic.Empty then
  // begin
  // Changing;
  // RequiredState([csHandleValid]);
  // SetBkColor(FHandle, ColorToRGB(FBrush.GetColor));
  // SetTextColor(FHandle, ColorToRGB(FFont.Color));
  // // Graphic.DrawTransparent(Self, Rect(X, Y, X + Graphic.Width, Y + Graphic.Height), Opacity);
  // // Not implemented
  // Changed;
  // end;
end;

procedure TCairoCanvas.FillAndStroke(doLine: boolean = true; doFill: boolean = false; fAlpha: single = 1.0);
begin
  if doFill then
  begin
    // SetColor(fBrush.getColor);
    fBrush.SetToCairo(Cairo);
    if doLine then
      Cairo.fill_preserve
    else
      Cairo.Fill;
  end;
  if doLine then
  begin
    fPen.SetToCairo(Cairo);
    Cairo.Stroke;
  end;

end;

procedure TCairoCanvas.FillSolid(fAlpha: single);
var
  ta: TColorRec;
begin
  ta := TColorRec(ColorToRGB(fBrush.GetColor));
  Cairo.set_source_rgba(ta.r / 255, ta.g / 255, ta.b / 255, fAlpha);
  Cairo.Fill;
end;

procedure TCairoCanvas.DrawFocusRect(const Rect: TRect);
var
  p: TCairoPen;
begin
  Changing;
  RequiredState([csHandleValid, csPenValid]);
  p := TCairoPen.Create;
  p.Assign(fPen);
  p.Width := 1;
  p.Style := Vcl.Graphics.psDot;
  Cairo.Rectangle(Rect.Left + 0.5, Rect.Top + 0.5, Rect.Width, Rect.Height);
  p.SetToCairo(Cairo);
  Cairo.Stroke;
  Changed;
end;

procedure TCairoCanvas.Ellipse(X1, Y1, X2, Y2: Integer);
begin
  Ellipse(_POS(X1), _POS(Y1), _POS(X2 - 1), _POS(Y2 - 1), true);
end;

procedure TCairoCanvas.FillRect(const Rect: TRect);
begin
  Changing;
  RequiredState([csHandleValid, csBrushValid]);
  Cairo.Rectangle(Rect.Left + 0.5, Rect.Top + 0.5, Rect.Width - 1, Rect.Height - 1);
  FillAndStroke(false, true);
  Changed;
end;

procedure TCairoCanvas.FloodFill(x, y: Integer; Color: TColor; FillStyle: TFillStyle);
const
  FillStyles: array [TFillStyle] of Word = (FLOODFILLSURFACE, FLOODFILLBORDER);
begin
  // Not implemented
  // Changing;
  // RequiredState([csHandleValid, csBrushValid]);
  // // Winapi.Windows.ExtFloodFill(FHandle, x, y, Color, FillStyles[FillStyle]);
  // Changed;
end;

procedure TCairoCanvas.FrameRect(const Rect: TRect);
var
  p: TCairoPen;

begin
  Changing;
  RequiredState([csHandleValid, csBrushValid]);
  p := TCairoPen.Create;
  p.Assign(fPen);
  p.Width := 1;
  p.Style := Vcl.Graphics.psSolid;
  p.Color := fBrush.GetColor;
  p.SetToCairo(Cairo);
  Cairo.Rectangle(Rect.Left + 0.5, Rect.Top + 0.5, Rect.Width, Rect.Height);
  Cairo.Stroke;
  Changed;
end;

function TCairoCanvas.HandleAllocated: boolean;
begin
  Result := FHandle <> 0;
end;

procedure TCairoCanvas.LineTo(x, y: Integer; const doStroke: boolean);
begin
  LineTo(_POS(x), _POS(y), doStroke);
end;

procedure TCairoCanvas.MoveTo(x, y: Integer);
begin
  RequiredState([csHandleValid]);
  MoveTo(_POS(x), _POS(y));
end;

procedure TCairoCanvas.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid, csBrushValid]);
  Cairo.ArcDraw(acPie, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  FillAndStrokePenBrush;
  Changed;
end;

type
  PPoints = ^TPoints;
  TPoints = array [0 .. 0] of TPoint;

procedure TCairoCanvas.Polygon(const Points: array of TPoint);
var
  lp: TPoint;
  loop: Integer;
  fSavePenpos: TPointD;
begin
  if length(Points) > 1 then
  begin
    Changing;
    fSavePenpos := FPenPos;
    RequiredState([csHandleValid, csPenValid, csBrushValid]);
    lp := Points[0];
    MoveTo(lp.x, lp.y);
    loop := 0;
    for lp in Points do
    begin
      if loop > 0 then
      begin
        LineTo(lp.x, lp.y, false);
      end;
      inc(loop);
    end;
    Cairo.close_path;
    FillAndStrokePenBrush;
    exclude(fPathState, cpsMovepos);
    FPenPos := fSavePenpos;
    Changed;
  end;
end;

procedure TCairoCanvas.Polyline(const Points: array of TPoint);
var
  lp: TPoint;
  fSavePenpos: TPointD;
  i: Integer;
begin
  if length(Points) > 1 then
  begin
    Changing;
    fSavePenpos := FPenPos;
    RequiredState([csHandleValid, csPenValid, csBrushValid]);
    lp := Points[0];
    Cairo.move_to(lp.x + 0.5, lp.y + 0.5);
    for i := 1 to high(Points) do
    begin
      lp := Points[i];
      Cairo.line_to(lp.x + 0.5, lp.y + 0.5);
    end;
    FillAndStroke;
    exclude(fPathState, cpsMovepos);
    FPenPos := fSavePenpos;
    Changed;
  end;
end;

procedure TCairoCanvas.PolyBezier(const Points: array of TPoint);
begin
  if length(Points) > 3 then
  begin
    Changing;
    RequiredState([csHandleValid, csPenValid]);
    Cairo.move_to(Points[0].x, Points[0].y);
    Cairo.curve_to(Points[1].x, Points[1].y, Points[2].x, Points[2].y, Points[3].x, Points[3].y);
    fPen.SetToCairo(Cairo);
    stroke;
    Changed;
  end;
end;

procedure TCairoCanvas.PolyBezierTo(const Points: array of TPoint);
begin
  if length(Points) > 2 then
  begin
    Changing;
    RequiredState([csHandleValid, csPenValid]);
    Cairo.curve_to(Points[0].x, Points[0].y, Points[1].x, Points[1].y, Points[2].x, Points[2].y);
    fPen.SetToCairo(Cairo);
    stroke;
    Changed;
  end;
end;

procedure TCairoCanvas.Rectangle(X1, Y1, X2, Y2: Integer);
begin
  Rectanglef(_POS(X1), _POS(Y1), (X2 - X1) - 1, (Y2 - Y1) - 1);
end;

procedure TCairoCanvas.Refresh;
begin
  DeselectHandles;
end;

procedure TCairoCanvas.RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);

  procedure RoundRectD(X1, Y1, X2, Y2, cx, cy: double);
  const
    // see http://paste.lisp.org/display/1105
    BEZIER: single = 0.55228477716; // = 4/3 * (sqrt(2) - 1);

  begin
    cx := cx / 2;
    cy := cy / 2;
    Cairo.move_to(X1 + cx, Y1);
    Cairo.line_to(X2 - cx, Y1);
    Cairo.curve_to(X2 - cx + BEZIER * cx, Y1, X2, Y1 + cy - BEZIER * cy, X2, Y1 + cy);
    Cairo.line_to(X2, Y2 - cy);
    Cairo.curve_to(X2, Y2 - cy + BEZIER * cy, X2 - cx + BEZIER * cx, Y2, X2 - cx, Y2);
    Cairo.line_to(X1 + cx, Y2);
    Cairo.curve_to(X1 + cx - BEZIER * cx, Y2, X1, Y2 - cy + BEZIER * cy, X1, Y2 - cy);
    Cairo.line_to(X1, Y1 + cy);
    Cairo.curve_to(X1, Y1 + cy - BEZIER * cy, X1 + cx - BEZIER * cx, Y1, X1 + cx, Y1);

  end;

// var
// c: TColor;
// i: Integer;

begin
  Changing;
  RequiredState([csHandleValid, csBrushValid, csPenValid]);
  // c := Brush.Color;
  // Brush.Color := clsilver;
  /// / RoundrectD(x1+10.5, y1+10.5, x2+10.5, y2+10.5, Y3, Y3);
  // cairo_save(fcr);
  // RoundRectD(X1 + 0.5, Y1 + 0.5, X2 + 0.5, Y2 + 0.5, Y3, Y3);
  //
  // for i := 1 to 5 do
  // begin
  // cairo_translate(fcr, 1, 1);
  // RoundRectD(X1 + 0.5, Y1 + 0.5, X2 + 0.5, Y2 + 0.5, Y3, Y3);
  // FillSolid(1 - (0.2 * i));
  // end;
  //
  // cairo_restore(fcr);
  //
  // Brush.Color := c;
  //
  // fpen.SetToCairo(fcr);
  fPen.Alpha := 1.0;
  RoundRectD(X1 + 0.5, Y1 + 0.5, X2 + 0.5, Y2 + 0.5, Y3, Y3);
  FillAndStroke(true, true);
  Changed;
end;

procedure TCairoCanvas.StretchDraw(const Rect: TRect; Graphic: TGraphic);
begin
  if Graphic <> nil then
  begin
    Changing;
    RequiredState(csAllValid);
    Changed;
  end;
end;

function TCairoCanvas.GetCanvasOrientation: TCanvasOrientation;
// var    Point: TPoint;
begin
  Result := coLeftToRight;
  // if (FTextFlags and ETO_RTLREADING) <> 0 then
  // begin
  // GetWindowOrgEx(Handle, Point);
  // if Point.x <> 0 then
  // Result := coRightToLeft
  // end;
end;

procedure TCairoCanvas.TextOut(x, y: Integer; const Text: string);

// procedure DrawLine(aH: Single);
//  var
//    tmp: TEmfEnumStatePen;
//  begin
//    tmp := State.Pen;
//    State.Pen.color := State.Font.color;
//    State.Pen.Width := ASize / 15;
//    State.Pen.style := PS_SOLID;
//    State.Pen.null := False;
//    SetPen;
//    MoveToI(-State.Pen.Width, -H + aH);
//    LineToI(AWidth + 2 * State.Pen.Width, -H + aH);
//
//    fContext.Stroke;
//    State.Pen := tmp;
//    SetPen;
//  end;

begin
  Changing;
  RequiredState([csHandleValid, csFontValid, csBrushValid]);
  // if CanvasOrientation = coRightToLeft then
  // inc(x, TextWidth(Text) + 1);
  // Winapi.Windows.ExtTextOut(FHandle, x, y, FTextFlags, nil, Text, length(Text), nil);

  FFont.SetToCairo(Cairo);
  // Cairo.
  Cairo.move_to(x, y + FFont.AdjustYpos);
  Cairo.text_path(Text);
  Cairo.Fill;


  MoveTo(x + TextWidth(Text), y);
  Changed;
end;

procedure TCairoCanvas.TextRect(Rect: TRect; x, y: Integer; const Text: string);
var
  Options: Longint;
begin
  Changing;
  RequiredState([csHandleValid, csFontValid, csBrushValid]);
  Options := ETO_CLIPPED or FTextFlags;
  if fBrush.GetStyle <> bsClear then
    Options := Options or ETO_OPAQUE;
  if ((FTextFlags and ETO_RTLREADING) <> 0) and (CanvasOrientation = coRightToLeft) then
    inc(x, TextWidth(Text) + 1);
  // Winapi.Windows.ExtTextOut(FHandle, x, y, Options, Rect, Text, length(Text), nil);
  Changed;
end;

procedure TCairoCanvas.TextRect(var Rect: TRect; var Text: string; TextFormat: TTextFormat = []);
// var     Format: TDrawTextFlags;
begin
  // if tfComposited in TextFormat then
  // raise InvalidOperation.CreateResFmt({$IFNDEF CLR}@{$ENDIF}SInvalidTextFormatFlag,
  // [GetEnumName(TypeInfo(TTextFormats), Integer(tfComposited))]);
  // Format := TTextFormatFlags(TextFormat);
  // DrawTextEx(Handle, PChar(Text), length(Text), Rect, Format, nil);
  // if tfModifyString in TextFormat then
  // SetLength(Text, StrLen(PChar(Text)));
end;

function TCairoCanvas.TextExtent(const Text: string): TSize;
Var ext: cairo_text_extents_t;
  fext: cairo_font_extents_t;

begin
  RequiredState([csHandleValid, csFontValid]);
  ext := FFont.CairoFont.text_extents(Text);
  fext := FFont.CairoFont.extents;
  // result.cy := Round(ext.height+fext.descent);
  Result.cy := Round(fext.ascent + fext.descent);
  Result.cx := Round(ext.Width);

end;

function TCairoCanvas.GetPenPos: TPoint;
begin
  // Cairo.
end;

procedure TCairoCanvas.SetPenPos(Value: TPoint);
begin
end;

function TCairoCanvas.GetPixel(x, y: Integer): TColor;
begin
  RequiredState([csHandleValid]);
  Result := clWhite;
end;

procedure TCairoCanvas.SetPixel(x, y: Integer; Value: TColor);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid]);
  Changed;
end;

function TCairoCanvas.GetClipRect: TRect;
begin
  RequiredState([csHandleValid]);
  Result := TRect.Empty;
end;

function TCairoCanvas.GetHandle: HDC;
begin
  Result := FHandle;
end;

procedure TCairoCanvas.DeselectHandles;
begin
  if (FHandle <> 0) and (State - [csPenValid, csBrushValid, csFontValid] <> State) then
  begin
    // SelectObject(FHandle, StockPen);
    // SelectObject(FHandle, StockBrush);
    // SelectObject(FHandle, StockFont);
    State := State - [csPenValid, csBrushValid, csFontValid];
  end;

  // not implemented
end;

procedure TCairoCanvas.CreateHandle;

const
  bly: array [TCairoPdfSize] of double = (2100, 2970, 4200, 5940, 8400);
  blx: array [TCairoPdfSize] of double = (2970, 4200, 5940, 8400, 11880);
var
  Sizex: double;
  SizeY: double;
begin
  if not(csHandleValid in State) then
  begin
    Sizex := convert(blx[fPdfSize] / 10, duMillimeters, duInches) * 72;
    SizeY := convert(bly[fPdfSize] / 10, duMillimeters, duInches) * 72;

    Surface := CairoFactory.CreateGdi(FHandle);
    Cairo := CairoFactory.CreateContext(Surface);
    include(State, csHandleValid);

    // cairo_destroy(fcr);
    // cairo_surface_destroy(fsurface);
    // exclude(State, csHandleValid);
    // end;
    //
    // case fCanvasType of
    // cctGDI: fsurface := cairo_win32_surface_create(FHandle);
    // cctPDF: fsurface := cairo_PDF_surface_create(Pansichar(UTF8String(fFilename)), Sizex, SizeY);
    // end;
    //
    // fcr := cairo_create(fsurface);
    // cairo_set_operator(fcr, cairo_operator_t.CAIRO_OPERATOR_OVER);
    //
    // SetAliasingMode;
    //
    // include(State, csHandleValid);
    // if fCanvasType = cctPDF then
    // begin
    // // cairo_scale(fcr, (blx[fPdfSize] / Sizex),  (bly[fPdfSize] / Sizey));
    // cairo_scale(fcr, (Sizex / blx[fPdfSize]), (SizeY / bly[fPdfSize]));
    // end;

  end;
end;

procedure TCairoCanvas.SetHandle(Value: HDC);
begin
  if Value = 0 then
    if csHandleValid in State then
    begin
      Surface.flush;
      Surface := nil;
      Cairo := nil;
      exclude(State, csHandleValid);
    end;
  //
  // if FHandle <> Value then
  // begin
  // if FHandle <> 0 then
  // begin
  // DeselectHandles;
  // FHandle := 0;
  // if csHandleValid in State then
  // begin
  // cairo_destroy(fcr);
  // cairo_surface_destroy(fsurface);
  // end;
  // exclude(State, csHandleValid);
  // end;
  // if Value <> 0 then
  // begin
  // include(State, csHandleValid);
  // FHandle := Value;
  // end;
  // end;
end;

procedure TCairoCanvas.RequiredState(ReqState: TCanvasState);
var
  NeededState: TCanvasState;
begin
  NeededState := ReqState - State;
  if NeededState <> [] then
  begin
    if csHandleValid in NeededState then
    begin
      CreateHandle;
      if Cairo = nil then
        raise Exception.Create('No Handle');
    end;
    if csFontValid in NeededState then
      CreateFont;
    if csPenValid in NeededState then
      CreatePen;
    if csBrushValid in NeededState then
      CreateBrush;
    State := State + NeededState;
  end;
end;

procedure TCairoCanvas.CreateFont;
begin
  FFont.Font := Font;
end;

procedure TCairoCanvas.CreatePen;
begin
  fPen.SetColor(Pen.Color);
  fPen.SetWidth(Pen.Width);
  fPen.SetStyle(Pen.Style);
end;

procedure TCairoCanvas.CreateBrush;
begin
  fBrush.SetColor(Brush.Color);
  fBrush.Style := Brush.Style;
end;

procedure TCairoCanvas.FontChanged(AFont: TObject);
begin
  if csFontValid in State then
  begin
    exclude(State, csFontValid);
  end;
end;

procedure TCairoCanvas.PenChanged(APen: TObject);
Var lPen: Tpen;
begin

  if csPenValid in State then
  begin
    exclude(State, csPenValid);
  end;

end;

procedure TCairoCanvas.BrushChanged(ABrush: TObject);
begin
  if csBrushValid in State then
  begin
    exclude(State, csBrushValid);
  end;
end;

constructor TCairoCanvas.CreateGdi(aHDC: HDC);
begin
  Create;
  fCanvasType := cctGDI;
  FHandle := aHDC;
end;

constructor TCairoPen.Create;
begin
  inherited Create;
  FMode := pmCopy;
  FWidth := 1;
  FColor := clBlack;
  FStyle := Vcl.Graphics.psSolid;
  fAlpha := 1.0;
end;

destructor TCairoPen.Destroy;
begin
  inherited;
end;

procedure TCairoPen.Assign(Source: TPersistent);
begin
  if Source is TCairoPen then
  begin
    Lock;
    try
      TCairoPen(Source).Lock;
      try
        // PenManager.AssignResource(Self, TCairoPen(Source).FResource);
        SetMode(TCairoPen(Source).FMode);
        fAlpha := 1.0;
      finally
        TCairoPen(Source).Unlock;
      end;
    finally
      Unlock;
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

function TCairoPen.GetColor: TColor;
begin
  Result := FColor;
end;

procedure TCairoPen.SetColor(const Value: TColor);
begin
  if Value <> FColor then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TCairoPen.SetMode(const Value: TPenMode);
begin
  if FMode <> Value then
  begin
    FMode := Value;
    Changed;
  end;
end;

function TCairoPen.GetStyle: TPenStyle;
begin
  Result := FStyle;
end;

procedure TCairoPen.SetStyle(const Value: TPenStyle);
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    Changed;
  end;
end;

function TCairoPen.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TCairoPen.SetWidth(const Value: Integer);
begin
  if (Value >= 0) and (Value <> FWidth) then
  begin
    FWidth := Value;
    Changed;
  end;
end;

function TCairoCanvas._POS(Value: Integer): double;
begin
  Result := (Value + 0.5);
end;

procedure TCairoCanvas.RequiredPathState(ReqState: TPathState);
var
  NeededState: TPathState;
begin
  NeededState := ReqState - fPathState;
  if NeededState <> [] then
  begin
    if cpsMovepos in NeededState then
      Cairo.move_to(FPenPos.x, FPenPos.y);
    fPathState := fPathState + NeededState;
  end;
end;

procedure TCairoCanvas.LineTo(x, y: Integer);
begin
  LineTo(x, y, true);
end;

procedure TCairoCanvas.SetAliasingMode;
begin
  case fAliasing of
    caDefault: Cairo.antialias := CAIRO_ANTIALIAS_DEFAULT;
    caNone: Cairo.antialias := CAIRO_ANTIALIAS_NONE;
    caGray: Cairo.antialias := CAIRO_ANTIALIAS_GRAY;
    caSubpixel: Cairo.antialias := CAIRO_ANTIALIAS_SUBPIXEL;
    caFast: Cairo.antialias := CAIRO_ANTIALIAS_FAST;
    caGood: Cairo.antialias := CAIRO_ANTIALIAS_GOOD;
    caBest: Cairo.antialias := CAIRO_ANTIALIAS_BEST;
  else raise Exception.Create('Falscher Mode in Antialiasing');
  end;
end;

procedure TCairoCanvas.setAliasing(const Value: TCairoAliasing);
begin
  if fAliasing <> Value then
  begin
    RequiredState([csHandleValid]);
    fAliasing := Value;
    SetAliasingMode;
    // exclude(state, csHandleValid);
  end;
end;

procedure TCairoCanvas.MoveToF(x, y: single);
begin
  Cairo.move_to(x, y);
end;

procedure TCairoCanvas.LineTof(x, y: single);
begin
  Cairo.line_to(x, y);
end;

procedure TCairoCanvas.CurveToC(X1, Y1, X2, Y2, X3, Y3: single);
begin
  Cairo.curve_to(X1, Y1, X2, Y2, X3, Y3);
end;

procedure TCairoCanvas.Rectanglef(X1, Y1, X2, Y2: double);
begin
  Changing;
  RequiredState([csHandleValid, csBrushValid, csPenValid]);
  Cairo.Rectangle(X1, Y1, X2, Y2);
  FillAndStrokePenBrush;
  Changed;
end;

procedure TCairoCanvas.MoveTo(x, y: double);
begin
  RequiredState([csHandleValid]);
  FPenPos.x := x;
  FPenPos.y := y;
  Cairo.move_to(FPenPos.x, FPenPos.y);
  include(fPathState, cpsMovepos);
end;

procedure TCairoCanvas.LineTo(x, y: double; const doStroke: boolean);
begin
  Changing;
  RequiredState([csHandleValid, csPenValid]);
  RequiredPathState([cpsMovepos]);
  FPenPos.x := x;
  FPenPos.y := y;
  Cairo.line_to(FPenPos.x, FPenPos.y);
  if doStroke then
  begin
    FillAndStroke;
    exclude(fPathState, cpsMovepos);
  end;
  Changed;
end;

procedure TCairoCanvas.Ellipse(X1, Y1, X2, Y2: double; doStroke: boolean);
Var px, py: double;
begin
  Changing;
  RequiredState([csHandleValid, csPenValid, csBrushValid]);
  Cairo.ArcDraw(acArc, X1, Y1, X2, Y2, X2, Y2, X2, Y2, px, py);
  if doStroke then
    FillAndStrokePenBrush;
  Changed;
end;

procedure TCairoCanvas.flush;
begin
  if assigned(Surface) then
    Surface.flush;
end;

constructor TCairoCanvas.CreatePdf(const aFilename: string; aSize: TCairoPdfSize);
begin
  Create;
  fCanvasType := cctPDF;
  fPdfSize := aSize;
  FHandle := 0;
  fFilename := aFilename;
  CreateHandle;
end;

procedure TCairoCanvas.TextOutf(x, y, d, H: double; const Text: string);
begin
  Changing;
  Cairo.Save;
  RequiredState([csFontValid]);
  FFont.SetToCairo(Cairo);

  Cairo.set_font_size(H * 96 / 72);
  Cairo.translate(x, y);
  if not SameValue(d, 0) then
    Cairo.rotate(degtoRad(-d));
  Cairo.move_to(0, 0);
  Cairo.move_to(0, FFont.AdjustYpos);
  Cairo.text_path(Text);
  Cairo.SetColor(Font.Color, 0.5);
  Cairo.fill_preserve;
  Cairo.SetColor(clBlack, 0.5);
  Cairo.Stroke;


  Cairo.Restore;

  Changed;
end;

procedure TCairoCanvas.SetColor(const aColor: TColor);
var
  ta: TCairoColor;
begin
  ta.Color := ColorToRGB(aColor);
  Cairo.set_source_rgba(ta.red, ta.green, ta.blue, ta.Alpha);
end;

procedure TCairoCanvas.FillAndStrokePenBrush;
begin
  FillAndStroke(fPen.Style <> psClear, fBrush.GetStyle <> bsClear);
end;

procedure TCairoCanvas.PNGDraw(const aDestRect: TRect; aRotation: double; const Data: TBytes);
var
  lSurface: Pcairo_surface_t;
  lpattern: Pcairo_pattern_t;
  lMem: TCairoStream;
  lScaleHeight: double;
  lScaleWidth: double;
  lcairo_status_t: cairo_status_t;
  lw, lh: Integer;
  matrix: cairo_matrix_t;

begin
  // // Try to load PNG from Stream
  // lMem := TCairoStream.Create(Data);
  // try
  // lSurface := cairo_image_surface_create_from_png_stream(lMem.StreamRead, lMem);
  // finally
  // lMem.Free;
  // end;
  // if (lSurface <> nil) then
  // try
  // lcairo_status_t := cairo_surface_status(fcr);
  // if lcairo_status_t <> CAIRO_STATUS_SUCCESS then
  // Exit;
  //
  // lw := cairo_image_surface_get_width(lSurface);
  // lh := cairo_image_surface_get_height(lSurface);
  // if (lw > 1) and (lh > 1) then
  // begin
  //
  // Save;
  //
  // // TCairoAlphaHelper.UpdateAlpha(lSurface, 0.75);
  // // cairo_set_operator(fcr, CAIRO_OPERATOR_DEST);
  //
  // try
  // cairo_translate(fcr, aDestRect.Left, aDestRect.Top);
  // // Do Rotation
  // if not IsZero(aRotation) then
  // cairo_rotate(fcr, degtoRad(-aRotation));
  // lpattern := cairo_pattern_create_for_surface(lSurface);
  // try
  // // Calculate and Set Pattern Scale
  // lScaleWidth := lw / aDestRect.Width;
  // lScaleHeight := lh / aDestRect.Height;
  // cairo_matrix_init_scale(@matrix, lScaleWidth, lScaleHeight);
  // cairo_pattern_set_matrix(lpattern, @matrix);
  // cairo_pattern_set_extend(lpattern, CAIRO_EXTEND_NONE);
  //
  // // Set Source and Draw
  // cairo_set_source(fcr, lpattern);
  // // cairo_mask(fcr, lpattern);
  //
  // cairo_rectangle(fcr, 0, 0, aDestRect.Width, aDestRect.Height);
  // {$IFDEF DEBUGCAIRO}
  // Fill(true);
  // fPen.SetToCairo(fcr);
  // Stroke;
  // {$ELSE}
  // Fill;
  // {$ENDIF}
  // finally
  // cairo_pattern_destroy(lpattern);
  // end;
  //
  // finally
  // Restore;
  // end;
  //
  // end;
  // finally
  // cairo_surface_destroy(lSurface);
  // end;

end;

procedure TCairoCanvas.Save;
begin
  Cairo.Save;
end;

procedure TCairoCanvas.Restore;
begin
  Cairo.Restore;
end;

procedure TCairoCanvas.Fill(preserve: boolean);
begin
  if preserve then
    Cairo.fill_preserve
  else
    Cairo.Fill;
end;

procedure TCairoCanvas.Stroke(preserve: boolean);
begin
  if preserve then
    Cairo.stroke_preserve
  else
    Cairo.Stroke;
end;

{ TCairoGraphicsObject }

procedure TCairoGraphicsObject.Changed;
begin
  if assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TCairoGraphicsObject.Lock;
begin
  if assigned(FOwnerLock) then
    EnterCriticalSection(FOwnerLock^);
end;

procedure TCairoGraphicsObject.Unlock;
begin
  if assigned(FOwnerLock) then
    LeaveCriticalSection(FOwnerLock^);
end;

function TCairoPen.GetMode: TPenMode;
begin
  Result := FMode;
end;

procedure TCairoPen.SetToCairo(Cairo: ICairoContext);

// psSolid, psDash, psDot, psDashDot, psDashDotDot
const
  clsDash: array of double = [18, 6];
  clsDot: double = 3;
  clsDashDot: array of double = [8, 7, 3, 7];
  clsDashDotDot: array of double = [8, 4, 3, 4, 3, 4];

const
  PenModes: array [TPenMode] of Word = (R2_BLACK, R2_WHITE, R2_NOP, R2_NOT, R2_COPYPEN, R2_NOTCOPYPEN, R2_MERGEPENNOT, R2_MASKPENNOT,
    R2_MERGENOTPEN, R2_MASKNOTPEN, R2_MERGEPEN, R2_NOTMERGEPEN, R2_MASKPEN, R2_NOTMASKPEN, R2_XORPEN, R2_NOTXORPEN);

  function AdjustLineWidth(Value: Integer): double;
  begin
    if Value = 0 then
      Result := 1
    else
      // if (Value <= 1) and (cairo_get_antialias(cr) <> CAIRO_ANTIALIAS_NONE) then
      // Result := 0.5
      // else
      Result := Value;
  end;

begin
  Cairo.SetColor(ColorToRGB(FColor), fAlpha);
  Cairo.line_width := AdjustLineWidth(FWidth);


  case FStyle of
    Vcl.Graphics.psSolid: Cairo.set_dash([]);
    Vcl.Graphics.psDash: Cairo.set_dash(clsDash);
    Vcl.Graphics.psDot: Cairo.set_dash(clsDot);
    Vcl.Graphics.psDashDot: Cairo.set_dash(clsDashDot);
    Vcl.Graphics.psDashDotDot: Cairo.set_dash(clsDashDotDot);
    // // psClear: ;
    // // psInsideFrame: ;
    // // psUserStyle: ;
    // // psAlternate: ;
  else Cairo.set_dash([]);
  end;

  if FStyle = Vcl.Graphics.psSolid then
    Cairo.line_cap := CAIRO_LINE_CAP_ROUND
  else
    Cairo.line_cap := CAIRO_LINE_CAP_BUTT;
  Cairo.line_join := CAIRO_LINE_JOIN_ROUND;
end;

function TCairoFontGdi.GetColor: TColor;
begin
  Result := FFont.Color;
end;

function TCairoFontGdi.GetName: string;
begin
  Result := FFont.name;
end;

function TCairoFontGdi.GetSize: Integer;
begin
  Result := FFont.Size;
end;

procedure TCairoFontGdi.SetColor(const Value: TColor);
begin
  if Value <> FFont.Color then
  begin
    FFont.Color := Value;
    Changed;
  end;
end;

procedure TCairoFontGdi.SetHeight(const Value: Integer);
begin
  if FFont.Size <> Value then
  begin
    FFont.Size := Value;
    Changed;
  end;
end;

procedure TCairoFontGdi.SetName(const Value: string);
begin
  if Value <> FFont.name then
  begin
    FFont.name := Value;
    Changed;
  end;
end;

procedure TCairoFontGdi.SetSize(const Value: Integer);
begin
  if Value <> FFont.Size then
  begin
    FFont.Size := Value;
    Changed;
  end;

end;

procedure TCairoFontGdi.SetToCairo(Cairo: ICairoContext);
var
  ta: TColorRec;
  fsize: double;
  // lFont : TScaledWinFont;
begin

  Cairo.SetCairoFont(fCairoFont);
  // lfont.setToCairo(cairo.Handle);
  // Cairo.set_font_size(aFont.Size);
  Cairo.SetColor(FFont.Color);

  // cairo_select_font_face(cr, Putf8Char(FName), CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  // ta := TColorRec(ColorToRGB(FColor));
  // cairo_set_source_rgba(cr, ta.r / 255, ta.g / 255, ta.b / 255, 1.0);
  // fsize := MulDiv(FHeight, 96, 72);
  // cairo_set_font_size(cr, fsize);

end;

function TCairoBrush.GetColor: TColor;
begin
  Result := FColor;
end;

function TCairoBrush.GetStyle: TBrushStyle;
begin
  Result := FStyle;
end;

procedure TCairoBrush.SetColor(const Value: TColor);
begin
  if Value <> FColor then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TCairoBrush.SetStyle(const Value: TBrushStyle);
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    Changed;
  end;
end;

procedure TCairoBrush.SetToCairo(Cairo: ICairoContext);
Var
  lpattern: ICairoPattern;
  lcol: TCairoColor;
begin
  lcol.Color := ColorToRGB(FColor);
  Cairo.SetColor(ColorToRGB(FColor));

  lpattern := nil;
  case Style of
    bsSolid:;
    bsClear:;
    bsHorizontal:
      begin
        lpattern := CairoFactory.CreateLinePattern(8, lcol, lsSolid);
        lpattern.rotate(90);
      end;
    bsVertical:
      begin
        lpattern := CairoFactory.CreateLinePattern(8, lcol, lsSolid);
      end;
    bsFDiagonal:
      begin
        lpattern := CairoFactory.CreateLinePattern(6, lcol, lsSolid, 0.5);
        lpattern.rotate(45);
      end;
    bsBDiagonal:
      begin
        lpattern := CairoFactory.CreateLinePattern(6, lcol, lsSolid, 0.5);
        lpattern.rotate(135);
      end;
    bsCross:
      begin
        lpattern := CairoFactory.CreateCrossPattern(8, lcol, 0.5);
      end;
    bsDiagCross:
      begin
        lpattern := CairoFactory.CreateCrossPattern(6, lcol, 0.5);
        lpattern.rotate(45);
      end;
  end;

  if lpattern <> nil then
  begin
    Cairo.set_source(lpattern);
    lpattern := nil;
  end;

end;

function TCairoFontGdi.getHeight: Integer;
begin
  Result := FFont.Size;
end;

function TCairoFontGdi.getFont: TFont;
begin
  Result := FFont;
end;

procedure TCairoFontGdi.setFont(const Value: TFont);
begin
  FFont.Assign(Value);
  fCairoFont := TScaledWinFont.create_for_hfont(FFont.Handle, FFont.Size * Value.PixelsPerInch / 72);
  Changed;
end;

constructor TCairoFontGdi.Create;
begin
  inherited Create;
  FFont := TFont.Create;
end;

destructor TCairoFontGdi.Destroy;
begin
  FFont.Free;
  fCairoFont := nil;
  inherited;
end;

function TCairoFontGdi.AdjustYpos: Integer;
begin
  Result := Round(fCairoFont.extents.ascent);
end;

end.
