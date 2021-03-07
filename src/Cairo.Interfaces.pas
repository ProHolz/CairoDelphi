unit Cairo.Interfaces;

interface

uses
  Winapi.Windows,
  System.Uitypes,
  System.classes,
  Cairo.Types,
  Cairo.Base;

type
  TCairoLineStyle = (lsSolid, lsDash, lsDot, lsDashDot, lsDashDotDot);
  TCairoGradientType = (tgtLine, tgthor, tgtVert, tgtDiagonal);
  TCairoArcType = (acArc, acArcTo, acArcAngle, acPie, acChoord);
  TCairoArcDirection = (clockwise, counterclockwise);

  // Forwards
  ICairoSurface = interface;
  ICairoContext = interface;
  ICairoFont = interface;
  ICairoScaledFont = interface;
  ICairoPattern = interface;

  ICairoContext = interface
  ['{D9FB5149-8B52-4074-831E-34838CD32221}']
{$REGION 'Setter / Getter'}
    function Get_antialias: cairo_antialias_t;
    function Get_fill_rule: cairo_fill_rule_t;
    function Get_Handle: Pcairo_t;
    function Get_line_cap: cairo_line_cap_t;
    function Get_line_join: cairo_line_join_t;
    function Get_line_width: Double;
    function Get_miter_limit: Double;
    function Get_operator: cairo_operator_t;
    function Get_target: ICairoSurface;
    procedure Set_operator(const Value: cairo_operator_t);
    procedure Set_antialias(const Value: cairo_antialias_t);
    procedure set_dash(const dashes: array of Double; const offset: Double = 0.0);
    procedure Set_fill_rule(const Value: cairo_fill_rule_t);
    procedure Set_line_cap(const Value: cairo_line_cap_t);
    procedure Set_line_join(const Value: cairo_line_join_t);
    procedure Set_line_width(const Value: Double);
    procedure Set_miter_limit(const Value: Double);

     function Get_ArcDirection: TCairoArcDirection;
    procedure Set_ArcDirection(const Value: TCairoArcDirection);

{$ENDREGION}
{$REGION 'methods'}
    procedure restore;
    procedure save;

    procedure SetCairoFont(Value: ICairoFont);
    // Helper funcs
    procedure setColor(Value: Tcolor; const alpha: Double = 1.0);
    procedure setLineStyle(Value: TCairoLineStyle);
    procedure set_source(const source: ICairoPattern);
    procedure set_source_rgb(red: Double; green: Double; blue: Double);
    procedure set_source_rgba(red: Double; green: Double; blue: Double; alpha: Double);
    procedure set_source_surface(Surface: ICairoSurface; x: Double; y: Double);
    procedure Set_target(const Value: ICairoSurface);
    function status: cairo_status_t;
    // Arcs
    procedure ArcDraw(arctype: TCairoArcType; x1, y1, x2, y2, X3, Y3, X4, Y4: Double; var px, py : double); overload;
    procedure ArcDraw(arctype: TCairoArcType; x1, y1, x2, y2, X3, Y3, X4, Y4: Integer); overload;
    procedure arc(xc: Double; yc: Double; radius: Double; angle1: Double; angle2: Double);
    procedure arc_negative(xc: Double; yc: Double; radius: Double; angle1: Double; angle2: Double);
    procedure curve_to(x1: Double; y1: Double; x2: Double; y2: Double; X3: Double; Y3: Double);
    procedure rel_curve_to(dx1: Double; dy1: Double; dx2: Double; dy2: Double; dx3: Double; dy3: Double);
    procedure circle(xc: Double; yc: Double; radius: Double);
    procedure circle_negative(xc: Double; yc: Double; radius: Double);

    // Lines
    procedure move_to(x: Double; y: Double);
    procedure line_to(x: Double; y: Double);
    procedure rectangle(x: Double; y: Double; width: Double; height: Double);
    procedure rel_move_to(dx: Double; dy: Double);
    procedure rel_line_to(dx: Double; dy: Double);

    // Fill and stroke
    procedure stroke;
    procedure stroke_preserve;
    procedure fill;
    procedure fill_preserve;

  // Path
    procedure new_path;
    procedure new_sub_path;
    procedure close_path;

   // Paint
    procedure paint;
    procedure paint_with_alpha(alpha: Double);
    procedure mask(Pattern: Pcairo_pattern_t);
   // procedure mask_surface(Surface: ICairoSurface; surface_x: Double; surface_y: Double);


  // Text
    procedure text_path(const Value: string);
    procedure text_Clusters(const Value: string; scaled_font: ICairoScaledFont);
    procedure set_font_size(size: Double);

  //Ctx
    procedure translate(tx: Double; ty: Double);
    procedure scale(Sx: Double; Sy: Double);
    procedure rotate(angle: Double);
    procedure transform(matrix: Pcairo_matrix_t);
    procedure set_matrix(matrix: Pcairo_matrix_t);
    procedure get_matrix(matrix: Pcairo_matrix_t);
    procedure identity_matrix;

    // Clip

    procedure reset_clip;
    procedure clip;
    procedure clip_preserve;
    procedure clip_extents(out x1: Double; out y1: Double; out x2: Double; out y2: Double);


