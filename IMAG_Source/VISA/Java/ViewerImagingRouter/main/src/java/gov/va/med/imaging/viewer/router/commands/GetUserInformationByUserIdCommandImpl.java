/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 28, 2017
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
package gov.va.med.imaging.viewer.router.commands;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class GetUserInformationByUserIdCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = 927797777639285649L;

	private final String userId;
	private final RoutingToken routingToken;
	
	private static final String SPI_METHOD_NAME = "getUserInformationByUserId";
	
	public GetUserInformationByUserIdCommandImpl(RoutingToken routingToken, String userId)
	{
		this.userId = userId;
		this.routingToken = routingToken;
	}

	@Override
	protected String getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getUserInformationByUserId(getRoutingToken(), getUserId());
	}

	@Override
	public RoutingToken getRoutingToken()
	{
		return routingToken;
	}

	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	@Override
	protected Class<ViewerImagingDataSourceSpi> getSpiClass()
	{
		return ViewerImagingDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName()
	{
		return SPI_METHOD_NAME;
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[]{getRoutingToken(), getUserId()};
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[]{RoutingToken.class, String.class};
	}

	public String getUserId() {
		return userId;
	}
}
