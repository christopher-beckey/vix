/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 1/9/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
 * Description: 
 * 
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *       
 * 
 */

using System;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Serialization;
using VistA.Imaging.Telepathology.Common.Exceptions;
using VistA.Imaging.Telepathology.Logging;
using VistA.Imaging.Telepathology.Worklist.DataSource;
using VistA.Imaging.Telepathology.Worklist.Preferences;
using VistA.Imaging.Telepathology.Worklist.ViewModel;

namespace VistA.Imaging.Telepathology.Worklist
{
    public class UserPreferences
    {
        private static MagLogger Log = new MagLogger(typeof(UserPreferences));

        static UserPreferences _instance = new UserPreferences();

        public LayoutPreferences LayoutPreferences { get; private set; }

        public WorklistPreferences WorklistPreferences { get; private set; }

        public HealthSummaryPreferences HealthSummaryPreferences { get; private set; }

        public UserPreferences()
        {
            this.LayoutPreferences = new LayoutPreferences();
            this.WorklistPreferences = new WorklistPreferences();
            this.HealthSummaryPreferences = new HealthSummaryPreferences();
        }

        public static UserPreferences Instance
        {
            get
            {
                return _instance;
            }
        }

        public void Initialize()
        {
            _instance.Initialize(ViewModelLocator.DataSource);
        }

        /// <summary>
        /// Saves this instance.
        /// </summary>
        public void Save()
        {
            IWorkListDataSource dataSource = ViewModelLocator.DataSource;

            XmlWriterSettings settings = new XmlWriterSettings()
            {
                Encoding = Encoding.UTF8,
                OmitXmlDeclaration = true,
                Indent = false
            };

            // save layout preferences
            using (StringWriter output = new StringWriter())
            {
                XmlSerializer xs = new XmlSerializer(this.LayoutPreferences.GetType());

                using (XmlWriter writer = XmlWriter.Create(output, settings))
                {
                    xs.Serialize(writer, this.LayoutPreferences);
                }
                try
                {
                    dataSource.SavePreferences(GetLayoutLabel(), output.ToString());
                }
                catch (MagVixFailureException vfe)
                {
                    Log.Error("Failed to save layout preferences.", vfe);
                    System.Windows.MessageBox.Show("Could not save layout preferences.", "Error", System.Windows.MessageBoxButton.OK, System.Windows.MessageBoxImage.Error);
                }
            }

            // save filter preferences
            using (StringWriter output = new StringWriter())
            {
                XmlSerializer xs = new XmlSerializer(this.WorklistPreferences.GetType());

                using (XmlWriter writer = XmlWriter.Create(output, settings))
                {
                    xs.Serialize(writer, this.WorklistPreferences);
                }
                try 
                {
                    dataSource.SavePreferences("WLFILTERS", output.ToString());
                }
                catch (MagVixFailureException vfe)
                {
                    Log.Error("Failed to save filter preferences.", vfe);
                    System.Windows.MessageBox.Show("Could not save filter preferences.", "Error", System.Windows.MessageBoxButton.OK, System.Windows.MessageBoxImage.Error);
                }
            }

            // save health summary preferneces
            using (StringWriter output = new StringWriter())
            {
                XmlSerializer xs = new XmlSerializer(this.HealthSummaryPreferences.GetType());

                using (XmlWriter writer = XmlWriter.Create(output, settings))
                {
                    xs.Serialize(writer, this.HealthSummaryPreferences);
                }
                
                try
                {
                    dataSource.SavePreferences("HEALTHSUMMARY", output.ToString());
                }
                catch (MagVixFailureException vfe)
                {
                    Log.Error("Failed to save health summary preferences.", vfe);
                    System.Windows.MessageBox.Show("Could not save health summary preferences.", "Error", System.Windows.MessageBoxButton.OK, System.Windows.MessageBoxImage.Error);
                }
            }
        }

        private string StreamToString(MemoryStream ms)
        {
            StringWriter output = new StringWriter();


            return output.ToString();
        }

        private string GetLayoutLabel()
        {
            string label = "WLLAYOUT";
            Rectangle? totalWorkArea = null;

            foreach (Screen screen in Screen.AllScreens)
            {
                if (!totalWorkArea.HasValue)
                {
                    totalWorkArea = screen.WorkingArea;
                }
                else
                {
                    totalWorkArea = Rectangle.Union(totalWorkArea.Value, screen.WorkingArea);
                }
            }

            if (totalWorkArea.HasValue)
            {
                label = label + string.Format("_{0}_{1}", totalWorkArea.Value.Width, totalWorkArea.Value.Height);
            }

            return label;
        }

        private void Initialize(IWorkListDataSource dataSource)
        {
            // read layout preferences based on current monitor configuration
            string layoutPrefData = dataSource.ReadPreferences(GetLayoutLabel());
            if (!string.IsNullOrEmpty(layoutPrefData))
            {
                XmlSerializer serializer = new XmlSerializer(this.LayoutPreferences.GetType());
                
                using (StringReader reader = new StringReader(layoutPrefData))
                {
                    try
                    {
                        LayoutPreferences layoutPrefs = (LayoutPreferences)serializer.Deserialize(reader);
                        this.LayoutPreferences = layoutPrefs;
                    }
                    catch (Exception ex)
                    {
                        Log.Error("Could not apply layout preference.", ex);
                    }
                }
            }

            string worlistPrefData = dataSource.ReadPreferences("WLFILTERS");
            if (!string.IsNullOrEmpty(worlistPrefData))
            {
                using (StringReader strReader = new StringReader(worlistPrefData))
                using (XmlReader reader = XmlReader.Create(strReader))
                {
                    reader.Read();
                    if ((reader.MoveToContent() == XmlNodeType.Element) && (reader.LocalName == "WorklistPreferences"))
                    {
                        this.WorklistPreferences.ReadXml(reader);
                    }
                }
            }

            string hsPrefData = dataSource.ReadPreferences("HEALTHSUMMARY");
            if (!string.IsNullOrEmpty(hsPrefData))
            {
                XmlSerializer serializer = new XmlSerializer(this.HealthSummaryPreferences.GetType());

                using (StringReader reader = new StringReader(hsPrefData))
                {
                    try
                    {
                        HealthSummaryPreferences hsPrefs = (HealthSummaryPreferences)serializer.Deserialize(reader);
                        this.HealthSummaryPreferences = hsPrefs;
                    }
                    catch (Exception ex)
                    {
                        Log.Error("Could not apply health summery preferences.", ex);
                    }
                }
            }
        }
    }
}