{$ENDREGION}
{$REGION 'Properties'}
    //
    property &operator: cairo_operator_t read Get_operator write Set_operator;
    property antialias: cairo_antialias_t read Get_antialias write Set_antialias;
    property fill_rule: cairo_fill_rule_t read Get_fill_rule write Set_fill_rule;
    property Handle: Pcairo_t read Get_Handle;
    property line_cap: cairo_line_cap_t read Get_line_cap write Set_line_cap;
    property line_join: cairo_line_join_t read Get_line_join write Set_line_join;
    property line_width: Double read Get_line_width write Set_line_width;
    property miter_limit: Double read Get_miter_limit write Set_miter_limit;
    property target: ICairoSurface read Get_target write Set_target;
    property ArcDirection: TCairoArcDirection read Get_ArcDirection write Set_ArcDirection;
{$ENDREGION}
  end;


  ICairoSurface = interface
  ['{040D779E-FF7A-401F-9224-33B5A64430FA}']
{$REGION 'Setter / Getter'}
    function GetHandle: Pcairo_surface_t;
{$ENDREGION}
{$REGION 'methods'}
    function reference: Pcairo_surface_t;
    function get_reference_count: Cardinal;

    /// <summary>Do any pending drawing for the surface and also restore any temporary
    /// modifications cairo has made to the surface's state. This function must be
    /// called before switching from drawing on the surface with cairo to drawing on it
    /// directly with native APIs, or accessing its memory outside of Cairo. If the
    /// surface doesn't support direct access, then this function does nothing.
    /// </summary>
    procedure flush;

    /// <summary>Tells cairo that drawing has been done to surface using means other
    /// than cairo, and that cairo should reread any cached areas. Note that you must
    /// call cairo_surface_flush() before doing such drawing.
    /// </summary>
    procedure mark_dirty;

    procedure show_page;
    procedure copy_page;
    procedure set_device_scale(x_scale, y_scale: Double);

    /// <summary>
    /// Like cairo_surface_mark_dirty(), but drawing has been done only to the
    /// specified rectangle, so that cairo can retain cached contents for other parts
    /// of the surface.
    ///
    /// Any cached clip set on the surface will be reset by this function, to make sure
    /// that future cairo calls have the clip set that they expect.
    /// </summary>
    /// <param name="x"> (Integer) </param>
    /// <param name="y"> (Integer) </param>
    /// <param name="width"> (Integer) </param>
    /// <param name="height"> (Integer) </param>
    procedure mark_dirty_rectangle(x: Integer; y: Integer; width: Integer; height: Integer);


    /// <summary>
    ///  Returns the Type of the Surface
    /// </summary>
    /// <returns> cairo_surface_type_t
    /// </returns>
    function get_type: cairo_surface_type_t;

    /// <summary>This function returns the content type of surface which indicates
    /// whether the surface contains color and/or alpha information. See
    /// cairo_content_t.
    /// </summary>
    /// <returns> cairo_content_t
    /// </returns>
    function get_content: cairo_content_t;


    /// <summary> Checks whether an error has previously occurred for this surface.
    /// </summary>
    /// <returns> cairo_status_t
    /// </returns>
    function status: cairo_status_t;

