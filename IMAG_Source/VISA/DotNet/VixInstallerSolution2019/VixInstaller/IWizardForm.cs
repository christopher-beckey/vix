using System;
using System.Collections.Generic;
using System.Text;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public interface IWizardForm
    {
        void EnableCancelButton(bool isEnabled);

        void EnableNextButton(bool isEnabled);

        void EnableBackButton(bool isEnabled);

        void EnableFinishButton(bool isEnabled);

        int GetWizardPageIndex(String fullyQualifiedWizardPageClassName);

        bool IsDeveloperMode();

        event EventHandler OnDevModeChange;

        IVixConfigurationParameters GetVixConfigurationParameters();

        MuseFacade GetMuseConfig();

        void LoadMuseConfig();
    }
}
