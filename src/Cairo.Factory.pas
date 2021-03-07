unit Cairo.Factory;

interface

uses
  Winapi.Windows,
  System.Classes,
  Cairo.Types,
  Cairo.Interfaces,
  Cairo.Base;

Type
  tCairoFactory = class(TInterfacedObject, ICairoFactory)

  strict private
    function Create2LinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoPattern;


    function CreateCrossPattern(dist: integer; Color: TCairoColor; PenWidth: Double = 1.0): ICairoPattern;
    function createGDI(hdc: hdc): ICairoSurface;
    function createGDI_with_format(hdc: hdc; format: cairo_format_t): ICairoSurface;
    function CreateRecording(Handle : Pcairo_surface_t): ICairoSurface;
     function CreatePdf(const filename : String; Sizew, SizeH : Double) : ICairoSurface;
     function CreateSVG(const filename : String; Sizew, SizeH : Double) : ICairoSurface;


    function CreateLinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double = 1.0): ICairoPattern;
    function Patterncreate_linear(x0: Double; y0: Double; x1: Double; y1: Double): ICairoPattern;
    function Patterncreate_linearType(Value: TCairoGradientType): ICairoPattern;
    function Patterncreate_linearWH(x0: Double; y0: Double; W: Double; H: Double): ICairoPattern;
    // Context
    function CreateContext(Target: ICairoSurface): ICairoContext;


    // Pattern
    function Patterncreate_rgb(Red: Double; Green: Double; Blue: Double): ICairoPattern;
    function Patterncreate_rgba(Red: Double; Green: Double; Blue: Double; Alpha: Double): ICairoPattern;
    function Patterncreate_rgbaColor(Value: TCairoColor): ICairoPattern;
    function Patterncreate_rgbColor(Value: TCairoColor): ICairoPattern;

    // Font
    function CreateFont(const alogfont: LOGFONT; aSize: Double): ICairoFont;

    // Image
    function create_for_data(data: PByte; datasize: integer; format: cairo_format_t; width: integer; height: integer): ICairoSurface;
    function create_from_Png(filename: String): ICairoSurface;
    function create_from_PngStream(const aStream: TStream) : ICairoSurface;

  end;

implementation

uses
  Cairo.stream,
  Cairo.Font,
  Cairo.Surface,
  Cairo.Pattern,
  Cairo.Pattern.Surfaces,
  Cairo.Context,
  Cairo.Dll;

function tCairoFactory.Create2LinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoPattern;
begin
  result := TBrushPattern.Create2LinePattern(dist, Color, LineStyle, PenWidth);
end;

function tCairoFactory.CreateContext(Target: ICairoSurface): ICairoContext;
begin
  result := TContext.create(Target);
end;

function tCairoFactory.CreateCrossPattern(dist: integer; Color: TCairoColor; PenWidth: Double = 1.0): ICairoPattern;
begin
  result := TBrushPattern.CreateCrossPattern(dist, Color, PenWidth);
end;

function tCairoFactory.createGDI(hdc: hdc): ICairoSurface;
begin
  result := TcaGdiSurface.create(hdc);
end;

function tCairoFactory.createGDI_with_format(hdc: hdc; format: cairo_format_t): ICairoSurface;
begin
  result := TcaGdiSurface.create_with_format(hdc, format);
end;

function tCairoFactory.CreateLinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double = 1.0)
  : ICairoPattern;
begin
  result := TBrushPattern.CreateLinePattern(dist, Color, LineStyle, PenWidth);
end;

function tCairoFactory.CreateRecording(Handle : Pcairo_surface_t):
    ICairoSurface;
begin
 if Handle = nil then
  result := tCaRecordingSurface.create(CAIRO_CONTENT_COLOR_ALPHA)
  else
  result := tCaRecordingSurface.createWithHandle(Handle);

end;

function tCairoFactory.Patterncreate_linear(x0: Double; y0: Double; x1: Double; y1: Double): ICairoPattern;
begin
  result := TGradientPattern.create_linear(x0, y0, x1, y1);
end;

function tCairoFactory.Patterncreate_linearType(Value: TCairoGradientType): ICairoPattern;
begin
  result := TGradientPattern.create_linearType(Value);
end;

function tCairoFactory.Patterncreate_linearWH(x0: Double; y0: Double; W: Double; H: Double): ICairoPattern;
begin
  result := TGradientPattern.create_linearWH(x0, y0, W, H);
end;

