using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Xsl;

namespace Hydra.Dicom
{
    public class XmlProcessor
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static void ConvertToHtml(string filename, string xslFolder, Stream outputStream)
        {
            try
            {
                // first parse xml and extract the processing instruction
                var xmlDoc = new XmlDocument();
                xmlDoc.Load(filename);

                string xslFilename = null;

                // look for xml-stylesheet processing instruction
                var node = xmlDoc.SelectSingleNode("/processing-instruction('xml-stylesheet')")
                    as XmlProcessingInstruction;
                if (node != null)
                {
                    string[] spaceTokens = node.Value.Split(' ');
                    foreach (var x in spaceTokens)
                    {
                        if (x.ToLower().Contains("href"))
                        {
                            string[] valueTokens = x.Split('=');
                            if (valueTokens.Length >= 2)
                                xslFilename = valueTokens[1].Trim('\'', '\"');

                            break;
                        }
                    };
                }

                if (string.IsNullOrEmpty(xslFilename))
                    throw new Exception("No stylesheet reference found");

                xslFilename = Path.Combine(xslFolder, xslFilename);
                if (!File.Exists(xslFilename))
                    throw new Exception("Stylesheet file not found");

                using (XmlReader xrt = XmlReader.Create(xslFilename))
                {
                    var xslt = new XslCompiledTransform();
                    xslt.Load(xrt);

                    using (StringWriter sw = new StringWriter())
                    using (XmlWriter xwo = XmlWriter.Create(sw, xslt.OutputSettings)) // use OutputSettings of xsl, so it can be output as HTML
                    {
                        xslt.Transform(xmlDoc, xwo);

                        StreamWriter writer = new StreamWriter(outputStream);
                        writer.Write(sw.ToString());
                        writer.Flush();
                        outputStream.Position = 0;
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }
    }
}
