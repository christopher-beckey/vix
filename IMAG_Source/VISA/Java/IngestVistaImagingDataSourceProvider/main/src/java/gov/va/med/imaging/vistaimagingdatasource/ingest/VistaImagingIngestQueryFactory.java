/**
 * 
 * 
 * Date Created: Dec 5, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaimagingdatasource.ingest;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author Administrator
 *
 */
public class VistaImagingIngestQueryFactory
{
	public static VistaQuery createGetSiteIen(String stationNumber)
	{
		VistaQuery query = new VistaQuery("XWB GET VARIABLE VALUE");
		query.addParameter(VistaQuery.REFERENCE, "$O(^DIC(4,\"D\",\"" + stationNumber + "\",\"\"))");
		return query;
	}

	public static VistaQuery createImportImageQuery(ImageIngestParameters imageIngestParameters, 
		String patientDfn, StudyURN studyUrn, String siteId)
	{
		VistaQuery query = new VistaQuery("MAG4 ADD IMAGE");
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put(parameters.size() + "", "5^" + patientDfn);//DFN");
		
		if(studyUrn == null)
		{
			// not part of a group
			//parameters.put(parameters.size() + "", "16^1");//ProcedurePackage"); // parent data file number
			//parameters.put(parameters.size() + "", "17^ProcedureIen");
		}
		else
		{
			// part of a group
			parameters.put(parameters.size() + "", "14^" + studyUrn.getStudyId());
		}
		if(imageIngestParameters.getProcedureDate() != null)
			parameters.put(parameters.size() + "", "15^" + toMDate(imageIngestParameters.getProcedureDate()));// 3131205.145700");//ProcedureDate"); (3131105.194111)  = NOV 05, 2013@19:41:11
		//parameters.put(parameters.size() + "", "100^DocCategory");
		if(imageIngestParameters.getDocumentDate() != null)
			parameters.put(parameters.size() + "", "110^" + toMDate(imageIngestParameters.getDocumentDate()));
		if(imageIngestParameters.getTypeIndex() != null)
			parameters.put(parameters.size() + "", "42^" + imageIngestParameters.getTypeIndex());//FixType");
		if(imageIngestParameters.getProcedureEventIndex() != null)
			parameters.put(parameters.size() + "", "43^" + imageIngestParameters.getProcedureEventIndex());//FixProc");
		if(imageIngestParameters.getSpecialtyIndex() != null)
			parameters.put(parameters.size() + "", "44^" + imageIngestParameters.getSpecialtyIndex());//FixSpec");		
		if(imageIngestParameters.getOriginIndex() != null) {
			parameters.put(parameters.size() + "", "45^" + imageIngestParameters.getOriginIndex());// NON-VA");//Origin");
		}
		if(imageIngestParameters.getTrackingNumber() != null)
			parameters.put(parameters.size() + "", "108^" + imageIngestParameters.getTrackingNumber());//TrackingNumber");
		if(imageIngestParameters.getAcquisitionDevice() != null)
			parameters.put(parameters.size() + "", "ACQD^" + imageIngestParameters.getAcquisitionDevice());
		parameters.put(parameters.size() + "", "ACQS^" + siteId);// AcquisitionSite");
		//parameters.put(parameters.size() + "", "ACQL^AcquisitionLocation");
		//parameters.put(parameters.size() + "", "3^20");
		//parameters.put(parameters.size() + "", "109^Method");
		ImageFormat imageFormat = imageIngestParameters.getImageFormat();
		VistaImageType vistaImageType = VistaImageType.getFromImageFormat(imageFormat);
		if(vistaImageType != null)
			parameters.put(parameters.size() + "", "EXT^" + vistaImageType.getDefaultFileExtension());	// JPG");//Extension");
		if(imageIngestParameters.getCaptureUser() != null && imageIngestParameters.getCaptureUser().length() > 0)
		parameters.put(parameters.size() + "", "8^" + imageIngestParameters.getCaptureUser());
		if(imageIngestParameters.getImageDescription() != null) {
			String description = imageIngestParameters.getImageDescription();
			if(description.length() > 60) {
				description = description.substring(0, 59);
			}
			parameters.put(parameters.size() + "", "10^" + description);// My group description");//ImageDescription");
		}
		if(imageIngestParameters.getProcedure() != null) {
			String procedure = imageIngestParameters.getProcedure();
			if(procedure.length() > 10){
				procedure = procedure.substring(0,9);
			}
			parameters.put(parameters.size() + "", "6^" + procedure);// CLIN");//ProcedureDescription");
		}
		if(imageIngestParameters.getCaptureDate() != null)
			parameters.put(parameters.size() + "", "7^" + toMDate(imageIngestParameters.getCaptureDate()));// T");//CaptureDate");
		parameters.put(parameters.size() + "", "41^CLIN");
		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	
	public static VistaQuery createGroupQuery(ImageIngestParameters imageIngestParameters, String patientDfn, String siteId)
	{
		VistaQuery query = new VistaQuery("MAG4 ADD IMAGE");
		Map<String, String> parameters = new HashMap<String, String>();
		
		// 2005.04^0
		parameters.put(parameters.size() + "", "2005.04^0");
		parameters.put(parameters.size() + "", "3^11");
		parameters.put(parameters.size() + "", "5^" + patientDfn);//DFN");
		//parameters.put(parameters.size() + "", "16^1");//ProcedurePackage"); // parent data file number
		//parameters.put(parameters.size() + "", "17^ProcedureIen");
		if(imageIngestParameters.getProcedureDate() != null)
			parameters.put(parameters.size() + "", "15^" + toMDate(imageIngestParameters.getProcedureDate()));// 3131205.145700");//ProcedureDate"); (3131105.194111)  = NOV 05, 2013@19:41:11
		//parameters.put(parameters.size() + "", "100^DocCategory");
		if(imageIngestParameters.getDocumentDate() != null)
			parameters.put(parameters.size() + "", "110^" + toMDate(imageIngestParameters.getDocumentDate()));
		if(imageIngestParameters.getTypeIndex() != null)
			parameters.put(parameters.size() + "", "42^" + imageIngestParameters.getTypeIndex());//FixType");
		if(imageIngestParameters.getProcedureEventIndex() != null)
			parameters.put(parameters.size() + "", "43^" + imageIngestParameters.getProcedureEventIndex());//FixProc");
		if(imageIngestParameters.getSpecialtyIndex() != null)
			parameters.put(parameters.size() + "", "44^" + imageIngestParameters.getSpecialtyIndex());//FixSpec");		
		if(imageIngestParameters.getOriginIndex() != null)
			parameters.put(parameters.size() + "", "45^" + imageIngestParameters.getOriginIndex());// NON-VA");//Origin");
		if(imageIngestParameters.getTrackingNumber() != null)
			parameters.put(parameters.size() + "", "108^" + imageIngestParameters.getTrackingNumber());//TrackingNumber");
		if(imageIngestParameters.getAcquisitionDevice() != null)
			parameters.put(parameters.size() + "", "ACQD^" + imageIngestParameters.getAcquisitionDevice());//AcquisitionDevice");
		parameters.put(parameters.size() + "", "ACQS^" + siteId);// AcquisitionSite");
		//parameters.put(parameters.size() + "", "ACQL^AcquisitionLocation");
		//parameters.put(parameters.size() + "", "109^Method");		
		if(imageIngestParameters.getCaptureUser() != null)
			parameters.put(parameters.size() + "", "8^" + imageIngestParameters.getCaptureUser());
		if(imageIngestParameters.getShortDescription() != null)
			parameters.put(parameters.size() + "", "10^" + imageIngestParameters.getShortDescription());// My group description");//GroupDescription");
		// this wasn't in cMagImport.pas but I think it should be here
		if(imageIngestParameters.getProcedure() != null)
			parameters.put(parameters.size() + "", "6^" + imageIngestParameters.getProcedure());// CLIN");//ProcedureDescription");
		parameters.put(parameters.size() + "", "41^CLIN");
		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	
	public static VistaQuery createDeleteImageEntryQuery(String imageIen)
	{
		VistaQuery query = new VistaQuery("MAGG IMAGE DELETE");
		query.addParameter(VistaQuery.LITERAL, imageIen + StringUtils.CARET + "1"); // 1=force delete
		query.addParameter(VistaQuery.LITERAL, "0"); // GrpDelOK
		query.addParameter(VistaQuery.LITERAL, ""); // reason
		
		return query;
	}
	
	public static String toMDate(Date date)
	{
		SimpleDateFormat format = new SimpleDateFormat("yyMMdd.HHmmss");
		
		StringBuilder sb = new StringBuilder();
		sb.append("3");
		sb.append(format.format(date));
		return sb.toString();
	}
	
	public static VistaQuery createAbsJBQueueQuery(String imageIen, boolean includeAbs)
	{
		VistaQuery query = new VistaQuery("MAG ABSJB");
		query.addParameter(VistaQuery.LITERAL, (includeAbs == true ? imageIen : "") + StringUtils.CARET + imageIen);
		return query;
	}
	
	public static VistaQuery createPostProcessQueuesQuery(String imageIen)
	{
		VistaQuery query = new VistaQuery("MAG4 POST PROCESS ACTIONS");
		query.addParameter(VistaQuery.LITERAL, imageIen);
		return query;
	}

	public static VistaQuery createGetImageInformationQuery(String imageIen) 
	{
		//getLogger().info("getContextIEN TransactionContext (" + TransactionContextFactory.get().getDisplayIdentity() + ").");
		
		VistaQuery msg = new VistaQuery("XWB GET VARIABLE VALUE");
		String arg = "^MAG(2005," + imageIen + ",0)";
		msg.addParameter(VistaQuery.REFERENCE, arg);
		return msg;
	}
	
	public static VistaQuery createUpdateThumbnailNetworkLocationQuery(String imageIen, String networkLocationIen)
	{
		VistaQuery query = new VistaQuery("MAG STORAGE FETCH SET");
		query.addParameter(VistaQuery.LITERAL, imageIen);
		query.addParameter(VistaQuery.LITERAL, networkLocationIen + "*");
		return query;
		
	}
}
