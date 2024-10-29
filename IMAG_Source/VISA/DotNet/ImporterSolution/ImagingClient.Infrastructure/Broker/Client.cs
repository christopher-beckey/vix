using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Broker
{
    public class Client
    {
        private Connection currentConnection;
        private string siteServiceURL;
        private string applicationLabel;
        private string passCode;

        public Connection CurrentConnection
        {
            get { return this.currentConnection; }
            set { this.currentConnection = value; }
        }

        public string SiteServiceURL
        {
            get { return this.siteServiceURL; }
            set { this.siteServiceURL = value; }
        }

        public string ApplicationLabel
        {
            get { return this.applicationLabel; }
            set { this.applicationLabel = value; }
        }

        public string PassCode
        {
            get { return this.passCode; }
            set { this.passCode = value; }
        }

        public Client()
        {
            currentConnection = null;
        }

        public Connection Connect()
        {
            return DoConnect("", 0, "");
        }

        public void Close()
        {
            if (currentConnection != null)
            {
                currentConnection.Close();
                currentConnection = null;
            }
        }

        private Connection DoConnect(string server, int port, string securityToken)
        {
            Connection conn = new Connection();
            if (conn.Connect(server, port, securityToken, ApplicationLabel, PassCode) == 1)
            {
                // for now set as default connection
                currentConnection = conn;

                return conn;
            }

            return null;
        }
    }
}
