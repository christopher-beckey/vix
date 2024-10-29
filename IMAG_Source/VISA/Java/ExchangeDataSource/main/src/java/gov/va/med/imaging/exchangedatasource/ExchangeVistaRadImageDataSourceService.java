/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 8, 2009
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
package gov.va.med.imaging.exchangedatasource;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VistaRadImageDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.vistarad.ExamImage;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;

import gov.va.med.logging.Logger;

/**
 * Data source to retrieve images for VistARad from the DoD
 * 
 * @author vhaiswwerfej
 *
 */
public class ExchangeVistaRadImageDataSourceService 
extends ExchangeImageDataSourceService 
implements VistaRadImageDataSourceSpi 
{
	private final static Logger logger = 
		Logger.getLogger(ExchangeVistaRadImageDataSourceService.class);
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param site
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static ExchangeVistaRadImageDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new ExchangeVistaRadImageDataSourceService(resolvedArtifactSource, protocol);
    }
	
	public ExchangeVistaRadImageDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadImageDataSourceSpi#getImage(gov.va.med.imaging.exchange.business.vistarad.ExamImage, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	public ImageStreamResponse getImage(ExamImage image,
			ImageFormatQualityList requestFormatQuality)
	throws MethodException, ConnectionException 
	{
		return this.getImage(image.getImageUrn(), requestFormatQuality);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadImageDataSourceSpi#getImageTXTFile(gov.va.med.imaging.exchange.business.vistarad.ExamImage)
	 */
	@Override
	public DataSourceInputStream getImageTXTFile(ExamImage image)
	throws MethodException, ConnectionException, ImageNotFoundException, 
		ImageNearLineException 
	{
		return this.getImageTXTFile(image.getImageUrn());
	}

	@Override
	public ImageStreamResponse getImage(ImageURN imageUrn,
			ImageFormatQualityList requestFormatQuality)
	throws MethodException, ConnectionException
	{
		return super.getImage(imageUrn, requestFormatQuality);
	}

}
