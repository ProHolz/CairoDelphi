unit Cairo.Types;

interface
 {$MINENUMSIZE 4}
const
  CAIRO_VERSION_MAJOR = 1;
  CAIRO_VERSION_MINOR = 15;
  CAIRO_VERSION_MICRO = 12;
  CAIRO_FEATURES_H = 1;
  CAIRO_HAS_WIN32_SURFACE = 1;
  CAIRO_HAS_WIN32_FONT = 1;
  CAIRO_HAS_PNG_FUNCTIONS = 1;
  CAIRO_HAS_SCRIPT_SURFACE = 1;
  CAIRO_HAS_FT_FONT = 0;
  CAIRO_HAS_PS_SURFACE = 1;
  CAIRO_HAS_PDF_SURFACE = 1;
  CAIRO_HAS_SVG_SURFACE = 1;
  CAIRO_HAS_IMAGE_SURFACE = 1;
  CAIRO_HAS_MIME_SURFACE = 1;
  CAIRO_HAS_RECORDING_SURFACE = 1;
  CAIRO_HAS_OBSERVER_SURFACE = 1;
  CAIRO_HAS_USER_FONT = 1;
  CAIRO_HAS_INTERPRETER = 1;


  CAIRO_TAG_DEST = 'cairo.dest';
  CAIRO_TAG_LINK = 'Link';
  CAIRO_MIME_TYPE_JPEG = 'image/jpeg';
  CAIRO_MIME_TYPE_PNG = 'image/png';
  CAIRO_MIME_TYPE_JP2 = 'image/jp2';
  CAIRO_MIME_TYPE_URI = 'text/x-uri';
  CAIRO_MIME_TYPE_UNIQUE_ID = 'application/x-cairo.uuid';
  CAIRO_MIME_TYPE_JBIG2 = 'application/x-cairo.jbig2';
  CAIRO_MIME_TYPE_JBIG2_GLOBAL = 'application/x-cairo.jbig2-global';
  CAIRO_MIME_TYPE_JBIG2_GLOBAL_ID = 'application/x-cairo.jbig2-global-id';
  CAIRO_MIME_TYPE_CCITT_FAX = 'image/g3fax';
  CAIRO_MIME_TYPE_CCITT_FAX_PARAMS = 'application/x-cairo.ccitt.params';
  CAIRO_MIME_TYPE_EPS = 'application/postscript';
  CAIRO_MIME_TYPE_EPS_PARAMS = 'application/x-cairo.eps.params';




  CAIRO_PDF_OUTLINE_ROOT = 0;
  TT_CONFIG_OPTION_SUBPIXEL_HINTING = 2;
  TT_CONFIG_OPTION_MAX_RUNNABLE_OPCODES = 1000000;
  T1_MAX_DICT_DEPTH = 5;
  T1_MAX_SUBRS_CALLS = 16;
  T1_MAX_CHARSTRINGS_OPERANDS = 256;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_X1 = 500;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y1 = 400;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_X2 = 1000;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y2 = 275;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_X3 = 1667;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y3 = 275;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_X4 = 2333;
  CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y4 = 0;

  CHAR_BIT = 8;
  USHRT_MAX = $ffff;
  INT_MAX = 2147483647;
  INT_MIN = (-2147483647-1);
  UINT_MAX = $ffffffff;
  LONG_MIN = (-2147483647-1);
  LONG_MAX = 2147483647;
  ULONG_MAX = $ffffffff;

