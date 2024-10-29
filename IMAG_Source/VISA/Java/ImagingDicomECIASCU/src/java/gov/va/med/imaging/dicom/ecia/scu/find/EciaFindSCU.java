package gov.va.med.imaging.dicom.ecia.scu.find;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import java.net.HttpURLConnection;
import java.net.URL;

import java.security.KeyStore;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.HashSet;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.OptionGroup;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import gov.va.med.logging.Logger;
import org.dcm4che2.data.BasicDicomObject;
import org.dcm4che2.data.DicomElement;
import org.dcm4che2.data.DicomObject;
import org.dcm4che2.data.Tag;
import org.dcm4che2.data.VR;
import org.dcm4che2.io.DicomInputStream;
import org.dcm4che2.tool.dcmqr.DcmQR;
import org.dcm4che2.tool.dcmqr.DcmQR.QueryRetrieveLevel;

import gov.va.med.imaging.dicom.ecia.scu.dto.ImageDTO;
import gov.va.med.imaging.dicom.ecia.scu.dto.SeriesDTO;
import gov.va.med.imaging.dicom.ecia.scu.dto.StudyDTO;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.dicom.ecia.scu.configuration.EciaDicomConfiguration;

/**
 * SCU implementation class for getting data from ECIA
 * 
 * @author Quoc Nguyen
 *
 */
public class EciaFindSCU {

	private EciaDicomConfiguration eciaConfig = null;
	private final static Logger LOGGER = Logger.getLogger(EciaFindSCU.class);

	private static final Object SYNC_OBJECT = new Object();
	private static SSLSocketFactory SSL_SOCKET_FACTORY = null;

	public EciaFindSCU (EciaDicomConfiguration eciaConfig) {
		this.eciaConfig = eciaConfig;
	}
		
	// See below for more info about fields to retrieve
	
	/**
	 * Implementation method to retrieve a list of Studies for a given patient ID.
	 * Because of the hierarchical nature of DICOM, need to perform multiple queries
	 * to get the needed data.
	 * 
	 * For performance improvement, query by patient ICN will get minimal data
	 * from the "STUDY" level only and by patient EDIPI will get all available 
	 * and appropriate data from all three levels. 
	 * 
	 * @param String 					given patient ID
	 * @param String 					date range
	 * @return List<StudyDTO>			result of retrieval
	 * @throws Exception				in case the implementation need to throw one
	 * 
	 */
	public List<StudyDTO> getStudyListByPatientId(String patientId, String dateRange) throws Exception {

        LOGGER.info("EciaFindSCU.getStudyListByPatientId() --> Getting study list for patient id [{}] and date range [{}]", patientId, dateRange);
		
		if(patientId == null || patientId.equals("")) {
			throw new IllegalArgumentException("EciaFindSCU.getStudyListByPatientId() --> Patient id is required and should not be empty.");
		}
		
		// By PatientID @ STUDY level (default to STUDY when not specifying)
		String [] studyQryNoDates = {"-q00100020=" + patientId, 
									 "-r0020000D", "-r00081030", "-r00144076", "-r00321060", "-r00081032", "-r00080020",
									 "-r00080030", "-r00080080", "-r00080050", "-r00100010", "-r00120030", "-r00120031", 
									 "-r00201208", "-r00201206", "-r00080061"};
 
		String [] studyQryDates  = {"-q00100020=" + patientId, "-q00080020=" + dateRange,
									"-r0020000D", "-r00081030", "-r00144076", "-r00321060", "-r00081032", "-r00080020",
									"-r00080030", "-r00080080", "-r00080050", "-r00100010", "-r00120030", "-r00120031", 
									"-r00201208", "-r00201206", "-r00080061"};


        LOGGER.debug("EciaFindSCU.getStudyListByPatientId() --> Query with server properties --> [{}]", this.eciaConfig);
		
		List<DicomObject> dicomStudyResults = doQuery(((dateRange == null) || (dateRange.equals(""))) ? (studyQryNoDates) : (studyQryDates));  // STUDY level
		
		// Nothing to transfer for the first query.  Should stop.
		if (dicomStudyResults == null || dicomStudyResults.isEmpty()) {
            LOGGER.debug("EciaFindSCU.getStudyListByPatientId() --> STUDY query level --> no study for patient EDIPI [{} and date range [{}]. Return null.", patientId, dateRange);
			return null;
		}
		
		List<StudyDTO> studyDTOs = transferStudyInstances(dicomStudyResults);

        LOGGER.debug("EciaFindSCU.getStudyListByPatientId() --> Got a study list (potentially huge = not included) for patient Id [{}] and date range [{}]", patientId, dateRange);
		
		return studyDTOs;		
	}
	
