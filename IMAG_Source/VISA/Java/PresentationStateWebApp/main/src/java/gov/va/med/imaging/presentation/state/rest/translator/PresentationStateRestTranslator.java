/**
 * 
 */
package gov.va.med.imaging.presentation.state.rest.translator;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordType;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordsType;
import gov.va.med.imaging.presentation.state.rest.types.StudyContextsType;

/**
 * @author William Peterson
 *
 */
public class PresentationStateRestTranslator {

	public static List<PresentationStateRecord> translatePSRecordsType(PresentationStateRecordsType typeList){
		PresentationStateRecordType[] psRecordTypes = typeList.getPStateRecords();
		List<PresentationStateRecord> psRecordList = new ArrayList<PresentationStateRecord>(psRecordTypes.length);
		for(int i=0; i<psRecordTypes.length; i++){
			PresentationStateRecord temp = translatePSRecordType(psRecordTypes[i]);
			psRecordList.add(temp);
		}
		return psRecordList;
	}
	
	public static PresentationStateRecord translatePSRecordType(PresentationStateRecordType type){
		PresentationStateRecord record = new PresentationStateRecord();

		record.setpStateUID(type.getPStateUID());
		record.setStudyUID(type.getPStateStudyUID());
		record.setpStateName(type.getPStateName());
		record.setSource(type.getPStateSource());
		record.setPsData(type.getPStateData());
		record.setIncludeDeleted(type.isIncludeDeleted());
		record.setIncludeDetails(type.isIncludeDetails());
		record.setIncludeOtherUsers(type.isIncludeOtherUsers());
		
		return record;
	}
	
	public static PresentationStateRecordsType translatePSRecords(List<PresentationStateRecord> records){

		if(records == null)
			return null;
		
		PresentationStateRecordType [] result = new PresentationStateRecordType[records.size()];
		for(int i = 0; i < records.size(); i++)
		{
			result[i] = translatePSRecord(records.get(i));
		}
		
		return new PresentationStateRecordsType(result);		
	}
	
	private static PresentationStateRecordType translatePSRecord(PresentationStateRecord record)
	{
		return new PresentationStateRecordType(record.getStudyUID(), 
					record.getpStateUID(), record.getpStateName(),
					record.getSource(), record.getPsData(),
					record.getDuz(), record.getTimeStored());
	}

	
	public static List<String> translateStudyContextsType(StudyContextsType typeList){
		String[] studies = typeList.getStudyContexts();
		return Arrays.asList(studies);
	}



}
