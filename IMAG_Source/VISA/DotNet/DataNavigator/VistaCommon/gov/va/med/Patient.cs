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

namespace VistaCommon.gov.va.med
{
    public class Patient
    {

        public string PatientIcn { get; private set; }
        public string PatientName { get; set; }
        public string VeteranStatus { get; set; }
        public string DateOfBirth { get; set; }
        public string PatientSex { get; set; }

        /// <summary>
        /// might want to remove this...
        /// </summary>
        protected List<SiteAddress> visitedSites = new List<SiteAddress>();

        public List<SiteAddress> VisitedSites
        {
            get { return visitedSites; }
        }


        public Patient(string patientIcn, string patientName)
        {
            PatientIcn = patientIcn;
            PatientName = patientName;
        }
        public Patient(string patientIcn) : this(patientIcn, "") {}

        public override string ToString()
        {
            return PatientName;
        }
    }
}
