/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 16, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v6;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetImageInformationCommand;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayGetImageInformationCommandV6
extends AbstractClinicalDisplayGetImageInformationCommand
{
	public ClinicalDisplayGetImageInformationCommandV6(String imageId, String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials,
			boolean includeDeletedImages)
	{
		super(imageId, ClinicalDisplayCommandCommonV6.clinicalDisplayV6InterfaceVersion, includeDeletedImages);
		ClinicalDisplayCommandCommonV6.setTransactionContext(credentials, transactionId);
	}
}