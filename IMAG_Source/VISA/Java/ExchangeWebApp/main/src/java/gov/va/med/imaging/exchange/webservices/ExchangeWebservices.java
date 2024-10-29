/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 30, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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

import gov.va.med.PatientIdentifier;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ExchangeRouter;
import gov.va.med.imaging.exchange.ImagingExchangeContext;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.FilterType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.RequestorType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType;
import gov.va.med.imaging.exchange.webservices.translator.v1.ExchangeTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeWebservices 
implements gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadata
{
	private ExchangeTranslator exchangeTranslator = new ExchangeTranslator();
	private final static Logger LOGGER = Logger.getLogger(ExchangeWebservices.class);

	@Override
	public StudyType[] getPatientStudyList(String datasource,
			RequestorType requestor, FilterType filter, String patientId,
			String transactionId) 
	throws RemoteException 
	{
		setTransactionContext(requestor, transactionId);
		Long startTime = System.currentTimeMillis();
        LOGGER.info("start getPatientStudyList transaction({})", transactionId);
		ExchangeRouter router = ImagingExchangeContext.getExchangeRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve patient studies");
		
		StudyFilter studyFilter = exchangeTranslator.transformFilter(filter);			
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("Exchange WebApp getStudyList");
		//TODO: look at requesting site number and setRequestingSource 
		transactionContext.setRequestingSource("unknown");		
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		//TODO: get the site number from the request (somewhere). if none is specified then get the site 
		// number from appConfig and go against the local site
		String siteNumber = ImagingExchangeContext.getAppConfiguration().getLocalSiteNumber();// "660";				
		try 
		{
			List<Study> studies = router.getPatientStudyList(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber), 
					PatientIdentifier.icnPatientIdentifier(patientId), studyFilter);
		
			gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] studyTypes = 
				exchangeTranslator.transformStudies(studies);
            LOGGER.info("ExchangeWebservices.getPatientStudyList() --> Converted [{}] business studies into [{}] studies to return", studies == null ? 0 : studies.size(), studyTypes == null ? 0 : studyTypes.length);
			transactionContext.setEntriesReturned( studyTypes == null ? 0 : studyTypes.length );
			if (studyTypes != null)
			{
				String dumpExchangeGraphs = System.getenv("dumpvaexchangegraphs");
				if (dumpExchangeGraphs != null && dumpExchangeGraphs.equalsIgnoreCase("true"))
				{
					dumpVaStudyGraph(patientId, studyTypes);
				}
			}
            LOGGER.info("ExchangeWebservices.getPatientStudyList() --> SUCCESS, transaction [{}] in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return studyTypes;
		}
		catch(InsufficientPatientSensitivityException ipsX)
		{
			LOGGER.info("ExchangeWebservices.getPatientStudyList() --> Insufficient patient sensitivity to view specified patient, returning empty study list. This is not being logged as an exception.");
			transactionContext.setEntriesReturned(0);
            LOGGER.info("ExchangeWebservices.getPatientStudyList() --> SUCCESS, transaction [{}] in {} ms.  Returned no studies.", transactionId, System.currentTimeMillis() - startTime);
			return new gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[0];
		}
		catch(Exception ex)
		{
			String msg = "ExchangeWebservices.getPatientStudyList() --> Error while translating study: " + ex.getMessage();
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			LOGGER.error(msg);
			throw new RemoteException(msg);
		}
	}
	
	/**
	 * Set the transaction context properties that are passed in the webservices.
	 * @param requestor
	 * @param transactionId
	 */
	private void setTransactionContext(
		gov.va.med.imaging.exchange.webservices.soap.types.v1.RequestorType requestor,
		java.lang.String transactionId)
	{
		LOGGER.info("ExchangeWebservices.getPatientStudyList() --> Transaction Id [" + transactionId + 
					"], username [" + requestor == null || requestor.getUsername() == null ? "null" : requestor.getUsername() + "]");
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		if(transactionId != null)
			transactionContext.setTransactionId(transactionId);
		
		if(requestor != null)
		{
			if( requestor.getUsername() != null )
				transactionContext.setFullName(requestor.getUsername());
			if( requestor.getFacilityId() != null )
				transactionContext.setSiteNumber(requestor.getFacilityId());
			if( requestor.getFacilityName() != null )
				transactionContext.setSiteName(requestor.getFacilityName());
			if( requestor.getPurposeOfUse() != null )
				transactionContext.setPurposeOfUse(requestor.getPurposeOfUse().toString());
			if( requestor.getSsn() != null )
				transactionContext.setSsn(requestor.getSsn());
		}
	}

	private void dumpVaStudyGraph(String patientIcn, gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] exchangeStudies)
	{
		String vixcache = System.getenv("vixcache");
		
		if (vixcache != null)
		{
			String fileSpec = System.getenv("vixcache") + "/vaexchange" + patientIcn + ".xml";

			try (FileOutputStream fileOut = new FileOutputStream(StringUtil.cleanString(fileSpec));
				 OutputStream outputStream = new BufferedOutputStream(fileOut); 
				 XMLEncoder xmlEncoder = new XMLEncoder(outputStream))
			{
				xmlEncoder.writeObject(exchangeStudies);
			}
			catch (Exception ex)
			{
                LOGGER.error("ExchangeWebservices.dumpVaStudyGraph() --> Error: {}", ex.getMessage());
			}
		}
	}
}
