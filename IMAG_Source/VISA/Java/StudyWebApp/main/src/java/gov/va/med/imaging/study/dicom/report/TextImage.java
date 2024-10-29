package gov.va.med.imaging.study.dicom.report;

import com.lbs.DCS.*;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.study.dicom.vista.PatientInfo;
import gov.va.med.imaging.study.dicom.vista.LocalVistaDataSource;
import gov.va.med.imaging.study.rest.types.StudyFilterResultType;
import gov.va.med.imaging.utils.FileUtilities;
import gov.va.med.logging.Logger;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;


public class TextImage
{
	private static final long serialVersionUID = 1L;
	private final static Logger logger = Logger.getLogger(gov.va.med.imaging.study.dicom.report.TextImage.class);

	private BufferedImage createImageWithText(String text){
		String[] lines = text.split("\n");

		BufferedImage bufferedImage = new BufferedImage(900, 25*lines.length, BufferedImage.TYPE_BYTE_GRAY);
		Graphics2D g = bufferedImage.createGraphics();
		Font font = new Font("TimesNewRoman", Font.BOLD, 18);
		g.setFont(font);
		g.setBackground(Color.BLACK);
		g.clearRect(0, 0, bufferedImage.getWidth(), bufferedImage.getHeight());
		g.setColor(Color.WHITE);
		g.drawImage(bufferedImage, 0, 0, null);

		int i=0;
		for(String l : lines) {
			i++;
			g.drawString(l, 10, g.getFontMetrics().getAscent()*i);
		}
		g.dispose();

		return bufferedImage;
	}

	public BufferedImage createReportArtifact(String filename, String text, String pname, String pid, String pssn,
											  Date dt, String dob, String mod, String studyUrn, String studyUid, String accessionNumber,
											  String seriesUid, String studyDesc, boolean buildSc, String transactionId){
		BufferedImage bi = null;
		mod = mod.replace("RAD","").replace("CON","");
		String localPatName = pname.replaceAll(",","^").replaceAll("\\s+", "^");
		try {
			File pdir = FileUtilities.getFile(filename).getParentFile();
			if (pdir != null && !pdir.exists()) {
				if (!pdir.mkdirs())
                    logger.error("createImage cannot make dirs: {}", pdir.getAbsolutePath());
			}

			if (buildSc) {
				bi = createImageWithText(text);
				convertScDicom(bi, filename + ".dcm", pid, dt, mod, studyUrn, studyUid, accessionNumber,
						seriesUid, studyDesc, localPatName, transactionId);
			} else {
				convertSRDicom(text, filename + ".dcm", localPatName, pid, dt, dob, studyUrn, studyUid,
						accessionNumber, seriesUid, studyDesc, transactionId);
			}
		} catch (Exception e) {
            logger.error("createImage exception: {}", e.getMessage());
		}

		return bi;
	}

