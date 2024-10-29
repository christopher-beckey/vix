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
using GearCORELib;
using GearFORMATSLib;
using GearDISPLAYLib;
using GearPROCESSINGLib;
using GearMEDLib;
using GearPDFLib;
using VECTLib;

namespace IGToolkit
{

    

    public class IGComponentManager
    {
        private static IGComponentManager componentManager = new IGComponentManager();

        public static IGComponentManager getComponentManager()
        {
            // return componentManager;
            return new IGComponentManager();
        }


        private IGCoreCtl axIGCoreCtl;
        private IGDisplayCtl axIGDisplayCtl;
        private IGFormatsCtl axIGFormatsCtl;
        private IGProcessingCtl axIGProcessingCtl;
        private IGMedCtl axIGMedCtl;
        private IGPDFCtl axIGPDFCtl;
        private IGVectorCtl axIGVectorCtl;
        /*
        //private AxGearCORELib.AxIGCoreCtl axIGCoreCtl;
        private AxGearDISPLAYLib.AxIGDisplayCtl axIGDisplayCtl;
        private AxGearFORMATSLib.AxIGFormatsCtl axIGFormatsCtl;
        private AxGearPROCESSINGLib.AxIGProcessingCtl axIGProcessingCtl;
        private AxGearMEDLib.AxIGMedCtl axIGMedCtl;
        private AxGearPDFLib.AxIGPDFCtl axIGPDFCtl;
        private AxVECTLib.AxIGVectorCtl axIGVectorCtl;
        */

        //public AxGearCORELib.AxIGCoreCtl IGCoreCtrl
        public IGCoreCtl IGCoreCtrl
        {
            get { return axIGCoreCtl; }
        }

        public IGDisplayCtl IGDisplayCtrl
        {
            get { return axIGDisplayCtl; }
        }

        public IGMedCtl IGMedCtrl
        {
            get { return axIGMedCtl; }
        }

        public IGFormatsCtl IGFormatsCtrl
        {
            get { return axIGFormatsCtl; }
        }
        

        public IGComponentManager()
        {
            //axIGCoreCtl = new AxGearCORELib.AxIGCoreCtl();
            axIGCoreCtl = new IGCoreCtl();
            axIGDisplayCtl = new IGDisplayCtl();// AxGearDISPLAYLib.AxIGDisplayCtl();
            axIGFormatsCtl = new IGFormatsCtl();// AxGearFORMATSLib.AxIGFormatsCtl();
            axIGProcessingCtl = new IGProcessingCtl();// AxGearPROCESSINGLib.AxIGProcessingCtl();
            axIGPDFCtl = new IGPDFCtl();// AxGearPDFLib.AxIGPDFCtl();
            axIGVectorCtl = new IGVectorCtl();// AxVECTLib.AxIGVectorCtl();
            axIGMedCtl = new IGMedCtl();// AxGearMEDLib.AxIGMedCtl();

            /*
            ((System.ComponentModel.ISupportInitialize)(this.axIGCoreCtl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.axIGDisplayCtl)).BeginInit();
            //((System.ComponentModel.ISupportInitialize)(this.axIGPageViewCtl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.axIGFormatsCtl)).BeginInit();
            //((System.ComponentModel.ISupportInitialize)(this.axIGDlgsCtl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.axIGProcessingCtl)).BeginInit();
            //((System.ComponentModel.ISupportInitialize)(this.axIGGUIDlgCtl)).BeginInit();
            */
            //axIGCoreCtl.Result.NotificationFlags = GearCORELib.enumIGErrorHandlingFlags.IG_ERR_OLE_ERROR;

            StringBuilder licenseKey = new StringBuilder();
            licenseKey.Append("1.0.RiRL10JLtjbIJZt2E9k2cLRmRvcsw9EmPIwmJFEvwswFE4wstD69b4wsPmPX727DC91Zn0CFkmz4JjwDt9b0PsJFn0CjCIzLR2zZtvwgbXc2zmCDA9");
            licenseKey.Append("tsc0tmA9zX6g7vnjcXnDJ9zj10Aj7mksEiw2AmcFbXJIALt4bI6mzFPinXcmngEDtR1ZzIkF1D1XnIcFwF6sw9zgbD64Cmzics6mkIcsw");
            licenseKey.Append("Fnm72c9Rgzj7ikD1gk26L1ZAZJI7vnDcsk0EZCXAZ7Lk4nF1InIn4P0wjCj19nDnZJD7sEXzscv7I7ZzZtX70ni6DnvAiz9EmzjPv6gCZ");
            licenseKey.Append("CF1jCLzgw2JDkXE2tDc01FAj1itIz4626Un24");

            /*
            this.axIGCoreCtl.Enabled = true;
            System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(IGComponentManager));
            this.axIGCoreCtl.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axIGCoreCtl1.OcxState")));
            */
            axIGCoreCtl.License.SetSolutionName("Vista");
            axIGCoreCtl.License.SetSolutionKey(unchecked((int)3187320571), unchecked((int)2640663994), 
                unchecked((int)3596556560), unchecked((int)2787111168));
            axIGCoreCtl.License.SetOEMLicenseKey(licenseKey.ToString());

            axIGCoreCtl.AssociateComponent(axIGFormatsCtl.ComponentInterface);
            axIGCoreCtl.AssociateComponent(axIGDisplayCtl.ComponentInterface);
            axIGCoreCtl.AssociateComponent(axIGProcessingCtl.ComponentInterface);
            axIGCoreCtl.AssociateComponent(axIGPDFCtl.ComponentInterface);
            axIGCoreCtl.AssociateComponent(axIGMedCtl.ComponentInterface);
            axIGCoreCtl.AssociateComponent(axIGVectorCtl.ComponentInterface);

            IIGComponent igComp = null;

            igComp = axIGCoreCtl.CreateComponent("GearJPEG2K.IGJPEG2K.15");
            axIGCoreCtl.AssociateComponent(igComp.ComponentInterface);

            IGFormatParams dcm, temp = null;

            for (int i = 0; i < axIGFormatsCtl.Settings.FormatCount; i++)
            {
                temp = axIGFormatsCtl.Settings.get_Format(i);
                if (temp.ID == enumIGFormats.IG_FORMAT_DCM)
                {
                    dcm = temp;
                    dcm.DetectionPriority = 1100;
                }
            }
        }

        

    }
}
