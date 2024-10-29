/**
 * 
 * 
 * Date Created: Feb 10, 2014
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
public class PostTIUElectronicallyFileNoteCommandImpl
extends AbstractTIUDataSourceCommandImpl<Boolean>
{
	private static final long serialVersionUID = 4821274387111094867L;
	
	private final PatientTIUNoteURN tiuNoteUrn;

	/**
	 * @param routingToken
	 */
	public PostTIUElectronicallyFileNoteCommandImpl(PatientTIUNoteURN tiuNoteUrn)
	{
		super(tiuNoteUrn);
		this.tiuNoteUrn = tiuNoteUrn;
	}

	/**
	 * @return the tiuNoteUrn
	 */
	public PatientTIUNoteURN getTiuNoteUrn()
	{
		return tiuNoteUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "electronicallyFileTIUNote";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?> []{PatientTIUNoteURN.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getTiuNoteUrn()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.electronicallyFileTIUNote(getTiuNoteUrn());
	}
}
