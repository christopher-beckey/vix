/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.tiu;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingTIUQueryFactory
{

	public static VistaQuery createGetTiuNotesQuery(String searchText, String titleList)
	{
		VistaQuery query = new VistaQuery("MAG3 TIU LONG LIST OF TITLES");
		query.addParameter(VistaQuery.LITERAL, "NOTE|" + (searchText == null ? "" : "" + searchText.toUpperCase()));
		if(titleList != null && !titleList.isEmpty()){
			if(titleList.equalsIgnoreCase("USER")){
				query.addParameter(VistaQuery.LITERAL, "1");			
			}
		}
		return query;
	}
	
	public static VistaQuery createGetTiuAuthors(String searchText)
	{
		VistaQuery query = new VistaQuery("MAG3 LOOKUP ANY");
		query.addParameter(VistaQuery.LITERAL, "200^50^" + (searchText == null ? "" : "" + searchText.toUpperCase()) + "^.01;29");
		query.addParameter(VistaQuery.LITERAL, "1^");
		return query;
	}
	
	public static VistaQuery createGetTiuLocations(String searchText)
	{
		VistaQuery query = new VistaQuery("MAG3 LOOKUP ANY");
		query.addParameter(VistaQuery.LITERAL, "44^50^" + (searchText == null ? "" : "" + searchText.toUpperCase()) + "^.01^");
		query.addParameter(VistaQuery.LITERAL, "1^");
		return query;
	}
	
	public static VistaQuery createAssociateImageWithNoteQuery(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuNoteUrn)
	{
		VistaQuery query = new VistaQuery("MAG3 TIU IMAGE");
		query.addParameter(VistaQuery.LITERAL, imagingUrn.getImagingIdentifier());
		query.addParameter(VistaQuery.LITERAL, tiuNoteUrn.getItemId());
		return query;
	}
	
	public static VistaQuery createTIUNoteQuery(String patientDfn, TIUItemURN locationUrn, 
		Date noteDate, TIUItemURN noteUrn, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
	{		
		VistaQuery query = new VistaQuery("MAG3 TIU NEW");
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		query.addParameter(VistaQuery.LITERAL, noteUrn.getItemId());
		query.addParameter(VistaQuery.LITERAL, "0"); // admin close (1 to close admin)
		query.addParameter(VistaQuery.LITERAL, "S"); // mode (s = scanned document, m = manual closure)
		query.addParameter(VistaQuery.LITERAL, ""); // esig hash
		query.addParameter(VistaQuery.LITERAL, (authorUrn == null ? "" : "" + authorUrn.getItemId()));
		query.addParameter(VistaQuery.LITERAL, (locationUrn == null ? "" : "" + locationUrn.getItemId()));
		query.addParameter(VistaQuery.LITERAL, (noteDate == null ? "" : "" + toMDate(noteDate)));
		query.addParameter(VistaQuery.LITERAL, (consultUrn == null ? "" : "" + consultUrn.getConsultId()));
		if(noteText != null && noteText.length() > 0)
		{
			HashMap<String, String> parameters = new HashMap<String, String>();
			DecimalFormat df = new DecimalFormat("00000000");
			String [] lines = StringUtils.Split(noteText, StringUtils.NEW_LINE);
			for(int i = 0; i < lines.length; i++)
			{
				String lengthPiece = df.format(i);
				parameters.put("\"TEXT" + lengthPiece + "\"", lines[i]);	
			}
			query.addParameter(VistaQuery.LIST, parameters);
		}
		return query;
	}
	
	private static String toMDate(Date date)
	{
		SimpleDateFormat format = new SimpleDateFormat("yyMMdd.HHmmss");
		
		StringBuilder sb = new StringBuilder();
		sb.append("3");
		sb.append(format.format(date));
		return sb.toString();
	}
	
	public static VistaQuery createModifyTIUNoteQuery(String patientDfn, String noteId, UpdateNoteStatus newStatus, String esigHash)
	{
		VistaQuery query = new VistaQuery("MAG3 TIU MODIFY NOTE");
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		query.addParameter(VistaQuery.LITERAL, noteId);
		query.addParameter(VistaQuery.LITERAL, newStatus.getStatusCode()); // admin close (1 to close admin)
		query.addParameter(VistaQuery.LITERAL, "S"); // mode (s = scanned document, m = manual closure)
		query.addParameter(VistaQuery.LITERAL, (esigHash == null ? "" : "" + esigHash)); // esig hash
		query.addParameter(VistaQuery.LITERAL, ""); // DUZ of signer
		return query;
	}
	
	public static VistaQuery createIsNoteAConsultQuery(TIUItemURN tiuNoteUrn)
	{
		VistaQuery query = new VistaQuery("TIU IS THIS A CONSULT?");
		query.addParameter(VistaQuery.LITERAL, tiuNoteUrn.getItemId());
		return query;
	}
	
	public static VistaQuery createIsAdvanceDirectiveQuery(String ien, boolean newNote)
	{
		VistaQuery query = new VistaQuery("MAGG IS DOC CLASS");
		query.addParameter(VistaQuery.LITERAL, ien);
		if(newNote)
			query.addParameter(VistaQuery.LITERAL, "8925.1");
		else
			query.addParameter(VistaQuery.LITERAL, "8925");
			query.addParameter(VistaQuery.LITERAL, "ADVANCE DIRECTIVE");
		return query;
	}
	
	public static VistaQuery createGetPatientTIUNotesQuery(TIUNoteRequestStatus noteStatus,
		String patientDfn, Date fromDate, Date toDate,
		String authorDuz, int count, boolean ascending)
	{
		VistaQuery query = new VistaQuery("TIU DOCUMENTS BY CONTEXT");
		query.addParameter(VistaQuery.LITERAL, "3"); // document class, 3 = progress notes
		
		query.addParameter(VistaQuery.LITERAL, noteStatus.getValue());
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		query.addParameter(VistaQuery.LITERAL, (fromDate == null ? "" : "" + toMDate(fromDate)));
		query.addParameter(VistaQuery.LITERAL, (toDate == null ? "" : "" + toMDate(toDate)));
		query.addParameter(VistaQuery.LITERAL, (authorDuz == null ? "" : "" + authorDuz));
		query.addParameter(VistaQuery.LITERAL, String.valueOf(count));
		query.addParameter(VistaQuery.LITERAL, (ascending == true ? "A" : "D"));
		query.addParameter(VistaQuery.LITERAL, "1");
		query.addParameter(VistaQuery.LITERAL, "0");
		return query;
	}
	
	public static VistaQuery createGetTIUNoteDetailsQuery(PatientTIUNoteURN noteUrn)
	{
		VistaQuery query = new VistaQuery("TIU GET RECORD TEXT");
		query.addParameter(VistaQuery.LITERAL, noteUrn.getNoteId());
		return query;
	}
	
	public static VistaQuery createTIUNoteAddendumQuery(String patientDfn,
		PatientTIUNoteURN noteUrn, Date date, String addendumText)
	{		
		VistaQuery query = new VistaQuery("MAG3 TIU CREATE ADDENDUM");
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		query.addParameter(VistaQuery.LITERAL, noteUrn.getNoteId());
		query.addParameter(VistaQuery.LITERAL, "0"); // admin close (0 = unsigned)
		query.addParameter(VistaQuery.LITERAL, "S"); // mode (s = scanned document, m = manual closure)
		query.addParameter(VistaQuery.LITERAL, ""); // esig hash
		query.addParameter(VistaQuery.LITERAL, ""); // DUZ of signer
		query.addParameter(VistaQuery.LITERAL, toMDate(date));
		if(addendumText != null && addendumText.length() > 0)
		{
			HashMap<String, String> parameters = new HashMap<String, String>();
			DecimalFormat df = new DecimalFormat("00000000");
			String [] lines = StringUtils.Split(addendumText, StringUtils.NEW_LINE);
			for(int i = 0; i < lines.length; i++)
			{
				String lengthPiece = df.format(i);
				parameters.put("\"TEXT" + lengthPiece + "\"", lines[i]);	
			}
			query.addParameter(VistaQuery.LIST, parameters);
		}
		return query;
	}
	
	public enum UpdateNoteStatus
	{
		unsigned("0"),
		electronicallyFiled("1"),
		electronicallySigned("2");
		
		final String statusCode;
		
		UpdateNoteStatus(String statusCode)
		{
			this.statusCode = statusCode;
		}

		/**
		 * @return the statusCode
		 */
		public String getStatusCode()
		{
			return statusCode;
		}
	}
}
