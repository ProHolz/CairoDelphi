unit Cairo.Context;

interface
 {$HINTS OFF}
uses
  System.UITypes,
  Cairo.Types,
  Cairo.Interfaces,
  Cairo.Base,
  Cairo.Surface,
  Cairo.Pattern,
  Cairo.Font;

type
  // Arc


  // DEVICE

  TcaSystem = class
  public
    class procedure debug_reset_static_data(); static;
    class function status_to_string(status: cairo_status_t): string; static;
    class function version: Integer; static;
    class function version_string(): string; static;
  end;

  TContext = class(TInterfacedObject, ICairoContext)
  strict private
    function Get_Handle: Pcairo_t;
    procedure Set_target(const Value: ICairoSurface);
  private const
    clsDash: array of Double = [18, 6];
    clsDashDot: array of Double = [8, 7, 3, 7];
    clsDashDotDot: array of Double = [8, 4, 3, 4, 3, 4];
    clsDot: array of Double = [3, 3];

   private type
    TPointD = record
      x, y: double;
    end;

  var
    fcr: Pcairo_t;
    FPenPos: TPointD;
    FArcDirection: TCairoArcDirection;

{$REGION 'GroupSupport '}
    procedure push_group();
    procedure push_group_with_content(content: cairo_content_t);
    function pop_group(): Pcairo_pattern_t;
    procedure pop_group_to_source();
    function get_group_target: Pcairo_surface_t;
{$ENDREGION}
{$REGION 'not Public'}
    function reference(): Pcairo_t;
    function get_reference_count(): Cardinal;

    function get_user_data(key: Pcairo_user_data_key_t): Pointer;
    function set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t)
      : cairo_status_t;

    procedure tag_begin(tag_name: PUTF8Char; attributes: PUTF8Char);
    procedure tag_end(tag_name: PUTF8Char);




{$ENDREGION}
{$REGION 'Fills and Lines'}
    procedure set_antialias(const antialias: cairo_antialias_t);
    function get_antialias(): cairo_antialias_t;

    function get_fill_rule(): cairo_fill_rule_t;
    function get_line_width(): Double;
    function get_line_cap(): cairo_line_cap_t;
    function get_line_join(): cairo_line_join_t;
    function get_miter_limit(): Double;

    procedure set_fill_rule(const fill_rule: cairo_fill_rule_t);
    procedure set_line_width(const width: Double);
    procedure set_line_cap(const line_cap: cairo_line_cap_t);
    procedure set_line_join(const line_join: cairo_line_join_t);
    procedure set_miter_limit(const limit: Double);
{$ENDREGION}
{$REGION 'Fonts'}
    procedure select_font_face(family: PUTF8Char; slant: cairo_font_slant_t; weight: cairo_font_weight_t);
    procedure set_font_matrix(matrix: Pcairo_matrix_t);
    procedure get_font_matrix(matrix: Pcairo_matrix_t);
    procedure set_font_options(options: Pcairo_font_options_t);
    procedure get_font_options(options: Pcairo_font_options_t);
    procedure set_font_face(font_face: Pcairo_font_face_t);
    function get_font_face: Pcairo_font_face_t;
    procedure set_scaled_font(scaled_font: Pcairo_scaled_font_t);
    function get_scaled_font(cr: Pcairo_t): Pcairo_scaled_font_t;
    procedure show_text(utf8: PUTF8Char);
    procedure show_glyphs(glyphs: Pcairo_glyph_t; num_glyphs: Integer);
    procedure show_text_glyphs(utf8: PUTF8Char; utf8_len: Integer; glyphs: Pcairo_glyph_t; num_glyphs: Integer;
      clusters: Pcairo_text_cluster_t; num_clusters: Integer; cluster_flags: cairo_text_cluster_flags_t);

    procedure glyph_path(glyphs: Pcairo_glyph_t; num_glyphs: Integer);
    procedure text_extents(utf8: PUTF8Char; var extents: cairo_text_extents_t);
    procedure glyph_extents(glyphs: Pcairo_glyph_t; num_glyphs: Integer; extents: Pcairo_text_extents_t);
    procedure font_extents(extents: Pcairo_font_extents_t);
{$ENDREGION}
{$REGION 'no plan'}
    function get_source(): Pcairo_pattern_t;
    function has_current_point(): boolean;
    procedure get_current_point(out x: Double; out y: Double);
    function get_dash_count(): Integer;
    procedure get_dash(dashes: PDouble; offset: PDouble);
    procedure SaveCurrent;
{$ENDREGION}
{$REGION 'Device'}
    procedure user_to_device(var x: Double; var y: Double);
    procedure user_to_device_distance(var dx: Double; var dy: Double);
    procedure device_to_user(var x: Double; var y: Double);
    procedure device_to_user_distance(var dx: Double; var dy: Double);
{$ENDREGION}
{$REGION 'Line and Path'}
    // Path
    procedure path_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);

    function copy_path(): Pcairo_path_t;
    function copy_path_flat(): Pcairo_path_t;
    procedure append_path(path: Pcairo_path_t);


    procedure path_destroy(path: Pcairo_path_t);

    procedure ARCI(centerx, centery, W, H, Sx, Sy, Ex, Ey: Double; clockwise: boolean; arctype: TCairoArcType;
      out positionX, positionY: Double);
    function Get_ArcDirection: TCairoArcDirection;
    procedure Set_ArcDirection(const Value: TCairoArcDirection);

  public
    procedure ArcDraw(arctype: TCairoArcType; x1, y1, x2, y2, X3, Y3, X4, Y4:
        Double; var px, py : double); overload;
    procedure ArcDraw(arctype: TCairoArcType; x1, y1, x2, y2, X3, Y3, X4, Y4: Integer); overload;

  protected
    function get_operator(): cairo_operator_t;
    function get_target: ICairoSurface;
    function get_tolerance(): Double;
    procedure set_operator(const op: cairo_operator_t);
    procedure set_tolerance(tolerance: Double);


  public

    // Line and Fills
    procedure move_to(x: Double; y: Double);

    procedure line_to(x: Double; y: Double);
    procedure curve_to(x1: Double; y1: Double; x2: Double; y2: Double; X3: Double; Y3: Double);
    procedure arc(xc: Double; yc: Double; radius: Double; angle1: Double; angle2: Double);
    procedure arc_negative(xc: Double; yc: Double; radius: Double; angle1: Double; angle2: Double);
    procedure rel_move_to(dx: Double; dy: Double);
    procedure rel_line_to(dx: Double; dy: Double);
    procedure rel_curve_to(dx1: Double; dy1: Double; dx2: Double; dy2: Double; dx3: Double; dy3: Double);
    procedure rectangle(x: Double; y: Double; width: Double; height: Double);

    procedure circle(xc: Double; yc: Double; radius: Double);
    procedure circle_negative(xc: Double; yc: Double; radius: Double);


    // Paint
    procedure paint;
    procedure paint_with_alpha(alpha: Double);
    procedure mask(Pattern: Pcairo_pattern_t);
    procedure mask_surface(Surface: TSurface; surface_x: Double; surface_y: Double);

    // Stroke Fill
    procedure stroke;
    procedure stroke_preserve;
    procedure fill;
    procedure fill_preserve;
    procedure stroke_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);
    procedure fill_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);

    procedure copy_page;
    procedure show_page;

    function in_stroke(x: Double; y: Double): cairo_bool_t;
    function in_fill(x: Double; y: Double): cairo_bool_t;
    function in_clip(x: Double; y: Double): cairo_bool_t;
    // Clip

    procedure reset_clip;
    procedure clip;
    procedure clip_preserve;
    procedure clip_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);

    // Rectangles
    function copy_clip_rectangle_list: Pcairo_rectangle_list_t;
    procedure rectangle_list_destroy(rectangle_list: Pcairo_rectangle_list_t);

