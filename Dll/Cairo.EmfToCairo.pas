unit Cairo.EmfToCairo;

interface

uses
  System.Sysutils,
  Winapi.Windows,
  Vcl.Graphics,
  Cairo.Types;

type
  TEmfToCairoClass = class
  public
    function CreateCairo(Emf: HENHMETAFILE; var Cairo: Pcairo_surface_t): boolean;
  end;

implementation

uses
  Cairo.Interfaces,
  Cairo.Emf,
  Cairo.Emf.implementations,
  Cairo.Emf.Worker;

{ TEmfToCairoClass }

function TEmfToCairoClass.CreateCairo(Emf: HENHMETAFILE; var Cairo: Pcairo_surface_t): boolean;
var
  lemf: IEmfEnum;
  R: TRect;
  mf: TMetafile;
  p: Pointer;

  lRecoding: iCairoRecordingSurface;
  lContext: ICairoContext;
  lMetaSurface: iCairoSurface;
  lRect: cairo_rectangle_t;

begin
  result := false;
  lMetaSurface := CairoFactory.CreateRecording(nil);
  lContext := CairoFactory.CreateContext(lMetaSurface);
  mf := TMetafile.Create;
  try
    mf.Handle := Emf;

    R.Left := 0;
    R.Top := 0;
    R.Right := mf.width;
    R.Bottom := mf.height;

    lemf := TEmfEnum.Create(lContext);
    p := Pointer(lemf);
    EnumEnhMetaFile(getDc(0), mf.Handle, @EnumEmfCairoFunc, p, R);

    if supports(lMetaSurface, iCairoRecordingSurface, lRecoding) then
      begin
        lRecoding.ink_extents(lRect.x, lRect.y, lRect.width, lRect.height);

        if (lRect.width > 1) and (lRect.height > 1) then
          begin
            result := true;
            Cairo := lMetaSurface.Reference;
          end;
      end;
  finally
    mf.ReleaseHandle;
    mf.Free;
  end;
end;

end.
