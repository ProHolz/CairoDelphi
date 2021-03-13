program testCairo;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {Form16},
  Cairo.Dll in '..\src\Cairo.Dll.pas',
  Cairo.Stream in '..\src\Cairo.Stream.pas',
  Cairo.Context in '..\src\Cairo.Context.pas',
  Cairo.Font in '..\src\Cairo.Font.pas',
  Cairo.Surface.Speciale in '..\src\Cairo.Surface.Speciale.pas',
  Cairo.Surface in '..\src\Cairo.Surface.pas',
  Cairo.Base in '..\src\Cairo.Base.pas',
  Cairo.Types in '..\src\Cairo.Types.pas',
  Cairo.Pattern in '..\src\Cairo.Pattern.pas',
  Cairo.Pattern.Surfaces in '..\src\Cairo.Pattern.Surfaces.pas',
  Cairo.Bitmap in '..\src\Cairo.Bitmap.pas',
  Cairo.NotImplemented in '..\src\Cairo.NotImplemented.pas',
  Cairo.Canvas in '..\src\Cairo.Canvas.pas',
  Cairo.Freetype in '..\src\Cairo.Freetype.pas',
  Cairo.Interfaces in '..\src\Cairo.Interfaces.pas',
  Cairo.Factory in '..\src\Cairo.Factory.pas',
  Cairo.Emf in '..\src\Cairo.Emf.pas',
  Cairo.Emf.Worker in '..\src\Cairo.Emf.Worker.pas',
  Cairo.Emf.Implementations in '..\src\Cairo.Emf.Implementations.pas',
  testclass in 'testclass.pas',
  Cairo.EmfToCairo in '..\Dll\Cairo.EmfToCairo.pas',
  Cairo.ExportIntf in '..\Dll\Cairo.ExportIntf.pas',
  Cairo.ExportImpl in '..\Dll\Cairo.ExportImpl.pas',
  testExport in 'testExport.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm16, Form16);
  Application.Run;
end.
