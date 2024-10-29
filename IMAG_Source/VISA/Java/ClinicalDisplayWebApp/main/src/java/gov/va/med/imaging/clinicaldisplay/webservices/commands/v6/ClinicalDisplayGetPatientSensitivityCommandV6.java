/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 18, 2010
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

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetPatientSensitivityCommand;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator6;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayGetPatientSensitivityCommandV6
extends AbstractClinicalDisplayGetPatientSensitivityCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PatientSensitiveCheckResponseType>
{
	public ClinicalDisplayGetPatientSensitivityCommandV6(String transactionId, String siteId, String patientId,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials)
	{
		super(siteId, patientId);
		ClinicalDisplayCommandCommonV6.setTransactionContext(credentials, transactionId);
	}

	@Override
	public Integer getEntriesReturned(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PatientSensitiveCheckResponseType translatedResult)
	{
		return null;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV6.clinicalDisplayV6InterfaceVersion;
	}

	@Override
	protected Class<gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PatientSensitiveCheckResponseType> getResultClass()
	{
		return gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PatientSensitiveCheckResponseType.class;
	}

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PatientSensitiveCheckResponseType translateRouterResult(
			PatientSensitiveValue routerResult) 
	throws TranslationException
	{
		return ClinicalDisplayTranslator6.translate(routerResult);
	}

}
