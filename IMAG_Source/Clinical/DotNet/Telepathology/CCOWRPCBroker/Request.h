#pragma once

using namespace System;
using namespace System::Collections::Generic;

#include "Parameter.h"

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

public ref class Request
{
public:
	Request(void)
	{
		MethodName = nullptr;
		ParameterList = gcnew System::Collections::Generic::List<Parameter^>();
	}

	property String^ MethodName;

	property IEnumerable<Parameter^>^ Parameters
	{
		IEnumerable<Parameter^>^ get()
		{
			return ParameterList;
		}
	}

	Request^ AddParameter(String^ value)
	{
		Parameter^ param = gcnew Parameter();
		param->Type = Literal;
		param->Value = value;

		ParameterList->Add(param);
		return this;
	}

	Request^ AddParameter(System::Collections::Generic::List<String^>^ value)
	{
		Parameter^ param = gcnew Parameter();
		param->Type = List;
		param->Value = value;

		ParameterList->Add(param);
		return this;
	}
    
	Request^ AddParameter(Parameter^ value)
	{
		Parameter^ param = gcnew Parameter();
		param->Type = value->Type;
		param->Value = value->Value;

		ParameterList->Add(param);
		return this;
	}

	void ClearParameters()
	{
		ParameterList->Clear();
	}

private:
	property System::Collections::Generic::List<Parameter^>^ ParameterList;


};

}
}
}
}
