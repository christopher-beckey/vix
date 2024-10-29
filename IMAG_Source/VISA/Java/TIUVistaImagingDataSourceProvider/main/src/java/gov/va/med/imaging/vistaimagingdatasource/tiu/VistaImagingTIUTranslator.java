/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.tiu;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.protocol.vista.VistaCommonTranslator;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.url.vista.StringUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.text.SimpleDateFormat;
import java.text.ParseException;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingTIUTranslator
{
	/**	 
	 	IEN^TITLE^REFERENCE DATE/TIME (INT)^PATIENT NAME (LAST I/LAST 4)^AUTHOR
	    (INT;EXT)^HOSPITAL LOCATION^SIGNATURE STATUS^Visit Date/Time^
	    Discharge Date/time^Variable Pointer to Request (e.g., Consult)^# of
	    Associated Images^Subject^Has Children^IEN of Parent Document
	 	 
	 	68^DERMATOLOGY PROCEDURE CONSENT^3140211.102359^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/11/14;3140211.102359^        ;^^1^^^1^
		67^Adverse React/Allergy^3140210.1344^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.1344^        ;^^1^^^1^
		66^CLINICAL WARNING^3140210.1327^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.1327^        ;^^1^^^1^
		65^Adverse React/Allergy^3140210.1317^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.1317^        ;^^1^^^1^
		64^CLINICAL WARNING^3140210.1259^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.1259^        ;^^1^^^1^
		63^ADVANCE DIRECTIVE^3140210.1211^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.1211^        ;^^1^^^1^
		62^CRISIS NOTE^3140210.120938^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.120938^        ;^^1^^^1^
		55^ADVANCE DIRECTIVE^3140207.1258^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/07/14;3140207.125851^        ;^^0^^^1^
		54^EKG CONSULT NOTE^3111222.0019^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 11/07/11;3111107.151137^        ;^7;GMR(123,^1^^^1^
		53^EKG CONSULT NOTE^3111107.1516^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 11/07/11;3111107.151137^        ;^8;GMR(123,^3^^^1^
	 
	 * @param rpcResult
	 * @param patientIdentifier
	 * @param site
	 * @return
	 */
	public static List<PatientTIUNote> translatePatientTiuNotes(String rpcResult, PatientIdentifier patientIdentifier, Site site)
	throws MethodException
	{
		List<PatientTIUNote> result = new ArrayList<PatientTIUNote>();
		String [] lines = StringUtils.Split(rpcResult, StringUtils.NEW_LINE);
		for(String line : lines)
		{
			
			//0 ^1                ^2           ^3                    ^4                           ^5        ^6        ^7                           ^8         ^10^
			//63^ADVANCE DIRECTIVE^3140210.1211^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.1211^        ;^^1^^^1^
			//69^Addendum to CRISIS NOTE^3140214.162133^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^unsigned^Visit: 02/10/14;3140210.120938^        ;^^0^^^62^
			//62^CRISIS NOTE^3140210.120938^FRANK, MACY L (F7890)^76;STUART FRANK;FRANK,STUART^DR OFFICE^completed^Visit: 02/10/14;3140210.120938^        ;^^1^^+^1^
			
			String [] pieces = StringUtils.Split(line.trim(), StringUtils.CARET);
			String ien = pieces[0];
			String title = pieces[1];
			String dateString = pieces[2];
			String patientName = pieces[3];
			String authorString = pieces[4];
			String hospitalLocation = pieces[5];
			String signatureStatus = pieces[6];
			String visitDateString = pieces[7];
			String numberOfAssociatedImagesString = pieces[10];
			String parentIen = pieces[13];
		
			Date date = VistaCommonTranslator.convertMDateToDate(dateString);
			
			String [] authorStringPieces = StringUtils.Split(authorString, StringUtils.SEMICOLON);
			String authorDuz = authorStringPieces[0];
			String authorName = authorStringPieces[2];
			
			Date visitDate = null;
			if(visitDateString != null && visitDateString.length() > 0)
			{
				String [] visitDatePieces;
				// TH 7/23/2017: check date extracted format, insure that's not 
				// empty before calling  VistaCommonTranslator.convertMDateToDate()
				if(visitDateString.contains(";"))
				{
					visitDatePieces = StringUtils.Split(visitDateString, StringUtils.SEMICOLON);
					if (visitDatePieces.length > 1)
					{
						if (visitDatePieces[1] != null && visitDatePieces[1].length() > 0)
							visitDate = VistaCommonTranslator.convertMDateToDate(visitDatePieces[1]);
					}
				}
				else
				{
					SimpleDateFormat format = new SimpleDateFormat("mm/dd/yy");
					visitDatePieces = StringUtils.Split(visitDateString, StringUtils.COLON);
					try 
					{
						visitDate = format.parse(visitDatePieces[1]);
					}
					catch (ParseException e) 
					{
						visitDate = new Date();
			        }
				}

			}
			int numberOfAssociatedImages = 0;
			if(numberOfAssociatedImagesString != null && numberOfAssociatedImagesString.length() > 0)
				numberOfAssociatedImages = Integer.parseInt(numberOfAssociatedImagesString);
			
			try
			{
				PatientTIUNoteURN noteUrn = PatientTIUNoteURN.create(site.getRepositoryId(), ien, patientIdentifier);
				PatientTIUNoteURN parentTIUNoteUrn = null;
				// The parentIen always seems to have a value (either a 1 or another number) - if a 1, no way to know if really a parent is to note 1 or not - ignoring for now
				if(parentIen != null && parentIen.length() > 0)
					parentTIUNoteUrn = PatientTIUNoteURN.create(site.getRepositoryId(), parentIen, patientIdentifier);
				
				result.add(new PatientTIUNote(noteUrn, title, date, patientName, authorName, 
					authorDuz, hospitalLocation, signatureStatus, visitDate, numberOfAssociatedImages, parentTIUNoteUrn));
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
			
		}
		return result;
	}
	
	public static List<TIULocation> translateLocations(String rpcResult, Site site)
	throws MethodException
	{
		/*
			2^Found 2 entries matching "Dr"
			NAME
			DR OFFICE^|2
			DR. FRANK'S CLINIC^|9
		 */
		List<TIULocation> result = new ArrayList<TIULocation>();
		String [] lines = StringUtils.Split(rpcResult,  StringUtils.NEW_LINE);
		for(int i = 2; i < lines.length; i++)
		{
			String [] sections = StringUtils.Split(lines[i].trim(), StringUtils.STICK);			
			String [] pieces = StringUtils.Split(sections[0], StringUtils.CARET);
			String ien = sections[1].trim();
			String name = pieces[0].trim();
			try
			{
				TIUItemURN urn = TIUItemURN.create(site.getRepositoryId(), ien);
				result.add(new TIULocation(urn, name));	
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
		}
		
		return result;
	}
	
	public static List<TIUAuthor> translateAuthors(String rpcResult, Site site)
	throws MethodException
	{
		/*
			2^Found 2 entries matching "FR"
			NAME^SERVICE/SECTION
			FRANK,STUART^MEDICINE^|76
			FRANK,STUART^^|81
		 */
		List<TIUAuthor> result = new ArrayList<TIUAuthor>();
		String [] lines = StringUtils.Split(rpcResult,  StringUtils.NEW_LINE);
		for(int i = 2; i < lines.length; i++)
		{
			String [] sections = StringUtils.Split(lines[i].trim(), StringUtils.STICK);			
			String [] pieces = StringUtils.Split(sections[0], StringUtils.CARET);
			String ien = sections[1].trim();
			String name = pieces[0].trim();
			String section = pieces[1].trim();
			try
			{
				TIUItemURN urn = TIUItemURN.create(site.getRepositoryId(), ien);
				result.add(new TIUAuthor(urn, name, section));	
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
		}		
		return result;
	}
	
	
	/**
	 * 
	 * @param result
	 * @param site
	 * @return
	 */
	public static List<TIUNote> translateTIUNotes(String rpcResult, Site site)
	throws MethodException
	{
		/*
		 	1^Success^^
			key word^TITLE^CLASS
			ADVANCE  ^<ADVANCE DIRECTIVE>^NOTE|8
			ADVANCE DIRECTIVE^^NOTE|8
			ADVERSE  ^<ADVERSE REACTION/ALLERGY>^NOTE|17
		 */
		
		List<TIUNote> result = new ArrayList<TIUNote>();
		String [] lines = StringUtils.Split(rpcResult,  StringUtils.NEW_LINE);
		for(int i = 2; i < lines.length; i++)
		{
			String [] sections = StringUtils.Split(lines[i].trim(), StringUtils.STICK);			
			String [] pieces = StringUtils.Split(sections[0], StringUtils.CARET);
			String ien = sections[1].trim();
			String keyword = pieces[0];
			String title = pieces[1];
			if(title != null && title.length() > 0){
				if(title.contains("<")){
					title = title.replace('<', ' ');
				}
				if(title.contains(">")){
					title = title.replace('>', ' ');
				}
				title = title.trim();
			}
			String noteClass = pieces[2];
			try
			{
				TIUItemURN noteUrn = TIUItemURN.create(site.getRepositoryId(), ien);
				result.add(new TIUNote(noteUrn, title, keyword, noteClass));
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
		}
		return result;
	}

}
