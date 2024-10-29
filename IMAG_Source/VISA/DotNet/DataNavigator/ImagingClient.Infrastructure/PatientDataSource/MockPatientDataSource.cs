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
using ImagingClient.Infrastructure.Model;

namespace ImagingClient.Infrastructure.PatientDataSource
{
    public class MockPatientDataSource : IPatientDataSource
    {

        public ObservableCollection<Patient> GetPatientList(string searchCriteria)
        {
            return new ObservableCollection<Patient>
                       {
                           CreatePatient(searchCriteria, 1),
                           CreatePatient(searchCriteria, 2),
                           CreatePatient(searchCriteria, 3),
                           CreatePatient(searchCriteria, 4),
                           CreatePatient(searchCriteria, 5)
                       };
        }

        public PatientSensitiveLevel GetPatientSensitivityLevel(string patientIcn)
        {
            PatientSensitiveLevel level = new PatientSensitiveLevel();
            level.SensitiveLevel = PatientSensitiveLevels.NoActionRequired;
            return level;
        }

        private Patient CreatePatient(String searchCriteria, int i)
        {
            String ctr = i.ToString();
            Patient patient = new Patient();
            patient.PatientName = searchCriteria + "_Patient_" + i;
            patient.Dob = "01/02/1950";
            patient.PatientSex = "M";
            patient.VeteranStatus = "Yes";
            patient.Ssn = ctr + ctr + ctr + "-" + ctr + ctr + "-" + ctr + ctr + ctr + ctr;
            patient.Dfn = ctr + ctr + ctr + ctr;
            patient.PatientIcn = ctr + ctr + ctr + "V" + ctr + ctr + ctr + ctr + ctr + ctr;
            return patient;
        }

    }
}
