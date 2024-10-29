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
public class PostTIUElectronicallySignNoteCommandImpl
extends AbstractTIUDataSourceCommandImpl<Boolean>
{
	private static final long serialVersionUID = 4821274387111094867L;
	
	private final PatientTIUNoteURN tiuNoteUrn;
	private final String electronicSignature;

	/**
	 * @param routingToken
	 */
	public PostTIUElectronicallySignNoteCommandImpl(PatientTIUNoteURN tiuNoteUrn,
		String electronicSignature)
	{
		super(tiuNoteUrn);
		this.tiuNoteUrn = tiuNoteUrn;
		this.electronicSignature = electronicSignature;
	}

	/**
	 * @return the tiuNoteUrn
	 */
	public PatientTIUNoteURN getTiuNoteUrn()
	{
		return tiuNoteUrn;
	}

	/**
	 * @return the electronicSignature
	 */
	public String getElectronicSignature()
	{
		return electronicSignature;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "electronicallySignTIUNote";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?> []{PatientTIUNoteURN.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getTiuNoteUrn(), getElectronicSignature()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.electronicallySignTIUNote(getTiuNoteUrn(), getElectronicSignature());
	}

}
