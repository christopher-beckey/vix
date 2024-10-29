package gov.va.med.imaging.core.router.commands;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.DicomServicesDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class GetDicomReportTextCommandImpl 
extends AbstractDataSourceCommandImpl<String, DicomServicesDataSourceSpi> {

	private Logger logger = LogManager.getLogger(GetDicomReportTextCommandImpl.class);
	private static final String SPI_METHOD_NAME = "getDicomReportText";
	private RoutingToken routingToken;
	private WorkItem workItem;

	private static final long serialVersionUID = 1L;

	public GetDicomReportTextCommandImpl(RoutingToken routingToken, WorkItem workItem){
		this.routingToken = routingToken;
		this.workItem = workItem;
	}
	
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class, WorkItem.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken(), getWorkItem()} ;
	}
	
	public RoutingToken getRoutingToken() {
		return this.routingToken;
	}
	
	public WorkItem getWorkItem(){
		return this.workItem;
	}

	@Override
	protected String getCommandResult(DicomServicesDataSourceSpi spi)
			throws ConnectionException, MethodException {
		if(logger.isDebugEnabled()){logger.debug(this.getClass().getName()+": Executing Router command.");}
		String reportText = spi.getDicomReportText(getRoutingToken(), getWorkItem());
		
		return reportText;
	}
	
	@Override
	protected Class<DicomServicesDataSourceSpi> getSpiClass() {
		return DicomServicesDataSourceSpi.class;
	}

	@Override
	protected String getSiteNumber() {
		return TransactionContextFactory.get().getSiteNumber();
	}


}
