unit Cairo.Emf.Implementations;

interface
{$HINTS OFF}
uses
  Winapi.Windows,
  System.Types,
  System.Sysutils,
  System.Classes,
  Generics.Collections,
  Cairo.Types,
  Cairo.Base,
  Cairo.Interfaces,
  Cairo.Emf;

type
  TEmfGDIComment = (pgcOutline, pgcBookmark, pgcLink, pgcLinkNoBorder);

  TEmfRect = record
    Left, Top, Right, Bottom: Single;
  end;

  /// a EMF coordinates box
  TEmfBox = record
    Left, Top, Width, Height: Single;
  end;

  TEmfColorRGB = cardinal;


type

  TEmfFontSpec = packed record
    angle: SmallInt; // -360..+360
    ascent, descent, cell: SmallInt;
  end;

  TEmfEnumStatePen = record
    null: boolean;
    color, style: integer;
    Width: Single;
  end;

  TEmfEnumStateBrush = record
    null: boolean;
    color: integer;
    style: integer;
  end;

  TEmfEnumStatefont = record
    color: cardinal;
    align: DWORD;
    BkMode: DWORD;
    BkColor: cardinal;
    spec: TEmfFontSpec;
    LogFont: TLogFontW; // better be the last entry in TPdfEnumState record
  end;

  TEmfHandleObj = record
    case kind: integer of
      OBJ_PEN: (Pen: TEmfEnumStatePen);
      OBJ_FONT: (Font: TEmfEnumStatefont);
      OBJ_BRUSH: (Brush: TEmfEnumStateBrush);
  end;


type
  /// a state of the EMF enumeration engine, for the CairoCanvas
  // - used also for the SaveDC/RestoreDC stack
  TEmfEnumState = class
  strict private
    FMappingMode: integer;
    FViewSize: TSize;
    FWinSize: TSize;
    // transformation and clipping
    FBaseTransform: TCairoMatrix;
    FWorldTransform: TCairoMatrix;
    FActualTransform: TCairoMatrix;
    function Get_WorldTransform: cairo_matrix_t;
    procedure Set_MappingMode(const Value: integer);
    procedure Set_ViewSize(const Value: TSize);
    procedure Set_WinSize(const Value: TSize);
    procedure Set_WorldTransform(const Value: cairo_matrix_t);
    function getActualMatrix: pCairo_Matrix_t;
    procedure CalculateMatrix;

  protected
    Position: TPoint;
    Moved: boolean;
    WinOrg: TPoint;
    ViewOrg: TPoint;
    MetaRgn: TEmfBox; // clipping
    ClipRgn: TEmfBox; // clipping
    ClipRgnNull: boolean; // clipping
    PolyFillMode: integer;
    StretchBltMode: integer;
    ArcDirection: integer;
    Pen: TEmfEnumStatePen;
    Brush: TEmfEnumStateBrush;
    Font: TEmfEnumStatefont;

    procedure AssignFrom(aEmf: TEmfEnumState);
    function CreateCopy: TEmfEnumState;
    constructor Create;

    function getSign : Integer; inline;

    property MappingMode: integer read FMappingMode write Set_MappingMode;
    property ViewSize: TSize read FViewSize write Set_ViewSize;
    property WinSize: TSize read FWinSize write Set_WinSize;
    property WorldTransform: cairo_matrix_t read Get_WorldTransform write Set_WorldTransform;
    property ActualCairoMatrix: pCairo_Matrix_t read getActualMatrix;

  end;

type
  TEmfEnum = class(TInterfacedObject, IEmfEnum)
  strict private
    fContext: ICairoContext;
    FDevScaleX: Double;
    FDevScaleY: Double;
    FFactor: Double;
    FFactorX: Double;
    FFactorY: Double;
    FOffsetX: Double;
    FOffsetY: Double;

    fWorldFactorx: Double;
    fWorldFactory: Double;

    fInitMetaRgn: TEmfBox;


    fStates: TObjectList<TEmfEnumState>;
    fHandleObjects: TDictionary<integer, TEmfHandleObj>;

    fInlined: boolean;

    fnewpath: boolean;


  strict private
    procedure SizePosChanged;

  private
    function Get_OBJ(Index: integer): TEmfHandleObj;
    procedure Set_OBJ(Index: integer; const Value: TEmfHandleObj);

    procedure Set_FillColor(const Value: integer);
    procedure SetPen;
    procedure SetBrush;

    procedure Fill;
    procedure Stroke;
    procedure FillStroke;


    procedure DrawBitmap(xs, ys, ws, hs, xd, yd, wd, hd, usage: integer; Bmi: PBitmapInfo; bits: pointer; clipRect: PRect;
      xSrcTransform: PXForm; dwRop: DWORD; transparent: TEmfColorRGB = $FFFFFFFF);

    procedure FillRectangle(const Rect: TRect; ResetNewPath: boolean);

    // get current clipping area
    function GetClipRect: TEmfBox;

    procedure HandleComment(kind: TEmfGDIComment; P: PAnsiChar; Len: integer);
    // MetaRgn - clipping
    procedure InitMetaRgn(ClientRect: TRect);
    procedure SetMetaRgn;
    // intersect - clipping
    function IntersectClipRect(const ClpRect: TEmfBox; const CurrRect: TEmfBox): TEmfBox;
    procedure ScaleMatrix(Custom: XFORM; iMode: cardinal);


    procedure TextOut(var R: TEMRExtTextOut);


    procedure new_path;
    procedure close_path;

    procedure Save;
    procedure Restore;

    procedure Set_miter_limit(Value: Double);

    procedure Rectangle(x, y, Width, Height: Double);

    procedure Clip;
    procedure Ellipse(x, y, Width, Height: Double);

    procedure LineToI(x, y: integer); overload;
    procedure LineToI(x, y: Double); overload;
    procedure MoveToI(x, y: integer); overload;
    procedure MoveToI(x, y: Double); overload;
    procedure CurveToCI(x1, y1, x2, y2, x3, y3: Double);
    procedure RoundRectI(x1, y1, x2, y2, cx, cy: Double);
    procedure ARCI(centerx, centery, W, H, Sx, Sy, Ex, Ey: integer; clockwise: boolean; arctype: TCairoArcType; var Position: TPoint);
    function BoxI(Box: TRect): TEmfBox;
    procedure BeginText;
    procedure EndText;

    function Get_FNewPath: boolean;
    procedure Set_FNewPath(const Value: boolean);

    // From private Vars
    property IsNewPath: boolean read Get_FNewPath write Set_FNewPath;

    function State: TEmfEnumState;

    // Interface
  private
    procedure EMF_MetaHeader(const Value: TEnhMetaHeader);
    procedure EMF_SetWindowExtEx(const Value: TSize);
    procedure EMF_SetWindowOrgEx(const Value: TPoint);
    procedure EMF_SetViewPortExtEx(const Value: TSize);
    procedure EMF_SetViewPortOrgEx(const Value: TPoint);
    procedure EMF_SetMapMode(Value: DWORD);
    procedure EMF_SetWorldTransform(const Value: TEMRSetWorldTransform);
    procedure EMF_MofifyWorldTransform(const Value: TEMRModifyWorldTransform);

    procedure EMF_SetBKMode(const Value: DWORD);
    procedure EMF_SetBKColor(const Value: cardinal);
    procedure EMF_SetTextColor(const Value: cardinal);
    procedure EMF_SetTextAlign(const Value: DWORD);


    procedure EMF_SETPOLYFILLMODE(Value: DWORD);
    procedure EMF_SetStretchBltMode(Value: DWORD);
    procedure EMF_SetArcDirection(Value: DWORD);


    Procedure EMF_SaveDC;
    Procedure EMF_RestoreDC;
    procedure EMF_Set_miter_limit(Value: Single); // fw

    procedure EMF_IntersectClipRect(const ClpRect: TRect);
    procedure EMF_ExtSelectClipRgn(data: PRgnDataHeader; iMode: DWORD);


    procedure EMF_CreatePen(const Value: TEMRCreatePen);
    procedure EMF_ExtCreatePen(const Value: TEMRExtCreatePen);
    procedure EMF_CreateBrushIndirect(const Value: TEMRCreateBrushIndirect);
    procedure EMF_CreateFont(aLogFont: PEMRExtCreateFontIndirect);
    procedure EMF_DeleteObject(const Value: DWORD);
    procedure EMF_SelectObjectFromIndex(const Value: integer);


    procedure EMF_MOVETOEX(const Value: EMRMoveToEx);
    procedure EMF_LINETO(const Value: EMRLINETO);
    procedure EMF_Rectangle(const Value: EMRRectangle);
    procedure EMF_Ellipse(const Value: EMRELLIPSE);
    procedure EMF_Roundrect(const Value: EMRROUNDRECT);

    procedure EMF_Arc(Value: EMRARC);
    procedure EMF_ArcTo(Value: EMRArcTo);
    procedure EMF_ANGLEARC(const Value : EMRANGLEARC);
    procedure EMF_Pie(Value: EMRPie);
    procedure EMF_Chord(Value: EMRChord);

    procedure EMF_FillRGN(Value: EMRFillRgn);
    procedure EMF_SetMetaRgn;

    procedure EMF_POLYGON(const Value: EMRPolyLine);
    procedure EMF_POLYGON16(const Value: EMRPolyLine16);

    procedure EMF_POLYLINE(const Value: EMRPolyLine);
    procedure EMF_POLYLINE16(const Value: EMRPolyLine16);
    procedure EMF_POLYLINETO(const Value: EMRPolyLineTO);
    procedure EMF_POLYLINETO16(const Value: EMRPolyLineTO16);

    procedure EMF_PolyPolygon(data: PEMRPolyPolygon; iType: integer);
    procedure EMF_POLYBEZIER(const Value: EMRPolyBezier);
    procedure EMF_POLYBEZIER16(const Value: EMRPolyBezier16);
    procedure EMF_POLYBEZIERTO(const Value: EMRPolyBezierTo);
    procedure EMF_POLYBEZIERTO16(const Value: EMRPolyBezierTo16);

    procedure EMF_POLYDRAW(const R: PEnhMetaRecord);
    procedure EMF_POLYDRAW16(const R: PEnhMetaRecord);


    procedure EMF_GradientFill(data: PEMGradientFill);


    procedure EMF_BITBLT(Value: PEMRBITBLT);
    procedure EMF_STRETCHBLT(Value: PEMRStretchBlt);
    procedure EMF_STRETCHDIBITS(Value: PEMRStretchDIBits);
    procedure EMF_TRANSPARENTBLT(Value: PEMRTransparentBLT);

    procedure EMF_TextOut(var R: TEMRExtTextOut);

    procedure EMF_GDICOMMENT(const Value: EMRGDICOMMENT);

    procedure EMF_BeginPath;
    procedure EMF_CLosePath;
    procedure EMF_EndPath;
    procedure EMF_AbortPath;
    procedure EMF_FillPath;
    procedure EMF_StrokePath;
    procedure EMF_StrokeAndFillPath;

    procedure EMF_SetPixel;

  public
    constructor Create(aContext: ICairoContext);
    destructor Destroy; override;
  end;


