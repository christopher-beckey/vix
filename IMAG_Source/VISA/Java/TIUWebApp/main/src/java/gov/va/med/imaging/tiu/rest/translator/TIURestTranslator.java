/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.translator;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.tiu.rest.types.TIUAuthorType;
import gov.va.med.imaging.tiu.rest.types.TIUAuthorsType;
import gov.va.med.imaging.tiu.rest.types.TIULocationType;
import gov.va.med.imaging.tiu.rest.types.TIULocationsType;
import gov.va.med.imaging.tiu.rest.types.TIUNoteRequestStatusType;
import gov.va.med.imaging.tiu.rest.types.TIUNoteType;
import gov.va.med.imaging.tiu.rest.types.TIUNotesType;
import gov.va.med.imaging.tiu.rest.types.TIUPatientNoteType;
import gov.va.med.imaging.tiu.rest.types.TIUPatientNotesType;

/**
 * @author Julian Werfel
 *
 */
public class TIURestTranslator
{
	private final static Logger logger = Logger.getLogger(TIURestTranslator.class);

	private static final String DATE_FORMAT_YYYY_MM_DD_HH_MM_SS_Z = "yyyy-MM-dd HH:mm:ssZ";
	private static final String DATE_FORMAT_YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
	
	public static TIULocationsType translateTIULocations(List<TIULocation> locations)
	{
		if(locations == null)
			return null;
		
		TIULocationType [] result = new TIULocationType[locations.size()];
		for(int i = 0; i < locations.size(); i++)
		{
			result[i] = translate(locations.get(i));
		}
		
		return new TIULocationsType(result);
	}
	
	public static TIUAuthorsType translateTIUAuthors(List<TIUAuthor> authors)
	{
		if(authors == null)
			return null;
		
		TIUAuthorType [] result = new TIUAuthorType[authors.size()];
		for(int i = 0; i < authors.size(); i++)
		{
			result[i] = translate(authors.get(i));
		}
		
		return new TIUAuthorsType(result);
	}
	
	private static TIULocationType translate(TIULocation location)
	{
		return new TIULocationType(location.getLocationUrn().toString(), location.getName());
	}
	
	private static TIUAuthorType translate(TIUAuthor author)
	{
		return new TIUAuthorType(author.getAuthorUrn().toString(), author.getName(), author.getService());
	}
	
	public static TIUNotesType translateTIUNotes(List<TIUNote> notes)
	{
		if(notes == null)
			return null;
		
		TIUNoteType [] result = new TIUNoteType[notes.size()];
		
		for(int i = 0; i < notes.size(); i++)
		{
			result[i] = translate(notes.get(i));
		}
		
		return new TIUNotesType(result);
	}

	private static TIUNoteType translate(TIUNote note)
	{
		return new TIUNoteType(note.getNoteUrn().toString(), note.getTitle(), 
				note.getKeyWord(), note.getNoteClass());
	}
	
	public static PatientIdentifier parsePatientIdentifier(String patientId)
	throws MethodException
	{
		if(patientId == null || patientId.length() < 1){
			return null;
		}
		try
		{
			return PatientIdentifier.fromString(patientId);			
		}
		catch(PatientIdentifierParseException pipX)
		{
			throw new MethodException(pipX);
		}
	}
	
	public static PatientTIUNoteURN parsePatientTIUNoteUrn(String noteUrnString)
	throws MethodException
	{
		if(noteUrnString == null || noteUrnString.length() < 1){
			return null;
		}
		
		try
		{
			return URNFactory.create(noteUrnString, PatientTIUNoteURN.class);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}
	
	public static TIUNoteRequestStatus translate(TIUNoteRequestStatusType requestStatus)
	{
		switch (requestStatus)
		{
			case byAuthor:
				return TIUNoteRequestStatus.byAuthor;
			case signedAll:
				return TIUNoteRequestStatus.signedAll;
			case signedDateRange:
				return TIUNoteRequestStatus.signedDateRange;
			case uncosigned:
				return TIUNoteRequestStatus.uncosigned;
			case unsigned:
				return TIUNoteRequestStatus.unsigned;			
		}
		return TIUNoteRequestStatus.signedAll;
	}
	
	public static TIUNoteRequestStatus translate(String status){
		
		if(status.equals("byAuthor"))
			return TIUNoteRequestStatus.byAuthor;
		if(status.equals("signedAll"))
			return TIUNoteRequestStatus.signedAll;
		if(status.equals("signedDataRange"))
			return TIUNoteRequestStatus.signedDateRange;
		if(status.equals("uncosigned"))
			return TIUNoteRequestStatus.uncosigned;
		if(status.equals("unsigned"))
			return TIUNoteRequestStatus.unsigned;
		
		
		return TIUNoteRequestStatus.signedAll;
	}
	
	public static TIUPatientNotesType translatePatientNotes(List<PatientTIUNote> notes)
	{
		if(notes == null)
			return null;
		
		TIUPatientNoteType [] result = new TIUPatientNoteType[notes.size()];
		for(int i = 0; i < notes.size(); i++)
			result[i] = translate(notes.get(i));
		
		return new TIUPatientNotesType(result);
	}
	
	public static TIUPatientNoteType translate(PatientTIUNote note)
	{
		return new TIUPatientNoteType(
			note.getPatientTiuNoteUrn() == null ? null : note.getPatientTiuNoteUrn().toString(), 
			note.getTitle(), 
			note.getDate(), note.getPatientName(), note.getAuthorName(), note.getAuthorDuz(), 
			note.getHospitalLocation(), note.getSignatureStatus(), note.getDischargeDate(), 
			note.getNumberAssociatedImages(), 
			note.getParentPatientTiuNoteUrn() == null ? null : note.getParentPatientTiuNoteUrn().toString(), 
			note.getSiteVixUrl());
	}
	
	/**
	 * 
	 * New Format: yyyy-MM-dd HH:mm:ssZ for new clients and existing should transition
	 * Old Format yyyy-MM-dd HH:mm:ss to support backward compatibility
	 * 
	 * @param dateString
	 * We would like to deprecate the old format so we have quality data fidelity.
	 * 
	 * @return java Date object adjusted to local time zone
	 * @throws ParseException
	 */
	public static Date parseDate(String dateString) throws MethodException {
		Date date = null;
		try {
			if(dateString == null) { 
				logger.error("TIURestTranslator.parseDate() received a null value");
				throw new MethodException("TIURestTranslator.parseDate() encountered a null date value");
			} else if(dateString.length() == DATE_FORMAT_YYYY_MM_DD_HH_MM_SS.length()) {
				SimpleDateFormat sdfv1 = new SimpleDateFormat(DATE_FORMAT_YYYY_MM_DD_HH_MM_SS);
				date = sdfv1.parse(dateString);
			} else {
				SimpleDateFormat sdfv2 = new SimpleDateFormat(DATE_FORMAT_YYYY_MM_DD_HH_MM_SS_Z);
				date = sdfv2.parse(dateString);
			}
		} catch (ParseException pX) {
            logger.error("TIURestTranslator.parseDate() failed to parse {}; cause: {}", dateString, pX.getMessage());
			throw new MethodException(pX);
		}
		return date;
	}
	
}
