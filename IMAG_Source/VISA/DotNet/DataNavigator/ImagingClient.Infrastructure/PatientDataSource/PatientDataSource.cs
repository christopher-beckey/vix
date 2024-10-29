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
using System.Collections.ObjectModel;
using System.Configuration;
using ImagingClient.Infrastructure.Model;
using ImagingClient.Infrastructure.Rest;

namespace ImagingClient.Infrastructure.PatientDataSource
{
    public class PatientDataSource : IPatientDataSource
    {
        private String PatientServiceUrl = "PatientWebApp";

        public ObservableCollection<Patient> GetPatientList(string searchCriteria)
        {
            String resourcePath = String.Format("patient/getPatientList?searchCriteria={0}", searchCriteria);
            return RestUtils.DoGetObject<ObservableCollection<Patient>>(PatientServiceUrl, resourcePath);
        }

        public PatientSensitiveLevel GetPatientSensitivityLevel(string patientIcn)
        {
            String resourcePath = String.Format("patient/getPatientSensitivityLevel?patientIcn={0}", patientIcn);
            return RestUtils.DoGetObject<PatientSensitiveLevel>(PatientServiceUrl, resourcePath);
        }


    }
}
