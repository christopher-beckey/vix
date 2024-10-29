/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 6, 2012
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
package gov.va.med.imaging.roi.commands.datasource;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.WorkListDataSourceSpi;
import gov.va.med.imaging.exchange.business.WorkItem;

/**
 * This command creates a new work item - its probably not necessary, could call the existing workList command in CoreRouter
 * 
 * @author VHAISWWERFEJ
 *
 */
public class PostReleaseOfInformationRequestDataSourceCommandImpl
extends AbstractDataSourceCommandImpl<WorkItem, WorkListDataSourceSpi>
{
	private static final long serialVersionUID = 7554838161845559363L;
	private final WorkItem workItem;
	
	public PostReleaseOfInformationRequestDataSourceCommandImpl(WorkItem workItem)
	{
		super();
		this.workItem = workItem;
	}
	
	public WorkItem getWorkItem()
	{
		return workItem;
	}

	@Override
	protected Class<WorkListDataSourceSpi> getSpiClass()
	{
		return WorkListDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName()
	{
		return "createWorkItem";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?> [] {WorkItem.class};
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getWorkItem()};
	}

	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	@Override
	protected WorkItem getCommandResult(WorkListDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.createWorkItem(getWorkItem());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
	}

}