implementation

uses
  System.Math,
  Vcl.graphics,
  Vcl.Imaging.pngImage;


const
  MWT_SET = 4;

const
  // see http://paste.lisp.org/display/1105
  BEZIER: Single = 0.55228477716; // = 4/3 * (sqrt(2) - 1);
  EmptyEmfbox: TEmfBox = (Left: 0.0; Top: 0.0; Width: 0.0; Height: 0.0);

type
  PtrUInt = NativeUInt;

procedure NormalizeRect(var Rect: System.Types.TRect);
var
  tmp: integer;
begin // PDF can't draw twisted rects -> normalize such values
  if Rect.Right < Rect.Left then
  begin
    tmp := Rect.Left;
    Rect.Left := Rect.Right;
    Rect.Right := tmp;
  end;
  if Rect.Bottom < Rect.Top then
  begin
    tmp := Rect.Top;
    Rect.Top := Rect.Bottom;
    Rect.Bottom := tmp;
  end;
end;

procedure NormalizeRectEMF(var Rect: TEmfRect);
var
  tmp: Single;
begin // PDF can't draw twisted rects -> normalize such values
  if Rect.Right < Rect.Left then
  begin
    tmp := Rect.Left;
    Rect.Left := Rect.Right;
    Rect.Right := tmp;
  end;
  if Rect.Bottom < Rect.Top then
  begin
    tmp := Rect.Top;
    Rect.Top := Rect.Bottom;
    Rect.Bottom := tmp;
  end;
end;

procedure win32_xform_to_cairo_matrix(const aXForm: XFORM; var m: cairo_matrix_t);
begin
  m.xx := aXForm.eM11;
  m.xy := aXForm.eM21;
  m.yx := aXForm.eM12;
  m.yy := aXForm.eM22;
  m.x0 := aXForm.eDx;
  m.y0 := aXForm.eDy;
end;

procedure TEmfEnum.EMF_CreateFont(aLogFont: PEMRExtCreateFontIndirect);
var
  HF: HFONT;
  TM: TTextMetric;
  Old: HGDIOBJ;
  destDC: HDC;
  lTemp: TEmfHandleObj;
begin
  destDC := Getdc(0);
  HF := CreateFontIndirectW(aLogFont.elfw.elfLogFont);
  Old := SelectObject(destDC, HF);
  GetTextMetrics(destDC, TM);
  SelectObject(destDC, Old);
  DeleteObject(HF);
  begin
    lTemp := Get_OBJ(aLogFont^.ihFont - 1);
    lTemp.kind := OBJ_FONT;
    Move(aLogFont^.elfw.elfLogFont, lTemp.Font.LogFont, sizeof(lTemp.Font.LogFont));
    lTemp.Font.LogFont.lfPitchAndFamily := TM.tmPitchAndFamily;
    if lTemp.Font.LogFont.lfOrientation <> 0 then
      lTemp.Font.spec.angle := lTemp.Font.LogFont.lfOrientation div 10
    else // -360..+360
      lTemp.Font.spec.angle := lTemp.Font.LogFont.lfEscapement div 10;
    lTemp.Font.spec.ascent := TM.tmAscent;
    lTemp.Font.spec.descent := TM.tmDescent;
    lTemp.Font.spec.cell := TM.tmHeight - TM.tmInternalLeading;
    Set_OBJ(aLogFont^.ihFont - 1, lTemp);
  end;
end;

procedure TEmfEnum.DrawBitmap(xs, ys, ws, hs, xd, yd, wd, hd, usage: integer; Bmi: PBitmapInfo; bits: pointer; clipRect: PRect;
  xSrcTransform: PXForm; dwRop: DWORD; transparent: TEmfColorRGB = $FFFFFFFF);
Var lBitmap: ICairoSurface;
  lStatus: cairo_status_t;
  B: TBitmap;
  png: TPngimage;
  lStream: TStream;

  lscalex : double;
  lscaly : double;
begin
  lStream := TMemoryStream.Create;
  try
    B := TBitmap.Create;
    try
      B.PixelFormat := pf24bit;
      B.Width := ws;
      B.Height := hs;

      lscalex := wd / ws;
      lscaly := hd / hs;
      StretchDIBits(B.Canvas.Handle, 0, 0, ws, hs, 0, 0, ws, hs, bits, Bmi^, usage, dwRop);
      if transparent <> $FFFFFFFF then
      begin
        if integer(transparent) < 0 then
          transparent := GetSysColor(transparent and $FF);
        B.TransparentColor := transparent;
      end;

      png := TPngimage.Create;
      try
        png.Assign(B);
        png.SaveToStream(lStream);
      finally
        png.Free;
      end;
      lStream.Position := 0;
      lBitmap := CairoFactory.create_from_PngStream(lStream);
      if lBitmap.status = CAIRO_STATUS_SUCCESS then
      begin
        lBitmap.set_device_scale(1, State.getSign);
        fcontext.save;
        fContext.scale(lscalex, lscaly);
        fContext.set_source_surface(lBitmap, xd / lscalex, yd / lscaly);
        fContext.paint;
        fContext.restore;
      end;

    finally
      B.Free;
    end;
  finally
    lStream.Free;
  end;
end;

procedure TEmfEnum.EMF_ExtSelectClipRgn(data: PRgnDataHeader; iMode: DWORD);
var ExtClip: TRect;
begin
  if data <> nil then
    ExtClip := data^.rcBound;
  case iMode of
    RGN_COPY:
      begin
        State.ClipRgn := State.MetaRgn;
        State.ClipRgnNull := False;
      end;
  end;
end;

procedure TEmfEnum.FillRectangle(const Rect: TRect; ResetNewPath: boolean);