{$ENDREGION}
{$REGION 'Texout'}
    procedure text_path(const Value: string);
    procedure text_Clusters(const Value: string; scaled_font: ICairoScaledFont);
    procedure set_font_size(size: Double);
{$ENDREGION}
{$REGION 'Paths'}
    procedure new_path;
    procedure new_sub_path;
    procedure close_path;

{$ENDREGION}
{$REGION 'ctx'}
    procedure translate(tx: Double; ty: Double);
    procedure scale(Sx: Double; Sy: Double);
    procedure rotate(angle: Double);
    procedure transform(matrix: Pcairo_matrix_t);
    procedure set_matrix(matrix: Pcairo_matrix_t);
    procedure get_matrix(matrix: Pcairo_matrix_t);
    procedure identity_matrix;
{$ENDREGION}
  public
    constructor create(target: ICairoSurface);
    destructor Destroy; override;
    class function getLineStyleLength(Value: TCairoLineStyle): Double;
    procedure restore;
    procedure save;
    procedure SetCairoFont(Value: ICairoFont);
    // Helper funcs
    procedure setColor(Value: Tcolor; const alpha: Double = 1.0);
    procedure setLineStyle(Value: TCairoLineStyle);
    procedure set_dash(const dashes: array of Double; const offset: Double = 0.0);
    procedure set_source(const source: ICairoPattern);
    procedure set_source_rgb(red: Double; green: Double; blue: Double);
    procedure set_source_rgba(red: Double; green: Double; blue: Double; alpha: Double);
    procedure set_source_surface(Surface: ICairoSurface; x: Double; y: Double);
    function status: cairo_status_t;

    // Properties
    property &operator: cairo_operator_t read get_operator write set_operator;
    property antialias: cairo_antialias_t read get_antialias write set_antialias;
    property fill_rule: cairo_fill_rule_t read get_fill_rule write set_fill_rule;
    property Handle: Pcairo_t read Get_Handle;
    property line_cap: cairo_line_cap_t read get_line_cap write set_line_cap;
    property line_join: cairo_line_join_t read get_line_join write set_line_join;
    property line_width: Double read get_line_width write set_line_width;
    property miter_limit: Double read get_miter_limit write set_miter_limit;
    property target: ICairoSurface read get_target;
    property ArcDirection: TCairoArcDirection read Get_ArcDirection write Set_ArcDirection;
  end;

  TCairo_Device = class
  protected
    fDevice: Pcairo_device_t;
    function acquire: cairo_status_t;
    procedure destroy; reintroduce;   // To disable warning...
    procedure finish;
    procedure flush;
    function get_reference_count: Cardinal;
    function get_type: cairo_device_type_t;
    function get_user_data(key: Pcairo_user_data_key_t): Pointer;
    function observer_elapsed: Double;
    function observer_fill_elapsed: Double;
    function observer_glyphs_elapsed: Double;
    function observer_mask_elapsed: Double;
    function observer_paint_elapsed: Double;
    function observer_print(write_func: cairo_write_func_t; closure: Pointer): cairo_status_t;
    function observer_stroke_elapsed: Double;
    // cairo_device_
    function reference: Pcairo_device_t;
    procedure release;
    function set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t)
      : cairo_status_t;
    function status: cairo_status_t;
  end;

implementation

uses
  System.Math,
  Cairo.Dll;

{$REGION 'CURVEHELPER'}
type
  tcaRes = (caMoveto, caLine, caCurve, caPosition);

  teaDrawtype = record
    res: tcaRes;
    pts: array [0 .. 2] of record x, y: single;
  end;

