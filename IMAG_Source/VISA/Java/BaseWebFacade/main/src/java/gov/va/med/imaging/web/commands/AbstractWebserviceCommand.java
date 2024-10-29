/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2010
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
package gov.va.med.imaging.web.commands;

import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.webservices.common.WebservicesCommon;

import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * Abstract command for handling web service calls.
 * @author vhaiswwerfej
 *
 * @param <D> The type of the object returned by the router
 * @param <E> The type this method is expected to convert the router result into
 */
public abstract class AbstractWebserviceCommand<D, E extends Object>
{
	protected final static Logger LOGGER = Logger.getLogger(AbstractWebserviceCommand.class);
	
	private final String methodName;
	
	public final static String transactionContextNaValue = "n/a";
	
	/**
	 * 
	 * @param methodName The name of the method (used for display purposes, not functional)
	 */
	public AbstractWebserviceCommand(String methodName)
	{
		this.methodName = methodName;
	}
	
	protected Logger getLogger()
	{
		return LOGGER;
	}
	
	/**
	 * Return the name of the method
	 * @return
	 */
	public String getMethodName() 
	{
		return methodName;
	}
	
	/**
	 * Return the transaction Id
	 * @return
	 */
	protected String getTransactionId()
	{
		return getTransactionContext().getTransactionId();
	}	
	
	/**
	 * Convenience method to get the transaction context
	 * @return
	 */
	protected TransactionContext getTransactionContext()
	{
		return TransactionContextFactory.get();
	}
	
	/**
	 * Return the router for the interface
	 * @return
	 */
	protected abstract FacadeRouter getRouter();
	
	/**
	 * Return the name of the web application
	 * @return
	 */
	protected abstract String getWepAppName(); 
	
	/**
	 * Execute the router command to generate the expected result
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	protected abstract D executeRouterCommand()
	throws MethodException, ConnectionException;
	
	/**
	 * Return a string representing the input parameters (for logging debug output)
	 * @return
	 */
	protected abstract String getMethodParameterValuesString();
	
	/**
	 * Returns any additional details about the request that can be included, if nothing should be added this
	 * method should return null
	 * @return
	 */
	protected abstract String getRequestTypeAdditionalDetails();
	
	/**
	 * Translate the router result into the expected result
	 * @param routerResult
	 * @return
	 * @throws TranslationException
	 * @throws MethodException A MethodException may be thrown during the translation if the result contains an exception that should be thrown
	 */
	protected abstract E translateRouterResult(D routerResult)
	throws TranslationException, MethodException;
	
	/**
	 * Get the class of the expected result
	 * @return
	 */
	protected abstract Class<E> getResultClass(); 
	
	/**
	 * Return a map of transaction context fields to set during the initialization
	 * @return
	 */
	protected abstract Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields();
	
	/**
	 * Implement this method to set additional transaction context fields during initialization
	 */
	public abstract void setAdditionalTransactionContextFields();
	
	/**
	 * Return the version number for the command
	 * @return
	 */
	public abstract String getInterfaceVersion();
	
	/**
	 * Return the number of resulted objects returned or null if this should not be used. This value is used to set
	 * the transactionContext EntriesReturned value
	 * @param translatedResult
	 * @return
	 */
	public abstract Integer getEntriesReturned(E translatedResult);
	
