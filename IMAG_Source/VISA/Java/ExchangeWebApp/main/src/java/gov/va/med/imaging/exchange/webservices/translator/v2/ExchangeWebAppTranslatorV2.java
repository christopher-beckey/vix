/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 27, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.exchange.webservices.translator.v2;

import gov.va.med.URNFactory;
import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ProcedureFilter;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.ProcedureFilterMatchMode;

import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeWebAppTranslatorV2
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeWebAppTranslatorV2.class);	
	
	private static DateFormat getWebserviceDateFormat()
	{
		return new DicomDateFormat();
	}
	
	public static ProcedureFilter translate(gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType filterType)
	{
		ProcedureFilter filter = new ProcedureFilter(ProcedureFilterMatchMode.existInProcedureList);
		// JMW - for now set to level 2 as allowed, might change later if can get information from DoD
		// this is the same level we have always been providing to the DoD.
		filter.setMaximumAllowedLevel(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK);
		if(filterType != null) 
		{
			DateFormat df = getWebserviceDateFormat();
			
			Date fromDate = null;
			try
			{
				fromDate = filterType.getFromDate() == null || filterType.getFromDate().length() == 0 ? 
						null : 
						df.parse(filterType.getFromDate());
			} 
			catch (ParseException x)
			{
                LOGGER.error("ExchangeWebAppTranslatorV2.translate() --> Set to null. Encountered ParseException for from-date [{}]: {}", filterType.getFromDate(), x.getMessage());
				fromDate = null;
			}
			
			Date toDate = null;
			try
			{
				toDate = filterType.getToDate() == null || filterType.getToDate().length() == 0 ? 
						null : 
						df.parse(filterType.getToDate());
			} 
			catch (ParseException x)
			{
                LOGGER.error("ExchangeWebAppTranslatorV2.translate(1) --> Set to null. Encountered ParseException for to-date [{}]: {}", filterType.getToDate(), x.getMessage());
				toDate = null;
			}
			
			filter.setFromDate(fromDate);
			filter.setToDate(toDate);
			// the study Id recieved in the filter (from the DOD) should be the entire study URN
			// need to convert that to just the internal study Id value (IEN)
			if(filterType.getStudyId() == null) 
			{
				filter.setStudyId(null);
			}
			else {
				try {
					StudyURN studyUrn = URNFactory.create(filterType.getStudyId(), StudyURN.class);
					filter.setStudyId(studyUrn);
				}
				catch(ClassCastException ccX) {
					filter.setStudyId(null);
				}
				catch(URNFormatException iurnfX) {
					filter.setStudyId(null);
				}
				
			}
			//filter.setStudyId(filterType.getStudyId() == null ? "" : filterType.getStudyId());
		}		
		return filter;
	}
}
