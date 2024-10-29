/**
 * 
 * 
 * Date Created: Dec 5, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest.datasource;

import java.io.InputStream;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;

/**
 * @author Administrator
 *
 */
@SPI(description="This SPI defines operations providing access to storing new images (binaries).")
public interface ImageIngestDataSourceSpi
extends VersionableDataSourceSpi
{
	
	public abstract ImageURN storeImage(RoutingToken globalRoutingToken, InputStream imageInputStream, 
		ImageIngestParameters imageIngestParameters, boolean createGroup)
	throws MethodException, ConnectionException;
	

}
