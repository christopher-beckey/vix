/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 4/11/2012
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
using System.ComponentModel;

namespace VistA.Imaging.Telepathology.CCOW
{
    public interface IContextManager : INotifyPropertyChanged
    {
        string ApplicationLabel { get; set; }

        string Passcode { get; set; }

        string SiteID { get; set; }

        bool ProductionAccount { get; set; }

        ContextState ContextState { get; }

        ContextData CurrentContext { get; set; }

        VERGENCECONTEXTORLib.Contextor Contextor { get; set; }

        void Run();

        void Suspend();

        void Resume();

        void ResumeSet(Object context);

        void ResumeGet();

        void SetCurrentPatient(Patient patient);

        PatientContextState GetPatientContextState(Patient patient);

        bool IsBusy { get; set; }

        void Close();
    }
}
