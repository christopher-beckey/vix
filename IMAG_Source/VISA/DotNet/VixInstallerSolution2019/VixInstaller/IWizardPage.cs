using System;
using System.Collections.Generic;
using System.Text;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    interface IWizardPage
    {
        bool IsComplete();
        int GetNextPageIndex();
        void Initialize();
        void RegisterDevModeChangeHandler();
        void UnregisterDevModeChangeHandler();
    }
}
