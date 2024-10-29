/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 20, 2010
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

import java.util.List;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayGetDocumentsCommand;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayGetDocumentsCommandV5
extends AbstractClinicalDisplayGetDocumentsCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType>
{

	public ClinicalDisplayGetDocumentsCommandV5(String transactionId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials,String patientIcn)
	{
		super(patientIcn);
		ClinicalDisplayCommandCommonV5.setTransactionContext(credentials, transactionId);
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
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType translateRouterResult(
			List<DocumentSet> routerResult) 
	throws TranslationException
	{
		return ClinicalDisplayCommandCommonV5.getTranslator().translate(routerResult);
	}
}