	/**
	 * Retrieves a list of Studies and their descendant series / images provided a study identifier and date range (optional)
	 * 
	 * @param String 			study UID to query for
	 * @param String			date range (can be null)
	 * @param MIXConfiguration 	used for report fetching
	 * @return List<StudyDTO>	results
	 * @throws Exception 		in the event of any errors
	 * 
	 */
	public List<StudyDTO> getStudyByStudyUID(String studyUID, String dateRange, MIXConfiguration mixConfiguration) throws Exception {

        LOGGER.info("EciaFindSCU.getStudyByStudyUID() --> Getting study for UID [{}] and date range [{}]", studyUID, dateRange);
		
		if ((studyUID == null) || (studyUID.length() == 0)) {
			throw new IllegalArgumentException("EciaFindSCU.getStudyByStudyUID() --> study UID is required and should not be empty.");
		}
		
		String [] studyQueryParameters = null;
		
		if ((dateRange == null) || (dateRange.length() == 0)) {
			// Define queries without a date range
			studyQueryParameters = new String [] {"-q0020000D=" + studyUID, "-r00081030", "-r00144076", "-r00321060", "-r00081032", "-r00080020", "-r00080030", "-r00080080", "-r00100010", "-r00120030", "-r00120031", "-r00201208", "-r00201206", "-r00080061", "-r00100020", "-r00080050"};
		} else {
			// Define queries with a date range
			studyQueryParameters = new String [] {"-q0020000D=" + studyUID, "-q00080020=" + dateRange, "-r00081030", "-r00144076", "-r00321060", "-r00081032", "-r00080020", "-r00080030", "-r00080080","-r00100010", "-r00120030", "-r00120031", "-r00201208", "-r00201206", "-r00080061", "-r00100020", "-r00080050"};
		}

        LOGGER.debug("EciaFindSCU.getStudyByStudyUID() --> studyQueryParameters {}", Arrays.toString(studyQueryParameters));
		List<DicomObject> dicomStudyResults = doQuery(studyQueryParameters);
		
		if (dicomStudyResults == null || dicomStudyResults.isEmpty()) {
            LOGGER.debug("EciaFindSCU.getStudyByStudyUID() --> No study for found for study UID [{}].  Return null.", studyUID);
			return null;
		}
		
		// Log if we got back additional studies and retrun null. Should throw an exception as this should be unique.
		if (dicomStudyResults.size() > 1) {
            LOGGER.debug("EciaFindSCU.getStudyByStudyUID() --> Query returned [{}] studies; expected only a single result. Return null.", dicomStudyResults.size());
			return null;
		}
		
		// Convert the DICOM study results into DTOs
		List<StudyDTO> studyDTOs = transferStudyInstances(dicomStudyResults);

		// Should only be one studyDTO.  No need for loop.
		updateStudyWithSeriesAndImages(studyDTOs.get(0));
		updateStudyReportContents(studyDTOs.get(0), mixConfiguration);

		// Return the results
		return studyDTOs;
	}
	
	/**
	 * Updates a Study to retrieve descendant series and images
	 * 
	 * @param StudyDTO		study DTO object to update
	 * @throws Exception 	in the event of any exceptions
	 * 
	 */
	private void updateStudyWithSeriesAndImages(StudyDTO studyDTO) throws Exception {

		String studyUID = studyDTO.getStudyInstanceUID();

        LOGGER.debug("EciaFindSCU.updateStudyWithSeriesAndImages() --> Updating study with uid [{}]", studyUID);
		
		// Define query parameters to query for the series and images 
		String [] seriesQueryParameters = new String [] {"-S", "-q0020000D=" + studyUID, "-r00120071", "-r0020000E", "-r00200011", "-r0008103E", "-r00080060", "-r00201209"};
		String [] imageQueryParameters = new String [] {"-I", "-q0020000D=" + studyUID, "-r00080018", "-r00200013", "-r0020000E", "-r00080016"};
			
		// Query for series and images
        LOGGER.debug("EciaFindSCU.updateStudyWithSeriesAndImages() --> seriesQueryParameters {}", Arrays.toString(seriesQueryParameters));
		List<DicomObject> dicomSeriesResults = doQuery(seriesQueryParameters);

        LOGGER.debug("EciaFindSCU.updateStudyWithSeriesAndImages() --> imageQueryParameters {}", Arrays.toString(imageQueryParameters));
		List<DicomObject> dicomImageResults = doQuery(imageQueryParameters);
	
		// Construct series from the image results
		List<SeriesDTO> seriesDTOs = transferImageInstances(dicomImageResults);

		// Merge the series and image results
		if (! (dicomSeriesResults.isEmpty())) {
			if (! ((seriesDTOs == null) || (seriesDTOs.isEmpty()))) {
				studyDTO.setSeriesDTOs(transferSeriesInstances(seriesDTOs, dicomSeriesResults));
			}
		}
	}
	
	/**
	 * Attempts to update a provided Study with its study report contents, if available
	 * 
	 * @param StudyDTO 				object to update
	 * @param MIXConfiguration 		object to get values for WADO connectivity
	 * @throws Exception 			in the event of any errors
	 * 
	 */
	private void updateStudyReportContents(StudyDTO studyDTO, MIXConfiguration mixConfiguration) throws Exception {

        LOGGER.debug("EciaFindSCU.updateStudyReportContents() --> Updating study with UID [{}]", studyDTO.getStudyInstanceUID());
		
		if (studyDTO.getStudyInstanceUID() == null || studyDTO.getModalitiesInStudy() == null) {
			LOGGER.debug("EciaFindSCU.updateStudyReportContents() --> provided StudyDTO has no UID or no modalities.  Return.");
			return;
		}

		if(!(Arrays.asList(studyDTO.getModalitiesInStudy()).contains("SR"))) {
			return;
		}
		
		LOGGER.debug("EciaFindSCU.updateStudyReportContents() --> provided StudyDTO has an [SR] modality");
		
		// Iterate over each series and image to potentially do a WADO call
		// Create a list of report text values to concatenate together in case multiple images have them
		List<String> reportTextList = new ArrayList<String>();
		if (studyDTO.getSeriesDTOs() != null) {
			for (SeriesDTO seriesDTO : studyDTO.getSeriesDTOs()) {
				// Skip if this series does not contain the SR modality or has no images
				if ((seriesDTO.getModality().contains("SR")) && (seriesDTO.getImageDTOs() != null)) {
					// Iterate over each image
					for (ImageDTO imageDTO : seriesDTO.getImageDTOs()) {
						// Execute a WADO call to get the report text, if available
						String reportText = getReportContent(mixConfiguration, studyDTO.getStudyInstanceUID(), seriesDTO.getSeriesInstanceUID(), imageDTO.getSopInstanceUID());
						
						// Set the results of the WADO call here, if anything was really returned
						if ((reportText != null) && (reportText.length() > 0)) {
							// Add to the list
							reportTextList.add(reportText);
						}
					}
				}
			}
		}

		// Set the report text value if we have any data
		String reportText = concatenateReportText(reportTextList);
		if (reportText != null) {
			studyDTO.setReportTextValue(reportText);
		}
	}

