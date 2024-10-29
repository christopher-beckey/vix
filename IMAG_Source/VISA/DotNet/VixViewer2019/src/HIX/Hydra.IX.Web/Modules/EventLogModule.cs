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
    public class EventLogModule : HixModule
    {
        public EventLogModule(IHixRequestHandler handler) : base("events")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddPost("/", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.CreateEventLogRecord, this, parameters);
                });

            AddGet("/", _ => GetEventLogItems(handler));
        }

        Response GetEventLogItems(IHixRequestHandler handler)
        {
            try
            {
                var requestParams = (this.Context.Request.Query as Nancy.DynamicDictionary).ToDictionary();
                object value = null;
                int pageSize = -1;
                int pageIndex = -1;

                requestParams.TryGetValue("pageSize", out value);
                if (((value != null) && (value is string)))
                {
                    int.TryParse(value as string, out pageSize);
                }

                requestParams.TryGetValue("pageIndex", out value);
                if (((value != null) && (value is string)))
                {
                    int.TryParse(value as string, out pageIndex);
                }

                var items = handler.GetEventLogItems((pageSize == -1 ? null : (int?)pageSize), (pageIndex == -1 ? null : (int?)pageIndex));
                if (items == null)
                    items = new List<EventLogItem>();

                return this.Response.AsJson<List<EventLogItem>>(items.ToList());
            }
            catch (Exception ex)
            {
                Response resp = ex.ToString();
                resp.StatusCode = HttpStatusCode.InternalServerError;

                return resp;
            }
        }
    }
}
