unit Cairo.Surface;

interface

uses
   winapi.windows,
   Cairo.Types,
   Cairo.Interfaces;

type
   TSurface = class(TInterfacedObject, ICairoSurface)
   strict private
      function GetHandle: Pcairo_surface_t;
   private
      fSurface: Pcairo_surface_t;
   protected
      function reference: Pcairo_surface_t;
      function get_reference_count: Cardinal;
      function get_user_data(key: Pcairo_user_data_key_t): Pointer;
      function set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;

      procedure get_mime_data(mime_type: PUTF8Char; data: PPByte; length: PCardinal);
      function set_mime_data(mime_type: PUTF8Char; data: PByte; length: Cardinal; Destroy: cairo_destroy_func_t; closure: Pointer): cairo_status_t;
      function supports_mime_type(mime_type: PUTF8Char): cairo_bool_t;

   // Map
      function map_to_image(extents: Pcairo_rectangle_int_t): Pcairo_surface_t;
      procedure unmap_image(image: Pcairo_surface_t);

      function create_similar(other: Pcairo_surface_t; content: cairo_content_t; width: Integer; height: Integer): Pcairo_surface_t;
      function create_similar_image(other: Pcairo_surface_t; format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t;
      function create_for_rectangle(target: Pcairo_surface_t; x: Double; y: Double; width: Double; height: Double): Pcairo_surface_t;

     // Device
      function get_device: Pcairo_device_t;
      procedure set_device_scale(x_scale, y_scale: Double);
      procedure get_device_scale(var x_scale, y_scale: Double);
      procedure set_device_offset(x_offset, y_offset: Double);
      procedure get_device_offset(var x_offset, y_offset: Double);

      procedure set_fallback_resolution(x_pixels_per_inch, y_pixels_per_inch: Double);
      procedure get_fallback_resolution(var x_pixels_per_inch, y_pixels_per_inch: Double);

      procedure get_font_options(options: pcairo_font_options_t);

      procedure copy_page;
      procedure show_page;  virtual;
      function has_show_text_glyphs: cairo_bool_t;
      procedure finish;
   public
    // Create Destroy Copy etc....
      constructor Create;
      destructor Destroy; override;
      procedure flush;
      procedure mark_dirty;
      procedure mark_dirty_rectangle(x: Integer; y: Integer; width: Integer; height: Integer);

// Information

      function status: cairo_status_t;
      function get_type: cairo_surface_type_t;
      function get_content: cairo_content_t;


//
      property Handle: Pcairo_surface_t read fSurface;

   end;

   TcaPdfSurface = class(TSurface)
   private
     fWidth : Double;
     fHeight : Double;
   protected
      procedure restrict_to_version(version: cairo_pdf_version_t);
      procedure get_versions(versions: PPcairo_pdf_version_t; num_versions: PInteger);
      function version_to_string(version: cairo_pdf_version_t): PUTF8Char;

      procedure set_size(width_in_points, height_in_points: Double);
      function add_outline(parent_id: Integer; utf8, link_attribs: PUTF8Char; flags: cairo_pdf_outline_flags_t): Integer;
      procedure set_metadata(metadata: cairo_pdf_metadata_t; utf8: PUTF8Char);
      procedure set_page_label(utf8: PUTF8Char);
      procedure set_thumbnail_size(width, height: Integer);
       procedure show_page;  override;
   public
      constructor create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double);
      constructor create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double);
   end;

   tCaImageSurface = class(TSurface)
   private
     fData : Pointer;
   protected
      // Image Surface
      function format_stride_for_width(format: cairo_format_t; width: Integer): Integer;

     // Image Device
   public
      constructor create(format: cairo_format_t; width: Integer; height: Integer);
      constructor create_for_data(data: PByte; format: cairo_format_t; width: Integer; height: Integer; stride: Integer);
      constructor create_from_png(const filename : string);
      constructor create_from_png_stream(read_func: cairo_read_func_t; closure: Pointer);
      destructor Destroy; override;
      function get_data: PByte;
      function get_format: cairo_format_t;
      function get_width: Integer;
      function get_height: Integer;
      function get_stride: Integer;

      // Png
      function write_to_png(filename: PUTF8Char): cairo_status_t;
      function write_to_png_stream(write_func: cairo_write_func_t; closure: Pointer): cairo_status_t;

   end;

   tCaRecordingSurface = class(TSurface, iCairoRecordingSurface)
   private
      procedure ink_extents(var x0, y0, width, height: Double);
      function get_extents(var extents: cairo_rectangle_t): cairo_bool_t;
    public
      // Recording Device
      constructor create(content: cairo_content_t); overload;
      constructor CreateWithHandle(Handle : Pcairo_surface_t);
      constructor create(content: cairo_content_t; extents: cairo_rectangle_t); overload;


   end;

   tCaSvgSurface = class(TSurface)
   protected
      procedure restrict_to_version(version: cairo_svg_version_t);
      procedure get_versions(versions: PPcairo_svg_version_t; num_versions: PInteger);
      function version_to_string(version: cairo_svg_version_t): PUTF8Char;
      procedure set_document_unit(&unit: cairo_svg_unit_t);
      function get_document_unit: cairo_svg_unit_t;

   public
      constructor create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double);
      constructor create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double);

   end;

   TcaScriptSurface = class(TSurface)
   protected
      procedure write_comment(script: Pcairo_device_t; comment: PUTF8Char; len: Integer);
      procedure set_mode(script: Pcairo_device_t; mode: cairo_script_mode_t);
      function get_mode(script: Pcairo_device_t): cairo_script_mode_t;
      function surface_create(script: Pcairo_device_t; content: cairo_content_t; width: Double; height: Double): Pcairo_surface_t;
      function surface_create_for_target(script: Pcairo_device_t; target: Pcairo_surface_t): Pcairo_surface_t;
      function from_recording_surface(script: Pcairo_device_t; recording_surface: Pcairo_surface_t): cairo_status_t;

   public
      constructor create(filename: PUTF8Char);
      constructor create_for_stream(write_func: cairo_write_func_t; closure: Pointer);
   end;

   TcaGdiSurface = class(TSurface)
   protected
      function printing_surface_create(hdc: hdc): Pcairo_surface_t;
      function create_with_ddb(hdc: hdc; format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t;
      function create_with_dib(format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t;
      function get_dc: hdc;
      function get_image: Pcairo_surface_t;

   public
      constructor create(hdc: hdc);
      constructor create_with_format(hdc: hdc; format: cairo_format_t);
      constructor create_as_DIB(format: cairo_format_t; width, Height : integer);


   end;

   TcaPSSurface = class(TSurface)
   protected
      procedure restrict_to_level(level: cairo_ps_level_t);
      procedure get_levels(levels: PPcairo_ps_level_t; num_levels: PInteger);
      function level_to_string(level: cairo_ps_level_t): PUTF8Char;
      procedure set_eps(eps: cairo_bool_t);
      function get_eps: cairo_bool_t;
      procedure set_size(width_in_points, height_in_points: Double);
      procedure dsc_comment(comment: PUTF8Char);
      procedure dsc_begin_setup;
      procedure dsc_begin_page_setup;

   public
      constructor create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double);
      constructor create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double);

   end;

  