	/**
	 * Execute the command
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@SuppressWarnings("unchecked")
	public E execute()
	throws MethodException, ConnectionException
	{
		LOGGER.debug("Executing Web Service command.");
		TransactionContext transactionContext = TransactionContextFactory.get();
		String transactionId = transactionContext.getTransactionId();
		String methodParameterValueString = getMethodParameterValuesString();
        LOGGER.info("{} ({}): {}", getMethodName(), transactionId, methodParameterValueString == null ? "" : methodParameterValueString);
		String requestTypeAdditionalDetails = getRequestTypeAdditionalDetails();
		long startTime = System.currentTimeMillis();
		transactionContext.setRequestType(getWepAppName() + " " + getInterfaceVersion() +  " " + getMethodName() + (requestTypeAdditionalDetails == null ? "" : " " + requestTypeAdditionalDetails));
		initializeTransationContext();		
		
		E expectedResult = null;
		try
		{
			FacadeRouter router = getRouter();
			// check router here to be sure it doesn't have to be done in each command
			if(router == null)
			{
				String msg = "AbstractWebserviceCommand.execute() --> Internal error: can not obtain [" + getWepAppName() + "] Router to execute method [" + getMethodName() + "]";
				LOGGER.error(msg);
				throw new ConnectionException(msg);
			}

            LOGGER.debug("AbstractWebserviceCommand.execute() --> Router: {}", router.getClass());
            LOGGER.debug("AbstractWebserviceCommand.execute() --> WebserviceCommand Class: {}", this.getClass());
            LOGGER.debug("AbstractWebserviceCommand.execute() --> Result Class: {}", this.getResultClass());
			
			D routerResult = executeRouterCommand();
			
			LOGGER.debug("AbstractWebserviceCommand.execute() --> Survived executeRouterCommand() method");
			
			if(routerResult == null)
			{
				LOGGER.debug("AbstractWebserviceCommand.execute() --> Got null result from executeRouterCommand().  Return null.");
				return null;
			}
			
			if(routerResult.getClass() == getResultClass())
			{
				expectedResult = (E)routerResult;
			}
			else
			{
				expectedResult = translateRouterResult(routerResult);
				LOGGER.debug("AbstractWebserviceCommand.execute() --> Survived translateRouterResult()");
			}

		}
		// this must be here so the proper exception will be thrown
		catch(InsufficientPatientSensitivityException ipsX)
		{
            LOGGER.error("AbstractWebserviceCommand.execute() --> Encountered InsufficientPatientSensitivityException in [{}], returning error message to client: {}", getMethodName(), ipsX.getMessage());
			transactionContext.setErrorMessage(ipsX.getMessage());
			transactionContext.setExceptionClassName(ipsX.getClass().getSimpleName());
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw InsufficientPatientSensitivityException.createInsufficientPatientSensitivityException(ipsX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("AbstractWebserviceCommand.execute() --> Encountered ConnectionException in [{}]: {}", getMethodName(), cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException("AbstractWebserviceCommand.execute() --> Encountered ConnectionException", cX);
		}
		catch(MethodException mX)
		{
            LOGGER.error("AbstractWebserviceCommand.execute() --> Encountered MethodException in [{}]: {}", getMethodName(), mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			WebservicesCommon.throwSecurityCredentialsExceptionFromMethodException(mX);
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new MethodException("AbstractWebserviceCommand.execute() --> Encountered MethodException", mX);
		}		
		catch(Exception eX)
		{
            LOGGER.error("AbstractWebserviceCommand.execute() --> Encountered an exception in [{}]: {}", getMethodName(), eX.getMessage());
			transactionContext.setErrorMessage(eX.toString());
			transactionContext.setExceptionClassName(eX.getClass().getSimpleName());
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException("AbstractWebserviceCommand.execute() --> Encountered an exception in", eX);
		}
		
		Integer entriesReturned = getEntriesReturned(expectedResult);
		
		if(entriesReturned != null)
		{
			transactionContext.setEntriesReturned(entriesReturned);
		}

        LOGGER.info("AbstractWebserviceCommand.execute() --> Completed [{}, {}] with transaction Id [{}] in {} ms", getWepAppName(), getMethodName(), transactionId, System.currentTimeMillis() - startTime);
		
		return expectedResult;
	}
	
	private void initializeTransationContext()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = getTransactionContextFields();
		if(transactionContextFields != null)
		{
			for(WebserviceInputParameterTransactionContextField field : transactionContextFields.keySet())
			{
				String value = transactionContextFields.get(field);
				if(field == WebserviceInputParameterTransactionContextField.patientId)
					transactionContext.setPatientID(value);
				else if(field == WebserviceInputParameterTransactionContextField.quality)
					transactionContext.setQuality(value);
				else if(field == WebserviceInputParameterTransactionContextField.queryFilter)
					transactionContext.setQueryFilter(value);
				else if(field == WebserviceInputParameterTransactionContextField.urn)
					transactionContext.setUrn(value);
				else if(field == WebserviceInputParameterTransactionContextField.requestType)
					transactionContext.setRequestType(value);
			}
		}
		setAdditionalTransactionContextFields();
	}
	
	protected RoutingToken getLocalRoutingToken() throws ConnectionException
	{
		RoutingToken localRoutingToken = null;
		try 
		{
			TransactionContext xactionContext = TransactionContextFactory.get();
			String realmSiteNumber = xactionContext.getRealm();
			localRoutingToken = RoutingTokenImpl.createVARadiologySite(realmSiteNumber);
		} 
		catch (RoutingTokenFormatException e) 
		{
            LOGGER.error("AbstractWebserviceCommand.getLocalRoutingToken() --> Encountered an exception in [{}]: {}", getMethodName(), e.getMessage());
			throw new ConnectionException("AbstractWebserviceCommand.getLocalRoutingToken() --> Encountered an exception in [" + getMethodName() + "]", e);
		}
		return localRoutingToken;
	}

}