end;
teaDrawArray = array of teaDrawtype;



function CalcCurveArcData(centerx, centery, W, H, Sx, Sy, Ex, Ey: Double;
    aClockWise: boolean; arctype: TCairoArcType; out res: teaDrawArray):
    boolean;
type
   TCoeff = array [0 .. 3] of double;
   TCoeffArray = array [0 .. 1, 0 .. 3] of TCoeff;

const
   twoPi = 2 * PI;
  { (* }
  // coefficients for error estimation
  // while using cubic Bézier curves for approximation
  // 0 < b/a < 1/4
   coeffsLow: TCoeffArray = (((3.85268, - 21.229, - 0.330434, 0.0127842), ( - 1.61486, 0.706564, 0.225945, 0.263682),
    ( - 0.910164, 0.388383, 0.00551445, 0.00671814), ( - 0.630184, 0.192402, 0.0098871, 0.0102527)),
    (( - 0.162211, 9.94329, 0.13723, 0.0124084), ( - 0.253135, 0.00187735, 0.0230286, 0.01264), ( - 0.0695069, - 0.0437594, 0.0120636, 0.0163087),
    ( - 0.0328856, - 0.00926032, - 0.00173573, 0.00527385)));
  // coefficients for error estimation
  // while using cubic Bézier curves for approximation
  // 1/4 <= b/a <= 1
   coeffsHigh: TCoeffArray = (((0.0899116, - 19.2349, - 4.11711, 0.183362), (0.138148, - 1.45804, 1.32044, 1.38474), (0.230903, - 0.450262, 0.219963, 0.414038),
    (0.0590565, - 0.101062, 0.0430592, 0.0204699)), ((0.0164649, 9.89394, 0.0919496, 0.00760802), (0.0191603, - 0.0322058, 0.0134667, - 0.0825018),
    (0.0156192, - 0.017535, 0.00326508, - 0.228157), ( - 0.0236752, 0.0405821, - 0.0173086, 0.176187)));
  // safety factor to convert the "best" error approximation
  // into a "max bound" error
   safety: TCoeff = (0.001, 4.98, 0.207, 0.0067);

var
   fcx, fcy: double; // center of the ellipse.
   faRad, fbRad: double; // Semi-major axis.
   feta1, feta2: double; // Start End angle of the arc.
   fx1, fy1, fx2, fy2: double; // start and and endpoint.
   fxLeft, fyUp: double; // leftmost point of the arc.
   fwidth, fheight: double; // Horizontal width of the arc. Vertical height of the arc.
   fArctype: TCairoArcType; // Indicator for center to endpoints line inclusion.
   fClockWise: boolean;

   procedure InitFuncData;
   var
      lambda1, lambda2: double;
   begin
      fcx := centerx;
      fcy := centery;
      faRad := (W - 1) / 2;
      fbRad := (H - 1) / 2;
      fArctype := arctype;
  // Calculate Rotation at Start and EndPoint
      fClockWise := aClockWise;
      if aClockWise then
         begin
            lambda1 := ArcTan2(Sy - fcy, Sx - fcx);
            lambda2 := ArcTan2(Ey - fcy, Ex - fcx);
         end
      else
         begin
            lambda2 := ArcTan2(Sy - fcy, Sx - fcx);
            lambda1 := ArcTan2(Ey - fcy, Ex - fcx);
         end;
      feta1 := ArcTan2(sin(lambda1) / fbRad, cos(lambda1) / faRad);
      feta2 := ArcTan2(sin(lambda2) / fbRad, cos(lambda2) / faRad);
  // make sure we have eta1 <= eta2 <= eta1 + 2 PI
      feta2 := feta2 - (twoPi * floor((feta2 - feta1) / twoPi));
  // the preceding correction fails if we have exactly et2 - eta1 = 2 PI
  // it reduces the interval to zero length
      if SameValue(feta1, feta2) then
         feta2 := feta2 + twoPi;

  // start point
      fx1 := fcx + (faRad * cos(feta1));
      fy1 := fcy + (fbRad * sin(feta1));

  // end point
      fx2 := fcx + (faRad * cos(feta2));
      fy2 := fcy + (fbRad * sin(feta2));
  // Dimensions
      fxLeft := min(fx1, fx2);
      fyUp := min(fy1, fy2);
      fwidth := max(fx1, fx2) - fxLeft;
      fheight := max(fy1, fy2) - fyUp;
   end;

   function estimateError(etaA, etaB: double): double;
   var
      coeffs: ^TCoeffArray;
      c0, c1, cos2, cos4, cos6, dEta, eta, x: double;

      function rationalFunction(x: double; const c: TCoeff): double;
      begin
         result := (x * (x * c[0] + c[1]) + c[2]) / (x + c[3]);
      end;

   begin
      eta := 0.5 * (etaA + etaB);
      x := fbRad / faRad;
      dEta := etaB - etaA;
      cos2 := cos(2 * eta);
      cos4 := cos(4 * eta);
      cos6 := cos(6 * eta);
  // select the right coeficients set according to degree and b/a
      if x < 0.25 then
         coeffs := @coeffsLow
      else
         coeffs := @coeffsHigh;
      c0 := rationalFunction(x, coeffs[0][0]) + cos2 * rationalFunction(x, coeffs[0][1]) + cos4 * rationalFunction(x, coeffs[0][2]) + cos6 *
       rationalFunction(x, coeffs[0][3]);
      c1 := rationalFunction(x, coeffs[1][0]) + cos2 * rationalFunction(x, coeffs[1][1]) + cos4 * rationalFunction(x, coeffs[1][2]) + cos6 *
       rationalFunction(x, coeffs[1][3]);
      result := rationalFunction(x, safety) * faRad * exp(c0 + c1 * dEta);
   end;

   procedure BuildPathIterator;
   var
      alpha: double;
      found: boolean;
      n: integer;
      dEta, etaB, etaA: double;
      cosEtaB, sinEtaB, aCosEtaB, bSinEtaB, aSinEtaB, bCosEtaB, xB, yB, xBDot, yBDot: double;
      I: integer;
      t, xA, xADot, yA, yADot: double;
      ressize: integer; // Index var for result Array
      r: ^teaDrawtype;
      lstartx, lstarty: double; // Start From
   const
      defaultFlatness = 0.5; // half a pixel
   begin
  // find the number of Bézier curves needed
      found := false;
      n := 1;
      while (not found) and (n < 1024) do
         begin
            dEta := (feta2 - feta1) / n;
            if dEta <= 0.5 * PI then
               begin
                  etaB := feta1;
                  found := true;
                  for I := 0 to n - 1 do
                     begin
                        etaA := etaB;
                        etaB := etaB + dEta;
                        found := (estimateError(etaA, etaB) <= defaultFlatness);
                        if not found then
                           break;
                     end;
               end;
    // if not found then
            n := n shl 1;
         end;
      dEta := (feta2 - feta1) / n;
      etaB := feta1;
      cosEtaB := cos(etaB);
      sinEtaB := sin(etaB);
      aCosEtaB := faRad * cosEtaB;
      bSinEtaB := fbRad * sinEtaB;
      aSinEtaB := faRad * sinEtaB;
      bCosEtaB := fbRad * cosEtaB;
      xB := fcx + aCosEtaB;
      yB := fcy + bSinEtaB;
      xBDot := - aSinEtaB;
      yBDot := + bCosEtaB;
      lstartx := xB;
      lstarty := yB;
  // calculate and reserve Space for the result
      ressize := n;
      case fArctype of
         acArc: inc(ressize, 1); // first move
         acArcTo: inc(ressize, 3); // first line and move
         acArcAngle: inc(ressize, 1); // first move
         acPie: inc(ressize, 3); // first and last Line
         acChoord: inc(ressize, 2);
      end;
      SetLength(res, ressize);
      r := pointer(res);
      case fArctype of
         acArc:
            begin // Start with moveto
               r^.res := caMoveto;
               r^.pts[0].x := xB;
               r^.pts[0].y := yB;
               inc(r);
            end;
         acArcTo:
            begin // Start with moveto
               r^.res := caLine;
               if fClockWise then
                  begin
                     r^.pts[0].x := fx1;
                     r^.pts[0].y := fy1;
                  end
               else
                  begin
                     r^.pts[0].x := fx2;
                     r^.pts[0].y := fy2;
                  end;
               inc(r);
               r^.res := caMoveto;
               r^.pts[0].x := fx1;
               r^.pts[0].y := fy1;
               inc(r);
            end;
         acArcAngle:;
         acPie:
            begin
               r^.res := caMoveto;
               r^.pts[0].x := fcx;
               r^.pts[0].y := fcy;
               inc(r);
               r^.res := caLine;
               r^.pts[0].x := xB;
               r^.pts[0].y := yB;
               inc(r);
            end;
         acChoord:
            begin
               r^.res := caMoveto;
               r^.pts[0].x := xB;
               r^.pts[0].y := yB;
               inc(r);
            end;
      end;
      t := tan(0.5 * dEta);
      alpha := sin(dEta) * (sqrt(4 + 3 * t * t) - 1) / 3;
      for I := 0 to n - 1 do
         begin
            xA := xB;
            yA := yB;
            xADot := xBDot;
            yADot := yBDot;
            etaB := etaB + dEta;
            cosEtaB := cos(etaB);
            sinEtaB := sin(etaB);
            aCosEtaB := faRad * cosEtaB;
            bSinEtaB := fbRad * sinEtaB;
            aSinEtaB := faRad * sinEtaB;
            bCosEtaB := fbRad * cosEtaB;
            xB := fcx + aCosEtaB;
            yB := fcy + bSinEtaB;
            xBDot := - aSinEtaB;
            yBDot := bCosEtaB;
            r^.res := caCurve;
            r^.pts[0].x := xA + alpha * xADot;
            r^.pts[0].y := yA + alpha * yADot;
            r^.pts[1].x := xB - alpha * xBDot;
            r^.pts[1].y := yB - alpha * yBDot;
            r^.pts[2].x := xB;
            r^.pts[2].y := yB;
            inc(r);
         end; // Loop
      case fArctype of
         acArcTo:
            begin
               r^.res := caPosition;
               if fClockWise then
                  begin
                     r^.pts[0].x := fx2;
                     r^.pts[0].y := fy2;
                  end
               else
                  begin
                     r^.pts[0].x := fx1;
                     r^.pts[0].y := fy1;
                  end
            end;
         acPie:
            begin
               r^.res := caLine;
               r^.pts[0].x := fcx;
               r^.pts[0].y := fcy;
            end;
         acChoord:
            begin
               r^.res := caLine;
               r^.pts[0].x := lstartx;
               r^.pts[0].y := lstarty;
            end;
      end;
   end;

begin
   res := nil;
   InitFuncData; // Initialize Data
   BuildPathIterator;
   result := length(res) > 1;
end;

{$ENDREGION}


class procedure TcaSystem.debug_reset_static_data;
begin
  cairo_debug_reset_static_data;
end;

class function TcaSystem.status_to_string(status: cairo_status_t): string;
begin
  result := string(Utf8String(cairo_status_to_string(status)));
end;

{ TcaSystem }

class function TcaSystem.version: Integer;
begin
  result := cairo_version;
end;

class function TcaSystem.version_string: string;
begin
  result := string(Utf8String(cairo_version_String));
end;

{ TcaContext }

constructor TContext.create(target: ICairoSurface);
begin
  inherited create;
  fcr := cairo_create(target.Handle);
  FArcDirection := counterclockwise;
end;

destructor TContext.destroy;
begin
  cairo_destroy(fcr);
  inherited;
end;

procedure TContext.append_path(path: Pcairo_path_t);
begin
  cairo_append_path(fcr, path);
end;

procedure TContext.arc(xc, yc, radius, angle1, angle2: Double);
begin
  cairo_arc(fcr, xc, yc, radius, angle1, angle2);
end;

procedure TContext.ArcDraw(arctype: TCairoArcType; x1, y1, x2, y2, X3, Y3, X4,
    Y4: Double; var px, py : double);
var
  W, H: Double;
  cx, cy: Double;
//  positionX, positionY: Double;
begin
  W := Max(x2, x1) - min(x2, x1);
  H := Max(y2, y1) - min(y2, y1);
  cx := min(x2, x1) + (W / 2) + 0.5;
  cy := min(y2, y1) + (H / 2) + 0.5;
  ARCI(cx, cy, W, H, X3 + 0.5, Y3 + 0.5, X4 + 0.5, Y4 + 0.5, FArcDirection <> counterclockwise, arctype, pX, pY);

end;

procedure TContext.ArcDraw(arctype: TCairoArcType; x1, y1, x2, y2, X3, Y3, X4, Y4: Integer);
var
  W, H: Double;
  cx, cy: Double;
  positionX, positionY: Double;
begin
  W := Max(x2, x1) - min(x2, x1);
  H := Max(y2, y1) - min(y2, y1);
  cx := min(x2, x1) + (W / 2) + 0.5;
  cy := min(y2, y1) + (H / 2) + 0.5;

  ARCI(cx, cy, W, H, X3 + 0.5, Y3 + 0.5, X4 + 0.5, Y4 + 0.5, FArcDirection <> counterclockwise, arctype, positionX, positionY);

end;

procedure TContext.ARCI(centerx, centery, W, H, Sx, Sy, Ex, Ey: Double; clockwise: boolean; arctype: TCairoArcType;
  out positionX, positionY: Double);
var
  res: teaDrawArray;
  i: Integer;
begin
  if CalcCurveArcData(centerx, centery, W, H, Sx, Sy, Ex, Ey, clockwise, arctype, res) then
  begin
    for i := 0 to high(res) do
      with res[i] do
        case res of
          caMoveto: move_to(pts[0].x, pts[0].y);
          caLine: line_to(pts[0].x, pts[0].y);
          caCurve: curve_to(pts[0].x, pts[0].y, pts[1].x, pts[1].y, pts[2].x, pts[2].y);
          caPosition:
            begin
              positionX := pts[0].x;
              positionY := pts[0].y;
            end;
        end;

  end;
end;

procedure TContext.arc_negative(xc, yc, radius, angle1, angle2: Double);
begin
  cairo_arc_negative(fcr, xc, yc, radius, angle1, angle2);
  SaveCurrent;
end;

procedure TContext.circle(xc, yc, radius: Double);
begin
  arc(xc, yc, radius, 0, pi * 2);
end;

procedure TContext.circle_negative(xc, yc, radius: Double);
begin
  arc_negative(xc, yc, radius, pi * 2, 0);
end;

procedure TContext.clip;
begin
  cairo_clip(fcr);
end;

procedure TContext.clip_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);
begin
  cairo_clip_extents(fcr, @x1, @y1, @x2, @y2);
