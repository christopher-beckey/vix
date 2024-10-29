/**
 * 
 */
package gov.va.med.imaging.presentation.state.datasource;

import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;

import java.util.*;

import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 *
 */
public class VistaImagingPresentationStateQueryFactory {

	
	private static final String RPC_GET_STUDY_PSTATE_DETAILS = "MAGN ANNOT GET IMAGE ANNOT";
	private static final String RPC_GET_PSTATE_DETAILS = "MAGN ANNOT GET PSTATE";
	private static final String RPC_GET_PSTATE_RECORDS = "MAGN ANNOT GET STUDY";
	private static final String RPC_CREATE_PSTATE_RECORD = "MAGN ANNOT STORE STUDY";
	
	private final static int maxLineLength = 230;
	
	private final static Logger logger = Logger.getLogger(VistaImagingPresentationStateQueryFactory.class);
	
	/**
	 *  Constructor
	 */
	public VistaImagingPresentationStateQueryFactory() {
		
	}

	
	public static VistaQuery deletePSRecordQuery(PresentationStateRecord pStateRecord){

		VistaQuery vistaQuery = new VistaQuery(RPC_CREATE_PSTATE_RECORD);
		HashMap<String, String> parameters = new HashMap<String, String>();
		getPSRecordAsMap(parameters, pStateRecord);
		parameters.put("\"DELETED\"", "1");
		vistaQuery.addParameter(VistaQuery.LIST, parameters);

		return vistaQuery;
	}
	
	public static VistaQuery getPSDetailsQuery(List<PresentationStateRecord> pStateRecords){
		//for current testing, we are only passing in the first pStateUID.
		//	We will convert to the List later.
		
		VistaQuery vistaQuery = new VistaQuery(RPC_GET_PSTATE_DETAILS);
		HashMap<String, String> parameters = new HashMap<String, String>();
		getPSDetailsAsMap(parameters, pStateRecords);
		vistaQuery.addParameter(VistaQuery.LIST, parameters);
		
		return vistaQuery;
	}
	
	public static VistaQuery getStudyPSDetailsQuery(String studyContext){
		
		VistaQuery vistaQuery = new VistaQuery(RPC_GET_STUDY_PSTATE_DETAILS);
		if (studyContext.toLowerCase(Locale.ENGLISH).startsWith("urn:vastudy"))
		{
			String magIen = StringUtils.Piece(studyContext,"-",2);
			studyContext = "^^^MAG^" + magIen;
		}
		vistaQuery.addParameter(VistaQuery.LITERAL, studyContext);
		
		return vistaQuery;
	}

	public static VistaQuery getPSRecordsQuery(PresentationStateRecord pStateRecord){
		
		VistaQuery vistaQuery = new VistaQuery(RPC_GET_PSTATE_RECORDS);
		Map<String,String> parameter1 = new HashMap<String,String>();
		parameter1.put("1", pStateRecord.getStudyUID());
		vistaQuery.addParameter(VistaQuery.LIST, parameter1);
		
		//optional PARAM2="DUW"  
		//D - include deleted annotations 
		//U - include all user's annotations
		//W - include word processing fields)
		StringBuffer parameter2 = new StringBuffer();
		if(pStateRecord.isIncludeDeleted()){
			parameter2.append("D");
		}
		if(pStateRecord.isIncludeOtherUsers()){
			parameter2.append("U");
		}
		if(pStateRecord.isIncludeDetails()){
			parameter2.append("W");
		}
		vistaQuery.addParameter(VistaQuery.LITERAL, parameter2.toString());
		
		return vistaQuery;
	}
	
	public static VistaQuery createPSDetailQuery(PresentationStateRecord pStateRecord){

		VistaQuery vistaQuery = new VistaQuery(RPC_CREATE_PSTATE_RECORD);
		HashMap<String, String> parameters = new HashMap<String, String>();
		getPSDetailAsMap(parameters, pStateRecord);
		getDetailsXMLAsMap(parameters, pStateRecord);
		vistaQuery.addParameter(VistaQuery.LIST, parameters);

		return vistaQuery;
	}
	
	public static VistaQuery createPSRecordQuery(PresentationStateRecord pStateRecord){
		
		VistaQuery vistaQuery = new VistaQuery(RPC_CREATE_PSTATE_RECORD);
		HashMap<String, String> parameters = new HashMap<String, String>();
		getPSRecordAsMap(parameters, pStateRecord);
		getDetailsXMLAsMap(parameters, pStateRecord);
		vistaQuery.addParameter(VistaQuery.LIST, parameters);

		return vistaQuery;
	}
	
	

	private static void getPSRecordAsMap(Map<String,String> parameters, PresentationStateRecord pStateRecord)
	{
		if(pStateRecord == null)
			return;
		
		parameters.put("\"STUDY UID\"", pStateRecord.getStudyUID());
		parameters.put("\"PSTATE UID\"", pStateRecord.getpStateUID());
		parameters.put("\"NAME\"", pStateRecord.getpStateName());
		parameters.put("\"SOURCE\"", pStateRecord.getSource());
		
		return;
	}

	private static void getPSDetailAsMap(Map<String,String> parameters, PresentationStateRecord pStateRecord)
	{
		if(pStateRecord == null)
			return;
		
		parameters.put("\"STUDY UID\"", pStateRecord.getStudyUID());
		parameters.put("\"PSTATE UID\"", pStateRecord.getpStateUID());
		
		return;
	}

	private static void getPSDetailsAsMap(Map<String,String> parameters, List<PresentationStateRecord> pStateRecords)
	{
		if(pStateRecords == null)
			return;
		
		for(int i=0; i<pStateRecords.size(); i++){
			
			parameters.put("\"" + Integer.toString(i+1) + "\"", pStateRecords.get(i).getpStateUID());
		}
		return;
	}

	private static void getDetailsXMLAsMap(Map<String,String> parameters, PresentationStateRecord pStateRecord){
		
		if(pStateRecord.getPsData() != null)
		{
			String encodedPSData = VistaImagingPresentationStateTranslator.translatePSRecordPlainData(pStateRecord.getPsData());
			List<String> detailLines = splitLineIntoShorterLines(encodedPSData);
			if(detailLines != null)
			{
				for(int i = 0; i < detailLines.size(); i++)
				{
					parameters.put("\""+Integer.toString(i+1)+"\"", detailLines.get(i));
				}
			}
			else{
				logger.warn("No Presentation State Data to decompose.");
			}
		}
	}
	
	private static List<String> splitLineIntoShorterLines(String xmlString)
	{
		if(xmlString == null)
			return null;
		List<String> shortLines = new ArrayList<String>();
		while(xmlString.length() > maxLineLength)
		{
			String subLine = xmlString.substring(0, maxLineLength);
			shortLines.add(subLine);
			xmlString = xmlString.substring(maxLineLength);
		}
		shortLines.add(xmlString);
		return shortLines;
	}
}
