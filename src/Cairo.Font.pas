unit Cairo.Font;

interface

uses
   Winapi.Windows,
   Cairo.Types,
   Cairo.Interfaces;

type

   TCairoFontBase = class(TInterfacedObject, ICairoFont)
   private
      fFontOptions: Pcairo_font_options_t;

   protected
      function font_options_copy(original: Pcairo_font_options_t): Pcairo_font_options_t;
    // Font Options
      function font_options_create: Pcairo_font_options_t;
      procedure font_options_destroy;
      function font_options_equal(other: Pcairo_font_options_t): cairo_bool_t;
      function font_options_get_antialias: cairo_antialias_t;
      function font_options_get_hint_metrics: cairo_hint_metrics_t;
      function font_options_get_hint_style: cairo_hint_style_t;
      function font_options_get_subpixel_order: cairo_subpixel_order_t;
      function font_options_hash: Cardinal;
      procedure font_options_merge(other: Pcairo_font_options_t);
      procedure font_options_set_antialias(antialias: cairo_antialias_t);
      procedure font_options_set_hint_metrics(hint_metrics: cairo_hint_metrics_t);
      procedure font_options_set_hint_style(hint_style: cairo_hint_style_t);
      procedure font_options_set_subpixel_order(subpixel_order: cairo_subpixel_order_t);
      function font_options_status: cairo_status_t;

   public
      constructor create;
      destructor Destroy; override;
      procedure setToCairo(Cairo: Pcairo_t); virtual; abstract;
      function text_extents(const Value : String): cairo_text_extents_t; virtual; abstract;
      function extents: cairo_font_extents_t; virtual; abstract;
   end;

   TCairoFont = class(TCairoFontBase)
   private
      ffont_face: Pcairo_font_face_t;

    // Font Face
    protected  // For Compiler Happy
      function font_face_reference: Pcairo_font_face_t;
      procedure font_face_destroy;
      function font_face_get_reference_count: Cardinal;
      function font_face_status: cairo_status_t;
      function font_face_get_type: cairo_font_type_t;
      function face_get_user_data(key: Pcairo_user_data_key_t): Pointer;
      function font_face_set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;

      function glyph_allocate(num_glyphs: Integer): Pcairo_glyph_t;
      procedure glyph_free(glyphs: Pcairo_glyph_t);
      function text_cluster_allocate(num_clusters: Integer): Pcairo_text_cluster_t;
      procedure text_cluster_free(clusters: Pcairo_text_cluster_t);


   public
      constructor create(font_face: Pcairo_font_face_t);
      destructor Destroy; override;

      procedure setToCairo(Cairo: Pcairo_t); override;
   end;

   TCairoScaledFont = class(TCairoFontBase)
   private
      fscaled_font: Pcairo_scaled_font_t;

   // cairo_scaled_font_
    protected  // For Compiler Happy
      function reference: Pcairo_scaled_font_t;

      function get_reference_count: Cardinal;

      function get_type: cairo_font_type_t;
      function get_user_data(key: Pcairo_user_data_key_t): Pointer;
      function set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;

      procedure glyph_extents(glyphs: Pcairo_glyph_t; num_glyphs: Integer; extents: Pcairo_text_extents_t);
      function text_to_glyphs(x, y: Double; utf8: PUTF8Char; utf8_len: Integer; glyphs: PPcairo_glyph_t; num_glyphs: PInteger; clusters: PPcairo_text_cluster_t;
       num_clusters: PInteger; cluster_flags: Pcairo_text_cluster_flags_t): cairo_status_t;
      function get_font_face: Pcairo_font_face_t;
      procedure get_font_matrix(font_matrix: Pcairo_matrix_t);
      procedure get_ctm(ctm: Pcairo_matrix_t);
      procedure get_scale_matrix(scale_matrix: Pcairo_matrix_t);
      procedure get_font_options(options: Pcairo_font_options_t);

   public
      constructor create(font_face: Pcairo_font_face_t; Fontheight: Double);
      destructor Destroy; override;
      procedure setToCairo(Cairo: Pcairo_t); override;
      function text_extents(const Value : String): cairo_text_extents_t; override;
      function extents: cairo_font_extents_t; override;
      function status: cairo_status_t;
   end;

   // Win32
   TScaledWinFont = class(TCairoScaledFont, ICairoScaledFont)
   strict private
      function handle: Pcairo_scaled_font_t;
   protected   // For Compiler Happy
     // cairo_win32_font_face_
      function font_face_create_for_logfontw(logfont: PLOGFONTW): Pcairo_font_face_t;

      function font_face_create_for_logfontw_hfont(logfont: PLOGFONTW; Font: HFONT): Pcairo_font_face_t;
      function scaled_font_select_font(scaled_font: Pcairo_scaled_font_t; hdc: hdc): cairo_status_t;
      procedure scaled_font_done_font(scaled_font: Pcairo_scaled_font_t);
      function scaled_font_get_metrics_factor(scaled_font: Pcairo_scaled_font_t): Double;
      procedure scaled_font_get_logical_to_device(scaled_font: Pcairo_scaled_font_t; logical_to_device: Pcairo_matrix_t);
      procedure scaled_font_get_device_to_logical(scaled_font: Pcairo_scaled_font_t; device_to_logical: Pcairo_matrix_t);

   public
      constructor create_for_hfont(Font: HFONT; Fontheight: Double);
      constructor create_for_logfont(const Font: LOGFONT; Fontheight: Double);
      destructor Destroy; override;
   end;

   // Win32
   TWinFont = class(TCairoFont)
   protected   // For Compiler Happy
   public
      constructor create_for_hfont(Font: HFONT);
      destructor Destroy; override;
   end;

