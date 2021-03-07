unit Cairo.Pattern.Surfaces;

interface

uses
  Cairo.types,
  Cairo.Interfaces,
  Cairo.Base,
  Cairo.surface;

type
  TBrushPattern = class
  private
    function CreateCrossSurface(dist: integer; Color: TCairoColor; PenWidth:
        Double): ICairoSurface;
    function CreateLineSurface(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoSurface;
    function Create2LineSurface(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoSurface;
  public
    class function CreateCrossPattern(dist: integer; Color: TCairoColor; PenWidth: Double = 1.0): ICairoPattern; static;
    class function CreateLinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double = 1.0)
      : ICairoPattern; static;
    class function Create2LinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double)
      : ICairoPattern; static;
  end;

implementation

uses
  Cairo.Pattern,
  Cairo.Context;

{ TBrushPattern }

class function TBrushPattern.CreateCrossPattern(dist: integer; Color: TCairoColor; PenWidth: Double = 1.0): ICairoPattern;
var
  local: TBrushPattern;
  ls: ICairoSurface;
begin
  local := TBrushPattern.Create;
  try
    ls := local.CreateCrossSurface(dist, Color, PenWidth);
    try
      result := TSurfacePattern.Create(ls.Handle);
    finally
      ls := nil;
    end;
  finally
    local.Free;
  end;

end;

function TBrushPattern.CreateCrossSurface(dist: integer; Color: TCairoColor;
    PenWidth: Double): ICairoSurface;
var
  cr: TContext;
  x: Double;
begin
  result := tCaImageSurface.Create(CAIRO_FORMAT_ARGB32, dist, dist);
  cr := TContext.Create(result);
  try
    x := dist - 0.5; // 2;
    cr.set_source_rgba(Color.Red, Color.Green, Color.Blue, Color.Alpha);
    cr.move_to(x, 0);
    cr.line_to(x, dist);
    cr.move_to(0, x);
    cr.line_to(dist, x);
    cr.line_width := PenWidth;
    cr.stroke;
  finally
    cr.Free;
  end;
end;

function TBrushPattern.CreateLineSurface(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoSurface;
var
  cr: TContext;
  x: Double;
  yDist: Double;
begin
  yDist := TContext.getLineStyleLength(LineStyle);
  result := tCaImageSurface.Create(CAIRO_FORMAT_ARGB32, dist, round(yDist));
  cr := TContext.Create(result);
  try
    x := dist - 0.5; // 2;
    cr.set_source_rgba(Color.Red, Color.Green, Color.Blue, Color.Alpha);
    cr.setLineStyle(LineStyle);
    cr.move_to(x, 0);
    cr.line_to(x, yDist);
    cr.line_width := PenWidth;
    cr.stroke;
  finally
    cr.Free;
  end;
end;

class function TBrushPattern.CreateLinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double = 1.0)
  : ICairoPattern;
var
  local: TBrushPattern;
  ls: ICairoSurface;
begin
  local := TBrushPattern.Create;
  try
    ls := local.CreateLineSurface(dist, Color, LineStyle, PenWidth);
    try
      result := TSurfacePattern.Create(ls.Handle);
    finally
      ls := NIL;
    end;
  finally
    local.Free;
  end;

end;

class function TBrushPattern.Create2LinePattern(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double)
  : ICairoPattern;
var
  local: TBrushPattern;
  ls: ICairoSurface;
begin
  local := TBrushPattern.Create;
  try
    ls := local.Create2LineSurface(dist, Color, LineStyle, PenWidth);
    try
      result := TSurfacePattern.Create(ls.Handle);
    finally
      ls := nil;
    end;
  finally
    local.Free;
  end;
end;

function TBrushPattern.Create2LineSurface(dist: integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoSurface;
var
  cr: TContext;
  x: Double;
  yDist: Double;
begin
  yDist := TContext.getLineStyleLength(LineStyle);
  result := tCaImageSurface.Create(CAIRO_FORMAT_ARGB32, dist, round(yDist));
  cr := TContext.Create(result);
  try
    x := dist - 0.5; // 2;
    cr.set_source_rgba(Color.Red, Color.Green, Color.Blue, Color.Alpha);
    cr.setLineStyle(LineStyle);
    cr.move_to(x, 0);
    cr.line_to(x, yDist);
    cr.line_width := PenWidth;
    cr.stroke;

    x := (dist / 2) - 0.5;
    cr.setLineStyle(lsSolid);
    cr.move_to(x, 0);
    cr.line_to(x, yDist);
    cr.line_width := PenWidth;
    cr.stroke;

  finally
    cr.Free;
  end;
end;

end.
