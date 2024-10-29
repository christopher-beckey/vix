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

@RouterCommandExecution(asynchronous=true, distributable=true)
public class PostDicomObjectFileCommandImpl 
extends AbstractCommandImpl<java.lang.Void> {


	private static final long serialVersionUID = 1L;
	private RoutingToken routingToken = null;
	private String dicomFileSpec = null;

	private Logger logger = Logger.getLogger(PostDicomObjectFileCommandImpl.class);


	public PostDicomObjectFileCommandImpl(RoutingToken routingToken, String dicomFilename) {
		super();
		this.routingToken = routingToken;
		this.dicomFileSpec = dicomFilename;
	}

	@Override
	public Void callSynchronouslyInTransactionContext() throws MethodException, ConnectionException {
		try{
		if(logger.isDebugEnabled()){
            logger.debug("VIX Viewer DICOM object cached file: {}", getDicomFileSpec());}
		DicomRouter router = DicomContext.getRouter();
		List<String> dicomFileList = new ArrayList<String>();
		dicomFileList.add(getDicomFileSpec());
		router.postDicomObjectFilesToListedAEs(getRoutingToken(), dicomFileList);
		}
		catch(Throwable tX){
			logger.error(tX.getMessage());
			logger.error(tX);
		}
		return null;
	}
	
	public RoutingToken getRoutingToken(){
		return this.routingToken;
	}
	
	public String getDicomFileSpec(){
		return this.dicomFileSpec;
	}
	

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		final PostDicomObjectFileCommandImpl other = (PostDicomObjectFileCommandImpl) obj;
		if (this.routingToken == null)
		{
			if (other.routingToken != null)
				return false;
		} else if (!this.routingToken
				.equals(other.routingToken))
			return false;
		if (this.dicomFileSpec == null)
		{
			if (other.dicomFileSpec != null)
				return false;
		} else if (!this.dicomFileSpec
				.equals(other.dicomFileSpec))
			return false;
		return true;
	}

	@Override
	protected String parameterToString() {
		StringBuffer sb = new StringBuffer();
		
		sb.append(this.getRoutingToken());
		sb.append(this.getDicomFileSpec());		
		
		return sb.toString();
	}
	

}
