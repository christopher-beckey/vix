/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 18, 2011
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
package gov.va.med.imaging.router.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.PatientDataSourceSpi;

/**
 * @author vhaiswwerfej
 *
 */
public class PostSensitivePatientAccessCommandImpl
extends AbstractDataSourceCommandImpl<Boolean, PatientDataSourceSpi>
{
	private static final long serialVersionUID = 4421296319821815709L;
	
	private final RoutingToken routingToken;
	private final PatientIdentifier patientIdentifier;
	
	private static final String SPI_METHOD_NAME = "logPatientSensitiveAccess";
	
	public PostSensitivePatientAccessCommandImpl(RoutingToken routingToken, String patientIcn)
	{
		this(routingToken, new PatientIdentifier(patientIcn, PatientIdentifierType.icn));
	}
	
	public PostSensitivePatientAccessCommandImpl(RoutingToken routingToken, PatientIdentifier patientIdentifier)
	{
		super();
		this.routingToken = routingToken;
		this.patientIdentifier = patientIdentifier;
	}

	@Override
	protected Boolean getCommandResult(PatientDataSourceSpi spi)
			throws ConnectionException, MethodException
	{
		return spi.logPatientSensitiveAccess(getRoutingToken(), getPatientIdentifier());
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
	protected Class<PatientDataSourceSpi> getSpiClass()
	{
		return PatientDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName()
	{
		return SPI_METHOD_NAME;
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[]{getRoutingToken(), getPatientIdentifier()};
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[]{RoutingToken.class, PatientIdentifier.class};
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	
}
