unit Cairo.FtFontManager;

interface

uses
  System.Sysutils,
  System.Types,
  Cairo.Freetype,
  Spring.Collections;

type

  TFTFontData = record
    Filename: String;
    Stylename : String;
    FamilyName : String;

  end;


  TFtFontmanager = class
  private
    FItems: IDictionary<string,ilist<TFTFontData>>;
    FLibrary: FT_Library;
    Ferrorcount : integer;

    function GetFontDirectory: string;

  public
    constructor Create;
    destructor Destroy; override;
    function LoadFonts: Integer;
  end;


implementation

uses
  Winapi.Windows,
  Winapi.SHFolder,
  System.ioutils;

{ TFtFontmanager }

constructor TFtFontmanager.Create;
begin
  inherited Create;
  FItems := TCollections.CreateDictionary<String, ilist<TFTFontData>>;
  if FT_Init_FreeType(FLibrary) <> 0 then
    raise Exception.Create('Can not Initialize Freetype');

end;

destructor TFtFontmanager.Destroy;
begin
  FItems := nil;
  FT_Done_FreeType(FLibrary);
  inherited;
end;

function TFtFontmanager.GetFontDirectory: string;
var
  LStr: array [0 .. MAX_PATH] of Char;
begin
  Result := '';
  SetLastError(ERROR_SUCCESS);
  if SHGetFolderPath(0, CSIDL_WINDOWS, 0, 0, @LStr) = S_OK then
  begin
    Result := LStr;
    Result := TPath.Combine(Result, 'Fonts');
  end;
end;


function TFtFontmanager.LoadFonts: Integer;
Var res: string;
  lft: TFTFontData;
  FFace: FT_Face;
  lList : Ilist<TFTFontData>;
begin
  for res in TDirectory.GetFiles(GetFontDirectory, '*.ttf') do
  begin
    if FT_New_Face(FLibrary, pAnsichar(UTF8String(res)), 0, FFace) = 0 then
    begin
      lft.Stylename  := Fface.style_name;
      lft.FamilyName  := Fface.family_name;
      lft.Filename := res;
      if FItems.TryGetValue(lft.FamilyName, lList) then
      lList.Add(lft)
      else
      begin
       lList := TCollections.CreateList<TFTFontData>;
       lList.Add(lft);
       FItems.Add(lft.FamilyName, lList);
      end;
      FT_Done_Face(FFace);
    end
    else
    begin
      inc(Ferrorcount);
    end;
  end;
  result := FItems.Count;
end;

end.
