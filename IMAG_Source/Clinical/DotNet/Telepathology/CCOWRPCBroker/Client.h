#pragma once

using namespace System;

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

public ref class Client
{
public:
	Client(void)
	{
		CurrentConnection = nullptr;
	}

    property Connection^ CurrentConnection;

    property String^ SiteServiceURL;

	property String^ ApplicationLabel;

	property String^ PassCode;

    Connection^ Connect()
    {
        return Connect("", 0, "");
    }

	void Close()
	{
		if (CurrentConnection != nullptr)
		{
			delete CurrentConnection;
			CurrentConnection = nullptr;
		}
	}

private:

	Connection^ Connect(String^ server, int port, String^ securityToken)
    {
        Connection^ conn = gcnew Connection();
        if (conn->Connect(server, port, securityToken, ApplicationLabel, PassCode) == 1)
        {
            // for now set as default connection
            CurrentConnection = conn;

            return conn;
        }

        return nullptr;
    }
};

}
}
}
}
