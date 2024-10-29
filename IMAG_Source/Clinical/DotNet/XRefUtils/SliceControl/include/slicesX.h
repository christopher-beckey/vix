//Per VHA Directive 2004-038, this routine should not be modified.
// +---------------------------------------------------------------+
// | Property of the US Government.                                |
// | No permission to copy or redistribute this software is given. |
// | Use of unreleased versions of this software requires the user |
// | to execute a written test agreement with the VistA Imaging    |
// | Development Office of the Department of Veterans Affairs,     |
// | telephone (301) 734-0100.                                     |
// |                                                               |
// | The Food and Drug Administration classifies this software as  |
// | a medical device.  As such, it may not be changed in any way. |
// | Modifications to this software may result in an adulterated   |
// | medical device under 21CFR820, the use of which is considered |
// | to be a violation of US Federal Statutes.                     |
// +---------------------------------------------------------------+
// 
// 
// slicesX.h : Declaration of the CslicesX

#ifndef __SLICESX_H_
#define __SLICESX_H_

#include "resource.h"       // main symbols
#include "sliceProcessing.h"

/////////////////////////////////////////////////////////////////////////////
// CslicesX
class ATL_NO_VTABLE CslicesX : 
	public CComObjectRootEx<CComMultiThreadModel>,
	public CComCoClass<CslicesX, &CLSID_slicesX>,
	public IDispatchImpl<IslicesX, &IID_IslicesX, &LIBID_SLICECALCLib>
{
public:
	CslicesX()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_SLICESX)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(CslicesX)
	COM_INTERFACE_ENTRY(IslicesX)
	COM_INTERFACE_ENTRY(IDispatch)
END_COM_MAP()

// IslicesX
public:
	
	STDMETHOD(IntersectLine)( /*[out]*/ short * P0X, /*[out]*/ short* P0Y,  /*[out]*/ short * P1X,/*[out]*/ short* P1Y, /*[out]*/ BOOL * Parallel, /*[out]*/ BOOL * Intersect);
	STDMETHOD(ProjectSlice)(/*[in]*/ VARIANT* scoutPosition, /*[in]*/ VARIANT* scoutOrientation, /*[in]*/ VARIANT* scoutPixelSpacing, /*[in]*/ long scoutRows, /*[in]*/ long scoutColumns, /*[in]*/ VARIANT* imagePosition, /*[in]*/ VARIANT* imageOrientation, /*[in]*/ VARIANT* imagePixelSpacing, /*[in]*/ long imageRows, /*[in]*/ long imageColumns, /*[out]*/ VARIANT* sliceLine, double * Angle);
	STDMETHOD(Project)(BSTR* ScoutPos, BSTR* ScoutOrient, BSTR* ScoutPixSpace, short ScoutRows, short ScoutCols, BSTR* ImgPos, BSTR* ImgOrient, BSTR* ImgPixSpace, short ImgRows, short ImgCols);
	STDMETHOD(BoundingBox)(short* UlX, short* UlY, short* UrX, short* UrY, short* LrX, short* LrY, short* LlX, short* LlY);
	STDMETHOD(Axis)(short* TopX, short* TopY, short* RightX, short* RightY, short* BottomX, short* BottomY, short* LeftX, short* LeftY);
// Implementation
private:
	//##ModelId=3A6C889B01A1
	CsliceProcessing _mslice;
};

#endif //__SLICESX_H_
