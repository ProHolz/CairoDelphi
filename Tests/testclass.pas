unit testclass;

interface

uses
  Winapi.Windows,
  Vcl.Graphics;

type
 TTestmeta = class(TObject)
 private


 protected

 public
   constructor Create;
   destructor Destroy; override;

  class procedure drawMetaHigh(Canvas: Tcanvas);
   class procedure drawMeta(Canvas: Tcanvas);
   class procedure drawMetaLow(Canvas: Tcanvas);
   class procedure drawMetaArctoTest(Canvas: Tcanvas);
   class procedure drawMetaArcAngleTest(Canvas: Tcanvas);

   class procedure drawMetaClip(Canvas: Tcanvas);

 end;


  tMetaManager = class
   public
     class function CreateMetafile(asize : Tsize; var aMeta : Tmetafile; var aCanvas : TmetafileCanvas):boolean;
  end;






implementation
 uses classes, sysutils, Vcl.Imaging.jpeg, System.Math;

{ tMetaManager }

class function tMetaManager.CreateMetafile(asize : Tsize; var aMeta :
    Tmetafile; var aCanvas : TmetafileCanvas): boolean;
Var tmc : TMetafileCanvas;
begin
  aMeta := TMetafile.Create;
  ameta.SetSize(asize.cx, asize.cy);
  aCanvas := TMetafileCanvas.Create(aMeta, 0);
  result := true;
end;

{ TTestmeta }

constructor TTestmeta.Create;
begin
  inherited;

end;

destructor TTestmeta.Destroy;
begin

  inherited;
end;

class procedure TTestmeta.drawMetaHigh(Canvas: Tcanvas);
 Var lp : TPoint;
     x,y1, y2 : integer;
     lPic : TGraphic;
     lPicrect :Trect;
begin
 SetMapMode(Canvas.Handle, MM_HIMETRIC) ;
 SetWindowOrgEx(Canvas.handle,  0, 29700, @lp);
 // Draw Paper
 Canvas.Pen.Width := 40;
 canvas.Brush.Color := clYellow;
 Canvas.Brush.Style := bsSolid;
 canvas.Rectangle(0,0,21000 , 29700);
 Canvas.Pen.Color := clBlue;

  Canvas.Brush.Style := bsClear;
  canvas.Rectangle(1000,1000, 20000 , 28700);

  x :=  2000;
  y1 := 1000;
  y2 := 28700;

  lPic := TJPEGImage.create;
  lPic.LoadFromFile('D:\Projekte\SynPdfrework\Win32\Data\Hemmler_logo.jpg');

  lPicrect := rect(1000, 24000, 1000+15560, 24000+5440);

  canvas.StretchDraw(Lpicrect, lPic);
  lPic.free;

//  canvas.Pen.Color := clLtGray;
//  canvas.Pen.Style := psDot;
//  while x < 20000 do
//  begin
//    Canvas.MoveTo(x, y1);
//    Canvas.LineTo(x, y2);
//    inc(x, 1000);
//  end;

  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 1000;
  SetTextAlign(Canvas.Handle, TA_TOP) ;
  Canvas.TextOut(1000, 28700, 'Test MM_HIMETRIC');



end;

class procedure TTestmeta.drawMeta(Canvas: Tcanvas);
 Var lp : TPoint;
begin
 SetMapMode(Canvas.Handle, MM_HIMETRIC) ;
 SetWindowOrgEx(Canvas.handle,  0, 29700, @lp);
 // Draw Paper
 canvas.Brush.Color := clWhite;
 Canvas.Brush.Style := bsSolid;
 Canvas.Pen.Color := clBlue;
 Canvas.Pen.Width := 10;
 canvas.Rectangle(0,0,21000 , 29700);

//  Canvas.Brush.Style := bsClear;
  canvas.Rectangle(1000,1000, 20000 , 28700);

  //SetViewportOrgEx(Canvas.handle,  100, -1000, nil);

  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 1000;
  SetTextAlign(Canvas.Handle, TA_TOP) ;
  Canvas.TextOut(1000, 28700, 'Test');
end;

class procedure TTestmeta.drawMetaLow(Canvas: Tcanvas);
 Var lp : TPoint;
     x,y1, y2 : integer;