end;

procedure TContext.clip_preserve;
begin
  cairo_clip_preserve(fcr);
end;

procedure TContext.close_path;
begin
  cairo_close_path(fcr);
end;

function TContext.copy_clip_rectangle_list: Pcairo_rectangle_list_t;
begin
  result := cairo_copy_clip_rectangle_list(fcr);
end;

procedure TContext.copy_page;
begin
  cairo_copy_page(fcr);
end;

function TContext.copy_path: Pcairo_path_t;
begin
  result := cairo_copy_path(fcr);
end;

function TContext.copy_path_flat: Pcairo_path_t;
begin
  result := cairo_copy_path_flat(fcr);
end;

procedure TContext.curve_to(x1, y1, x2, y2, X3, Y3: Double);
begin
  cairo_curve_to(fcr, x1, y1, x2, y2, X3, Y3);
end;

procedure TContext.device_to_user(var x: Double; var y: Double);
begin
  cairo_device_to_user(fcr, @x, @y);
end;

procedure TContext.device_to_user_distance(var dx: Double; var dy: Double);
begin
  cairo_device_to_user_distance(fcr, @dx, @dy);
end;

procedure TContext.fill;
begin
  cairo_fill(fcr);
end;

procedure TContext.fill_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);
begin
  cairo_fill_extents(fcr, @x1, @y1, @x2, @y2);
