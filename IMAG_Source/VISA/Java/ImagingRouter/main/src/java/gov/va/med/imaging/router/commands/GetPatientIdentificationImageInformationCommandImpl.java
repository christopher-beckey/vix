/**
 * 
 *
 * Date Created: Dec 19, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Administrator
 *
 */
@RouterCommandExecution(asynchronous=true, distributable=false)
public class GetPatientIdentificationImageInformationCommandImpl
extends AbstractImagingCommandImpl<PatientPhotoIDInformation>
{
	private static final long serialVersionUID = -7393569914716597583L;
	
	private final RoutingToken routingToken;
	private final PatientIdentifier patientIdentifier;
	private final boolean allowCached;
	
	/**
	 * @param routingToken
	 * @param patientIdentifier
	 * @param allowCached
	 */
	public GetPatientIdentificationImageInformationCommandImpl(
			RoutingToken routingToken, PatientIdentifier patientIdentifier,
			boolean allowCached)
	{
		super();
		this.routingToken = routingToken;
		this.patientIdentifier = patientIdentifier;
		this.allowCached = allowCached;
	}

	public GetPatientIdentificationImageInformationCommandImpl(
		RoutingToken routingToken, PatientIdentifier patientIdentifier)
	{
		this(routingToken, patientIdentifier, false);
	}
	
	/**
	 * @return the allowCached
	 */
	public boolean isAllowCached()
	{
		return allowCached;
	}

	/**
	 * @return the routingToken
	 */
	public RoutingToken getRoutingToken()
	{
		return routingToken;
	}

	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public PatientPhotoIDInformation callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        getLogger().info("getPatientIdentificationImageInformation - Transaction ID [{}] from site [{}] for patient [{}].", transactionContext.getTransactionId(), getRoutingToken().toString(), getPatientIdentifier());
				
		transactionContext.setServicedSource(routingToken.toRoutingTokenString());
				
		PatientPhotoIDInformation photoIdInformation = null;
		if(isAllowCached())
		{
			photoIdInformation = CommonImageCacheFunctions.getPatientIDInformationFromCache(getCommandContext(), getRoutingToken(), getPatientIdentifier());
			if(photoIdInformation != null)
			{
				transactionContext.setItemCached(Boolean.TRUE);
                getLogger().info("Retrieved patient [{}] photo ID information from cache", patientIdentifier);
				return photoIdInformation;
			}
		}
		transactionContext.setItemCached(Boolean.FALSE);
        getLogger().info("Did not find patient [{}] photo ID information from cache, retrieving from datasource", patientIdentifier);
		photoIdInformation = ImagingContext.getRouter().getPatientIdentificationImageInformation(getRoutingToken(), getPatientIdentifier());
		if(photoIdInformation != null)
		{
			getLogger().info("Retrieved patient photo ID information from data source, putting into cache before returning");
			CommonImageCacheFunctions.cachePatientIDInformation(getCommandContext(), getRoutingToken(), getPatientIdentifier(), photoIdInformation);
		}
		return photoIdInformation;
	}
			
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if(obj instanceof GetPatientIdentificationImageInformationCommandImpl)
		{
			GetPatientIdentificationImageInformationCommandImpl that = (GetPatientIdentificationImageInformationCommandImpl)obj;
			return this.getRoutingToken().equals(that.getRoutingToken().equals(that.getRoutingToken()) && 
					this.getPatientIdentifier().equals(that.getPatientIdentifier()));
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
StringBuilder sb = new StringBuilder();
		
		sb.append(getPatientIdentifier());
		sb.append(", ");
		sb.append(getRoutingToken());
		
		return sb.toString();
	}

}
