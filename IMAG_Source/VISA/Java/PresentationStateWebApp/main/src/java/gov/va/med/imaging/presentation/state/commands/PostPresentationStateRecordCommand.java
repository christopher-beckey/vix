/**
 * 
 */
package gov.va.med.imaging.presentation.state.commands;

import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.DicomRouter;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.rest.translator.PresentationStateRestTranslator;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordType;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.url.vista.StringUtils;

/**
 * @author William Peterson
 *
 */
public class PostPresentationStateRecordCommand 
extends AbstractPresentationStateCommand<Boolean, RestBooleanReturnType> {

	private final String siteId;
	private final String interfaceVersion;
	private final PresentationStateRecordType pStateRecordType;
	private final String dicomFileSpec;
	
	private final Logger logger = Logger.getLogger(PostPresentationStateRecordCommand.class);

	
	public PostPresentationStateRecordCommand(String siteId, String interfaceVersion, String fileSpec, PresentationStateRecordType pStateRecordType) {
		super("PostPresentationStateRecord");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
		this.pStateRecordType = pStateRecordType;
		this.dicomFileSpec = convertDicomFileSpec(fileSpec);
		//logger.debug("Filename string passed in: " + StringUtils.displayEncodedChars(fileSpec));
		//this.dicomFileSpec = FilenameUtils.separatorsToUnix(fileSpec);
		//logger.debug("Filename string converted to :" + StringUtils.displayEncodedChars(this.dicomFileSpec));

	}

	@Override
	protected Boolean executeRouterCommand() throws MethodException,
			ConnectionException {
		RoutingToken routingToken;
		try {
			PresentationStateRecord pStateRecord = PresentationStateRestTranslator.translatePSRecordType(getPStateRecordType());
			routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			if (getDicomFileSpec() != null && !getDicomFileSpec().equals("")){
				this.postDicomFileSpec(getDicomFileSpec(), routingToken);
			}
			logger.debug("Continuing on with posting Presentation State Record.");
			return getRouter().postPresentationStateRecord(routingToken, pStateRecord);
		} catch (RoutingTokenFormatException rtfX) {
			throw new MethodException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "post Presentation State Record [" + getPStateRecordType().getPStateStudyUID() + ";" + getPStateRecordType().getPStateUID() +" ]";
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
			throws TranslationException, MethodException {
		return new RestBooleanReturnType(routerResult);
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass() {
		return RestBooleanReturnType.class;
	}

	@Override
	public String getInterfaceVersion() {
		
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult) {
		
		return null;
	}

	public String getSiteId() {
		return siteId;
	}


	public String getDicomFileSpec() {
		return dicomFileSpec;
	}

	public PresentationStateRecordType getPStateRecordType() {
		return pStateRecordType;
	}

	private void postDicomFileSpec(String fileSpec, RoutingToken routingToken){
		DicomRouter router = DicomContext.getRouter();
		
		logger.debug("Sending DICOM object file to appropriate router command.");
		router.postDicomObjectFile(routingToken, fileSpec);
		logger.debug("Sent DICOM object file to appropriate router command.");
		
	}
	
	private String convertDicomFileSpec(String infile){
		String temp = null;
        logger.debug("Filename string passed in: {}", infile);
		if(infile != null){
			temp = infile.trim();
			String[] parts = temp.split("\\\\\\\\");
			StringBuffer buf = new StringBuffer();
			for(int i=0; i<parts.length; i++){
				buf.append(parts[i]);
				if(i != parts.length-1)
				buf.append("\\");
			}
			temp = buf.toString();
			temp = temp.replace("\"", "");
            logger.debug("Filename string converted to: {}", temp);
		}
		return temp;

	}

	
}
