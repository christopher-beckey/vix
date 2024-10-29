// RadiologyImage.h : Declaration of the CRadiologyImage

#pragma once
#include "resource.h"       // main symbols

#include "XRefUtils_i.h"
#include "ProjectionMan.h"



#if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
#error "Single-threaded COM objects are not properly supported on Windows CE platform, such as the Windows Mobile platforms that do not include full DCOM support. Define _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA to force ATL to support creating single-thread COM object's and allow use of it's single-threaded COM object implementations. The threading model in your rgs file was set to 'Free' as that is the only threading model supported in non DCOM Windows CE platforms."
#endif

using namespace ATL;

#include <list>
using namespace std;

class CDicomTag
{
public:
	LONG m_Group;
	LONG m_Element;
	CComBSTR m_Value;
};


// CRadiologyImage

class ATL_NO_VTABLE CRadiologyImage :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CRadiologyImage, &CLSID_RadiologyImage>,
	public ISupportErrorInfo,
	public IDispatchImpl<IRadiologyImage, &IID_IRadiologyImage, &LIBID_XRefUtilsLib, /*wMajor =*/ 1, /*wMinor =*/ 0>
{
public:
	CRadiologyImage()
	{
	}

	virtual ~CRadiologyImage()
	{
		list<CDicomTag*>::iterator iter = m_TagList.begin();
		while (iter != m_TagList.end())
		{
			delete *iter;
			iter++;
		}

		m_TagList.clear();
	}

DECLARE_REGISTRY_RESOURCEID(IDR_RADIOLOGYIMAGE)


BEGIN_COM_MAP(CRadiologyImage)
	COM_INTERFACE_ENTRY(IRadiologyImage)
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
	STDMETHOD(get_ProjectionIndex)(SHORT* pVal);
	STDMETHOD(put_ProjectionIndex)(SHORT newVal);
	STDMETHOD(get_TagValue)(LONG group, LONG element, BSTR* pVal);
	STDMETHOD(put_TagValue)(LONG group, LONG element, BSTR newVal);
	STDMETHOD(get_UserData)(VARIANT* pVal);
	STDMETHOD(put_UserData)(VARIANT newVal);

private:
	SHORT m_ProjectionIndex;
	CComVariant m_UserData;
	list<CDicomTag*> m_TagList;
public:
	STDMETHOD(SetTag)(LONG group, LONG element, BSTR newValue);
};

OBJECT_ENTRY_AUTO(__uuidof(RadiologyImage), CRadiologyImage)
