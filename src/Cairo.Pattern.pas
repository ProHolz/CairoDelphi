unit Cairo.Pattern;

interface
  {$HINTS OFF}
uses
   Cairo.Types,
   Cairo.Base,
   Cairo.Interfaces;


 // Pattern

type

// TPatternFactory = class
// public
// // cairo_pattern_
// function create_raster_source(user_data: Pointer; content: cairo_content_t; width: Integer; height: Integer): Pcairo_pattern_t;

// function create_for_surface(surface: Pcairo_surface_t): Pcairo_pattern_t;
// function create_linear(x0: Double; y0: Double; x1: Double; y1: Double): Pcairo_pattern_t;
// function create_radial(cx0: Double; cy0: Double; radius0: Double; cx1: Double; cy1: Double; radius1: Double): Pcairo_pattern_t;
// function create_mesh(): Pcairo_pattern_t;
// end;

   TPattern = class(TinterfacedObject, ICairoPattern)

   strict private
    // Gradient

   private
      fpattern: Pcairo_pattern_t;

   protected

      procedure add_color_stop_rgba(offset: Double; Value: TCairoColor); virtual;

      function reference: Pcairo_pattern_t;
      function get_user_data(key: Pcairo_user_data_key_t): Pointer;
      function set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;
      function get_type: cairo_pattern_type_t;
      procedure set_filter(filter: cairo_filter_t);
      function get_filter: cairo_filter_t;
      procedure set_matrix(matrix: TCairoMatrix);
      procedure get_matrix(var matrix: cairo_matrix_t);
      procedure set_extend(extend: cairo_extend_t);
      function get_extend: cairo_extend_t;
       procedure Translate_and_Scale(tx, ty, sx, sy: Double);

   public
      constructor Create;
      destructor Destroy; override;

      function status: cairo_status_t;
      function get_reference_count: Cardinal;

      procedure Translate(tx, ty: Double);
      procedure Rotate(Degrees: Double);
      procedure Scale(sx, sy: Double);


      procedure setAsSource(const cr: Pcairo_t); virtual;

// Properties
      property Pattern: Pcairo_pattern_t read fpattern;

   end;

   TRGBAPattern = class(TPattern)
   protected
     function get_rgba(var Red, Green, Blue, Alpha: Double): cairo_status_t;
   public
      constructor create_rgb(Red: Double; Green: Double; Blue: Double);
      constructor create_rgba(Red: Double; Green: Double; Blue: Double; Alpha: Double);
      constructor create_rgbColor(Value: TCairoColor);
      constructor create_rgbaColor(Value: TCairoColor);
   end;

   TSurfacePattern = class(TPattern)
   private
      function get_surface(surface: PPcairo_surface_t): cairo_status_t;

   public
      constructor Create(surface: Pcairo_surface_t);
   end;



   TGradientPattern = class(TPattern)
   // cairo_pattern_
     protected
       procedure add_color_stop_rgba(offset: Double; Value: TCairoColor);  override;
     public

      constructor create_linear(x0: Double; y0: Double; x1: Double; y1: Double);
      constructor create_linearWH(x0: Double; y0: Double; W: Double; H: Double);
      constructor create_linearType(Value: TCairoGradientType);

      protected
      procedure add_color_stop_rgb(offset, Red, Green, Blue: Double); overload;
       procedure add_color_stop_rgb(offset: Double; Value: TCairoColor); overload;

      function get_color_stop_rgba(index: Integer; var offset, Red, Green, Blue, Alpha: Double): cairo_status_t;

      function get_color_stop_count(var count: Integer): cairo_status_t;
      function get_linear_points(var x0, y0, x1, y1: Double): cairo_status_t;
      function get_radial_circles(var x0, y0, r0, x1, y1, r1: Double): cairo_status_t;
   end;

   TMeshPattern = class(TPattern)