implementation

uses
   Cairo.Dll;
{ TcaSurface }

function TSurface.create_similar(other: Pcairo_surface_t; content: cairo_content_t; width, height: Integer): Pcairo_surface_t;
begin
   result := cairo_surface_create_similar(other, content, width, height);
end;

function TSurface.create_similar_image(other: Pcairo_surface_t; format: cairo_format_t; width, height: Integer): Pcairo_surface_t;
begin
   result := cairo_surface_create_similar_image(other, format, width, height);
end;

function TSurface.create_for_rectangle(target: Pcairo_surface_t; x, y, width, height: Double): Pcairo_surface_t;
begin
   result := cairo_surface_create_for_rectangle(target, x, y, width, height);
end;

procedure TSurface.finish;
begin
   cairo_surface_finish(fSurface);
end;

destructor TSurface.Destroy;
begin
   cairo_surface_destroy(fSurface);
   inherited;
end;

procedure TSurface.flush;
begin
   cairo_surface_flush(fSurface);
end;

procedure TSurface.mark_dirty;
begin
   cairo_surface_mark_dirty(fSurface);
end;

procedure TSurface.mark_dirty_rectangle(x: Integer; y: Integer; width: Integer; height: Integer);
begin
   cairo_surface_mark_dirty_rectangle(fSurface, x, y, width, height);
