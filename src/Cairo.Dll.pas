unit Cairo.Dll;

{$MINENUMSIZE 4}

interface

uses
   Winapi.Windows,
   Cairo.Types,
   Cairo.FreeType;

const
   {$IFDEF DEBUGCAIRO}
   LIB_CAIRO_32 = 'CairoD.dll';
   {$ELSE}
   LIB_CAIRO_32 = 'Cairo.dll';
   {$ENDIF}
   _PU = '';
function cairo_version(): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_version';

function cairo_version_string(): PUTF8Char; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_version_string';

function cairo_create(target: Pcairo_surface_t): Pcairo_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_create';

function cairo_reference(cr: Pcairo_t): Pcairo_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_reference';

procedure cairo_destroy(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_destroy';

function cairo_get_reference_count(cr: Pcairo_t): Cardinal; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_reference_count';

function cairo_get_user_data(cr: Pcairo_t; key: Pcairo_user_data_key_t): Pointer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_user_data';

function cairo_set_user_data(cr: Pcairo_t; key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_set_user_data';

procedure cairo_save(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_save';

procedure cairo_restore(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_restore';

procedure cairo_push_group(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_push_group';

procedure cairo_push_group_with_content(cr: Pcairo_t; content: cairo_content_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_push_group_with_content';

function cairo_pop_group(cr: Pcairo_t): Pcairo_pattern_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pop_group';

procedure cairo_pop_group_to_source(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pop_group_to_source';

procedure cairo_set_operator(cr: Pcairo_t; op: cairo_operator_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_operator';

procedure cairo_set_source(cr: Pcairo_t; source: Pcairo_pattern_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_source';

procedure cairo_set_source_rgb(cr: Pcairo_t; red: Double; green: Double; blue: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_source_rgb';

procedure cairo_set_source_rgba(cr: Pcairo_t; red: Double; green: Double; blue: Double; alpha: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_set_source_rgba';

procedure cairo_set_source_surface(cr: Pcairo_t; surface: Pcairo_surface_t; x: Double; y: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_set_source_surface';

procedure cairo_set_tolerance(cr: Pcairo_t; tolerance: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_tolerance';

procedure cairo_set_antialias(cr: Pcairo_t; antialias: cairo_antialias_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_antialias';

procedure cairo_set_fill_rule(cr: Pcairo_t; fill_rule: cairo_fill_rule_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_fill_rule';

procedure cairo_set_line_width(cr: Pcairo_t; width: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_line_width';

procedure cairo_set_line_cap(cr: Pcairo_t; line_cap: cairo_line_cap_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_line_cap';

procedure cairo_set_line_join(cr: Pcairo_t; line_join: cairo_line_join_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_line_join';

procedure cairo_set_dash(cr: Pcairo_t; dashes: PDouble; num_dashes: Integer; offset: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_dash';

procedure cairo_set_miter_limit(cr: Pcairo_t; limit: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_miter_limit';

procedure cairo_translate(cr: Pcairo_t; tx: Double; ty: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_translate';

procedure cairo_scale(cr: Pcairo_t; sx: Double; sy: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scale';

procedure cairo_rotate(cr: Pcairo_t; angle: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_rotate';

procedure cairo_transform(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_transform';

procedure cairo_set_matrix(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_matrix';

procedure cairo_identity_matrix(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_identity_matrix';

procedure cairo_user_to_device(cr: Pcairo_t; x: PDouble; y: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_user_to_device';

procedure cairo_user_to_device_distance(cr: Pcairo_t; dx: PDouble; dy: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_user_to_device_distance';

procedure cairo_device_to_user(cr: Pcairo_t; x: PDouble; y: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_to_user';

procedure cairo_device_to_user_distance(cr: Pcairo_t; dx: PDouble; dy: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_to_user_distance';

procedure cairo_new_path(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_new_path';

procedure cairo_move_to(cr: Pcairo_t; x: Double; y: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_move_to';

procedure cairo_new_sub_path(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_new_sub_path';

procedure cairo_line_to(cr: Pcairo_t; x: Double; y: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_line_to';

procedure cairo_curve_to(cr: Pcairo_t; x1: Double; y1: Double; x2: Double; y2: Double; x3: Double; y3: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_curve_to';

procedure cairo_arc(cr: Pcairo_t; xc: Double; yc: Double; radius: Double; angle1: Double; angle2: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_arc';

procedure cairo_arc_negative(cr: Pcairo_t; xc: Double; yc: Double; radius: Double; angle1: Double; angle2: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_arc_negative';

procedure cairo_rel_move_to(cr: Pcairo_t; dx: Double; dy: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_rel_move_to';

procedure cairo_rel_line_to(cr: Pcairo_t; dx: Double; dy: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_rel_line_to';

procedure cairo_rel_curve_to(cr: Pcairo_t; dx1: Double; dy1: Double; dx2: Double; dy2: Double; dx3: Double; dy3: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_rel_curve_to';

procedure cairo_rectangle(cr: Pcairo_t; x: Double; y: Double; width: Double; height: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_rectangle';

procedure cairo_close_path(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_close_path';

procedure cairo_path_extents(cr: Pcairo_t; x1: PDouble; y1: PDouble; x2: PDouble; y2: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_path_extents';

procedure cairo_paint(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_paint';

procedure cairo_paint_with_alpha(cr: Pcairo_t; alpha: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_paint_with_alpha';

procedure cairo_mask(cr: Pcairo_t; pattern: Pcairo_pattern_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mask';

procedure cairo_mask_surface(cr: Pcairo_t; surface: Pcairo_surface_t; surface_x: Double; surface_y: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_mask_surface';

procedure cairo_stroke(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_stroke';

procedure cairo_stroke_preserve(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_stroke_preserve';

procedure cairo_fill(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_fill';

procedure cairo_fill_preserve(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_fill_preserve';

procedure cairo_copy_page(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_copy_page';

procedure cairo_show_page(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_show_page';

function cairo_in_stroke(cr: Pcairo_t; x: Double; y: Double): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_in_stroke';

function cairo_in_fill(cr: Pcairo_t; x: Double; y: Double): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_in_fill';

function cairo_in_clip(cr: Pcairo_t; x: Double; y: Double): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_in_clip';

procedure cairo_stroke_extents(cr: Pcairo_t; x1: PDouble; y1: PDouble; x2: PDouble; y2: PDouble); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_stroke_extents';

procedure cairo_fill_extents(cr: Pcairo_t; x1: PDouble; y1: PDouble; x2: PDouble; y2: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_fill_extents';

procedure cairo_reset_clip(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_reset_clip';

procedure cairo_clip(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_clip';

procedure cairo_clip_preserve(cr: Pcairo_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_clip_preserve';

procedure cairo_clip_extents(cr: Pcairo_t; x1: PDouble; y1: PDouble; x2: PDouble; y2: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_clip_extents';

function cairo_copy_clip_rectangle_list(cr: Pcairo_t): Pcairo_rectangle_list_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_copy_clip_rectangle_list';

procedure cairo_rectangle_list_destroy(rectangle_list: Pcairo_rectangle_list_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_rectangle_list_destroy';

procedure cairo_tag_begin(cr: Pcairo_t; tag_name: PUTF8Char; attributes: PUTF8Char); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_tag_begin';

procedure cairo_tag_end(cr: Pcairo_t; tag_name: PUTF8Char); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_tag_end';

function cairo_glyph_allocate(num_glyphs: Integer): Pcairo_glyph_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_glyph_allocate';

procedure cairo_glyph_free(glyphs: Pcairo_glyph_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_glyph_free';

function cairo_text_cluster_allocate(num_clusters: Integer): Pcairo_text_cluster_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_text_cluster_allocate';

procedure cairo_text_cluster_free(clusters: Pcairo_text_cluster_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_text_cluster_free';

function cairo_font_options_create(): Pcairo_font_options_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_options_create';

function cairo_font_options_copy(original: Pcairo_font_options_t): Pcairo_font_options_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_options_copy';

procedure cairo_font_options_destroy(options: Pcairo_font_options_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_options_destroy';

function cairo_font_options_status(options: Pcairo_font_options_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_options_status';

procedure cairo_font_options_merge(options: Pcairo_font_options_t; other: Pcairo_font_options_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_merge';

function cairo_font_options_equal(options: Pcairo_font_options_t; other: Pcairo_font_options_t): cairo_bool_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_equal';

function cairo_font_options_hash(options: Pcairo_font_options_t): Cardinal; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_options_hash';

procedure cairo_font_options_set_antialias(options: Pcairo_font_options_t; antialias: cairo_antialias_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_set_antialias';

function cairo_font_options_get_antialias(options: Pcairo_font_options_t): cairo_antialias_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_get_antialias';

procedure cairo_font_options_set_subpixel_order(options: Pcairo_font_options_t; subpixel_order: cairo_subpixel_order_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_set_subpixel_order';

function cairo_font_options_get_subpixel_order(options: Pcairo_font_options_t): cairo_subpixel_order_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_get_subpixel_order';

procedure cairo_font_options_set_hint_style(options: Pcairo_font_options_t; hint_style: cairo_hint_style_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_set_hint_style';

function cairo_font_options_get_hint_style(options: Pcairo_font_options_t): cairo_hint_style_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_get_hint_style';

procedure cairo_font_options_set_hint_metrics(options: Pcairo_font_options_t; hint_metrics: cairo_hint_metrics_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_set_hint_metrics';

function cairo_font_options_get_hint_metrics(options: Pcairo_font_options_t): cairo_hint_metrics_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_options_get_hint_metrics';

procedure cairo_select_font_face(cr: Pcairo_t; family: PUTF8Char; slant: cairo_font_slant_t; weight: cairo_font_weight_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_select_font_face';

procedure cairo_set_font_size(cr: Pcairo_t; size: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_font_size';

procedure cairo_set_font_matrix(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_font_matrix';

procedure cairo_get_font_matrix(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_font_matrix';

procedure cairo_set_font_options(cr: Pcairo_t; options: Pcairo_font_options_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_font_options';

procedure cairo_get_font_options(cr: Pcairo_t; options: Pcairo_font_options_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_font_options';

procedure cairo_set_font_face(cr: Pcairo_t; font_face: Pcairo_font_face_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_font_face';

function cairo_get_font_face(cr: Pcairo_t): Pcairo_font_face_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_font_face';

procedure cairo_set_scaled_font(cr: Pcairo_t; scaled_font: Pcairo_scaled_font_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_set_scaled_font';

function cairo_get_scaled_font(cr: Pcairo_t): Pcairo_scaled_font_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_scaled_font';

procedure cairo_show_text(cr: Pcairo_t; utf8: PUTF8Char); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_show_text';

procedure cairo_show_glyphs(cr: Pcairo_t; glyphs: Pcairo_glyph_t; num_glyphs: Integer); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_show_glyphs';

procedure cairo_show_text_glyphs(cr: Pcairo_t; utf8: PUTF8Char; utf8_len: Integer; glyphs: Pcairo_glyph_t; num_glyphs: Integer; clusters: Pcairo_text_cluster_t;
 num_clusters: Integer; cluster_flags: cairo_text_cluster_flags_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_show_text_glyphs';

procedure cairo_text_path(cr: Pcairo_t; utf8: PUTF8Char); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_text_path';

procedure cairo_glyph_path(cr: Pcairo_t; glyphs: Pcairo_glyph_t; num_glyphs: Integer); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_glyph_path';

procedure cairo_text_extents(cr: Pcairo_t; utf8: PUTF8Char; var extents: cairo_text_extents_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_text_extents';

procedure cairo_glyph_extents(cr: Pcairo_t; glyphs: Pcairo_glyph_t; num_glyphs: Integer; extents: Pcairo_text_extents_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_glyph_extents';

procedure cairo_font_extents(cr: Pcairo_t; extents: Pcairo_font_extents_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_extents';

function cairo_font_face_reference(font_face: Pcairo_font_face_t): Pcairo_font_face_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_face_reference';

procedure cairo_font_face_destroy(font_face: Pcairo_font_face_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_face_destroy';

function cairo_font_face_get_reference_count(font_face: Pcairo_font_face_t): Cardinal; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_face_get_reference_count';

function cairo_font_face_status(font_face: Pcairo_font_face_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_face_status';

function cairo_font_face_get_type(font_face: Pcairo_font_face_t): cairo_font_type_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_face_get_type';

function cairo_font_face_get_user_data(font_face: Pcairo_font_face_t; key: Pcairo_user_data_key_t): Pointer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_font_face_get_user_data';

function cairo_font_face_set_user_data(font_face: Pcairo_font_face_t; key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t)
 : cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_font_face_set_user_data';

function cairo_scaled_font_create(font_face: Pcairo_font_face_t; font_matrix: Pcairo_matrix_t; ctm: Pcairo_matrix_t; options: Pcairo_font_options_t)
 : Pcairo_scaled_font_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_create';

function cairo_scaled_font_reference(scaled_font: Pcairo_scaled_font_t): Pcairo_scaled_font_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_reference';

procedure cairo_scaled_font_destroy(scaled_font: Pcairo_scaled_font_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_destroy';

function cairo_scaled_font_get_reference_count(scaled_font: Pcairo_scaled_font_t): Cardinal; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_reference_count';

function cairo_scaled_font_status(scaled_font: Pcairo_scaled_font_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_status';

function cairo_scaled_font_get_type(scaled_font: Pcairo_scaled_font_t): cairo_font_type_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_type';

function cairo_scaled_font_get_user_data(scaled_font: Pcairo_scaled_font_t; key: Pcairo_user_data_key_t): Pointer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_user_data';

function cairo_scaled_font_set_user_data(scaled_font: Pcairo_scaled_font_t; key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t)
 : cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_set_user_data';

procedure cairo_scaled_font_extents(scaled_font: Pcairo_scaled_font_t; extents: Pcairo_font_extents_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_extents';

procedure cairo_scaled_font_text_extents(scaled_font: Pcairo_scaled_font_t; utf8: PUTF8Char; extents: Pcairo_text_extents_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_text_extents';

procedure cairo_scaled_font_glyph_extents(scaled_font: Pcairo_scaled_font_t; glyphs: Pcairo_glyph_t; num_glyphs: Integer; extents: Pcairo_text_extents_t);
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_glyph_extents';

function cairo_scaled_font_text_to_glyphs(scaled_font: Pcairo_scaled_font_t; x: Double; y: Double; utf8: PUTF8Char; utf8_len: Integer; glyphs: PPcairo_glyph_t;
 num_glyphs: PInteger; clusters: PPcairo_text_cluster_t; num_clusters: PInteger; cluster_flags: Pcairo_text_cluster_flags_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_text_to_glyphs';

function cairo_scaled_font_get_font_face(scaled_font: Pcairo_scaled_font_t): Pcairo_font_face_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_font_face';

procedure cairo_scaled_font_get_font_matrix(scaled_font: Pcairo_scaled_font_t; font_matrix: Pcairo_matrix_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_font_matrix';

procedure cairo_scaled_font_get_ctm(scaled_font: Pcairo_scaled_font_t; ctm: Pcairo_matrix_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_ctm';

procedure cairo_scaled_font_get_scale_matrix(scaled_font: Pcairo_scaled_font_t; scale_matrix: Pcairo_matrix_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_scale_matrix';

procedure cairo_scaled_font_get_font_options(scaled_font: Pcairo_scaled_font_t; options: Pcairo_font_options_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_scaled_font_get_font_options';

function cairo_toy_font_face_create(family: PUTF8Char; slant: cairo_font_slant_t; weight: cairo_font_weight_t): Pcairo_font_face_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_toy_font_face_create';

function cairo_toy_font_face_get_family(font_face: Pcairo_font_face_t): PUTF8Char; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_toy_font_face_get_family';

function cairo_toy_font_face_get_slant(font_face: Pcairo_font_face_t): cairo_font_slant_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_toy_font_face_get_slant';

function cairo_toy_font_face_get_weight(font_face: Pcairo_font_face_t): cairo_font_weight_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_toy_font_face_get_weight';

function cairo_user_font_face_create(): Pcairo_font_face_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_create';

procedure cairo_user_font_face_set_init_func(font_face: Pcairo_font_face_t; init_func: cairo_user_scaled_font_init_func_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_set_init_func';

procedure cairo_user_font_face_set_render_glyph_func(font_face: Pcairo_font_face_t; render_glyph_func: cairo_user_scaled_font_render_glyph_func_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_set_render_glyph_func';

procedure cairo_user_font_face_set_text_to_glyphs_func(font_face: Pcairo_font_face_t; text_to_glyphs_func: cairo_user_scaled_font_text_to_glyphs_func_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_set_text_to_glyphs_func';

procedure cairo_user_font_face_set_unicode_to_glyph_func(font_face: Pcairo_font_face_t; unicode_to_glyph_func: cairo_user_scaled_font_unicode_to_glyph_func_t);
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_set_unicode_to_glyph_func';

function cairo_user_font_face_get_init_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_init_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_get_init_func';

function cairo_user_font_face_get_render_glyph_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_render_glyph_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_get_render_glyph_func';

function cairo_user_font_face_get_text_to_glyphs_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_text_to_glyphs_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_get_text_to_glyphs_func';

function cairo_user_font_face_get_unicode_to_glyph_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_unicode_to_glyph_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_user_font_face_get_unicode_to_glyph_func';

function cairo_get_operator(cr: Pcairo_t): cairo_operator_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_operator';

function cairo_get_source(cr: Pcairo_t): Pcairo_pattern_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_source';

function cairo_get_tolerance(cr: Pcairo_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_tolerance';

function cairo_get_antialias(cr: Pcairo_t): cairo_antialias_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_antialias';

function cairo_has_current_point(cr: Pcairo_t): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_has_current_point';

procedure cairo_get_current_point(cr: Pcairo_t; x: PDouble; y: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_current_point';

function cairo_get_fill_rule(cr: Pcairo_t): cairo_fill_rule_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_fill_rule';

function cairo_get_line_width(cr: Pcairo_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_line_width';

function cairo_get_line_cap(cr: Pcairo_t): cairo_line_cap_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_line_cap';

function cairo_get_line_join(cr: Pcairo_t): cairo_line_join_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_line_join';

function cairo_get_miter_limit(cr: Pcairo_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_miter_limit';

function cairo_get_dash_count(cr: Pcairo_t): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_dash_count';

procedure cairo_get_dash(cr: Pcairo_t; dashes: PDouble; offset: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_dash';

procedure cairo_get_matrix(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_matrix';

function cairo_get_target(cr: Pcairo_t): Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_target';

function cairo_get_group_target(cr: Pcairo_t): Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_get_group_target';

function cairo_copy_path(cr: Pcairo_t): Pcairo_path_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_copy_path';

function cairo_copy_path_flat(cr: Pcairo_t): Pcairo_path_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_copy_path_flat';

procedure cairo_append_path(cr: Pcairo_t; path: Pcairo_path_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_append_path';

procedure cairo_path_destroy(path: Pcairo_path_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_path_destroy';

function cairo_status(cr: Pcairo_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_status';

function cairo_status_to_string(status: cairo_status_t): PUTF8Char; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_status_to_string';

function cairo_device_reference(device: Pcairo_device_t): Pcairo_device_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_reference';

function cairo_device_get_type(device: Pcairo_device_t): cairo_device_type_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_get_type';

function cairo_device_status(device: Pcairo_device_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_status';

function cairo_device_acquire(device: Pcairo_device_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_acquire';

procedure cairo_device_release(device: Pcairo_device_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_release';

procedure cairo_device_flush(device: Pcairo_device_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_flush';

procedure cairo_device_finish(device: Pcairo_device_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_finish';

procedure cairo_device_destroy(device: Pcairo_device_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_destroy';

function cairo_device_get_reference_count(device: Pcairo_device_t): Cardinal; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_get_reference_count';

function cairo_device_get_user_data(device: Pcairo_device_t; key: Pcairo_user_data_key_t): Pointer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_device_get_user_data';

function cairo_device_set_user_data(device: Pcairo_device_t; key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_set_user_data';

function cairo_surface_create_similar(other: Pcairo_surface_t; content: cairo_content_t; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_create_similar';

function cairo_surface_create_similar_image(other: Pcairo_surface_t; format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_create_similar_image';

function cairo_surface_map_to_image(surface: Pcairo_surface_t; extents: Pcairo_rectangle_int_t): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_map_to_image';

procedure cairo_surface_unmap_image(surface: Pcairo_surface_t; image: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_unmap_image';

function cairo_surface_create_for_rectangle(target: Pcairo_surface_t; x: Double; y: Double; width: Double; height: Double): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_create_for_rectangle';

function cairo_surface_create_observer(target: Pcairo_surface_t; mode: cairo_surface_observer_mode_t): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_create_observer';

function cairo_surface_observer_add_paint_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_paint_callback';

function cairo_surface_observer_add_mask_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_mask_callback';

function cairo_surface_observer_add_fill_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_fill_callback';

function cairo_surface_observer_add_stroke_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_stroke_callback';

function cairo_surface_observer_add_glyphs_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_glyphs_callback';

function cairo_surface_observer_add_flush_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_flush_callback';

function cairo_surface_observer_add_finish_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_add_finish_callback';

function cairo_surface_observer_print(surface: Pcairo_surface_t; write_func: cairo_write_func_t; closure: Pointer): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_print';

function cairo_surface_observer_elapsed(surface: Pcairo_surface_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_observer_elapsed';

function cairo_device_observer_print(device: Pcairo_device_t; write_func: cairo_write_func_t; closure: Pointer): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_device_observer_print';

function cairo_device_observer_elapsed(device: Pcairo_device_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_observer_elapsed';

function cairo_device_observer_paint_elapsed(device: Pcairo_device_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_observer_paint_elapsed';

function cairo_device_observer_mask_elapsed(device: Pcairo_device_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_observer_mask_elapsed';

function cairo_device_observer_fill_elapsed(device: Pcairo_device_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_observer_fill_elapsed';

function cairo_device_observer_stroke_elapsed(device: Pcairo_device_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_observer_stroke_elapsed';

function cairo_device_observer_glyphs_elapsed(device: Pcairo_device_t): Double; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_device_observer_glyphs_elapsed';

function cairo_surface_reference(surface: Pcairo_surface_t): Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_reference';

procedure cairo_surface_finish(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_finish';

procedure cairo_surface_destroy(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_destroy';

function cairo_surface_get_device(surface: Pcairo_surface_t): Pcairo_device_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_get_device';

function cairo_surface_get_reference_count(surface: Pcairo_surface_t): Cardinal; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_get_reference_count';

function cairo_surface_status(surface: Pcairo_surface_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_status';

function cairo_surface_get_type(surface: Pcairo_surface_t): cairo_surface_type_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_get_type';

function cairo_surface_get_content(surface: Pcairo_surface_t): cairo_content_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_get_content';

function cairo_surface_write_to_png(surface: Pcairo_surface_t; filename: PUTF8Char): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_write_to_png';

function cairo_surface_write_to_png_stream(surface: Pcairo_surface_t; write_func: cairo_write_func_t; closure: Pointer): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_write_to_png_stream';

function cairo_surface_get_user_data(surface: Pcairo_surface_t; key: Pcairo_user_data_key_t): Pointer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_get_user_data';

function cairo_surface_set_user_data(surface: Pcairo_surface_t; key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_set_user_data';

procedure cairo_surface_get_mime_data(surface: Pcairo_surface_t; mime_type: PUTF8Char; data: PPByte; length: PCardinal); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_get_mime_data';

function cairo_surface_set_mime_data(surface: Pcairo_surface_t; mime_type: PUTF8Char; data: PByte; length: Cardinal; destroy: cairo_destroy_func_t;
 closure: Pointer): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_set_mime_data';

function cairo_surface_supports_mime_type(surface: Pcairo_surface_t; mime_type: PUTF8Char): cairo_bool_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_supports_mime_type';

procedure cairo_surface_get_font_options(surface: Pcairo_surface_t; options: Pcairo_font_options_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_get_font_options';

procedure cairo_surface_flush(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_flush';

procedure cairo_surface_mark_dirty(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_mark_dirty';

procedure cairo_surface_mark_dirty_rectangle(surface: Pcairo_surface_t; x: Integer; y: Integer; width: Integer; height: Integer); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_mark_dirty_rectangle';

procedure cairo_surface_set_device_scale(surface: Pcairo_surface_t; x_scale: Double; y_scale: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_set_device_scale';

procedure cairo_surface_get_device_scale(surface: Pcairo_surface_t; x_scale: PDouble; y_scale: PDouble); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_get_device_scale';

procedure cairo_surface_set_device_offset(surface: Pcairo_surface_t; x_offset: Double; y_offset: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_set_device_offset';

procedure cairo_surface_get_device_offset(surface: Pcairo_surface_t; x_offset: PDouble; y_offset: PDouble); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_get_device_offset';

procedure cairo_surface_set_fallback_resolution(surface: Pcairo_surface_t; x_pixels_per_inch: Double; y_pixels_per_inch: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_set_fallback_resolution';

procedure cairo_surface_get_fallback_resolution(surface: Pcairo_surface_t; x_pixels_per_inch: PDouble; y_pixels_per_inch: PDouble); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_get_fallback_resolution';

procedure cairo_surface_copy_page(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_copy_page';

procedure cairo_surface_show_page(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_surface_show_page';

function cairo_surface_has_show_text_glyphs(surface: Pcairo_surface_t): cairo_bool_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_surface_has_show_text_glyphs';

function cairo_image_surface_create(format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_image_surface_create';

function cairo_format_stride_for_width(format: cairo_format_t; width: Integer): Integer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_format_stride_for_width';

function cairo_image_surface_create_for_data(data: PByte; format: cairo_format_t; width: Integer; height: Integer; stride: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_image_surface_create_for_data';

function cairo_image_surface_get_data(surface: Pcairo_surface_t): PByte; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_image_surface_get_data';

function cairo_image_surface_get_format(surface: Pcairo_surface_t): cairo_format_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_image_surface_get_format';

function cairo_image_surface_get_width(surface: Pcairo_surface_t): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_image_surface_get_width';

function cairo_image_surface_get_height(surface: Pcairo_surface_t): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_image_surface_get_height';

function cairo_image_surface_get_stride(surface: Pcairo_surface_t): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_image_surface_get_stride';

function cairo_image_surface_create_from_png(filename: PUTF8Char): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_image_surface_create_from_png';

function cairo_image_surface_create_from_png_stream(read_func: cairo_read_func_t; closure: Pointer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_image_surface_create_from_png_stream';

function cairo_recording_surface_create(content: cairo_content_t; extents: Pcairo_rectangle_t): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_recording_surface_create';

procedure cairo_recording_surface_ink_extents(surface: Pcairo_surface_t; x0: PDouble; y0: PDouble; width: PDouble; height: PDouble); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_recording_surface_ink_extents';

function cairo_recording_surface_get_extents(surface: Pcairo_surface_t; extents: Pcairo_rectangle_t): cairo_bool_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_recording_surface_get_extents';

function cairo_pattern_create_raster_source(user_data: Pointer; content: cairo_content_t; width: Integer; height: Integer): Pcairo_pattern_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_raster_source';

procedure cairo_raster_source_pattern_set_callback_data(pattern: Pcairo_pattern_t; data: Pointer); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_set_callback_data';

function cairo_raster_source_pattern_get_callback_data(pattern: Pcairo_pattern_t): Pointer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_get_callback_data';

procedure cairo_raster_source_pattern_set_acquire(pattern: Pcairo_pattern_t; acquire: cairo_raster_source_acquire_func_t;
 release: cairo_raster_source_release_func_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_set_acquire';

procedure cairo_raster_source_pattern_get_acquire(pattern: Pcairo_pattern_t; acquire: Pcairo_raster_source_acquire_func_t;
 release: Pcairo_raster_source_release_func_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_get_acquire';

procedure cairo_raster_source_pattern_set_snapshot(pattern: Pcairo_pattern_t; snapshot: cairo_raster_source_snapshot_func_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_set_snapshot';

function cairo_raster_source_pattern_get_snapshot(pattern: Pcairo_pattern_t): cairo_raster_source_snapshot_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_get_snapshot';

procedure cairo_raster_source_pattern_set_copy(pattern: Pcairo_pattern_t; copy: cairo_raster_source_copy_func_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_set_copy';

function cairo_raster_source_pattern_get_copy(pattern: Pcairo_pattern_t): cairo_raster_source_copy_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_get_copy';

procedure cairo_raster_source_pattern_set_finish(pattern: Pcairo_pattern_t; finish: cairo_raster_source_finish_func_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_set_finish';

function cairo_raster_source_pattern_get_finish(pattern: Pcairo_pattern_t): cairo_raster_source_finish_func_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_raster_source_pattern_get_finish';

function cairo_pattern_create_rgb(red: Double; green: Double; blue: Double): Pcairo_pattern_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_rgb';

function cairo_pattern_create_rgba(red: Double; green: Double; blue: Double; alpha: Double): Pcairo_pattern_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_rgba';

function cairo_pattern_create_for_surface(surface: Pcairo_surface_t): Pcairo_pattern_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_for_surface';

function cairo_pattern_create_linear(x0: Double; y0: Double; x1: Double; y1: Double): Pcairo_pattern_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_linear';

function cairo_pattern_create_radial(cx0: Double; cy0: Double; radius0: Double; cx1: Double; cy1: Double; radius1: Double): Pcairo_pattern_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_radial';

function cairo_pattern_create_mesh(): Pcairo_pattern_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_create_mesh';

function cairo_pattern_reference(pattern: Pcairo_pattern_t): Pcairo_pattern_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_reference';

procedure cairo_pattern_destroy(pattern: Pcairo_pattern_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_destroy';

function cairo_pattern_get_reference_count(pattern: Pcairo_pattern_t): Cardinal; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_reference_count';

function cairo_pattern_status(pattern: Pcairo_pattern_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_status';

function cairo_pattern_get_user_data(pattern: Pcairo_pattern_t; key: Pcairo_user_data_key_t): Pointer; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_user_data';

function cairo_pattern_set_user_data(pattern: Pcairo_pattern_t; key: Pcairo_user_data_key_t; user_data: Pointer; destroy: cairo_destroy_func_t): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_set_user_data';

function cairo_pattern_get_type(pattern: Pcairo_pattern_t): cairo_pattern_type_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_type';

procedure cairo_pattern_add_color_stop_rgb(pattern: Pcairo_pattern_t; offset: Double; red: Double; green: Double; blue: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_add_color_stop_rgb';

procedure cairo_pattern_add_color_stop_rgba(pattern: Pcairo_pattern_t; offset: Double; red: Double; green: Double; blue: Double; alpha: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_add_color_stop_rgba';

procedure cairo_mesh_pattern_begin_patch(pattern: Pcairo_pattern_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_begin_patch';

procedure cairo_mesh_pattern_end_patch(pattern: Pcairo_pattern_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_end_patch';

procedure cairo_mesh_pattern_curve_to(pattern: Pcairo_pattern_t; x1: Double; y1: Double; x2: Double; y2: Double; x3: Double; y3: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_curve_to';

procedure cairo_mesh_pattern_line_to(pattern: Pcairo_pattern_t; x: Double; y: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_line_to';

procedure cairo_mesh_pattern_move_to(pattern: Pcairo_pattern_t; x: Double; y: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_move_to';

procedure cairo_mesh_pattern_set_control_point(pattern: Pcairo_pattern_t; point_num: Cardinal; x: Double; y: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_set_control_point';

procedure cairo_mesh_pattern_set_corner_color_rgb(pattern: Pcairo_pattern_t; corner_num: Cardinal; red: Double; green: Double; blue: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_set_corner_color_rgb';

procedure cairo_mesh_pattern_set_corner_color_rgba(pattern: Pcairo_pattern_t; corner_num: Cardinal; red: Double; green: Double; blue: Double; alpha: Double);
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_set_corner_color_rgba';

procedure cairo_pattern_set_matrix(pattern: Pcairo_pattern_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_set_matrix';

procedure cairo_pattern_get_matrix(pattern: Pcairo_pattern_t; matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_matrix';

procedure cairo_pattern_set_extend(pattern: Pcairo_pattern_t; extend: cairo_extend_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_set_extend';

function cairo_pattern_get_extend(pattern: Pcairo_pattern_t): cairo_extend_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_extend';

procedure cairo_pattern_set_filter(pattern: Pcairo_pattern_t; filter: cairo_filter_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_set_filter';

function cairo_pattern_get_filter(pattern: Pcairo_pattern_t): cairo_filter_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_filter';

function cairo_pattern_get_rgba(pattern: Pcairo_pattern_t; red: PDouble; green: PDouble; blue: PDouble; alpha: PDouble): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_rgba';

function cairo_pattern_get_surface(pattern: Pcairo_pattern_t; surface: PPcairo_surface_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_surface';

function cairo_pattern_get_color_stop_rgba(pattern: Pcairo_pattern_t; index: Integer; offset: PDouble; red: PDouble; green: PDouble; blue: PDouble;
 alpha: PDouble): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_color_stop_rgba';

function cairo_pattern_get_color_stop_count(pattern: Pcairo_pattern_t; count: PInteger): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_color_stop_count';

function cairo_pattern_get_linear_points(pattern: Pcairo_pattern_t; x0: PDouble; y0: PDouble; x1: PDouble; y1: PDouble): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_linear_points';

function cairo_pattern_get_radial_circles(pattern: Pcairo_pattern_t; x0: PDouble; y0: PDouble; r0: PDouble; x1: PDouble; y1: PDouble; r1: PDouble)
 : cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pattern_get_radial_circles';

function cairo_mesh_pattern_get_patch_count(pattern: Pcairo_pattern_t; count: PCardinal): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_get_patch_count';

function cairo_mesh_pattern_get_path(pattern: Pcairo_pattern_t; patch_num: Cardinal): Pcairo_path_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_get_path';

function cairo_mesh_pattern_get_corner_color_rgba(pattern: Pcairo_pattern_t; patch_num: Cardinal; corner_num: Cardinal; red: PDouble; green: PDouble;
 blue: PDouble; alpha: PDouble): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_get_corner_color_rgba';

function cairo_mesh_pattern_get_control_point(pattern: Pcairo_pattern_t; patch_num: Cardinal; point_num: Cardinal; x: PDouble; y: PDouble): cairo_status_t;
 cdecl; external LIB_CAIRO_32 name _PU + 'cairo_mesh_pattern_get_control_point';

procedure cairo_matrix_init(matrix: Pcairo_matrix_t; xx: Double; yx: Double; xy: Double; yy: Double; x0: Double; y0: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_matrix_init';

procedure cairo_matrix_init_identity(matrix: Pcairo_matrix_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_init_identity';

procedure cairo_matrix_init_translate(matrix: Pcairo_matrix_t; tx: Double; ty: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_init_translate';

procedure cairo_matrix_init_scale(matrix: Pcairo_matrix_t; sx: Double; sy: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_init_scale';

procedure cairo_matrix_init_rotate(matrix: Pcairo_matrix_t; radians: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_init_rotate';

procedure cairo_matrix_translate(matrix: Pcairo_matrix_t; tx: Double; ty: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_translate';

procedure cairo_matrix_scale(matrix: Pcairo_matrix_t; sx: Double; sy: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_scale';

procedure cairo_matrix_rotate(matrix: Pcairo_matrix_t; radians: Double); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_rotate';

function cairo_matrix_invert(matrix: Pcairo_matrix_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_invert';

procedure cairo_matrix_multiply(result: Pcairo_matrix_t; a: Pcairo_matrix_t; b: Pcairo_matrix_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_matrix_multiply';

procedure cairo_matrix_transform_distance(matrix: Pcairo_matrix_t; dx: PDouble; dy: PDouble); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_matrix_transform_distance';

procedure cairo_matrix_transform_point(matrix: Pcairo_matrix_t; x: PDouble; y: PDouble); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_matrix_transform_point';

function cairo_region_create(): Pcairo_region_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_create';

function cairo_region_create_rectangle(rectangle: Pcairo_rectangle_int_t): Pcairo_region_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_create_rectangle';

function cairo_region_create_rectangles(rects: Pcairo_rectangle_int_t; count: Integer): Pcairo_region_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_create_rectangles';

function cairo_region_copy(original: Pcairo_region_t): Pcairo_region_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_copy';

function cairo_region_reference(region: Pcairo_region_t): Pcairo_region_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_reference';

procedure cairo_region_destroy(region: Pcairo_region_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_destroy';

function cairo_region_equal(a: Pcairo_region_t; b: Pcairo_region_t): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_equal';

function cairo_region_status(region: Pcairo_region_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_status';

procedure cairo_region_get_extents(region: Pcairo_region_t; extents: Pcairo_rectangle_int_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_get_extents';

function cairo_region_num_rectangles(region: Pcairo_region_t): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_num_rectangles';

procedure cairo_region_get_rectangle(region: Pcairo_region_t; nth: Integer; rectangle: Pcairo_rectangle_int_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_get_rectangle';

function cairo_region_is_empty(region: Pcairo_region_t): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_is_empty';

function cairo_region_contains_rectangle(region: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_region_overlap_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_contains_rectangle';

function cairo_region_contains_point(region: Pcairo_region_t; x: Integer; y: Integer): cairo_bool_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_contains_point';

procedure cairo_region_translate(region: Pcairo_region_t; dx: Integer; dy: Integer); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_translate';

function cairo_region_subtract(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_subtract';

function cairo_region_subtract_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_subtract_rectangle';

function cairo_region_intersect(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_intersect';

function cairo_region_intersect_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_intersect_rectangle';

function cairo_region_union(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_union';

function cairo_region_union_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_union_rectangle';

function cairo_region_xor(dst: Pcairo_region_t; other: Pcairo_region_t): cairo_status_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_region_xor';

function cairo_region_xor_rectangle(dst: Pcairo_region_t; rectangle: Pcairo_rectangle_int_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_region_xor_rectangle';

procedure cairo_debug_reset_static_data(); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_debug_reset_static_data';

function cairo_svg_surface_create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_svg_surface_create';

function cairo_svg_surface_create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double)
 : Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_svg_surface_create_for_stream';

procedure cairo_svg_surface_restrict_to_version(surface: Pcairo_surface_t; version: cairo_svg_version_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_svg_surface_restrict_to_version';

procedure cairo_svg_get_versions(versions: PPcairo_svg_version_t; num_versions: PInteger); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_svg_get_versions';

function cairo_svg_version_to_string(version: cairo_svg_version_t): PUTF8Char; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_svg_version_to_string';

procedure cairo_svg_surface_set_document_unit(surface: Pcairo_surface_t; &unit: cairo_svg_unit_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_svg_surface_set_document_unit';

function cairo_svg_surface_get_document_unit(surface: Pcairo_surface_t): cairo_svg_unit_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_svg_surface_get_document_unit';

function cairo_script_create(filename: PUTF8Char): Pcairo_device_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_script_create';

function cairo_script_create_for_stream(write_func: cairo_write_func_t; closure: Pointer): Pcairo_device_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_script_create_for_stream';

procedure cairo_script_write_comment(script: Pcairo_device_t; comment: PUTF8Char; len: Integer); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_script_write_comment';

procedure cairo_script_set_mode(script: Pcairo_device_t; mode: cairo_script_mode_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_script_set_mode';

function cairo_script_get_mode(script: Pcairo_device_t): cairo_script_mode_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_script_get_mode';

function cairo_script_surface_create(script: Pcairo_device_t; content: cairo_content_t; width: Double; height: Double): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_script_surface_create';

function cairo_script_surface_create_for_target(script: Pcairo_device_t; target: Pcairo_surface_t): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_script_surface_create_for_target';

function cairo_script_from_recording_surface(script: Pcairo_device_t; recording_surface: Pcairo_surface_t): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_script_from_recording_surface';

function cairo_pdf_surface_create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_create';

function cairo_pdf_surface_create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double)
 : Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_create_for_stream';

procedure cairo_pdf_surface_restrict_to_version(surface: Pcairo_surface_t; version: cairo_pdf_version_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_restrict_to_version';

procedure cairo_pdf_get_versions(versions: PPcairo_pdf_version_t; num_versions: PInteger); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pdf_get_versions';

function cairo_pdf_version_to_string(version: cairo_pdf_version_t): PUTF8Char; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pdf_version_to_string';

procedure cairo_pdf_surface_set_size(surface: Pcairo_surface_t; width_in_points: Double; height_in_points: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_set_size';

function cairo_pdf_surface_add_outline(surface: Pcairo_surface_t; parent_id: Integer; utf8: PUTF8Char; link_attribs: PUTF8Char;
 flags: cairo_pdf_outline_flags_t): Integer; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_add_outline';

procedure cairo_pdf_surface_set_metadata(surface: Pcairo_surface_t; metadata: cairo_pdf_metadata_t; utf8: PUTF8Char); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_set_metadata';

procedure cairo_pdf_surface_set_page_label(surface: Pcairo_surface_t; utf8: PUTF8Char); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_set_page_label';

procedure cairo_pdf_surface_set_thumbnail_size(surface: Pcairo_surface_t; width: Integer; height: Integer); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_pdf_surface_set_thumbnail_size';

function cairo_win32_surface_create(hdc: hdc): Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_win32_surface_create';

function cairo_win32_surface_create_with_format(hdc: hdc; format: cairo_format_t): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_surface_create_with_format';

function cairo_win32_printing_surface_create(hdc: hdc): Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_win32_printing_surface_create';

function cairo_win32_surface_create_with_ddb(hdc: hdc; format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_surface_create_with_ddb';

function cairo_win32_surface_create_with_dib(format: cairo_format_t; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_surface_create_with_dib';

function cairo_win32_surface_get_dc(surface: Pcairo_surface_t): hdc; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_win32_surface_get_dc';

function cairo_win32_surface_get_image(surface: Pcairo_surface_t): Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_win32_surface_get_image';

function cairo_win32_font_face_create_for_logfontw(logfont: PLOGFONTW): Pcairo_font_face_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_font_face_create_for_logfontw';

function cairo_win32_font_face_create_for_hfont(font: HFONT): Pcairo_font_face_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_font_face_create_for_hfont';

function cairo_win32_font_face_create_for_logfontw_hfont(logfont: PLOGFONTW; font: HFONT): Pcairo_font_face_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_font_face_create_for_logfontw_hfont';

function cairo_win32_scaled_font_select_font(scaled_font: Pcairo_scaled_font_t; hdc: hdc): cairo_status_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_scaled_font_select_font';

procedure cairo_win32_scaled_font_done_font(scaled_font: Pcairo_scaled_font_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_win32_scaled_font_done_font';

function cairo_win32_scaled_font_get_metrics_factor(scaled_font: Pcairo_scaled_font_t): Double; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_scaled_font_get_metrics_factor';

procedure cairo_win32_scaled_font_get_logical_to_device(scaled_font: Pcairo_scaled_font_t; logical_to_device: Pcairo_matrix_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_scaled_font_get_logical_to_device';

procedure cairo_win32_scaled_font_get_device_to_logical(scaled_font: Pcairo_scaled_font_t; device_to_logical: Pcairo_matrix_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_win32_scaled_font_get_device_to_logical';

procedure cairo_ft_font_face_set_synthesize(font_face: Pcairo_font_face_t; synth_flags: Cardinal); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ft_font_face_set_synthesize';

procedure cairo_ft_font_face_unset_synthesize(font_face: Pcairo_font_face_t; synth_flags: Cardinal); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ft_font_face_unset_synthesize';

function cairo_ft_font_face_get_synthesize(font_face: Pcairo_font_face_t): Cardinal; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ft_font_face_get_synthesize';

procedure cairo_ft_scaled_font_unlock_face(scaled_font: Pcairo_scaled_font_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ft_scaled_font_unlock_face';

function cairo_ps_surface_create(filename: PUTF8Char; width_in_points: Double; height_in_points: Double): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_create';

function cairo_ps_surface_create_for_stream(write_func: cairo_write_func_t; closure: Pointer; width_in_points: Double; height_in_points: Double)
 : Pcairo_surface_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_create_for_stream';

procedure cairo_ps_surface_restrict_to_level(surface: Pcairo_surface_t; level: cairo_ps_level_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_restrict_to_level';

procedure cairo_ps_get_levels(levels: PPcairo_ps_level_t; num_levels: PInteger); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_get_levels';

function cairo_ps_level_to_string(level: cairo_ps_level_t): PUTF8Char; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_level_to_string';

procedure cairo_ps_surface_set_eps(surface: Pcairo_surface_t; eps: cairo_bool_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_set_eps';

function cairo_ps_surface_get_eps(surface: Pcairo_surface_t): cairo_bool_t; cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_get_eps';

procedure cairo_ps_surface_set_size(surface: Pcairo_surface_t; width_in_points: Double; height_in_points: Double); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_set_size';

procedure cairo_ps_surface_dsc_comment(surface: Pcairo_surface_t; comment: PUTF8Char); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_dsc_comment';

procedure cairo_ps_surface_dsc_begin_setup(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_dsc_begin_setup';

procedure cairo_ps_surface_dsc_begin_page_setup(surface: Pcairo_surface_t); cdecl; external LIB_CAIRO_32 name _PU + 'cairo_ps_surface_dsc_begin_page_setup';

(* CAIRO GL


cairo_public cairo_surface_t *
cairo_gl_surface_create_for_dc (cairo_device_t		*device,
				HDC			 dc,
				int			 width,
				int			 height);


*)


function cairo_ft_font_face_create_for_ft_face(face : FT_Face; load_flags : integer): Pcairo_font_face_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_ft_font_face_create_for_ft_face';



{$IFDEF USEGL}
function cairo_wgl_device_create(rc: HGLRC): Pcairo_device_t; cdecl;
external LIB_CAIRO_32 name _PU + 'cairo_wgl_device_create';

function cairo_gl_surface_create(device: Pcairo_device_t; content: cairo_content_t; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_create';

function cairo_gl_surface_create_for_texture(device: Pcairo_device_t; content: cairo_content_t; Tex: Cardinal; width: Integer; height: Integer)
 : Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_create_for_texture';

procedure cairo_gl_surface_set_size(surface: Pcairo_surface_t; width_in_pixel: Integer; height_in_points: Integer); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_set_size';

function cairo_gl_surface_get_width(abstract_surface: Pcairo_surface_t): Integer; cdecl;
external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_get_width';

function cairo_gl_surface_get_height(abstract_surface: Pcairo_surface_t): Integer; cdecl;
external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_get_height';

procedure cairo_gl_surface_swapbuffers(surface: Pcairo_surface_t); cdecl;
external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_swapbuffers';

procedure cairo_gl_device_set_thread_aware(device: Pcairo_device_t; thread_aware: cairo_bool_t); cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_gl_device_set_thread_aware';


function cairo_gl_surface_create_for_dc(device: Pcairo_device_t; dc: HDC; width: Integer; height: Integer): Pcairo_surface_t; cdecl;
 external LIB_CAIRO_32 name _PU + 'cairo_gl_surface_create_for_dc';

{$ENDIF}

implementation

end.