// Mesh Pattern
   // cairo_mesh_pattern_

      constructor Create;

      procedure test;
      procedure test1;

      procedure begin_patch;
      procedure end_patch;
      procedure curve_to(x1, y1, x2, y2, x3, y3: Double);
      procedure line_to(x, y: Double);
      procedure move_to(x, y: Double);
      procedure set_control_point(point_num: Cardinal; x, y: Double);
      procedure set_corner_color_rgb(corner_num: Cardinal; Red, Green, Blue: Double);
      procedure set_corner_color_rgba(corner_num: Cardinal; Red, Green, Blue, Alpha: Double);
      function get_patch_count(var count: Cardinal): cairo_status_t;
      function get_path(patch_num: Cardinal): Pcairo_path_t;
      function get_corner_color_rgba(patch_num, corner_num: Cardinal; var Red, Green, Blue, Alpha: Double): cairo_status_t;
      function get_control_point(patch_num, point_num: Cardinal; var x, y: Double): cairo_status_t;

   end;

implementation

uses
   System.math,
   Cairo.Dll;

{ TBasePattern }

destructor TPattern.Destroy;
begin
   cairo_pattern_destroy(fpattern);
   inherited;
end;

function TPattern.reference: Pcairo_pattern_t;
begin
   result := cairo_pattern_reference(fpattern);
end;

function TPattern.get_reference_count: Cardinal;
begin
   result := cairo_pattern_get_reference_count(fpattern);
end;

function TPattern.status: cairo_status_t;
begin
   result := cairo_pattern_status(fpattern);
end;

function TPattern.get_user_data(key: Pcairo_user_data_key_t): Pointer;
begin
   result := cairo_pattern_get_user_data(fpattern, key);
end;

function TPattern.set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;
begin
   result := cairo_pattern_set_user_data(fpattern, key, user_data, Destroy);
end;

function TPattern.get_type: cairo_pattern_type_t;
begin
   result := cairo_pattern_get_type(fpattern);
end;

procedure TPattern.set_matrix(matrix: TCairoMatrix);
begin
   cairo_pattern_set_matrix(fpattern, matrix.matrix);
end;

procedure TPattern.get_matrix(var matrix: cairo_matrix_t);
begin
   cairo_pattern_get_matrix(fpattern, @matrix);
end;

procedure TPattern.set_extend(extend: cairo_extend_t);
begin
   cairo_pattern_set_extend(fpattern, extend);
end;

function TPattern.get_extend: cairo_extend_t;
begin
   result := cairo_pattern_get_extend(fpattern);
end;

procedure TPattern.set_filter(filter: cairo_filter_t);
begin
   cairo_pattern_set_filter(fpattern, filter);
end;

function TPattern.get_filter: cairo_filter_t;
begin
   result := cairo_pattern_get_filter(fpattern);
end;

constructor TPattern.Create;
begin
   inherited;
end;

procedure TPattern.Translate_and_Scale(tx, ty, sx, sy: Double);
var
   matrix: TCairoMatrix;
begin
   matrix.init_scale(sx, sy);
 // matrix.transform_distance(tx,ty);
 // matrix.scale(sx, sy);
   set_matrix(matrix);

end;

{ TSurfacePattern }

function TSurfacePattern.get_surface(surface: PPcairo_surface_t): cairo_status_t;
begin
   result := cairo_pattern_get_surface(fpattern, surface);
end;

constructor TSurfacePattern.Create(surface: Pcairo_surface_t);
begin
   inherited Create;
   fpattern := cairo_pattern_create_for_surface(surface);
   set_extend(CAIRO_EXTEND_REPEAT);
end;

{ TGradientPattern }

procedure TGradientPattern.add_color_stop_rgb(offset, Red, Green, Blue: Double);
begin
   cairo_pattern_add_color_stop_rgb(fpattern, offset, Red, Green, Blue);
end;

function TGradientPattern.get_color_stop_rgba(index: Integer; var offset, Red, Green, Blue, Alpha: Double): cairo_status_t;
begin
   result := cairo_pattern_get_color_stop_rgba(fpattern, index, @offset, @Red, @Green, @Blue, @Alpha);
end;

function TGradientPattern.get_color_stop_count(var count: Integer): cairo_status_t;
begin
   result := cairo_pattern_get_color_stop_count(fpattern, @count);
