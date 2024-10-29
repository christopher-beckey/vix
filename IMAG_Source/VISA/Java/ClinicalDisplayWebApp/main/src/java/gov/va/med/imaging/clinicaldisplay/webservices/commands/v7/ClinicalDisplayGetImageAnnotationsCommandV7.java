/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 16, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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

import java.util.List;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetImageAnnotationsCommand;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator7;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayGetImageAnnotationsCommandV7
extends AbstractClinicalDisplayGetImageAnnotationsCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[]>
{
	
	public ClinicalDisplayGetImageAnnotationsCommandV7(String imageId,
		String transactionId, 
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials)
	{
		super(imageId);
		ClinicalDisplayCommandCommonV7.setTransactionContext(credentials, transactionId);
	}

	@Override
	protected AnnotationType[] translateRouterResult(
			List<ImageAnnotation> routerResult) 
	throws TranslationException, MethodException
	{
		return ClinicalDisplayTranslator7.translate(routerResult);
	}

	@Override
	protected Class<gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[]> getResultClass()
	{
		return gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[].class;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV7.clinicalDisplayV7InterfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(AnnotationType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

}