begin
  with BoxI(Rect) do
   Rectangle(Left, top, Width, height);
  SetBrush;
  Fill;
end;

procedure TEmfEnum.SetPen;
begin
  if not State.Pen.null then
  begin
    fContext.setColor(State.Pen.color);
    if State.Pen.Width = 0 then
      State.Pen.Width := 1;
    fContext.line_width := State.Pen.Width;

    case State.Pen.style of
     PS_SOLID : fContext.setLineStyle(TcairoLineStyle.lsSolid);
     PS_DASH : fContext.setLineStyle(TcairoLineStyle.lsDash);
     PS_DOT : fContext.setLineStyle(TcairoLineStyle.lsDot);
     PS_DASHDOT : fContext.setLineStyle(TcairoLineStyle.lsDashDot);
     PS_DASHDOTDOT : fContext.setLineStyle(TcairoLineStyle.lsDashDotDot);
    end;


  end
  else
    fContext.line_width := 0;
end;

procedure TEmfEnum.SetBrush;
begin
  if not State.Brush.null then
  begin
    fContext.setColor(State.Brush.color);
  end;
end;

procedure TEmfEnum.EMF_MetaHeader(const Value: TEnhMetaHeader);
begin
  InitMetaRgn(Value.rclBounds);
  State.ArcDirection := AD_COUNTERCLOCKWISE;
end;

procedure TEmfEnum.EMF_MofifyWorldTransform(const Value: TEMRModifyWorldTransform);
begin
  ScaleMatrix(Value.XFORM, Value.iMode);
end;

procedure TEmfEnum.EMF_SetBKColor(const Value: cardinal);
begin
  if integer(Value) = clNone then
    State.Font.BkColor := 0
  else
    State.Font.BkColor := Value;
end;

procedure TEmfEnum.EMF_SetBKMode(const Value: DWORD);
begin
  State.Font.BkMode := Value;
end;

procedure TEmfEnum.EMF_SetTextAlign(const Value: DWORD);
begin
  State.Font.align := Value;
end;

procedure TEmfEnum.EMF_SetTextColor(const Value: cardinal);
begin
  if integer(Value) = clNone then
    State.Font.color := 0
  else
    State.Font.color := Value;
end;

procedure TEmfEnum.EMF_SetViewPortExtEx(const Value: TSize);
begin
  State.ViewSize := Value;
  SizePosChanged;
end;

procedure TEmfEnum.EMF_SetViewPortOrgEx(const Value: TPoint);
begin
  State.ViewOrg := Value;
  SizePosChanged;
end;

procedure TEmfEnum.EMF_SetWindowExtEx(const Value: TSize);
begin
  State.WinSize := Value;
  SizePosChanged;
end;

procedure TEmfEnum.EMF_SetWindowOrgEx(const Value: TPoint);
begin
  State.WinOrg := Value;
  SizePosChanged;
end;

procedure TEmfEnum.EMF_SetWorldTransform(const Value: TEMRSetWorldTransform);
begin
  ScaleMatrix(Value.XFORM, MWT_SET);
end;

procedure TEmfEnum.FillStroke;
begin
  if not State.Brush.null then
  begin
    SetBrush;
    if State.Pen.null then
      fContext.Fill
    else
      fContext.fill_preserve;
  end;

  if not State.Pen.null then
  begin
    SetPen;
    fContext.Stroke;
  end;
end;

function TEmfEnum.GetClipRect: TEmfBox;
begin
  Result := default (TEmfBox);
end;

function TEmfEnum.Get_OBJ(Index: integer): TEmfHandleObj;
begin
  if fHandleObjects.ContainsKey(index) then
    Result := fHandleObjects[index]
  else
    Result := default (TEmfHandleObj);
end;

procedure TEmfEnum.HandleComment(kind: TEmfGDIComment; P: PAnsiChar; Len: integer);
begin
  // TODO -cMM: TEmfEnum.HandleComment default body inserted
end;

procedure TEmfEnum.InitMetaRgn(ClientRect: TRect);
begin
  fInitMetaRgn := BoxI(ClientRect);
  State.ClipRgnNull := true;
  State.MetaRgn := fInitMetaRgn;
end;

function TEmfEnum.IntersectClipRect(const ClpRect: TEmfBox; const CurrRect: TEmfBox): TEmfBox;
begin
  Result := CurrRect;
  if (ClpRect.Width <> 0) or (ClpRect.Height <> 0) then
  begin // ignore null clipping area
    if ClpRect.Left > Result.Left then
      Result.Left := ClpRect.Left;
    if ClpRect.Top > Result.Top then
      Result.Top := ClpRect.Top;
    if (ClpRect.Left + ClpRect.Width) < (Result.Left + Result.Width) then
      Result.Width := (ClpRect.Left + ClpRect.Width) - Result.Left;
    if (ClpRect.Top + ClpRect.Height) < (Result.Top + Result.Height) then
      Result.Height := (ClpRect.Top + ClpRect.Height) - Result.Top;
    // fix rect
    if Result.Width < 0 then
      Result.Width := 0;
    if Result.Height < 0 then
      Result.Height := 0;
  end;
end;

procedure TEmfEnum.EMF_PolyPolygon(data: PEMRPolyPolygon; iType: integer);
begin
  // TODO -cMM: TEmfEnum.PolyPoly default body inserted
end;

procedure TEmfEnum.ScaleMatrix(Custom: XFORM; iMode: cardinal);
var
  m: cairo_matrix_t;
  lhelp: TCairoMatrix;
begin
  case iMode of
    MWT_IDENTITY:
      begin
        lhelp.init_identity;
        State.WorldTransform := lhelp.Matrix^;
      end;
    MWT_LEFTMULTIPLY:
      begin
        win32_xform_to_cairo_matrix(Custom, m);
        lhelp.multiply(State.WorldTransform, m);
        State.WorldTransform := lhelp.Matrix^;
      end;
    MWT_RIGHTMULTIPLY:
      begin
        win32_xform_to_cairo_matrix(Custom, m);
        lhelp.multiply(m, State.WorldTransform);
        State.WorldTransform := lhelp.Matrix^;
      end;
    MWT_SET:
      begin
        win32_xform_to_cairo_matrix(Custom, m);
        State.WorldTransform := m;
      end;
  else
    begin
      // Should not happen .....
    end;
  end;

  fContext.set_matrix(State.ActualCairoMatrix);
end;

procedure TEmfEnum.EMF_SelectObjectFromIndex(const Value: integer);

const
  STOCKBRUSHCOLOR: array [WHITE_BRUSH .. BLACK_BRUSH] of integer = (clWhite, $AAAAAA, $808080, $666666, clBlack);
  STOCKPENCOLOR: array [WHITE_PEN .. BLACK_PEN] of integer = (clWhite, clBlack);

var
  lTemp: TEmfHandleObj;

  iObject: integer;

begin
  iObject := Value;
  if iObject < 0 then
  begin // stock object?
    iObject := iObject and $7FFFFFFF;
    case iObject of
      NULL_BRUSH: State.Brush.null := true;
      WHITE_BRUSH .. BLACK_BRUSH:
        begin
          State.Brush.color := STOCKBRUSHCOLOR[iObject];
          State.Brush.null := False;
        end;
      NULL_PEN:
        begin
          if fInlined and ((State.Pen.style <> PS_NULL) or not State.Pen.null) then
          begin
            fInlined := False;
            if not State.Pen.null then
              fContext.Stroke;
          end;
          State.Pen.style := PS_NULL;
          State.Pen.null := true;
        end;
      WHITE_PEN, BLACK_PEN:
        begin
          if fInlined and ((State.Pen.color <> STOCKPENCOLOR[iObject]) or not State.Pen.null) then
          begin
            fInlined := False;
            if not State.Pen.null then
              fContext.Stroke;
          end;
          State.Pen.color := STOCKPENCOLOR[iObject];
          State.Pen.null := False;
        end;
    end;
  end
  else if fHandleObjects.ContainsKey(iObject - 1) then
  begin
    lTemp := Get_OBJ(iObject - 1);
    case lTemp.kind of // ignore any invalid reference
      OBJ_PEN:
        begin
          if fInlined and ((State.Pen.color <> lTemp.Pen.color) or (State.Pen.Width <> lTemp.Pen.Width) or
            (State.Pen.style <> lTemp.Pen.style)) then
          begin
            fInlined := False;
            if not State.Pen.null then
              fContext.Stroke;
          end;
          State.Pen.null := (lTemp.Pen.Width < 0) or (lTemp.Pen.style = PS_NULL); // !! 0 means as thick as possible
          State.Pen.color := lTemp.Pen.color;
          State.Pen.Width := lTemp.Pen.Width;
          State.Pen.style := lTemp.Pen.style;
        end;
      OBJ_BRUSH:
        begin
          State.Brush.null := lTemp.Brush.null;
          State.Brush.color := lTemp.Brush.color;
          State.Brush.style := lTemp.Brush.style;
        end;
      OBJ_FONT:
        begin
          State.Font.spec := lTemp.Font.spec;
          Move(lTemp.Font.LogFont, State.Font.LogFont, sizeof(LogFont));
        end;
    end;
  end;