begin
 SetMapMode(Canvas.Handle, MM_LOMETRIC) ;
 SetWindowOrgEx(Canvas.handle,  0, 2970, @lp);
 // Draw Paper
 canvas.Brush.Color := clWhite;
 Canvas.Brush.Style := bsSolid;
 canvas.Rectangle(0,0,2100 , 2970);

//  Canvas.Brush.Style := bsClear;
  canvas.Rectangle(100,100, 2000 , 2870);

  x :=  200;
  y1 := 100;
  y2 := 2870;

  canvas.Pen.Color := clLtGray;
  canvas.Pen.Style := psDot;
  canvas.Pen.Width := 3;
  while x < 2000 do
  begin
    Canvas.MoveTo(x, y1);
    Canvas.LineTo(x, y2);
    inc(x, 100);
  end;


  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 100;
  SetTextAlign(Canvas.Handle, TA_BOTTOM) ;
  Canvas.TextOut(100, 2870, 'Test MM_LOMETRIC');

  Canvas.Font.Color := clRed;
  SetTextAlign(Canvas.Handle, TA_TOP);
  Canvas.TextOut(100, 2870, 'Test MM_LOMETRIC');

  Canvas.Font.Color := clGreen;
  SetTextAlign(Canvas.Handle, TA_BASELINE or TA_RIGHT);
  Canvas.TextOut(100, 2870, 'Test MM_LOMETRIC');

end;

class procedure TTestmeta.drawMetaArctoTest(Canvas: Tcanvas);

 Procedure DrawArcto(R : Trect; astart, aEnd, aMove : Tpoint);
 begin
   // Prepare rect
   r.SetLocation(aMove);
   astart := astart.Add(aMove);
   aend := aEnd.Add(aMove);
   canvas.pen.color := clRed;
   canvas.Arcto(r.Left, r.top, r.Right, r.Bottom, astart.x, astart.y, aEnd.x, aEnd.y);
   canvas.pen.color := clGreen;
 end;


 procedure drawText(lm : Tpoint; s : string);
 begin
   canvas.Brush.Style := bsClear;
 Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 10;
  SetTextAlign(Canvas.Handle, TA_BOTTOM) ;

  Canvas.TextOut(lm.x, lm.y, s);
 end;


 Var lp : TPoint;
     x,y1, y2 : integer;
     lPic : TGraphic;
     lPicrect :Trect;
     lxform : XFORM;
     r : trect;
     ls, le : Tpoint;
     lm : tpoint;
begin
 //SetMapMode(Canvas.Handle, MM_TEXT) ;
 //SetWindowOrgEx(Canvas.handle,  0, 2970, @lp);
  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 10;
  SetTextAlign(Canvas.Handle, TA_TOP) ;

  Canvas.TextOut(10, 10, 'Test MM_TEXT');

  Canvas.Brush.Style := bsClear;
  SetArcDirection(canvas.Handle, AD_COUNTERCLOCKWISE);

  lm.x := 100;
  lm.y := 100;

  // Start moveto lineto and co
  drawText(lm,'Moveto');
  drawText(lm.add(point(100,100)),'Arcto');
  drawText(lm.add(point(400,180)),'Lineto');

 // Begin draw

  Canvas.moveto(lm.x, lm.y);
  lm.x := 200;
  r := Rect(0,0,300,200);
  ls := point(0,100);
  le := point(300, 200);

  DrawArcto(r, ls, le, lm);

  Canvas.lineto(lm.x+400, lm.y+100);



   SetArcDirection(canvas.Handle, AD_CLOCKWISE);

  lm.x := 100;
  lm.y := 400;

  // Start moveto lineto and co
  drawText(lm,'Moveto');
  drawText(lm.add(point(100,100)),'Arcto');
  drawText(lm.add(point(400,180)),'Lineto');

 // Begin draw

  Canvas.moveto(lm.x, lm.y);
  lm.x := 200;
  r := Rect(0,0,300,200);
  ls := point(0,100);
  le := point(300, 200);

  DrawArcto(r, ls, le, lm);

  Canvas.lineto(lm.x+400, lm.y+100);


end;

