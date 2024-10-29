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
package gov.va.med.imaging.exchange.webservices;

import gov.va.med.imaging.exchange.webservices.commands.v2.ExchangeGetStudyListCommandV2;
import gov.va.med.imaging.exchange.webservices.commands.v2.ExchangeGetStudyReportCommandV2;

import java.rmi.RemoteException;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeWebservicesV2
implements gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadata
{

	@Override
	public gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType getPatientReport(String datasource,
			gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, 
			String patientId, String transactionId,
			String studyId) 
	throws RemoteException
	{
		return new ExchangeGetStudyReportCommandV2(requestor, patientId, 
				transactionId, studyId).executeExchangeCommand();
	}

	@Override
	public gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType getPatientStudyList(String datasource,
			gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, 
			gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType filter, String patientId,
			String transactionId, String requestedSite) 
	throws RemoteException
	{
		return new ExchangeGetStudyListCommandV2(requestor, filter, 
				patientId, transactionId, requestedSite).executeExchangeCommand();
	}

}
