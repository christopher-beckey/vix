package gov.va.med.imaging.tiu.federation.translator;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.AbstractTranslator;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.tiu.federation.types.FederationPatientTIUNoteArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationPatientTIUNoteType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUAuthorArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUAuthorType;
import gov.va.med.imaging.tiu.federation.types.FederationTIULocationArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIULocationType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteRequestStatusType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteType;

public class TIUFederationRestTranslator 
extends AbstractTranslator 
{
	private static Map<TIUNoteRequestStatus, FederationTIUNoteRequestStatusType> tiuNoteRequestStatusMap;

	static{
		tiuNoteRequestStatusMap = new HashMap<TIUNoteRequestStatus, FederationTIUNoteRequestStatusType>();
		tiuNoteRequestStatusMap.put(TIUNoteRequestStatus.signedAll, FederationTIUNoteRequestStatusType.signedAll);
		tiuNoteRequestStatusMap.put(TIUNoteRequestStatus.unsigned, FederationTIUNoteRequestStatusType.unsigned);
		tiuNoteRequestStatusMap.put(TIUNoteRequestStatus.uncosigned, FederationTIUNoteRequestStatusType.uncosigned);
		tiuNoteRequestStatusMap.put(TIUNoteRequestStatus.byAuthor, FederationTIUNoteRequestStatusType.byAuthor);
		tiuNoteRequestStatusMap.put(TIUNoteRequestStatus.signedDateRange, FederationTIUNoteRequestStatusType.signedDateRange);
	}

	public static RestStringType translateUrn(PatientTIUNoteURN value){
		if(value == null){
			return null;
		}
		else{
			return new RestStringType(value.toString());
		}
	}


	private static FederationPatientTIUNoteType translate(PatientTIUNote value){
		
		RestStringType patientTIUNoteUrn = translateUrn(value.getPatientTiuNoteUrn());
		RestStringType parentPatientTIUNoteUrn = translateUrn(value.getParentPatientTiuNoteUrn());
		FederationPatientTIUNoteType type = new FederationPatientTIUNoteType(patientTIUNoteUrn, 
				value.getTitle(), value.getDate(), value.getPatientName(), value.getAuthorName(), 
				value.getAuthorDuz(), value.getHospitalLocation(), value.getSignatureStatus(), 
				value.getDischargeDate(), value.getNumberAssociatedImages(), parentPatientTIUNoteUrn);
		
		return type;
	}
	
	public static PatientTIUNoteURN translatePatientTIUNoteURN(RestStringType type) throws URNFormatException{
		if(type == null || type.getValue() == null){
			return null;
		}
		else{
			return URNFactory.create(type.getValue(), PatientTIUNoteURN.class);
		}
	}
	
	public static TIUItemURN translateTIUItemURN(RestStringType type) throws URNFormatException{
		if(type == null || type.getValue() == null){
			return null;
		}
		else{
			return URNFactory.create(type.getValue(), TIUItemURN.class);
		}
		
	}
	
	private static PatientTIUNote translate(FederationPatientTIUNoteType type) throws TranslationException{
		
		PatientTIUNoteURN patientTIUNoteUrn;
		PatientTIUNoteURN parentPatientTIUNoteUrn;
		try {
			patientTIUNoteUrn = translatePatientTIUNoteURN(type.getPatientTiuNoteUrn());
			parentPatientTIUNoteUrn = translatePatientTIUNoteURN(type.getParentPatientTiuNoteUrn());
		} catch (URNFormatException e) {
			throw new TranslationException(type.getPatientTiuNoteUrn().getValue() + 
					" cannot be transformed into a GlobalArtifactIdentifier realization."
				);
		}
		
		PatientTIUNote value = new PatientTIUNote(patientTIUNoteUrn, type.getTitle(),
		type.getDate(), type.getPatientName(), type.getAuthorName(), type.getAuthorDuz(),
		type.getHospitalLocation(), type.getSignatureStatus(), type.getDischargeDate(),
		type.getNumberAssociatedImages(), parentPatientTIUNoteUrn);
		
		return value;
	}


	public static RestStringType translateUrn(TIUItemURN value){
		if(value == null){
			return null;
		}
		else{
			return new RestStringType(value.toString());
		}
	}
	
	public static RestStringType translate(String value){
		if(value == null){
			return null;
		}
		else{
			return new RestStringType(value);
		}
	}
	
	public static String translate(RestStringType value){
		if(value == null){
			return null;
		}
		else{
			return new String(value.getValue());
		}
		
	}
	
	private static FederationTIUNoteType translate(TIUNote value){
		RestStringType urn = translateUrn(value.getNoteUrn());
		FederationTIUNoteType type = new FederationTIUNoteType(urn, value.getTitle(), 
				value.getKeyWord(), value.getNoteClass());
		return type;
	}
	
	private static TIUNote translate(FederationTIUNoteType type) throws TranslationException{
		TIUItemURN urn;
		try {
			urn = translateTIUItemURN(type.getNoteUrn());
		} catch (URNFormatException e) {
			throw new TranslationException(type.getNoteUrn().getValue() + 
					" cannot be transformed into a GlobalArtifactIdentifier realization."
				);
		}
		TIUNote value = new TIUNote(urn, type.getTitle(), type.getKeyWord(), type.getNoteClass());
		return value;
	}
	
	public static FederationTIUNoteArrayType translateTIUNotesType(List<TIUNote> items) 
	{
		FederationTIUNoteArrayType resultsArray = new FederationTIUNoteArrayType();
		if(items == null || items.isEmpty())
			return resultsArray;
		
		FederationTIUNoteType[] result = new FederationTIUNoteType[items.size()];
		int i = 0;
		for(TIUNote item : items)
		{
			result[i] = translate(item);
			i++;
		}
		resultsArray.setValues(result);
		return resultsArray;
	}
	
	
	private static FederationTIUAuthorType translate(TIUAuthor value){
		RestStringType urn = translateUrn(value.getAuthorUrn());
		FederationTIUAuthorType type = new FederationTIUAuthorType(urn, value.getName(), value.getService());
		return type;
	}
	
	public static FederationTIUAuthorArrayType translateTIUAuthorsType(List<TIUAuthor> items) 
	{
		FederationTIUAuthorArrayType resultsArray = new FederationTIUAuthorArrayType();
		if(items == null || items.isEmpty())
			return resultsArray;
		
		FederationTIUAuthorType[] result = new FederationTIUAuthorType[items.size()];
		int i = 0;
		for(TIUAuthor item : items)
		{
			
			result[i] = translate(item);
			i++;
		}
		return new FederationTIUAuthorArrayType(result);
	}
	
	public static TIUAuthor translate(FederationTIUAuthorType type) throws TranslationException{
		TIUItemURN urn;
		try {
			urn = translateTIUItemURN(type.getAuthorUrn());
		} catch (URNFormatException e) {
			throw new TranslationException(type.getAuthorUrn() + 
					" cannot be transformed into a GlobalArtifactIdentifier realization."
				);
		}
		TIUAuthor value = new TIUAuthor(urn, type.getName(), type.getService());
		return value;
	}
	
	
	private static FederationTIULocationType translate(TIULocation value){
		RestStringType urn = translateUrn(value.getLocationUrn());
		FederationTIULocationType type = new FederationTIULocationType(urn, value.getName());
		return type;
		
	}
	
	private static TIULocation translate(FederationTIULocationType type) throws TranslationException{
		TIUItemURN urn;
		try {
			urn = translateTIUItemURN(type.getLocationUrn());
		} catch (URNFormatException e) {
			throw new TranslationException(type.getLocationUrn() + 
					" cannot be transformed into a GlobalArtifactIdentifier realization."
				);
		}
		TIULocation value = new TIULocation(urn, type.getName());
		return value;
	}
	
	public static FederationTIULocationArrayType translateTIULocations(List<TIULocation> items) 
	{
		FederationTIULocationArrayType resultsArray = new FederationTIULocationArrayType();
		if(items == null)
			return resultsArray;
		
		FederationTIULocationType[] result = new FederationTIULocationType[items.size()];
		int i = 0;
		for(TIULocation item : items)
		{
			
			result[i] = translate(item);
			i++;
		}
		resultsArray.setValues(result);
		return resultsArray;
	}

	public static FederationPatientTIUNoteArrayType translatePatientTIUNotes(List<PatientTIUNote> items) 
	{
		FederationPatientTIUNoteArrayType resultsArray = new FederationPatientTIUNoteArrayType();
		if(items == null || items.isEmpty())
			return resultsArray;
		
		FederationPatientTIUNoteType[] result = new FederationPatientTIUNoteType[items.size()];
		int i = 0;
		for(PatientTIUNote item : items)
		{
			result[i] = translate(item);
			i++;
		}
		resultsArray.setValues(result);
		return resultsArray;
	}
	
	public static List<TIUAuthor> translate(FederationTIUAuthorArrayType types) {

		List<TIUAuthor> results = new ArrayList<TIUAuthor>();
		FederationTIUAuthorType[] items = types.getValues();
		
		if(items == null || items.length < 1)
			return results;
		
		
		for(FederationTIUAuthorType item : items)
		{
			TIUAuthor result;
			try {
				result = translate(item);
				results.add(result);
			} catch (TranslationException tX) {
                getLogger().error("URN Format Exception. Failed to translate and add TIUAuthorURN String [{}] to list.", item.getAuthorUrn());
			}
		}
		return results;
	}

	public static List<TIULocation> translate(FederationTIULocationArrayType types) {

		List<TIULocation> results = new ArrayList<TIULocation>();
		
		if(types == null || types.getValues() == null || types.getValues().length < 1)
			return results;

		FederationTIULocationType[] items = types.getValues();
		
		
		for(FederationTIULocationType item : items)
		{
			TIULocation result;
			try {
				result = translate(item);
				results.add(result);
			} catch (TranslationException tX) {
                getLogger().error("URN Format Exception. Failed to translate and add TIULocationURN String [{}] to list.", item.getLocationUrn());
			}
		}
		return results;
	}

	public static List<TIUNote> translate(FederationTIUNoteArrayType types) {

		List<TIUNote> results = new ArrayList<TIUNote>();
		FederationTIUNoteType[] items = types.getValues();
		
		if(items == null || items.length < 1)
			return results;
		
		
		for(FederationTIUNoteType item : items)
		{
			TIUNote result;
			try {
				result = translate(item);
				results.add(result);
			} catch (TranslationException tX) {
                getLogger().error("URN Format Exception. Failed to translate and add TIUNoteURN String [{}] to list.", item.getNoteUrn());
			}
		}
		return results;
	}


	public static List<PatientTIUNote> translate(FederationPatientTIUNoteArrayType types) {

		List<PatientTIUNote> results = new ArrayList<PatientTIUNote>();
		FederationPatientTIUNoteType[] items = types.getValues();
		
		if(items == null || items.length < 1)
			return results;
		
		
		for(FederationPatientTIUNoteType item : items)
		{
			PatientTIUNote result;
			try {
				result = translate(item);
				results.add(result);
			} catch (TranslationException tX) {
                getLogger().error("URN Format Exception. Failed to translate and add PatientTIUNoteURN String [{}] to list.", item.getPatientTiuNoteUrn());
			}
		}
		return results;
	}
	
	
	public static TIUNoteRequestStatus translate(
			FederationTIUNoteRequestStatusType requestStatusType)
		{		
			for( Entry<TIUNoteRequestStatus, FederationTIUNoteRequestStatusType> entry : TIUFederationRestTranslator.tiuNoteRequestStatusMap.entrySet() )
				if( entry.getValue() == requestStatusType )
					return entry.getKey();
			
			return TIUNoteRequestStatus.unsigned;
		}	
	
	public static FederationTIUNoteRequestStatusType translate(
			TIUNoteRequestStatus requestStatus)
		{		
			for( Entry<TIUNoteRequestStatus, FederationTIUNoteRequestStatusType> entry : TIUFederationRestTranslator.tiuNoteRequestStatusMap.entrySet() )
				if( entry.getKey() == requestStatus )
					return entry.getValue();
			
			return FederationTIUNoteRequestStatusType.unsigned;
		}	

	public static Date parseDate(String dateString)
	throws MethodException
	{
		try
		{
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			return dateFormat.parse(dateString);
		}
		catch(ParseException pX)
		{
			throw new MethodException(pX);
		}
	}

	public static PatientIdentifier parsePatientIdentifier(String patientId)
	throws MethodException
	{
		try
		{
			return PatientIdentifier.fromString(patientId);			
		}
		catch(PatientIdentifierParseException pipX)
		{
			throw new MethodException(pipX);
		}
	}
}