end;

function TSurface.reference: Pcairo_surface_t;
begin
   result := cairo_surface_reference(fSurface);
end;

function TSurface.get_reference_count: Cardinal;
begin
   result := cairo_surface_get_reference_count(fSurface);
end;

function TSurface.status: cairo_status_t;
begin
   result := cairo_surface_status(fSurface);
end;

function TSurface.get_type: cairo_surface_type_t;
begin
   result := cairo_surface_get_type(fSurface);
end;

function TSurface.get_content: cairo_content_t;
begin
   result := cairo_surface_get_content(fSurface);
end;

function TSurface.get_user_data(key: Pcairo_user_data_key_t): Pointer;
begin
   result := cairo_surface_get_user_data(fSurface, key);
end;

function TSurface.set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;
begin
   result := cairo_surface_set_user_data(fSurface, key, user_data, Destroy);
end;

procedure TSurface.get_mime_data(mime_type: PUTF8Char; data: PPByte; length: PCardinal);
begin
   cairo_surface_get_mime_data(fSurface, mime_type, data, length);
end;

function TSurface.set_mime_data(mime_type: PUTF8Char; data: PByte; length: Cardinal; Destroy: cairo_destroy_func_t; closure: Pointer): cairo_status_t;
begin
   result := cairo_surface_set_mime_data(fSurface, mime_type, data, length, Destroy, closure);
end;

function TSurface.supports_mime_type(mime_type: PUTF8Char): cairo_bool_t;
begin
   result := cairo_surface_supports_mime_type(fSurface, mime_type);
end;

procedure TSurface.get_font_options(options: pcairo_font_options_t);
begin
   cairo_surface_get_font_options(fSurface, options);
end;

procedure TSurface.copy_page;
begin
   cairo_surface_copy_page(fSurface);
end;

procedure TSurface.show_page;
begin
   cairo_surface_show_page(fSurface);
end;

function TSurface.has_show_text_glyphs: cairo_bool_t;
begin
   result := cairo_surface_has_show_text_glyphs(fSurface);
end;

function TSurface.map_to_image(extents: Pcairo_rectangle_int_t): Pcairo_surface_t;
begin
   result := cairo_surface_map_to_image(fSurface, extents);
end;

procedure TSurface.unmap_image(image: Pcairo_surface_t);
begin
   cairo_surface_unmap_image(fSurface, image);
end;

function TSurface.get_device: Pcairo_device_t;
begin
   result := cairo_surface_get_device(fSurface);
end;

procedure TSurface.set_device_scale(x_scale, y_scale: Double);
begin
   cairo_surface_set_device_scale(fSurface, x_scale, y_scale);
end;

procedure TSurface.get_device_scale(var x_scale, y_scale: Double);
begin
   cairo_surface_get_device_scale(fSurface, @x_scale, @y_scale);
end;

procedure TSurface.set_device_offset(x_offset, y_offset: Double);
begin
   cairo_surface_set_device_offset(fSurface, x_offset, y_offset);
end;

procedure TSurface.get_device_offset(var x_offset, y_offset: Double);
begin
   cairo_surface_get_device_offset(fSurface, @x_offset, @y_offset);
end;

procedure TSurface.set_fallback_resolution(x_pixels_per_inch, y_pixels_per_inch: Double);
begin
   cairo_surface_set_fallback_resolution(fSurface, x_pixels_per_inch, y_pixels_per_inch);
