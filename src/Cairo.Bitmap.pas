unit Cairo.Bitmap;

interface

uses
   Cairo.Types;

type
   TCairoAlphaHelper = class
   private
      fsurface: Pcairo_surface_t;
      procedure internalUpdateAlpha(Value: Double);

   protected
      constructor Create(aSurface: Pcairo_surface_t);

   public

      class procedure UpdateAlpha(aSurface: Pcairo_surface_t; Value: Double);

   end;

implementation

uses
   Cairo.dll;

type
   colorAgrb = packed record
      r, g, b, a: byte;
   end;

   pcolorAgrb = ^colorAgrb;

{ TCairoAlphaHelper }

constructor TCairoAlphaHelper.Create(aSurface: Pcairo_surface_t);
begin
   inherited Create;
   fsurface := aSurface;
end;

procedure TCairoAlphaHelper.internalUpdateAlpha(Value: Double);
var
   lw, lh, ls: Integer;
   lFormat: cairo_format_t;
   // pp : pointer;
   pa: pcolorAgrb;
   row, col: Integer;
   newAlpha: byte;
begin
   lw := cairo_image_surface_get_width(fsurface);
   lh := cairo_image_surface_get_height(fsurface);
   ls := cairo_image_surface_get_stride(fsurface);
   lFormat := cairo_image_surface_get_format(fsurface);
   if lFormat = CAIRO_FORMAT_ARGB32 then
      begin
         newAlpha := round(Value * 255);
         if (ls mod lw) = 0 then
            begin
               cairo_surface_flush(fsurface);
               pointer(pa) := cairo_image_surface_get_data(fsurface);
               for row := 0 to lh - 1 do
                  for col := 0 to lw - 1 do
                     begin
                        pa.a := newAlpha;
                        inc(pa);
                     end;
               cairo_surface_mark_dirty(fsurface);
            end;
      end;
end;

class procedure TCairoAlphaHelper.UpdateAlpha(aSurface: Pcairo_surface_t; Value: Double);
var
   ltemp: TCairoAlphaHelper;
begin
   ltemp := TCairoAlphaHelper.Create(aSurface);
   try
      ltemp.internalUpdateAlpha(Value);
   finally
      ltemp.Free;
   end;

end;

end.
