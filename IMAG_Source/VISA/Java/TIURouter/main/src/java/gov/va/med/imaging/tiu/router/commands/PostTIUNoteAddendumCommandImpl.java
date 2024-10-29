/**
 * 
 * 
 * Date Created: Feb 14, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import java.util.Date;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;

/**
 * @author Julian Werfel
 *
 */
public class PostTIUNoteAddendumCommandImpl
extends AbstractTIUDataSourceCommandImpl<PatientTIUNoteURN>
{
	private static final long serialVersionUID = 2485774374812507013L;
	
	private final PatientTIUNoteURN noteUrn;
	private final Date date;
	private final String addendumText;
	
	public PostTIUNoteAddendumCommandImpl(PatientTIUNoteURN noteUrn,
		Date date, String addendumText)
	{
		super(noteUrn);
		this.noteUrn = noteUrn;
		this.date = date;
		this.addendumText = addendumText;
	}

	/**
	 * @return the noteUrn
	 */
	public PatientTIUNoteURN getNoteUrn()
	{
		return noteUrn;
	}

	/**
	 * @return the date
	 */
	public Date getDate()
	{
		return date;
	}

	/**
	 * @return the addendumText
	 */
	public String getAddendumText()
	{
		return addendumText;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "createTIUNoteAddendum";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[]{PatientTIUNoteURN.class, Date.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getNoteUrn(), getDate(), getAddendumText()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected PatientTIUNoteURN getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.createTIUNoteAddendum(getNoteUrn(), getDate(), getAddendumText());
	}

}
