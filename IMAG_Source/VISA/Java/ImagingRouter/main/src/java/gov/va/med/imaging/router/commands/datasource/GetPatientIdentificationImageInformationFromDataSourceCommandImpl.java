/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Dec 19, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.router.commands.datasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.PatientDataSourceSpi;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;

/**
 * @author Administrator
 *
 */
public class GetPatientIdentificationImageInformationFromDataSourceCommandImpl
extends AbstractDataSourceCommandImpl<PatientPhotoIDInformation, PatientDataSourceSpi>
{
	private static final long serialVersionUID = 1010147787347965677L;
	
	private static final String SPI_METHOD_NAME = "getPatientIdentificationImageInformation";
	
	private final RoutingToken globalRoutingToken;
	private final PatientIdentifier patientIdentifier;
//	private final Boolean remote;
	
	/**
	 * @param globalRoutingToken
	 * @param patientIdentifier
	 * @param remote
	 */
//	public GetPatientIdentificationImageInformationFromDataSourceCommandImpl(
//	RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier, boolean remote)
//	{
//		super();
//		this.globalRoutingToken = globalRoutingToken;
//		this.patientIdentifier = patientIdentifier;
//		this.remote = remote;
//	}
//	
	public GetPatientIdentificationImageInformationFromDataSourceCommandImpl(
	RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.patientIdentifier = patientIdentifier;
//		this(globalRoutingToken, patientIdentifier, false);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return globalRoutingToken;
	}
	
	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}
	
	/**
	 * @return the remote
	 */
//	public boolean isRemote()
//	{
//		return remote;
//	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<PatientDataSourceSpi> getSpiClass()
	{
		return PatientDataSourceSpi.class;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return SPI_METHOD_NAME;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, PatientIdentifier.class};
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		//return new Object[] {getRoutingToken(), getPatientIdentifier(), isRemote()};
		return new Object[] {getRoutingToken(), getPatientIdentifier()};
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSiteNumber()
	 */
	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected PatientPhotoIDInformation getCommandResult(
		PatientDataSourceSpi spi) 
	throws ConnectionException, MethodException
	{
		return spi.getPatientIdentificationImageInformation(getRoutingToken(), getPatientIdentifier());
//		if (isRemote())
//		{
//			return spi.getRemotePatientIdentificationImageInformation(getRoutingToken(), getPatientIdentifier());
//		}
//		else
//		{
//			return spi.getPatientIdentificationImageInformation(getRoutingToken(), getPatientIdentifier());
//		}
	}
	
	

}