end;

procedure TSurface.get_fallback_resolution(var x_pixels_per_inch, y_pixels_per_inch: Double);
begin
   cairo_surface_get_fallback_resolution(fSurface, @x_pixels_per_inch, @y_pixels_per_inch);
end;

{ TcaPdfSurface }

constructor TcaPdfSurface.create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double);
begin
   inherited create;
   fWidth := width_in_points;
   fHeight := height_in_points;
   fSurface := cairo_pdf_surface_create(filename, width_in_points, height_in_points);
end;

constructor TcaPdfSurface.create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double);
begin
   inherited create;
   fWidth := width_in_points;
   fHeight := height_in_points;
   fSurface := cairo_pdf_surface_create_for_stream(write_func, closure, width_in_points, height_in_points);
end;

procedure TcaPdfSurface.restrict_to_version(version: cairo_pdf_version_t);
begin
   cairo_pdf_surface_restrict_to_version(fSurface, version);
end;

procedure TcaPdfSurface.get_versions(versions: PPcairo_pdf_version_t; num_versions: PInteger);
begin
   cairo_pdf_get_versions(versions, num_versions);
end;

function TcaPdfSurface.version_to_string(version: cairo_pdf_version_t): PUTF8Char;
begin
   result := cairo_pdf_version_to_string(version);
end;

procedure TcaPdfSurface.set_size(width_in_points, height_in_points: Double);
begin
   cairo_pdf_surface_set_size(fSurface, width_in_points, height_in_points);
end;

function TcaPdfSurface.add_outline(parent_id: Integer; utf8, link_attribs: PUTF8Char; flags: cairo_pdf_outline_flags_t): Integer;
begin
   result := cairo_pdf_surface_add_outline(fSurface, parent_id, utf8, link_attribs, flags);
end;

procedure TcaPdfSurface.set_metadata(metadata: cairo_pdf_metadata_t; utf8: PUTF8Char);
begin
   cairo_pdf_surface_set_metadata(fSurface, metadata, utf8);
end;

procedure TcaPdfSurface.set_page_label(utf8: PUTF8Char);
begin
   cairo_pdf_surface_set_page_label(fSurface, utf8);
end;

procedure TcaPdfSurface.set_thumbnail_size(width, height: Integer);
begin
   cairo_pdf_surface_set_thumbnail_size(fSurface, width, height);
end;

procedure TcaPdfSurface.show_page;
begin
  inherited;
  set_size(fwidth, fheight);
end;
{ tCaImageSurface }

function tCaImageSurface.format_stride_for_width(format: cairo_format_t; width: Integer): Integer;
begin
   result := cairo_format_stride_for_width(format, width);
end;

constructor tCaImageSurface.create(format: cairo_format_t; width: Integer; height: Integer);
begin
   inherited create;
   fSurface := cairo_image_surface_create(format, width, height);
end;

constructor tCaImageSurface.create_for_data(data: PByte; format:
    cairo_format_t; width: Integer; height: Integer; stride: Integer);
begin
  inherited create;
  getmem(fdata, Stride*(height-1));
  move(data^, fdata^, Stride*(height-1));
   fsurface := cairo_image_surface_create_for_data(fdata, format, width, height, stride);
end;

function tCaImageSurface.get_data: PByte;
begin
   result := cairo_image_surface_get_data(fSurface);
end;

function tCaImageSurface.get_format: cairo_format_t;
begin
   result := cairo_image_surface_get_format(fSurface);
end;

function tCaImageSurface.get_width: Integer;
begin
   result := cairo_image_surface_get_width(fSurface);
end;

function tCaImageSurface.get_height: Integer;
begin
   result := cairo_image_surface_get_height(fSurface);
end;

function tCaImageSurface.get_stride: Integer;
begin
   result := cairo_image_surface_get_stride(fSurface);
end;

constructor tCaImageSurface.create_from_png(const filename : string);
begin
  inherited Create;
   fSurface := cairo_image_surface_create_from_png(Pansichar(Utf8String(  filename)));
