unit Cairo.Stream;

interface
  uses
    System.Sysutils,
    System.Classes,
    Cairo.Types;

   type
     PCairoStream = type of Pointer;
     TCairoStream = class
        private
          fOwnStream : Boolean;
          fStream : TStream;
        public

         constructor Create(); overload;
         constructor Create(const ABytes: TBytes); overload;
         constructor Create(const AStream: TStream); overload;

         destructor Destroy; override;

         procedure savetofile(const filename : string);


         class function CairoWrite(closure: PcairoStream; data: PByte; length: Cardinal): _cairo_status; static; cdecl;
         class function StreamRead(closure: Pointer; data: PByte; length: Cardinal): _cairo_status; static; cdecl;
     end;




implementation
 uses Cairo.Dll;


{ TCairoStream }

constructor TCairoStream.Create();
begin
  inherited Create;
  fStream := TBytesStream.Create;
end;

destructor TCairoStream.Destroy;
begin
 if fOwnStream then
  fstream.free;
  inherited;
end;

class function TCairoStream.CairoWrite(closure: PcairoStream; data: PByte; length: Cardinal): _cairo_status;
begin
  Result := CAIRO_STATUS_WRITE_ERROR;
   if (closure <> nil) and(data <> nil) then
   begin
     if (Tobject(closure) is TCairoStream) then
    begin
     TCairoStream(closure).fStream.Write(data^, length);
     result := CAIRO_STATUS_SUCCESS;
    end;
   end;
end;

procedure TCairoStream.savetofile(const filename: string);
begin
  TMemoryStream(fStream).SaveToFile(filename);
end;

class function TCairoStream.StreamRead(closure: Pointer; data: PByte; length:
    Cardinal): _cairo_status;
begin
   Result := CAIRO_STATUS_WRITE_ERROR;
   if (closure <> nil) and(data <> nil) then
   begin
     if (Tobject(closure) is TCairoStream) then
    begin
     TCairoStream(closure).fStream.Read(data^, length);
     result := CAIRO_STATUS_SUCCESS;
    end;
   end;
end;

constructor TCairoStream.Create(const ABytes: TBytes);
begin
 inherited Create;
  fStream := TBytesStream.Create(ABytes);
  fOwnStream := true;
end;

constructor TCairoStream.Create(const AStream: TStream);
begin
inherited Create;
  fStream := aStream;
  fOwnStream := false;
end;

end.