implementation

uses
   System.Math,
   Cairo.dll;

function TCairoFont.font_face_reference: Pcairo_font_face_t;
begin
   result := cairo_font_face_reference(ffont_face);
end;

procedure TCairoFont.font_face_destroy;
begin
   cairo_font_face_destroy(ffont_face);
end;

function TCairoFont.font_face_get_reference_count: Cardinal;
begin
   result := cairo_font_face_get_reference_count(ffont_face);
end;

function TCairoFont.font_face_status: cairo_status_t;
begin
   result := cairo_font_face_status(ffont_face);
end;

function TCairoFont.font_face_get_type: cairo_font_type_t;
begin
   result := cairo_font_face_get_type(ffont_face);
end;

function TCairoFont.face_get_user_data(key: Pcairo_user_data_key_t): Pointer;
begin
   result := cairo_font_face_get_user_data(ffont_face, key);
end;

function TCairoFont.font_face_set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;
begin
   result := cairo_font_face_set_user_data(ffont_face, key, user_data, Destroy);
end;

function TCairoFont.glyph_allocate(num_glyphs: Integer): Pcairo_glyph_t;
begin
   result := cairo_glyph_allocate(num_glyphs);
end;

procedure TCairoFont.glyph_free(glyphs: Pcairo_glyph_t);
begin
   cairo_glyph_free(glyphs);
end;

function TCairoFont.text_cluster_allocate(num_clusters: Integer): Pcairo_text_cluster_t;
begin
   result := cairo_text_cluster_allocate(num_clusters);
end;

procedure TCairoFont.text_cluster_free(clusters: Pcairo_text_cluster_t);
begin
   cairo_text_cluster_free(clusters);
end;

destructor TCairoFont.Destroy;
begin
   font_face_destroy;
   inherited;
end;

constructor TCairoFont.create(font_face: Pcairo_font_face_t);
begin
   inherited create;
   ffont_face := font_face;
end;

procedure TCairoFont.setToCairo(Cairo: Pcairo_t);
begin
   cairo_set_font_face(Cairo, ffont_face);
   cairo_set_font_options(Cairo, fFontOptions);
end;

{ TCairoScaledFont }

constructor TCairoScaledFont.create(font_face: Pcairo_font_face_t; Fontheight: Double);
var
 fFontMatrix: cairo_matrix_t;
 fCtm: cairo_matrix_t;

begin
   inherited create;
   cairo_matrix_init_identity(@fCtm);
   cairo_matrix_init_scale(@fFontMatrix, Fontheight, Fontheight);

   cairo_font_options_set_hint_metrics(fFontOptions, CAIRO_HINT_METRICS_DEFAULT);
   cairo_font_options_set_hint_style(fFontOptions, CAIRO_HINT_STYLE_DEFAULT);
   cairo_font_options_set_antialias(fFontOptions, CAIRO_ANTIALIAS_DEFAULT);


   fscaled_font := cairo_scaled_font_create(font_face, @fFontMatrix, @fCtm, fFontOptions);
end;

function TCairoScaledFont.reference: Pcairo_scaled_font_t;
begin
   result := cairo_scaled_font_reference(fscaled_font);
end;

destructor TCairoScaledFont.Destroy;
begin
   cairo_scaled_font_destroy(fscaled_font);
   inherited;
end;

