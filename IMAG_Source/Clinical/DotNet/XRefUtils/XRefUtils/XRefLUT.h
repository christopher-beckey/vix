// XRefLUT.h : Declaration of the CXRefLUT

#pragma once
#include "resource.h"       // main symbols



#include "XRefUtils_i.h"
#include "ProjectionMan.h"



#if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
#error "Single-threaded COM objects are not properly supported on Windows CE platform, such as the Windows Mobile platforms that do not include full DCOM support. Define _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA to force ATL to support creating single-thread COM object's and allow use of it's single-threaded COM object implementations. The threading model in your rgs file was set to 'Free' as that is the only threading model supported in non DCOM Windows CE platforms."
#endif

using namespace ATL;


// CXRefLUT

class ATL_NO_VTABLE CXRefLUT :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CXRefLUT, &CLSID_XRefLUT>,
	public ISupportErrorInfo,
	public IDispatchImpl<IXRefLUT, &IID_IXRefLUT, &LIBID_XRefUtilsLib, /*wMajor =*/ 1, /*wMinor =*/ 0>,
	public CProjectionManager
{
public:
	CXRefLUT()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_XREFLUT)


BEGIN_COM_MAP(CXRefLUT)
	COM_INTERFACE_ENTRY(IXRefLUT)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(ISupportErrorInfo)
END_COM_MAP()

// ISupportsErrorInfo
	STDMETHOD(InterfaceSupportsErrorInfo)(REFIID riid);


	DECLARE_PROTECT_FINAL_CONSTRUCT()

	HRESULT FinalConstruct()
	{
		return S_OK;
	}

	void FinalRelease()
	{
	}

public:
	STDMETHOD(GetXRefLine)(IRadiologyImage* image1, IRadiologyImage* image2, LONG* success, LONG* planeId, VARIANT* line);
	STDMETHOD(GetNearestImage)(IRadiologyImage* image, VARIANT images, LONG posX, LONG posY, IRadiologyImage** nearestImage);
	STDMETHOD(RegisterImage)(IRadiologyImage* image);
};

OBJECT_ENTRY_AUTO(__uuidof(XRefLUT), CXRefLUT)
