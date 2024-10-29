using Hydra.Common.Exceptions;
using Hydra.IX.Common;
using Nancy;
using Nancy.ModelBinding;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class SettingsModule : HixModule
    {
        public SettingsModule(IHixRequestHandler handler)
            : base("settings")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddPost("/", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.CreateEventLogRecord, this, parameters);
                });

            AddGet("/", parameters =>
            {
                var items = handler.GetEventLogItems(null, null);
                if (items == null)
                    items = new List<EventLogItem>();

                return View["EventLogView.cshtml", items];
            });
        }
    }
}
