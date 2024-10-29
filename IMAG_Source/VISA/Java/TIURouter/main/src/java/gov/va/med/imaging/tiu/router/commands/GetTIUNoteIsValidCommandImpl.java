/**
 * 
 * 
 * Date Created: Jan 8, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.tiu.router.commands;

import java.util.Date;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;

/**
 * @author vhaisltjahjb
 *
 */
public class GetTIUNoteIsValidCommandImpl
extends AbstractTIUDataSourceCommandImpl<Boolean>
{
	private static final long serialVersionUID = 6177138065890135729L;
	
	private String typeIndex;
	private TIUItemURN noteUrn;
	private PatientTIUNoteURN patientNoteUrn;
	
	/**
	 * @param routingToken
	 * @param typeIndex
	 * @param noteUrn
	 * @param patientNoteUrn
	 */
	public GetTIUNoteIsValidCommandImpl(RoutingToken globalRoutingToken, TIUItemURN noteUrn, PatientTIUNoteURN patientNoteUrn, String typeIndex)
	{
		super(globalRoutingToken);
		this.typeIndex = typeIndex;
		this.noteUrn = noteUrn;
		this.patientNoteUrn = patientNoteUrn;
	}

	/**
	 * @return the typeIndex
	 */
	public String getTypeIndex()
	{
		return typeIndex;
	}

	/**
	 * @return the noteUrn
	 */
	public TIUItemURN getNoteUrn()
	{
		return noteUrn;
	}

	/**
	 * @return the patientNoteUrn
	 */
	public PatientTIUNoteURN getPatientNoteUrn()
	{
		return patientNoteUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "isTIUNoteValid";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, TIUItemURN.class, PatientTIUNoteURN.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getNoteUrn(), getPatientNoteUrn(), getTypeIndex()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.isTIUNoteValid(getRoutingToken(), getNoteUrn(), getPatientNoteUrn(), getTypeIndex());
	}

}
