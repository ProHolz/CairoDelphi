unit testExport;

interface

Procedure Dopdf;
Procedure DoSvgAll;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Vcl.Graphics,
  Cairo.ExportIntf,
  Cairo.ExportImpl;

Procedure Dopdf;
var
  PageNo: Integer;
  Cairo: ICairoExporter;
  Pdf: ICairoPDF;
  meta: TMetafile;
  lPath : String;
begin
  Pdf := nil;
  Cairo := CairoExporter;
  if Cairo <> nil then
  begin
    lPath := TPath.GetLibraryPath;
    Pdf := Cairo.GetCairoPDF;
    // Create a4
    Pdf.CreatePDF(TPath.Combine(lPath,'Test.pdf'), 595, 842);
    Pdf.CreationDate := Now;
    Pdf.Creator := 'Creator';
    Pdf.Author := 'Author';
    Pdf.Subject := 'Subject';
    Pdf.Title := 'Title';

    try
      meta := TMetafile.Create;
      try
        meta.LoadFromFile(TPath.Combine(lPath,'EMF1.emf'));
        Pdf.AddPage;
        Pdf.RenderMetaFile(meta.Handle);

        meta.LoadFromFile(TPath.Combine(lPath,'EMF2.emf'));
        Pdf.AddPage;
        Pdf.RenderMetaFile(meta.Handle);

        meta.LoadFromFile(TPath.Combine(lPath,'EMF3.emf'));
        Pdf.AddPage;
        Pdf.RenderMetaFile(meta.Handle);
        Pdf.AddPage;

      finally
        meta.Free;
      end;
    finally
      Pdf := nil;
      Cairo := nil;
    end;
  end;
end;

Procedure DoSvg(const value: Integer);
var
  PageNo: Integer;
  Cairo: ICairoExporter;
  SVG: ICairoSVG;
  meta: TMetafile;
  Lpath : String;
begin
  Cairo := CairoExporter;
  if Cairo <> nil then
  begin
    lPath := TPath.GetLibraryPath;
    SVG := Cairo.GetCairoSVG;
    SVG.CreateSVG(TPath.Combine(lPath,'Test' + value.toString + '.svg'), 595, 842);
    try
      meta := TMetafile.Create;
      try
        meta.LoadFromFile(TPath.Combine(lPath,'EMF' + value.toString + '.emf'));
        SVG.RenderMetaFile(meta.Handle);
      finally
        meta.Free;
      end;
    finally
      SVG := nil;
      Cairo := nil;
    end;
  end;
end;

Procedure DoSvgAll;
begin
  DoSvg(1);
  DoSvg(2);
  DoSvg(3);
end;

end.
