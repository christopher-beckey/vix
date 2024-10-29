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
using System.ComponentModel;
using Aga.Controls.Tree;
using VistA.Imaging.Telepathology.Common.Model;
using System.Diagnostics;

namespace VistA.Imaging.Telepathology.Worklist.Controls
{
    public class WorkListViewComparer
    {
        public static int Compare(TreeNode x, TreeNode y, string sortColumn)
        {
            try
            {
                TreeNode xt = (TreeNode)x;
                TreeNode yt = (TreeNode)y;

                Trace.WriteLine("Level " + xt.Level.ToString() + " and " + yt.Level.ToString());

                int result = 0;

                CaseListItem xc = (CaseListItem)xt.Tag;
                CaseListItem yc = (CaseListItem)yt.Tag;

                string valx = string.Empty, valy = string.Empty;
                switch (sortColumn)
                {
                    case "AccessionSlide#":
                        valx = xc.AccessionNumber;
                        valy = yc.AccessionNumber;
                        break;
                    //case "Lock":
                    //    valx = xc.LockedBy;
                    //    valy = yc.LockedBy;
                    //    break;
                    case "Priority":
                        valx = xc.Priority;
                        valy = yc.Priority;
                        break;
                    case "PatientID":
                        valx = xc.PatientID;
                        valy = yc.PatientID;
                        break;
                    case "PatientName":
                        valx = xc.PatientName;
                        valy = yc.PatientName;
                        break;
                    case "StudyDate":
                        valx = xc.StudyDateTime;
                        valy = yc.StudyDateTime;
                        break;
                    //case "StainType":
                    //    valx = xc.StainType;
                    //    valy = yc.StainType;
                    //    break;
                    //case "TissueSampleSite":
                    //    valx = xc.TissueSampleSite;
                    //    valy = yc.TissueSampleSite;
                    //    break;
                    case "AcquisitionSite":
                        valx = xc.AcquisitionSite;
                        valy = yc.AcquisitionSite;
                        break;
                    case "SpecimenCount":
                        valx = xc.SpecimenCount;
                        valy = yc.SpecimenCount;
                        break;
                    //case "SlideCount":
                    //    valx = xc.SlideCount;
                    //    valy = yc.SlideCount;
                    //    break;
                    //case "HasReport":
                    //    valx = xc.HasReport;
                    //    valy = yc.HasReport;
                    //    break;
                    case "ReportStatus":
                        valx = xc.ReportStatus;
                        valy = yc.ReportStatus;
                        break;
                    //case "HasNotes":
                    //    valx = xc.HasNotes;
                    //    valy = yc.HasNotes;
                    //    break;
                }

                result = String.Compare(valx, valy);
                Trace.WriteLine("Comparing " + valx + " and " + valy + " Result:" + result);

                return result;
            }
            catch (Exception)
            {
                return 0;
            }
        }
    }
}
