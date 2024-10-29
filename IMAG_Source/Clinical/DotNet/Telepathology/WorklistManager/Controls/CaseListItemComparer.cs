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
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VistA.Imaging.Telepathology.Common.Model;
using System.Diagnostics;
using System.Globalization;

namespace VistA.Imaging.Telepathology.Worklist.Controls
{
    public class CaseListItemComparer
    {
        public static int Compare(CaseListItem item1, CaseListItem item2, CaseListColumnType field, bool ascending)
        {
            int result = 0;
            string valx = string.Empty, valy = string.Empty;

            switch (field)
            {
                case CaseListColumnType.Description:
                    valx = item1.Description;
                    valy = item2.Description;
                    break;
                case CaseListColumnType.Site:
                    valx = item1.SiteAbbr;
                    valy = item2.SiteAbbr;
                    break;
                case CaseListColumnType.ReservedBy:
                    valx = item1.ReservedBy;
                    valy = item2.ReservedBy;
                    break;
                case CaseListColumnType.PatientID:
                    valx = item1.PatientID;
                    valy = item2.PatientID;
                    break;
                case CaseListColumnType.PatientName:
                    valx = item1.PatientName;
                    valy = item2.PatientName;
                    break;
                case CaseListColumnType.DateTime:
                    {
                        // special handling for date
                        DateTime date1, date2;

                        if (DateTime.TryParseExact(item1.DateTime, "MM-dd-yyyy HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out date1) &&
                            DateTime.TryParseExact(item2.DateTime, "MM-dd-yyyy HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out date2))
                        {
                            result = ascending ? date1.CompareTo(date2) : date2.CompareTo(date1);
                        }
                    }
                    valx = item1.DateTime;
                    valy = item2.DateTime;
                    break;
                case CaseListColumnType.SpecimenCount:
                    valx = item1.SpecimenCount;
                    valy = item2.SpecimenCount;
                    break;
                case CaseListColumnType.ConsultationStatus:
                    valx = item1.ConsultationStatus;
                    valy = item2.ConsultationStatus;
                    break;
                case CaseListColumnType.ReportStatus:
                    valx = item1.ReportStatus;
                    valy = item2.ReportStatus;
                    break;
                case CaseListColumnType.HasNotes:
                    //valx = item1.HasNotes;
                    //valy = item2.HasNotes;
                    valx = item1.IsNoteAttached;
                    valy = item2.IsNoteAttached;
                    break;
            }

            if (field != CaseListColumnType.DateTime)
            {
                result = ascending ? String.Compare(valx, valy) : -String.Compare(valx, valy);
            }

            if ((result == 0) && (field != CaseListColumnType.Description))
            {
                // finally compare using description
                result = Compare(item1, item2, CaseListColumnType.Description, true);
            }
            Trace.WriteLine("Comparing " + valx + " and " + valy + " Result:" + result);

            return result;
        }
    }
}
