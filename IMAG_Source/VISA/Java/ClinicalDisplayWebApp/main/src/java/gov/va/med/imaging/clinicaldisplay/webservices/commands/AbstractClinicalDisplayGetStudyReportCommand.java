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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayGetStudyReportCommand
extends AbstractClinicalDisplayWebserviceCommand<String, String>
{
	private final String studyId;

	public AbstractClinicalDisplayGetStudyReportCommand(String studyId)
	{
		super("getStudyReport");
		this.studyId = studyId;
	}

	public String getStudyId()
	{
		return studyId;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		StudyURN studyUrn = null;
		try
		{
			TransactionContext transactionContext = getTransactionContext();
			URN urn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP);		
						
			if(urn instanceof StudyURN)
			{
				studyUrn = (StudyURN)urn;
			}
			else if(urn instanceof ImageURN)
			{
				ImageURN imageUrn = (ImageURN)urn;
				studyUrn = imageUrn.getParentStudyURN();
			}
			else
			{
				return "1^^\nReport is not available for this study";
			}
			transactionContext.setPatientID(studyUrn.getPatientId());	
			ClinicalDisplayRouter rtr = getRouter();
			Study study = rtr.getPatientStudy(studyUrn);
			if(study != null)
			{
				transactionContext.setFacadeBytesSent(study.getRadiologyReport() == null ? 0L : study.getRadiologyReport().length());
				return study.getRadiologyReport();
			}
            getLogger().warn("Got null study back from router for study Id '{}', returning null report.", getStudyId());
			return null;
		}
		catch(URNFormatException iurnfX)
		{
			throw new MethodException("URNFormatException, unable to retrieve study report", iurnfX);
		}
	}

	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for report '" + getStudyId() + "'.";
	}

	@Override
	protected Class<String> getResultClass()
	{
		return String.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getStudyId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	protected String translateRouterResult(String routerResult)
	throws TranslationException
	{
		return routerResult;
	}
}