	private void convertScDicom(BufferedImage bimg, String dcmfile, String pid, Date dt, String mod,
								String studyUrn, String studyUid, String accessionNumber, String seriesUid,
								String studyDesc, String pname, String transactionId)
			throws ImagingDicomException {
		String output_ts_uid = UID.TRANSFERLITTLEENDIANEXPLICIT;
		if(logger.isDebugEnabled())
            logger.debug("convertImage: saving image to dcm file {} for {}", dcmfile, pid);

		String studyId = parseStudyId(studyUrn);
		PatientInfo patientInfo = LocalVistaDataSource.getPatientInfo(pid, transactionId, StudyFilterResultType.all);
		//parsePatientInfo(patssn,text,pid, dob, pname);

		DicomFileOutput dfo = null;

		try{
			// jpg/png image way
			dfo = new DicomFileOutput( dcmfile,output_ts_uid,true, true );
			DicomDataSet ds = JAIUtil.bufferedImageToDataSet(bimg);
			setCommonDds(dt, ds, studyUid, seriesUid, studyId, patientInfo, pid, accessionNumber, studyDesc, pname);

			ds.insert( DCM.E_IMAGE_TYPE, "ORIGINAL\\SECONDARY" );						// 0008,0008
			ds.insert( DCM.E_SOPCLASS_UID, UID.SOPCLASSSECONDARYCAPTURE );				// 0008,0016
			ds.insert( DCM.E_MODALITY, mod );						// 0008,0060
			ds.insert( DCM.E_PRESENTATION_INTENT_TYPE, "SR");		// 0008,0068
			ds.insert( DCM.E_STATION_NAME, "Vista");				// 0008,1010
			ds.insert( DCM.E_ACCESSION_NUMBER, (accessionNumber==null) ? "123456" : accessionNumber);       // 0008,0050
			ds.insert ( DCM.E_DEVICE_SERIAL_NUMBER, "" );			// 0018,1000
			ds.insert ( DCM.E_DATE_OF_SECONDARY_CAPTURE, (new SimpleDateFormat("yyyyMMdd").format(dt)) );	// 0018,1012
			ds.insert ( DCM.E_TIME_OF_SECONDARY_CAPTURE, (new SimpleDateFormat("HHmmss").format(dt)) );		// 0018,1014
			ds.insert( DCM.E_PATIENT_ORIENTATION, "");				// 0020,0020
			ds.insert( DCM.E_PLANAR_CONFIGURATION, 0);				// 0028,0006
			ds.insert( DCM.E_REQUESTING_PHYSICIAN, "CPACS^DOD^OR");		// 0032,1032

			FileUtilities.getFile(dcmfile).getParentFile().mkdirs();

			dfo.writeDataSet( ds );
		} catch (Exception e) {
            logger.error("Error creating report file: {}", e.getMessage());
		}
		finally
		{
			try
			{
				if( dfo != null)
					dfo.close();
			}
			catch( Exception e )
			{
                logger.error("Error closing DicomFileOutput in finally: {}", e.getMessage());
			}
		}
	}

