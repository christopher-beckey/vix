/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 28, 2010
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

import gov.va.med.imaging.exchange.ProcedureFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.exchange.webservices.commands.AbstractExchangeGetStudyListCommand;
import gov.va.med.imaging.exchange.webservices.translator.v2.ExchangeTranslatorV2;
import gov.va.med.imaging.exchange.webservices.translator.v2.ExchangeWebAppTranslatorV2;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeGetStudyListCommandV2
extends AbstractExchangeGetStudyListCommand<gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType>
{
	private final gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType filter;
	
	public ExchangeGetStudyListCommandV2(
			gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, 
			gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType filter, String patientId,
			String transactionId, String requestedSite)
	{
		super(patientId, requestedSite);
		this.filter = filter;
		ExchangeCommandCommonV2.setTransactionContext(requestor, transactionId);
	}

	@Override
	protected ProcedureFilter getStudyFilter()
	{
		ProcedureFilter procedureFilter = ExchangeWebAppTranslatorV2.translate(filter);
		return procedureFilter;
	}

	@Override
	public Integer getEntriesReturned(gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType translatedResult)
	{
		return (translatedResult == null ? 0 : (translatedResult.getStudies() == null ? 0 : translatedResult.getStudies().length));
	}

	@Override
	public String getInterfaceVersion()
	{
		return ExchangeCommandCommonV2.exchangeV2InterfaceVersion;
	}

	@Override
	protected Class<gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType> getResultClass()
	{
		return gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType.class;
	}

	@Override
	protected gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType translateRouterResult(
			StudySetResult routerResult) throws TranslationException
	{
		return ExchangeTranslatorV2.translate(routerResult);
	}

}
