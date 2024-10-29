using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VixHealthMonitor.messages
{
    /// <summary>
    /// This message is sent just before the configuration properties are saved to disk. 
    /// This message indicates anyone listening should save properties they are aware of so they can be stored to disk
    /// </summary>
    public class SaveConfigurationPropertiesMessage
    {
    }
}
