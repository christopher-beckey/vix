﻿/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/20/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
 * Developer:  Lenard Williams
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

namespace DicomImporter.Common.Model
{
    using System;

    /// <summary>
    /// Contains the different media categories allowed in the
    /// DICOM Importer.
    /// </summary>
    public static class Services
    {
        #region Constants and Fields

        public const string Radiology = "Radiology";

        public const string Consult = "Consult";

        public const string Lab = "Lab";

        public const string None = "None";
        #endregion

        #region Public Methods

        public static bool IsService(string service)
        {
            switch (service)
            {
                case Radiology:
                case Consult:
                case Lab:
                case None:
                    return true;
            }

            return false;
        }

        #endregion
    }
}
