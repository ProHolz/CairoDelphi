unit Cairo.Emf.Worker;

interface

uses
  Winapi.Windows,
  Cairo.Emf;

function EnumEMFCairoFunc(DC: HDC; var Table: THandleTable; R: PEnhMetaRecord; NumObjects: DWord; E: IEmfEnum): LongBool; stdcall;

implementation

uses
  System.Types,
  Cairo.Interfaces;

 Var gLoop : integer = 0;

/// EMF enumeration callback function, called from GDI
// - draw most content on Cairo canvas (do not render 100% GDI content yet)
function EnumEMFCairoFunc(DC: HDC; var Table: THandleTable; R: PEnhMetaRecord; NumObjects: DWord; E: IEmfEnum): LongBool; stdcall;

begin
  Result := true;
  inc(Gloop);
  case R^.iType of
    EMR_HEADER:
      begin
        E.EMF_MetaHeader(PEnhMetaHeader(R)^);
           { TODO : Check for defaults..... without DC.....}
        E.EMF_SetMapMode(GetMapMode(DC));
        E.EMF_SetPolyFillmode(  GetPolyFillMode(DC));
        E.EMF_SetArcDirection(GetArcDirection(DC));
        GLoop := 1;
      end;

    EMR_SETWINDOWEXTEX: E.EMF_SetWindowExtEx(PEMRSetWindowExtEx(R)^.szlExtent);
    EMR_SETWINDOWORGEX: E.EMF_SetWindowOrgEx(PEMRSetWindowOrgEx(R)^.ptlOrigin);
    EMR_SETVIEWPORTEXTEX: E.EMF_SetViewPortExtEx(PEMRSetViewPortExtEx(R)^.szlExtent);
    EMR_SETVIEWPORTORGEX: E.EMF_SetViewPortOrgEx(PEMRSetViewPortOrgEx(R)^.ptlOrigin);
    EMR_SETBKMODE: E.EMF_SetBKMode(PEMRSetBkMode(R)^.iMode);
    EMR_SETBKCOLOR: E.EMF_SetBKColor(PEMRSetBkColor(R)^.crColor);
    EMR_SETTEXTCOLOR: E.EMF_SetTextColor(PEMRSetTextColor(R)^.crColor);
    EMR_SETTEXTALIGN: E.EMF_SetTextAlign(PEMRSetTextAlign(R)^.iMode);
    EMR_EXTTEXTOUTA : E.EMF_TextOut(PEMRExtTextOut(R)^);
    EMR_EXTTEXTOUTW: E.EMF_TextOut(PEMRExtTextOut(R)^);
    EMR_SAVEDC: E.EMF_SaveDC;
    EMR_RESTOREDC: E.EMF_RestoreDC;
    EMR_SETWORLDTRANSFORM: E.EMF_SetWorldTransform(PEMRSetWorldTransform(R)^);
    EMR_CREATEPEN: E.EMF_CreatePen(PEMRCreatePen(R)^);

    EMR_CREATEBRUSHINDIRECT: E.EMF_CreateBrushIndirect(PEMRCreateBrushIndirect(R)^);

    EMR_EXTCREATEFONTINDIRECTW: E.EMF_CreateFont(PEMRExtCreateFontIndirect(R));

    EMR_DELETEOBJECT: E.EMF_DeleteObject(PEMRDeleteObject(R)^.ihObject);

    EMR_SELECTOBJECT: E.EMF_SelectObjectFromIndex(PEMRSelectObject(R)^.ihObject);

    EMR_MOVETOEX: E.EMF_MOVETOEX(PEMRMoveToEx(R)^);

    EMR_LINETO: E.EMF_LINETO(PEMRLineTo(R)^);

    EMR_RECTANGLE : E.EMF_Rectangle(PEMRRectangle(R)^);
    EMR_ELLIPSE: E.EMF_Ellipse(PEMREllipse(R)^);

    EMR_ROUNDRECT: E.EMF_Roundrect(PEMRRoundRect(R)^);

    EMR_ARC: E.EMF_Arc(PEMRARC(R)^);

    EMR_ARCTO: E.EMF_ArcTo(PEMRARCTO(R)^);

    EMR_ANGLEARC : E.EMF_ANGLEARC(PEMRAngleArc(R)^);

    EMR_PIE: E.EMF_Pie(PEMRPie(R)^);

    EMR_CHORD: E.EMF_Chord(PEMRChord(R)^);

    EMR_FILLRGN: E.EMF_FillRGN(PEMRFillRgn(R)^);

    EMR_POLYGON :  E.EMF_POLYGON(PEMRPolyLine(R)^) ;
    EMR_POLYGON16 : E.EMF_POLYGON16(PEMRPolyline16(R)^) ;

    EMR_POLYLINE  : E.EMF_POLYLINE(PEMRPolyLine(R)^) ;
    EMR_POLYLINE16: E.EMF_POLYLINE16(PEMRPolyLine16(R)^) ;

    EMR_POLYPOLYGON, EMR_POLYPOLYGON16, EMR_POLYPOLYLINE, EMR_POLYPOLYLINE16: E.EMF_PolyPolygon(PEMRPolyPolygon(R), R^.iType);
    EMR_POLYBEZIER: E.EMF_POLYBEZIER(PEMRPolyBezier(R)^);

    EMR_POLYBEZIER16:  E.EMF_POLYBEZIER16(PEMRPolyBezier16(R)^);

    EMR_POLYBEZIERTO: E.EMF_POLYBEZIERTO(PEMRPolyBezierto(R)^);

    EMR_POLYBEZIERTO16: E.EMF_POLYBEZIERTO16(PEMRPolyBezierto16(R)^);

    EMR_POLYLINETO : E.EMF_POLYLINETO(PEMRPolyLineTO(R)^) ;
    EMR_POLYLINETO16:  E.EMF_POLYLINETO16(PEMRPolyLineTO16(R)^) ;

    EMR_POLYDRAW: E.EMF_POLYDRAW(R);

    EMR_POLYDRAW16:  E.EMF_POLYDRAW16(R);

    EMR_BITBLT: E.EMF_BITBLT(PEMRBitBlt(R));

    EMR_STRETCHBLT: E.EMF_STRETCHBLT(PEMRStretchBlt(R));

    EMR_STRETCHDIBITS: E.EMF_STRETCHDIBITS(PEMRStretchDIBits(R));

    EMR_TRANSPARENTBLT: E.EMF_TRANSPARENTBLT(PEMRTransparentBlt(R));

    EMR_GDICOMMENT: E.EMF_GDICOMMENT( PEMRGDICOMMENT(R)^);
      
    EMR_MODIFYWORLDTRANSFORM: E.EMF_MofifyWorldTransform(PEMRModifyWorldTransform(R)^);

    EMR_EXTCREATEPEN: E.EMF_ExtCreatePen(PEMRExtCreatePen(R)^);// approx. - fast solution

    EMR_SETMITERLIMIT:  E.EMF_Set_miter_limit(PEMRSetMiterLimit(R)^.eMiterLimit);

    EMR_SETMETARGN: E.EMF_SetMetaRgn;

    EMR_EXTSELECTCLIPRGN: E.EMF_ExtSelectClipRgn(@PEMRExtSelectClipRgn(R)^.RgnData[0], PEMRExtSelectClipRgn(R)^.iMode);
    EMR_INTERSECTCLIPRECT: E.EMF_IntersectClipRect(PEMRIntersectClipRect(R)^.rclClip);


    EMR_SETMAPMODE: E.EMF_SetMapMode (PEMRSetMapMode(R)^.iMode);
    EMR_BEGINPATH: E.EMF_BeginPath;

    EMR_ENDPATH: E.EMF_EndPath;
    EMR_ABORTPATH: E.EMF_AbortPath;

    EMR_CLOSEFIGURE: E.EMF_CLosePath;
    EMR_FILLPATH: E.EMF_FillPath;

    EMR_STROKEPATH: E.EMF_StrokePath;


    EMR_STROKEANDFILLPATH: E.EMF_StrokeAndFillPath;

    EMR_SETPOLYFILLMODE: E.EMF_SetPolyFillMode(PEMRSetPolyFillMode(R)^.iMode);
    EMR_GRADIENTFILL: E.EMF_GradientFill(PEMGradientFill(R));
    EMR_SETSTRETCHBLTMODE: E.EMF_SetStretchBltMode(PEMRSetStretchBltMode(R)^.iMode);
    EMR_SETARCDIRECTION: E.EMF_SetArcDirection( PEMRSetArcDirection(R)^.iArcDirection);
    EMR_SETPIXELV: ; // Not Implemented

    // TBD
    EMR_SMALLTEXTOUT, EMR_SETROP2, EMR_ALPHADIBBLEND, EMR_SETBRUSHORGEX, EMR_SETICMMODE, EMR_SELECTPALETTE, EMR_CREATEPALETTE,
     EMR_SETPALETTEENTRIES, EMR_RESIZEPALETTE, EMR_REALIZEPALETTE, EMR_EOF:; // do nothing
  else
    begin
      R^.iType := R^.iType; // for debug purpose (breakpoint)
    end;
  end;
end;

end.
