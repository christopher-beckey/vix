/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import java.util.Date;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUPatientNotesCommandImpl
extends AbstractTIUDataSourceCommandImpl<List<PatientTIUNote>>
{
	private static final long serialVersionUID = 6170138065890135729L;
	
	private final TIUNoteRequestStatus noteStatus;
	private final PatientIdentifier patientIdentifier;
	private final Date fromDate;
	private final Date toDate;
	private final String authorDuz;
	private final int count;
	private final boolean ascending;
	
	public GetTIUPatientNotesCommandImpl(RoutingToken globalRoutingToken, TIUNoteRequestStatus noteStatus, PatientIdentifier patientIdentifier,
		Date fromDate, Date toDate, String authorDuz, int count, boolean ascending)
	{
		super(globalRoutingToken);
		this.noteStatus = noteStatus;
		this.patientIdentifier = patientIdentifier;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.authorDuz = authorDuz;
		this.count = count;
		this.ascending = ascending;
	}

	/**
	 * @return the noteStatus
	 */
	public TIUNoteRequestStatus getNoteStatus()
	{
		return noteStatus;
	}

	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	/**
	 * @return the fromDate
	 */
	public Date getFromDate()
	{
		return fromDate;
	}

	/**
	 * @return the toDate
	 */
	public Date getToDate()
	{
		return toDate;
	}

	/**
	 * @return the authorDuz
	 */
	public String getAuthorDuz()
	{
		return authorDuz;
	}

	/**
	 * @return the count
	 */
	public int getCount()
	{
		return count;
	}

	/**
	 * @return the ascending
	 */
	public boolean isAscending()
	{
		return ascending;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getPatientTIUNotes";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, TIUNoteRequestStatus.class, PatientIdentifier.class, Date.class, Date.class, String.class, int.class, boolean.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getNoteStatus(), getPatientIdentifier(), getFromDate(), getToDate(), getAuthorDuz(), getCount(), isAscending()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<PatientTIUNote> getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getPatientTIUNotes(getRoutingToken(), getNoteStatus(), getPatientIdentifier(), getFromDate(), getToDate(), getAuthorDuz(), getCount(), isAscending());
	}

}
