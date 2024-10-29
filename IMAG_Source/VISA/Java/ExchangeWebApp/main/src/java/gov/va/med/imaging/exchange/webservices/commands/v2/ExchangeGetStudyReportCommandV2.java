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
package gov.va.med.imaging.exchange.webservices.commands.v2;

import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.exchange.webservices.commands.AbstractExchangeGetStudyReportCommand;
import gov.va.med.imaging.exchange.webservices.translator.v2.ExchangeTranslatorV2;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeGetStudyReportCommandV2
extends AbstractExchangeGetStudyReportCommand<gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType>
{	
	public ExchangeGetStudyReportCommandV2(gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, 
			String patientId, String transactionId, String studyId)
	{
		super(studyId);
		ExchangeCommandCommonV2.setTransactionContext(requestor, transactionId);
	}

	@Override
	public Integer getEntriesReturned(gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ExchangeCommandCommonV2.exchangeV2InterfaceVersion;
	}

	@Override
	protected Class<gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType> getResultClass()
	{
		return gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType.class;
	}

	@Override
	protected gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType translateRouterResult(Study routerResult)
	throws TranslationException
	{
		return ExchangeTranslatorV2.translateToStudyReport(routerResult);		
	}

}
