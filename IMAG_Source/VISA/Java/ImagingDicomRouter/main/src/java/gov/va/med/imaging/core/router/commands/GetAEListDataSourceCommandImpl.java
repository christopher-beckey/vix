package gov.va.med.imaging.core.router.commands;

import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.DicomServicesDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class GetAEListDataSourceCommandImpl 
extends AbstractDataSourceCommandImpl<List<DicomAE>,DicomServicesDataSourceSpi> {

	private Logger logger = Logger.getLogger(GetAEListDataSourceCommandImpl.class);
	private static final String SPI_METHOD_NAME = "getAEList";
	private RoutingToken routingToken;

	private static final long serialVersionUID = 1L;

	public GetAEListDataSourceCommandImpl(RoutingToken routingToken){
		this.routingToken = routingToken;
	}
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken()} ;
	}
	
	public RoutingToken getRoutingToken(){
		return this.routingToken;
	}

	@Override
	protected List<DicomAE> getCommandResult(DicomServicesDataSourceSpi spi)
			throws ConnectionException, MethodException {
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router command.", this.getClass().getName());}
		List<DicomAE> list = spi.getAEList(getRoutingToken());
		
		//if(logger.isDebugEnabled()){logger.debug(list.toString());}
		
		return list;
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
