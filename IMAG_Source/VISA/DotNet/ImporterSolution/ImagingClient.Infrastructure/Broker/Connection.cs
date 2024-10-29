using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Broker
{
    public class Connection
    {
        private BapiHelper broker;

        private string securityToken;

        public string UserName
        {
            get { return this.broker.UserName; }
        }

        public string UserSSN
        {
            get { return this.broker.UserSSN; }
        }

        public string UserDUZ
        {
            get { return this.broker.UserDUZ; }
        }

        public string SiteName
        {
            get { return this.broker.SiteName; }
        }

        public string SiteNumber
        {
            get { return this.broker.SiteNumber; }
        }

        public string Division
        {
            get { return this.broker.Division; }
        }

        public string Server
        {
            get { return this.broker.Server; }
        }

        public int Port
        {
            get { return this.broker.Port; }
        }

        public string SecurityToken
        {
            get { return this.securityToken; }
            set { this.securityToken = value; }
        }

        public Connection()
        {
            this.broker = new BapiHelper();
        }

        //virtual ~Connection()
        //{
        //    this.Close();
        //}

        public void Close()
        {
            if (broker != null)
            {
                this.broker.Close();
                this.broker = null;
            }
        }

        public Response Execute(Request request)
        {
            Response response = new Response();

            int paramIndex = 0;
            broker.SetProperty("RemoteProcedure", request.MethodName);
            
            foreach(Parameter param in request.Parameters)
            {
                if (param.Type == ParameterType.List)
                {
                    int paramItemIndex = 0;
                    broker.SetParameter(paramIndex, (int)param.Type, "");
                    
                    List<string> list = (List<string>)param.Value;
                    foreach(string item in list)
                    {
                        broker.SetParameterItem(paramIndex, paramItemIndex++, item);
                    }
                }
                else
                {
                    broker.SetParameter(paramIndex, (int)param.Type, (string)param.Value);
                }

                paramIndex++;
            }

            response.RawData = broker.CallMethod();

            return response;
        }

        public int Connect(string server, int port, string securityToken, string applicationLabel, string passcode)
        {
            int ret = 0;

            this.broker.Initialize();
            this.securityToken = securityToken;

            //TLB - 2FA Implementation:
            //RpcbContextorCreate and RpcbContextorReset are not available in Bapi32_65
            //Need to revisit CCOW functionality and refactor

            //broker.InitializeCCOW(applicationLabel, passcode);

            ret = this.broker.Login(server, port, securityToken);

            return ret;
        }
    }
}
