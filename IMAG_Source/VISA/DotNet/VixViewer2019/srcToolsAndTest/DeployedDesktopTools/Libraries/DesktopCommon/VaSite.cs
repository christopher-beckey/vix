using System.Collections.Generic;

namespace DesktopCommon
{
    public class VaSite : VisaSource
    {
        //siteName, siteNumber, siteAbbreviation, region, vistaServer, vistaPort, vixServer, vixPort
        public static VaSite AllSites = new VaSite("All", "*", "ALL", "0", "", 0, "all", 1);

        public string SiteName { get; set; }
        public string SiteAbbr { get; set; }
        public string VistaHost { get; set; }
        public int VistaPort { get; set; }
        public string VixHost { get; set; }
        public int VixPort { get; set; }
        public string RegionId { get; set; }
        public bool TestSite { get; set; }

        public new string DisplayName
        {
            get
            {
                string value = Name + " [" + SiteNumber + "]";
                if (TestSite)
                    value += " (TEST)";
                return value;
            }
        }

        public bool HasVix
        {
            get
            {
                return !string.IsNullOrWhiteSpace(VisaHost) && VisaPort > 0;
            }
        }

        public string SiteNumber
        {
            get
            {
                return ID;
            }
        }

        public bool IsVix
        {
            get
            {
                if (SiteNumber == "200")
                    return false;
                if (SiteNumber == "2002") // BHIE
                    return false;
                if (SiteNumber == "2003") // HAIMS
                    return false;
                if (SiteNumber == "2004") // NCAT
                    return false;
                if (SiteNumber == "2001") // excluding CVIX root host name (ugly!)
                    return false;
                if (SiteNumber.StartsWith("2001."))
                    return false;
                if (VistaHost.Length <= 0)
                    return false;
                if (VisaPort <= 0)
                    return false;
                return true;
            }
        }

        public bool IsVixOrCvix
        {
            get
            {
                return IsVix || IsCvix;
            }
        }

        public bool IsCvix
        {
            get
            {
                if (SiteNumber.StartsWith("2001."))
                {
                    return true;
                }
                return false;
            }
        }

        public VaSite(string name, string siteNumber, string siteAbbr, string regionId, string vistaHost, int vistaPort, string vixHost, int vixPort, bool testSite = false)
            : base(siteNumber, name, vistaHost, vistaPort)
        {
            this.SiteAbbr = siteAbbr;
            this.RegionId = regionId;
            this.VistaHost = vistaHost;
            this.VistaPort = vistaPort;
            this.VixHost = vixHost;
            this.VixPort = vixPort;
            this.TestSite = testSite;
        }

        public override int GetHashCode()
        {
            int i = SiteNumber.GetHashCode();
            return i;
        }

        public override bool Equals(object obj)
        {
            if (obj is VaSite)
            {
                VaSite that = (VaSite)obj;
                return this.SiteNumber.Equals(that.SiteNumber);
            }
            return false;
        }
        public int Compare(VaSite x, VaSite y)
        {
            return x.Name.CompareTo(y.Name);
        }
    }

    public class VaSiteKeyComparer : IEqualityComparer<VaSite>
    {
        public bool Equals(VaSite x, VaSite y)
        {
            return x.SiteNumber == y.SiteNumber;
        }

        public int GetHashCode(VaSite obj)
        {
            return obj.SiteNumber.GetHashCode();
        }
    }
}
