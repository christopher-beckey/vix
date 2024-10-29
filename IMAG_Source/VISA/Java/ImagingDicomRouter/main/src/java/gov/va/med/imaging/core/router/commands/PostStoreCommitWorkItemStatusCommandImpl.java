package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.WorkListDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

import java.lang.reflect.Method;
import java.util.List;

public class PostStoreCommitWorkItemStatusCommandImpl 
extends AbstractDicomSCDataSourceCommandImpl<Boolean>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "updateSCWorkItemStatus";

	private final String scWIID;
	private final String status;
	
	public PostStoreCommitWorkItemStatusCommandImpl(String scWIID, String status)
	{
		this.scWIID = scWIID;
		this.status = status;		
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getSCWIID(), getStatus()} ;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(
			WorkListDataSourceSpi spi) 
	throws ConnectionException, MethodException 
	{
		return spi.updateSCWorkItemStatus(getSCWIID(), getStatus());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
//	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	/**
	 * @return the SC WI ID 
	 */
	public String getSCWIID() {
		return scWIID;
	}
	/**
	 * @return the process flag 
	 */
	public String getStatus() {
		return status;		
	}
}
