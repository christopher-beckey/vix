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



public class PostToAEDataSourceCommandImpl 
extends AbstractDataSourceCommandImpl<Void, DicomServicesDataSourceSpi> {


	private DicomAE dicomAE;
	private List<String> dicomFileList;
	private RoutingToken routingToken;
	private static final String SPI_METHOD_NAME = "postToAE";
	private static final long serialVersionUID = 1L;
	
	private Logger logger = Logger.getLogger(PostToAEDataSourceCommandImpl.class);

	
	public PostToAEDataSourceCommandImpl(RoutingToken routingToken, DicomAE ae, List<String> dicomFiles){
		super();
		this.dicomAE = ae;
		this.routingToken = routingToken;
		this.dicomFileList = dicomFiles;
	}

	@Override
	public RoutingToken getRoutingToken() {
		return routingToken;
	}
	
	

	/**
	 * @return the dicomAE
	 */
	public DicomAE getDicomAE() {
		return dicomAE;
	}

	/**
	 * @return the dicomFileList
	 */
	public List<String> getDicomFileList() {
		return dicomFileList;
	}

	@Override
	protected Class<DicomServicesDataSourceSpi> getSpiClass() {
		return DicomServicesDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class, DicomAE.class, List.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken(), getDicomAE(), getDicomFileList()} ;
	}

	@Override
	protected String getSiteNumber() {
		return TransactionContextFactory.get().getSiteNumber();
	}

	@Override
	protected Void getCommandResult(DicomServicesDataSourceSpi spi) throws ConnectionException, MethodException {
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router command.", this.getClass().getName());}
		spi.postToAE(getRoutingToken(), getDicomAE(), getDicomFileList());
		return null;
	}

}