function TCairoScaledFont.get_reference_count: Cardinal;
begin
   result := cairo_scaled_font_get_reference_count(fscaled_font);
end;

function TCairoScaledFont.status: cairo_status_t;
begin
   result := cairo_scaled_font_status(fscaled_font);
end;

function TCairoScaledFont.get_type: cairo_font_type_t;
begin
   result := cairo_scaled_font_get_type(fscaled_font);
end;

function TCairoScaledFont.get_user_data(key: Pcairo_user_data_key_t): Pointer;
begin
   result := cairo_scaled_font_get_user_data(fscaled_font, key);
end;

function TCairoScaledFont.set_user_data(key: Pcairo_user_data_key_t; user_data: Pointer; Destroy: cairo_destroy_func_t): cairo_status_t;
begin
   result := cairo_scaled_font_set_user_data(fscaled_font, key, user_data, Destroy);
end;

function TCairoScaledFont.extents: cairo_font_extents_t;
begin
   cairo_scaled_font_extents(fscaled_font, @result);
end;

procedure TCairoScaledFont.glyph_extents(glyphs: Pcairo_glyph_t; num_glyphs: Integer; extents: Pcairo_text_extents_t);
begin
   cairo_scaled_font_glyph_extents(fscaled_font, glyphs, num_glyphs, extents);
end;

function TCairoScaledFont.text_to_glyphs(x, y: Double; utf8: PUTF8Char; utf8_len: Integer; glyphs: PPcairo_glyph_t; num_glyphs: PInteger;
 clusters: PPcairo_text_cluster_t; num_clusters: PInteger; cluster_flags: Pcairo_text_cluster_flags_t): cairo_status_t;
begin
   result := cairo_scaled_font_text_to_glyphs(fscaled_font, x, y, utf8, utf8_len, glyphs, num_glyphs, clusters, num_clusters, cluster_flags);
end;

function TCairoScaledFont.get_font_face: Pcairo_font_face_t;
begin
   result := cairo_scaled_font_get_font_face(fscaled_font);
end;

procedure TCairoScaledFont.get_font_matrix(font_matrix: Pcairo_matrix_t);
begin
   cairo_scaled_font_get_font_matrix(fscaled_font, font_matrix);
end;

procedure TCairoScaledFont.get_ctm(ctm: Pcairo_matrix_t);
begin
   cairo_scaled_font_get_ctm(fscaled_font, ctm);
end;

procedure TCairoScaledFont.get_scale_matrix(scale_matrix: Pcairo_matrix_t);
begin
   cairo_scaled_font_get_scale_matrix(fscaled_font, scale_matrix);
end;

procedure TCairoScaledFont.get_font_options(options: Pcairo_font_options_t);
begin
   cairo_scaled_font_get_font_options(fscaled_font, options);
end;

procedure TCairoScaledFont.setToCairo(Cairo: Pcairo_t);
begin
   cairo_set_scaled_font(Cairo, fscaled_font);
   cairo_set_font_options(Cairo, fFontOptions);
end;


function TCairoScaledFont.text_extents(const Value: String): cairo_text_extents_t;
begin
  cairo_scaled_font_text_extents(fscaled_font, Pansichar(Utf8String(Value)), @result);
end;

{ TCairoWinFont }

constructor TScaledWinFont.create_for_hfont(Font: HFONT; Fontheight: Double);
var
   temp: Pcairo_font_face_t;
begin
   temp := cairo_win32_font_face_create_for_hfont(Font);
   inherited create(temp, Fontheight);
   if cairo_font_face_get_reference_count(temp) > 1 then
      cairo_font_face_destroy(temp);
end;

function TScaledWinFont.font_face_create_for_logfontw(logfont: PLOGFONTW): Pcairo_font_face_t;
begin
   result := cairo_win32_font_face_create_for_logfontw(logfont);
end;

function TScaledWinFont.font_face_create_for_logfontw_hfont(logfont: PLOGFONTW; Font: HFONT): Pcairo_font_face_t;
begin
   result := cairo_win32_font_face_create_for_logfontw_hfont(logfont, Font);
end;

function TScaledWinFont.scaled_font_select_font(scaled_font: Pcairo_scaled_font_t; hdc: hdc): cairo_status_t;
begin
   result := cairo_win32_scaled_font_select_font(scaled_font, hdc);
end;

procedure TScaledWinFont.scaled_font_done_font(scaled_font: Pcairo_scaled_font_t);
begin
   cairo_win32_scaled_font_done_font(scaled_font);
end;

