/**
 * 
 * 
 * Date Created: Dec 6, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest.router.commands;

import java.io.InputStream;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;
import gov.va.med.imaging.ingest.datasource.ImageIngestDataSourceSpi;

/**
 * @author Administrator
 *
 */
public class PostIngestImageCommandImpl
extends AbstractDataSourceCommandImpl<ImageURN, ImageIngestDataSourceSpi>
{

	private static final long serialVersionUID = 2602837624337193586L;
	
	private final RoutingToken routingToken;
	private final InputStream imageInputStream;
	private final ImageIngestParameters imageIngestParameters;
	private final boolean createGroup;

	/**
	 * @param routingToken
	 * @param imageInputStream
	 * @param imageIngestParameters
	 */
	public PostIngestImageCommandImpl(RoutingToken routingToken,
		InputStream imageInputStream, ImageIngestParameters imageIngestParameters, 
		boolean createGroup)
	{
		super();
		this.routingToken = routingToken;
		this.imageInputStream = imageInputStream;
		this.imageIngestParameters = imageIngestParameters;
		this.createGroup = createGroup;
	}
	
	public PostIngestImageCommandImpl(RoutingToken routingToken,
		InputStream imageInputStream, ImageIngestParameters imageIngestParameters)
	{
		this(routingToken, imageInputStream, imageIngestParameters, false);
	}

	/**
	 * @return the createGroup
	 */
	public boolean isCreateGroup()
	{
		return createGroup;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return routingToken;
	}

	/**
	 * @return the imageInputStream
	 */
	public InputStream getImageInputStream()
	{
		return imageInputStream;
	}

	/**
	 * @return the imageIngestParameters
	 */
	public ImageIngestParameters getImageIngestParameters()
	{
		return imageIngestParameters;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<ImageIngestDataSourceSpi> getSpiClass()
	{
		return ImageIngestDataSourceSpi.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "storeImage";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, InputStream.class, ImageIngestParameters.class, boolean.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getImageInputStream(), getImageIngestParameters(), isCreateGroup()};
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
	protected ImageURN getCommandResult(ImageIngestDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.storeImage(getRoutingToken(), getImageInputStream(), getImageIngestParameters(), isCreateGroup());
	}

}
