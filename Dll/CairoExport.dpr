library CairoExport;



uses
  System.SysUtils,
  System.Classes,
  WinApi.Windows,
  Cairo.EmfToCairo in 'Cairo.EmfToCairo.pas',
  Cairo.Types in '..\src\Cairo.Types.pas',
  Cairo.Interfaces in '..\src\Cairo.Interfaces.pas',
  Cairo.Emf in '..\src\Cairo.Emf.pas',
  Cairo.Emf.Worker in '..\src\Cairo.Emf.Worker.pas',
  Cairo.Factory in '..\src\Cairo.Factory.pas',
  Cairo.Base in '..\src\Cairo.Base.pas',
  Cairo.Dll in '..\src\Cairo.Dll.pas',
  Cairo.Freetype in '..\src\Cairo.Freetype.pas',
  Cairo.Context in '..\src\Cairo.Context.pas',
  Cairo.Font in '..\src\Cairo.Font.pas',
  Cairo.Pattern in '..\src\Cairo.Pattern.pas',
  Cairo.Pattern.Surfaces in '..\src\Cairo.Pattern.Surfaces.pas',
  Cairo.Surface in '..\src\Cairo.Surface.pas',
  Cairo.Surface.Speciale in '..\src\Cairo.Surface.Speciale.pas',
  Cairo.Stream in '..\src\Cairo.Stream.pas',
  Cairo.Emf.Implementations in '..\src\Cairo.Emf.Implementations.pas',
  Cairo.ExportIntf in 'Cairo.ExportIntf.pas',
  Cairo.ExportImpl in 'Cairo.ExportImpl.pas';

function CreateCairoFromEmf(Emf: HENHMETAFILE; var cairo : Pcairo_surface_t) : boolean; cdecl;
Var ltemp : TEmfToCairoClass;
begin
 ltemp := TEmfToCairoClass.Create;
 try
   result := ltemp.CreateCairo(emf, Cairo);
 finally
   ltemp.Free;
 end;
end;

 function CairoExporter : ICairoExporter;  stdcall;
  begin
   result := TCairoExporter.Create;
  end;

exports
   CreateCairoFromEmf,
   CairoExporter;


begin
end.
