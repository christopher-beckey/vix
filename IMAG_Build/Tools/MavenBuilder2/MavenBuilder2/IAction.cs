using System;
using System.Collections.Generic;
using System.Text;

namespace MavenBuilder2
{
    public delegate void ActionCompleteDelegate(bool result);

    public interface IAction
    {
        void execute();

        ActionCompleteDelegate OnActionCompleteEvent
        {
            get;
            set;
        }

        string ActionName
        {
            get;
        }
    }
}
