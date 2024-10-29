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
package gov.va.med.imaging.mix.webservices;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.mix.webservices.commands.v1.MixGetReportAndShallowStudyListCommandV1;
import gov.va.med.imaging.mix.webservices.commands.v1.MixGetStudyTreeCommandV1;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXMetadataException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportTypeProcedureCodes;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslator;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;

import java.rmi.RemoteException;
import java.text.ParseException;

/**
 * @author vhaiswwerfej
 *
 */
public class MixWebservicesV1
implements gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata
{

	@Override
	public ReportType getPatientReport(String datasource,
			RequestorType requestor, 
			String patientId, 
			String transactionId,
			String studyId) 
	throws MIXMetadataException
	{
		Study study = new MixGetStudyTreeCommandV1(studyId, transactionId).executeMixCommand();

		StudyType studyType = null;
		try {
			studyType = MixTranslator.transformStudy(study);
		}
		catch (URNFormatException ufe) {
			throw new MIXMetadataException("URN format exception during study translation: " + ufe.getMessage());
		}
		catch (ParseException pe) {
			throw new MIXMetadataException("URN parsing exception during study translation: " + pe.getMessage());
		}

		ReportType reportType = new ReportType();
		reportType.setRadiologyReport(studyType.getReportContent());
		reportType.setPatientId(patientId);
		reportType.setProcedureDate(studyType.getProcedureDate());

		String cptCode = studyType.getProcedureCodes().getCptCode(0);
		ReportTypeProcedureCodes rpcs = new ReportTypeProcedureCodes();
		rpcs.setCptCode(0, cptCode);
		reportType.setProcedureCodes(rpcs);

		reportType.setSiteAbbreviation(studyType.getSiteAbbreviation());
		reportType.setSiteName(studyType.getSiteName());
		reportType.setSiteNumber(studyType.getSiteNumber());
		reportType.setStudyId(studyType.getStudyId());

		return reportType;
	}

	@Override
	public ReportStudyListResponseType getPatientReportStudyList(String datasource,
			RequestorType requestor, FilterType filter, 
			String patientId, Boolean fullTree,
			String transactionId, String requestedSite) 
	throws MIXMetadataException
	{
		StudySetResult studySetResult = new MixGetReportAndShallowStudyListCommandV1( 
				patientId, "VHA", filter.getFromDate(), filter.getToDate(), null, transactionId).executeMixCommand();

		ReportStudyListResponseType rSLRT = null;
		try {
			rSLRT = MixTranslatorV1.translate(studySetResult);
		} 
		catch (TranslationException te) {
			throw new MIXMetadataException("StudySetResult translation exception: " + te.getMessage());
		}

		return rSLRT;
	}
}
