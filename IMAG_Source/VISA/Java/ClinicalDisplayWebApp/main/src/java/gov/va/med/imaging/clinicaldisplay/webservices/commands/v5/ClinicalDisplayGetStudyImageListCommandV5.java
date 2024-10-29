/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 3, 2010
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

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetStudyImageListCommand;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayGetStudyImageListCommandV5
extends AbstractClinicalDisplayGetStudyImageListCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[]>
{
	public ClinicalDisplayGetStudyImageListCommandV5(String transactionId,
			String studyId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials 
			)
	{
		super(studyId);
		ClinicalDisplayCommandCommonV5.setTransactionContext(credentials, transactionId);
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV5.clinicalDisplayV5InterfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

	@Override
	protected Class<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[]> getResultClass()
	{
		return gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[].class;
	}	

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] translateRouterResult(Study routerResult)
	throws TranslationException
	{
		try
		{
			return ClinicalDisplayCommandCommonV5.getTranslator().transformStudyToFatImages(routerResult);
		}
		catch(URNFormatException urnfX)
		{
			throw new TranslationException(urnfX);
		}
	}	
}