end;

procedure TContext.fill_preserve;
begin
  cairo_fill_preserve(fcr);
end;

procedure TContext.font_extents(extents: Pcairo_font_extents_t);
begin
  cairo_font_extents(fcr, extents);
end;

class function TContext.getLineStyleLength(Value: TCairoLineStyle): Double;

  function DashLength(const Values: array of Double): Double;
  var
    i: Integer;
  begin
    result := 0;
    for i := low(Values) to high(Values) do
      result := result + Values[i];
  end;

begin
  case Value of
    lsSolid: result := 64;
    lsDash: result := DashLength(clsDash);
    lsDot: result := DashLength(clsDot);
    lsDashDot: result := DashLength(clsDashDot);
    lsDashDotDot: result := DashLength(clsDashDotDot);
  else result := 64;
  end;

end;

function TContext.get_antialias: cairo_antialias_t;
begin
  result := cairo_get_antialias(fcr);
end;

function TContext.Get_ArcDirection: TCairoArcDirection;
begin
  Result := FArcDirection;
end;

procedure TContext.get_current_point(out x: Double; out y: Double);
begin
  cairo_get_current_point(fcr, @x, @y);
end;

procedure TContext.get_dash(dashes, offset: PDouble);
begin
  cairo_get_dash(fcr, dashes, offset);