type
  PUTF8CHAR = PAnsiChar;
  UTF8Char = AnsiChar;

  // Forward declarations
  PPByte = ^PByte;
  P_cairo = Pointer;
  PP_cairo = ^P_cairo;
  P_cairo_surface = type of Pointer;
  PP_cairo_surface = ^P_cairo_surface;
  P_cairo_device = Pointer;
  PP_cairo_device = ^P_cairo_device;
  P_cairo_pattern = Pointer;
  PP_cairo_pattern = ^P_cairo_pattern;
  P_cairo_scaled_font = Pointer;
  PP_cairo_scaled_font = ^P_cairo_scaled_font;
  P_cairo_font_face = Pointer;
  PP_cairo_font_face = ^P_cairo_font_face;
  P_cairo_font_options = Pointer;
  PP_cairo_font_options = ^P_cairo_font_options;
  P_cairo_region = Pointer;
  PP_cairo_region = ^P_cairo_region;
  PFT_RasterRec_ = Pointer;
  PPFT_RasterRec_ = ^PFT_RasterRec_;
  PFT_LibraryRec_ = Pointer;
  PPFT_LibraryRec_ = ^PFT_LibraryRec_;
  PFT_ModuleRec_ = Pointer;
  PPFT_ModuleRec_ = ^PFT_ModuleRec_;
  PFT_DriverRec_ = Pointer;
  PPFT_DriverRec_ = ^PFT_DriverRec_;
  PFT_RendererRec_ = Pointer;
  PPFT_RendererRec_ = ^PFT_RendererRec_;
  PFT_Face_InternalRec_ = Pointer;
  PPFT_Face_InternalRec_ = ^PFT_Face_InternalRec_;
  PFT_Size_InternalRec_ = Pointer;
  PPFT_Size_InternalRec_ = ^PFT_Size_InternalRec_;
  PFT_SubGlyphRec_ = Pointer;
  PPFT_SubGlyphRec_ = ^PFT_SubGlyphRec_;
  PFT_Slot_InternalRec_ = Pointer;
  PPFT_Slot_InternalRec_ = ^PFT_Slot_InternalRec_;
  P_cairo_matrix = ^_cairo_matrix;
  P_cairo_user_data_key = ^_cairo_user_data_key;
  P_cairo_rectangle_int = ^_cairo_rectangle_int;
  P_cairo_rectangle = ^_cairo_rectangle;
  P_cairo_rectangle_list = ^_cairo_rectangle_list;
  Pcairo_glyph_t = ^cairo_glyph_t;
  PPcairo_glyph_t = ^Pcairo_glyph_t;
  Pcairo_text_cluster_t = ^cairo_text_cluster_t;
  PPcairo_text_cluster_t = ^Pcairo_text_cluster_t;
  Pcairo_text_extents_t = ^cairo_text_extents_t;
  Pcairo_font_extents_t = ^cairo_font_extents_t;
  Pcairo_path = ^cairo_path;


  (**
   * cairo_bool_t:
   *
   * #cairo_bool_t is used for boolean values. Returns of type
   * #cairo_bool_t will always be either 0 or 1, but testing against
   * these values explicitly is not encouraged; just use the
   * value as a boolean condition.
   *
   * <informalexample><programlisting>
   *  if (cairo_in_stroke (cr, x, y)) {
   *      /<!-- -->* do something *<!-- -->/
   *  }
   * </programlisting></informalexample>
   *
   * Since: 1.0
   **)
  cairo_bool_t = LongBool;
  Pcairo_t = type of Pointer;
  PPcairo_t = ^Pcairo_t;
  Pcairo_surface_t = type of Pointer;
  PPcairo_surface_t = ^Pcairo_surface_t;
  Pcairo_device_t = type of Pointer;
  PPcairo_device_t = ^Pcairo_device_t;

  (**
   * cairo_matrix_t:
   * @xx: xx component of the affine transformation
   * @yx: yx component of the affine transformation
   * @xy: xy component of the affine transformation
   * @yy: yy component of the affine transformation
   * @x0: X translation component of the affine transformation
   * @y0: Y translation component of the affine transformation
   *
   * A #cairo_matrix_t holds an affine transformation, such as a scale,
   * rotation, shear, or a combination of those. The transformation of
   * a point (x, y) is given by:
   * <programlisting>
   *     x_new = xx * x + xy * y + x0;
   *     y_new = yx * x + yy * y + y0;
   * </programlisting>
   *
   * Since: 1.0
   **)
  _cairo_matrix = record
    xx: Double;
    yx: Double;
    xy: Double;
    yy: Double;
    x0: Double;
    y0: Double;
  end;

  cairo_matrix_t = _cairo_matrix;
  Pcairo_matrix_t = ^cairo_matrix_t;
  Pcairo_pattern_t = type of Pointer;
  PPcairo_pattern_t = ^Pcairo_pattern_t;

  (**
   * cairo_destroy_func_t:
   * @data: The data element being destroyed.
   *
   * #cairo_destroy_func_t the type of function which is called when a
   * data element is destroyed. It is passed the pointer to the data
   * element and should free any memory and resources allocated for it.
   *
   * Since: 1.0
   **)
  cairo_destroy_func_t = procedure(data: Pointer); cdecl;

  (**
   * cairo_user_data_key_t:
   * @unused: not used; ignore.
   *
   * #cairo_user_data_key_t is used for attaching user data to cairo
   * data structures.  The actual contents of the struct is never used,
   * and there is no need to initialize the object; only the unique
   * address of a #cairo_data_key_t object is used.  Typically, you
   * would just use the address of a static #cairo_data_key_t object.
   *
   * Since: 1.0
   **)
  _cairo_user_data_key = record
    unused: Integer;
  end;

  cairo_user_data_key_t = _cairo_user_data_key;
  Pcairo_user_data_key_t = ^cairo_user_data_key_t;

  (**
   * cairo_status_t:
   * @CAIRO_STATUS_SUCCESS: no error has occurred (Since 1.0)
   * @CAIRO_STATUS_NO_MEMORY: out of memory (Since 1.0)
   * @CAIRO_STATUS_INVALID_RESTORE: cairo_restore() called without matching cairo_save() (Since 1.0)
   * @CAIRO_STATUS_INVALID_POP_GROUP: no saved group to pop, i.e. cairo_pop_group() without matching cairo_push_group() (Since 1.0)
   * @CAIRO_STATUS_NO_CURRENT_POINT: no current point defined (Since 1.0)
   * @CAIRO_STATUS_INVALID_MATRIX: invalid matrix (not invertible) (Since 1.0)
   * @CAIRO_STATUS_INVALID_STATUS: invalid value for an input #cairo_status_t (Since 1.0)
   * @CAIRO_STATUS_NULL_POINTER: %NULL pointer (Since 1.0)
   * @CAIRO_STATUS_INVALID_STRING: input string not valid UTF-8 (Since 1.0)
   * @CAIRO_STATUS_INVALID_PATH_DATA: input path data not valid (Since 1.0)
   * @CAIRO_STATUS_READ_ERROR: error while reading from input stream (Since 1.0)
   * @CAIRO_STATUS_WRITE_ERROR: error while writing to output stream (Since 1.0)
   * @CAIRO_STATUS_SURFACE_FINISHED: target surface has been finished (Since 1.0)
   * @CAIRO_STATUS_SURFACE_TYPE_MISMATCH: the surface type is not appropriate for the operation (Since 1.0)
   * @CAIRO_STATUS_PATTERN_TYPE_MISMATCH: the pattern type is not appropriate for the operation (Since 1.0)
   * @CAIRO_STATUS_INVALID_CONTENT: invalid value for an input #cairo_content_t (Since 1.0)
   * @CAIRO_STATUS_INVALID_FORMAT: invalid value for an input #cairo_format_t (Since 1.0)
   * @CAIRO_STATUS_INVALID_VISUAL: invalid value for an input Visual* (Since 1.0)
   * @CAIRO_STATUS_FILE_NOT_FOUND: file not found (Since 1.0)
   * @CAIRO_STATUS_INVALID_DASH: invalid value for a dash setting (Since 1.0)
   * @CAIRO_STATUS_INVALID_DSC_COMMENT: invalid value for a DSC comment (Since 1.2)
   * @CAIRO_STATUS_INVALID_INDEX: invalid index passed to getter (Since 1.4)
   * @CAIRO_STATUS_CLIP_NOT_REPRESENTABLE: clip region not representable in desired format (Since 1.4)
   * @CAIRO_STATUS_TEMP_FILE_ERROR: error creating or writing to a temporary file (Since 1.6)
   * @CAIRO_STATUS_INVALID_STRIDE: invalid value for stride (Since 1.6)
   * @CAIRO_STATUS_FONT_TYPE_MISMATCH: the font type is not appropriate for the operation (Since 1.8)
   * @CAIRO_STATUS_USER_FONT_IMMUTABLE: the user-font is immutable (Since 1.8)
   * @CAIRO_STATUS_USER_FONT_ERROR: error occurred in a user-font callback function (Since 1.8)
   * @CAIRO_STATUS_NEGATIVE_COUNT: negative number used where it is not allowed (Since 1.8)
   * @CAIRO_STATUS_INVALID_CLUSTERS: input clusters do not represent the accompanying text and glyph array (Since 1.8)
   * @CAIRO_STATUS_INVALID_SLANT: invalid value for an input #cairo_font_slant_t (Since 1.8)
   * @CAIRO_STATUS_INVALID_WEIGHT: invalid value for an input #cairo_font_weight_t (Since 1.8)
   * @CAIRO_STATUS_INVALID_SIZE: invalid value (typically too big) for the size of the input (surface, pattern, etc.) (Since 1.10)
   * @CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED: user-font method not implemented (Since 1.10)
   * @CAIRO_STATUS_DEVICE_TYPE_MISMATCH: the device type is not appropriate for the operation (Since 1.10)
   * @CAIRO_STATUS_DEVICE_ERROR: an operation to the device caused an unspecified error (Since 1.10)
   * @CAIRO_STATUS_INVALID_MESH_CONSTRUCTION: a mesh pattern
   *   construction operation was used outside of a
   *   cairo_mesh_pattern_begin_patch()/cairo_mesh_pattern_end_patch()
   *   pair (Since 1.12)
   * @CAIRO_STATUS_DEVICE_FINISHED: target device has been finished (Since 1.12)
   * @CAIRO_STATUS_JBIG2_GLOBAL_MISSING: %CAIRO_MIME_TYPE_JBIG2_GLOBAL_ID has been used on at least one image
   *   but no image provided %CAIRO_MIME_TYPE_JBIG2_GLOBAL (Since 1.14)
   * @CAIRO_STATUS_PNG_ERROR: error occurred in libpng while reading from or writing to a PNG file (Since 1.16)
   * @CAIRO_STATUS_FREETYPE_ERROR: error occurred in libfreetype (Since 1.16)
   * @CAIRO_STATUS_WIN32_GDI_ERROR: error occurred in the Windows Graphics Device Interface (Since 1.16)
   * @CAIRO_STATUS_TAG_ERROR: invalid tag name, attributes, or nesting (Since 1.16)
   * @CAIRO_STATUS_LAST_STATUS: this is a special value indicating the number of
   *   status values defined in this enumeration.  When using this value, note
   *   that the version of cairo at run-time may have additional status values
   *   defined than the value of this symbol at compile-time. (Since 1.10)
   *
   * #cairo_status_t is used to indicate errors that can occur when
   * using Cairo. In some cases it is returned directly by functions.
   * but when using #cairo_t, the last error, if any, is stored in
   * the context and can be retrieved with cairo_status().
   *
   * New entries may be added in future versions.  Use cairo_status_to_string()
   * to get a human-readable representation of an error message.
   *
   * Since: 1.0
   **)
  _cairo_status = (
    CAIRO_STATUS_SUCCESS = 0,
    CAIRO_STATUS_NO_MEMORY = 1,
    CAIRO_STATUS_INVALID_RESTORE = 2,
    CAIRO_STATUS_INVALID_POP_GROUP = 3,
    CAIRO_STATUS_NO_CURRENT_POINT = 4,
    CAIRO_STATUS_INVALID_MATRIX = 5,
    CAIRO_STATUS_INVALID_STATUS = 6,
    CAIRO_STATUS_NULL_POINTER = 7,
    CAIRO_STATUS_INVALID_STRING = 8,
    CAIRO_STATUS_INVALID_PATH_DATA = 9,
    CAIRO_STATUS_READ_ERROR = 10,
    CAIRO_STATUS_WRITE_ERROR = 11,
    CAIRO_STATUS_SURFACE_FINISHED = 12,
    CAIRO_STATUS_SURFACE_TYPE_MISMATCH = 13,
    CAIRO_STATUS_PATTERN_TYPE_MISMATCH = 14,
    CAIRO_STATUS_INVALID_CONTENT = 15,
    CAIRO_STATUS_INVALID_FORMAT = 16,
    CAIRO_STATUS_INVALID_VISUAL = 17,
    CAIRO_STATUS_FILE_NOT_FOUND = 18,
    CAIRO_STATUS_INVALID_DASH = 19,
    CAIRO_STATUS_INVALID_DSC_COMMENT = 20,
    CAIRO_STATUS_INVALID_INDEX = 21,
    CAIRO_STATUS_CLIP_NOT_REPRESENTABLE = 22,
    CAIRO_STATUS_TEMP_FILE_ERROR = 23,
    CAIRO_STATUS_INVALID_STRIDE = 24,
    CAIRO_STATUS_FONT_TYPE_MISMATCH = 25,
    CAIRO_STATUS_USER_FONT_IMMUTABLE = 26,
    CAIRO_STATUS_USER_FONT_ERROR = 27,
    CAIRO_STATUS_NEGATIVE_COUNT = 28,
    CAIRO_STATUS_INVALID_CLUSTERS = 29,
    CAIRO_STATUS_INVALID_SLANT = 30,
    CAIRO_STATUS_INVALID_WEIGHT = 31,
    CAIRO_STATUS_INVALID_SIZE = 32,
    CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED = 33,
    CAIRO_STATUS_DEVICE_TYPE_MISMATCH = 34,
    CAIRO_STATUS_DEVICE_ERROR = 35,
    CAIRO_STATUS_INVALID_MESH_CONSTRUCTION = 36,
    CAIRO_STATUS_DEVICE_FINISHED = 37,
    CAIRO_STATUS_JBIG2_GLOBAL_MISSING = 38,
    CAIRO_STATUS_PNG_ERROR = 39,
    CAIRO_STATUS_FREETYPE_ERROR = 40,
    CAIRO_STATUS_WIN32_GDI_ERROR = 41,
    CAIRO_STATUS_TAG_ERROR = 42,
    CAIRO_STATUS_LAST_STATUS = 43);
  P_cairo_status = ^_cairo_status;
  cairo_status_t = _cairo_status;

  (**
   * cairo_content_t:
   * @CAIRO_CONTENT_COLOR: The surface will hold color content only. (Since 1.0)
   * @CAIRO_CONTENT_ALPHA: The surface will hold alpha content only. (Since 1.0)
   * @CAIRO_CONTENT_COLOR_ALPHA: The surface will hold color and alpha content. (Since 1.0)
   *
   * #cairo_content_t is used to describe the content that a surface will
   * contain, whether color information, alpha information (translucence
   * vs. opacity), or both.
   *
   * Note: The large values here are designed to keep #cairo_content_t
   * values distinct from #cairo_format_t values so that the
   * implementation can detect the error if users confuse the two types.
   *
   * Since: 1.0
   **)
  _cairo_content = (
    CAIRO_CONTENT_COLOR = 4096,
    CAIRO_CONTENT_ALPHA = 8192,
    CAIRO_CONTENT_COLOR_ALPHA = 12288);
  P_cairo_content = ^_cairo_content;
  cairo_content_t = _cairo_content;

  (**
   * cairo_format_t:
   * @CAIRO_FORMAT_INVALID: no such format exists or is supported.
   * @CAIRO_FORMAT_ARGB32: each pixel is a 32-bit quantity, with
   *   alpha in the upper 8 bits, then red, then green, then blue.
   *   The 32-bit quantities are stored native-endian. Pre-multiplied
   *   alpha is used. (That is, 50% transparent red is 0x80800000,
   *   not 0x80ff0000.) (Since 1.0)
   * @CAIRO_FORMAT_RGB24: each pixel is a 32-bit quantity, with
   *   the upper 8 bits unused. Red, Green, and Blue are stored
   *   in the remaining 24 bits in that order. (Since 1.0)
   * @CAIRO_FORMAT_A8: each pixel is a 8-bit quantity holding
   *   an alpha value. (Since 1.0)
   * @CAIRO_FORMAT_A1: each pixel is a 1-bit quantity holding
   *   an alpha value. Pixels are packed together into 32-bit
   *   quantities. The ordering of the bits matches the
   *   endianess of the platform. On a big-endian machine, the
   *   first pixel is in the uppermost bit, on a little-endian
   *   machine the first pixel is in the least-significant bit. (Since 1.0)
   * @CAIRO_FORMAT_RGB16_565: each pixel is a 16-bit quantity
   *   with red in the upper 5 bits, then green in the middle
   *   6 bits, and blue in the lower 5 bits. (Since 1.2)
   * @CAIRO_FORMAT_RGB30: like RGB24 but with 10bpc. (Since 1.12)
   *
   * #cairo_format_t is used to identify the memory format of
   * image data.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.0
   **)
  _cairo_format = (
    CAIRO_FORMAT_INVALID = -1,
    CAIRO_FORMAT_ARGB32 = 0,
    CAIRO_FORMAT_RGB24 = 1,
    CAIRO_FORMAT_A8 = 2,
    CAIRO_FORMAT_A1 = 3,
    CAIRO_FORMAT_RGB16_565 = 4,
    CAIRO_FORMAT_RGB30 = 5);
  P_cairo_format = ^_cairo_format;
  cairo_format_t = _cairo_format;

  (**
   * cairo_write_func_t:
   * @closure: the output closure
   * @data: the buffer containing the data to write
   * @length: the amount of data to write
   *
   * #cairo_write_func_t is the type of function which is called when a
   * backend needs to write data to an output stream.  It is passed the
   * closure which was specified by the user at the time the write
   * function was registered, the data to write and the length of the
   * data in bytes.  The write function should return
   * %CAIRO_STATUS_SUCCESS if all the data was successfully written,
   * %CAIRO_STATUS_WRITE_ERROR otherwise.
   *
   * Returns: the status code of the write operation
   *
   * Since: 1.0
   **)
  cairo_write_func_t = function(closure: Pointer; data: PByte; length: Cardinal): _cairo_status; cdecl;

  (**
   * cairo_read_func_t:
   * @closure: the input closure
   * @data: the buffer into which to read the data
   * @length: the amount of data to read
   *
   * #cairo_read_func_t is the type of function which is called when a
   * backend needs to read data from an input stream.  It is passed the
   * closure which was specified by the user at the time the read
   * function was registered, the buffer to read the data into and the
   * length of the data in bytes.  The read function should return
   * %CAIRO_STATUS_SUCCESS if all the data was successfully read,
   * %CAIRO_STATUS_READ_ERROR otherwise.
   *
   * Returns: the status code of the read operation
   *
   * Since: 1.0
   **)
  cairo_read_func_t = function(closure: Pointer; data: PByte; length: Cardinal): _cairo_status; cdecl;

  (**
   * cairo_rectangle_int_t:
   * @x: X coordinate of the left side of the rectangle
   * @y: Y coordinate of the the top side of the rectangle
   * @width: width of the rectangle
   * @height: height of the rectangle
   *
   * A data structure for holding a rectangle with integer coordinates.
   *
   * Since: 1.10
   **)
  _cairo_rectangle_int = record
    x: Integer;
    y: Integer;
    width: Integer;
    height: Integer;
  end;

  cairo_rectangle_int_t = _cairo_rectangle_int;
  Pcairo_rectangle_int_t = ^cairo_rectangle_int_t;

  (**
   * cairo_operator_t:
   * @CAIRO_OPERATOR_CLEAR: clear destination layer (bounded) (Since 1.0)
   * @CAIRO_OPERATOR_SOURCE: replace destination layer (bounded) (Since 1.0)
   * @CAIRO_OPERATOR_OVER: draw source layer on top of destination layer
   * (bounded) (Since 1.0)
   * @CAIRO_OPERATOR_IN: draw source where there was destination content
   * (unbounded) (Since 1.0)
   * @CAIRO_OPERATOR_OUT: draw source where there was no destination
   * content (unbounded) (Since 1.0)
   * @CAIRO_OPERATOR_ATOP: draw source on top of destination content and
   * only there (Since 1.0)
   * @CAIRO_OPERATOR_DEST: ignore the source (Since 1.0)
   * @CAIRO_OPERATOR_DEST_OVER: draw destination on top of source (Since 1.0)
   * @CAIRO_OPERATOR_DEST_IN: leave destination only where there was
   * source content (unbounded) (Since 1.0)
   * @CAIRO_OPERATOR_DEST_OUT: leave destination only where there was no
   * source content (Since 1.0)
   * @CAIRO_OPERATOR_DEST_ATOP: leave destination on top of source content
   * and only there (unbounded) (Since 1.0)
   * @CAIRO_OPERATOR_XOR: source and destination are shown where there is only
   * one of them (Since 1.0)
   * @CAIRO_OPERATOR_ADD: source and destination layers are accumulated (Since 1.0)
   * @CAIRO_OPERATOR_SATURATE: like over, but assuming source and dest are
   * disjoint geometries (Since 1.0)
   * @CAIRO_OPERATOR_MULTIPLY: source and destination layers are multiplied.
   * This causes the result to be at least as dark as the darker inputs. (Since 1.10)
   * @CAIRO_OPERATOR_SCREEN: source and destination are complemented and
   * multiplied. This causes the result to be at least as light as the lighter
   * inputs. (Since 1.10)
   * @CAIRO_OPERATOR_OVERLAY: multiplies or screens, depending on the
   * lightness of the destination color. (Since 1.10)
   * @CAIRO_OPERATOR_DARKEN: replaces the destination with the source if it
   * is darker, otherwise keeps the source. (Since 1.10)
   * @CAIRO_OPERATOR_LIGHTEN: replaces the destination with the source if it
   * is lighter, otherwise keeps the source. (Since 1.10)
   * @CAIRO_OPERATOR_COLOR_DODGE: brightens the destination color to reflect
   * the source color. (Since 1.10)
   * @CAIRO_OPERATOR_COLOR_BURN: darkens the destination color to reflect
   * the source color. (Since 1.10)
   * @CAIRO_OPERATOR_HARD_LIGHT: Multiplies or screens, dependent on source
   * color. (Since 1.10)
   * @CAIRO_OPERATOR_SOFT_LIGHT: Darkens or lightens, dependent on source
   * color. (Since 1.10)
   * @CAIRO_OPERATOR_DIFFERENCE: Takes the difference of the source and
   * destination color. (Since 1.10)
   * @CAIRO_OPERATOR_EXCLUSION: Produces an effect similar to difference, but
   * with lower contrast. (Since 1.10)
   * @CAIRO_OPERATOR_HSL_HUE: Creates a color with the hue of the source
   * and the saturation and luminosity of the target. (Since 1.10)
   * @CAIRO_OPERATOR_HSL_SATURATION: Creates a color with the saturation
   * of the source and the hue and luminosity of the target. Painting with
   * this mode onto a gray area produces no change. (Since 1.10)
   * @CAIRO_OPERATOR_HSL_COLOR: Creates a color with the hue and saturation
   * of the source and the luminosity of the target. This preserves the gray
   * levels of the target and is useful for coloring monochrome images or
   * tinting color images. (Since 1.10)
   * @CAIRO_OPERATOR_HSL_LUMINOSITY: Creates a color with the luminosity of
   * the source and the hue and saturation of the target. This produces an
   * inverse effect to @CAIRO_OPERATOR_HSL_COLOR. (Since 1.10)
   *
   * #cairo_operator_t is used to set the compositing operator for all cairo
   * drawing operations.
   *
   * The default operator is %CAIRO_OPERATOR_OVER.
   *
   * The operators marked as <firstterm>unbounded</firstterm> modify their
   * destination even outside of the mask layer (that is, their effect is not
   * bound by the mask layer).  However, their effect can still be limited by
   * way of clipping.
   *
   * To keep things simple, the operator descriptions here
   * document the behavior for when both source and destination are either fully
   * transparent or fully opaque.  The actual implementation works for
   * translucent layers too.
   * For a more detailed explanation of the effects of each operator, including
   * the mathematical definitions, see
   * <ulink url="http://cairographics.org/operators/">http://cairographics.org/operators/</ulink>.
   *
   * Since: 1.0
   **)
  _cairo_operator = (
    CAIRO_OPERATOR_CLEAR = 0,
    CAIRO_OPERATOR_SOURCE = 1,
    CAIRO_OPERATOR_OVER = 2,
    CAIRO_OPERATOR_IN = 3,
    CAIRO_OPERATOR_OUT = 4,
    CAIRO_OPERATOR_ATOP = 5,
    CAIRO_OPERATOR_DEST = 6,
    CAIRO_OPERATOR_DEST_OVER = 7,
    CAIRO_OPERATOR_DEST_IN = 8,
    CAIRO_OPERATOR_DEST_OUT = 9,
    CAIRO_OPERATOR_DEST_ATOP = 10,
    CAIRO_OPERATOR_XOR = 11,
    CAIRO_OPERATOR_ADD = 12,
    CAIRO_OPERATOR_SATURATE = 13,
    CAIRO_OPERATOR_MULTIPLY = 14,
    CAIRO_OPERATOR_SCREEN = 15,
    CAIRO_OPERATOR_OVERLAY = 16,
    CAIRO_OPERATOR_DARKEN = 17,
    CAIRO_OPERATOR_LIGHTEN = 18,
    CAIRO_OPERATOR_COLOR_DODGE = 19,
    CAIRO_OPERATOR_COLOR_BURN = 20,
    CAIRO_OPERATOR_HARD_LIGHT = 21,
    CAIRO_OPERATOR_SOFT_LIGHT = 22,
    CAIRO_OPERATOR_DIFFERENCE = 23,
    CAIRO_OPERATOR_EXCLUSION = 24,
    CAIRO_OPERATOR_HSL_HUE = 25,
    CAIRO_OPERATOR_HSL_SATURATION = 26,
    CAIRO_OPERATOR_HSL_COLOR = 27,
    CAIRO_OPERATOR_HSL_LUMINOSITY = 28);
  P_cairo_operator = ^_cairo_operator;
  cairo_operator_t = _cairo_operator;

  (**
   * cairo_antialias_t:
   * @CAIRO_ANTIALIAS_DEFAULT: Use the default antialiasing for
   *   the subsystem and target device, since 1.0
   * @CAIRO_ANTIALIAS_NONE: Use a bilevel alpha mask, since 1.0
   * @CAIRO_ANTIALIAS_GRAY: Perform single-color antialiasing (using
   *  shades of gray for black text on a white background, for example), since 1.0
   * @CAIRO_ANTIALIAS_SUBPIXEL: Perform antialiasing by taking
   *  advantage of the order of subpixel elements on devices
   *  such as LCD panels, since 1.0
   * @CAIRO_ANTIALIAS_FAST: Hint that the backend should perform some
   * antialiasing but prefer speed over quality, since 1.12
   * @CAIRO_ANTIALIAS_GOOD: The backend should balance quality against
   * performance, since 1.12
   * @CAIRO_ANTIALIAS_BEST: Hint that the backend should render at the highest
   * quality, sacrificing speed if necessary, since 1.12
   *
   * Specifies the type of antialiasing to do when rendering text or shapes.
   *
   * As it is not necessarily clear from the above what advantages a particular
   * antialias method provides, since 1.12, there is also a set of hints:
   * @CAIRO_ANTIALIAS_FAST: Allow the backend to degrade raster quality for speed
   * @CAIRO_ANTIALIAS_GOOD: A balance between speed and quality
   * @CAIRO_ANTIALIAS_BEST: A high-fidelity, but potentially slow, raster mode
   *
   * These make no guarantee on how the backend will perform its rasterisation
   * (if it even rasterises!), nor that they have any differing effect other
   * than to enable some form of antialiasing. In the case of glyph rendering,
   * @CAIRO_ANTIALIAS_FAST and @CAIRO_ANTIALIAS_GOOD will be mapped to
   * @CAIRO_ANTIALIAS_GRAY, with @CAIRO_ANTALIAS_BEST being equivalent to
   * @CAIRO_ANTIALIAS_SUBPIXEL.
   *
   * The interpretation of @CAIRO_ANTIALIAS_DEFAULT is left entirely up to
   * the backend, typically this will be similar to @CAIRO_ANTIALIAS_GOOD.
   *
   * Since: 1.0
   **)
  _cairo_antialias = (
    CAIRO_ANTIALIAS_DEFAULT = 0,
    CAIRO_ANTIALIAS_NONE = 1,
    CAIRO_ANTIALIAS_GRAY = 2,
    CAIRO_ANTIALIAS_SUBPIXEL = 3,
    CAIRO_ANTIALIAS_FAST = 4,
    CAIRO_ANTIALIAS_GOOD = 5,
    CAIRO_ANTIALIAS_BEST = 6);
  P_cairo_antialias = ^_cairo_antialias;
  cairo_antialias_t = _cairo_antialias;

  (**
   * cairo_fill_rule_t:
   * @CAIRO_FILL_RULE_WINDING: If the path crosses the ray from
   * left-to-right, counts +1. If the path crosses the ray
   * from right to left, counts -1. (Left and right are determined
   * from the perspective of looking along the ray from the starting
   * point.) If the total count is non-zero, the point will be filled. (Since 1.0)
   * @CAIRO_FILL_RULE_EVEN_ODD: Counts the total number of
   * intersections, without regard to the orientation of the contour. If
   * the total number of intersections is odd, the point will be
   * filled. (Since 1.0)
   *
   * #cairo_fill_rule_t is used to select how paths are filled. For both
   * fill rules, whether or not a point is included in the fill is
   * determined by taking a ray from that point to infinity and looking
   * at intersections with the path. The ray can be in any direction,
   * as long as it doesn't pass through the end point of a segment
   * or have a tricky intersection such as intersecting tangent to the path.
   * (Note that filling is not actually implemented in this way. This
   * is just a description of the rule that is applied.)
   *
   * The default fill rule is %CAIRO_FILL_RULE_WINDING.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.0
   **)
  _cairo_fill_rule = (
    CAIRO_FILL_RULE_WINDING = 0,
    CAIRO_FILL_RULE_EVEN_ODD = 1);
  P_cairo_fill_rule = ^_cairo_fill_rule;
  cairo_fill_rule_t = _cairo_fill_rule;

  (**
   * cairo_line_cap_t:
   * @CAIRO_LINE_CAP_BUTT: start(stop) the line exactly at the start(end) point (Since 1.0)
   * @CAIRO_LINE_CAP_ROUND: use a round ending, the center of the circle is the end point (Since 1.0)
   * @CAIRO_LINE_CAP_SQUARE: use squared ending, the center of the square is the end point (Since 1.0)
   *
   * Specifies how to render the endpoints of the path when stroking.
   *
   * The default line cap style is %CAIRO_LINE_CAP_BUTT.
   *
   * Since: 1.0
   **)

  _cairo_line_cap = (
    CAIRO_LINE_CAP_BUTT = 0,
    CAIRO_LINE_CAP_ROUND = 1,
    CAIRO_LINE_CAP_SQUARE = 2);
  P_cairo_line_cap = ^_cairo_line_cap;
  cairo_line_cap_t = _cairo_line_cap;

  (**
   * cairo_line_join_t:
   * @CAIRO_LINE_JOIN_MITER: use a sharp (angled) corner, see
   * cairo_set_miter_limit() (Since 1.0)
   * @CAIRO_LINE_JOIN_ROUND: use a rounded join, the center of the circle is the
   * joint point (Since 1.0)
   * @CAIRO_LINE_JOIN_BEVEL: use a cut-off join, the join is cut off at half
   * the line width from the joint point (Since 1.0)
   *
   * Specifies how to render the junction of two lines when stroking.
   *
   * The default line join style is %CAIRO_LINE_JOIN_MITER.
   *
   * Since: 1.0
   **)
  _cairo_line_join = (
    CAIRO_LINE_JOIN_MITER = 0,
    CAIRO_LINE_JOIN_ROUND = 1,
    CAIRO_LINE_JOIN_BEVEL = 2);
  P_cairo_line_join = ^_cairo_line_join;
  cairo_line_join_t = _cairo_line_join;

  (**
   * cairo_rectangle_t:
   * @x: X coordinate of the left side of the rectangle
   * @y: Y coordinate of the the top side of the rectangle
   * @width: width of the rectangle
   * @height: height of the rectangle
   *
   * A data structure for holding a rectangle.
   *
   * Since: 1.4
   **)
  _cairo_rectangle = record
    x: Double;
    y: Double;
    width: Double;
    height: Double;
  end;

  cairo_rectangle_t = _cairo_rectangle;
  Pcairo_rectangle_t = ^cairo_rectangle_t;

  (**
   * cairo_rectangle_list_t:
   * @status: Error status of the rectangle list
   * @rectangles: Array containing the rectangles
   * @num_rectangles: Number of rectangles in this list
   *
   * A data structure for holding a dynamically allocated
   * array of rectangles.
   *
   * Since: 1.4
   **)
  _cairo_rectangle_list = record
    status: cairo_status_t;
    rectangles: Pcairo_rectangle_t;
    num_rectangles: Integer;
  end;

  cairo_rectangle_list_t = _cairo_rectangle_list;
  Pcairo_rectangle_list_t = ^cairo_rectangle_list_t;
  Pcairo_scaled_font_t = Pointer;
  PPcairo_scaled_font_t = ^Pcairo_scaled_font_t;
  Pcairo_font_face_t = Pointer;
  PPcairo_font_face_t = ^Pcairo_font_face_t;

  (**
   * cairo_glyph_t:
   * @index: glyph index in the font. The exact interpretation of the
   *      glyph index depends on the font technology being used.
   * @x: the offset in the X direction between the origin used for
   *     drawing or measuring the string and the origin of this glyph.
   * @y: the offset in the Y direction between the origin used for
   *     drawing or measuring the string and the origin of this glyph.
   *
   * The #cairo_glyph_t structure holds information about a single glyph
   * when drawing or measuring text. A font is (in simple terms) a
   * collection of shapes used to draw text. A glyph is one of these
   * shapes. There can be multiple glyphs for a single character
   * (alternates to be used in different contexts, for example), or a
   * glyph can be a <firstterm>ligature</firstterm> of multiple
   * characters. Cairo doesn't expose any way of converting input text
   * into glyphs, so in order to use the Cairo interfaces that take
   * arrays of glyphs, you must directly access the appropriate
   * underlying font system.
   *
   * Note that the offsets given by @x and @y are not cumulative. When
   * drawing or measuring text, each glyph is individually positioned
   * with respect to the overall origin
   *
   * Since: 1.0
   **)
  cairo_glyph_t = record
    index: Cardinal;
    x: Double;
    y: Double;
  end;

  (**
   * cairo_text_cluster_t:
   * @num_bytes: the number of bytes of UTF-8 text covered by cluster
   * @num_glyphs: the number of glyphs covered by cluster
   *
   * The #cairo_text_cluster_t structure holds information about a single
   * <firstterm>text cluster</firstterm>.  A text cluster is a minimal
   * mapping of some glyphs corresponding to some UTF-8 text.
   *
   * For a cluster to be valid, both @num_bytes and @num_glyphs should
   * be non-negative, and at least one should be non-zero.
   * Note that clusters with zero glyphs are not as well supported as
   * normal clusters.  For example, PDF rendering applications typically
   * ignore those clusters when PDF text is being selected.
   *
   * See cairo_show_text_glyphs() for how clusters are used in advanced
   * text operations.
   *
   * Since: 1.8
   **)
  cairo_text_cluster_t = record
    num_bytes: Integer;
    num_glyphs: Integer;
  end;

  (**
   * cairo_text_cluster_flags_t:
   * @CAIRO_TEXT_CLUSTER_FLAG_BACKWARD: The clusters in the cluster array
   * map to glyphs in the glyph array from end to start. (Since 1.8)
   *
   * Specifies properties of a text cluster mapping.
   *
   * Since: 1.8
   **)
  _cairo_text_cluster_flags = (
    CAIRO_TEXT_CLUSTER_FLAG_BACKWARD = 1);
  P_cairo_text_cluster_flags = ^_cairo_text_cluster_flags;
  cairo_text_cluster_flags_t = _cairo_text_cluster_flags;
  Pcairo_text_cluster_flags_t = ^cairo_text_cluster_flags_t;

  (**
   * cairo_text_extents_t:
   * @x_bearing: the horizontal distance from the origin to the
   *   leftmost part of the glyphs as drawn. Positive if the
   *   glyphs lie entirely to the right of the origin.
   * @y_bearing: the vertical distance from the origin to the
   *   topmost part of the glyphs as drawn. Positive only if the
   *   glyphs lie completely below the origin; will usually be
   *   negative.
   * @width: width of the glyphs as drawn
   * @height: height of the glyphs as drawn
   * @x_advance:distance to advance in the X direction
   *    after drawing these glyphs
   * @y_advance: distance to advance in the Y direction
   *   after drawing these glyphs. Will typically be zero except
   *   for vertical text layout as found in East-Asian languages.
   *
   * The #cairo_text_extents_t structure stores the extents of a single
   * glyph or a string of glyphs in user-space coordinates. Because text
   * extents are in user-space coordinates, they are mostly, but not
   * entirely, independent of the current transformation matrix. If you call
   * <literal>cairo_scale(cr, 2.0, 2.0)</literal>, text will
   * be drawn twice as big, but the reported text extents will not be
   * doubled. They will change slightly due to hinting (so you can't
   * assume that metrics are independent of the transformation matrix),
   * but otherwise will remain unchanged.
   *
   * Since: 1.0
   **)
  cairo_text_extents_t = record
    x_bearing: Double;
    y_bearing: Double;
    width: Double;
    height: Double;
    x_advance: Double;
    y_advance: Double;
  end;

  (**
   * cairo_font_extents_t:
   * @ascent: the distance that the font extends above the baseline.
   *          Note that this is not always exactly equal to the maximum
   *          of the extents of all the glyphs in the font, but rather
   *          is picked to express the font designer's intent as to
   *          how the font should align with elements above it.
   * @descent: the distance that the font extends below the baseline.
   *           This value is positive for typical fonts that include
   *           portions below the baseline. Note that this is not always
   *           exactly equal to the maximum of the extents of all the
   *           glyphs in the font, but rather is picked to express the
   *           font designer's intent as to how the font should
   *           align with elements below it.
   * @height: the recommended vertical distance between baselines when
   *          setting consecutive lines of text with the font. This
   *          is greater than @ascent+@descent by a
   *          quantity known as the <firstterm>line spacing</firstterm>
   *          or <firstterm>external leading</firstterm>. When space
   *          is at a premium, most fonts can be set with only
   *          a distance of @ascent+@descent between lines.
   * @max_x_advance: the maximum distance in the X direction that
   *         the origin is advanced for any glyph in the font.
   * @max_y_advance: the maximum distance in the Y direction that
   *         the origin is advanced for any glyph in the font.
   *         This will be zero for normal fonts used for horizontal
   *         writing. (The scripts of East Asia are sometimes written
   *         vertically.)
   *
   * The #cairo_font_extents_t structure stores metric information for
   * a font. Values are given in the current user-space coordinate
   * system.
   *
   * Because font metrics are in user-space coordinates, they are
   * mostly, but not entirely, independent of the current transformation
   * matrix. If you call <literal>cairo_scale(cr, 2.0, 2.0)</literal>,
   * text will be drawn twice as big, but the reported text extents will
   * not be doubled. They will change slightly due to hinting (so you
   * can't assume that metrics are independent of the transformation
   * matrix), but otherwise will remain unchanged.
   *
   * Since: 1.0
   **)
  cairo_font_extents_t = record
    ascent: Double;
    descent: Double;
    height: Double;
    max_x_advance: Double;
    max_y_advance: Double;
  end;

  (**
   * cairo_font_slant_t:
   * @CAIRO_FONT_SLANT_NORMAL: Upright font style, since 1.0
   * @CAIRO_FONT_SLANT_ITALIC: Italic font style, since 1.0
   * @CAIRO_FONT_SLANT_OBLIQUE: Oblique font style, since 1.0
   *
   * Specifies variants of a font face based on their slant.
   *
   * Since: 1.0
   **)
  _cairo_font_slant = (
    CAIRO_FONT_SLANT_NORMAL = 0,
    CAIRO_FONT_SLANT_ITALIC = 1,
    CAIRO_FONT_SLANT_OBLIQUE = 2);
  P_cairo_font_slant = ^_cairo_font_slant;
  cairo_font_slant_t = _cairo_font_slant;

  (**
   * cairo_font_weight_t:
   * @CAIRO_FONT_WEIGHT_NORMAL: Normal font weight, since 1.0
   * @CAIRO_FONT_WEIGHT_BOLD: Bold font weight, since 1.0
   *
   * Specifies variants of a font face based on their weight.
   *
   * Since: 1.0
   **)
  _cairo_font_weight = (
    CAIRO_FONT_WEIGHT_NORMAL = 0,
    CAIRO_FONT_WEIGHT_BOLD = 1);
  P_cairo_font_weight = ^_cairo_font_weight;
  cairo_font_weight_t = _cairo_font_weight;

  (**
   * cairo_subpixel_order_t:
   * @CAIRO_SUBPIXEL_ORDER_DEFAULT: Use the default subpixel order for
   *   for the target device, since 1.0
   * @CAIRO_SUBPIXEL_ORDER_RGB: Subpixel elements are arranged horizontally
   *   with red at the left, since 1.0
   * @CAIRO_SUBPIXEL_ORDER_BGR:  Subpixel elements are arranged horizontally
   *   with blue at the left, since 1.0
   * @CAIRO_SUBPIXEL_ORDER_VRGB: Subpixel elements are arranged vertically
   *   with red at the top, since 1.0
   * @CAIRO_SUBPIXEL_ORDER_VBGR: Subpixel elements are arranged vertically
   *   with blue at the top, since 1.0
   *
   * The subpixel order specifies the order of color elements within
   * each pixel on the display device when rendering with an
   * antialiasing mode of %CAIRO_ANTIALIAS_SUBPIXEL.
   *
   * Since: 1.0
   **)
  _cairo_subpixel_order = (
    CAIRO_SUBPIXEL_ORDER_DEFAULT = 0,
    CAIRO_SUBPIXEL_ORDER_RGB = 1,
    CAIRO_SUBPIXEL_ORDER_BGR = 2,
    CAIRO_SUBPIXEL_ORDER_VRGB = 3,
    CAIRO_SUBPIXEL_ORDER_VBGR = 4);
  P_cairo_subpixel_order = ^_cairo_subpixel_order;
  cairo_subpixel_order_t = _cairo_subpixel_order;

  (**
   * cairo_hint_style_t:
   * @CAIRO_HINT_STYLE_DEFAULT: Use the default hint style for
   *   font backend and target device, since 1.0
   * @CAIRO_HINT_STYLE_NONE: Do not hint outlines, since 1.0
   * @CAIRO_HINT_STYLE_SLIGHT: Hint outlines slightly to improve
   *   contrast while retaining good fidelity to the original
   *   shapes, since 1.0
   * @CAIRO_HINT_STYLE_MEDIUM: Hint outlines with medium strength
   *   giving a compromise between fidelity to the original shapes
   *   and contrast, since 1.0
   * @CAIRO_HINT_STYLE_FULL: Hint outlines to maximize contrast, since 1.0
   *
   * Specifies the type of hinting to do on font outlines. Hinting
   * is the process of fitting outlines to the pixel grid in order
   * to improve the appearance of the result. Since hinting outlines
   * involves distorting them, it also reduces the faithfulness
   * to the original outline shapes. Not all of the outline hinting
   * styles are supported by all font backends.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.0
   **)
  _cairo_hint_style = (
    CAIRO_HINT_STYLE_DEFAULT = 0,
    CAIRO_HINT_STYLE_NONE = 1,
    CAIRO_HINT_STYLE_SLIGHT = 2,
    CAIRO_HINT_STYLE_MEDIUM = 3,
    CAIRO_HINT_STYLE_FULL = 4);
  P_cairo_hint_style = ^_cairo_hint_style;
  cairo_hint_style_t = _cairo_hint_style;

  (**
   * cairo_hint_metrics_t:
   * @CAIRO_HINT_METRICS_DEFAULT: Hint metrics in the default
   *  manner for the font backend and target device, since 1.0
   * @CAIRO_HINT_METRICS_OFF: Do not hint font metrics, since 1.0
   * @CAIRO_HINT_METRICS_ON: Hint font metrics, since 1.0
   *
   * Specifies whether to hint font metrics; hinting font metrics
   * means quantizing them so that they are integer values in
   * device space. Doing this improves the consistency of
   * letter and line spacing, however it also means that text
   * will be laid out differently at different zoom factors.
   *
   * Since: 1.0
   **)
  _cairo_hint_metrics = (
    CAIRO_HINT_METRICS_DEFAULT = 0,
    CAIRO_HINT_METRICS_OFF = 1,
    CAIRO_HINT_METRICS_ON = 2);
  P_cairo_hint_metrics = ^_cairo_hint_metrics;
  cairo_hint_metrics_t = _cairo_hint_metrics;
  Pcairo_font_options_t = type of Pointer;
  PPcairo_font_options_t = ^Pcairo_font_options_t;

  (**
   * cairo_font_type_t:
   * @CAIRO_FONT_TYPE_TOY: The font was created using cairo's toy font api (Since: 1.2)
   * @CAIRO_FONT_TYPE_FT: The font is of type FreeType (Since: 1.2)
   * @CAIRO_FONT_TYPE_WIN32: The font is of type Win32 (Since: 1.2)
   * @CAIRO_FONT_TYPE_QUARTZ: The font is of type Quartz (Since: 1.6, in 1.2 and
   * 1.4 it was named CAIRO_FONT_TYPE_ATSUI)
   * @CAIRO_FONT_TYPE_USER: The font was create using cairo's user font api (Since: 1.8)
   *
   * #cairo_font_type_t is used to describe the type of a given font
   * face or scaled font. The font types are also known as "font
   * backends" within cairo.
   *
   * The type of a font face is determined by the function used to
   * create it, which will generally be of the form
   * <function>cairo_<emphasis>type</emphasis>_font_face_create(<!-- -->)</function>.
   * The font face type can be queried with cairo_font_face_get_type()
   *
   * The various #cairo_font_face_t functions can be used with a font face
   * of any type.
   *
   * The type of a scaled font is determined by the type of the font
   * face passed to cairo_scaled_font_create(). The scaled font type can
   * be queried with cairo_scaled_font_get_type()
   *
   * The various #cairo_scaled_font_t functions can be used with scaled
   * fonts of any type, but some font backends also provide
   * type-specific functions that must only be called with a scaled font
   * of the appropriate type. These functions have names that begin with
   * <function>cairo_<emphasis>type</emphasis>_scaled_font(<!-- -->)</function>
   * such as cairo_ft_scaled_font_lock_face().
   *
   * The behavior of calling a type-specific function with a scaled font
   * of the wrong type is undefined.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.2
   **)
  _cairo_font_type = (
    CAIRO_FONT_TYPE_TOY = 0,
    CAIRO_FONT_TYPE_FT = 1,
    CAIRO_FONT_TYPE_WIN32 = 2,
    CAIRO_FONT_TYPE_QUARTZ = 3,
    CAIRO_FONT_TYPE_USER = 4);
  P_cairo_font_type = ^_cairo_font_type;
  cairo_font_type_t = _cairo_font_type;

  (**
   * cairo_user_scaled_font_init_func_t:
   * @scaled_font: the scaled-font being created
   * @cr: a cairo context, in font space
   * @extents: font extents to fill in, in font space
   *
   * #cairo_user_scaled_font_init_func_t is the type of function which is
   * called when a scaled-font needs to be created for a user font-face.
   *
   * The cairo context @cr is not used by the caller, but is prepared in font
   * space, similar to what the cairo contexts passed to the render_glyph
   * method will look like.  The callback can use this context for extents
   * computation for example.  After the callback is called, @cr is checked
   * for any error status.
   *
   * The @extents argument is where the user font sets the font extents for
   * @scaled_font.  It is in font space, which means that for most cases its
   * ascent and descent members should add to 1.0.  @extents is preset to
   * hold a value of 1.0 for ascent, height, and max_x_advance, and 0.0 for
   * descent and max_y_advance members.
   *
   * The callback is optional.  If not set, default font extents as described
   * in the previous paragraph will be used.
   *
   * Note that @scaled_font is not fully initialized at this
   * point and trying to use it for text operations in the callback will result
   * in deadlock.
   *
   * Returns: %CAIRO_STATUS_SUCCESS upon success, or an error status on error.
   *
   * Since: 1.8
   **)
  cairo_user_scaled_font_init_func_t = function(scaled_font: Pcairo_scaled_font_t; cr: Pcairo_t; extents: Pcairo_font_extents_t): _cairo_status; cdecl;

  (**
   * cairo_user_scaled_font_render_glyph_func_t:
   * @scaled_font: user scaled-font
   * @glyph: glyph code to render
   * @cr: cairo context to draw to, in font space
   * @extents: glyph extents to fill in, in font space
   *
   * #cairo_user_scaled_font_render_glyph_func_t is the type of function which
   * is called when a user scaled-font needs to render a glyph.
   *
   * The callback is mandatory, and expected to draw the glyph with code @glyph to
   * the cairo context @cr.  @cr is prepared such that the glyph drawing is done in
   * font space.  That is, the matrix set on @cr is the scale matrix of @scaled_font,
   * The @extents argument is where the user font sets the font extents for
   * @scaled_font.  However, if user prefers to draw in user space, they can
   * achieve that by changing the matrix on @cr.  All cairo rendering operations
   * to @cr are permitted, however, the result is undefined if any source other
   * than the default source on @cr is used.  That means, glyph bitmaps should
   * be rendered using cairo_mask() instead of cairo_paint().
   *
   * Other non-default settings on @cr include a font size of 1.0 (given that
   * it is set up to be in font space), and font options corresponding to
   * @scaled_font.
   *
   * The @extents argument is preset to have <literal>x_bearing</literal>,
   * <literal>width</literal>, and <literal>y_advance</literal> of zero,
   * <literal>y_bearing</literal> set to <literal>-font_extents.ascent</literal>,
   * <literal>height</literal> to <literal>font_extents.ascent+font_extents.descent</literal>,
   * and <literal>x_advance</literal> to <literal>font_extents.max_x_advance</literal>.
   * The only field user needs to set in majority of cases is
   * <literal>x_advance</literal>.
   * If the <literal>width</literal> field is zero upon the callback returning
   * (which is its preset value), the glyph extents are automatically computed
   * based on the drawings done to @cr.  This is in most cases exactly what the
   * desired behavior is.  However, if for any reason the callback sets the
   * extents, it must be ink extents, and include the extents of all drawing
   * done to @cr in the callback.
   *
   * Returns: %CAIRO_STATUS_SUCCESS upon success, or
   * %CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
   *
   * Since: 1.8
   **)
  cairo_user_scaled_font_render_glyph_func_t = function(scaled_font: Pcairo_scaled_font_t; glyph: Cardinal; cr: Pcairo_t; extents: Pcairo_text_extents_t): _cairo_status; cdecl;

  (**
   * cairo_user_scaled_font_text_to_glyphs_func_t:
   * @scaled_font: the scaled-font being created
   * @utf8: a string of text encoded in UTF-8
   * @utf8_len: length of @utf8 in bytes
   * @glyphs: pointer to array of glyphs to fill, in font space
   * @num_glyphs: pointer to number of glyphs
   * @clusters: pointer to array of cluster mapping information to fill, or %NULL
   * @num_clusters: pointer to number of clusters
   * @cluster_flags: pointer to location to store cluster flags corresponding to the
   *                 output @clusters
   *
   * #cairo_user_scaled_font_text_to_glyphs_func_t is the type of function which
   * is called to convert input text to an array of glyphs.  This is used by the
   * cairo_show_text() operation.
   *
   * Using this callback the user-font has full control on glyphs and their
   * positions.  That means, it allows for features like ligatures and kerning,
   * as well as complex <firstterm>shaping</firstterm> required for scripts like
   * Arabic and Indic.
   *
   * The @num_glyphs argument is preset to the number of glyph entries available
   * in the @glyphs buffer. If the @glyphs buffer is %NULL, the value of
   * @num_glyphs will be zero.  If the provided glyph array is too short for
   * the conversion (or for convenience), a new glyph array may be allocated
   * using cairo_glyph_allocate() and placed in @glyphs.  Upon return,
   * @num_glyphs should contain the number of generated glyphs.  If the value
   * @glyphs points at has changed after the call, the caller will free the
   * allocated glyph array using cairo_glyph_free().  The caller will also free
   * the original value of @glyphs, so the callback shouldn't do so.
   * The callback should populate the glyph indices and positions (in font space)
   * assuming that the text is to be shown at the origin.
   *
   * If @clusters is not %NULL, @num_clusters and @cluster_flags are also
   * non-%NULL, and cluster mapping should be computed. The semantics of how
   * cluster array allocation works is similar to the glyph array.  That is,
   * if @clusters initially points to a non-%NULL value, that array may be used
   * as a cluster buffer, and @num_clusters points to the number of cluster
   * entries available there.  If the provided cluster array is too short for
   * the conversion (or for convenience), a new cluster array may be allocated
   * using cairo_text_cluster_allocate() and placed in @clusters.  In this case,
   * the original value of @clusters will still be freed by the caller.  Upon
   * return, @num_clusters should contain the number of generated clusters.
   * If the value @clusters points at has changed after the call, the caller
   * will free the allocated cluster array using cairo_text_cluster_free().
   *
   * The callback is optional.  If @num_glyphs is negative upon
   * the callback returning or if the return value
   * is %CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED, the unicode_to_glyph callback
   * is tried.  See #cairo_user_scaled_font_unicode_to_glyph_func_t.
   *
   * Note: While cairo does not impose any limitation on glyph indices,
   * some applications may assume that a glyph index fits in a 16-bit
   * unsigned integer.  As such, it is advised that user-fonts keep their
   * glyphs in the 0 to 65535 range.  Furthermore, some applications may
   * assume that glyph 0 is a special glyph-not-found glyph.  User-fonts
   * are advised to use glyph 0 for such purposes and do not use that
   * glyph value for other purposes.
   *
   * Returns: %CAIRO_STATUS_SUCCESS upon success,
   * %CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED if fallback options should be tried,
   * or %CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
   *
   * Since: 1.8
   **)
  cairo_user_scaled_font_text_to_glyphs_func_t = function(scaled_font: Pcairo_scaled_font_t; utf8: PUTF8Char; utf8_len: Integer; glyphs: PPcairo_glyph_t; num_glyphs: PInteger; clusters: PPcairo_text_cluster_t; num_clusters: PInteger; cluster_flags: Pcairo_text_cluster_flags_t): _cairo_status; cdecl;

  (**
   * cairo_user_scaled_font_unicode_to_glyph_func_t:
   * @scaled_font: the scaled-font being created
   * @unicode: input unicode character code-point
   * @glyph_index: output glyph index
   *
   * #cairo_user_scaled_font_unicode_to_glyph_func_t is the type of function which
   * is called to convert an input Unicode character to a single glyph.
   * This is used by the cairo_show_text() operation.
   *
   * This callback is used to provide the same functionality as the
   * text_to_glyphs callback does (see #cairo_user_scaled_font_text_to_glyphs_func_t)
   * but has much less control on the output,
   * in exchange for increased ease of use.  The inherent assumption to using
   * this callback is that each character maps to one glyph, and that the
   * mapping is context independent.  It also assumes that glyphs are positioned
   * according to their advance width.  These mean no ligatures, kerning, or
   * complex scripts can be implemented using this callback.
   *
   * The callback is optional, and only used if text_to_glyphs callback is not
   * set or fails to return glyphs.  If this callback is not set or if it returns
   * %CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED, an identity mapping from Unicode
   * code-points to glyph indices is assumed.
   *
   * Note: While cairo does not impose any limitation on glyph indices,
   * some applications may assume that a glyph index fits in a 16-bit
   * unsigned integer.  As such, it is advised that user-fonts keep their
   * glyphs in the 0 to 65535 range.  Furthermore, some applications may
   * assume that glyph 0 is a special glyph-not-found glyph.  User-fonts
   * are advised to use glyph 0 for such purposes and do not use that
   * glyph value for other purposes.
   *
   * Returns: %CAIRO_STATUS_SUCCESS upon success,
   * %CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED if fallback options should be tried,
   * or %CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
   *
   * Since: 1.8
   **)
  cairo_user_scaled_font_unicode_to_glyph_func_t = function(scaled_font: Pcairo_scaled_font_t; unicode: Cardinal; glyph_index: PCardinal): _cairo_status; cdecl;

  (**
   * cairo_path_data_type_t:
   * @CAIRO_PATH_MOVE_TO: A move-to operation, since 1.0
   * @CAIRO_PATH_LINE_TO: A line-to operation, since 1.0
   * @CAIRO_PATH_CURVE_TO: A curve-to operation, since 1.0
   * @CAIRO_PATH_CLOSE_PATH: A close-path operation, since 1.0
   *
   * #cairo_path_data_t is used to describe the type of one portion
   * of a path when represented as a #cairo_path_t.
   * See #cairo_path_data_t for details.
   *
   * Since: 1.0
   **)
  _cairo_path_data_type = (
    CAIRO_PATH_MOVE_TO = 0,
    CAIRO_PATH_LINE_TO = 1,
    CAIRO_PATH_CURVE_TO = 2,
    CAIRO_PATH_CLOSE_PATH = 3);
  P_cairo_path_data_type = ^_cairo_path_data_type;
  cairo_path_data_type_t = _cairo_path_data_type;
  (**
   * cairo_path_data_t:
   *
   * #cairo_path_data_t is used to represent the path data inside a
   * #cairo_path_t.
   *
   * The data structure is designed to try to balance the demands of
   * efficiency and ease-of-use. A path is represented as an array of
   * #cairo_path_data_t, which is a union of headers and points.
   *
   * Each portion of the path is represented by one or more elements in
   * the array, (one header followed by 0 or more points). The length
   * value of the header is the number of array elements for the current
   * portion including the header, (ie. length == 1 + # of points), and
   * where the number of points for each element type is as follows:
   *
   * <programlisting>
   *     %CAIRO_PATH_MOVE_TO:     1 point
   *     %CAIRO_PATH_LINE_TO:     1 point
   *     %CAIRO_PATH_CURVE_TO:    3 points
   *     %CAIRO_PATH_CLOSE_PATH:  0 points
   * </programlisting>
   *
   * The semantics and ordering of the coordinate values are consistent
   * with cairo_move_to(), cairo_line_to(), cairo_curve_to(), and
   * cairo_close_path().
   *
   * Here is sample code for iterating through a #cairo_path_t:
   *
   * <informalexample><programlisting>
   *      int i;
   *      cairo_path_t *path;
   *      cairo_path_data_t *data;
   * &nbsp;
   *      path = cairo_copy_path (cr);
   * &nbsp;
   *      for (i=0; i < path->num_data; i += path->data[i].header.length) {
   *          data = &amp;path->data[i];
   *          switch (data->header.type) {
   *          case CAIRO_PATH_MOVE_TO:
   *              do_move_to_things (data[1].point.x, data[1].point.y);
   *              break;
   *          case CAIRO_PATH_LINE_TO:
   *              do_line_to_things (data[1].point.x, data[1].point.y);
   *              break;
   *          case CAIRO_PATH_CURVE_TO:
   *              do_curve_to_things (data[1].point.x, data[1].point.y,
   *                                  data[2].point.x, data[2].point.y,
   *                                  data[3].point.x, data[3].point.y);
   *              break;
   *          case CAIRO_PATH_CLOSE_PATH:
   *              do_close_path_things ();
   *              break;
   *          }
   *      }
   *      cairo_path_destroy (path);
   * </programlisting></informalexample>
   *
   * As of cairo 1.4, cairo does not mind if there are more elements in
   * a portion of the path than needed.  Such elements can be used by
   * users of the cairo API to hold extra values in the path data
   * structure.  For this reason, it is recommended that applications
   * always use <literal>data->header.length</literal> to
   * iterate over the path data, instead of hardcoding the number of
   * elements for each element type.
   *
   * Since: 1.0
   **)

  _anonymous_type_1 = record
    &type: cairo_path_data_type_t;
    length: Integer;
  end;
  P_anonymous_type_1 = ^_anonymous_type_1;

  _anonymous_type_2 = record
    x: Double;
    y: Double;
  end;
  P_anonymous_type_2 = ^_anonymous_type_2;

  _cairo_path_data_t = record
    case Integer of
      0: (header: _anonymous_type_1);
      1: (point: _anonymous_type_2);
  end;

   cairo_path_data_t = _cairo_path_data_t;
  Pcairo_path_data_t = ^cairo_path_data_t;


  (**
   * cairo_path_t:
   * @status: the current error status
   * @data: the elements in the path
   * @num_data: the number of elements in the data array
   *
   * A data structure for holding a path. This data structure serves as
   * the return value for cairo_copy_path() and
   * cairo_copy_path_flat() as well the input value for
   * cairo_append_path().
   *
   * See #cairo_path_data_t for hints on how to iterate over the
   * actual data within the path.
   *
   * The num_data member gives the number of elements in the data
   * array. This number is larger than the number of independent path
   * portions (defined in #cairo_path_data_type_t), since the data
   * includes both headers and coordinates for each portion.
   *
   * Since: 1.0
   **)
  cairo_path = record
    status: cairo_status_t;
    data: Pcairo_path_data_t;
    num_data: Integer;
  end;

  cairo_path_t = cairo_path;
  Pcairo_path_t = ^cairo_path_t;

  (**
   * cairo_device_type_t:
   * @CAIRO_DEVICE_TYPE_DRM: The device is of type Direct Render Manager, since 1.10
   * @CAIRO_DEVICE_TYPE_GL: The device is of type OpenGL, since 1.10
   * @CAIRO_DEVICE_TYPE_SCRIPT: The device is of type script, since 1.10
   * @CAIRO_DEVICE_TYPE_XCB: The device is of type xcb, since 1.10
   * @CAIRO_DEVICE_TYPE_XLIB: The device is of type xlib, since 1.10
   * @CAIRO_DEVICE_TYPE_XML: The device is of type XML, since 1.10
   * @CAIRO_DEVICE_TYPE_COGL: The device is of type cogl, since 1.12
   * @CAIRO_DEVICE_TYPE_WIN32: The device is of type win32, since 1.12
   * @CAIRO_DEVICE_TYPE_INVALID: The device is invalid, since 1.10
   *
   * #cairo_device_type_t is used to describe the type of a given
   * device. The devices types are also known as "backends" within cairo.
   *
   * The device type can be queried with cairo_device_get_type()
   *
   * The various #cairo_device_t functions can be used with devices of
   * any type, but some backends also provide type-specific functions
   * that must only be called with a device of the appropriate
   * type. These functions have names that begin with
   * <literal>cairo_<emphasis>type</emphasis>_device</literal> such as
   * cairo_xcb_device_debug_cap_xrender_version().
   *
   * The behavior of calling a type-specific function with a device of
   * the wrong type is undefined.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.10
   **)
  _cairo_device_type = (
    CAIRO_DEVICE_TYPE_DRM = 0,
    CAIRO_DEVICE_TYPE_GL = 1,
    CAIRO_DEVICE_TYPE_SCRIPT = 2,
    CAIRO_DEVICE_TYPE_XCB = 3,
    CAIRO_DEVICE_TYPE_XLIB = 4,
    CAIRO_DEVICE_TYPE_XML = 5,
    CAIRO_DEVICE_TYPE_COGL = 6,
    CAIRO_DEVICE_TYPE_WIN32 = 7,
    CAIRO_DEVICE_TYPE_INVALID = -1);
  P_cairo_device_type = ^_cairo_device_type;
  cairo_device_type_t = _cairo_device_type;

  (**
   * cairo_surface_observer_mode_t:
   * @CAIRO_SURFACE_OBSERVER_NORMAL: no recording is done
   * @CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS: operations are recorded
   *
   * Whether operations should be recorded.
   *
   * Since: 1.12
   **)
  cairo_surface_observer_mode_t = (
    CAIRO_SURFACE_OBSERVER_NORMAL = 0,
    CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS = 1);
  Pcairo_surface_observer_mode_t = ^cairo_surface_observer_mode_t;

  cairo_surface_observer_callback_t = procedure(observer: Pcairo_surface_t; target: Pcairo_surface_t; data: Pointer); cdecl;

  (**
   * cairo_surface_type_t:
   * @CAIRO_SURFACE_TYPE_IMAGE: The surface is of type image, since 1.2
   * @CAIRO_SURFACE_TYPE_PDF: The surface is of type pdf, since 1.2
   * @CAIRO_SURFACE_TYPE_PS: The surface is of type ps, since 1.2
   * @CAIRO_SURFACE_TYPE_XLIB: The surface is of type xlib, since 1.2
   * @CAIRO_SURFACE_TYPE_XCB: The surface is of type xcb, since 1.2
   * @CAIRO_SURFACE_TYPE_GLITZ: The surface is of type glitz, since 1.2
   * @CAIRO_SURFACE_TYPE_QUARTZ: The surface is of type quartz, since 1.2
   * @CAIRO_SURFACE_TYPE_WIN32: The surface is of type win32, since 1.2
   * @CAIRO_SURFACE_TYPE_BEOS: The surface is of type beos, since 1.2
   * @CAIRO_SURFACE_TYPE_DIRECTFB: The surface is of type directfb, since 1.2
   * @CAIRO_SURFACE_TYPE_SVG: The surface is of type svg, since 1.2
   * @CAIRO_SURFACE_TYPE_OS2: The surface is of type os2, since 1.4
   * @CAIRO_SURFACE_TYPE_WIN32_PRINTING: The surface is a win32 printing surface, since 1.6
   * @CAIRO_SURFACE_TYPE_QUARTZ_IMAGE: The surface is of type quartz_image, since 1.6
   * @CAIRO_SURFACE_TYPE_SCRIPT: The surface is of type script, since 1.10
   * @CAIRO_SURFACE_TYPE_QT: The surface is of type Qt, since 1.10
   * @CAIRO_SURFACE_TYPE_RECORDING: The surface is of type recording, since 1.10
   * @CAIRO_SURFACE_TYPE_VG: The surface is a OpenVG surface, since 1.10
   * @CAIRO_SURFACE_TYPE_GL: The surface is of type OpenGL, since 1.10
   * @CAIRO_SURFACE_TYPE_DRM: The surface is of type Direct Render Manager, since 1.10
   * @CAIRO_SURFACE_TYPE_TEE: The surface is of type 'tee' (a multiplexing surface), since 1.10
   * @CAIRO_SURFACE_TYPE_XML: The surface is of type XML (for debugging), since 1.10
   * @CAIRO_SURFACE_TYPE_SKIA: The surface is of type Skia, since 1.10
   * @CAIRO_SURFACE_TYPE_SUBSURFACE: The surface is a subsurface created with
   *   cairo_surface_create_for_rectangle(), since 1.10
   * @CAIRO_SURFACE_TYPE_COGL: This surface is of type Cogl, since 1.12
   *
   * #cairo_surface_type_t is used to describe the type of a given
   * surface. The surface types are also known as "backends" or "surface
   * backends" within cairo.
   *
   * The type of a surface is determined by the function used to create
   * it, which will generally be of the form
   * <function>cairo_<emphasis>type</emphasis>_surface_create(<!-- -->)</function>,
   * (though see cairo_surface_create_similar() as well).
   *
   * The surface type can be queried with cairo_surface_get_type()
   *
   * The various #cairo_surface_t functions can be used with surfaces of
   * any type, but some backends also provide type-specific functions
   * that must only be called with a surface of the appropriate
   * type. These functions have names that begin with
   * <literal>cairo_<emphasis>type</emphasis>_surface</literal> such as cairo_image_surface_get_width().
   *
   * The behavior of calling a type-specific function with a surface of
   * the wrong type is undefined.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.2
   **)
  _cairo_surface_type = (
    CAIRO_SURFACE_TYPE_IMAGE = 0,
    CAIRO_SURFACE_TYPE_PDF = 1,
    CAIRO_SURFACE_TYPE_PS = 2,
    CAIRO_SURFACE_TYPE_XLIB = 3,
    CAIRO_SURFACE_TYPE_XCB = 4,
    CAIRO_SURFACE_TYPE_GLITZ = 5,
    CAIRO_SURFACE_TYPE_QUARTZ = 6,
    CAIRO_SURFACE_TYPE_WIN32 = 7,
    CAIRO_SURFACE_TYPE_BEOS = 8,
    CAIRO_SURFACE_TYPE_DIRECTFB = 9,
    CAIRO_SURFACE_TYPE_SVG = 10,
    CAIRO_SURFACE_TYPE_OS2 = 11,
    CAIRO_SURFACE_TYPE_WIN32_PRINTING = 12,
    CAIRO_SURFACE_TYPE_QUARTZ_IMAGE = 13,
    CAIRO_SURFACE_TYPE_SCRIPT = 14,
    CAIRO_SURFACE_TYPE_QT = 15,
    CAIRO_SURFACE_TYPE_RECORDING = 16,
    CAIRO_SURFACE_TYPE_VG = 17,
    CAIRO_SURFACE_TYPE_GL = 18,
    CAIRO_SURFACE_TYPE_DRM = 19,
    CAIRO_SURFACE_TYPE_TEE = 20,
    CAIRO_SURFACE_TYPE_XML = 21,
    CAIRO_SURFACE_TYPE_SKIA = 22,
    CAIRO_SURFACE_TYPE_SUBSURFACE = 23,
    CAIRO_SURFACE_TYPE_COGL = 24);
  P_cairo_surface_type = ^_cairo_surface_type;
  cairo_surface_type_t = _cairo_surface_type;

  (**
   * cairo_raster_source_acquire_func_t:
   * @pattern: the pattern being rendered from
   * @callback_data: the user data supplied during creation
   * @target: the rendering target surface
   * @extents: rectangular region of interest in pixels in sample space
   *
   * #cairo_raster_source_acquire_func_t is the type of function which is
   * called when a pattern is being rendered from. It should create a surface
   * that provides the pixel data for the region of interest as defined by
   * extents, though the surface itself does not have to be limited to that
   * area. For convenience the surface should probably be of image type,
   * created with cairo_surface_create_similar_image() for the target (which
   * enables the number of copies to be reduced during transfer to the
   * device). Another option, might be to return a similar surface to the
   * target for explicit handling by the application of a set of cached sources
   * on the device. The region of sample data provided should be defined using
   * cairo_surface_set_device_offset() to specify the top-left corner of the
   * sample data (along with width and height of the surface).
   *
   * Returns: a #cairo_surface_t
   *
   * Since: 1.12
   **)
  cairo_raster_source_acquire_func_t = function(pattern: Pcairo_pattern_t; callback_data: Pointer; target: Pcairo_surface_t; extents: Pcairo_rectangle_int_t): P_cairo_surface; cdecl;
  Pcairo_raster_source_acquire_func_t = ^cairo_raster_source_acquire_func_t;

  (**
   * cairo_raster_source_release_func_t:
   * @pattern: the pattern being rendered from
   * @callback_data: the user data supplied during creation
   * @surface: the surface created during acquire
   *
   * #cairo_raster_source_release_func_t is the type of function which is
   * called when the pixel data is no longer being access by the pattern
   * for the rendering operation. Typically this function will simply
   * destroy the surface created during acquire.
   *
   * Since: 1.12
   **)
  cairo_raster_source_release_func_t = procedure(pattern: Pcairo_pattern_t; callback_data: Pointer; surface: Pcairo_surface_t); cdecl;
  Pcairo_raster_source_release_func_t = ^cairo_raster_source_release_func_t;

  (**
   * cairo_raster_source_snapshot_func_t:
   * @pattern: the pattern being rendered from
   * @callback_data: the user data supplied during creation
   *
   * #cairo_raster_source_snapshot_func_t is the type of function which is
   * called when the pixel data needs to be preserved for later use
   * during printing. This pattern will be accessed again later, and it
   * is expected to provide the pixel data that was current at the time
   * of snapshotting.
   *
   * Return value: CAIRO_STATUS_SUCCESS on success, or one of the
   * #cairo_status_t error codes for failure.
   *
   * Since: 1.12
   **)
  cairo_raster_source_snapshot_func_t = function(pattern: Pcairo_pattern_t; callback_data: Pointer): _cairo_status; cdecl;

  (**
   * cairo_raster_source_copy_func_t:
   * @pattern: the #cairo_pattern_t that was copied to
   * @callback_data: the user data supplied during creation
   * @other: the #cairo_pattern_t being used as the source for the copy
   *
   * #cairo_raster_source_copy_func_t is the type of function which is
   * called when the pattern gets copied as a normal part of rendering.
   *
   * Return value: CAIRO_STATUS_SUCCESS on success, or one of the
   * #cairo_status_t error codes for failure.
   *
   * Since: 1.12
   **)
  cairo_raster_source_copy_func_t = function(pattern: Pcairo_pattern_t; callback_data: Pointer; other: Pcairo_pattern_t): _cairo_status; cdecl;

  (**
   * cairo_raster_source_finish_func_t:
   * @pattern: the pattern being rendered from
   * @callback_data: the user data supplied during creation
   *
   * #cairo_raster_source_finish_func_t is the type of function which is
   * called when the pattern (or a copy thereof) is no longer required.
   *
   * Since: 1.12
   **)
  cairo_raster_source_finish_func_t = procedure(pattern: Pcairo_pattern_t; callback_data: Pointer); cdecl;

  (**
   * cairo_pattern_type_t:
   * @CAIRO_PATTERN_TYPE_SOLID: The pattern is a solid (uniform)
   * color. It may be opaque or translucent, since 1.2.
   * @CAIRO_PATTERN_TYPE_SURFACE: The pattern is a based on a surface (an image), since 1.2.
   * @CAIRO_PATTERN_TYPE_LINEAR: The pattern is a linear gradient, since 1.2.
   * @CAIRO_PATTERN_TYPE_RADIAL: The pattern is a radial gradient, since 1.2.
   * @CAIRO_PATTERN_TYPE_MESH: The pattern is a mesh, since 1.12.
   * @CAIRO_PATTERN_TYPE_RASTER_SOURCE: The pattern is a user pattern providing raster data, since 1.12.
   *
   * #cairo_pattern_type_t is used to describe the type of a given pattern.
   *
   * The type of a pattern is determined by the function used to create
   * it. The cairo_pattern_create_rgb() and cairo_pattern_create_rgba()
   * functions create SOLID patterns. The remaining
   * cairo_pattern_create<!-- --> functions map to pattern types in obvious
   * ways.
   *
   * The pattern type can be queried with cairo_pattern_get_type()
   *
   * Most #cairo_pattern_t functions can be called with a pattern of any
   * type, (though trying to change the extend or filter for a solid
   * pattern will have no effect). A notable exception is
   * cairo_pattern_add_color_stop_rgb() and
   * cairo_pattern_add_color_stop_rgba() which must only be called with
   * gradient patterns (either LINEAR or RADIAL). Otherwise the pattern
   * will be shutdown and put into an error state.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.2
   **)
  _cairo_pattern_type = (
    CAIRO_PATTERN_TYPE_SOLID = 0,
    CAIRO_PATTERN_TYPE_SURFACE = 1,
    CAIRO_PATTERN_TYPE_LINEAR = 2,
    CAIRO_PATTERN_TYPE_RADIAL = 3,
    CAIRO_PATTERN_TYPE_MESH = 4,
    CAIRO_PATTERN_TYPE_RASTER_SOURCE = 5);
  P_cairo_pattern_type = ^_cairo_pattern_type;
  cairo_pattern_type_t = _cairo_pattern_type;

  (**
   * cairo_extend_t:
   * @CAIRO_EXTEND_NONE: pixels outside of the source pattern
   *   are fully transparent (Since 1.0)
   * @CAIRO_EXTEND_REPEAT: the pattern is tiled by repeating (Since 1.0)
   * @CAIRO_EXTEND_REFLECT: the pattern is tiled by reflecting
   *   at the edges (Since 1.0; but only implemented for surface patterns since 1.6)
   * @CAIRO_EXTEND_PAD: pixels outside of the pattern copy
   *   the closest pixel from the source (Since 1.2; but only
   *   implemented for surface patterns since 1.6)
   *
   * #cairo_extend_t is used to describe how pattern color/alpha will be
   * determined for areas "outside" the pattern's natural area, (for
   * example, outside the surface bounds or outside the gradient
   * geometry).
   *
   * Mesh patterns are not affected by the extend mode.
   *
   * The default extend mode is %CAIRO_EXTEND_NONE for surface patterns
   * and %CAIRO_EXTEND_PAD for gradient patterns.
   *
   * New entries may be added in future versions.
   *
   * Since: 1.0
   **)
  _cairo_extend = (
    CAIRO_EXTEND_NONE = 0,
    CAIRO_EXTEND_REPEAT = 1,
    CAIRO_EXTEND_REFLECT = 2,
    CAIRO_EXTEND_PAD = 3);
  P_cairo_extend = ^_cairo_extend;
  cairo_extend_t = _cairo_extend;

  (**
   * cairo_filter_t:
   * @CAIRO_FILTER_FAST: A high-performance filter, with quality similar
   *     to %CAIRO_FILTER_NEAREST (Since 1.0)
   * @CAIRO_FILTER_GOOD: A reasonable-performance filter, with quality
   *     similar to %CAIRO_FILTER_BILINEAR (Since 1.0)
   * @CAIRO_FILTER_BEST: The highest-quality available, performance may
   *     not be suitable for interactive use. (Since 1.0)
   * @CAIRO_FILTER_NEAREST: Nearest-neighbor filtering (Since 1.0)
   * @CAIRO_FILTER_BILINEAR: Linear interpolation in two dimensions (Since 1.0)
   * @CAIRO_FILTER_GAUSSIAN: This filter value is currently
   *     unimplemented, and should not be used in current code. (Since 1.0)
   *
   * #cairo_filter_t is used to indicate what filtering should be
   * applied when reading pixel values from patterns. See
   * cairo_pattern_set_filter() for indicating the desired filter to be
   * used with a particular pattern.
   *
   * Since: 1.0
   **)
  _cairo_filter = (
    CAIRO_FILTER_FAST = 0,
    CAIRO_FILTER_GOOD = 1,
    CAIRO_FILTER_BEST = 2,
    CAIRO_FILTER_NEAREST = 3,
    CAIRO_FILTER_BILINEAR = 4,
    CAIRO_FILTER_GAUSSIAN = 5);
  P_cairo_filter = ^_cairo_filter;
  cairo_filter_t = _cairo_filter;
  Pcairo_region_t = Pointer;
  PPcairo_region_t = ^Pcairo_region_t;

  (**
   * cairo_region_overlap_t:
   * @CAIRO_REGION_OVERLAP_IN: The contents are entirely inside the region. (Since 1.10)
   * @CAIRO_REGION_OVERLAP_OUT: The contents are entirely outside the region. (Since 1.10)
   * @CAIRO_REGION_OVERLAP_PART: The contents are partially inside and
   *     partially outside the region. (Since 1.10)
   *
   * Used as the return value for cairo_region_contains_rectangle().
   *
   * Since: 1.10
   **)
  _cairo_region_overlap = (
    CAIRO_REGION_OVERLAP_IN = 0,
    CAIRO_REGION_OVERLAP_OUT = 1,
    CAIRO_REGION_OVERLAP_PART = 2);
  P_cairo_region_overlap = ^_cairo_region_overlap;
  cairo_region_overlap_t = _cairo_region_overlap;

  (**
   * cairo_svg_version_t:
   * @CAIRO_SVG_VERSION_1_1: The version 1.1 of the SVG specification. (Since 1.2)
   * @CAIRO_SVG_VERSION_1_2: The version 1.2 of the SVG specification. (Since 1.2)
   *
   * #cairo_svg_version_t is used to describe the version number of the SVG
   * specification that a generated SVG file will conform to.
   *
   * Since: 1.2
   **)
  _cairo_svg_version = (
    CAIRO_SVG_VERSION_1_1 = 0,
    CAIRO_SVG_VERSION_1_2 = 1);
  P_cairo_svg_version = ^_cairo_svg_version;
  cairo_svg_version_t = _cairo_svg_version;
  Pcairo_svg_version_t = ^cairo_svg_version_t;
  PPcairo_svg_version_t = ^Pcairo_svg_version_t;

  (**
   * cairo_svg_version_t:
   *
   * @CAIRO_SVG_UNIT_USER: User unit, a value in the current coordinate system.
   *   If used in the root element for the initial coordinate systems it
   *   corresponds to pixels. (Since 1.16)
   * @CAIRO_SVG_UNIT_EM: The size of the element's font. (Since 1.16)
   * @CAIRO_SVG_UNIT_EX: The x-height of the element’s font. (Since 1.16)
   * @CAIRO_SVG_UNIT_PX: Pixels (1px = 1/96th of 1in). (Since 1.16)
   * @CAIRO_SVG_UNIT_IN: Inches (1in = 2.54cm = 96px). (Since 1.16)
   * @CAIRO_SVG_UNIT_CM: Centimeters (1cm = 96px/2.54). (Since 1.16)
   * @CAIRO_SVG_UNIT_MM: Millimeters (1mm = 1/10th of 1cm). (Since 1.16)
   * @CAIRO_SVG_UNIT_PT: Points (1pt = 1/72th of 1in). (Since 1.16)
   * @CAIRO_SVG_UNIT_PC: Picas (1pc = 1/6th of 1in). (Since 1.16)
   * @CAIRO_SVG_UNIT_PERCENT: Percent, a value that is some fraction of another
   *   reference value. (Since 1.16)
   *
   * #cairo_svg_unit_t is used to describe the units valid for coordinates and
   * lengths in the SVG specification.
   *
   * See also:
   * https://www.w3.org/TR/SVG/coords.html#Units
   * https://www.w3.org/TR/SVG/types.html#DataTypeLength
   * https://www.w3.org/TR/css-values-3/#lengths
   *
   * Since: 1.16
   **)
  _cairo_svg_unit = (
    CAIRO_SVG_UNIT_USER = 0,
    CAIRO_SVG_UNIT_EM = 1,
    CAIRO_SVG_UNIT_EX = 2,
    CAIRO_SVG_UNIT_PX = 3,
    CAIRO_SVG_UNIT_IN = 4,
    CAIRO_SVG_UNIT_CM = 5,
    CAIRO_SVG_UNIT_MM = 6,
    CAIRO_SVG_UNIT_PT = 7,
    CAIRO_SVG_UNIT_PC = 8,
    CAIRO_SVG_UNIT_PERCENT = 9);
  P_cairo_svg_unit = ^_cairo_svg_unit;
  cairo_svg_unit_t = _cairo_svg_unit;

  (**
   * cairo_script_mode_t:
   * @CAIRO_SCRIPT_MODE_ASCII: the output will be in readable text (default). (Since 1.12)
   * @CAIRO_SCRIPT_MODE_BINARY: the output will use byte codes. (Since 1.12)
   *
   * A set of script output variants.
   *
   * Since: 1.12
   **)
  cairo_script_mode_t = (
    CAIRO_SCRIPT_MODE_ASCII = 0,
    CAIRO_SCRIPT_MODE_BINARY = 1);
  Pcairo_script_mode_t = ^cairo_script_mode_t;

  (**
   * cairo_pdf_version_t:
   * @CAIRO_PDF_VERSION_1_4: The version 1.4 of the PDF specification. (Since 1.10)
   * @CAIRO_PDF_VERSION_1_5: The version 1.5 of the PDF specification. (Since 1.10)
   *
   * #cairo_pdf_version_t is used to describe the version number of the PDF
   * specification that a generated PDF file will conform to.
   *
   * Since: 1.10
   **)
  _cairo_pdf_version = (
    CAIRO_PDF_VERSION_1_4 = 0,
    CAIRO_PDF_VERSION_1_5 = 1);
  P_cairo_pdf_version = ^_cairo_pdf_version;
  cairo_pdf_version_t = _cairo_pdf_version;
  Pcairo_pdf_version_t = ^cairo_pdf_version_t;
  PPcairo_pdf_version_t = ^Pcairo_pdf_version_t;

  (**
   * cairo_pdf_outline_flags_t:
   * @CAIRO_PDF_OUTLINE_FLAG_OPEN: The outline item defaults to open in the PDF viewer (Since 1.16)
   * @CAIRO_PDF_OUTLINE_FLAG_BOLD: The outline item is displayed by the viewer in bold text (Since 1.16)
   * @CAIRO_PDF_OUTLINE_FLAG_ITALIC: The outline item is displayed by the viewer in italic text (Since 1.16)
   *
   * #cairo_pdf_outline_flags_t is used by the
   * cairo_pdf_surface_add_outline() function specify the attributes of
   * an outline item. These flags may be bitwise-or'd to produce any
   * combination of flags.
   *
   * Since: 1.16
   **)
  _cairo_pdf_outline_flags = (
    CAIRO_PDF_OUTLINE_FLAG_OPEN = 1,
    CAIRO_PDF_OUTLINE_FLAG_BOLD = 2,
    CAIRO_PDF_OUTLINE_FLAG_ITALIC = 4);
  P_cairo_pdf_outline_flags = ^_cairo_pdf_outline_flags;
  cairo_pdf_outline_flags_t = _cairo_pdf_outline_flags;

  (**
   * cairo_pdf_metadata_t:
   * @CAIRO_PDF_METADATA_TITLE: The document title (Since 1.16)
   * @CAIRO_PDF_METADATA_AUTHOR: The document author (Since 1.16)
   * @CAIRO_PDF_METADATA_SUBJECT: The document subject (Since 1.16)
   * @CAIRO_PDF_METADATA_KEYWORDS: The document keywords (Since 1.16)
   * @CAIRO_PDF_METADATA_CREATOR: The document creator (Since 1.16)
   * @CAIRO_PDF_METADATA_CREATE_DATE: The document creation date (Since 1.16)
   * @CAIRO_PDF_METADATA_MOD_DATE: The document modification date (Since 1.16)
   *
   * #cairo_pdf_metadata_t is used by the
   * cairo_pdf_surface_set_metadata() function specify the metadata to set.
   *
   * Since: 1.16
   **)
  _cairo_pdf_metadata = (
    CAIRO_PDF_METADATA_TITLE = 0,
    CAIRO_PDF_METADATA_AUTHOR = 1,
    CAIRO_PDF_METADATA_SUBJECT = 2,
    CAIRO_PDF_METADATA_KEYWORDS = 3,
    CAIRO_PDF_METADATA_CREATOR = 4,
    CAIRO_PDF_METADATA_CREATE_DATE = 5,
    CAIRO_PDF_METADATA_MOD_DATE = 6);
  P_cairo_pdf_metadata = ^_cairo_pdf_metadata;
  cairo_pdf_metadata_t = _cairo_pdf_metadata;






  (**
   * cairo_ft_synthesize_t:
   * @CAIRO_FT_SYNTHESIZE_BOLD: Embolden the glyphs (redraw with a pixel offset)
   * @CAIRO_FT_SYNTHESIZE_OBLIQUE: Slant the glyph outline by 12 degrees to the
   * right.
   *
   * A set of synthesis options to control how FreeType renders the glyphs
   * for a particular font face.
   *
   * Individual synthesis features of a #cairo_ft_font_face_t can be set
   * using cairo_ft_font_face_set_synthesize(), or disabled using
   * cairo_ft_font_face_unset_synthesize(). The currently enabled set of
   * synthesis options can be queried with cairo_ft_font_face_get_synthesize().
   *
   * Note: that when synthesizing glyphs, the font metrics returned will only
   * be estimates.
   *
   * Since: 1.12
   **)
  cairo_ft_synthesize_t = (
    CAIRO_FT_SYNTHESIZE_BOLD = 1,
    CAIRO_FT_SYNTHESIZE_OBLIQUE = 2);
  Pcairo_ft_synthesize_t = ^cairo_ft_synthesize_t;

  (**
   * cairo_ps_level_t:
   * @CAIRO_PS_LEVEL_2: The language level 2 of the PostScript specification. (Since 1.6)
   * @CAIRO_PS_LEVEL_3: The language level 3 of the PostScript specification. (Since 1.6)
   *
   * #cairo_ps_level_t is used to describe the language level of the
   * PostScript Language Reference that a generated PostScript file will
   * conform to.
   *
   * Since: 1.6
   **)
  _cairo_ps_level = (
    CAIRO_PS_LEVEL_2 = 0,
    CAIRO_PS_LEVEL_3 = 1);
  P_cairo_ps_level = ^_cairo_ps_level;
  cairo_ps_level_t = _cairo_ps_level;
  Pcairo_ps_level_t = ^cairo_ps_level_t;
  PPcairo_ps_level_t = ^Pcairo_ps_level_t;


implementation

end.
