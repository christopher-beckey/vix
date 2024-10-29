using System;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Text;
using System.Xml;
using System.Windows.Forms;
using System.Xml.Serialization;
using Hydra.VistA;
using Hydra.VistA.Parsers;

namespace SCIP_Tool
{
    public partial class FormStudy : Form
    {
        private string logFilePath = "";
        private readonly StringBuilder sb = new StringBuilder();
        private readonly string sampleStudyXml = SampleStudyXml();
        private readonly string sampleStudyXmlPath = SampleStudyXmlPath();

        public FormStudy()
        {
            InitializeComponent();
            Directory.CreateDirectory(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Log"));
            logFilePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Log", DateTime.Now.ToString("yyyyddMHHmm") + ".log");
            tbInput.Text = sampleStudyXml;
            ResetLabelInfo();
            //this.Width = 1054;
            //this.Height = 532;
            this.CenterToScreen();
        }

        #region Form Controls

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void ButtonParse_Click(object sender, EventArgs e)
        {
            Parse();
        }

        private void ButtonExecute_Click(object sender, EventArgs e)
        {
            PseudoExecute();
        }

        private void ButtonCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion Form Controls

        private void Parse()
        {
            ResetLabelInfo();
            StudyMetadataParser.ParsePatientStudyQueryReponse(tbInput.Text, "0000000000V999999", "");
            AppendText("Done{0}", Environment.NewLine);
            ButtonClose.Enabled = true;
        }

        private void PseudoExecute()
        {
            try
            {
                //PseudoModule pseudoModule = new PseudoModule("vix/viewer");
                //StudyQuery studyQuery = new StudyQuery();

                //XmlSerializer s = new XmlSerializer(typeof(StudyQuery));
                //StreamReader streamReader = new StreamReader(SampleStudyXmlPath());
                //streamReader.ReadToEnd();
                //StudyQuery studyQuery = (StudyQuery)s.Deserialize(streamReader);
                //streamReader.Close();

                XmlSerializer s = new XmlSerializer(typeof(StudyQuery));
                StudyQuery studyQuery;
                using (XmlReader reader = XmlReader.Create(SampleStudyXmlPath()))
                {
                    studyQuery = (StudyQuery)s.Deserialize(reader);
                }
                AppendText("Done{0}", Environment.NewLine);
            }
            catch (Exception ex)
            {
                AppendText(ex.ToString(), Environment.NewLine); ;
            }
        }

        public void AppendText(string format, params object[] args)
        {
            sb.AppendFormat(format, args);
            LogTheLine(string.Format(format, args));
            this.tbOutput.Text = sb.ToString();
            if (format == "Done")
                ButtonClose.Focus();
            Application.DoEvents();
        }

        private void LogTheLine(string theLine)
        {
            if (!File.Exists(logFilePath))
            {
                using (StreamWriter sw = File.CreateText(logFilePath))
                {
                    sw.WriteLine(DateTime.Now.ToString("yyyyddMHHmmss") + "\t" + theLine.TrimEnd('\r', '\n'));
                }
            }
            else
            {
                using (StreamWriter sw = File.AppendText(logFilePath))
                {
                    sw.WriteLine(DateTime.Now.ToString("yyyyddMHHmmss") + "\t" + theLine.TrimEnd('\r', '\n'));
                }
            }
        }

        private void ResetLabelInfo()
        {
            this.lblInfo.Text = "";
            this.lblInfo.ForeColor = Color.Black;
        }

        private void UIError(string msg)
        {
            this.lblInfo.Text = msg;
            this.lblInfo.ForeColor = Color.Red;
        }

        private static string SampleStudyXmlPath()
        {
            return Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"StudyTools\Sample1.xml");
        }

        private static string SampleStudyXml()
        {
            using (StreamReader reader = new StreamReader(SampleStudyXmlPath()))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
