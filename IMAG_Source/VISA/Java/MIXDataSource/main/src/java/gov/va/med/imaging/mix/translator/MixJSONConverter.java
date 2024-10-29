package gov.va.med.imaging.mix.translator;

import java.util.List;
import java.util.ArrayList;

import gov.va.med.logging.Logger;
import org.json.*;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.mix.DODImageURN;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXImagingStudyException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorResultType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries;


public class MixJSONConverter
{
	private static Logger logger = Logger.getLogger(MixJSONConverter.class);	

	public static ReportStudyListResponseType ConvertDiagnosticReportToJava(String jsonData, String patientIcn)
	{
		ReportStudyListResponseType rslr = null;
		
		try {
			if(logger.isDebugEnabled()){logger.debug("Convert DiagnosticReport(s) JSON response to JSONObject...");}
			JSONObject obj = new JSONObject(jsonData);
			if(logger.isDebugEnabled()){logger.debug("Get DRs JSONArray...");}
			JSONArray dRs = obj.getJSONArray("DRs"); // {"DRs":[...]} assumed 
			if ((dRs==null) || (dRs.length()==0)) {
				return rslr;
			}
			if(logger.isDebugEnabled()){
                logger.debug("Convert {} DRs JSONArray items ...", dRs.length());}

			List<StudyType> studies = new ArrayList<StudyType>();
			List<ErrorResultType> errors = new ArrayList<ErrorResultType>();

			for (int i = 0; i < dRs.length(); i++) {
				if(logger.isDebugEnabled()){
                    logger.debug("Convert DRs JSONArray item {}...", i + 1);}
				JSONObject curDR = dRs.getJSONObject(i);
				if(logger.isDebugEnabled()){
                    logger.debug("Convert DRs JSONArray item {} got object:", i + 1);}
				String status = curDR.getString("status"); // ?check for "final"
				if(logger.isDebugEnabled()){
                    logger.debug("Convert DRs JSONArray item {} status={}", i + 1, status);}

				JSONObject catObj = curDR.getJSONObject("category");
				JSONArray codingArray = catObj.getJSONArray("coding");
				JSONObject codingObj = codingArray.getJSONObject(0);
				String discipline = codingObj.getString("code");

				if(logger.isDebugEnabled()){
                    logger.debug("Convert DRs JSONArray item {} category={}", i + 1, discipline);}
				
				String patId;
				if ((patientIcn != null) && !patientIcn.isEmpty()) {
					patId = patientIcn;
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} KEEP ICN={}", i + 1, patId);}
				} else {
					String subject = curDR.getJSONObject("subject").getString("reference");
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} subject/reference={}", i + 1, subject);}
					patId = subject.replace("Patient/", ""); // take off FHIR
																// Patient
																// resource
																// reference
																// tag, keep id
				}

				String report = curDR.getJSONObject("text").getString("div");
				report = report.replaceAll("<div>", "");
				report = report.replaceAll("</div>", "");
				report = report.replaceAll("<pre>", "");
				report = report.replaceAll("</pre>", "");
				report = report.replaceAll("<p>", "");
				report = report.replaceAll("</p>", "");
				report = report.replaceAll("<b>", "");
				report = report.replaceAll("</b>", "");
				report = Integer.toString(0x82, 16) + "1^^" + report;

				if(logger.isDebugEnabled()){
                    logger.debug("Convert DRs JSONArray item {} report={}", i + 1, report);}

				JSONArray shallowStudies = curDR.getJSONArray("shallowStudy");
				for (int j = 0; j < shallowStudies.length(); j++) {
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {}...", i + 1, j + 1);}
					StudyType study = new StudyType();

					JSONObject curSStudy = shallowStudies.getJSONObject(j);
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} got object:", i + 1, j + 1);}
					String procDate = curSStudy.getString("started"); // ***
																		// "yyyy-MM-ddTHH:MI:SS+HHH:MI"
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} started={}", i + 1, j + 1, procDate);}
					String proc = curSStudy.getString("procedure"); // description
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} procedure={}", i + 1, j + 1, proc);}
					int numSeries = curSStudy.getInt("numberOfSeries");
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} numberOfSeries={}", i + 1, j + 1, numSeries);}
					int numInstances = curSStudy.getInt("numberOfInstances");
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} numberOfInstances={}", i + 1, j + 1, numInstances);}
					JSONArray modalityList = curSStudy.getJSONArray("modalityList");
					String modList = "";
					for (int k = 0; k < modalityList.length(); k++) {
						JSONObject curModality = modalityList.getJSONObject(k);
						String mty = curModality.getString("code");
						if (modList.isEmpty())
							modList = mty;
						else
							modList += "," + mty;
					}
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} modalities={}", i + 1, j + 1, modList);}
					String[] modalities = StringUtil.split(modList, StringUtil.COMMA);
					ModalitiesType mt = new ModalitiesType(modalities);
					String uid = curSStudy.getString("uid");
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {} - study {} uid={}", i + 1, j + 1, uid);}
					study.setDescription(proc);
					study.setProcedureDate(procDate);
					study.setProcedureDescription(modList);
					study.setSeriesCount(numSeries);
					study.setImageCount(numInstances);
					study.setModalities(mt);
					study.setDicomUid(uid);
					study.setReportContent(report);
					study.setPatientId(patId);
					if (discipline != null && !discipline.isEmpty())
						study.setSpecialtyDescription(discipline);

					studies.add(study);
					if(logger.isDebugEnabled()){
                        logger.debug("Convert DRs JSONArray item {}; added study, #studies={}", i + 1, studies.size());}
				}
			}
			rslr = new ReportStudyListResponseType();
			if (studies.size() > 0) {
				if(logger.isDebugEnabled()){logger.debug("Convert DRs JSONArray item: copy studies...");}
				StudyType[] studyTypeArray = new StudyType[studies.size()];
				for (int i = 0; i < studies.size(); i++) {
					studyTypeArray[i] = studies.get(i);
				}
				rslr.setStudies(studyTypeArray);
			} else
				if(logger.isDebugEnabled()){logger.debug("Convert DRs JSONArray item: no studies to copy!");}

		} catch (JSONException je) {
            logger.info("FHIR DiagnosticReport response JSON data object error: {}", je.getMessage());
			return null;
		}
		// ***
		return rslr;
	}
	
	public static StudyType ConvertImagingStudyToJava(String jsonData, String patientIcn, List<String> emptyStudyModalities)
	throws MIXImagingStudyException {
		StudyType st = null;
		try {
		     JSONObject iS = new JSONObject(jsonData);
		     if (iS.length()==0) {
		    	 return st;
		     }
		     st = new StudyType();
		     List<SeriesType> series = new ArrayList<SeriesType>();
		     DODImageURN dodURN = new DODImageURN();
		     
		     String started = iS.getString("started"); // *** "yyyy-MM-ddTHH:MI:SS+HHH:MI"
		     String patId;
		     if ((patientIcn!=null) && !patientIcn.isEmpty())
		       	 patId=patientIcn;
			 else {
		    	 String patRef = iS.getJSONObject("patient").getString("reference");
		    	 patId = patRef.replace("Patient/", ""); // take off FHIR Patient resource reference prefix
		     } 
		     String stdUid = iS.getString("uid");
		     String accessionNum = iS.getJSONObject("accession").getString("value"); // no Study ID from HAIMS, use accession#
		     // compose a fake study id as a studyUrn using urn:vastudy:200-<accvalue>-<patId> to pass MixTranslator
		     String stdId = "urn:vastudy:200-" + accessionNum + "-" + patId;
		     JSONArray procList = iS.getJSONArray("procedure"); // array, getting first element's "reference" value
		     String proc = procList.getJSONObject(0).getString("reference");
		     String desc = iS.getString("description");
		     // cpt 3/4/18: JLV externalContextId logic support fix: tuck "accession" JSON value in [] in front of study description field
		     //             Note: JLV assumes that parent DiagnostiReport's "text"."div" field (report text) contains the same alternate Exam# string 
		     //                   in-line after the "Exam#: " entry (was never true in Silver test data, only in production data)
		     if (desc==null) desc = "";
		     if (!desc.startsWith("[")) {
		    	 desc = "[" + accessionNum + "] " + desc; // prepend Description filed with "[<extContextId>] " 
		     }
		     int numSeries = iS.getInt("numberOfSeries");
		     int numInstances = iS.getInt("numberOfInstances");
		     String mtyList = "";
		     JSONArray modalityList = iS.getJSONArray("modalityList"); // array, getting "code" from each member
		     for (int k = 0; k < modalityList.length(); k++) {
		    	 JSONObject curModality = modalityList.getJSONObject(k);
			     String aMty = curModality.getString("code");
			     // skip (leave off) empty modality types
			     if (isEmptyModality(aMty, emptyStudyModalities)) continue;
			     if (mtyList.isEmpty()) {
			    	 mtyList = aMty;
			     } else {
			    	 mtyList += "," + aMty;
			     }
		     }		     
		     String[] modalities = StringUtil.split(mtyList, StringUtil.COMMA);
		     ModalitiesType mt = new ModalitiesType(modalities);
		     // convert JSON date to DicomDate
		     String procDate="";
		     if ((started!=null) && (started.length()>=20)) {
		    	 procDate = started.replace("-", "").replace("T", "").replace(":", "").substring(0, 14); // UTC is ignored !!!
		     }
		     
		     st.setProcedureDate(procDate);
		     st.setPatientId(patId);
		     st.setStudyId(stdId);
		     st.setDicomUid(stdUid);
		     st.setModalities(mt);
		     st.setSeriesCount(numSeries);
		     st.setImageCount(numInstances);
		     // st.setProcedureDescription(proc);
		     // make sure comma separated modality list is in procedure field!
		     st.setProcedureDescription(mtyList);
		     st.setDescription(desc);
		     //st.setReportContent(report); // cannot be filled here!!! -  make sure it's not lost from diagnostic report query!

		     JSONArray serieses = iS.getJSONArray("series");
		     for (int i = 0; i < serieses.length(); i++) {
		    	 SeriesType serT = new SeriesType();
			     List<InstanceType> instances = new ArrayList<InstanceType>();
			     
		    	 JSONObject curSeries = serieses.getJSONObject(i);
				 int serNum = curSeries.getInt("number");
			     String modality = curSeries.getJSONObject("modality").getString("code");
			     String serUid = curSeries.getString("uid");
			     // String serDesc = curSeries.getString("description");
			     int numSerInstances = curSeries.getInt("numberOfInstances");
			     if (isEmptyModality(modality, emptyStudyModalities)) {
			    	 // adjust study counters and skip series (continue)
			    	 if (numSeries > 0) {
			    		 numSeries--;
					     st.setSeriesCount(numSeries);
			    	 }
			    	 if (numInstances > numSerInstances) {
			    		 numInstances-=numSerInstances;
					     st.setImageCount(numInstances);
			    	 } else {
			    		 numInstances=0;
					     st.setImageCount(numInstances);		    		 
			    	 }		    		 
			    	 continue; // skip series insertion (and it's instances insertion as well)
			     }
			     serT.setDicomSeriesNumber(serNum);
			     serT.setModality(modality);
			     serT.setDicomUid(serUid);
			     // serT.setDescription(serDesc);
			     serT.setImageCount(numSerInstances);
			     
			     JSONArray insts = curSeries.getJSONArray("instance");
			     for (int j = 0; j < insts.length(); j++) {
			    	 InstanceType insT = new InstanceType();
			    	 JSONObject curIns = insts.getJSONObject(j);
					 int insNum = curIns.getInt("number");
			    	 String sopUid = curIns.getString("uid");
			    	 // String sopClass = curIns.getString("sopClass"); // where to put it? - not in InstanceType, not conveyed anyhow...
			    	 insT.setDicomInstanceNumber(insNum);
				     insT.setDicomUid(sopUid);
				     
				     try {
				    	 insT.setImageUrn((String)dodURN.create(stdUid, serUid, sopUid).toString());
				     } catch(URNFormatException ufe) {
				    	 throw new MIXImagingStudyException("Error creating DOD imageURN: " + ufe.getMessage());
				     }
				    	 
				     instances.add(insT);
			     }
			     
			     // hook instances!
			     InstanceType[] seriesInstances = instances.toArray(new InstanceType[instances.size()]);
			     SeriesTypeComponentInstances instancesWrapper = new SeriesTypeComponentInstances();
			     instancesWrapper.setInstance(seriesInstances);
			     serT.setComponentInstances(instancesWrapper);

			     series.add(serT);
		     }
		     
		     // hook series!
		     SeriesType[] studySeries = series.toArray(new SeriesType[series.size()]);
		     StudyTypeComponentSeries instancesWrapper = new StudyTypeComponentSeries();
		     instancesWrapper.setSeries(studySeries);
		     st.setComponentSeries(instancesWrapper);
			 if(logger.isDebugEnabled()){
                 logger.debug("Converted IS procedure date to DICOM date: {}", st.getProcedureDate());}
		}
		catch (JSONException je) {
            logger.info("FHIR ImagingStudy response JSON data object error: {}", je.getMessage());
			return null;
		}
		// *** log if inconsistencies found!
		return st;
	}
	
	private static boolean isEmptyModality(String theModality, List<String> emptyModalityList) {
		boolean result=false;
		for(String emptyModality : emptyModalityList)
		{
			if(theModality.equals(emptyModality))
			{
				result=true;
				break;
			}
		}
		return result;
	}
}

