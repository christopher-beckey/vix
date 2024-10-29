#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

public ref class ResponseToken
{
public:
    ResponseToken()
    {
        Value = nullptr;
    }

    ResponseToken(String^ value)
    {
        Value = value;
    }

    property String^ Value;

    IEnumerable<ResponseToken^>^ Split(String^ delimStr)
    {
        System::Collections::Generic::List<ResponseToken^>^ responseTokens = nullptr;

        if (Value != nullptr)
        {
            array<Char>^ delimiter = delimStr->ToCharArray();
            array<String^>^ tokens = Value->Split(delimiter, StringSplitOptions::None);
            if (tokens != nullptr)
            {
                responseTokens = gcnew System::Collections::Generic::List<ResponseToken^>();
                for (int i = 0; i < tokens->Length; i++)
                {
                    responseTokens->Add(gcnew ResponseToken(tokens[i]));
                }

            }
        }

        return responseTokens;
    }
};

public ref class Response
{
public:
    Response(void)
	{
		RawData = nullptr;
		RPCName = nullptr;
	}

    Response(String^ rawData)
    {
        RawData = rawData;
    }

    property String^ RPCName;

    property String^ RawData;

    IEnumerable<ResponseToken^>^ Split(String^ delimStr)
    {
		ResponseToken^ responseToken = gcnew ResponseToken(RawData);

        return responseToken->Split(delimStr);
    }
};

}
}
}
}
