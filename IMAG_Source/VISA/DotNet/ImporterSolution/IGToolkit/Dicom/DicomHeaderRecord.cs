/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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
 */


using System;
using System.Collections.Generic;
using System.Text;

namespace IGToolkit.Dicom
{
    public class DicomHeaderRecord
    {
        public int TagIndex { get; set; }
        public String Tag { get; set; }
        public String IndentedTag { get { return GetIndentation() + Tag; } }
        public String TagName {  get; set; }
        public String ValueRepresentation { get; set; }  
        public String ValueLength { get; set; }  
        public String ValueMultiplicity { get; set; }  
        public int Level { get; set; }  
        public String DataValue { get; set; }

        private string GetIndentation()
        {
            String indentation = String.Empty;
            for (int i = 0; i < Level; i++)
            {
                indentation += ">";
            }
            return indentation;
        }


        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();
            builder.Append(TagIndex.ToString().PadRight(3) + ": ");
            builder.Append(IndentedTag + " ");
            builder.Append(ValueRepresentation + " ");
            builder.Append(ValueLength + " ");
            builder.Append(ValueMultiplicity + " ");
            builder.Append(Level + " ");
            builder.Append(TagName + ": ");
            builder.Append(DataValue);
            return builder.ToString();
        }
    }
}
