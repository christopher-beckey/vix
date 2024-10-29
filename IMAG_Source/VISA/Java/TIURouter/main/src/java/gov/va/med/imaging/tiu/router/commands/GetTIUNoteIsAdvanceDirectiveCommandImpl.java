/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNoteIsAdvanceDirectiveCommandImpl
extends AbstractTIUDataSourceCommandImpl<Boolean>
{

	private static final long serialVersionUID = -7215636211541556033L;
	
	private final TIUItemURN noteUrn;
	
	public GetTIUNoteIsAdvanceDirectiveCommandImpl(TIUItemURN noteUrn)
	{
		super(noteUrn);
		this.noteUrn = noteUrn;
	}

	/**
	 * @return the noteUrn
	 */
	public TIUItemURN getNoteUrn()
	{
		return noteUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "isNoteValidAdvanceDirective";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {TIUItemURN.class};
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
	protected Boolean getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.isNoteValidAdvanceDirective(getNoteUrn());
	}

}
