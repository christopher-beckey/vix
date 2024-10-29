/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;

/**
 * @author Julian Werfel
 *
 */
public class PostTIUNoteWithImageCommandImpl
extends AbstractTIUDataSourceCommandImpl<Boolean>
{

	private static final long serialVersionUID = 7015237674873631620L;
	private final AbstractImagingURN imagingUrn;
	private final PatientTIUNoteURN tiuNoteUrn;
	
	/**
	 * @param routingToken
	 */
	public PostTIUNoteWithImageCommandImpl(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuNoteUrn)
	{
		super(imagingUrn);
		this.imagingUrn = imagingUrn;
		this.tiuNoteUrn = tiuNoteUrn;
	}

	/**
	 * @return the imagingUrn
	 */
	public AbstractImagingURN getImagingUrn()
	{
		return imagingUrn;
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
		return "associateImageWithTIUNote";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {AbstractImagingURN.class, PatientTIUNoteURN.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getImagingUrn(), getTiuNoteUrn()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.associateImageWithTIUNote(getImagingUrn(), getTiuNoteUrn());
	}

}
