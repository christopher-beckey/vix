using System;
using System.Collections.Generic;
using System.Text;

namespace MavenBuilder2
{
    public abstract class BaseAction
    {
        protected MavenBuilderConfiguration mavenBuilderConfiguration;
        protected LogMessageDelegate logMsgDelegate;
        protected event ActionCompleteDelegate OnActionComplete;

        public BaseAction(MavenBuilderConfiguration mavenBuilderConfiguration, LogMessageDelegate logMsgDelegate)
        {
            this.mavenBuilderConfiguration = mavenBuilderConfiguration;
            this.logMsgDelegate = logMsgDelegate;
        }

        protected void LogMsg(string msg)
        {
            logMsgDelegate(msg);
        }

        protected void ActionComplete(bool result)
        {
            if (OnActionComplete != null)
                OnActionComplete(result);
        }

        public ActionCompleteDelegate OnActionCompleteEvent
        {
            get
            {
                return OnActionComplete;
            }
            set
            {
                OnActionComplete += value;
            }
        }
    }
}