{$ENDREGION}
{$REGION 'properties '}
    property Handle: Pcairo_surface_t read GetHandle;
{$ENDREGION}
  end;


  iCairoRecordingSurface = interface(ICairoSurface)
  ['{28BF5CF3-3A1B-4EC7-B140-CAC4A046FFC2}']
     function get_extents(var extents: cairo_rectangle_t): cairo_bool_t;
     procedure ink_extents(var x0, y0, width, height: Double);
  end;


  ICairoFont = interface
  ['{6ADDD88F-6941-4AC6-83D6-8DE90C457E5D}']
    procedure setToCairo(Cairo: Pcairo_t);
    function text_extents(const Value: String): cairo_text_extents_t;
    function extents: cairo_font_extents_t;
  end;


  ICairoScaledFont = interface(ICairoFont)
  ['{A78CE7C0-B221-4F33-9EE3-795F2EB81841}']
    function handle : Pcairo_scaled_font_t;
  end;

  ICairoPattern = interface
  ['{141E7125-7E55-4DD8-A2FD-B5957A5CE414}']
    procedure setAsSource(const cr: Pcairo_t);
    procedure Translate(tx, ty: Double);
    procedure Rotate(Degrees: Double);
    procedure Scale(sx, sy: Double);

    // Gradient
    procedure add_color_stop_rgba(offset: Double; Value: TCairoColor);

  end;


  ICairoFactory = interface
  ['{0594EF28-3B7A-4120-913F-DF655761D31B}']
    // Surfaces
    function createGDI(hdc: hdc): ICairoSurface;
    function createGDI_with_format(hdc: hdc; format: cairo_format_t): ICairoSurface;
    function CreateRecording(Handle : Pcairo_surface_t) : ICairoSurface;
    function CreatePdf(const filename : String; Sizew, SizeH : Double) : ICairoSurface;
    function CreateSVG(const filename : String; Sizew, SizeH : Double) : ICairoSurface;
    // Context

    function CreateContext(Target: ICairoSurface): ICairoContext;

    // Pattern
    function Patterncreate_rgb(red: Double; green: Double; blue: Double): ICairoPattern;
    function Patterncreate_rgba(red: Double; green: Double; blue: Double; alpha: Double): ICairoPattern;
    function Patterncreate_rgbColor(Value: TCairoColor): ICairoPattern;
    function Patterncreate_rgbaColor(Value: TCairoColor): ICairoPattern;

    function Patterncreate_linear(x0: Double; y0: Double; x1: Double; y1: Double): ICairoPattern;
    function Patterncreate_linearWH(x0: Double; y0: Double; W: Double; H: Double): ICairoPattern;
    function Patterncreate_linearType(Value: TCairoGradientType): ICairoPattern;

    function CreateCrossPattern(dist: Integer; Color: TCairoColor; PenWidth: Double = 1.0): ICairoPattern;
    function CreateLinePattern(dist: Integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double = 1.0): ICairoPattern;
    function Create2LinePattern(dist: Integer; Color: TCairoColor; LineStyle: TCairoLineStyle; PenWidth: Double): ICairoPattern;

    // Font
    function CreateFont(const alogfont : LOGFONT; aSize : Double) : ICairoFont;


    // Image
    function create_for_data(data: PByte; datasize: integer; format: cairo_format_t; width: Integer; height: Integer) : ICairoSurface;
    function create_from_Png(filename: String) : ICairoSurface;
    function create_from_PngStream(const aStream: TStream) : ICairoSurface;


  end;


function CairoFactory: ICairoFactory;

implementation

uses
  Cairo.Factory;

var GlobSurfaceFactory: ICairoFactory;

function CairoFactory: ICairoFactory;
begin
  if GlobSurfaceFactory = nil then
    GlobSurfaceFactory := tCairoFactory.Create;
  result := GlobSurfaceFactory;
end;


initialization

finalization

GlobSurfaceFactory := nil;

end.
