/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 19, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v5;

import java.math.BigInteger;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetPatientShallowStudyListCommand;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayGetPatientShallowStudyListCommandV5
extends AbstractClinicalDisplayGetPatientShallowStudyListCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType>
{
	private final StudyFilter studyFilter;
	
	public ClinicalDisplayGetPatientShallowStudyListCommandV5(String transactionId, String siteId, 
			String patientId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType filter,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials, 
			BigInteger authorizedSensitivityLevel)
	{
		super(siteId, patientId, false);
		ClinicalDisplayCommandCommonV5.setTransactionContext(credentials, transactionId);
		studyFilter = ClinicalDisplayCommandCommonV5.getTranslator().transformFilter(filter, authorizedSensitivityLevel.intValue());
	}

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType translateInsufficientPatientSensitivityException(
			InsufficientPatientSensitivityException ipsX)
	{
		return ClinicalDisplayCommandCommonV5.getTranslator().transformExceptionToShallowStudiesType(ipsX);
	}

	@Override
	public Integer getEntriesReturned(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getStudies() == null ? 0 : translatedResult.getStudies().getStudy() == null ? 0 : translatedResult.getStudies().getStudy().length;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV5.clinicalDisplayV5InterfaceVersion;
	}

	@Override
	protected Class<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType> getResultClass()
	{
		return gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType.class;
	}

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType translateRouterResult(ArtifactResults routerResult)
	throws TranslationException
	{
		try
		{
			return ClinicalDisplayCommandCommonV5.getTranslator().transformStudiesToShallowStudies(routerResult);
		}
		catch(URNFormatException urnfX)
		{
			throw new TranslationException(urnfX);
		}
	}

	@Override
	protected StudyFilter getFilter()
	{
		return studyFilter;
	}

}