	/**
	 * Executes a WADO query given a MIX Configuration and a combination of UIDs for a study, series, and sop (object / image)
	 * 
	 * @param MIXConfiguration 		object to get values to build the WADO URL
	 * @param String				study instance UID
	 * @param String				series instance UID
	 * @param String				sop instance UID
	 * @return String				A single text value representing the report text, if available
	 * @throws Exception 			in the event of any errors
	 * 
	 */
	private String getReportContent(MIXConfiguration mixConfiguration, String studyInstanceUID, String seriesInstanceUID, String sopInstanceUID) throws Exception {
		
		LOGGER.info("EciaFindSCU.getReportContent() --> AFTER Getting report content....");
		
		// Get the site configuration	
		MIXSiteConfiguration mixSiteConfiguration = mixConfiguration.getSiteConfiguration("200W", "W");
		
		// Build out the URL
		StringBuilder url = new StringBuilder();
		
		url.append(mixSiteConfiguration.getProtocol());
		url.append("://");
		url.append(mixSiteConfiguration.getHost());
		url.append(":" + mixSiteConfiguration.getPort()); // string conversion, so just append
		url.append("/");
		url.append(mixSiteConfiguration.getMixApplication());
		url.append("/wadoget?requestType=WADO&contenttype=application/dicom");
		url.append("&studyUID=");
		url.append(studyInstanceUID);
		url.append("&seriesUID=");
		url.append(seriesInstanceUID);
		url.append("&objectUID=");
		url.append(sopInstanceUID);
		
        LOGGER.debug("EciaFindSCU.getReportContent() --> AFTER Built WADO URL: {}", url.toString());
		
		// Execute the actual query
		return queryForReportContent(url.toString(), mixConfiguration);
	}
	
	/**
	 * Combines a list of report text values into a single, separated value
	 *
	 * @param reportTextList list of report text values to combine
	 * @return combined, single value (or null)
	 */
	private String concatenateReportText(List<String> reportTextList) {
		
		LOGGER.info("EciaFindSCU.concatenateReportText() --> AFTER Getting one report text......");
		
		// Build the report text according to size
		if (reportTextList.size() == 0) {
			return null;
		} else if (reportTextList.size() == 1) {
			// Get the first report's text
			return reportTextList.get(0);
		} else {
			// Build a single report with separators and counts
			StringBuilder reportTextBuilder = new StringBuilder();
			int count = 1;
			for (String text : reportTextList) {
				if (count > 1) {
					reportTextBuilder.append("\r\n=========================\r\n");
				}

				reportTextBuilder.append("Report Text (");
				reportTextBuilder.append(count);
				reportTextBuilder.append(" of ");
				reportTextBuilder.append(reportTextList.size());
				reportTextBuilder.append("):\r\n=========================\r\n");
				reportTextBuilder.append(text);
				++count;
			}

			return reportTextBuilder.toString();
		}
	}
	
	/**
	 * Retrieves report text from a DICOM object located at the provided URL
	 * 
	 * @param String	 			WADO URL to request a DICOM object from
	 * @param MIXConfiguration		object to get values from
	 * @return String				report text contents, if available
	 * @throws Exception 			in the event of any exceptions while calling the WADO service
	 * 
	 */
	private String queryForReportContent(String url, MIXConfiguration mixConfiguration) throws Exception {

        LOGGER.info("EciaFindSCU.queryForReportContent() --> AFTER Getting report content using URL [{}]", url);
		
		String reportText = "";
		
		InputStream httpInputStream = null;
		DicomInputStream dicomInputStream = null;
		
		try {
			// Establish connection
			if (url.startsWith("https")) {
				HttpsURLConnection connection = (HttpsURLConnection) new URL(url).openConnection();
				connection.setHostnameVerifier(new HostnameVerifier() {
					public boolean verify(String hostname, SSLSession session) {
						return !Objects.isNull(hostname);
					}});
				connection.setRequestMethod("GET");
				connection.setDoInput(true);
				connection.setSSLSocketFactory(getSSLSocketFactory(mixConfiguration));
				connection.connect();
				httpInputStream = connection.getInputStream();
			} else {
				HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
				connection.setRequestMethod("GET");
				connection.setDoInput(true);
				httpInputStream = connection.getInputStream();
			}

			dicomInputStream = new DicomInputStream(httpInputStream);
			BasicDicomObject dicomObject = new BasicDicomObject();
			dicomInputStream.readDicomObject(dicomObject, -1);
            LOGGER.debug("EciaFindSCU.queryForReportContent() --> Got back DICOM image = {}", dicomObject.toString());

			// Get the content sequence elements, if there are any
			DicomElement contentSequenceElement = dicomObject.get(Tag.ContentSequence, VR.SQ);
			if (contentSequenceElement != null) {
				// Iterate over each element checking for text values
				for (int i = 0; i < contentSequenceElement.countItems(); ++i) {
					// Retrieve the object
					DicomObject elementObject = contentSequenceElement.getDicomObject(i);
					if (elementObject != null) {
						// Look for content sequence tags
						DicomObject contentSequence = elementObject.getNestedDicomObject(Tag.ContentSequence);
						if (contentSequence != null) {
							String textValue = contentSequence.getString(Tag.TextValue);
							// If we find a text value, set that and finish 
							if ((textValue != null) && (textValue.length() != 0)) {
								reportText = textValue;
								break;
							}
						}
						
						// If we haven't, go ahead and check the root element for a text value
						String textValue = elementObject.getString(Tag.TextValue);
						if ((textValue != null) && (textValue.length() != 0)) {
							reportText = textValue;
							break;
						}
					}
				}
			}
		} finally {
			try { if (httpInputStream != null) { httpInputStream.close(); } } catch(IOException ioe) {/* Ignore */}			
			try { if (dicomInputStream != null) { dicomInputStream.close(); } } catch(IOException ioe) {/* Ignore */}
		}
		
		return reportText;
	}

