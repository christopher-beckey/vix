/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNoteIsConsultCommandImpl
extends AbstractTIUDataSourceCommandImpl<Boolean>
{
	private static final long serialVersionUID = -1192308678305570082L;
	
	private final TIUItemURN tiuNoteUrn;
	
	public GetTIUNoteIsConsultCommandImpl(TIUItemURN tiuNoteUrn)
	{
		super(tiuNoteUrn);
		this.tiuNoteUrn = tiuNoteUrn;
	}

	/**
	 * @return the tiuNoteUrn
	 */
	public TIUItemURN getTiuNoteUrn()
	{
		return tiuNoteUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "isTIUNoteAConsult";
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
		return new Object[] {getTiuNoteUrn()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.isTIUNoteAConsult(getTiuNoteUrn());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#postProcessResult(java.lang.Object)
	 */
	@Override
	protected Boolean postProcessResult(Boolean result)
	{
		TransactionContextFactory.get().addDebugInformation("TIU Note [" + getTiuNoteUrn() + "] is " + (result == false ? "not " : "") + "a consult");
		
		return super.postProcessResult(result);
	}

}
