/**
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.viewer.datasource.ViewerImagingCvixDataSourceSpi;

/**
 * @author Administrator
 *
 */
public abstract class AbstractViewerImagingCvixDataSourceCommandImpl<R>
extends AbstractDataSourceCommandImpl<R, ViewerImagingCvixDataSourceSpi>
{
	private static final long serialVersionUID = -5531028137719112211L;
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<ViewerImagingCvixDataSourceSpi> getSpiClass()
	{
		return ViewerImagingCvixDataSourceSpi.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSiteNumber()
	 */
	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

}