	/**
	 * Helper method to create the final result for end-user of this implementation class
	 * by transferring the result of the first query into a list object of desired format.
	 * 
	 * @param List<DicomObject>			result of the first query to transfer
	 * @return List<StudyDTO>			result of transferred data to return
	 * 
	 */
	private List<StudyDTO> transferStudyInstances(List<DicomObject> dicomStudyResults) {
		
		LOGGER.debug("EciaFindSCU.transferStudyInstances() --> Getting data into DTO to return..... ");
		
		List<StudyDTO> studyDTOs = new ArrayList<StudyDTO>();
		
		for(DicomObject dicomStudyResult : dicomStudyResults) {
			
			StudyDTO studyDTO = new StudyDTO();
			
			studyDTO.setStudyInstanceUID(dicomStudyResult.getString(Tag.StudyInstanceUID));
			studyDTO.setStudyDescription(dicomStudyResult.getString(Tag.StudyDescription));
			studyDTO.setProcedureCodeSeq(dicomStudyResult.getString(Tag.ProcedureCodeSequence));
						
			studyDTO.setModalitiesInStudy(dicomStudyResult.getStrings(Tag.ModalitiesInStudy));
			
			// Modalities in Study should always have value(s) = no check until we do :-)
			studyDTO.setRequestedProcedureDescription(Arrays.toString(dicomStudyResult.getStrings(Tag.ModalitiesInStudy)).replace("[", "").replace("]", ""));
			
			studyDTO.setPatientId(dicomStudyResult.getString(Tag.PatientID));
			studyDTO.setPatientName(dicomStudyResult.getString(Tag.PatientName));
			studyDTO.setClinicalTrialSiteId(dicomStudyResult.getString(Tag.ClinicalTrialSiteID));
			studyDTO.setClinicalTrialSiteName(dicomStudyResult.getString(Tag.ClinicalTrialSiteName));
			studyDTO.setImageCount(dicomStudyResult.getInt(Tag.NumberOfStudyRelatedInstances));
			studyDTO.setSeriesCount(dicomStudyResult.getInt(Tag.NumberOfStudyRelatedSeries));
			
			// The procedure date is usually null.  Shouldn't query for it but does it for good measure
			String procDate = dicomStudyResult.getString(Tag.ProcedureCreationDate);
			
			// Concatenate Strings of Study Date and Study Time to create a new String, e.g. "20190530082049",
			// which will be converted to Date object in the MixTranslatorV1.
			// Study Date always has a value = no check.  Study Time doesn't always have a value = need to check.
			// If null, default to midnight for now.  Don't know about how time zone is figured into this but it does in conversion.
			String dateTime = dicomStudyResult.getString(Tag.StudyDate) + (dicomStudyResult.getString(Tag.StudyTime) == null ? "0000" : dicomStudyResult.getString(Tag.StudyTime));
			
			studyDTO.setProcedureCreationDate(procDate == null ? dateTime : procDate);			
			
			studyDTO.setInstitutionName(dicomStudyResult.getString(Tag.InstitutionName));
			
			// report text is set in updateStudyReportContents() method below
			//studyDTO.setReportTextValue(dicomStudyResult.getString(Tag.TextValue));
			
			studyDTO.setAccessionNumber(dicomStudyResult.getString(Tag.AccessionNumber));
			
			// 'specialtyDescription' and 'reportContent' have no corresponding DICOM tags.
			// Series belong(s) to this Study are/is set in transferSeriesInstances() method.
			
			studyDTOs.add(studyDTO);
		}
		
		return studyDTOs;
	}
	

	/**
	 * Helper method to transfer series data into Series DTOs
	 * 
	 * @param List<SeriesDTO> 		series DTOs to transfer modality into
	 * @param List<DicomObject>		contains series data
	 * @return List<SeriesDTO>		result to return
	 * 
	 */
	private List<SeriesDTO> transferSeriesInstances(List<SeriesDTO> seriesDTOs, List<DicomObject> dicomSeriesResults) {
		
		LOGGER.debug("EciaFindSCU.transferSeriesInstances() --> Getting series data into DTO to return..... ");
		
		// Can't reduce looping here and elsewhere b/c DicomObject doesn't implement Java Comparable interface.
		
		for(SeriesDTO seriesDTO : seriesDTOs) {
			for(DicomObject dicomSeriesResult : dicomSeriesResults) {
				if(seriesDTO.getSeriesInstanceUID().equalsIgnoreCase(dicomSeriesResult.getString(Tag.SeriesInstanceUID))) {
					seriesDTO.setModality(dicomSeriesResult.getString(Tag.Modality));
					// QN: add series description here for VAI-678
                    LOGGER.debug("EciaFindSCU.transferSeriesInstances() --> seriesDescription = {}", dicomSeriesResult.getString(Tag.SeriesDescription));
					seriesDTO.setSeriesDescription(dicomSeriesResult.getString(Tag.SeriesDescription));
				}
			}
		}
		
		return seriesDTOs;
	}
	
