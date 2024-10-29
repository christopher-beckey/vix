#pragma once

using namespace System;
using namespace System::Collections::Generic;

#include "BapiHelper.h"
#include "Request.h"
#include "Response.h"

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

public ref class Connection
{
private:
    property BapiHelper^ Broker;

public:
    Connection()
    {
        Broker = gcnew BapiHelper();
    }

	virtual ~Connection()
	{
		if (Broker != nullptr)
		{
			delete Broker;
			Broker = nullptr;
		}
	}

    property String^ Server 
    {
        String^ get()
        {
            return Broker->Server;
        }
    }

    property int Port
    {
        int get()
        {
            return Broker->Port;
        }
    }

    property String^ UserName
    {
        String^ get()
        {
            return Broker->UserName;
        }
    }

    property String^ UserSSN
    {
        String^ get()
        {
            return Broker->UserSSN;
        }
    }

    property String^ Division 
    { 
        String^ get()
        {
            return Broker->Division;
        }
    }

    property String^ SiteNumber
    {
        String^ get()
        {
            return Broker->SiteNumber;
        }
    }

    property String^ SiteName
    {
        String^ get()
        {
            return Broker->SiteName;
        }
    }

    property String^ UserDUZ
    {
        String^ get()
        {
            return Broker->UserDUZ;
        }
    }

    property Object^ Contextor
    {
        Object^ get()
        {
            return ((Broker != nullptr) && (Broker->Contextor != nullptr))? Broker->Contextor->InternalObject : nullptr;
        }
    }

	property String^ SecurityToken;

    Response^ Execute(Request^ request)
    {
        Response^ response = gcnew Response();

        // set procedure name
        Broker->SetProperty("RemoteProcedure", request->MethodName);

        // set Parameters
		int paramIndex = 0;

		for each(Parameter^ param in request->Parameters)
        {
            if (param->Type == List)
            {
                Broker->SetParameter(paramIndex, (int)param->Type, "");

				int paramItemIndex = 0;
				System::Collections::Generic::List<String^>^ list = dynamic_cast< System::Collections::Generic::List<String^>^ >(param->Value);

				for each(String^ item in list)
                {
                    Broker->SetParameterItem(paramIndex, paramItemIndex++, item);
                }
            }
            else
            {
                Broker->SetParameter(paramIndex, (int) param->Type, dynamic_cast<String^>(param->Value));
            }

			paramIndex++;
        }

        // call remote method
        response->RawData = Broker->CallMethod();

        return response;
    }

internal:
    int Connect(String^ server, int port, String^ securityToken, String^ applicationLabel, String^ passcode)
    {
        int ret = 0;

		Broker->Initialize();

        SecurityToken = securityToken;

		// initialize CCOW - create contextor
		Broker->InitializeCCOW(applicationLabel, passcode);

        ret = Broker->Login(server, port, securityToken);

        return ret;
    }

};

}
}
}
}