end;


procedure TContext.SaveCurrent;
begin
   if cairo_has_current_point(fcr) then
    cairo_get_current_point(fcr, @FPenPos.x, @FPenPos.y);
end;

function TContext.get_dash_count: Integer;
begin
  result := cairo_get_dash_count(fcr);
end;

function TContext.get_fill_rule: cairo_fill_rule_t;
begin
  result := cairo_get_fill_rule(fcr);
end;

function TContext.get_font_face: Pcairo_font_face_t;
begin
  result := cairo_get_font_face(fcr);
end;

procedure TContext.get_font_matrix(matrix: Pcairo_matrix_t);
begin
  cairo_get_font_matrix(fcr, matrix);
end;

procedure TContext.get_font_options(options: Pcairo_font_options_t);
begin
  cairo_get_font_options(fcr, options);
end;

function TContext.get_group_target: Pcairo_surface_t;
begin
  result := cairo_get_group_target(fcr);
end;

function TContext.Get_Handle: Pcairo_t;
begin
 result := fcr;
end;

function TContext.get_line_cap: cairo_line_cap_t;
begin
  result := cairo_get_line_cap(fcr);
end;

function TContext.get_line_join: cairo_line_join_t;
begin
  result := cairo_get_line_join(fcr);
end;

function TContext.get_line_width: Double;
begin
  result := cairo_get_line_width(fcr);
end;

procedure TContext.get_matrix(matrix: Pcairo_matrix_t);
begin
  cairo_get_matrix(fcr, matrix);
end;

function TContext.get_miter_limit: Double;
begin
  result := cairo_get_miter_limit(fcr);
end;

function TContext.get_operator: cairo_operator_t;
begin
  result := cairo_get_operator(fcr);
end;

function TContext.get_reference_count: Cardinal;
begin
  result := cairo_get_reference_count(fcr);
end;

function TContext.get_scaled_font(cr: Pcairo_t): Pcairo_scaled_font_t;
begin
  result := cairo_get_scaled_font(fcr);
end;

function TContext.get_source: Pcairo_pattern_t;
begin
  result := cairo_get_source(fcr);
end;

function TContext.get_target: ICairoSurface;
begin
  result := nil;
  // cairo_get_target(fcr);
end;

function TContext.get_tolerance: Double;
begin
  result := cairo_get_tolerance(fcr);
end;

function TContext.get_user_data(key: Pcairo_user_data_key_t): Pointer;
begin
  result := cairo_get_user_data(fcr, key);
end;

procedure TContext.glyph_extents(glyphs: Pcairo_glyph_t; num_glyphs: Integer; extents: Pcairo_text_extents_t);
begin
  cairo_glyph_extents(fcr, glyphs, num_glyphs, extents);
end;

procedure TContext.glyph_path(glyphs: Pcairo_glyph_t; num_glyphs: Integer);
begin
  cairo_glyph_path(fcr, glyphs, num_glyphs);
end;

function TContext.has_current_point: boolean;
begin
  result := cairo_has_current_point(fcr); // <> 0;
end;

procedure TContext.identity_matrix;
begin
  cairo_identity_matrix(fcr);
end;

function TContext.in_clip(x, y: Double): cairo_bool_t;
begin
  result := cairo_in_clip(fcr, x, y);
end;

function TContext.in_fill(x, y: Double): cairo_bool_t;
begin
  result := cairo_in_fill(fcr, x, y);
end;

function TContext.in_stroke(x, y: Double): cairo_bool_t;
begin
  result := cairo_in_stroke(fcr, x, y);
end;

procedure TContext.line_to(x, y: Double);
begin
  cairo_line_to(fcr, x, y);
end;

procedure TContext.mask(Pattern: Pcairo_pattern_t);
begin
  cairo_mask(fcr, Pattern);
end;

procedure TContext.mask_surface(Surface: TSurface; surface_x: Double; surface_y: Double);
begin
  cairo_mask_surface(fcr, Surface.Handle, surface_x, surface_y);
end;

procedure TContext.move_to(x, y: Double);
begin
  cairo_move_to(fcr, x, y);
end;

procedure TContext.new_path;
begin
  cairo_new_path(fcr);
end;

procedure TContext.new_sub_path();
begin
  cairo_new_sub_path(fcr);
end;

procedure TContext.paint;
begin
  cairo_paint(fcr);
end;

procedure TContext.paint_with_alpha(alpha: Double);
begin
  cairo_paint_with_alpha(fcr, alpha);
end;

procedure TContext.path_destroy(path: Pcairo_path_t);
begin
  cairo_path_destroy(path);
end;

procedure TContext.path_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);
begin
  cairo_path_extents(fcr, @x1, @y1, @x2, @y2);
end;

function TContext.pop_group: Pcairo_pattern_t;
begin
  result := cairo_pop_group(fcr)
end;

procedure TContext.pop_group_to_source;
begin
  cairo_pop_group_to_source(fcr);
end;

procedure TContext.push_group;
begin
  cairo_push_group(fcr);
end;

procedure TContext.push_group_with_content(content: cairo_content_t);
begin
  cairo_push_group_with_content(fcr, content);
end;

procedure TContext.rectangle(x, y, width, height: Double);
begin
  cairo_rectangle(fcr, x, y, width, height);
end;

