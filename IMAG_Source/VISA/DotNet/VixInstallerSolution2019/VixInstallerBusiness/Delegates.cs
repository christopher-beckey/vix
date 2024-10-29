using System;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    /// <summary>
    /// This delegate provides the means for business layer code to write a message to the textBoxInfo control. It maps to the
    /// Info method.
    /// </summary>
    /// <param name="infoMessage">The message string to be displayed on a new textbox line.</param>
    /// <returns></returns>
    public delegate String InfoDelegate(String infoMessage);

    /// <summary>
    /// This delegate allows business layer code to keep the UI responsive during extended processing.
    /// </summary>
    public delegate void AppEventsDelegate();
}