end;

procedure TEmfEnum.EMF_SetMetaRgn;
begin
  // TODO -cMM: TEmfEnum.SetMetaRgn default body inserted
end;

procedure TEmfEnum.Set_FillColor(const Value: integer);
begin
  fContext.setColor(Value);
end;

procedure TEmfEnum.Set_OBJ(Index: integer; const Value: TEmfHandleObj);
begin
  fHandleObjects.AddOrSetValue(index, Value);
end;

function DXTextWidth(DX: PIntegerArray; n: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to n - 1 do
    inc(Result, DX^[i]);
end;

procedure TEmfEnum.TextOut(var R: TEMRExtTextOut);
var
  wW, W, H: Single;
  Posi: TPoint;
  AWidth, ASize, PosX, PosY: Single;
  tmp: array of Char; // R.emrtext is not #0 terminated -> use tmp[]
  a, acos, asin: Single;
  bOpaque: boolean;
  backRect: TRect;

  lText: string;
  lFont: ICairoFont;
  lScaleFont : ICairoScaledFont;
  lMatrix: cairo_matrix_t;

  procedure DrawLine(aH: Single);
  var
    tmp: TEmfEnumStatePen;
  begin
    tmp := State.Pen;
    State.Pen.color := State.Font.color;
    State.Pen.Width := ASize / 15;
    State.Pen.style := PS_SOLID;
    State.Pen.null := False;
    SetPen;
    MoveToI(-State.Pen.Width, -H + aH);
    LineToI(AWidth + 2 * State.Pen.Width, -H + aH);

    fContext.Stroke;
    State.Pen := tmp;
    SetPen;
  end;

begin
  if R.emrtext.nChars > 0 then
  begin
    setLength(tmp, R.emrtext.nChars + 1);
    Move(pointer(PtrUInt(@R) + R.emrtext.offString)^, tmp[0], R.emrtext.nChars * 2);
    lText := pchar(tmp);

    ASize := Abs(State.Font.LogFont.lfHeight);
    lFont := CairoFactory.CreateFont(State.Font.LogFont, ASize);
    fContext.SetCairoFont(lFont);
    AWidth := lFont.text_extents(lText).Width; // fContext.TextWidth(Pointer(tmp));
    W := AWidth;
    wW := W; // right x
    if (State.Font.align and TA_CENTER) = TA_CENTER then
      W := W / 2 // center x
    else if (State.Font.align and TA_RIGHT) = TA_RIGHT then
      W := AWidth // left x
    else w := 0;
    // V Align mask = TA_BASELINE or TA_BOTTOM or TA_TOP = TA_BASELINE
    if (State.Font.align and TA_BASELINE) = TA_BASELINE then
      H := Abs(State.Font.LogFont.lfHeight) - Abs(State.Font.spec.cell) // center y
    else if (State.Font.align and TA_BOTTOM) = TA_BOTTOM then
      H := Abs(State.Font.spec.descent) // bottom y
    else
      H := -Abs(State.Font.spec.ascent); // top

    if (State.Font.align and TA_UPDATECP) = TA_UPDATECP then
      Posi := State.Position
    else
      Posi := R.emrtext.ptlReference;

     h := h * State.getSign;

    PosX := Posi.x - W;
    PosY := Posi.y - H;


    bOpaque := (not State.Brush.null) and (State.Brush.color <> clWhite) and
      ((R.emrtext.fOptions and ETO_OPAQUE <> 0) or ((State.Font.BkMode = OPAQUE)));

    backRect.TopLeft := Posi;
    backRect.BottomRight := Posi;
    inc(backRect.Right, Trunc(wW));
    inc(backRect.Bottom, Abs(State.Font.LogFont.lfHeight));
    NormalizeRect(backRect);

    if bOpaque then
    begin
      Set_FillColor(State.Font.BkColor);
       with BoxI(backRect) do
        Rectangle(Left, top, Width, height);
       // SetBrush;
        Fill;
    end;


    fContext.Save;
    try
      BeginText;
      fContext.translate(PosX, PosY);
       fContext.Scale(1, 1*State.getSign);
       //fContext.translate(0, ASize*2);

      fContext.move_to(0, 0);
      if State.Font.spec.angle <> 0 then
      begin
        a := State.Font.spec.angle * (PI / 180);
        fContext.rotate(-a);
      end;



      if Supports(lfont, ICairoScaledfont, lScaleFont) then
      begin
       fContext.setColor(State.Font.color);
       fContext.text_Clusters(ltext,   lScaleFont);
      end
       else
       fContext.Text_Path(lText);
      EndText;

      // Here we Should Draw underline etc.....

      if State.Font.LogFont.lfUnderline <> 0 then
        DrawLine(ASize / 8);
      if State.Font.LogFont.lfStrikeOut <> 0 then
        DrawLine(-ASize / 3);
    finally
      fContext.Restore;
    end;

    if (State.Font.align and TA_UPDATECP) = TA_UPDATECP then
    begin
      State.Position.x := Posi.x + Trunc(wW);
      State.Position.y := Posi.y;
    end;

  end;
end;

constructor TEmfEnum.Create(aContext: ICairoContext);
begin
  inherited Create;
  fWorldFactorx := 1;
  fWorldFactory := 1;

  FDevScaleY := 1;
  FDevScaleX := 1;
  FFactor := 1;
  FFactorX := 1;
  FFactorY := 1;
  FOffsetX := 1;
  FOffsetY := 1;

  fContext := aContext;
  fStates := TObjectList<TEmfEnumState>.Create(true);
  fStates.Add(TEmfEnumState.Create);
  fHandleObjects := TDictionary<integer, TEmfHandleObj>.Create;
end;

destructor TEmfEnum.Destroy;
begin
  fHandleObjects := nil;
  fStates.Free;
  inherited;
end;

procedure TEmfEnum.close_path;
begin
  fContext.close_path;
end;

procedure TEmfEnum.Fill;
begin
  fContext.Fill;
end;

procedure TEmfEnum.new_path;
begin
  fContext.new_path;
end;

function TEmfEnum.State: TEmfEnumState;
begin
  Result := fStates.Last;
end;

procedure TEmfEnum.Stroke;
begin
  SetPen;
  fContext.Stroke;
end;

procedure TEmfEnum.Save;
begin
  fContext.Save;
  fStates.Add(State.CreateCopy);
end;

procedure TEmfEnum.Restore;
begin
  fContext.Restore;
  if fStates.Count > 1 then
    fStates.Remove(fStates.Last);
  fContext.set_matrix(State.ActualCairoMatrix);
end;

procedure TEmfEnum.Set_miter_limit(Value: Double);
begin
  if Value > 0.1 then
    fContext.miter_limit := Value;
end;

procedure TEmfEnum.Rectangle(x, y, Width, Height: Double);
begin
  fContext.Rectangle(x, y, Width, Height);
end;

procedure TEmfEnum.Clip;
begin

end;

procedure TEmfEnum.Ellipse(x, y, Width, Height: Double);
var
  x2, y2: Double;
begin
  x2 := x + Width;
  y2 := y + Height;
  fContext.ArcDraw(acArc, x, y, x2, y2, x2, y2, x2, y2, x2, y2);
end;

procedure TEmfEnum.LineToI(x, y: Double);
begin
  fContext.line_to(x, y);
end;

procedure TEmfEnum.LineToI(x, y: integer);
begin
  fContext.line_to(x, y);
end;

procedure TEmfEnum.MoveToI(x, y: Double);
begin
  fContext.move_to(x, y);
end;

procedure TEmfEnum.MoveToI(x, y: integer);
begin
  fContext.move_to(x, y);
end;

procedure TEmfEnum.CurveToCI(x1, y1, x2, y2, x3, y3: Double);
begin
  fContext.curve_to(x1, y1, x2, y2, x3, y3);
end;

procedure TEmfEnum.RoundRectI(x1, y1, x2, y2, cx, cy: Double);
begin
  cx := cx / 2;
  cy := cy / 2;
  MoveToI(x1 + cx, y1);
  LineToI(x2 - cx, y1);
  CurveToCI(x2 - cx + BEZIER * cx, y1, x2, y1 + cy - BEZIER * cy, x2, y1 + cy);
  LineToI(x2, y2 - cy);
  CurveToCI(x2, y2 - cy + BEZIER * cy, x2 - cx + BEZIER * cx, y2, x2 - cx, y2);
  LineToI(x1 + cx, y2);
  CurveToCI(x1 + cx - BEZIER * cx, y2, x1, y2 - cy + BEZIER * cy, x1, y2 - cy);
  LineToI(x1, y1 + cy);
  CurveToCI(x1, y1 + cy - BEZIER * cy, x1 + cx - BEZIER * cx, y1, x1 + cx, y1);
  close_path;;
end;

procedure TEmfEnum.ARCI(centerx, centery, W, H, Sx, Sy, Ex, Ey: integer; clockwise: boolean; arctype: TCairoArcType; var Position: TPoint);
Var px, py : double;
begin
 fContext.ArcDraw(arctype,  centerx-w /2, centery-h/2, centerx+w/2, centery+h/2, sx, sy, ex, ey, px, py);
 State.Position.x := round(px);
 State.Position.y := round(py);

end;

function TEmfEnum.BoxI(Box: TRect): TEmfBox;
begin
  NormalizeRect(Box);
  Result.Left := Box.Left;
  Result.Top := Box.Top;
  Result.Width := Box.Width;
  Result.Height := Box.Height;
end;

procedure TEmfEnum.BeginText;
begin

end;

procedure TEmfEnum.EndText;
begin
  Set_FillColor(State.Font.color);
  fContext.Fill;
end;

function TEmfEnum.Get_FNewPath: boolean;
begin
  Result := fnewpath;
end;

procedure TEmfEnum.Set_FNewPath(const Value: boolean);
begin
  fnewpath := Value;
end;

procedure TEmfEnum.SizePosChanged;
begin
  fContext.set_matrix(State.ActualCairoMatrix);
end;

procedure TEmfEnum.EMF_CreatePen(const Value: TEMRCreatePen);
Var lhandleObject: TEmfHandleObj;
begin
  lhandleObject.kind := OBJ_PEN;
  lhandleObject.Pen.color := Value.lopn.lopnColor;
  lhandleObject.Pen.Width := Value.lopn.lopnWidth.x;
  lhandleObject.Pen.style := Value.lopn.lopnStyle;
  Set_OBJ(Value.ihPen - 1, lhandleObject);
end;

procedure TEmfEnum.EMF_CreateBrushIndirect(const Value: TEMRCreateBrushIndirect);
Var lhandleObject: TEmfHandleObj;
begin
  lhandleObject.kind := OBJ_BRUSH;

  lhandleObject.Brush.color := Value.lb.lbColor;
  lhandleObject.Brush.null := (Value.lb.lbStyle = BS_NULL);
  lhandleObject.Brush.style := Value.lb.lbStyle;

  Set_OBJ(Value.ihBrush - 1, lhandleObject);

end;

procedure TEmfEnum.EMF_DeleteObject(const Value: DWORD);
begin
  if fHandleObjects.ContainsKey(Value - 1) then
    fHandleObjects.Remove(Value - 1);
end;

procedure TEmfEnum.EMF_MOVETOEX(const Value: EMRMoveToEx);
begin
  State.Position := Value.ptl; // temp var to ignore unused moves
  if IsNewPath then
  begin
    MoveToI(State.Position.x, State.Position.y);
    State.Moved := true;
  end
  else
    State.Moved := False;
end;

procedure TEmfEnum.EMF_LINETO(const Value: EMRLINETO);
begin
  if (not IsNewPath) and (not State.Moved) then
    MoveToI(State.Position.x, State.Position.y);
  LineToI(Value.ptl.x, Value.ptl.y);
  State.Position := Value.ptl;
  State.Moved := False;
  fInlined := true;
  if not IsNewPath then
    if not State.Pen.null then
      Stroke;
end;

procedure TEmfEnum.EMF_Rectangle(const Value: EMRRectangle);
begin
  with BoxI(Value.rclBox) do
    Rectangle(Left, Top, Width, Height);
  FillStroke;
end;

procedure TEmfEnum.EMF_Ellipse(const Value: EMRELLIPSE);
begin
  with BoxI(Value.rclBox) do
    Ellipse(Left, Top, Width, Height);
  FillStroke;
end;

procedure TEmfEnum.EMF_Roundrect(const Value: EMRROUNDRECT);
Var lTemp: TRect;
begin
  lTemp := Value.rclBox;
  NormalizeRect(lTemp);
  RoundRectI(lTemp.Left, lTemp.Top, lTemp.Right, lTemp.Bottom, Value.szlCorner.cx, Value.szlCorner.cy);
  FillStroke;
end;

procedure TEmfEnum.EMF_Arc(Value: EMRARC);
begin
  NormalizeRect(Value.rclBox);
  with Value, CenterPoint(rclBox) do
    ARCI(x, y, rclBox.Right - rclBox.Left, rclBox.Bottom - rclBox.Top, ptlStart.x, ptlStart.y, ptlEnd.x, ptlEnd.y,
      State.ArcDirection = AD_CLOCKWISE, acArc, State.Position);
  if not State.Pen.null then
    Stroke;
end;

procedure TEmfEnum.EMF_ArcTo(Value: EMRArcTo);
begin
  NormalizeRect(Value.rclBox);
  if (not IsNewPath) and (not State.Moved) then
    MoveToI(State.Position.x, State.Position.y);
  with Value, CenterPoint(rclBox) do
  begin
    ARCI(x, y, rclBox.Right - rclBox.Left, rclBox.Bottom - rclBox.Top, ptlStart.x, ptlStart.y, ptlEnd.x, ptlEnd.y,
      State.ArcDirection = AD_CLOCKWISE, acArcTo, State.Position);
    State.Moved := False;
    fInlined := true;
    if not IsNewPath then
      if not State.Pen.null then
        Stroke;
  end;
end;

procedure TEmfEnum.EMF_Pie(Value: EMRPie);
begin
  NormalizeRect(Value.rclBox);
  with Value, CenterPoint(rclBox) do
    ARCI(x, y, rclBox.Right - rclBox.Left, rclBox.Bottom - rclBox.Top, ptlStart.x, ptlStart.y, ptlEnd.x, ptlEnd.y,
      State.ArcDirection = AD_CLOCKWISE, acPie, State.Position);
  if State.Pen.null then
    Fill
  else
    FillStroke;
end;

procedure TEmfEnum.EMF_Chord(Value: EMRChord);
begin
  NormalizeRect(Value.rclBox);
  with Value, CenterPoint(rclBox) do
    ARCI(x, y, rclBox.Right - rclBox.Left, rclBox.Bottom - rclBox.Top, ptlStart.x, ptlStart.y, ptlEnd.x, ptlEnd.y,
      State.ArcDirection = AD_CLOCKWISE, acChoord, State.Position);
  if State.Pen.null then
    Fill
  else
    FillStroke;
end;

procedure TEmfEnum.EMF_FillRGN(Value: EMRFillRgn);
begin
  EMF_SelectObjectFromIndex(Value.ihBrush);
  FillRectangle(PRgnDataHeader(@Value.RgnData[0])^.rcBound, False);
end;

procedure TEmfEnum.EMF_POLYGON(const Value: EMRPolyLine);
var
  i: integer;
begin
  if not(State.Brush.null) or (not State.Pen.null) then
  begin
    MoveToI(Value.aptl[0].x, Value.aptl[0].y);
    for i := 1 to Value.cptl - 1 do
      LineToI(Value.aptl[i].x, Value.aptl[i].y);
    if Value.cptl > 0 then
      State.Position := Value.aptl[Value.cptl - 1]
    else
      State.Position := Value.aptl[0];

    State.Moved := False;
    close_path;
    FillStroke;

  end;
end;

procedure TEmfEnum.EMF_POLYGON16(const Value: EMRPolyLine16);
var
  i: integer;
begin
  if not(State.Brush.null) or (not State.Pen.null) then
  begin
    MoveToI(Value.apts[0].x, Value.apts[0].y);
    if Value.cpts > 0 then
    begin
      for i := 1 to Value.cpts - 1 do
        LineToI(Value.apts[i].x, Value.apts[i].y);
      with Value.apts[Value.cpts - 1] do
      begin
        State.Position.x := x;
        State.Position.y := y;
      end;
    end
    else
    begin
      State.Position.x := Value.apts[0].x;
      State.Position.y := Value.apts[0].y;
    end;
    State.Moved := False;
    close_path;
    FillStroke;

  end;
end;

procedure TEmfEnum.EMF_POLYLINE(const Value: EMRPolyLine);
var
  i: integer;
begin
  if (not State.Pen.null) then
  begin
    MoveToI(Value.aptl[0].x, Value.aptl[0].y);
    for i := 1 to Value.cptl - 1 do
      LineToI(Value.aptl[i].x, Value.aptl[i].y);
    if Value.cptl > 0 then
      State.Position := Value.aptl[Value.cptl - 1]
    else
      State.Position := Value.aptl[0];

    State.Moved := False;
    Stroke;

  end;
end;

procedure TEmfEnum.EMF_POLYLINE16(const Value: EMRPolyLine16);
var
  i: integer;
begin
  if (not State.Pen.null) then
  begin

    MoveToI(Value.apts[0].x, Value.apts[0].y);
    if Value.cpts > 0 then
    begin
      for i := 1 to Value.cpts - 1 do
        LineToI(Value.apts[i].x, Value.apts[i].y);
      with Value.apts[Value.cpts - 1] do
      begin
        State.Position.x := x;
        State.Position.y := y;
      end;
    end
    else
    begin
      State.Position.x := Value.apts[0].x;
      State.Position.y := Value.apts[0].y;
    end;
    State.Moved := False;
    Stroke;
  end;
end;

procedure TEmfEnum.EMF_POLYBEZIER(const Value: EMRPolyBezier);
var
  i: integer;
begin
  MoveToI(Value.aptl[0].x, Value.aptl[0].y);
  for i := 0 to (Value.cptl div 3) - 1 do
    CurveToCI(Value.aptl[i * 3 + 1].x, Value.aptl[i * 3 + 1].y, Value.aptl[i * 3 + 2].x, Value.aptl[i * 3 + 2].y, Value.aptl[i * 3 + 3].x,
      Value.aptl[i * 3 + 3].y);
  if Value.cptl > 0 then
    State.Position := Value.aptl[Value.cptl - 1]
  else
    State.Position := Value.aptl[0];
  State.Moved := False;
  if not IsNewPath then
    if not State.Pen.null then
      Stroke
    else
      new_path;
end;

procedure TEmfEnum.EMF_POLYBEZIER16(const Value: EMRPolyBezier16);
var
  i: integer;
begin
  MoveToI(Value.apts[0].x, Value.apts[0].y);
  if Value.cpts > 0 then
  begin
    for i := 0 to (Value.cpts div 3) - 1 do
      CurveToCI(Value.apts[i * 3 + 1].x, Value.apts[i * 3 + 1].y, Value.apts[i * 3 + 2].x, Value.apts[i * 3 + 2].y, Value.apts[i * 3 + 3].x,
        Value.apts[i * 3 + 3].y);
    with Value.apts[Value.cpts - 1] do
    begin
      State.Position.x := x;
      State.Position.y := y;
    end;
  end
  else
  begin
    State.Position.x := Value.apts[0].x;
    State.Position.y := Value.apts[0].y;
  end;
  State.Moved := False;
  if not IsNewPath then
    if not State.Pen.null then
      Stroke
    else
      new_path;
end;

procedure TEmfEnum.EMF_POLYBEZIERTO(const Value: EMRPolyBezierTo);
var
  i: integer;
begin
  if not IsNewPath then
    if not State.Moved then
      MoveToI(State.Position.x, State.Position.y);
  if Value.cptl > 0 then
  begin
    for i := 0 to (Value.cptl div 3) - 1 do
      CurveToCI(Value.aptl[i * 3].x, Value.aptl[i * 3].y, Value.aptl[i * 3 + 1].x, Value.aptl[i * 3 + 1].y, Value.aptl[i * 3 + 2].x,
        Value.aptl[i * 3 + 2].y);
    State.Position := Value.aptl[Value.cptl - 1];
  end;
  State.Moved := False;
  if not IsNewPath then
    if not State.Pen.null then
      Stroke
    else
      new_path;
end;

procedure TEmfEnum.EMF_POLYBEZIERTO16(const Value: EMRPolyBezierTo16);
var
  i: integer;
begin
  if not IsNewPath then
    if not State.Moved then
      MoveToI(State.Position.x, State.Position.y);
  if Value.cpts > 0 then
  begin
    for i := 0 to (Value.cpts div 3) - 1 do
      CurveToCI(Value.apts[i * 3].x, Value.apts[i * 3].y, Value.apts[i * 3 + 1].x, Value.apts[i * 3 + 1].y, Value.apts[i * 3 + 2].x,
        Value.apts[i * 3 + 2].y);
    with Value.apts[Value.cpts - 1] do
    begin
      State.Position.x := x;
      State.Position.y := y;
    end;
  end;
  State.Moved := False;
  if not IsNewPath then
    if not State.Pen.null then
      Stroke
    else
      new_path;
end;

procedure TEmfEnum.EMF_POLYLINETO(const Value: EMRPolyLineTO);
var
  i: integer;
begin
  if not IsNewPath then
  begin
    new_path;
    if State.Moved then
      MoveToI(State.Position.x, State.Position.y);
  end;
  begin
    if Value.cptl > 0 then
    begin
      for i := 0 to Value.cptl - 1 do
        LineToI(Value.aptl[i].x, Value.aptl[i].y);
      State.Position := Value.aptl[Value.cptl - 1];
    end;
  end;


  State.Moved := False;
  if not IsNewPath then
    if not State.Pen.null then
      Stroke
    else
      new_path;
end;

procedure TEmfEnum.EMF_POLYLINETO16(const Value: EMRPolyLineTO16);
var
  i: integer;
begin

  if not IsNewPath then
  begin
    new_path;
    if not State.Moved then
      MoveToI(State.Position.x, State.Position.y);
  end;

  if Value.cpts > 0 then
  begin
    for i := 0 to Value.cpts - 1 do
      LineToI(Value.apts[i].x, Value.apts[i].y);
    with Value.apts[Value.cpts - 1] do
    begin
      State.Position.x := x;
      State.Position.y := y;
    end;
  end;
  State.Moved := False;
  if not IsNewPath then
    if not State.Pen.null then
    begin
      Stroke;
    end
    else
      new_path;
end;

procedure TEmfEnum.EMF_POLYDRAW(const R: PEnhMetaRecord);
type
  PByteArray = ^TByteArray;
  TByteArray = array [0 .. MaxInt - 1] of Byte; // redefine here with {$R-}
var
  i: integer;
  polytypes: PByteArray;
begin
  if PEMRPolyDraw(R)^.cptl > 0 then
  begin

    polytypes := @PEMRPolyDraw(R)^.aptl[PEMRPolyDraw(R)^.cptl];
    i := 0;
    while i < integer(PEMRPolyDraw(R)^.cptl) do
    begin
      case polytypes^[i] and not PT_CLOSEFIGURE of
        PT_LINETO:
          begin
            LineToI(PEMRPolyDraw(R)^.aptl[i].x, PEMRPolyDraw(R)^.aptl[i].y);
            if polytypes^[i] and PT_CLOSEFIGURE <> 0 then
            begin
              LineToI(State.Position.x, State.Position.y);
              State.Position := PEMRPolyDraw(R)^.aptl[i];
            end;
          end;
        PT_BEZIERTO:
          begin
            CurveToCI(PEMRPolyDraw(R)^.aptl[i + 1].x, PEMRPolyDraw(R)^.aptl[i + 1].y, PEMRPolyDraw(R)^.aptl[i + 2].x,
              PEMRPolyDraw(R)^.aptl[i + 2].y, PEMRPolyDraw(R)^.aptl[i + 3].x, PEMRPolyDraw(R)^.aptl[i + 3].y);
            inc(i, 3);
            if polytypes^[i] and PT_CLOSEFIGURE <> 0 then
            begin
              LineToI(State.Position.x, State.Position.y);
              State.Position := PEMRPolyDraw(R)^.aptl[i];
            end;
          end;
        PT_MOVETO:
          begin
            MoveToI(PEMRPolyDraw(R)^.aptl[i].x, PEMRPolyDraw(R)^.aptl[i].y);
            State.Position := PEMRPolyDraw(R)^.aptl[i];
          end;
      else break; // invalid type
      end;
      inc(i);
    end;
    State.Position := PEMRPolyDraw(R)^.aptl[PEMRPolyDraw(R)^.cptl - 1];
    State.Moved := False;
    if not IsNewPath then
      if not State.Pen.null then
      begin
        Stroke;
      end
      else
        new_path;
  end;

end;

procedure TEmfEnum.EMF_POLYDRAW16(const R: PEnhMetaRecord);
type
  PByteArray = ^TByteArray;
  TByteArray = array [0 .. MaxInt - 1] of Byte; // redefine here with {$R-}
var
  i: integer;
  polytypes: PByteArray;
begin
  if PEMRPolyDraw16(R)^.cpts > 0 then
  begin

    polytypes := @PEMRPolyDraw16(R)^.apts[PEMRPolyDraw16(R)^.cpts];
    i := 0;
    while i < integer(PEMRPolyDraw16(R)^.cpts) do
    begin
      case polytypes^[i] and not PT_CLOSEFIGURE of
        PT_LINETO:
          begin
            LineToI(PEMRPolyDraw16(R)^.apts[i].x, PEMRPolyDraw16(R)^.apts[i].y);
            if polytypes^[i] and PT_CLOSEFIGURE <> 0 then
            begin
              LineToI(State.Position.x, State.Position.y);
              with PEMRPolyDraw16(R)^.apts[i] do
              begin
                State.Position.x := x;
                State.Position.y := y;
              end;
            end;
          end;
        PT_BEZIERTO:
          begin
            CurveToCI(PEMRPolyDraw16(R)^.apts[i + 1].x, PEMRPolyDraw16(R)^.apts[i + 1].y, PEMRPolyDraw16(R)^.apts[i + 2].x,
              PEMRPolyDraw16(R)^.apts[i + 2].y, PEMRPolyDraw16(R)^.apts[i + 3].x, PEMRPolyDraw16(R)^.apts[i + 3].y);
            inc(i, 3);
            if polytypes^[i] and PT_CLOSEFIGURE <> 0 then
            begin
              LineToI(State.Position.x, State.Position.y);
              with PEMRPolyDraw16(R)^.apts[i] do
              begin
                State.Position.x := x;
                State.Position.y := y;
              end;
            end;
          end;
        PT_MOVETO:
          begin
            MoveToI(PEMRPolyDraw16(R)^.apts[i].x, PEMRPolyDraw16(R)^.apts[i].y);
            with PEMRPolyDraw16(R)^.apts[i] do
            begin
              State.Position.x := x;
              State.Position.y := y;
            end;
          end;
      else break; // invalid type
      end;
      inc(i);
    end;
    with PEMRPolyDraw16(R)^.apts[PEMRPolyDraw16(R)^.cpts - 1] do
    begin
      State.Position.x := x;
      State.Position.y := y;
    end;
    State.Moved := False;
    if not IsNewPath then
      if not State.Pen.null then
      begin
        Stroke;
      end
      else
        new_path;
  end;


end;

procedure TEmfEnum.EMF_BITBLT(Value: PEMRBITBLT);
begin
  with Value^ do // only handle RGB bitmaps (no palette)
    if (offBmiSrc <> 0) and (offBitsSrc <> 0) then
    begin
      DrawBitmap(xSrc, ySrc, cxDest, cyDest, xDest, yDest, cxDest, cyDest, iUsageSrc, pointer(PtrUInt(Value) + offBmiSrc),
        pointer(PtrUInt(Value) + offBitsSrc), @Value^.rclBounds, @Value^.xformSrc, Value^.dwRop);
    end
    else
      case Value^.dwRop of // we only handle PATCOPY = fillrect
        PATCOPY:
          with Value^ do
            FillRectangle(Rect(xDest, yDest, xDest + cxDest, yDest + cyDest), true);
      end;
end;

procedure TEmfEnum.EMF_STRETCHBLT(Value: PEMRStretchBlt);
begin
  with PEMRStretchBlt(Value)^ do // only handle RGB bitmaps (no palette)
    if (offBmiSrc <> 0) and (offBitsSrc <> 0) then
    begin
      DrawBitmap(xSrc, ySrc, cxSrc, cySrc, xDest, yDest, cxDest, cyDest, iUsageSrc, pointer(PtrUInt(Value) + offBmiSrc),
        pointer(PtrUInt(Value) + offBitsSrc), @PEMRStretchBlt(Value)^.rclBounds, @PEMRStretchBlt(Value)^.xformSrc,
        PEMRStretchBlt(Value)^.dwRop);
    end
    else
      case PEMRStretchBlt(Value)^.dwRop of // we only handle PATCOPY = fillrect
        PATCOPY:
          with PEMRStretchBlt(Value)^ do
            FillRectangle(Rect(xDest, yDest, xDest + cxDest, yDest + cyDest), true);
      end;
end;

procedure TEmfEnum.EMF_STRETCHDIBITS(Value: PEMRStretchDIBits);
begin
  with PEMRStretchDIBits(Value)^ do // only handle RGB bitmaps (no palette)
    if (offBmiSrc <> 0) and (offBitsSrc <> 0) then
    begin
      if State.WorldTransform.yy < 0 then
        with PBitmapInfo(PtrUInt(Value) + offBmiSrc)^ do
          bmiHeader.biHeight := -bmiHeader.biHeight;
      DrawBitmap(xSrc, ySrc, cxSrc, cySrc, xDest, yDest, cxDest, cyDest, iUsageSrc, pointer(PtrUInt(Value) + offBmiSrc),
        pointer(PtrUInt(Value) + offBitsSrc), @PEMRStretchDIBits(Value)^.rclBounds, nil, PEMRStretchDIBits(Value)^.dwRop);
    end;
end;

procedure TEmfEnum.EMF_TRANSPARENTBLT(Value: PEMRTransparentBLT);
begin
  with PEMRTransparentBLT(Value)^ do // only handle RGB bitmaps (no palette)
    if (offBmiSrc <> 0) and (offBitsSrc <> 0) then
      DrawBitmap(xSrc, ySrc, cxSrc, cySrc, xDest, yDest, cxDest, cyDest, iUsageSrc, pointer(PtrUInt(Value) + offBmiSrc),
        pointer(PtrUInt(Value) + offBitsSrc), @PEMRTransparentBLT(Value)^.rclBounds, @PEMRTransparentBLT(Value)^.xformSrc, SRCCOPY,
        PEMRTransparentBLT(Value)^.dwRop); // dwRop stores the transparent color
end;

procedure TEmfEnum.EMF_GDICOMMENT(const Value: EMRGDICOMMENT);
begin
  if Value.cbData > 1 then
    HandleComment(TEmfGDIComment(Value.data[0]), PAnsiChar(@Value.data) + 1, Value.cbData - 1);
end;

procedure TEmfEnum.EMF_ExtCreatePen(const Value: TEMRExtCreatePen);
Var lhandleObject: TEmfHandleObj;
begin
  lhandleObject.kind := OBJ_PEN;
  lhandleObject.Pen.color := Value.elp.elpColor;
  lhandleObject.Pen.Width := Value.elp.elpWidth;
  lhandleObject.Pen.style := Value.elp.elpPenStyle and (PS_STYLE_MASK or PS_ENDCAP_MASK);
  Set_OBJ(Value.ihPen - 1, lhandleObject);
end;

procedure TEmfEnum.EMF_BeginPath;
begin
  new_path;
  if not State.Moved then
  begin
    MoveToI(State.Position.x, State.Position.y);
    State.Moved := true;
  end;
end;

procedure TEmfEnum.EMF_EndPath;
begin
  IsNewPath := False;
end;

procedure TEmfEnum.EMF_AbortPath;
begin
  new_path;
  IsNewPath := False;
end;

procedure TEmfEnum.EMF_FillPath;
begin
  if not State.Brush.null then
  begin
    SetBrush;
    Fill;
  end;
  new_path;
  IsNewPath := False;
end;

procedure TEmfEnum.EMF_StrokePath;
begin
  if not State.Pen.null then
  begin
    Stroke;
  end;
  new_path;
  IsNewPath := False;
end;

procedure TEmfEnum.EMF_StrokeAndFillPath;
begin
  FillStroke;
  new_path;
  IsNewPath := False;
end;

procedure TEmfEnum.EMF_SetPixel;
begin
  // // prepare pixel size and color
  // if pen.Width <> 1 then
  // begin
  // E.fPenWidth := E.Canvas.GetWorldFactorX * E.Canvas.FDevScaleX;
  // E.Canvas.Set_line_width(E.fPenWidth * E.Canvas.FFactorX);
  // end;
  // if PEMRSetPixelV(R)^.crColor <> cardinal(pen.color) then
  // E.Canvas.SetRGBStrokeColor(PEMRSetPixelV(R)^.crColor);
  // // draw point
  // Position := Point(PEMRSetPixelV(R)^.ptlPixel.X, PEMRSetPixelV(R)^.ptlPixel.Y);
  // E.Canvas.PointI(Position.X, Position.Y);
  // E.Canvas.Stroke;
  // Moved := false;
  // // roll back pixel size and color
  // if pen.Width <> 1 then
  // begin
  // E.fPenWidth := pen.Width * E.Canvas.GetWorldFactorX * E.Canvas.FDevScaleX;
  // E.Canvas.Set_line_width(E.fPenWidth * E.Canvas.FFactorX);
  // end;
  // if PEMRSetPixelV(R)^.crColor <> cardinal(pen.color) then
  // E.Canvas.SetRGBStrokeColor(pen.color);
end;

procedure TEmfEnum.EMF_SaveDC;
begin
  Save;
end;

procedure TEmfEnum.EMF_RestoreDC;
begin
  Restore;
end;

procedure TEmfEnum.EMF_Set_miter_limit(Value: Single);
begin
  Set_miter_limit(Value);
end;

procedure TEmfEnum.EMF_CLosePath;
begin
  close_path;
end;

procedure TEmfEnum.EMF_GradientFill(data: PEMGradientFill);
begin

end;

procedure TEmfEnum.EMF_TextOut(var R: TEMRExtTextOut);
begin
  TextOut(R);
end;

procedure TEmfEnum.EMF_IntersectClipRect(const ClpRect: TRect);
begin
  State.ClipRgn := IntersectClipRect(BoxI(ClpRect), State.ClipRgn);
end;

procedure TEmfEnum.EMF_SetMapMode(Value: DWORD);
begin
  State.MappingMode := Value;
  SizePosChanged;
end;

procedure TEmfEnum.EMF_SETPOLYFILLMODE(Value: DWORD);
begin
  State.PolyFillMode := Value;
end;

procedure TEmfEnum.EMF_SetStretchBltMode(Value: DWORD);
begin
  State.StretchBltMode := Value;
end;

procedure TEmfEnum.EMF_SetArcDirection(Value: DWORD);
begin
  State.ArcDirection := Value;
  case Value  of
    AD_COUNTERCLOCKWISE : fContext.ArcDirection := counterclockwise;
    AD_CLOCKWISE : fContext.ArcDirection := clockwise;
  end;
end;

procedure TEmfEnum.SetMetaRgn;

begin
  if not State.ClipRgnNull then
  begin
    State.MetaRgn := IntersectClipRect(State.ClipRgn, State.MetaRgn);
    State.ClipRgn := EmptyEmfbox;
    State.ClipRgnNull := true;
  end;
end;

{ TEmfEnumState }

procedure TEmfEnumState.AssignFrom(aEmf: TEmfEnumState);
begin
  Position := aEmf.Position;
  Moved := aEmf.Moved;
  WinSize := aEmf.WinSize;
  ViewSize := aEmf.ViewSize;
  WinOrg := aEmf.WinOrg;
  ViewOrg := aEmf.ViewOrg;
  WorldTransform := aEmf.WorldTransform;
  MetaRgn := aEmf.MetaRgn;
  ClipRgn := aEmf.MetaRgn;
  ClipRgnNull := aEmf.ClipRgnNull;
  FMappingMode := aEmf.FMappingMode;
  PolyFillMode := aEmf.PolyFillMode;
  StretchBltMode := aEmf.StretchBltMode;
  ArcDirection := aEmf.ArcDirection;
  Pen := aEmf.Pen;
  Brush := aEmf.Brush;
  Font := aEmf.Font;
end;

function TEmfEnumState.CreateCopy: TEmfEnumState;
begin
  Result := TEmfEnumState.Create;
  Result.AssignFrom(self);
end;

procedure TEmfEnumState.Set_MappingMode(const Value: integer);
begin
  if Value <> FMappingMode then
  begin
    (*
      {$EXTERNALSYM MM_TEXT}
      MM_TEXT = 1;
      {$EXTERNALSYM MM_LOMETRIC}
      MM_LOMETRIC = 2;
      {$EXTERNALSYM MM_HIMETRIC}
      MM_HIMETRIC = 3;
      {$EXTERNALSYM MM_LOENGLISH}
      MM_LOENGLISH = 4;
      {$EXTERNALSYM MM_HIENGLISH}
      MM_HIENGLISH = 5;
      {$EXTERNALSYM MM_TWIPS}
      MM_TWIPS = 6;
      {$EXTERNALSYM MM_ISOTROPIC}
      MM_ISOTROPIC = 7;
      {$EXTERNALSYM MM_ANISOTROPIC}
      MM_ANISOTROPIC = 8;
    *)
    FMappingMode := Value;
    CalculateMatrix;
  end;
end;

procedure TEmfEnumState.Set_ViewSize(const Value: TSize);
begin
  FViewSize := Value;
  CalculateMatrix;
end;

procedure TEmfEnumState.Set_WinSize(const Value: TSize);
begin
  FWinSize := Value;
  CalculateMatrix;
end;

constructor TEmfEnumState.Create;
begin
  inherited Create;
  FMappingMode := 1; // MMtext
  FViewSize.cx := 96;
  FViewSize.cy := 96;
  FWinSize.cx := 96;
  FWinSize.cy := 96;
  FBaseTransform.init_identity;
  FWorldTransform.init_identity;
  FActualTransform.init_identity;
end;

function TEmfEnumState.Get_WorldTransform: cairo_matrix_t;
begin
  Result := FWorldTransform.Matrix^;
end;

procedure TEmfEnumState.Set_WorldTransform(const Value: cairo_matrix_t);
begin
  FWorldTransform.initWithMatrix(Value);
end;

procedure TEmfEnumState.CalculateMatrix;
Var fscale : Double;
begin

  case FMappingMode of
    MM_TEXT: FBaseTransform.init_identity;

     MM_LOMETRIC : begin
      fScale := 960 / 2540;
      FBaseTransform.init_identity;
        FBaseTransform.translate(ViewOrg.x, -ViewOrg.y);
        FBaseTransform.scale(Fscale, -fscale);

    end;

    MM_HIMETRIC : begin
      fScale := 96 / 2540;
      FBaseTransform.init_identity;
        FBaseTransform.translate(ViewOrg.x, -ViewOrg.y);
        FBaseTransform.scale(Fscale, -fscale);

    end;
    MM_ANISOTROPIC:
      begin
        FBaseTransform.init_identity;
        FBaseTransform.translate(ViewOrg.x, ViewOrg.y);
        FBaseTransform.scale(FViewSize.cx / FWinSize.cx, FViewSize.cy / FWinSize.cy);
      end;
  else FBaseTransform.init_identity;
  end;

  FActualTransform.multiply(FBaseTransform, FWorldTransform);

end;

function TEmfEnumState.getActualMatrix: pCairo_Matrix_t;
begin
  CalculateMatrix;
  Result := FActualTransform.Matrix;
end;

procedure TEmfEnum.EMF_ANGLEARC(const Value: EMRANGLEARC);
begin
  if (not IsNewPath) and (not State.Moved) then
    MoveToI(State.Position.x, State.Position.y);
  fcontext.arc_negative(Value.ptlCenter.x, Value.ptlCenter.Y, Value.nRadius,
  degtoRad(-Value.eStartAngle), degtoRad(-(Value.eStartAngle   + Value.eSweepAngle)));
  FillStroke;
end;

function TEmfEnumState.getSign: Integer;
begin
 if FMappingMode in [MM_LOMETRIC..MM_HIENGLISH ] then
  result := -1
  else result :=1;

end;

end.
