/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import java.util.Date;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;

/**
 * @author Julian Werfel
 *
 */
public class PostTIUNoteCommandImpl
extends AbstractTIUDataSourceCommandImpl<PatientTIUNoteURN>
{
	private static final long serialVersionUID = 2785535772400805315L;
	
	private final TIUItemURN noteUrn;
	private final PatientIdentifier patientIdentifier;
	private final TIUItemURN locationUrn;
	private final Date noteDate;
	private final ConsultURN consultUrn;
	private final String noteText;

	private final TIUItemURN authorUrn;


	public PostTIUNoteCommandImpl(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
		TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
	{
		super(noteUrn);
		this.noteUrn = noteUrn;
		this.patientIdentifier = patientIdentifier;
		this.locationUrn = locationUrn;
		this.noteDate = noteDate;
		this.consultUrn = consultUrn;
		this.noteText = noteText;
		this.authorUrn = authorUrn;
	}
	
	/**
	 * @return the noteUrn
	 */
	public TIUItemURN getNoteUrn()
	{
		return noteUrn;
	}

	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	/**
	 * @return the locationUrn
	 */
	public TIUItemURN getLocationUrn()
	{
		return locationUrn;
	}

	/**
	 * @return the noteDate
	 */
	public Date getNoteDate()
	{
		return noteDate;
	}

	/**
	 * @return the noteText
	 */
	public String getNoteText()
	{
		return noteText;
	}

	/**
	 * @return the consultUrn
	 */
	public ConsultURN getConsultUrn()
	{
		return consultUrn;
	}

	/**
	 *
	 * @return the author URN
	 */
	public TIUItemURN getAuthorUrn() {
		return authorUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "createTIUNote";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {TIUItemURN.class, PatientIdentifier.class, TIUItemURN.class, Date.class, ConsultURN.class, String.class, TIUItemURN.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getNoteUrn(), getPatientIdentifier(), getLocationUrn(), getNoteDate(), getConsultUrn(), getNoteText(), getAuthorUrn()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected PatientTIUNoteURN getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.createTIUNote(getNoteUrn(), getPatientIdentifier(), getLocationUrn(), getNoteDate(), getConsultUrn(), getNoteText(), getAuthorUrn());
	}

}