end;

function TGradientPattern.get_linear_points(var x0, y0, x1, y1: Double): cairo_status_t;
begin
   result := cairo_pattern_get_linear_points(fpattern, @x0, @y0, @x1, @y1);
end;

function TGradientPattern.get_radial_circles(var x0, y0, r0, x1, y1, r1: Double): cairo_status_t;
begin
   result := cairo_pattern_get_radial_circles(fpattern, @x0, @y0, @r0, @x1, @y1, @r1);
end;

constructor TGradientPattern.create_linear(x0, y0, x1, y1: Double);
begin
   inherited Create;
   fpattern := cairo_pattern_create_linear(x0, y0, x1, y1);

// cairo_pattern_set_extend(fpattern, CAIRO_EXTEND_REFLECT);
end;

procedure TGradientPattern.add_color_stop_rgb(offset: Double; Value: TCairoColor);
begin
   cairo_pattern_add_color_stop_rgb(fpattern, offset, Value.Red, Value.Green, Value.Blue);
end;

procedure TGradientPattern.add_color_stop_rgba(offset: Double; Value: TCairoColor);
begin
   cairo_pattern_add_color_stop_rgba(fpattern, offset, Value.Red, Value.Green, Value.Blue, Value.Alpha);
end;

constructor TGradientPattern.create_linearType(Value: TCairoGradientType);
begin
   inherited Create;
   case Value of
      tgtLine: fpattern := cairo_pattern_create_linear(0, 0, 1, 1);
      tgthor: fpattern := cairo_pattern_create_linear(0, 0, 1, 0);
      tgtVert: fpattern := cairo_pattern_create_linear(0, 0, 0, 1);
      tgtDiagonal: fpattern := cairo_pattern_create_linear(0, 0, 200, 100);
   else
      fpattern := cairo_pattern_create_linear(0, 0, 1, 1);
   end;
end;

constructor TGradientPattern.create_linearWH(x0, y0, W, H: Double);
begin
   create_linear(x0, y0, x0 + W, y0 + H);
end;

{ TMeshPattern }

procedure TMeshPattern.begin_patch;
begin
   cairo_mesh_pattern_begin_patch(fpattern);
end;

procedure TMeshPattern.end_patch;
begin
   cairo_mesh_pattern_end_patch(fpattern);
end;

procedure TMeshPattern.curve_to(x1, y1, x2, y2, x3, y3: Double);
begin
   cairo_mesh_pattern_curve_to(fpattern, x1, y1, x2, y2, x3, y3);
end;

procedure TMeshPattern.line_to(x, y: Double);
begin
   cairo_mesh_pattern_line_to(fpattern, x, y);
end;

procedure TMeshPattern.move_to(x, y: Double);
begin
   cairo_mesh_pattern_move_to(fpattern, x, y);
end;

procedure TMeshPattern.set_control_point(point_num: Cardinal; x, y: Double);
begin
   cairo_mesh_pattern_set_control_point(fpattern, point_num, x, y);
end;

procedure TMeshPattern.set_corner_color_rgb(corner_num: Cardinal; Red, Green, Blue: Double);
begin
   cairo_mesh_pattern_set_corner_color_rgb(fpattern, corner_num, Red, Green, Blue);
end;

procedure TMeshPattern.set_corner_color_rgba(corner_num: Cardinal; Red, Green, Blue, Alpha: Double);
begin
   cairo_mesh_pattern_set_corner_color_rgba(fpattern, corner_num, Red, Green, Blue, Alpha);
end;

function TMeshPattern.get_patch_count(var count: Cardinal): cairo_status_t;
begin
   result := cairo_mesh_pattern_get_patch_count(fpattern, @count);
end;

function TMeshPattern.get_path(patch_num: Cardinal): Pcairo_path_t;
begin
   result := cairo_mesh_pattern_get_path(fpattern, patch_num);
end;