	/**
	 * Helper method to transfer image data and Series Instance UID into Series DTOs
	 * 
	 * @param List<DicomObject>			result of the third query to transfer
	 * @return List<SeriesDTO>			result of transferred data including Image DTO(s) to return to end-users
	 * 
	 */
	private List<SeriesDTO> transferImageInstances (List<DicomObject> dicomImageResults) {
		
		LOGGER.debug("EciaFindSCU.transferImageInstances() --> Getting image(s) into DTO to return..... ");
		
		List<SeriesDTO> seriesDTOs = new ArrayList<SeriesDTO>();
		
		// Get unique objects based on seriesInstanceUID
		List<String> seriesInstanceUIDs = new ArrayList<String>();

		// Get a list of series UIDs only
		for(DicomObject dicomImageResult : dicomImageResults) {		
			seriesInstanceUIDs.add(dicomImageResult.getString(Tag.SeriesInstanceUID));
		}
		
		// Get unique series UIDs
		seriesInstanceUIDs = new ArrayList<String>(new HashSet<String>(seriesInstanceUIDs));
				
		// Transfer the series instance UID first
		for(String seriesInstanceUID : seriesInstanceUIDs) {		
			seriesDTOs.add(new SeriesDTO(seriesInstanceUID));
		}
		
		// Transfer the instance (image) last
		for(SeriesDTO seriesDTO : seriesDTOs) {
			List<ImageDTO> imageDTOs = new ArrayList<ImageDTO>();
			for(DicomObject dicomImageResult : dicomImageResults) {
				
				if(seriesDTO.getSeriesInstanceUID().equalsIgnoreCase(dicomImageResult.getString(Tag.SeriesInstanceUID))) {
					imageDTOs.add( 
							new ImageDTO( 
									// dObj.getString(Tag.URNCodeValue), 
									// Should be URNCodevalue but not supported for this version of DCM4CHE
									// and will be created while translating later
									dicomImageResult.getString(Tag.SOPInstanceUID),
									dicomImageResult.getInt(Tag.InstanceNumber),
									dicomImageResult.getString(Tag.SeriesInstanceUID),
									dicomImageResult.getString(Tag.SOPClassUID)
									));
				}
			}
			
			seriesDTO.setImageDTOs(imageDTOs);
		}

		return seriesDTOs;
	}

	/**
	 * Common query method.  Operates from a given array of Strings that contains
	 * what to query for and the desired fields to return
	 * 
	 * @param String []				parameters to base query on
	 * @return List<DicomObject>	standard return for DICOM query
	 * 
	 */
	private List<DicomObject> doQuery(String [] args) throws Exception {
		
		List<DicomObject> results = null;
		
		DcmQR dcmqr = new DcmQR("VA_ECIA");

		dcmqr.setRemoteHost(eciaConfig.getServerHost());
		dcmqr.setRemotePort(eciaConfig.getServerPort());

	    dcmqr.setCalling(eciaConfig.getCallingAE());		
		dcmqr.setCalledAET(eciaConfig.getCalledAE(), false);			
		
		dcmqr.getKeys();
		dcmqr.setCFind(true);
		dcmqr.setCGet(true);
		
		// Default to 60s
		final int connectTimeOut = eciaConfig.getConnectTimeOut() == 0 ? 60000 : eciaConfig.getConnectTimeOut();
		dcmqr.setConnectTimeout(connectTimeOut);
        LOGGER.debug("EciaFindSCU.doQuery() --> set connect timeout to [{} ms]", connectTimeOut);
		
		// Default to 5 mins
		final int cfindRspTimeOut = eciaConfig.getCfindRspTimeOut() == 0 ? 300000 : eciaConfig.getCfindRspTimeOut();
		dcmqr.setDimseRspTimeout(cfindRspTimeOut);
        LOGGER.debug("EciaFindSCU.doQuery() --> set Dimse (C-FIND) Rsp Timeout to [{} ms]", cfindRspTimeOut);

		LOGGER.debug("EciaFindSCU.doQuery() --> Building options....");
		
		CommandLine cl = buildOptions(args);
		
		// There's no getQueryLevel() method. Workaround for logging.
		String localQueryLevel = null;
		 
		if (cl.hasOption("P")) {
            dcmqr.setQueryLevel(QueryRetrieveLevel.PATIENT);
            localQueryLevel = "PATIENT";
		} else if (cl.hasOption("S")) {
            dcmqr.setQueryLevel(QueryRetrieveLevel.SERIES);
            localQueryLevel = "SERIES";
		} else if (cl.hasOption("I")) {
            dcmqr.setQueryLevel(QueryRetrieveLevel.IMAGE);
            localQueryLevel = "IMAGE";
		} else {
            dcmqr.setQueryLevel(QueryRetrieveLevel.STUDY);
            localQueryLevel = "STUDY";
		}
		
		if (cl.hasOption("q")) {
            String [] matchingKeys = cl.getOptionValues("q");
            for (int i = 1; i < matchingKeys.length; i++,i++) {
                dcmqr.addMatchingKey(Tag.toTagPath(matchingKeys[i - 1]), matchingKeys[i]);
            }
        }
 
        if (cl.hasOption("r")) {
            String[] returnKeys = cl.getOptionValues("r");
            for (int i = 0; i < returnKeys.length; i++) {
                dcmqr.addReturnKey(Tag.toTagPath(returnKeys[i]));
            }
        }
        
		dcmqr.configureTransferCapability(true);

        LOGGER.debug("EciaFindSCU.doQuery() --> Querying at [{}] level", localQueryLevel);
		
		try {
			dcmqr.open();
			results = dcmqr.query();
		} catch (Exception e) {
            LOGGER.error("EciaFindSCU.doQuery() --> Queried at [{}] level encountered an Exception --> {}", localQueryLevel, e);
			throw e;
		} finally {
			try {
				if(dcmqr != null) {
					dcmqr.close();					
				}
			} catch (InterruptedException ie) {
				LOGGER.error("EciaFindSCU.doQuery() --> closing encountered InterruptedException !!!", ie);
				throw new Exception(ie.getMessage(), ie);
			}
			
			dcmqr.stop();
		}

        LOGGER.debug("EciaFindSCU.doQuery() --> Queried at [{}] level successfully --> number of result(s) [{}]", localQueryLevel, results.size());
		
		return results;
	}
	
