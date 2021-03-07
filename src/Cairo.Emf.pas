unit Cairo.Emf;

interface

uses
  Winapi.Windows,
  System.Types;

  type
  /// internal data used during drawing
  // - contain the EMF enumeration engine state parameters
  IEmfEnum = interface
    ['{E00F2B17-5520-46D3-8771-E92278BFF8AA}']

    procedure EMF_MetaHeader(const Value :  TEnhMetaHeader);
    procedure EMF_SetWindowExtEx(const Value :  TSize);
    procedure EMF_SetWindowOrgEx(const Value :  TPoint);
    procedure EMF_SetViewPortExtEx(const Value :  TSize);
    procedure EMF_SetViewPortOrgEx(const Value :  TPoint);
    procedure EMF_SetBKMode(const Value :  DWORD);
    procedure EMF_SetBKColor(const Value :  Cardinal);
    procedure EMF_SetTextColor(const Value :  Cardinal);
    procedure EMF_SetTextAlign(const Value :  DWORD);

    procedure EMF_SetMapMode(Value : DWORD);
    procedure EMF_SetPolyFillMode(Value : DWORD);
    procedure EMF_SetStretchBltMode(Value : DWORD);
    procedure EMF_SetArcDirection(Value : DWORD);



    procedure EMF_SetWorldTransform(const Value : TEMRSetWorldTransform);
    procedure EMF_MofifyWorldTransform(const Value : TEMRModifyWorldTransform);

    Procedure EMF_SaveDC;
    Procedure EMF_RestoreDC;

    procedure EMF_IntersectClipRect(const ClpRect: TRect);
    procedure EMF_ExtSelectClipRgn(data: PRgnDataHeader; iMode: DWord);


    procedure EMF_Set_miter_limit(Value: Single); // fw

    procedure EMF_CreatePen(const Value : TEMRCreatePen);
    procedure EMF_ExtCreatePen(const Value : TEMRExtCreatePen);

    procedure EMF_CreateBrushIndirect(const Value : TEMRCreateBrushIndirect);
    procedure EMF_CreateFont(Value: PEMRExtCreateFontIndirect);
    procedure EMF_DeleteObject(const Value : DWORD);
    procedure EMF_SelectObjectFromIndex(const Value: Integer);


   // EMR_MOVETOEX

    procedure EMF_MOVETOEX(const Value: EMRMoveToEx);
    procedure EMF_LINETO(const Value: EMRLINETO);
    procedure EMF_Rectangle(const Value: EMRRectangle);
    procedure EMF_Ellipse(const Value: EMRELLIPSE);
    procedure EMF_Roundrect(const Value: EMRROUNDRECT);
    procedure EMF_Arc(Value: EMRARC);
    procedure EMF_ArcTo(Value: EMRArcTo);
    procedure EMF_ANGLEARC(const Value : EMRANGLEARC);
    procedure EMF_Pie(Value: EMRPie);
    procedure EMF_Chord(Value: EMRChord);

    procedure EMF_FillRGN(Value: EMRFillRgn);
    procedure EMF_SetMetaRgn;

    procedure EMF_POLYGON(const Value : EMRPolyLine);
    procedure EMF_POLYGON16(const Value : EMRPolyLine16);

    procedure EMF_POLYLINE(const Value : EMRPolyLine);
    procedure EMF_POLYLINE16(const Value : EMRPolyLine16);
    procedure EMF_POLYLINETO(const Value : EMRPolyLineTO);
    procedure EMF_POLYLINETO16(const Value : EMRPolyLineTO16);

    procedure EMF_PolyPolygon(data: PEMRPolyPolygon; iType: integer);
    procedure EMF_POLYBEZIER(const Value : EMRPolyBezier);
    procedure EMF_POLYBEZIER16(const Value : EMRPolyBezier16);

    procedure EMF_POLYBEZIERTO(const Value : EMRPolyBezierTo);
    procedure EMF_POLYBEZIERTO16(const Value : EMRPolyBezierTo16);

    procedure EMF_POLYDRAW(const R : PEnhMetaRecord);
    procedure EMF_POLYDRAW16(const R : PEnhMetaRecord);


    procedure EMF_GradientFill(data: PEMGradientFill);


    procedure EMF_BITBLT(Value : PEMRBITBLT);
    procedure EMF_STRETCHBLT(Value : PEMRStretchBlt);
    procedure EMF_STRETCHDIBITS(Value : PEMRStretchDIBits);
    procedure EMF_TRANSPARENTBLT(Value : PEMRTransparentBLT);


    procedure EMF_TextOut(var R: TEMRExtTextOut);

    procedure EMF_GDICOMMENT(const Value : EMRGDICOMMENT);


    procedure EMF_BeginPath;
    procedure EMF_CLosePath;
    procedure EMF_EndPath;
    procedure EMF_AbortPath;

    procedure EMF_FillPath;

    procedure EMF_StrokePath;
    procedure EMF_StrokeAndFillPath;
  // Must be implemented....
    procedure EMF_SetPixel;
  end;

implementation

end.
