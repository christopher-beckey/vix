#pragma once

#include <comdef.h>
#include <windows.h>
#include <atlstr.h>
#include <msclr\marshal.h>
#include <msclr\marshal_atl.h>
#include "ContextorHelper.h"

using namespace System;
using namespace System::Runtime::InteropServices;

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

private class StringHelper
{
public:
	StringHelper(String^ text) : m_buffer(NULL)
	{
		if (text != nullptr)
		{
			m_buffer = (char*)(void*)Marshal::StringToHGlobalAnsi(text);	
		}
	}

	virtual ~StringHelper()
	{
		if (m_buffer)
		{
			Marshal::FreeHGlobal((System::IntPtr)m_buffer);
		}
	}

	operator char*(void)
	{
		return m_buffer;
	}

private:
	char* m_buffer;
};

}
}
}
}