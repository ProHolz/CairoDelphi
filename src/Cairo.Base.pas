unit Cairo.Base;

interface

uses
  Cairo.Types;

type
  // Matrix
  TCairoMatrix = record
    // cairo_matrix_
  private
    fMatrix: cairo_matrix_t;

  public
    procedure init(xx, yx, xy, yy, x0, y0: Double);
    procedure init_identity;
    procedure init_translate(tx, ty: Double);
    procedure init_scale(sx, sy: Double);
    procedure init_rotate(radians: Double);
    procedure initWithMatrix(const Value : cairo_matrix_t);
    procedure translate(tx, ty: Double);
    procedure scale(sx, sy: Double);
    procedure rotate(radians: Double);
    function invert: cairo_status_t;
    procedure multiply(const a, b: TCairoMatrix); overload;
    procedure multiply(const a, b: cairo_matrix_t); overload;



    procedure transform_distance(var dx, dy: Double);
    procedure transform_point(var x, y: Double);
    function Matrix: Pcairo_matrix_t;
  end;


  // Region
  TRegion = record
    // cairo_region
  private
    fRegion: Pcairo_region_t;

  public
    function create(): Pcairo_region_t;
    function create_rectangle(rectangle: Pcairo_rectangle_int_t): Pcairo_region_t;
    function create_rectangles(rects: Pcairo_rectangle_int_t; count: Integer): Pcairo_region_t;
    function copy(original: Pcairo_region_t): Pcairo_region_t;
    procedure destroy(region: Pcairo_region_t);
    function reference: Pcairo_region_t;


    function equal(a: Pcairo_region_t; b: Pcairo_region_t): cairo_bool_t;
    function status: cairo_status_t;
    procedure get_extents(extents: Pcairo_rectangle_int_t);
    function num_rectangles: Integer;
    procedure get_rectangle(nth: Integer; rectangle: Pcairo_rectangle_int_t);
    function is_empty: cairo_bool_t;
    function contains_rectangle(region: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_region_overlap_t;
    function contains_point(region: Pcairo_region_t; x: Integer; y: Integer): cairo_bool_t;
    procedure translate(dx, dy: Integer);
    function subtract(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t;
    function subtract_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
    function intersect(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t;
    function intersect_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
    function union(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t;
    function union_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
    function &xor(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t;
    function xor_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
  end;

//type
//  TColorMapper_ = record
//    case LongWord of
//      0: (Color: Cardinal);
//
//      1:
//{$IFDEF BIGENDIAN}
//          (a, b, G, R: System.Byte);
//{$ELSE}
//          (R, G, b, a: System.Byte);
//{$ENDIF}
//  end;

type
  TCairoColor = record
  private type
    TColorMapper = record
      case LongWord of
        0: (Color: Cardinal);

        1:
{$IFDEF BIGENDIAN}
            (a, b, G, R: System.Byte);
{$ELSE}
            (R, G, b, a: System.Byte);
{$ENDIF}
    end;
  private
    fColor: TColorMapper;
    procedure setColor(Value: Cardinal);
    function getColor: Cardinal;
    function getAlpha: Double;
    function getBlue: Double;
    function getGreen: Double;
    function getRed: Double;

    procedure setAlpha(const Value: Double);
  public
    property Red: Double read getRed;
    property Green: Double read getGreen;
    property Blue: Double read getBlue;
    property Alpha: Double read getAlpha write setAlpha;
    property Color: Cardinal read getColor write setColor;

  end;


implementation

uses
  Cairo.dll;
{ TCairoMatrix }

procedure TCairoMatrix.init(xx, yx, xy, yy, x0, y0: Double);
begin
  cairo_matrix_init(@fMatrix, xx, yx, xy, yy, x0, y0);
end;

procedure TCairoMatrix.init_identity;
begin
  cairo_matrix_init_identity(@fMatrix);
end;

procedure TCairoMatrix.init_translate(tx, ty: Double);
begin
  init_identity;
  cairo_matrix_init_translate(@fMatrix, tx, ty);
end;

procedure TCairoMatrix.init_scale(sx, sy: Double);
begin
  init_identity;
  cairo_matrix_scale(@fMatrix, sx, sy);
end;

procedure TCairoMatrix.init_rotate(radians: Double);
begin
  init_identity;
  cairo_matrix_init_rotate(@fMatrix, radians);
end;

procedure TCairoMatrix.translate(tx, ty: Double);
begin
  cairo_matrix_translate(@fMatrix, tx, ty);
end;

procedure TCairoMatrix.scale(sx, sy: Double);
begin
  cairo_matrix_scale(@fMatrix, sx, sy);
end;

procedure TCairoMatrix.rotate(radians: Double);
begin
  cairo_matrix_rotate(@fMatrix, radians);
end;

function TCairoMatrix.invert: cairo_status_t;
begin
  result := cairo_matrix_invert(@fMatrix);
end;

procedure TCairoMatrix.multiply(const a, b: TCairoMatrix);
begin
  cairo_matrix_multiply(@fMatrix, @a.fMatrix, @b.fMatrix);
end;

procedure TCairoMatrix.transform_distance(var dx, dy: Double);
begin
  cairo_matrix_transform_distance(@fMatrix, @dx, @dy);
end;

procedure TCairoMatrix.transform_point(var x, y: Double);
begin
  cairo_matrix_transform_point(@fMatrix, @x, @y);
end;

function TCairoMatrix.Matrix: Pcairo_matrix_t;
begin
  result := @fMatrix;
end;

procedure TCairoMatrix.initWithMatrix(const Value: cairo_matrix_t);
begin
 fMatrix := Value;
end;

procedure TCairoMatrix.multiply(const a, b: cairo_matrix_t);
begin
 cairo_matrix_multiply(@fMatrix, @a, @b);
end;

{ TRegion }

function TRegion.create: Pcairo_region_t;
begin
  result := cairo_region_create;
end;

function TRegion.create_rectangle(rectangle: Pcairo_rectangle_int_t): Pcairo_region_t;
begin
  result := cairo_region_create_rectangle(rectangle);
end;

function TRegion.create_rectangles(rects: Pcairo_rectangle_int_t; count: Integer): Pcairo_region_t;
begin
  result := cairo_region_create_rectangles(rects, count);
end;

function TRegion.copy(original: Pcairo_region_t): Pcairo_region_t;
begin
  result := cairo_region_copy(original);
end;

function TRegion.reference: Pcairo_region_t;
begin
  result := cairo_region_reference(fRegion);
end;

procedure TRegion.destroy(region: Pcairo_region_t);
begin
  cairo_region_destroy(fRegion);
end;

function TRegion.equal(a, b: Pcairo_region_t): cairo_bool_t;
begin
  result := cairo_region_equal(a, b);
end;

function TRegion.status: cairo_status_t;
begin
  result := cairo_region_status(fRegion);
end;

procedure TRegion.get_extents(extents: Pcairo_rectangle_int_t);
begin
  cairo_region_get_extents(fRegion, extents);
end;

function TRegion.num_rectangles: Integer;
begin
  result := cairo_region_num_rectangles(fRegion);
end;

procedure TRegion.get_rectangle(nth: Integer; rectangle: Pcairo_rectangle_int_t);
begin
  cairo_region_get_rectangle(fRegion, nth, rectangle);
end;

function TRegion.is_empty: cairo_bool_t;
begin
  result := cairo_region_is_empty(fRegion);
end;

function TRegion.contains_rectangle(region: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_region_overlap_t;
begin
  result := cairo_region_contains_rectangle(fRegion, rectangle);
end;

function TRegion.contains_point(region: Pcairo_region_t; x, y: Integer): cairo_bool_t;
begin
  result := cairo_region_contains_point(fRegion, x, y);
end;

procedure TRegion.translate(dx, dy: Integer);
begin
  cairo_region_translate(fRegion, dx, dy);
end;

function TRegion.subtract(dst, other: Pcairo_region_t): cairo_status_t;
begin
  result := cairo_region_subtract(dst, other);
end;

function TRegion.subtract_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
begin
  result := cairo_region_subtract_rectangle(dst, rectangle);
end;

function TRegion.intersect(dst, other: Pcairo_region_t): cairo_status_t;
begin
  result := cairo_region_intersect(dst, other);
end;

function TRegion.intersect_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
begin
  result := cairo_region_intersect_rectangle(dst, rectangle);
end;

function TRegion.union(dst, other: Pcairo_region_t): cairo_status_t;
begin
  result := cairo_region_union(dst, other);
end;

function TRegion.union_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
begin
  result := cairo_region_union_rectangle(dst, rectangle);
end;

function TRegion.&xor(dst, other: Pcairo_region_t): cairo_status_t;
begin
  result := cairo_region_xor(dst, other);
end;

function TRegion.xor_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t;
begin
  result := cairo_region_xor_rectangle(dst, rectangle);
end;

{ TCairoColor }

function TCairoColor.getRed: Double;
begin
  result := fColor.R / 255;
end;

function TCairoColor.getGreen: Double;
begin
  result := fColor.G / 255;
end;

function TCairoColor.getBlue: Double;
begin
  result := fColor.b / 255;
end;

function TCairoColor.getAlpha: Double;
begin
  result := fColor.a / 255;
end;

procedure TCairoColor.setColor(Value: Cardinal);
begin
  fColor.Color := Value;
  fColor.a := 255;
end;

function TCairoColor.getColor: Cardinal;
begin
  result := fColor.Color;
end;

procedure TCairoColor.setAlpha(const Value: Double);
begin
  fColor.a := round(Value * 255);
end;

end.