	/**
	 * Helper method to transfer/parse the given array of Strings to proper
	 * format to set up the query
	 * 
	 * @param String []		parameters to format 
	 * @return CommandLine	standard object that contains parameters that the query could use
	 * 
	 */
	private CommandLine buildOptions(String [] args)
	{
		Options opts = new Options();
		// set query level
		OptionGroup qrlevel = new OptionGroup();
		
		OptionBuilder.withDescription("perform patient level query, multiple "
                + "exclusive with -S and -I, perform study level query\n"
                + "                            by default.");
        OptionBuilder.withLongOpt("patient");
        opts.addOption(OptionBuilder.create("P"));
		OptionBuilder.withDescription("perform series level query, multiple "
                + "exclusive with -P and -I, perform study level query\n"
                + "                            by default.");
        OptionBuilder.withLongOpt("series");
        opts.addOption(OptionBuilder.create("S"));

        OptionBuilder.withDescription("perform instance level query, multiple "
                + "exclusive with -P and -S, perform study level query\n"
                + "                            by default.");
        OptionBuilder.withLongOpt("image");
        opts.addOption(OptionBuilder.create("I"));

        opts.addOptionGroup(qrlevel);
        
        // set query params (patient id in this case)
        OptionBuilder.withArgName("[seq/]attr=value");
        OptionBuilder.hasArgs();
        OptionBuilder.withValueSeparator('=');
        opts.addOption(OptionBuilder.create("q"));

        // set return params
        OptionBuilder.withArgName("attr");
        OptionBuilder.hasArgs();
        opts.addOption(OptionBuilder.create("r"));
        
        
        //**************** new
        OptionBuilder.withArgName("aet");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "retrieve instances of matching entities by C-MOVE to specified destination.");
        opts.addOption(OptionBuilder.create("cmove"));

        opts.addOption("nocfind", false,
                "retrieve instances without previous query - unique keys must be specified by -q options");

        opts.addOption("cget", false, "retrieve instances of matching entities by C-GET.");

        OptionBuilder.withArgName("cuid[:ts]");
        OptionBuilder.hasArgs();
        OptionBuilder.withDescription(
                "negotiate support of specified Storage SOP Class and Transfer "
                + "Syntaxes. The Storage SOP Class may be specified by its UID "
                + "or by one of following key words:\n"
                + "CR  - Computed Radiography Image Storage\n"
                + "CT  - CT Image Storage\n"
                + "MR  - MRImageStorage\n"
                + "US  - Ultrasound Image Storage\n"
                + "NM  - Nuclear Medicine Image Storage\n"
                + "PET - PET Image Storage\n"
                + "SC  - Secondary Capture Image Storage\n"
                + "XA  - XRay Angiographic Image Storage\n"
                + "XRF - XRay Radiofluoroscopic Image Storage\n"
                + "DX  - Digital X-Ray Image Storage for Presentation\n"
                + "MG  - Digital Mammography X-Ray Image Storage for Presentation\n"
                + "PR  - Grayscale Softcopy Presentation State Storage\n"
                + "KO  - Key Object Selection Document Storage\n"
                + "SR  - Basic Text Structured Report Document Storage\n"
                + "The Transfer Syntaxes may be specified by a comma "
                + "separated list of UIDs or by one of following key "
                + "words:\n"
                + "IVRLE - offer only Implicit VR Little Endian "
                + "Transfer Syntax\n"
                + "LE - offer Explicit and Implicit VR Little Endian "
                + "Transfer Syntax\n"
                + "BE - offer Explicit VR Big Endian Transfer Syntax\n"
                + "DEFL - offer Deflated Explicit VR Little "
                + "Endian Transfer Syntax\n"
                + "JPLL - offer JEPG Loss Less Transfer Syntaxes\n"
                + "JPLY - offer JEPG Lossy Transfer Syntaxes\n"
                + "MPEG2 - offer MPEG2 Transfer Syntax\n"
                + "NOPX - offer No Pixel Data Transfer Syntax\n"
                + "NOPXD - offer No Pixel Data Deflate Transfer Syntax\n"
                + "If only the Storage SOP Class is specified, all "
                + "Transfer Syntaxes listed above except No Pixel Data "
                + "and No Pixel Data Delflate Transfer Syntax are "
                + "offered.");
        opts.addOption(OptionBuilder.create("cstore"));

