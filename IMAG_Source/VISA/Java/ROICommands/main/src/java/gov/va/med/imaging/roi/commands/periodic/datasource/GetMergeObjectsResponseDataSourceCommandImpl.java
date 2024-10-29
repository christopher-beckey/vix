/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 27, 2012
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

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.roi.datasource.ImageMergeWriterDataSourceSpi;

/**
 * @author VHAISWWERFEJ
 *
 */
public class GetMergeObjectsResponseDataSourceCommandImpl
extends AbstractDataSourceCommandImpl<DataSourceImageInputStream, ImageMergeWriterDataSourceSpi>
{
	private static final long serialVersionUID = -811930436241283308L;
	
	private final String groupIdentifier;
	private final Patient patient;
	
	public GetMergeObjectsResponseDataSourceCommandImpl(String groupIdentifier, Patient patient)
	{
		super();
		this.groupIdentifier = groupIdentifier;
		this.patient = patient;
	}

	public String getGroupIdentifier()
	{
		return groupIdentifier;
	}
	
	public Patient getPatient()
	{
		return patient;
	}

	@Override
	public RoutingToken getRoutingToken()
	{
		return getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
	}

	@Override
	protected Class<ImageMergeWriterDataSourceSpi> getSpiClass()
	{
		return ImageMergeWriterDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName()
	{
		return "mergeObjects";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {String.class, Patient.class};
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getGroupIdentifier(), getPatient()};
	}

	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	@Override
	protected DataSourceImageInputStream getCommandResult(
			ImageMergeWriterDataSourceSpi spi) 
	throws ConnectionException, MethodException
	{
		return spi.mergeObjects(getGroupIdentifier(), getPatient());
	}
}