procedure TContext.rectangle_list_destroy(rectangle_list: Pcairo_rectangle_list_t);
begin
  cairo_rectangle_list_destroy(rectangle_list);
end;

function TContext.reference: Pcairo_t;
begin
  result := cairo_reference(fcr);
end;

procedure TContext.rel_curve_to(dx1, dy1, dx2, dy2, dx3, dy3: Double);
begin
  cairo_rel_curve_to(fcr, dx1, dy1, dx2, dy2, dx3, dy3);
end;

procedure TContext.rel_line_to(dx, dy: Double);
begin
  cairo_rel_line_to(fcr, dx, dy);
end;

procedure TContext.rel_move_to(dx, dy: Double);
begin
  cairo_rel_move_to(fcr, dx, dy);
end;

procedure TContext.reset_clip;
begin
  cairo_reset_clip(fcr);
end;

procedure TContext.restore;
begin
  cairo_restore(fcr);
end;

procedure TContext.rotate(angle: Double);
begin
  cairo_rotate(fcr, angle);
end;

procedure TContext.save;
begin
  cairo_save(fcr);
end;

procedure TContext.scale(Sx, Sy: Double);
begin
  cairo_scale(fcr, Sx, Sy);
end;

procedure TContext.select_font_face(family: PUTF8Char; slant: cairo_font_slant_t; weight: cairo_font_weight_t);
begin
  cairo_select_font_face(fcr, family, slant, weight);
end;

procedure TContext.SetCairoFont(Value: ICairoFont);
begin
  Value.setToCairo(fcr);
end;

procedure TContext.setColor(Value: Tcolor; const alpha: Double);
var
  ta: TColorrec;
begin
  ta.Color := Value;
  cairo_set_source_rgba(fcr, ta.r / 255, ta.g / 255, ta.b / 255, alpha);
end;

procedure TContext.setLineStyle(Value: TCairoLineStyle);

begin
  case Value of
    lsSolid: set_dash([]);
    lsDash: set_dash(clsDash);
    lsDot: set_dash(clsDot);
    lsDashDot: set_dash(clsDashDot);
    lsDashDotDot: set_dash(clsDashDotDot);
  else set_dash([]);
  end;
end;

procedure TContext.set_antialias(const antialias: cairo_antialias_t);
begin
  cairo_set_antialias(fcr, antialias);
end;

procedure TContext.Set_ArcDirection(const Value: TCairoArcDirection);
begin
  FArcDirection := Value;
end;

procedure TContext.set_dash(const dashes: array of Double; const offset: Double = 0.0);
begin
  if length(dashes) > 0 then
    cairo_set_dash(fcr, @dashes[0], length(dashes), offset)
  else
    cairo_set_dash(fcr, nil, 0, 0);
end;

procedure TContext.set_fill_rule(const fill_rule: cairo_fill_rule_t);
begin
  cairo_set_fill_rule(fcr, fill_rule);
end;

procedure TContext.set_font_face(font_face: Pcairo_font_face_t);
begin
  cairo_set_font_face(fcr, font_face);
end;

procedure TContext.set_font_matrix(matrix: Pcairo_matrix_t);
begin
  cairo_set_font_matrix(fcr, matrix);
end;

procedure TContext.set_font_options(options: Pcairo_font_options_t);
begin
  cairo_set_font_options(fcr, options);
end;

procedure TContext.set_font_size(size: Double);
begin
  cairo_set_font_size(fcr, size);
end;

procedure TContext.set_line_cap(const line_cap: cairo_line_cap_t);
begin
  cairo_set_line_cap(fcr, line_cap);
end;

procedure TContext.set_line_join(const line_join: cairo_line_join_t);
begin
  cairo_set_line_join(fcr, line_join);
end;

procedure TContext.set_line_width(const width: Double);
begin
  cairo_set_line_width(fcr, width);
end;

procedure TContext.set_matrix(matrix: Pcairo_matrix_t);
begin
  cairo_set_matrix(fcr, matrix);
end;

procedure TContext.set_miter_limit(const limit: Double);
begin
  cairo_set_miter_limit(fcr, limit);
end;

procedure TContext.set_operator(const op: cairo_operator_t);
begin
  cairo_set_operator(fcr, op);
end;

procedure TContext.set_scaled_font(scaled_font: Pcairo_scaled_font_t);
begin
  cairo_set_scaled_font(fcr, scaled_font);
end;

procedure TContext.set_source(const source: ICairoPattern);
begin
  source.setAsSource(fcr);
  // cairo_set_source(fcr, source.Pattern);
end;

procedure TContext.set_source_rgb(red, green, blue: Double);
begin
  cairo_set_source_rgb(fcr, red, green, blue);
end;

procedure TContext.set_source_rgba(red, green, blue, alpha: Double);
begin
  cairo_set_source_rgba(fcr, red, green, blue, alpha);
end;

procedure TContext.set_source_surface(Surface: ICairoSurface; x: Double; y:
    Double);
begin
  cairo_set_source_surface(fcr, Surface.Handle, x, y);
end;

procedure TContext.Set_target(const Value: ICairoSurface);
begin
  // TODO -cMM: TContext.Set_target default body inserted
end;

procedure TContext.set_tolerance(tolerance: Double);
begin
  cairo_set_tolerance(fcr, tolerance);
end;

function TContext.set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t)
  : cairo_status_t;
begin
  result := cairo_set_user_data(fcr, key, user_data, destroy);
end;

procedure TContext.show_glyphs(glyphs: Pcairo_glyph_t; num_glyphs: Integer);
begin
  cairo_show_glyphs(fcr, glyphs, num_glyphs);
end;

procedure TContext.show_page;
begin
  cairo_show_page(fcr);
end;

procedure TContext.show_text(utf8: PUTF8Char);
begin
  cairo_show_text(fcr, utf8);