function tCairoFactory.Patterncreate_rgb(Red: Double; Green: Double; Blue: Double): ICairoPattern;
begin
  result := TRGBAPattern.create_rgb(Red, Green, Blue);
end;

function tCairoFactory.Patterncreate_rgba(Red: Double; Green: Double; Blue: Double; Alpha: Double): ICairoPattern;
begin
  result := TRGBAPattern.create_rgba(Red, Green, Blue, Alpha);
end;

function tCairoFactory.Patterncreate_rgbaColor(Value: TCairoColor): ICairoPattern;
begin
  result := TRGBAPattern.create_rgbaColor(Value);
end;

function tCairoFactory.Patterncreate_rgbColor(Value: TCairoColor): ICairoPattern;
begin
  result := TRGBAPattern.create_rgbColor(Value);
end;

function tCairoFactory.CreateFont(const alogfont: LOGFONT; aSize: Double): ICairoFont;
begin
  result := TScaledWinFont.create_for_logfont(alogfont, aSize);
end;


// procedure TPdfEnum.DrawBitmap(xs, ys, ws, hs, xd, yd, wd, hd, usage: integer;
// Bmi: PBitmapInfo; bits: pointer; clipRect: PRect; xSrcTransform: PXForm; dwRop: DWord;
// transparent: TPdfColorRGB = $FFFFFFFF);
// var B: TBitmap;
// R: TRect;
// Box, ClipRc: TPdfBox;
// fIntFactorX, fIntFactorY, fIntOffsetX, fIntOffsetY: Single;
// begin
// B := TBitmap.Create;
// try
// InitTransformation(xSrcTransform, fIntFactorX, fIntFactorY, fIntOffsetX, fIntOffsetY);
// // create a TBitmap with (0,0,ws,hs) bounds from DIB bits and info
// if Bmi^.bmiHeader.biBitCount=1 then
// B.Monochrome := true else
// B.PixelFormat := pf24bit;
// B.Width := ws;
// B.Height := hs;
// StretchDIBits(B.Canvas.Handle,0, 0, ws, hs, Trunc(xs+fIntOffsetX), Trunc(ys+fIntOffsetY),
// Trunc(ws*fIntFactorX), Trunc(hs*fIntFactorY), bits, Bmi^, usage, dwRop);
// if transparent <> $FFFFFFFF then begin
// if integer(transparent)<0 then
// transparent := GetSysColor(transparent and $ff);
// B.TransparentColor := transparent;
// end;
// // draw the bitmap on the PDF canvas
// with Canvas do begin
// R := Rect(xd, yd, wd+xd, hd+yd);
// NormalizeRect(R);
// Box := BoxI(R,true);
// ClipRc := GetClipRect;
// if (ClipRc.Width>0) and (ClipRc.Height>0) then
// Doc.CreateOrGetImage(B, @Box, @ClipRc) else // use cliping
// Doc.CreateOrGetImage(B, @Box, nil);
// // Doc.CreateOrGetImage() will reuse any matching TPdfImage
// // don't send bmi and bits parameters here, because of StretchDIBits above
// end;
// finally
// B.Free;
// end;
// end;


function tCairoFactory.create_for_data(data: PByte; datasize: integer; format: cairo_format_t; width, height: integer): ICairoSurface;
Var
  lStride: integer;
  lNewSize: integer;
begin
  result := nil;
  lStride := cairo_format_stride_for_width(format, width);
  lNewSize := lStride * height;
  if datasize = lNewSize then
  begin
    result := tCaImageSurface.create_for_data(data, format, width, height, lStride);
  end;
end;

function tCairoFactory.create_from_Png(filename: String): ICairoSurface;
begin
 result := tCaImageSurface.create_from_png(filename);
end;

function tCairoFactory.create_from_PngStream(const aStream: TStream): ICairoSurface;
Var lstream : TCairoStream;
begin
 lStream := TCairoStream.Create(aStream);
 result := tCaImageSurface.create_from_png_stream(lstream.StreamRead, lstream);
end;

function tCairoFactory.CreatePdf(const filename: String; Sizew, SizeH: Double): ICairoSurface;
begin
  result := TcaPdfSurface.create(Putf8char(Utf8string(filename)), Sizew, Sizeh);
end;
function tCairoFactory.CreateSVG(const filename: String; Sizew, SizeH: Double): ICairoSurface;
begin
 result := tCaSvgSurface.create(Putf8char(Utf8string(filename)), Sizew, Sizeh);
end;
end.
