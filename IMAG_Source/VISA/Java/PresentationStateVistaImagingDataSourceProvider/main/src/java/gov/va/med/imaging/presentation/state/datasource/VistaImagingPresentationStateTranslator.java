/**
 * 
 */
package gov.va.med.imaging.presentation.state.datasource;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.url.vista.StringUtils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;


/**
 * @author William Peterson
 *
 */
public class VistaImagingPresentationStateTranslator {

	
	private final static Logger logger = Logger.getLogger(VistaImagingPresentationStateTranslator.class);

	public VistaImagingPresentationStateTranslator() {
		
	}

	public static List<PresentationStateRecord> translatePSDetails(String result)
	throws MethodException{
		if(result == null){
			throw new MethodException("RPC response from VistA is null.");
		}

		//Split result into String array on \r\n
		String[] lines = StringUtils.Split(result, StringUtils.CRLF);
		String status = StringUtils.MagPiece(lines[0], StringUtils.CARET, 1);
		int iStatus = Integer.valueOf(status);
		//check if 0 for success and other for failure
		if(iStatus < 0){
			if(lines[0].contains("not found")){
				return null;
			}
			//if failure, throw MethodException with exception details
			throw new MethodException("VistA return error: " + status +", " + lines[0]);
		}
		
		List<PresentationStateRecord> psList = new ArrayList<PresentationStateRecord>();
		
		PresentationStateRecord psRecord = null;
		StringBuffer buffer = null;
		
		//create FOR loop at lines index i=2
		for(int i=2; i<lines.length; i++){
			//get 1st piece out of lines[i]
			String lineType = StringUtils.MagPiece(lines[i], StringUtils.CARET, 1);
			//if lines[i] has ANNOTATION GROUP prefix
			if(lineType.contains("ANNOTATION GROUP")){
				//create new PresentationStateRecord object
				psRecord = new PresentationStateRecord();
				//split out lines[i] and store in PSRecord object
				psRecord.setpStateUID(StringUtils.MagPiece(lines[i], StringUtils.CARET, 3));
				psRecord.setpStateName(StringUtils.MagPiece(lines[i], StringUtils.CARET, 19));
				psRecord.setSource(StringUtils.MagPiece(lines[i], StringUtils.CARET, 11));
				psRecord.setDuz(StringUtils.MagPiece(lines[i], StringUtils.CARET, 5));
				psRecord.setTimeStored(StringUtils.MagPiece(lines[i], StringUtils.CARET, 8));
				//add PSRecord object to list
				psList.add(psRecord);
			}
			//if lines[i] has PRESENTATION prefix
			else if(lineType.contains("PRESENTATION")){
				//get lineType for next line
				lineType = StringUtils.MagPiece(lines[i], StringUtils.CARET, 1);
				//create new StringBuffer object
				buffer = new StringBuffer();
				//create WHILE loop for data lines
				int j=0;
				for(; i+j<lines.length; j++){
					lineType = StringUtils.MagPiece(lines[i+j], StringUtils.CARET, 1);
					if(lineType.contains("PRESENTATION")){
						//get 2nd piece out of lines[i]
						String partialData = StringUtils.MagPiece(lines[i+j], StringUtils.CARET, 2).trim();
						//append StringBuffer with lines[i]
						buffer.append(partialData);
					}
					else{
						j--;
						break;
					}
				}
				i += j;
				//decode StringBuffer object
				String psData = translatePSRecordEncodedData(buffer.toString());

				PresentationStateRecord temp = psList.get(psList.size()-1);
				//assign decoded StringBuffer object to psData member in PSRecord
				temp.setPsData(psData);
			}
			
		}
        logger.debug("Returning {} Presentation State Records.", psList.size());
		return psList;
	}
	