	private void convertSRDicom(String text, String dcmfile, String pname, String pid, Date dt,
								String dob, String studyUrn, String studyUid, String accessionNumber,
								String seriesUid, String studyDesc, String transactionId)
			throws ImagingDicomException {  // Using LaurelBridge DCF 3.3.40c library
		String output_ts_uid = UID.TRANSFERLITTLEENDIANEXPLICIT;

		if(logger.isDebugEnabled())
            logger.debug("convertImage: saving SR to dcm file {} for {}", dcmfile, pid);
		// patient sex
		String stid = parseStudyId(studyUrn);
		PatientInfo patientInfo = LocalVistaDataSource.getPatientInfo(pid, transactionId, StudyFilterResultType.all);
		//parsePatientInfo(patssn, text, pid, dob, pname);

		DicomFileOutput dfo = null;

		try {
			// Dicom SR way
			DicomDataSet ds = new DicomDataSet();
			DicomDataSet header_ds = null;
			setCommonDds(dt, ds, studyUid, seriesUid, stid, patientInfo, pid, accessionNumber, studyDesc, pname);

			ds.insert( DCM.E_SOPCLASS_UID, "1.2.840.10008.5.1.4.1.1.88.11" );	// Basic Text SR IOD
			ds.insert( DCM.E_MODALITY, "SR" );						// 0008,0060
			ds.insert (DCM.E_READING_PHYSICIANS_NAME, "");			// 0008,1060
			ds.insert( new AttributeTag("0008,1110"), "");
			ds.insert( DCM.E_ACCESSION_NUMBER, (accessionNumber==null) ? "123456" : accessionNumber);   // 0008,0050

			ds.insert( new AttributeTag("0028,0008"), 1);			// 0028,0008

			ds.insert( new AttributeTag("0032,000A"), "COMPLETED");
			ds.insert( new AttributeTag("0032,1060"), "REPORT");
			ds.insert( new AttributeTag("0033,0020"), "SCP SR Creation");
			ds.insert( new AttributeTag("0040,A040"), "CONTAINER");

			DicomDataSet ds1 = new DicomDataSet();
			ds1.insert( new AttributeTag("0008,0100"), "11528-7");
			ds1.insert( new AttributeTag("0008,0102"), "LN");
			ds1.insert( new AttributeTag("0008,0104"), "Radiology Report");
			DicomSQElement sqElem = new DicomSQElement(new AttributeTag("0040,A043"), ds1);
			ds.insert( sqElem );

			ds.insert( new AttributeTag("0040,A050"), "SEPARATE");

			ds1 = new DicomDataSet();
			ds1.insert( new AttributeTag("0040,A027"), "VISTA");
			ds1.insert( new AttributeTag("0040,A030"), "19000101");
			ds1.insert( new AttributeTag("0040,A075"), "VISTA^VIX");
			ds1.insert( new AttributeTag("0040,A088"), "");
			ds1.insert( new AttributeTag("0040,A121"), "");
			ds1.insert( new AttributeTag("0040,A122"), "");
			sqElem = new DicomSQElement(new AttributeTag("0040,A073"), ds1);
			ds.insert( sqElem );

			ds1 = new DicomDataSet();
			ds1.insert( new AttributeTag("0008,0050"), "");
			ds1.insert( new AttributeTag("0008,1110"), "");
			ds1.insert( new AttributeTag("0020,000D"), studyUid);
			ds1.insert( new AttributeTag("0032,1060"), "REPORT");
			ds1.insert( new AttributeTag("0032,1064"), "");
			ds1.insert( new AttributeTag("0040,1001"), "");
			ds1.insert( new AttributeTag("0040,2016"), "");
			ds1.insert( new AttributeTag("0040,2017"), "");
			sqElem = new DicomSQElement(new AttributeTag("0040,A370"), ds1);
			ds.insert( sqElem );


			ds.insert( new AttributeTag("0040,A372"), "");
			ds.insert( new AttributeTag("0040,A375"), "");
			ds.insert( new AttributeTag("0040,A491"), "COMPLETE");
			ds.insert( new AttributeTag("0040,A493"), "VERIFIED");
			ds.insert( new AttributeTag("0040,A504"), "");

			DicomDataSet[] setsa730 = new DicomDataSet[5];

			setsa730[0] = new DicomDataSet();
			setsa730[0].insert( new AttributeTag("0040,A010"), "HAS CONCEPT MOD");
			setsa730[0].insert( new AttributeTag("0040,A040"), "CODE");
			DicomDataSet[] ds00 = new DicomDataSet[1];
			ds00[0] = new DicomDataSet();
			ds00[0].insert( new AttributeTag("0008,0100"), "121049");
			ds00[0].insert( new AttributeTag("0008,0102"), "DCM");
			ds00[0].insert( new AttributeTag("0008,0104"), "Language of Contents Items and Descendants");
			DicomSQElement sqElem00 = new DicomSQElement(new AttributeTag("0040,A043"), ds00);
			setsa730[0].insert( sqElem00 );
			setsa730[0].insert( new AttributeTag("0040,A050"), "");

			DicomDataSet[] ds01 = new DicomDataSet[1];
			ds01[0] = new DicomDataSet();
			ds01[0].insert( new AttributeTag("0008,0100"), "end");
			ds01[0].insert( new AttributeTag("0008,0102"), "ISO639_2");
			ds01[0].insert( new AttributeTag("0008,0104"), "English");
			DicomSQElement sqElem01 = new DicomSQElement(new AttributeTag("0040,A168"), ds01);
			setsa730[0].insert( sqElem01 );
			setsa730[0].insert( new AttributeTag("0040,A730"), "");
			setsa730[0].insert( new AttributeTag("0040,DB73"), "");

			setsa730[1] = new DicomDataSet();
			setsa730[1].insert( new AttributeTag("0040,A010"), "HAS OBS CONTEXT");
			setsa730[1].insert( new AttributeTag("0040,A040"), "PNAME");
			DicomDataSet[] ds10 = new DicomDataSet[1];
			ds10[0] = new DicomDataSet();
			ds10[0].insert( new AttributeTag("0008,0100"), "121008");
			ds10[0].insert( new AttributeTag("0008,0102"), "DCM");
			ds10[0].insert( new AttributeTag("0008,0104"), "Person Observer Name");
			DicomSQElement sqElem10 = new DicomSQElement(new AttributeTag("0040,A043"), ds10);
			setsa730[1].insert( sqElem10 );
			setsa730[1].insert( new AttributeTag("0040,A050"), "");
			setsa730[1].insert( new AttributeTag("0040,A123"), "SEE REPORT");
			setsa730[1].insert( new AttributeTag("0040,A730"), "");
			setsa730[1].insert( new AttributeTag("0040,DB73"), "");

			setsa730[2] = new DicomDataSet();
			setsa730[2].insert( new AttributeTag("0040,A010"), "HAS OBS CONTEXT");
			setsa730[2].insert( new AttributeTag("0040,A040"), "UIDREF");
			DicomDataSet[] ds20 = new DicomDataSet[1];
			ds20[0] = new DicomDataSet();
			ds20[0].insert( new AttributeTag("0008,0100"), "121008");
			ds20[0].insert( new AttributeTag("0008,0102"), "DCM");
			ds20[0].insert( new AttributeTag("0008,0104"), "Procedure Study Instance UID");
			DicomSQElement sqElem20 = new DicomSQElement(new AttributeTag("0040,A043"), ds20);
			setsa730[2].insert( sqElem20 );
			setsa730[2].insert( new AttributeTag("0040,A050"), "");
			setsa730[2].insert( new AttributeTag("0040,A124"), studyUid);
			setsa730[2].insert( new AttributeTag("0040,A730"), "");
			setsa730[2].insert( new AttributeTag("0040,DB73"), "");

			setsa730[3] = new DicomDataSet();
			setsa730[3].insert( new AttributeTag("0040,A010"), "HAS OBS CONTEXT");
			setsa730[3].insert( new AttributeTag("0040,A040"), "PNAME");
			DicomDataSet[] ds30 = new DicomDataSet[1];
			ds30[0] = new DicomDataSet();
			ds30[0].insert( new AttributeTag("0008,0100"), "121009");
			ds30[0].insert( new AttributeTag("0008,0102"), "DCM");
			ds30[0].insert( new AttributeTag("0008,0104"), "Subject Name");
			DicomSQElement sqElem30 = new DicomSQElement(new AttributeTag("0040,A043"), ds30);
			setsa730[3].insert( sqElem30 );
			setsa730[3].insert( new AttributeTag("0040,A050"), "");
			setsa730[3].insert( new AttributeTag("0040,A123"), pname);
			setsa730[3].insert( new AttributeTag("0040,A730"), "");
			setsa730[3].insert( new AttributeTag("0040,DB73"), "");

			setsa730[4] = new DicomDataSet();
			setsa730[4].insert( new AttributeTag("0040,A010"), "CONTAINS");
			setsa730[4].insert( new AttributeTag("0040,A040"), "CONTAINER");
			DicomDataSet[] ds40 = new DicomDataSet[1];
			ds40[0] = new DicomDataSet();
			ds40[0].insert( new AttributeTag("0008,0100"), "121070");
			ds40[0].insert( new AttributeTag("0008,0102"), "DCM");
			ds40[0].insert( new AttributeTag("0008,0104"), "Findings");
			DicomSQElement sqElem40 = new DicomSQElement(new AttributeTag("0040,A043"), ds40);
			setsa730[4].insert( sqElem40 );
			setsa730[4].insert( new AttributeTag("0040,A050"), "SEPARATE");
			DicomDataSet[] ds41 = new DicomDataSet[1];
			ds41[0] = new DicomDataSet();
			ds41[0].insert( new AttributeTag("0040,A010"), "CONTAINS");
			ds41[0].insert( new AttributeTag("0040,A040"), "TEXT");
			DicomDataSet[] ds410 = new DicomDataSet[1];
			ds410[0] = new DicomDataSet();
			ds410[0].insert( new AttributeTag("0008,0100"), "121071");
			ds410[0].insert( new AttributeTag("0008,0102"), "DCM");
			ds410[0].insert( new AttributeTag("0008,0104"), "Finding");
			DicomSQElement sqElem410 = new DicomSQElement(new AttributeTag("0040,A043"), ds410);
			ds41[0].insert( sqElem410 );
			ds41[0].insert( new AttributeTag("0040,A050"), "");
			//ds41[0].insert( new AttributeTag("0008,0104"), "English");
			ds41[0].insert( new AttributeTag("0040,A160"), text);
			ds41[0].insert( new AttributeTag("0040,A730"), "");
			ds41[0].insert( new AttributeTag("0040,DB73"), "");
			DicomSQElement sqElem41 = new DicomSQElement(new AttributeTag("0040,A730"), ds41);
			setsa730[4].insert( sqElem41 );
			setsa730[4].insert( new AttributeTag("0040,DB73"), "");

			sqElem = new DicomSQElement(new AttributeTag("0040,A730"), setsa730);
			ds.insert( sqElem );

			if ( header_ds != null )
			{
                logger.info("adding elements from header data set:{}{}", System.getProperty("line.separator"), header_ds);
				ds.insert( header_ds );
			}

			dfo = new DicomFileOutput( dcmfile,	output_ts_uid, true, true );

			dfo.writeDataSet( ds );
			dfo.close();
			dfo = null;
		} catch (Exception e) {
            logger.error("Error: {}", e.getMessage(), e);
		}
		finally
		{
			try
			{
				if( dfo != null)
					dfo.close();
			}
			catch( Exception e )
			{
                logger.error("Error in finally: {}", e.getMessage(), e);
			}
		}
	}

