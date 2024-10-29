package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstanceFile;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckInfo;

import java.lang.reflect.Method;

import gov.va.med.logging.Logger;

public class PostInstanceFileCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<InstanceFile>
{

	private static final long serialVersionUID = 1L;
	private static Logger logger = Logger.getLogger(PostInstanceFileCommandImpl.class);


	private static final String SPI_METHOD_NAME = "createInstanceFile";

	private SOPInstance sopInstance;
	private InstanceFile instanceFile;
	
	public PostInstanceFileCommandImpl(SOPInstance sopInstance, InstanceFile instanceFile)
	{
		this.sopInstance = sopInstance;
		this.instanceFile = instanceFile;
	}

	@Override
	public RoutingToken getRoutingToken() {
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{SOPInstance.class, InstanceFile.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{sopInstance, instanceFile} ;
	}

	@Override
	protected String parameterToString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(getSiteNumber());
		sb.append(", ");
		sb.append(sopInstance.toString());
		sb.append(", ");
		sb.append(instanceFile.toString());
		return sb.toString();
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected InstanceFile getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException 
	{
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}
		return spi.createInstanceFile(sopInstance, instanceFile);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

}