end;

constructor tCaImageSurface.create_from_png_stream(read_func:
    cairo_read_func_t; closure: Pointer);

begin
   inherited Create;
   fSurface := cairo_image_surface_create_from_png_stream(read_func, closure);
end;

function tCaImageSurface.write_to_png(filename: PUTF8Char): cairo_status_t;
begin
   result := cairo_surface_write_to_png(fSurface, filename);
end;

function tCaImageSurface.write_to_png_stream(write_func: cairo_write_func_t; closure: Pointer): cairo_status_t;
begin
   result := cairo_surface_write_to_png_stream(fSurface, write_func, closure);
end;

destructor tCaImageSurface.Destroy;
begin
  if fdata <> nil then freemem(fdata);
  
  inherited;
end;

{ tCaRecordingSurface }


procedure tCaRecordingSurface.ink_extents(var x0, y0, width, height: Double);
begin
   cairo_recording_surface_ink_extents(fSurface, @x0, @y0, @width, @height);
end;

constructor tCaRecordingSurface.create(content: cairo_content_t);
begin
 inherited create;
 fSurface := cairo_recording_surface_create(content, nil);
end;

constructor tCaRecordingSurface.create(content: cairo_content_t;
  extents: cairo_rectangle_t);
begin
 inherited create;
   fSurface := cairo_recording_surface_create(content, @extents);
end;


constructor tCaRecordingSurface.CreateWithHandle(Handle: Pcairo_surface_t);
begin
 inherited create;
 fSurface := Handle;
end;

function tCaRecordingSurface.get_extents(var extents: cairo_rectangle_t): cairo_bool_t;
begin
   result := cairo_recording_surface_get_extents(fSurface, @extents);
end;


{ tCaSvgSurface }

constructor tCaSvgSurface.create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double);
begin
   inherited create;
   fSurface := cairo_svg_surface_create(filename, width_in_points, height_in_points);
end;

constructor tCaSvgSurface.create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double);
begin
   inherited create;
   fSurface := cairo_svg_surface_create_for_stream(write_func, closure, width_in_points, height_in_points);
end;

procedure tCaSvgSurface.restrict_to_version(version: cairo_svg_version_t);
begin
   cairo_svg_surface_restrict_to_version(fSurface, version);
end;

procedure tCaSvgSurface.get_versions(versions: PPcairo_svg_version_t; num_versions: PInteger);
begin
   cairo_svg_get_versions(versions, num_versions);
end;

function tCaSvgSurface.version_to_string(version: cairo_svg_version_t): PUTF8Char;
begin
   result := cairo_svg_version_to_string(version);
end;

procedure tCaSvgSurface.set_document_unit(&unit: cairo_svg_unit_t);
begin
   cairo_svg_surface_set_document_unit(fSurface, &unit);
end;

function tCaSvgSurface.get_document_unit: cairo_svg_unit_t;
begin
   result := cairo_svg_surface_get_document_unit(fSurface);
end;

{ TcaScriptSurface }

constructor TcaScriptSurface.create(filename: PUTF8Char);
begin
   inherited create;
   fSurface := cairo_script_create(filename);
end;

constructor TcaScriptSurface.create_for_stream(write_func: cairo_write_func_t; closure: Pointer);
begin
   inherited create;
   fSurface := cairo_script_create_for_stream(write_func, closure);
end;

procedure TcaScriptSurface.write_comment(script: Pcairo_device_t; comment: PUTF8Char; len: Integer);
begin
   cairo_script_write_comment(script, comment, len);
end;

procedure TcaScriptSurface.set_mode(script: Pcairo_device_t; mode: cairo_script_mode_t);
begin
   cairo_script_set_mode(script, mode);
end;

function TcaScriptSurface.get_mode(script: Pcairo_device_t): cairo_script_mode_t;
begin
   result := cairo_script_get_mode(script);
end;