	private DicomDataSet setCommonDds(Date dt, DicomDataSet ds, String studyUid, String seriesUid, String stid,
									  PatientInfo patientInfo, String pid, String accessionNumber, String studyDesc, String modifiedPatName)
			throws DCSException {
		ds.insert( DCM.E_STUDY_DATE, (new SimpleDateFormat("yyyyMMdd").format(dt)));	// 0008,0020
		ds.insert( DCM.E_STUDY_TIME, (new SimpleDateFormat("HHmmss").format(dt)));		// 0008,0030
		ds.insert( DCM.E_SERIES_DATE, (new SimpleDateFormat("yyyyMMdd").format(dt)));
		ds.insert( DCM.E_SERIES_TIME, (new SimpleDateFormat("HHmmss").format(dt)));
		ds.insert (DCM.E_CONTENT_DATE, (new SimpleDateFormat("yyyyMMdd").format(dt)));
		ds.insert (DCM.E_CONTENT_TIME, (new SimpleDateFormat("HHmmss").format(dt)));
		if(accessionNumber != null) {
			ds.insert(DCM.E_ACCESSION_NUMBER, accessionNumber);    // 0008,0050
		}else{
			ds.insert(DCM.E_ACCESSION_NUMBER, "123456");
		}
		ds.insert( DCM.E_TRANSFER_SYNTAX_UID , "1.2.840.10008.1.2.4.70"); // 0002,0010
		ds.insert( DCM.E_REFERRING_PHYSICIANS_NAME, "VISTA^^^" );	// 0008,0090
		ds.insert( DCM.E_MANUFACTURER, "Vista" );				// 0008,0070
		ds.insert (DCM.E_INSTITUTION_NAME, "VA");				// 0008,0080
		ds.insert( DCM.E_INSTANCE_NUMBER, 1);					// 0020,0013
		ds.insert( DCM.E_SERIES_NUMBER, 99999);					// 0020,0011
		ds.insert( DCM.E_STUDY_DESCRIPTION, studyDesc);		    // 0008,1030
		ds.insert( DCM.E_STUDY_INSTANCE_UID, studyUid);			// 0020,000D
		ds.insert( DCM.E_SERIES_DESCRIPTION, "Diagnostic Report");		// 0008,103e
		if(patientInfo.getDssn() == null){
			ds.insert( DCM.E_PATIENT_ID, patientInfo.getIcn() );
		}else {
			ds.insert(DCM.E_PATIENT_ID, patientInfo.getDssn());                    // 0010,0020
		}
		if(patientInfo.getSex() != null) ds.insert (DCM.E_PATIENTS_SEX, patientInfo.getSex() );	// 0010,0040
		ds.insert( DCM.E_PATIENTS_NAME, modifiedPatName );				// 0010,0010
		if(patientInfo.getDob() != null ) {
			ds.insert(DCM.E_PATIENTS_BIRTH_DATE, patientInfo.getDob());            // 0010,0030
		}
		ds.insert( DCM.E_STUDY_ID, stid);						// 0020,0010
		ds.insert( new AttributeTag("0008,1111"), "");
		ds.insert ( new AttributeTag("0010,1000"), pid );		// 0010,1000
		String seuid = seriesUid;
		if (seuid == null || seuid.isEmpty()){
			String tempStudyUid = studyUid.length() > 58 ? studyUid.substring(0, 58) : studyUid;
			if(tempStudyUid.lastIndexOf(".") == tempStudyUid.length()){
				tempStudyUid = tempStudyUid.substring(0,tempStudyUid.length()-1);
			}
			seuid = tempStudyUid + ".99999";
		}
		else if(seuid.length() <= 62) { //Some PACS will reject this if it is more than 64 characters
			seuid += ".1";
		}
		else if (seuid.charAt(62) == '.') {                       // ". [y]* y .x" len=63|64 => ".1_*"
			seuid = seuid.substring(0, seuid.substring(0, 62).lastIndexOf(".")) + ".1";
		} else {
			seuid = seuid.substring(0, seuid.lastIndexOf(".")) + ".1"; // ". [y]+ x" len=63|64 => ".1_"|".1__"
		}
		ds.insert( DCM.E_SERIES_INSTANCE_UID, seuid);			// 0020,000E
		//ds.insert( DCM.E_SERIES_INSTANCE_UID, studyUid+".1");	// 0020,000E
		if(logger.isDebugEnabled())
            logger.debug("sr studyuid={} len={} seriesuid={} len={}", studyUid, studyUid.length(), seuid, seuid.length());
		String sopuid = stid.replace("-", ".");
		sopuid = sopuid.replaceAll("[^\\d.]","");
		int idx = 63 - sopuid.length();
		if (studyUid.length() > idx) {
			sopuid = studyUid.charAt(idx-1) == '.' ? (studyUid.substring(0, idx) + sopuid) : (studyUid.substring(0, idx) + "." + sopuid);
		}
		else {
			sopuid = studyUid + "." + sopuid;
		}
		ds.insert( DCM.E_SOPINSTANCE_UID, sopuid );// 0008,0018
		if(logger.isDebugEnabled())
            logger.debug("img studyuid={} len={} sopinsuid={} len={}", studyUid, studyUid.length(), sopuid, sopuid.length());
		return ds;
	}

	private String parseStudyId(String studyUrn){
		String stid = studyUrn;
		if (stid.indexOf("urn:vastudy:") >= 0) {
			stid = stid.substring(stid.indexOf("urn:vastudy:") + 12);
			stid = stid.substring(0, stid.lastIndexOf("-"));
		}
		return stid;
	}
}

