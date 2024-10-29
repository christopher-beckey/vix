/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNoteTextCommandImpl
extends AbstractTIUDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = 3291789628625140491L;
	
	private final PatientTIUNoteURN noteUrn;
	public GetTIUNoteTextCommandImpl(PatientTIUNoteURN noteUrn)
	{
		super(noteUrn);
		this.noteUrn = noteUrn;
	}
	
	/**
	 * @return the noteUrn
	 */
	public PatientTIUNoteURN getNoteUrn()
	{
		return noteUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getTIUNoteText";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {PatientTIUNoteURN.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getNoteUrn()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getTIUNoteText(getNoteUrn());
	}

}
