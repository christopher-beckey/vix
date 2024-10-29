#pragma once

#include <atlstr.h>
#include "StringHelper.h"

using namespace System;
using namespace System::Runtime::InteropServices;

#import "..\Vendor\Sentillion\VergenceContextor.tlb"  no_namespace raw_native_types raw_interfaces_only named_guids

namespace VistA {
namespace Imaging {
namespace Telepathology {
namespace CCOWRPCBroker {

public ref class ContextorHelper
{
public:
    ContextorHelper(long contextor) : m_contextor(NULL)
    {
        CComQIPtr<IContextor> spContextor = (IUnknown*) contextor; 
		m_contextor = spContextor.Detach();
    }

	virtual ~ContextorHelper()
	{
		if (m_contextor != NULL)
		{
			m_contextor->Release();
			m_contextor = NULL;
		}
	}

	bool Run(String^ applicationLabel, String^ passcode)
	{
		if (!m_contextor)
		{
			return false;
		}

		CComBSTR bstrApplicationLabel = StringHelper(applicationLabel);
		CComBSTR bstrPassCode = StringHelper(passcode);

		return SUCCEEDED(m_contextor->Run(bstrApplicationLabel, bstrPassCode, VARIANT_TRUE, L"*"));
	}

    property Object^ InternalObject
    {
        Object^ get()
        {
            if (m_contextor == NULL)
            {
                return nullptr;
            }

            IntPtr contextor(m_contextor);
            return Marshal::GetObjectForIUnknown(contextor);
        }
    }

private:
    IContextor* m_contextor;
};

}
}
}
}
