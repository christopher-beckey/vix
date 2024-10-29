#pragma once

#include <comdef.h>
#include <windows.h>
#include <atlstr.h>
#include <msclr\marshal.h>
#include <msclr\marshal_atl.h>
#include "ContextorHelper.h"
#include "StringHelper.h"

using namespace System;
using namespace System::Runtime::InteropServices;

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

#define DECL_FUNC(ret, name, ...) \
    typedef ret (__stdcall *P_##name)(__VA_ARGS__); \
    P_##name name;
#define INIT_FUNC(name) \
    if ((name = (P_##name) GetProcAddress(m_hModDll, #name)) == NULL) goto error;

private ref class BapiHelper
{
public:
    BapiHelper(void) : m_initialized(false), m_hModDll(NULL), m_broker(NULL)
    {
		Contextor = nullptr;
    }

	virtual ~BapiHelper()
	{
		if ((m_broker != NULL) && (Contextor != nullptr))
		{
			RpcbContextorReset(m_broker);

			delete Contextor;
			Contextor = nullptr;

			RpcbFree(m_broker);
			m_broker = NULL;

			FreeLibrary(m_hModDll);
			m_hModDll = NULL;
		}
	}

    DECL_FUNC(void*, RpcbCreate)
    DECL_FUNC(long, RpcbContextorCreate, void*)
	DECL_FUNC(void, RpcbContextorReset, void*)
    DECL_FUNC(void, RpcbFree, void*)
    DECL_FUNC(void, RpcbGetServerInfo, char*, char*, int*)
    DECL_FUNC(void, RpcbPropSet, void*, char*, char*)
    DECL_FUNC(void, RpcbPropGet, void*, char*, BSTR*)
    DECL_FUNC(void, RpcbUserPropSet, void*, char*, char*)
    DECL_FUNC(void, RpcbUserPropGet, void*, char*, BSTR*)
    DECL_FUNC(char*, RpcbCall, void*, BSTR*)
    DECL_FUNC(void, RpcbParamSet, void*, int, int, char*)
    DECL_FUNC(void, RpcbMultSet, void*, int, char*, char*)

    bool Initialize()
    {
        if (!m_initialized)
        {
            m_hModDll = LoadLibraryA("Bapi32_47_1.dll");
            if (m_hModDll)
            {
                INIT_FUNC(RpcbCreate)
                INIT_FUNC(RpcbContextorCreate)
				INIT_FUNC(RpcbContextorReset)
                INIT_FUNC(RpcbFree)
                INIT_FUNC(RpcbGetServerInfo)
                INIT_FUNC(RpcbPropSet)
                INIT_FUNC(RpcbPropGet)
                INIT_FUNC(RpcbUserPropSet)
                INIT_FUNC(RpcbUserPropGet)
                INIT_FUNC(RpcbCall)
                INIT_FUNC(RpcbParamSet)
                INIT_FUNC(RpcbMultSet)

				m_broker = RpcbCreate();

                m_initialized = true;
            }
        }

error:
        return m_initialized;
    }

    property String^ Server;

    property int Port;

    property String^ Division;

    property String^ SiteNumber;

    property String^ SiteName;

    property String^ UserName;

    property String^ UserSSN;

    property bool Connected;

    property String^ UserDUZ;

	property ContextorHelper^ Contextor;

    //public VERGENCECONTEXTORLib.Contextor Contextor { get; set; }

    void SetProperty(String^ name, String^ value)
    {
		StringHelper sName(name);
		StringHelper sValue(value);

        RpcbPropSet(m_broker, sName, sValue);
    }

    void SetProperty(char* name, char* value)
    {
        RpcbPropSet(m_broker, name, value);
    }

	String^ GetProperty(String^ name)
    {
		StringHelper sName(name);
		CComBSTR value;

        RpcbPropGet(m_broker, sName, &value);

        return Convert(value);
    }

    void SetUserProperty(String^ name, String^ value)
    {
		StringHelper sName(name);
		StringHelper sValue(value);

        RpcbUserPropSet(m_broker, sName, sValue);
    }

    String^ GetUserProperty(String^ name)
    {
		StringHelper sName(name);
		BSTR value = NULL;

        RpcbUserPropGet(m_broker, sName, &value);

        return Convert(value);
    }

    void SetParameter(int paramIndex, int paramType, String^ paramValue)
    {
        StringHelper sValue(paramValue);

        RpcbParamSet(m_broker, paramIndex, paramType, sValue);
    }

    void SetParameterItem(int paramIndex, int paramItemIndex, String^ paramValue)
    {
		StringHelper sValue(paramValue);
		char sParamItemIndex[256];
		sprintf(sParamItemIndex, "%d", paramItemIndex);

        RpcbMultSet(m_broker, paramIndex, sParamItemIndex, sValue);
    }

	int InitializeCCOW(String^ applicationLabel, String^ passcode)
	{
        int ret = 0;

		try
		{
			// create contextor
			long rpcContextor = RpcbContextorCreate(m_broker);
			Contextor = gcnew ContextorHelper(rpcContextor);
			if (!Contextor->Run(applicationLabel, passcode))
			{
				RpcbContextorReset(m_broker);
				delete Contextor;
				Contextor = nullptr;
			}
		}
		catch(...)
		{
			ret = 0;
		}

		return ret;
	}

    int Login(String^ server, int port, String^ securityToken)
    {
        int ret = 0;

		try
		{
			CStringA sServer(server);
			CStringA sPort;
			sPort.Format("%d", port);

			char serverPtr[256];
			char portPtr[256];

			strcpy(serverPtr, sServer); 
			strcpy(portPtr, sPort); 

			// hide error messages
			SetProperty("ShowErrorMsgs", "1");

			RpcbGetServerInfo(serverPtr, portPtr, &ret);
			if (ret == 1) // user clicked OK
			{
				Server = Convert(serverPtr);
				Port = atoi(portPtr);

				// set connection properties
				SetProperty("Server", serverPtr);
				SetProperty("ListenerPort", portPtr);

				// set connected propery to TRUE to connect
				SetProperty("Connected", "1");

				// check if connection succeeded
				String^ prop = GetProperty("Connected");
				CStringA sProp(prop);
				Connected =  (sProp == "1");

				if (Connected)
				{
					// get properties
					UserName = GetUserProperty("NAME");
					array<String^>^ tokens = GetUserProperty("DIVISION")->Split('^');
					SiteNumber = tokens[0];
					SiteName = tokens[1];
					Division = tokens[2];
					UserDUZ = GetUserProperty("DUZ");
				}
				else
				{
					// user cancelled
					return 0;
				}
			}
		}
		catch(...)
		{
			ret = 0;
		}

        return ret;
    }

    String^ CallMethod()
    {
        BSTR bstrText = NULL;    
		String^ response = nullptr;

        RpcbCall(m_broker, &bstrText);
		if (bstrText != NULL)
		{
			response = Convert(bstrText);
			::SysFreeString(bstrText);
		}

        return response;
    }

private:
    bool m_initialized;

    HMODULE m_hModDll;

    void* m_broker;

	String^ Convert(BSTR text)
	{
		CString sText = text;
		return gcnew String(sText);
	}

	String^ Convert(char* text)
	{
		return gcnew String(text);
	}
};

}
}
}
}


