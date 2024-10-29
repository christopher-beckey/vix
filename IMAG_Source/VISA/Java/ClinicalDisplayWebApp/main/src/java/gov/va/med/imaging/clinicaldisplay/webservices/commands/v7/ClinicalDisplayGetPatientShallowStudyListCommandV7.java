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
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v7;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetPatientShallowStudyListCommand;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator7;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import java.math.BigInteger;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayGetPatientShallowStudyListCommandV7
extends AbstractClinicalDisplayGetPatientShallowStudyListCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType>
{
	private final StudyFilter studyFilter;
	
	public ClinicalDisplayGetPatientShallowStudyListCommandV7(String transactionId, String siteId, 
			String patientId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			BigInteger authorizedSensitivityLevel,
			boolean includeArtifacts)
	{
		super(siteId, patientId, includeArtifacts);
		ClinicalDisplayCommandCommonV7.setTransactionContext(credentials, transactionId);
		studyFilter = ClinicalDisplayTranslator7.translate(filter, authorizedSensitivityLevel.intValue());
	}

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType translateInsufficientPatientSensitivityException(
			InsufficientPatientSensitivityException ipsX)
	{
		return ClinicalDisplayTranslator7.translate(ipsX);
	}

	@Override
	public Integer getEntriesReturned(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getStudies() == null ? 0 : translatedResult.getStudies().getStudy() == null ? 0 : translatedResult.getStudies().getStudy().length;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV7.clinicalDisplayV7InterfaceVersion;
	}

	@Override
	protected Class<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType> getResultClass()
	{
		return gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType.class;
	}

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType translateRouterResult(ArtifactResults routerResult)
	throws TranslationException, MethodException
	{
		try
		{
			return ClinicalDisplayTranslator7.translate(routerResult, getFilter());
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