class procedure TTestmeta.drawMetaArcAngleTest(Canvas: Tcanvas);

 Procedure DrawArcAngle(R : Trect; aMove : Tpoint);
 var cx, cy : integer;
     rad : integer;
 begin
   // Prepare rect
   r.SetLocation(aMove);
   canvas.pen.color := clRed;

   cx := r.CenterPoint.x;
   cy := r.CenterPoint.y;
   rad := 100;
   canvas.MoveTo(cx-2*rad, cy-rad);

   canvas.AngleArc(cx, cy, rad, 0, 90);
   canvas.pen.color := clGreen;

   canvas.MoveTo(cx, cy+rad);
   canvas.LineTo(cx, cy- rad);
   canvas.MoveTo(cx -rad, cy);
   canvas.LineTo(cx + rad, cy);


 end;


 procedure drawText(lm : Tpoint; s : string);
 begin
   canvas.Brush.Style := bsClear;
  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 10;
  SetTextAlign(Canvas.Handle, TA_BOTTOM) ;

  Canvas.TextOut(lm.x, lm.y, s);
 end;


 Var lp : TPoint;
     x,y1, y2 : integer;
     lPic : TGraphic;
     lPicrect :Trect;
     lxform : XFORM;
     r : trect;
     ls, le : Tpoint;
     lm : tpoint;
begin
 //SetMapMode(Canvas.Handle, MM_TEXT) ;
 //SetWindowOrgEx(Canvas.handle,  0, 2970, @lp);
  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 10;
  SetTextAlign(Canvas.Handle, TA_TOP) ;

  Canvas.TextOut(10, 10, 'Test MM_TEXT');

  Canvas.Brush.Style := bsClear;
  SetArcDirection(canvas.Handle, AD_COUNTERCLOCKWISE);

  lm.x := 100;
  lm.y := 100;

  // Start moveto lineto and co
  drawText(lm,'AngleArc');
//  drawText(lm.add(point(100,100)),'Arcto');
//  drawText(lm.add(point(400,180)),'Lineto');

 // Begin draw

  lm.x := 100;
  r := Rect(0,0,300,200);
  ls := point(0,100);
  le := point(300, 200);

  DrawArcAngle(r,  lm);



end;

class procedure TTestmeta.drawMetaClip(Canvas: Tcanvas);
Var lp : TPoint;
     x,y1, y2 : integer;

     r : Trect;
     rgn : HRGN;

begin
 //SetMapMode(Canvas.Handle, MM_TEXT) ;
// SetWindowOrgEx(Canvas.handle,  0, 2970, @lp);
 // Draw Paper
 canvas.Brush.Color := clWhite;
 Canvas.Brush.Style := bsSolid;
 canvas.Rectangle(0,0,2100 , 2970);

//  Canvas.Brush.Style := bsClear;
  canvas.Rectangle(100,100, 2000 , 2870);

  x :=  200;
  y1 := 100;
  y2 := 2870;

//  canvas.Pen.Color := clLtGray;
//  canvas.Pen.Style := psDot;
//  while x < 2000 do
//  begin
//    Canvas.MoveTo(x, y1);
//    Canvas.LineTo(x, y2);
//    inc(x, 100);
//  end;


  Canvas.Font.Name := 'Arial';
  Canvas.Font.Size := 100;
  SetTextAlign(Canvas.Handle, TA_TOP) ;
  Canvas.TextOut(100, 100, 'Test MM_LOMETRIC');


  R := Rect(100,200, 1000 , 1000);
  RGN := CreateRectRgnIndirect(r) ;
//  RGN := CreateRectRgn(100,100, 2000 , 2870) ;
  SelectClipRgn(Canvas.handle, RGN);
//  ExtSelectClipRgn(Canvas.handle, RGN, RGN_COPY);
  DeleteObject(RGN);

  canvas.Brush.Color := clYellow;
  canvas.Brush.Style := bsSolid;
  //canvas.Rectangle(0,0, 2000 , 2970);

{$IFDEF DEBUG2}
  ExcludeClipRect(Canvas.Handle, 400,400, 1800 , 2570);

  canvas.Brush.Color := clBlue;
  canvas.Brush.Style := bsSolid;
  canvas.Rectangle(300,300, 2000 , 2870);

  IntersectClipRect(Canvas.Handle, 200,200, 1900 , 2770);

   canvas.Brush.Color := clCream;
  canvas.Brush.Style := bsSolid;
  canvas.Rectangle(0,0, 2000 , 2870);
{$ENDIF}




end;

end.
