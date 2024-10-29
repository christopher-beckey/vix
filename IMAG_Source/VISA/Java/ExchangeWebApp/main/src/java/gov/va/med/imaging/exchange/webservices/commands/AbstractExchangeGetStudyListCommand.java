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

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeSet;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.exchange.ExchangeRouter;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractExchangeGetStudyListCommand<E extends Object>
extends AbstractExchangeWebserviceCommand<StudySetResult, E>
{
	private final String patientId;
	private final String requestedSite;
	
	public AbstractExchangeGetStudyListCommand(String patientId, String requestedSite)
	{
		super("AbstractExchangeGetStudyListCommand.getPatientStudyList()");
		this.patientId = patientId;
		this.requestedSite = requestedSite;
	}
	
	protected abstract StudyFilter getStudyFilter();

	@Override
	protected StudySetResult executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		ExchangeRouter rtr = getRouter();
		StudyFilter studyFilter = getStudyFilter();
		try
		{
			studyFilter.setExcludeSiteNumbers(getExcludedSiteNumbers());
		}
		catch(RoutingTokenFormatException rtfX)
		{
            getLogger().warn("AbstractExchangeGetStudyListCommand.executeRouterCommand() --> Error while setting excluded sites: {}", rtfX.getMessage());
		}
		getTransactionContext().setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		StudySetResult result = null;
		
		try
		{
			if(isSiteSpecified())
			{
				RoutingToken routingToken = null;
				try
				{
					// this really should only create VA sites, but just in case use this method to set the correct home community id
					routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getRequestedSite());
				}
				catch(RoutingTokenFormatException rtfX)
				{
					String msg = "AbstractExchangeGetStudyListCommand.executeRouterCommand() --> Error while creating routing token from requested site [" + getRequestedSite() + "]: " + rtfX.getMessage();
					getLogger().error(msg);
					throw new MethodException(msg, rtfX);
				}
				// only get data from this specified site
				result = rtr.getPatientStudySetResultWithImages(routingToken, PatientIdentifier.icnPatientIdentifier(patientId),
						studyFilter);
			}
			else
			{
				// get data from all sites for this patient
				result = rtr.getStudySetResultWithImagesForPatient(PatientIdentifier.icnPatientIdentifier(getPatientId()),
						studyFilter);
			}
		}
		catch(PatientNotFoundException pnfX)
		{
            getLogger().warn("AbstractExchangeGetStudyListCommand.executeRouterCommand() --> Patient id [{}] was NOT found. Returning empty study list. Error: {}", getPatientId(), pnfX.getMessage());
			// for this interface return an empty study list if a patient is not found
			result = StudySetResult.createFullResult(new TreeSet<Study>());			
		}
        getLogger().info("AbstractExchangeGetStudyListCommand.executeRouterCommand() -->  Got [{}] Artifacts in StudySetResult from router for patient [{}]", result == null ? "null" : result.getArtifactSize(), getPatientId());
		getTransactionContext().addDebugInformation("Result has status [" + result == null ? "null result" : result.getArtifactResultStatus() + "].");
		return result;
	}	
	
	private Collection<String> getExcludedSiteNumbers()
	{
		Collection<String> excludedSiteNumbers = new ArrayList<String>();
		excludedSiteNumbers.add("200");
		return excludedSiteNumbers;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient '" + getPatientId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());

		return transactionContextFields;
	}

	public String getPatientId()
	{
		return patientId;
	}

	public String getRequestedSite()
	{
		return requestedSite;
	}

	private boolean isSiteSpecified()
	{
		if(getRequestedSite() == null)
			return false;
		if(getRequestedSite().length() <= 0)
			return false;
		if("*".equals(getRequestedSite()))
			return false;
		return true;
	}
}
