unit Cairo.Surface.Speciale;

interface

{$IFDEF TEST2}

uses
   Cairo.Dll;

type
   TRasterPattern = class
   public
      // cairo_raster_source_pattern_

      procedure cairo_raster_source_pattern_set_callback_data(pattern: Pcairo_pattern_t; data: Pointer);
      function cairo_raster_source_pattern_get_callback_data(pattern: Pcairo_pattern_t): Pointer;
      procedure cairo_raster_source_pattern_set_acquire(pattern: Pcairo_pattern_t; acquire: cairo_raster_source_acquire_func_t;
       release: cairo_raster_source_release_func_t);
      procedure cairo_raster_source_pattern_get_acquire(pattern: Pcairo_pattern_t; acquire: Pcairo_raster_source_acquire_func_t;
       release: Pcairo_raster_source_release_func_t);
      procedure cairo_raster_source_pattern_set_snapshot(pattern: Pcairo_pattern_t; snapshot: cairo_raster_source_snapshot_func_t);
      function cairo_raster_source_pattern_get_snapshot(pattern: Pcairo_pattern_t): cairo_raster_source_snapshot_func_t;
      procedure cairo_raster_source_pattern_set_copy(pattern: Pcairo_pattern_t; copy: cairo_raster_source_copy_func_t);
      function cairo_raster_source_pattern_get_copy(pattern: Pcairo_pattern_t): cairo_raster_source_copy_func_t;
      procedure cairo_raster_source_pattern_set_finish(pattern: Pcairo_pattern_t; finish: cairo_raster_source_finish_func_t);

   end;






   {$ENDIF}

implementation

end.
