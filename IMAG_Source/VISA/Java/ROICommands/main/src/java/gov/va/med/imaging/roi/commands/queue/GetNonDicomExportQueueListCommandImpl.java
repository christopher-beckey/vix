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
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.roi.datasource.ExportQueueDataSourceSpi;
import gov.va.med.imaging.roi.queue.NonDicomExportQueue;

import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class GetNonDicomExportQueueListCommandImpl
extends AbstractDataSourceCommandImpl<List<NonDicomExportQueue>, ExportQueueDataSourceSpi>
{
	private static final long serialVersionUID = 5984466136467846670L;
	private RoutingToken routingToken; // not final because it might not have a value provided
	
	public GetNonDicomExportQueueListCommandImpl(RoutingToken routingToken)
	{
		super();
		this.routingToken = routingToken;
	}
	
	/**
	 * Get the list of DICOM export queues from the local site
	 */
	public GetNonDicomExportQueueListCommandImpl()
	{
		super();
		this.routingToken = null; // cannot set value from command context since command context is null here
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		if(routingToken == null)
			routingToken = getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
		return routingToken;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<ExportQueueDataSourceSpi> getSpiClass()
	{
		return ExportQueueDataSourceSpi.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getNonDicomExportQueues";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object [] {getRoutingToken() };
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
	protected List<NonDicomExportQueue> getCommandResult(
			ExportQueueDataSourceSpi spi) 
	throws ConnectionException, MethodException
	{
		return spi.getNonDicomExportQueues(getRoutingToken());
	}

}
