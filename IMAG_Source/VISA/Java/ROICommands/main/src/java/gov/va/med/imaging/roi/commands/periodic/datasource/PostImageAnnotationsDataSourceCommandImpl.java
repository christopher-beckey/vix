/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 26, 2012
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

import java.io.InputStream;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.roi.datasource.ImageAnnotationWriterDataSourceSpi;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PostImageAnnotationsDataSourceCommandImpl
extends AbstractDataSourceCommandImpl<DataSourceInputStream, ImageAnnotationWriterDataSourceSpi>
{
	private static final long serialVersionUID = 4849791809210531542L;
	
	private final InputStream inputStream;
	private final ImageFormat imageFormat;
	private final ImageAnnotationDetails imageAnnotationDetails;
	
	public PostImageAnnotationsDataSourceCommandImpl(InputStream inputStream, 
			ImageFormat imageFormat, ImageAnnotationDetails imageAnnotationDetails)
	{
		super();
		this.inputStream = inputStream;
		this.imageFormat = imageFormat;
		this.imageAnnotationDetails = imageAnnotationDetails;
	}

	public InputStream getInputStream()
	{
		return inputStream;
	}

	public ImageAnnotationDetails getImageAnnotationDetails()
	{
		return imageAnnotationDetails;
	}

	public ImageFormat getImageFormat()
	{
		return imageFormat;
	}

	@Override
	public RoutingToken getRoutingToken()
	{
		return getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
	}

	@Override
	protected Class<ImageAnnotationWriterDataSourceSpi> getSpiClass()
	{
		return ImageAnnotationWriterDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName()
	{
		return "burnImageAnnotations";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {InputStream.class, ImageFormat.class, ImageAnnotationDetails.class};
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		// Dumb Fortify attempt
		return new Object [] {inputStream, getImageFormat(), getImageAnnotationDetails()};
	}

	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	@Override
	protected DataSourceInputStream getCommandResult(
			ImageAnnotationWriterDataSourceSpi spi) 
	throws ConnectionException, MethodException
	{
		// Dumb Fortify attempt
		return spi.burnImageAnnotations(inputStream, getImageFormat(), getImageAnnotationDetails());
	}

}
