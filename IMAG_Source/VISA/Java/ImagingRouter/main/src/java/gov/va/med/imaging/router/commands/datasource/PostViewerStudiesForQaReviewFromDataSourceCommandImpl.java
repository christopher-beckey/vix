/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 9, 2017
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.router.commands.datasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.List;

/**
 * @author vhaisltjahjb
 *
 */
public class PostViewerStudiesForQaReviewFromDataSourceCommandImpl 
extends AbstractDataSourceCommandImpl<List<Study>, ExternalPackageDataSourceSpi> 
{

	private static final long serialVersionUID = -5379994879566937841L;
	
	private static final String SPI_METHOD_NAME = "postViewerStudiesForQaReview";
	
	private final RoutingToken routingToken;
	private final StudyFilter filter;
	
	public PostViewerStudiesForQaReviewFromDataSourceCommandImpl(
		RoutingToken routingToken, 
		StudyFilter filter)
	{
		this.routingToken = routingToken;
		this.filter = filter;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<Study> getCommandResult(ExternalPackageDataSourceSpi spi)
	throws ConnectionException, MethodException 
	{
		List<Study> studyList = null;
		getLogger().info("spi.postViewerStudiesForQaReview");
		studyList = spi.postViewerStudiesForQaReview(
			getRoutingToken(), 
			getFilter());

        getLogger().debug("Number of studies: {}", studyList.size());
        getLogger().debug("Study List: {}", studyList.toString());
		
		return studyList;
	}

	public RoutingToken getRoutingToken()
	{
		return this.routingToken;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSiteNumber()
	 */
	@Override
	protected String getSiteNumber() 
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	public StudyFilter getFilter() {
		return filter;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<ExternalPackageDataSourceSpi> getSpiClass() 
	{
		return ExternalPackageDataSourceSpi.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[]{getRoutingToken(), getFilter()};
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[]{RoutingToken.class, StudyFilter.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString() 
	{
		StringBuilder sb = new StringBuilder();
		sb.append(getSiteNumber());
		return sb.toString();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#postProcessResult(java.lang.Object)
	 */
	@Override
	protected List<Study> postProcessResult(List<Study> result) 
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : result.size());
		return result;
	}
}