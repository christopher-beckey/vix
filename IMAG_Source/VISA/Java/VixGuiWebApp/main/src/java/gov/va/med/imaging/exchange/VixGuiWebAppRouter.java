package gov.va.med.imaging.exchange;

import java.io.InputStream;
import java.util.Date;
import java.util.List;

import gov.va.med.imaging.access.TransactionLogWriter;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.enums.DatasourceProtocol;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.javalogs.JavaLogFile;
import gov.va.med.imaging.transactions.TransactionLogQuery;

/**
 * 
 * @author vhaiswbeckec
 *
 */
@FacadeRouterInterface//(extendsClassName="gov.va.med.imaging.BaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface VixGuiWebAppRouter
extends FacadeRouter
{
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="ProcessSiteServiceCacheRefreshCommand")
	public abstract void refreshSiteServiceCache()
	throws MethodException, ConnectionException;	
	
	@FacadeRouterMethod(asynchronous = false, commandClassName = "GetTransactionLogEntriesCommand")
	public abstract void getTransactionLogEntries(
			TransactionLogWriter transactionLogWriter,			
			String fieldName,
			String fieldValue) 
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous = false, commandClassName = "GetTransactionLogEntriesCommand")
	public abstract void getTransactionLogEntries(
			TransactionLogWriter transactionLogWriter,
			Date               startDate,
			Date               endDate, 
			ImageQuality       imageQuality, 
			String             user, 
			String             modality, 
			DatasourceProtocol datasourceProtocol,
			String             errorMessage,
			String             imageUrn,
			String             transactionId, 
			Boolean            forward,
			Integer            startIndex,
			Integer            endIndex) 
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetJavaLogListCommand")
	public abstract List<JavaLogFile> getJavaLogFiles()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetJavaLogFileCommand")
	public abstract InputStream getJavaLogFile(String filename)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous = false, commandClassName = "GetTransactionLogEntriesByTransactionIdCommand")
	public abstract void getTransactionLogEntriesByTransactionId(
			TransactionLogWriter transactionLogWriter,			
			String transactionId) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous = false, commandClassName = "GetTransactionLogEntriesByQueryCommand")
	void getTransactionLogEntries(TransactionLogWriter writer, TransactionLogQuery query) throws MethodException, ConnectionException;
}
