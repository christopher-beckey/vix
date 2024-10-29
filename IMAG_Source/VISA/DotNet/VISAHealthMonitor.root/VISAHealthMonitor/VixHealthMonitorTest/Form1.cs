using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using VISAHealthMonitorCommon.wiki;
using VISAHealthMonitorCommon.jmx;
using VISACommon;
using System.Xml;
using VISAHealthMonitorCommon.certificates;

namespace VixHealthMonitorTest
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                Config wikiConfiguration = new Config();
                wikiConfiguration.WikiRootUrl = "http://vhaiswimmixvi1:8080/wiki/Wiki.jsp";
                List<VixAdministrator> administrators = VixAdministratorsHelper.GetSiteAdministrators(wikiConfiguration, "660", 30);
                foreach (VixAdministrator administrator in administrators)
                {
                    richTextBox1.AppendText(administrator.ToString() + Environment.NewLine);
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        class Config : WikiConfiguration
        {
            public string WikiRootUrl { get; set; }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                richTextBox1.Text = "";
                VaSite site = new VaSite("Fayetteville, NC", "565", "FNC", "6", null, 0, "vhafncclu1a.v06.med.va.gov", 8080);

                string value = JmxUtility.GetJmxBeanValue(site, KnownJmxAttribute.SystemProperties);
                JmxSystemProperties systemProperties = JmxSystemProperties.Parse(value);

                foreach (string key in systemProperties.Values.Keys)
                {
                    richTextBox1.AppendText(key + "=" + systemProperties.Values[key] + Environment.NewLine);
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                richTextBox1.AppendText(CertificateHelper.GetCertificateExpirationDate(new VaSite("CVIX1", "2001.1", "CVIX1", "10", "", 9300, "vhacvixnode1.r04.med.va.gov", 80)) + Environment.NewLine);

                //CertificateHelper.DownloadSslCertificate("vhacvixnode1.r04.med.va.gov");

            }
            catch (Exception ex)
            {
                richTextBox1.AppendText("Exception: " + ex.Message + Environment.NewLine);
            }
        }
    }
}
