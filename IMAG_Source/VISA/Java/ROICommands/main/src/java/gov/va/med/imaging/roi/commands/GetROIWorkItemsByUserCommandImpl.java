/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 28, 2012
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
package gov.va.med.imaging.roi.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.WorkListDataSourceSpi;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemFilter;
import gov.va.med.imaging.exchange.business.WorkItemTags;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * This command retrieves the work items for the user based on the user DUZ in the principal.
 * This command does not provide a parameter to specify the user, it can only work for the
 * user who is authenticated by the realm
 * 
 * @author VHAISWWERFEJ
 *
 */
public class GetROIWorkItemsByUserCommandImpl
extends AbstractDataSourceCommandImpl<List<WorkItem>, WorkListDataSourceSpi>
{
	private static final long serialVersionUID = 8298224030660780535L;
	private final ROIWorkItemFilter workItemFilter;

	public GetROIWorkItemsByUserCommandImpl()
	{
		super();
		workItemFilter = new ROIWorkItemFilter();
		WorkItemTags tags = new WorkItemTags();
		String userDuz = TransactionContextFactory.get().getDuz();
        getLogger().info("Creating filter to search for work items for user '{}'.", userDuz);
		tags.addTag(ROIWorkItemTag.userDuz.getTagName(), userDuz);
		workItemFilter.setTags(tags);
	}

	public ROIWorkItemFilter getWorkItemFilter()
	{
		return workItemFilter;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<WorkListDataSourceSpi> getSpiClass()
	{
		return WorkListDataSourceSpi.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getWorkItemList";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {WorkItemFilter.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getWorkItemFilter()};
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
	protected List<WorkItem> getCommandResult(WorkListDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		getWorkItemFilter().setSiteId(getCommandContext());
		return spi.getWorkItemList(getWorkItemFilter());
	}

	@Override
	protected List<WorkItem> postProcessResult(List<WorkItem> result)
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : result.size());
		return super.postProcessResult(result);
	}

}