end;

procedure TContext.show_text_glyphs(utf8: PUTF8Char; utf8_len: Integer; glyphs: Pcairo_glyph_t; num_glyphs: Integer;
  clusters: Pcairo_text_cluster_t; num_clusters: Integer; cluster_flags: cairo_text_cluster_flags_t);
begin
  cairo_show_text_glyphs(fcr, utf8, utf8_len, glyphs, num_glyphs, clusters, num_clusters, cluster_flags);
end;

function TContext.status: cairo_status_t;
begin
  result := cairo_status(fcr);
end;



procedure TContext.stroke;
begin
  cairo_stroke(fcr);
end;

procedure TContext.stroke_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);
begin
  cairo_stroke_extents(fcr, @x1, @y1, @x2, @y2);
end;

procedure TContext.stroke_preserve;
begin
  cairo_stroke_preserve(fcr);
end;

procedure TContext.tag_begin(tag_name, attributes: PUTF8Char);
begin
  cairo_tag_begin(fcr, tag_name, attributes);
end;

procedure TContext.tag_end(tag_name: PUTF8Char);
begin
  cairo_tag_end(fcr, tag_name);
end;

procedure TContext.text_extents(utf8: PUTF8Char; var extents: cairo_text_extents_t);
begin
  cairo_text_extents(fcr, utf8, extents);
end;

procedure TContext.text_path(const Value: string);
Var lUtf8 : UTF8String;
begin
  lutf8 := utf8String( Value);
  cairo_text_path(fcr, Pansichar(lUtf8));
end;


procedure TContext.text_Clusters(const Value: string; scaled_font: ICairoScaledFont);
var
   status: cairo_status_t;
   glyphs: Pcairo_glyph_t;
   cluster : Pcairo_text_cluster_t;
   clusterflag : cairo_text_cluster_flags_t;
   num_glyphs: Integer;
   num_clusters : Integer;
   utf8: Utf8String;
   utf8len: Integer;

begin
   glyphs := nil;
   cluster := nil;
   clusterflag := CAIRO_TEXT_CLUSTER_FLAG_BACKWARD;
   num_clusters := 0;
   utf8 := Utf8String(Value);
   utf8len := length(utf8);

   status := cairo_scaled_font_text_to_glyphs(scaled_font.Handle, 0, 0,
   Pansichar(utf8), utf8len, @glyphs, @num_glyphs, @cluster, @num_clusters, @clusterflag);

   if (status = CAIRO_STATUS_SUCCESS) then
      begin
//         cairo_show_glyphs(fcr, glyphs, num_glyphs);
         cairo_show_text_glyphs(fcr, Pansichar(utf8), utf8len, glyphs, num_glyphs, cluster, num_clusters, clusterflag);
         cairo_glyph_free(glyphs);
         cairo_text_cluster_free (cluster);
      end;
end;
procedure TContext.transform(matrix: Pcairo_matrix_t);
begin
  cairo_transform(fcr, matrix);
end;

procedure TContext.translate(tx, ty: Double);
begin
  cairo_translate(fcr, tx, ty);
end;

procedure TContext.user_to_device(var x: Double; var y: Double);
begin
  cairo_user_to_device(fcr, @x, @y);
end;

procedure TContext.user_to_device_distance(var dx: Double; var dy: Double);
begin
  cairo_user_to_device_distance(fcr, @dx, @dy);
end;

function TCairo_Device.acquire: cairo_status_t;
begin
  result := cairo_device_acquire(fDevice);
end;

procedure TCairo_Device.destroy;
begin
  cairo_device_destroy(fDevice);
end;

procedure TCairo_Device.finish;
begin
  cairo_device_finish(fDevice);
end;

procedure TCairo_Device.flush;
begin
  cairo_device_flush(fDevice);
end;

function TCairo_Device.get_reference_count: Cardinal;
begin
  result := cairo_device_get_reference_count(fDevice);
end;

function TCairo_Device.get_type: cairo_device_type_t;
begin
  result := cairo_device_get_type(fDevice);
end;

function TCairo_Device.get_user_data(key: Pcairo_user_data_key_t): Pointer;
begin
  result := cairo_device_get_user_data(fDevice, key);
end;

function TCairo_Device.observer_elapsed: Double;
begin
  result := cairo_device_observer_elapsed(fDevice);
end;

function TCairo_Device.observer_fill_elapsed: Double;
begin
  result := cairo_device_observer_fill_elapsed(fDevice);
end;

function TCairo_Device.observer_glyphs_elapsed: Double;
begin
  result := cairo_device_observer_glyphs_elapsed(fDevice);
end;

function TCairo_Device.observer_mask_elapsed: Double;
begin
  result := cairo_device_observer_mask_elapsed(fDevice);
end;

function TCairo_Device.observer_paint_elapsed: Double;
begin
  result := cairo_device_observer_paint_elapsed(fDevice);
end;

function TCairo_Device.observer_print(write_func: cairo_write_func_t; closure: Pointer): cairo_status_t;
begin
  result := cairo_device_observer_print(fDevice, write_func, closure);
end;

function TCairo_Device.observer_stroke_elapsed: Double;
begin
  result := cairo_device_observer_stroke_elapsed(fDevice);
end;

{ TCairo_Device }

function TCairo_Device.reference: Pcairo_device_t;
begin
  result := cairo_device_reference(fDevice);
end;

procedure TCairo_Device.release;
begin
  cairo_device_release(fDevice);
end;

function TCairo_Device.set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t)
  : cairo_status_t;
begin
  result := cairo_device_set_user_data(fDevice, key, user_data, destroy);
end;

function TCairo_Device.status: cairo_status_t;
begin
  result := cairo_device_status(fDevice);
end;

end.
