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

import gov.va.med.PatientIdentifier;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.rmi.RemoteException;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayGetPatientShallowStudyListCommand<E extends Object>
extends AbstractClinicalDisplayWebserviceCommand<ArtifactResults, E>
{
	private final static Logger LOGGER = Logger.getLogger(AbstractClinicalDisplayGetPatientShallowStudyListCommand.class);
	private final String siteId;
	private final String patientId;
	private final boolean includeArtifacts;

	public AbstractClinicalDisplayGetPatientShallowStudyListCommand(String siteId, 
			String patientId, boolean includeArtifacts)
	{
		super("getPatientShallowStudyList");
		this.siteId = siteId;
		this.patientId = patientId;
		this.includeArtifacts = includeArtifacts;
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getPatientId()
	{
		return patientId;
	}

	public boolean isIncludeArtifacts()
	{
		return includeArtifacts;
	}

	/**
	 * Return a StudyFilter business object based on the interface study filter
	 * 
	 * <br><br>
	 * <b>Note:</b> The study filter could not be included as a final parameter because it needed to be transformed from
	 * the interface type to the generic business type
	 * 
	 * @return
	 */
	protected abstract StudyFilter getFilter();
	
	/**
	 * For Clinical Display, the InsufficientPatientSensitivityException is returned as a special study result. This
	 * abstract method is used to translate the sensitivityException into the proper result for the interface type
	 * @param ipsX
	 * @return
	 */
	protected abstract E translateInsufficientPatientSensitivityException(InsufficientPatientSensitivityException ipsX);

	@Override
	protected ArtifactResults executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		ClinicalDisplayRouter rtr = getRouter(); 
		try
		{
			ArtifactResults result = rtr.getShallowArtifactResultsForPatientFromSite(
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId()),
					PatientIdentifier.icnPatientIdentifier(getPatientId()),
					getFilter(), true, isIncludeArtifacts());
			return result;
		}
		// InsufficientPatientSensitivityException is caught in AbstractWebserviceCommand		
		catch (RoutingTokenFormatException rtfX)
		{	
			String msg = "AbstractClinicalDisplayGetPatientShallowStudyListCommand.executeRouterCommand() --> RoutingTokenFormatException, unable to retrieve study metadata";
			LOGGER.error(msg);
			throw new MethodException(msg, rtfX);
		}	
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return " for patient '" + getPatientId() + "' from site '" + getSiteId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, 
				TransactionContextFactory.getFilterDateRange(getFilter().getFromDate(), getFilter().getToDate()));

		return transactionContextFields;
	}

	@Override
	public E executeClinicalDisplayCommand() 
	throws RemoteException
	{
		// This method is overridden here in order to handle the InsufficientPatientSensitivityException properly
		try
		{
			return super.execute();
		}
		catch(InsufficientPatientSensitivityException ipsX)
		{
			String msg = "AbstractClinicalDisplayGetPatientShallowStudyListCommand.executeClinicalDisplayCommand() --> Insufficient sensitivity exception: " + ipsX.getMessage();
			LOGGER.error(msg);
			return translateInsufficientPatientSensitivityException(ipsX);
		}
		catch(Exception ex)
		{
			String msg = "AbstractClinicalDisplayGetPatientShallowStudyListCommand.executeClinicalDisplayCommand() --> Encountered exception: " + ex.getMessage();
			LOGGER.error(msg);
			throw new RemoteException(msg, ex);
		}
	}	
}