function TMeshPattern.get_corner_color_rgba(patch_num, corner_num: Cardinal; var Red, Green, Blue, Alpha: Double): cairo_status_t;
begin
   result := cairo_mesh_pattern_get_corner_color_rgba(fpattern, patch_num, corner_num, @Red, @Green, @Blue, @Alpha);
end;

function TMeshPattern.get_control_point(patch_num, point_num: Cardinal; var x, y: Double): cairo_status_t;
begin
   result := cairo_mesh_pattern_get_control_point(fpattern, patch_num, point_num, @x, @y);
end;

function TRGBAPattern.get_rgba(var Red, Green, Blue, Alpha: Double): cairo_status_t;
begin
   result := cairo_pattern_get_rgba(fpattern, @Red, @Green, @Blue, @Alpha);
end;

constructor TRGBAPattern.create_rgb(Red, Green, Blue: Double);
begin
   inherited Create;
   fpattern := cairo_pattern_create_rgb(Red, Green, Blue);
end;

constructor TRGBAPattern.create_rgba(Red, Green, Blue, Alpha: Double);
begin
   inherited Create;
   fpattern := cairo_pattern_create_rgba(Red, Green, Blue, Alpha);
end;

constructor TRGBAPattern.create_rgbColor(Value: TCairoColor);
begin
   inherited Create;
   fpattern := cairo_pattern_create_rgb(Value.Red, Value.Green, Value.Blue);
end;

constructor TRGBAPattern.create_rgbaColor(Value: TCairoColor);
begin
   inherited Create;
   fpattern := cairo_pattern_create_rgba(Value.Red, Value.Green, Value.Blue, Value.Alpha);
end;

constructor TMeshPattern.Create;
begin
   inherited Create;
   fpattern := cairo_pattern_create_mesh;
end;

procedure TMeshPattern.test;
begin

/// * Add a Coons patch */
   begin_patch;
   move_to(0, 0);
   curve_to(30, - 30, 60, 30, 100, 0);
   curve_to(60, 30, 130, 60, 100, 100);
   curve_to(60, 70, 30, 130, 0, 100);
   curve_to(30, 70, - 30, 30, 0, 0);
   set_corner_color_rgb(0, 1, 0, 0);
   set_corner_color_rgb(1, 0, 1, 0);
   set_corner_color_rgb(2, 0, 0, 1);
   set_corner_color_rgb(3, 1, 1, 0);
   end_patch;

   begin_patch();
   move_to(100, 100);
   line_to(130, 130);
   line_to(130, 70);
   set_corner_color_rgb(0, 1, 0, 0);
   set_corner_color_rgb(1, 0, 1, 0);
   set_corner_color_rgb(2, 0, 0, 1);
   end_patch();
   set_extend(CAIRO_EXTEND_REPEAT);
end;

procedure TMeshPattern.test1;
begin
   begin_patch();
   move_to(0, 0);
   line_to(200, 0);
   line_to(200, 100);
   line_to(0, 100);
   set_corner_color_rgb(0, 1, 0, 0);
   set_corner_color_rgb(1, 0, 1, 0);
   set_corner_color_rgb(2, 0, 0, 1);
   set_corner_color_rgb(3, 0, 1, 1);
   end_patch();
end;

procedure TPattern.add_color_stop_rgba(offset: Double; Value: TCairoColor);
begin
  // TODO -cMM: TPattern.add_color_stop_rgba default body inserted
end;

procedure TPattern.Translate(tx, ty: Double);
var
   matrix: TCairoMatrix;
begin
   matrix.init_translate(tx, ty);
   set_matrix(matrix);
end;

procedure TPattern.setAsSource(const cr: Pcairo_t);
begin
   cairo_set_source(cr, fpattern);
end;

procedure TPattern.Rotate(Degrees: Double);
var
   matrix: TCairoMatrix;
begin
   matrix.init_rotate(DegToRad(Degrees));
   set_matrix(matrix);
end;

procedure TPattern.Scale(sx, sy: Double);
var
   matrix: TCairoMatrix;
begin
   matrix.init_scale(sx, sy);
   set_matrix(matrix);
end;

end.
