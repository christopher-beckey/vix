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

public class GetStoreCommitWorkItemCommandImpl 
extends AbstractDicomSCDataSourceCommandImpl<StorageCommitWorkItem>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getSCWorkItem";

	private final String scWIID;
	private final Boolean doProcess;
	
	public GetStoreCommitWorkItemCommandImpl(String scWIID, Boolean doProcess)
	{
		this.scWIID = scWIID;
		this.doProcess = doProcess;		
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class, Boolean.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getSCWIID(), getDoProcess()} ;
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
	protected StorageCommitWorkItem getCommandResult(
			WorkListDataSourceSpi spi) 
	throws ConnectionException, MethodException 
	{
		return spi.getSCWorkItem(getSCWIID(), getDoProcess());
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
	public Boolean getDoProcess() {
		return doProcess;		
	}
}
