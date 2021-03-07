unit Cairo.NotImplemented;

interface

   {$IFDEF TESTRR}

   TCairoToyFont = class(TCairoFont)
   private
     // cairo_toy_font_face_
      function create(family: PUTF8Char; slant: cairo_font_slant_t; weight: cairo_font_weight_t): Pcairo_font_face_t;
      function get_family(font_face: Pcairo_font_face_t): PUTF8Char;
      function get_slant(font_face: Pcairo_font_face_t): cairo_font_slant_t;
      function get_weight(font_face: Pcairo_font_face_t): cairo_font_weight_t;
   end;

   TCairoUserFont = class(TCairoFont)
   private
     // cairo_user_font_face_
      function create(): Pcairo_font_face_t;
      procedure set_init_func(font_face: Pcairo_font_face_t; init_func: cairo_user_scaled_font_init_func_t);
      procedure set_render_glyph_func(font_face: Pcairo_font_face_t; render_glyph_func: cairo_user_scaled_font_render_glyph_func_t);
      procedure set_text_to_glyphs_func(font_face: Pcairo_font_face_t; text_to_glyphs_func: cairo_user_scaled_font_text_to_glyphs_func_t);
      procedure set_unicode_to_glyph_func(font_face: Pcairo_font_face_t; unicode_to_glyph_func: cairo_user_scaled_font_unicode_to_glyph_func_t);
      function get_init_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_init_func_t;
      function get_render_glyph_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_render_glyph_func_t;
      function get_text_to_glyphs_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_text_to_glyphs_func_t;
      function get_unicode_to_glyph_func(font_face: Pcairo_font_face_t): cairo_user_scaled_font_unicode_to_glyph_func_t;
   end;



// Not implemented at moment must rethink the usecase.... ;-)
   TcaObserverSurface = class(TcaSurface)
   public
    // Observer
      function create_observer(target: Pcairo_surface_t; mode: cairo_surface_observer_mode_t): Pcairo_surface_t;
      function observer_add_paint_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_add_mask_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_add_fill_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_add_stroke_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_add_glyphs_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_add_flush_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_add_finish_callback(abstract_surface: Pcairo_surface_t; func: cairo_surface_observer_callback_t; data: Pointer): cairo_status_t;
      function observer_print(Surface: Pcairo_surface_t; write_func: cairo_write_func_t; closure: Pointer): cairo_status_t;
      function observer_elapsed(Surface: Pcairo_surface_t): Double;
   end;
   {$ENDIF}
implementation

end.