	public static List<PresentationStateRecord> translatePSRecords(String result)
	throws MethodException{
		
		if(result == null){
			throw new MethodException("RPC response from VistA is null.");
		}

		//Split result into String array on \r\n
		String[] lines = StringUtils.Split(result, StringUtils.CRLF);
		String status = StringUtils.MagPiece(lines[0], StringUtils.CARET, 1);
		int iStatus = Integer.valueOf(status);
		//check if 0 for success and other for failure
		if(iStatus < 0){
			if(lines[0].contains("not found")){
				return null;
			}
			//if failure, throw MethodException with exception details
			throw new MethodException("VistA return error: " + status +", " + lines[0]);
		}
		
		List<PresentationStateRecord> psList = new ArrayList<PresentationStateRecord>();
		
		//set lines[2] piece 2 to a studyuid local variable
		String studyUID = null;
		studyUID = StringUtils.MagPiece(lines[2], StringUtils.CARET, 2);
		PresentationStateRecord psRecord = null;
		StringBuffer buffer = null;
		
		//create FOR loop at lines index i=4
		for(int i=4; i<lines.length; i++){
			//get 1st piece out of lines[i]
			String lineType = StringUtils.MagPiece(lines[i], StringUtils.CARET, 1);
			//if lines[i] has ANNOTATION GROUP prefix
			if(lineType.contains("ANNOTATION GROUP")){
				//create new PresentationStateRecord object
				psRecord = new PresentationStateRecord();
				//split out lines[i] and store in PSRecord object
				if(studyUID != null){
					psRecord.setStudyUID(studyUID);					
				}
				psRecord.setpStateUID(StringUtils.MagPiece(lines[i], StringUtils.CARET, 3));
				psRecord.setpStateName(StringUtils.MagPiece(lines[i], StringUtils.CARET, 19));
				psRecord.setSource(StringUtils.MagPiece(lines[i], StringUtils.CARET, 11));
				psRecord.setDuz(StringUtils.MagPiece(lines[i], StringUtils.CARET, 5));
				psRecord.setTimeStored(StringUtils.MagPiece(lines[i], StringUtils.CARET, 8));
				//add PSRecord object to list
				psList.add(psRecord);
			}
			//if lines[i] has PRESENTATION prefix
			else if(lineType.contains("PRESENTATION")){
				//get lineType for next line
				lineType = StringUtils.MagPiece(lines[i], StringUtils.CARET, 1);
				//create new StringBuffer object
				buffer = new StringBuffer();
				//create WHILE loop for data lines
				int j=0;
				for(; i+j<lines.length; j++){
					lineType = StringUtils.MagPiece(lines[i+j], StringUtils.CARET, 1);
					if(lineType.contains("PRESENTATION")){
						//get 2nd piece out of lines[i]
						String partialData = StringUtils.MagPiece(lines[i+j], StringUtils.CARET, 2).trim();
						//append StringBuffer with lines[i]
						buffer.append(partialData);
					}
					else{
						j--;
						break;
					}
				}
				i += j;
				//decode StringBuffer object
				String psData = translatePSRecordEncodedData(buffer.toString());

				PresentationStateRecord temp = psList.get(psList.size()-1);
				//assign decoded StringBuffer object to psData member in PSRecord
				temp.setPsData(psData);
			}
			
		}
        logger.debug("Returning {} Presentation State Records.", psList.size());
		return psList;
	}
	
	public static String translatePSRecordPlainData(String data){
		
		if(data == null){
			return null;
		}
		StringBuffer buffer = new StringBuffer();
		
		try {
			buffer.append("[!CDATA[");
			String encodedData = URLEncoder.encode(data, "UTF-8");
			buffer.append(encodedData);
			buffer.append("]]");
		} catch (UnsupportedEncodingException e) {
			logger.error("Failed to encode Presentation State Data.");
			return null;
		}
		return buffer.toString();
	}
	
	public static String translatePSRecordEncodedData(String data){
		
		if(data == null){
			return null;
		}
		StringBuffer buffer = new StringBuffer(data);
		String decodedData = null;
		try {
			buffer.delete(buffer.length()-2, buffer.length()-0);
			buffer.delete(0, 8);
			decodedData = URLDecoder.decode(buffer.toString(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			logger.error("Failed to decode Presentation State Data.");
			return null;
		}
		return decodedData;
	}
}
