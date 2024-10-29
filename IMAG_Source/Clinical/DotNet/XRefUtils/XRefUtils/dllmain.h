// dllmain.h : Declaration of module class.

class CXRefUtilsModule : public ATL::CAtlDllModuleT< CXRefUtilsModule >
{
public :
	DECLARE_LIBID(LIBID_XRefUtilsLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_XREFUTILS, "{CF3ECB3F-EB00-4B20-A08C-21ACDC73BAF8}")
};

extern class CXRefUtilsModule _AtlModule;