function TScaledWinFont.scaled_font_get_metrics_factor(scaled_font: Pcairo_scaled_font_t): Double;
begin
   result := cairo_win32_scaled_font_get_metrics_factor(scaled_font);
end;

procedure TScaledWinFont.scaled_font_get_logical_to_device(scaled_font: Pcairo_scaled_font_t; logical_to_device: Pcairo_matrix_t);
begin
   cairo_win32_scaled_font_get_logical_to_device(scaled_font, logical_to_device);
end;

procedure TScaledWinFont.scaled_font_get_device_to_logical(scaled_font: Pcairo_scaled_font_t; device_to_logical: Pcairo_matrix_t);
begin
   cairo_win32_scaled_font_get_device_to_logical(scaled_font, device_to_logical);
end;

destructor TScaledWinFont.Destroy;
begin
   inherited;
end;

function TCairoFontBase.font_options_copy(original: Pcairo_font_options_t): Pcairo_font_options_t;
begin
   result := cairo_font_options_copy(original);
end;

{ TCairoFontBase }

function TCairoFontBase.font_options_create: Pcairo_font_options_t;
begin
   result := cairo_font_options_create;
end;

procedure TCairoFontBase.font_options_destroy;
begin
   cairo_font_options_destroy(fFontOptions);
end;

function TCairoFontBase.font_options_equal(other: Pcairo_font_options_t): cairo_bool_t;
begin
   result := cairo_font_options_equal(fFontOptions, other);
end;

function TCairoFontBase.font_options_get_antialias: cairo_antialias_t;
begin
   result := cairo_font_options_get_antialias(fFontOptions);
end;

function TCairoFontBase.font_options_get_hint_metrics: cairo_hint_metrics_t;
begin
   result := cairo_font_options_get_hint_metrics(fFontOptions);
end;

function TCairoFontBase.font_options_get_hint_style: cairo_hint_style_t;
begin
   result := cairo_font_options_get_hint_style(fFontOptions);
end;

function TCairoFontBase.font_options_get_subpixel_order: cairo_subpixel_order_t;
begin
   result := cairo_font_options_get_subpixel_order(fFontOptions);
end;

function TCairoFontBase.font_options_hash: Cardinal;
begin
   result := cairo_font_options_hash(fFontOptions);
end;

procedure TCairoFontBase.font_options_merge(other: Pcairo_font_options_t);
begin
   cairo_font_options_merge(fFontOptions, other);
end;

procedure TCairoFontBase.font_options_set_antialias(antialias: cairo_antialias_t);
begin
   cairo_font_options_set_antialias(fFontOptions, antialias);
end;

procedure TCairoFontBase.font_options_set_hint_metrics(hint_metrics: cairo_hint_metrics_t);
begin
   cairo_font_options_set_hint_metrics(fFontOptions, hint_metrics);
end;

procedure TCairoFontBase.font_options_set_hint_style(hint_style: cairo_hint_style_t);
begin
   cairo_font_options_set_hint_style(fFontOptions, hint_style);
end;

procedure TCairoFontBase.font_options_set_subpixel_order(subpixel_order: cairo_subpixel_order_t);
begin
   cairo_font_options_set_subpixel_order(fFontOptions, subpixel_order);
end;

function TCairoFontBase.font_options_status: cairo_status_t;
begin
   result := cairo_font_face_status(fFontOptions);
end;

constructor TCairoFontBase.create;
begin
   inherited;
   fFontOptions := font_options_create;
   font_options_set_antialias(CAIRO_ANTIALIAS_DEFAULT);
   font_options_set_hint_metrics(CAIRO_HINT_METRICS_ON);
end;

destructor TCairoFontBase.Destroy;
begin
   font_options_destroy;
   inherited;
end;

{ TWinFont }

constructor TWinFont.create_for_hfont(Font: HFONT);
var
   temp: Pcairo_font_face_t;
begin
   temp := cairo_win32_font_face_create_for_hfont(Font);
   inherited create(temp);
end;

destructor TWinFont.Destroy;
begin
  inherited;
end;

constructor TScaledWinFont.create_for_logfont(const Font: LOGFONT; Fontheight:
    Double);
var
   temp: Pcairo_font_face_t;
begin
   temp := cairo_win32_font_face_create_for_logfontw(@Font);
   if Fontheight <1 then
   Fontheight := 400;
   inherited create(temp, Fontheight);
   if cairo_font_face_get_reference_count(temp) > 1 then
      cairo_font_face_destroy(temp);
end;

function TScaledWinFont.handle: Pcairo_scaled_font_t;
begin
  result := fscaled_font;
end;

end.
