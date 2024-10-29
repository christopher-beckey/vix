/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 18, 2012
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
package gov.va.med.imaging.roi.commands.queue;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.roi.datasource.ExportQueueDataSourceSpi;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PostExportQueueRequestCommandImpl
extends AbstractDataSourceCommandImpl<Boolean, ExportQueueDataSourceSpi>
{
	private static final long serialVersionUID = 5984466136467846670L;
	private final AbstractExportQueueURN exportQueueUrn;
	private final AbstractImagingURN imagingUrn;
	private final int exportPriority;
	
	public PostExportQueueRequestCommandImpl(AbstractExportQueueURN exportQueueUrn, AbstractImagingURN imagingUrn, int exportPriority)
	{
		super();
		this.exportQueueUrn = exportQueueUrn;
		this.imagingUrn = imagingUrn;
		this.exportPriority = exportPriority;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<ExportQueueDataSourceSpi> getSpiClass()
	{
		return ExportQueueDataSourceSpi.class;
	}

	public AbstractExportQueueURN getExportQueueUrn()
	{
		return exportQueueUrn;
	}

	public AbstractImagingURN getImagingUrn()
	{
		return imagingUrn;
	}

	public int getExportPriority()
	{
		return exportPriority;
	}

	@Override
	public RoutingToken getRoutingToken()
	{
		return getImagingUrn();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "exportImages";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {AbstractExportQueueURN.class, AbstractImagingURN.class, int.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object [] {getExportQueueUrn(), getImagingUrn(), getExportPriority() };
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
	protected Boolean getCommandResult(
			ExportQueueDataSourceSpi spi) 
	throws ConnectionException, MethodException
	{
		return spi.exportImages(getExportQueueUrn(), getImagingUrn(), getExportPriority());
	}

}
