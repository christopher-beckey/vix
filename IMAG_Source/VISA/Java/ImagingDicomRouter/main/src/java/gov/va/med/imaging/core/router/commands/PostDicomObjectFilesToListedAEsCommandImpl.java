/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.DicomRouter;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author William Peterson
 *
 */
@RouterCommandExecution(asynchronous=true, distributable=true)
public class PostDicomObjectFilesToListedAEsCommandImpl 
extends AbstractCommandImpl<java.lang.Void> {

	private static final long serialVersionUID = 1L;
	private RoutingToken routingToken = null;
	private List<String> dicomFileList = null;
	private List<DicomAE> dicomAEList = null;

	private Logger logger = Logger.getLogger(PostDicomObjectFilesToListedAEsCommandImpl.class);


	public PostDicomObjectFilesToListedAEsCommandImpl(RoutingToken routingToken, List<String> dicomFiles){
		super();
		this.routingToken = routingToken;
		this.dicomFileList = dicomFiles;
		
	}
	
	@Override
	public Void callSynchronouslyInTransactionContext() throws MethodException, ConnectionException {

		DicomRouter router = DicomContext.getRouter();
		// get DICOM AE list from Dicom Services
		this.dicomAEList = getAEList();
		// if no AEs in list, terminate without exception, but put warning in log.
		if (this.dicomAEList == null || this.dicomAEList.isEmpty()){
			logger.warn("There are no DICOM AEs in the DICOM Services Configuration.");
			return null;
		}
		// if no images in list, terminate and log the exception
		if(this.dicomFileList == null || this.dicomFileList.isEmpty()){
			logger.error("There are no DICOM Object files given to send via DICOM Services.");
			return null;
		}
			//loop thru AE list
			for (DicomAE ae : this.dicomAEList){
				try{
					if(ae != null){
						//call sendToAEDataSourceCommand to send to AE destination.
						if(logger.isDebugEnabled()){
                            logger.debug("Sending image(s) to DICOM AE {} from VIX.", ae.getRemoteAETitle()); }
						router.postToAE(getRoutingToken(), ae, getDicomFileList());
					}
				}
				catch(MethodException mX){
					logger.error(mX.getMessage(), mX);
					
				}
				catch(ConnectionException cX){
					logger.error(cX.getMessage(), cX);
				}
				catch(Exception X){
					logger.error(X.getMessage(),X);
				}
				
			}
			// end loop
		return null;
	}
	
	public RoutingToken getRoutingToken(){
		return this.routingToken;
	}
	
	public List<String> getDicomFileList(){
		return this.dicomFileList;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		final PostDicomObjectFilesToListedAEsCommandImpl other = (PostDicomObjectFilesToListedAEsCommandImpl) obj;
		if (this.routingToken == null)
		{
			if (other.routingToken != null)
				return false;
		} else if (!this.routingToken
				.equals(other.routingToken))
			return false;
		if (this.dicomFileList == null)
		{
			if (other.dicomFileList != null)
				return false;
		} else if (!this.dicomFileList
				.equals(other.dicomFileList))
			return false;
		return true;
	}

	@Override
	protected String parameterToString() {
		StringBuffer sb = new StringBuffer();
		
		sb.append(this.getRoutingToken());
		sb.append(this.getDicomFileList());		
		
		return sb.toString();
	}

	private List<DicomAE> getAEList() throws MethodException, ConnectionException{
		DicomRouter router = DicomContext.getRouter();
		
		List<DicomAE> configList = router.getAEList(getRoutingToken());
		if(logger.isDebugEnabled()){
            logger.debug("Number of AEs in list: {}", configList.size());}
		
		List<DicomAE> list = new ArrayList<DicomAE>();
		
		//loop thru AE list
		for (DicomAE ae : configList){
					
			//validate critical metadata for each AE			
			//if not all metadata exist, issue a GetRemoteAECommand to fill in the missing metadata
			try{
				if(!ae.containsConnectionData()){
					//call GetRemoteAECommand data source command.
					if(logger.isDebugEnabled()){
                        logger.debug("Getting connection data for DICOM AE: {}", ae.getRemoteAETitle());}
					ae = router.getRemoteServiceAE(getRoutingToken(), DicomAE.searchMode.REMOTE_AE, ae.getRemoteAETitle(), getSiteNumber());
				}
				list.add(ae);
			}
			catch(MethodException mX){
                logger.error("Failed to get AE Connection data for DICOM AE: {}. {}", ae.getRemoteAETitle(), mX.getMessage());
                logger.error("DICOM AE {} will not be sent images.", ae.getRemoteAETitle());
			}
			catch(ConnectionException cX){
                logger.error("Failed to get AE Connection data for DICOM AE: {}. {}", ae.getRemoteAETitle(), cX.getMessage());
                logger.error("DICOM AE {} will not be sent images.", ae.getRemoteAETitle());
			}
		}
		// end loop
		configList.clear();
		configList = null;
		return list;
	}
	

	protected String getSiteNumber() {
		return TransactionContextFactory.get().getSiteNumber();
	}


}
