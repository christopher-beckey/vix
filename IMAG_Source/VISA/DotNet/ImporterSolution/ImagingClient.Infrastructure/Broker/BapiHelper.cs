using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Broker
{
    public class BapiHelper
    {
        private bool initialized;
        private IntPtr broker;
        private string userName;
        private string userSSN;
        private string userDUZ;
        private string siteName;
        private string siteNumber;
        private string division;
        private string server;
        private int port;
        private bool connected;

        public string UserName
        {
            get { return this.userName; }
            set { this.userName = value; }
        }

        public string UserSSN
        {
            get { return this.userSSN; }
            set { this.userSSN = value; }
        }

        public string UserDUZ
        {
            get { return this.userDUZ; }
            set { this.userDUZ = value; }
        }

        public string SiteName
        {
            get { return this.siteName; }
            set { this.siteName = value; }
        }

        public string SiteNumber
        {
            get { return this.siteNumber; }
            set { this.siteNumber = value; }
        }

        public string Division
        {
            get { return this.division; }
            set { this.division = value; }
        }

        public string Server
        {
            get { return this.server; }
            set { this.server = value; }
        }

        public int Port
        {
            get { return this.port; }
            set { this.port = value; }
        }

        public bool Connected
        {
            get { return this.connected; }
            set { this.connected = value; }
        }

        public BapiHelper()
        {
            //this.contextor = null;
        }

        //virtual ~BapiHelper()
        //{
        //    this.Close();
        //}

        public void Close()
        {
            //if (this.contextor != null)
            //    this.contextor = null;

            if (this.broker != null)
            {
                Bapi32_65.RpcbFree(this.broker);
                broker = IntPtr.Zero;
            }

            this.initialized = false;
        }

        public bool Initialize()
        {
            if (!this.initialized)
            {
                this.broker = Bapi32_65.RpcbCreate();
                this.initialized = true;
            }

            return this.initialized;
        }

        public void SetProperty(string name, string value)
        {
            Bapi32_65.RpcbPropSet(this.broker, name, value);
        }

        public string GetProperty(string name)
        {
            StringBuilder value = new StringBuilder(256);
            Bapi32_65.RpcbPropGet(this.broker, name, value);
            return value.ToString();
        }

        public void SetUserProperty(string name, string value)
        {
            Bapi32_65.RpcbUserPropSet(this.broker, name, value);
        }

        public string GetUserProperty(string name)
        {
            StringBuilder value = new StringBuilder(256);
            Bapi32_65.RpcbUserPropGet(this.broker, name, value);
            return value.ToString();
        }

        public void SetParameter(int paramIndex, int paramType, string paramValue)
        {
            Bapi32_65.RpcbParamSet(this.broker, paramIndex, paramType, paramValue);
        }

        public void SetParameterItem(int paramIndex, int paramItemIndex, string paramValue)
        {
            Bapi32_65.RpcbMultSet(this.broker, paramIndex, paramItemIndex.ToString(), paramValue);
        }

        public string CallMethod()
        {
            StringBuilder response = new StringBuilder(512);
            Bapi32_65.RpcbCall(this.broker, response);
            return response.ToString();
        }

        public int InitializeCCOW(string applicationLabel, string passcode)
        {
            int ret = 0;

            try
            {
                //TLB - 2FA Implementation:
                //RpcbContextorCreate and RpcbContextorReset are not available in Bapi32_65
                //Need to revisit CCOW functionality and refactor


                //long rpcContextor = RpcbContextorCreate(this.broker, "");
                //this.contextor = new ContextorHelper(rpcContextor);
                //if (!this.contextor.Run(applicationLabel, passcode))
                //{
                //    RpcbContextorReset(this.broker);
                //    this.contextor = null;
                //}
            }
            catch //(Exception ex)
            {
                ret = 0;
            }

            return ret;
        }

        public int Login(string server, int port, string securityToken)
        {
            int ret = 0;

            StringBuilder serverPtr = new StringBuilder(256);
            StringBuilder portPtr = new StringBuilder(256);

            try
            {
                serverPtr.Append(server);
                portPtr.Append(port.ToString());

                SetProperty("ShowErrorMsgs", "1");
                Bapi32_65.RpcbGetServerInfo(serverPtr, portPtr, ref ret);

                if (ret == 1)
                {
                    this.server = serverPtr.ToString();
                    this.port = int.Parse(portPtr.ToString());

                    // set connection properties
                    SetProperty("Server", serverPtr.ToString());
                    SetProperty("ListenerPort", portPtr.ToString());

                    // set connected propery to TRUE to connect
                    SetProperty("Connected", "1");

                    // check if connection succeeded
                    string connProp = GetProperty("Connected");
                    bool connected = (connProp == "1");

                    if (connected)
                    {
                        // get properties
                        this.userName = GetUserProperty("NAME");
                        this.userDUZ = GetUserProperty("DUZ");
                        this.siteNumber = this.division = GetUserProperty("DIVISION");
                        this.siteName = string.Empty;  //Can we retrieve SiteName from different properties???
                        
                        //Division or SiteNumber is all that is returned in Bapi32_65
                        //Below is no longer valid

                        //string tempDiv = GetUserProperty("DIVISION");
                        //string[] tokens = tempDiv.Split('^');
                        //this.siteNumber = (tokens != null && tokens.Length > 0) ? tokens[0] : string.Empty;
                        //this.siteName = (tokens != null && tokens.Length > 1) ? tokens[1] : string.Empty;
                        //this.division = (tokens != null && tokens.Length > 2) ? tokens[2] : string.Empty;
                    }
                    else
                    {
                        // user cancelled
                        return 0;
                    }
                }
            }
            catch //(Exception ex)
            {
                ret = 0;
            }

            return ret;
        }
    }
}
