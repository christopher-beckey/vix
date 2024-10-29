/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 27, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.roi.commands.periodic.datasource;

import java.io.OutputStream;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.roi.datasource.ImageMergeWriterDataSourceSpi;

/**
 * @author VHAISWWERFEJ
 *
 */
public class GetMergeImageOutputStreamDataSourceCommandImpl
extends AbstractDataSourceCommandImpl<OutputStream, ImageMergeWriterDataSourceSpi>
{
	private static final long serialVersionUID = -318020796604305224L;
	
	private final String groupIdentifier;
	private final String objectIdentifier;
	private final ImageFormat imageFormat;
	private final String objectDescription;
	
	public GetMergeImageOutputStreamDataSourceCommandImpl(String groupIdentifier, String objectIdentifier, 
			ImageFormat imageFormat, String objectDescription)
	{
		super();
		this.groupIdentifier = groupIdentifier;
		this.objectIdentifier = objectIdentifier;
		this.imageFormat = imageFormat;
		this.objectDescription = objectDescription;
	}

	public String getGroupIdentifier()
	{
		return groupIdentifier;
	}

	public String getObjectIdentifier()
	{
		return objectIdentifier;
	}

	public ImageFormat getImageFormat()
	{
		return imageFormat;
	}

	public String getObjectDescription()
	{
		return objectDescription;
	}

	@Override
	public RoutingToken getRoutingToken()
	{
		return getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
	}

	@Override
	protected Class<ImageMergeWriterDataSourceSpi> getSpiClass()
	{
		return ImageMergeWriterDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName()
	{
		return "getOutputStream";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {String.class, String.class, ImageFormat.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getGroupIdentifier(), getObjectIdentifier(), 
				getImageFormat(), getObjectDescription()};
	}

	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	@Override
	protected OutputStream getCommandResult(ImageMergeWriterDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getOutputStream(getGroupIdentifier(), getObjectIdentifier(), 
				getImageFormat(), getObjectDescription());
	}
}
