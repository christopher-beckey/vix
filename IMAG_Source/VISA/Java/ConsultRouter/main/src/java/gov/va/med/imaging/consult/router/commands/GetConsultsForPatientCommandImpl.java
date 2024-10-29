/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.router.commands;

import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.datasource.ConsultDataSourceSpi;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

/**
 * @author Julian Werfel
 *
 */
public class GetConsultsForPatientCommandImpl
extends AbstractConsultDataSourceCommandImpl<List<Consult>>
{
	private static final long serialVersionUID = -6262293475455986877L;
	
	private final PatientIdentifier patientIdentifier;
	
	public GetConsultsForPatientCommandImpl(RoutingToken globalRoutingToken,
		PatientIdentifier patientIdentifier)
	{
		super(globalRoutingToken);
		this.patientIdentifier = patientIdentifier;
	}

	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getPatientConsults";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, PatientIdentifier.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getPatientIdentifier()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<Consult> getCommandResult(ConsultDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getPatientConsults(getRoutingToken(), getPatientIdentifier());
	}

}