        OptionBuilder.withArgName("dir");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "store received objects into files in specified directory <dir>."
                        + " Do not store received objects by default.");
        opts.addOption(OptionBuilder.create("cstoredest"));

        opts.addOption("ivrle", false, "offer only Implicit VR Little Endian Transfer Syntax.");

        CommandLine cl = null;
        
        // parse options into proper format
        try {
            cl = new GnuParser().parse(opts, args);
        } catch (ParseException e) {
        	// log here
        	System.exit(1);
            e.printStackTrace();
        }
        
		return cl;
	}
		
	private static SSLSocketFactory getSSLSocketFactory(MIXConfiguration configuration) throws Exception {
		synchronized (SYNC_OBJECT) {
			if (SSL_SOCKET_FACTORY == null) {
				// Get a SSLSocketFactory for re-use
				SSL_SOCKET_FACTORY = getSSLSocketFactory(configuration.getKeystoreUrl(), configuration.getKeystorePassword(), configuration.getTruststoreUrl(), configuration.getTruststorePassword());
			}
		}

		return SSL_SOCKET_FACTORY;
	}

	// This is copied from ImagingCommon to prevent a dependency issue
	public static SSLSocketFactory getSSLSocketFactory(String keyStoreFilePath, String keyStorePassword, String trustStoreFilePath, String trustStorePassword) throws Exception {
		// File paths aren't guaranteed to be URL-formatted, so this should normalize those
		keyStoreFilePath = (keyStoreFilePath == null) ? (null) : (keyStoreFilePath.replace("file:///", ""));
		trustStoreFilePath = (trustStoreFilePath == null) ? (null) : (trustStoreFilePath.replace("file:///", ""));
		
		// Initialize a key manager
		KeyManagerFactory keyManagerFactory = null;
		if (keyStoreFilePath != null) {
			InputStream keyStoreInputStream = null;
			try {
				// Initialize the factory using the default algorithm
				keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());

				// Load the store
				KeyStore keyStore = KeyStore.getInstance("JKS");
				keyStoreInputStream = new FileInputStream(new File(keyStoreFilePath));
				keyStore.load(keyStoreInputStream, keyStorePassword.toCharArray());

				// Initialize the factory
				keyManagerFactory.init(keyStore, keyStorePassword.toCharArray());
			} catch (Exception e) {
				throw new Exception("Unable to load key store file [" + keyStoreFilePath + "]", e);
			} finally {
				if (keyStoreInputStream != null) {
					keyStoreInputStream.close();
				}
			}
		}

		// Initialize a trust manager
		TrustManagerFactory trustManagerFactory = null;
		if (trustStoreFilePath != null) {
			InputStream trustStoreInputStream = null;
			try {
				// Initialize the factory using the default algorithm
				trustManagerFactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());

				// Load the store
				KeyStore trustStore = KeyStore.getInstance("JKS");
				trustStoreInputStream = new FileInputStream(new File(trustStoreFilePath));
				trustStore.load(trustStoreInputStream, trustStorePassword.toCharArray());

				// Initialize the factory
				trustManagerFactory.init(trustStore);
			} catch (Exception e) {
				throw new Exception("Unable to load trust store file [" + trustStoreFilePath + "]", e);
			} finally {
				if (trustStoreInputStream != null) {
					trustStoreInputStream.close();
				}
			}
		}

		// Initialize the SSL context with the provided key and trust managers
		SSLContext context = SSLContext.getInstance("TLSv1.2");
		context.init((keyManagerFactory == null) ? (null) : (keyManagerFactory.getKeyManagers()), (trustManagerFactory == null) ? (null) : (trustManagerFactory.getTrustManagers()), null);
		return context.getSocketFactory();
	}
	
	
	//+++++++++++++++++++++++ Saved codes and info ++++++++++++++++++++++++++++++++++++++++++++++++++++++

		/**
		 * lambda expressions are not supported in -source 1.7
		 
		 Work-around if queried by date range at STUDY level doesn't work
		 * 
		 * @param List<ImageMetadataDTO>	list to filter out empty series
		 * @return List<ImageMetadataDTO>	filtered list
		 * 

		private List<ImageMetadataDTO> removeEmptySeries(List<ImageMetadataDTO> inDTOs) {
			
			List<ImageMetadataDTO> result = inDTOs.stream()              // convert list to stream
	                .filter(inDTO -> !inDTO.getSeries().isEmpty())     	// filter out empty series
	                .collect(Collectors.toList());              		// collect the output and convert streams to a List		

			//result.forEach(System.out::println);
			
			return result;
		}
		 */
		
		/*
		 * 		
		 * // By PatientID @ STUDY level (default to STUDY when not specifying)
		 * String [] argsPatient1 = {"-q00100020=" + patientId, "-r00200010", "-r0020000D", "-r00081030", "-r00081032", 
		 * "-r00144076", "-r00321060",
		 * "-r00100010", "-r00120030", "-r00120031",
		 * "-r00201208", "-r00201206", "-r00080061"};
		 *
		 * Timezone Offset From UTC		0008,0201	
		 * Study Date					0008,0020
		 * 
		 * Study Time					0008,0030
		 * Institution Name				0008,0080
		 * Text Value					0040,A160
		 * 
		 * Procedure Creation Date		0014,4076
		 * 
		 * These are the fields that we are asking for:
		 * 
		 * STUDY query level
		 * 
		 * Name							Tag			Comment
		 * 
		 * Study ID						0020,0010
		 * Study Instance UID			0020,000D
		 * Study Description			0008,1030
		 * Procedure Code Sequence		0008,1032	one value for an array?  There're more codes. Need to pick them?
		 * Procedure Creation Date		0014,4076	there's also a Procedure Last Modified Date, pick Creation Date for now
		 * Requested Procedure Descr.	0032,1060	closes match????
		 * Patient ID					0010,0020
		 * Patient's name				0010,0010
		 * Clinical Trial Site ID		0012,0030	is it the right one?
		 * Clinical Trial Site name		0012,0031	is it the right one?
		 * Image Count					0020,1208	can't get it = tally image instances in Series
		 * Series Count					0020,1206	can't get it = tally Series instances in Study
		 * Modalities In Study			0008,0061	example "PT\CT"
		 * SpecialtyDescription 		?????????	have no corresponding DICOM tags 
		 * ReportContent 				?????????	have no corresponding DICOM tags.
		 * 
		 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		 * 
		 * 	// By PatientID @ SERIES level
		 * 	String [] argsPatient2 = {"-S", "-q00100020=" + patientId, "-r00120071", "-r0020000E", "-r00200011", "-r0008103E", "-r0008,0060", "-r00201209","-r0020000D"};
		 * 
		 * SERIES query level
		 * 
		 * Name							Tag			Comment
		 * 
		 * Clinical Trial Series ID		0012,0071	no equivalence of seriesId to studyId.  Good???
		 * Series Instance UID			0020,000E
		 * Series Number				0020,0011
		 * Series Description			0008,103E
		 * Modality for Series			0008,0060
		 * Image Count					0020,1209 
		 * 
		 * (Need to request Study Instance UID (0020,000D) at this level to correctly transfer Series to Study)
		 * 
		 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		 *
		 *	// By PatientID @ IMAGE level
		 *	With URNCodeValue
		 *	String [] argsPatient3 = {"-I", "-q00100020=" + patientId, "-r00080120", "-r00080018", "-r00200013", "-r0020000E"};
		 *  
		 *  With CodeValue 
		 *  String [] argsPatient3 = {"-I", "-q00100020=" + patientId, "-r00080100", "-r00080018", "-r00200013", "-r0020000E"};
		 *  
		 * IMAGE query level
		 * 
		 * Name							Tag			Comment
		 * 
		 * URN Code Value				0008,0120	representation: URL. Is it the right one to pick?
		 * SOP Instance UID				0008,0018
		 * Instance Number				0020,0013
		 * 
		 * * Need to request Series Instance UID (0020,000E) at this level to correctly transfer Image(s) to Series
		 * * (0054,0400)	SH	Image ID
		 * 
		 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
		 * 
		 * Not requested but needed to retrieve image(s) later as needed
		 * SOP Instance UID				00080018
	     *
		 * 
		 */
		
		// Initially, Try to return the empty, expected object for testing

		/*
		
		// Remove these when connect to ECIA
		//import gov.va.med.imaging.exceptions.URNFormatException;
		//import gov.va.med.GlobalArtifactIdentifier;
		//import gov.va.med.GlobalArtifactIdentifierImpl;
		//import gov.va.med.imaging.exchange.business.Study;
		//import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
		//import java.util.TreeSet;
		//import java.util.SortedSet;
		 * 
		 * 	// Some values to create a GlobalArtifactIdentifierImpl object with
		String homeCommId = "2.16.840.1.113883.3.42.10012.100001.206";  // From WellKnownOID class. Value for HAIMS doc.
		String repositoryUniqueId = "200";  // DoD
		String documentUniqueId = "2.2.2.documentUniqueId"; // <-- should be StudyURN? StudyUID?

	 
		logger.info("Returning a made-up StudySetResult object while not connecting to ECIA yet.........");
		
		GlobalArtifactIdentifier glbId = null;
		
		try {
				glbId = GlobalArtifactIdentifierImpl.createFromGlobalArtifactIdentifiers(homeCommId, repositoryUniqueId, documentUniqueId, null);
		} catch (URNFormatException urnEx) {
			urnEx.printStackTrace();
		}
		
		SortedSet<Study> studies = new TreeSet<Study>();
		studies.add(Study.create(glbId, StudyLoadLevel.FULL, StudyDeletedImageState.includesDeletedImages));
		
		return StudySetResult.createFullResult(studies);
		}
		
		
		
	/**
	 * UNUSED code: Helper method to transfer Series data and modality from the result of the second query
	 * to Study DTO
	 * 
	 * @param List<StudyDTO>			contains Study data from the first query
	 * @param List<DicomObject>			result(s) of the second query to transfer
	 * @return List<StudyDTO>			Study DTO including Series to return to end-users
	 * 
	 	
	private List<StudyDTO> transferSeriesInstances (List<StudyDTO> studyDTOs, List<SeriesDTO> seriesDTOs, List<DicomObject> dicomSeriesResults) {
        
        if(studyDTOs.size() == 1) {  // one Study so all Series belong to this Study
        	studyDTOs.get(0).setSeriesDTOs(transferModality(seriesDTOs, dicomSeriesResults));
        } else {     // multiple Series so separate Series per Study (Can't seem to reuse transferModality())
               for(StudyDTO studyDTO : studyDTOs) {
                     List<SeriesDTO> localSeriesDTOs = new ArrayList<SeriesDTO>();
                     for(SeriesDTO seriesDTO : seriesDTOs) {
                            for(DicomObject dicomSeriesResult : dicomSeriesResults) {
                                  if(seriesDTO.getSeriesInstanceUID().equalsIgnoreCase(dicomSeriesResult.getString(Tag.SeriesInstanceUID)) &&
                                		  studyDTO.getStudyInstanceUID().equalsIgnoreCase(dicomSeriesResult.getString(Tag.StudyInstanceUID))) {
                                	  
                  						seriesDTO.setClinicalTrialSeriesId(dicomSeriesResult.getString(Tag.ClinicalTrialSeriesID));
                  						//seriesDTO.setSeriesInstanceUID(dicomSeriesResult.getString(Tag.SeriesInstanceUID));  //already exists here
                  						seriesDTO.setSeriesNumber(dicomSeriesResult.getInt(Tag.SeriesNumber));
                  						seriesDTO.setSeriesDescription(dicomSeriesResult.getString(Tag.SeriesDescription));
                  						seriesDTO.setModality(dicomSeriesResult.getString(Tag.Modality));
                  						seriesDTO.setImageCount(dicomSeriesResult.getInt(Tag.NumberOfSeriesRelatedInstances));

                                        localSeriesDTOs.add(seriesDTO);
                                        
                                        break;
                                        
                                   } // got a study/series match, transfer data from series result list to the current series DTO
                            } // go through series result list to find the matches
                     } // for each series                    
                     studyDTO.setSeriesDTOs(localSeriesDTOs);
               } // for each study
        }
        
        return studyDTOs;
 }

		*/
	
}