function TcaScriptSurface.surface_create(script: Pcairo_device_t; content: cairo_content_t; width, height: Double): Pcairo_surface_t;
begin
   result := cairo_script_surface_create(script, content, width, height);
end;

function TcaScriptSurface.surface_create_for_target(script: Pcairo_device_t; target: Pcairo_surface_t): Pcairo_surface_t;
begin
   result := cairo_script_surface_create_for_target(script, target);
end;

function TcaScriptSurface.from_recording_surface(script: Pcairo_device_t; recording_surface: Pcairo_surface_t): cairo_status_t;
begin
   result := cairo_script_from_recording_surface(script, recording_surface);
end;

{ TcaGdiSurface }

constructor TcaGdiSurface.create(hdc: hdc);

begin
   inherited create;
   fSurface := cairo_win32_surface_create(hdc);
end;


function TcaGdiSurface.printing_surface_create(hdc: hdc): Pcairo_surface_t;
begin
   result := cairo_win32_printing_surface_create(hdc);
end;

function TcaGdiSurface.create_with_ddb(hdc: hdc; format: cairo_format_t; width, height: Integer): Pcairo_surface_t;
begin
   result := cairo_win32_surface_create_with_ddb(hdc, format, width, height);
end;

function TcaGdiSurface.create_with_dib(format: cairo_format_t; width, height: Integer): Pcairo_surface_t;
begin
   result := cairo_win32_surface_create_with_dib(format, width, height);
end;

function TcaGdiSurface.get_dc: hdc;
begin
   result := cairo_win32_surface_get_dc(fSurface);
end;

function TcaGdiSurface.get_image: Pcairo_surface_t;
begin
   result := cairo_win32_surface_get_image(fSurface);
end;

constructor TcaGdiSurface.create_with_format(hdc: hdc; format: cairo_format_t);
begin
  inherited create;
   fSurface := cairo_win32_surface_create_with_format(hdc, Format);
end;


constructor TcaGdiSurface.create_as_DIB(format: cairo_format_t; width, Height: integer);
begin
 inherited create;
 fSurface := create_with_dib(format, width, Height);
end;

{ TcaPSSurface }

constructor TcaPSSurface.create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double);
begin
   inherited create;
   fSurface := cairo_ps_surface_create(filename, width_in_points, height_in_points);
end;

constructor TcaPSSurface.create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double);
begin
   inherited create;
   fSurface := cairo_ps_surface_create_for_stream(write_func, closure, width_in_points, height_in_points);
end;

procedure TcaPSSurface.restrict_to_level(level: cairo_ps_level_t);
begin
   cairo_ps_surface_restrict_to_level(fSurface, level);
end;

procedure TcaPSSurface.get_levels(levels: PPcairo_ps_level_t; num_levels: PInteger);
begin
   cairo_ps_get_levels(levels, num_levels);
end;

function TcaPSSurface.level_to_string(level: cairo_ps_level_t): PUTF8Char;
begin
   result := cairo_ps_level_to_string(level);
end;

procedure TcaPSSurface.set_eps(eps: cairo_bool_t);
begin
   cairo_ps_surface_set_eps(fSurface, eps);
end;

function TcaPSSurface.get_eps: cairo_bool_t;
begin
   result := cairo_ps_surface_get_eps(fSurface);
end;

procedure TcaPSSurface.set_size(width_in_points, height_in_points: Double);
begin
   cairo_ps_surface_set_size(fSurface, width_in_points, height_in_points);
end;

procedure TcaPSSurface.dsc_comment(comment: PUTF8Char);
begin
   cairo_ps_surface_dsc_comment(fSurface, comment);
end;

procedure TcaPSSurface.dsc_begin_setup;
begin
   cairo_ps_surface_dsc_begin_setup(fSurface);
end;

procedure TcaPSSurface.dsc_begin_page_setup;
begin
   cairo_ps_surface_dsc_begin_page_setup(fSurface);
end;

constructor TSurface.Create;
begin
 inherited Create;
end;

function TSurface.GetHandle: Pcairo_surface_t;
begin
 result := fSurface;
end;

end.
