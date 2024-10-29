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
// SliceCalc.cpp : Implementation of DLL Exports.


// Note: Proxy/Stub Information
//      To build a separate proxy/stub DLL, 
//      run nmake -f SliceCalcps.mk in the project directory.

#include "stdafx.h"
#include "resource.h"
#include <initguid.h>
#include <SliceCalc.h>

#include <SliceCalc_i.c>
#include <slicesX.h>
#ifdef _DEBUG
//#include <debug.h>
#endif



CComModule _Module;

BEGIN_OBJECT_MAP(ObjectMap)
OBJECT_ENTRY(CLSID_slicesX, CslicesX)
END_OBJECT_MAP()

class CSliceCalcApp : public CWinApp
{
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSliceCalcApp)
	public:
    virtual BOOL InitInstance();
    virtual int ExitInstance();
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CSliceCalcApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

BEGIN_MESSAGE_MAP(CSliceCalcApp, CWinApp)
	//{{AFX_MSG_MAP(CSliceCalcApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

CSliceCalcApp theApp;

BOOL CSliceCalcApp::InitInstance()
{
//#ifdef _DEBUG
//	int
//		lLeakLocation = 0;
//	lLeakLocation = CDebug::GetMemAllocNumber();
//	_CrtSetBreakAlloc(lLeakLocation);
//#endif
	_Module.Init(ObjectMap, m_hInstance, &LIBID_SLICECALCLib);
    return CWinApp::InitInstance();
}

int CSliceCalcApp::ExitInstance()
{
    _Module.Term();
    return CWinApp::ExitInstance();
}

/////////////////////////////////////////////////////////////////////////////
// Used to determine whether the DLL can be unloaded by OLE

STDAPI DllCanUnloadNow(void)
{
    AFX_MANAGE_STATE(AfxGetStaticModuleState());
    return (AfxDllCanUnloadNow()==S_OK && _Module.GetLockCount()==0) ? S_OK : S_FALSE;
}

/////////////////////////////////////////////////////////////////////////////
// Returns a class factory to create an object of the requested type

STDAPI DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
    return _Module.GetClassObject(rclsid, riid, ppv);
}

/////////////////////////////////////////////////////////////////////////////
// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
    // registers object, typelib and all interfaces in typelib
    return _Module.RegisterServer(TRUE);
}

/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
    return _Module.UnregisterServer(TRUE);
}


