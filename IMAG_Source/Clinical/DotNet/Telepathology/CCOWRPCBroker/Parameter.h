#pragma once

using namespace System;

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

public enum ParameterType
{
    Literal,
    Reference,
    List
};

public ref class Parameter
{
public:
    Parameter(void)
	{
		Value = nullptr;
		Type = Literal;
	}

    property Object^ Value;

    property ParameterType Type;
};

}
}
}
}
