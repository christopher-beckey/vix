/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 27, 2010
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
package gov.va.med.imaging.exchange.webservices.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierFactory;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.ExchangeRouter;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractExchangeGetStudyReportCommand<E extends Object>
extends AbstractExchangeWebserviceCommand<Study, E>
{
	private final String studyId;
	
	public AbstractExchangeGetStudyReportCommand(String studyId)
	{
		super("AbstractExchangeGetStudyReportCommand.getStudyReport()");
		this.studyId = studyId;
	}

	@Override
	protected Study executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		GlobalArtifactIdentifier studyUrn = null;
		try
		{
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			studyUrn = GlobalArtifactIdentifierFactory.create(studyId, StudyURN.class, BhieStudyURN.class);
		}
		catch (Throwable x)
		{
			String msg = "AbstractExchangeGetStudyReportCommand.executeRouterCommand() --> Error: " + x.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, x);
		}
		Study study = null;
		
		ExchangeRouter rtr = getRouter(); 
		if(studyUrn instanceof StudyURN)
		{
			// update the transaction context with patientId
			getTransactionContext().setPatientID(((StudyURN)studyUrn).getPatientId());
			//TODO: change to use a command that does not require a fully loaded study (when that is supported from the cache)
			study = rtr.getPatientStudy((StudyURN)studyUrn);			
		}
		else if(studyUrn instanceof BhieStudyURN)
		{
			// update the transaction context with patientId
			getTransactionContext().setPatientID(((BhieStudyURN)studyUrn).getPatientId());
			//TODO: change to use a command that does not require a fully loaded study (when that is supported from the cache)
			study = rtr.getPatientStudy((BhieStudyURN)studyUrn);
		}
		
		return study;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for study '" + studyId + "'.";
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

	public String getStudyId()
	{
		return studyId;
	}
}
