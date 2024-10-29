using ClearCanvas.Dicom;
using HtmlAgilityPack;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    internal class SRDocument
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        DicomFile _file;
        StringBuilder _stringBuilder;

        internal SRDocument(DicomFile file)
        {
            _file = file;
        }

        internal string WriteHTML()
        {
            _stringBuilder = new StringBuilder();

            try
            {
                DSRDocument document = new DSRDocument();
                if (document.read(_file.DataSet, DSRTypes.RF_ignoreContentItemErrors).good())
                {
                    StringBuilder result = new StringBuilder();
                    //document.print(ref result);
                    document.renderHTML(ref result, DSRTypes.HF_renderAllCodes | DSRTypes.HF_XHTML11Compatibility);

                    _stringBuilder.Append(result);
                }
                else
                {
                    _stringBuilder.Append("Error reading dataset.");
                }
            }
            catch (Exception ex)
            {
                _stringBuilder.Append(ex.Message);
            }

            // parse html and strip body
            return GetHtmlBody();
        }

        internal void WriteHTML(StreamWriter writer)
        {
            writer.Write(WriteHTML());
        }

        void CaptureOutput(object sender, DataReceivedEventArgs e)
        {
            _stringBuilder.Append(e.Data);
        }

        void CaptureError(object sender, DataReceivedEventArgs e)
        {
            _stringBuilder.Append(e.Data);
        }

        string GetHtmlBody()
        {
            string content = _stringBuilder.ToString();
            StringBuilder stringBuilder = new StringBuilder();

            HtmlDocument doc = new HtmlDocument();
            doc.LoadHtml(content);

            HtmlNode body = null;
            if ((doc.DocumentNode != null) && ((body = doc.DocumentNode.SelectSingleNode("/html/body")) != null))
                stringBuilder.Append(body.WriteContentTo());
            else
            {
                // error reading SR file
                if (string.IsNullOrEmpty(content))
                    content = @"Error reading SR file.";

                stringBuilder.Append("<div>");
                stringBuilder.Append(HtmlDocument.HtmlEncode(content));
                stringBuilder.Append("</div>");
            }

            return stringBuilder.ToString();
        }

        void WriteHtmlBodyOnly(StreamWriter writer)
        {
            string content = _stringBuilder.ToString();

            HtmlDocument doc = new HtmlDocument();
            doc.LoadHtml(content);

            HtmlNode body = null;
            if ((doc.DocumentNode != null) && ((body = doc.DocumentNode.SelectSingleNode("/html/body")) != null))
                body.WriteContentTo(writer);
            else
            {
                // error reading SR file
                if (string.IsNullOrEmpty(content))
                    content = @"Error reading SR file.";

                writer.Write("<div>");
                writer.Write(HtmlDocument.HtmlEncode(content));
                writer.Write("</div>");
            }
        }
    }
}
