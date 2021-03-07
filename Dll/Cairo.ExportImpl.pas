unit Cairo.ExportImpl;

interface
uses
Vcl.Graphics,
 Winapi.Windows,
  System.Sysutils,
  System.Classes,
  Cairo.ExportIntf,
  Cairo.Interfaces,
  Cairo.Types;

 type
  TCairoPDF = class(TInterfacedObject, ICairoPDF, ICairoSVG)
  private
    FPdfSurface: ICairoSurface;
    Sizex: double;
    SizeY: double;
    Filename : String;
    FHasPage : boolean;
    FContext: ICairoContext;
    LScale : Double;

   procedure CheckStatus(const aStatus : cairo_status_t);
   procedure RenderMeta(const aMeta: TMetafile);
   procedure StartPdf;
   procedure StartSVG;

   // From   ICairoPDF
    procedure AddPage; stdcall;
    procedure CreatePDF(const aFilename : WideString; const aWidth, aHeight: Integer); stdcall;
    procedure CreateSVG(const aFilename : WideString; const aWidth, aHeight: Integer); stdcall;
    procedure RenderMetaFile(const aMeta : HENHMETAFILE); stdcall;
    procedure SetAuthor(const Value: WideString); stdcall;
    procedure SetCreationDate(const Value: TDateTime); stdcall;
    procedure SetCreator(const Value: WideString); stdcall;
    procedure SetSubject(const Value: WideString); stdcall;
    procedure SetTitle(const Value: WideString); stdcall;

  public
    destructor Destroy; override;
  end;


  TCairoExporter = class(TInterfacedObject, ICairoExporter)
  private
    function GetCairoPDF: ICairoPDF; stdcall;
    function GetCairoSVG: ICairoSVG; stdcall;
  end;

implementation
 uses
  System.Types,
  Cairo.Font,
  Cairo.Stream,
  Cairo.dll,
  Cairo.Surface,
  Cairo.FreeType,
  Cairo.Emf,
  Cairo.Emf.worker,
  Cairo.Emf.Implementations,
  System.DateUtils;


 { TCairoPdf }

procedure  TCairoPdf.RenderMeta(const aMeta: TMetafile);
Var
  LMetaSurface : ICairoSurface;
  lContext : ICairoContext;
  R: TRect;
  lemf: IEmfEnum;
  lRecoding: iCairoRecordingSurface;
  p: Pointer;
  lx, ly, lw, lh: double;
  lScalex : Double;
  lScaley : Double;


begin
  LMetaSurface := CairoFactory.CreateRecording(nil);
  lContext := CairoFactory.CreateContext(lMetaSurface);

  R.Left := 0;
  R.Top := 0;
  R.Right := aMeta.width;
  R.Bottom := aMeta.height;
  lScalex := Sizex / aMeta.Width;
  lScaleY := SizeY / aMeta.Height;


  lemf := TEmfEnum.Create(lContext);
  p := Pointer(lemf);
  EnumEnhMetaFile(getDc(0), aMeta.Handle, @EnumEmfCairoFunc, p, R);
  LMetaSurface.flush;
  if supports(lMetaSurface, iCairoRecordingSurface, lRecoding) then
  begin
    FHasPage := true;
    lRecoding.ink_extents(lx, ly, lw, lh);
    FContext.save;
    FContext.scale(lScalex, lScaley);
    FContext.set_source_surface(lRecoding, 0, 0);
    FContext.paint;
    FContext.restore;
    FPdfSurface.flush;

  end;
  lContext := nil;
  LMetaSurface := nil;
end;


procedure TCairoPdf.StartPdf;
begin
  FPdfSurface := CairoFactory.CreatePdf(Filename, Sizex, SizeY);
  FContext := CairoFactory.CreateContext(FPdfSurface);
  Fcontext.scale(LScale, Lscale);
end;

procedure TCairoPdf.AddPage;
begin
 if FHasPage then
  begin
    FPdfSurface.show_page;
    CheckStatus(FPdfSurface.status);
    FHasPage := false;
  end;
end;

destructor TCairoPdf.Destroy;
begin
  FPdfSurface.flush;
  FContext := nil;
  FPdfSurface := nil;
  inherited;
end;

procedure TCairoPdf.CheckStatus(const aStatus: cairo_status_t);
begin
  if aStatus <> CAIRO_STATUS_SUCCESS then
    raise Exception.CreateFmt('cairo Status %d',[integer(aStatus)]);
end;

procedure TCairoPdf.StartSVG;
begin
  FPdfSurface := CairoFactory.CreateSVG(Filename, Sizex, SizeY);
  FContext := CairoFactory.CreateContext(FPdfSurface);
  Fcontext.scale(LScale, Lscale);
end;


procedure TCairoPDF.CreatePDF(const aFilename : WideString; const aWidth, aHeight: Integer);
begin
  Filename := aFilename;
  SizeX := aWidth;
  SizeY := aHeight;
  lScale := 1.0;
  StartPdf;
end;

procedure TCairoPDF.CreateSVG(const aFilename : WideString; const aWidth, aHeight: Integer);
begin
  Filename := aFilename;
  SizeX := aWidth;
  SizeY := aHeight;
  lScale := 1.0;
  StartSVG;
end;

procedure TCairoPDF.RenderMetaFile(const aMeta : HENHMETAFILE);
var lMeta : TmetaFile;
begin
  lMeta := TMetafile.Create;
  try
    lMeta.Enhanced := true;
    lMeta.Handle :=  aMeta;
    RenderMeta(lMeta);
  finally
    lMeta.ReleaseHandle;
    lMeta.Free;
  end;
end;

procedure TCairoPDF.SetAuthor(const Value: WideString);
begin
   if Assigned(FPdfSurface) then
    cairo_pdf_surface_set_metadata(FPdfSurface.Handle, CAIRO_PDF_METADATA_AUTHOR, PUtf8Char(Utf8String(Value)));
end;

procedure TCairoPDF.SetCreationDate(const Value: TDateTime);
var ltemp : Utf8String;
begin
  lTemp :=   UTF8String( DateToISO8601(Value, false));
  if Assigned(FPdfSurface) then
    cairo_pdf_surface_set_metadata(FPdfSurface.Handle, CAIRO_PDF_METADATA_MOD_DATE, PUtf8Char(ltemp));
end;

procedure TCairoPDF.SetCreator(const Value: WideString);
begin
 if Assigned(FPdfSurface) then
    cairo_pdf_surface_set_metadata(FPdfSurface.Handle, CAIRO_PDF_METADATA_CREATOR, PUtf8Char(Utf8String(Value)));

end;

procedure TCairoPDF.SetSubject(const Value: WideString);
begin
 if Assigned(FPdfSurface) then
    cairo_pdf_surface_set_metadata(FPdfSurface.Handle, CAIRO_PDF_METADATA_SUBJECT, PUtf8Char(Utf8String(Value)));
end;

procedure TCairoPDF.SetTitle(const Value: WideString);
begin
 if Assigned(FPdfSurface) then
    cairo_pdf_surface_set_metadata(FPdfSurface.Handle, CAIRO_PDF_METADATA_TITLE, PUtf8Char(Utf8String(Value)));

end;

function TCairoExporter.GetCairoPDF: ICairoPDF;
begin
  result := TCairoPdf.Create as ICairoPDF;
end;

function TCairoExporter.GetCairoSVG: ICairoSVG;
begin
  result := TCairoPdf.Create as ICairoSVG;
end;



end.
