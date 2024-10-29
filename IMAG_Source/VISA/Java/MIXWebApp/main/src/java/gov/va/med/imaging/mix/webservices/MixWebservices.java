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
package gov.va.med.imaging.mix.webservices;

import gov.va.med.PatientIdentifier;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.mix.MixRouter;
import gov.va.med.imaging.mix.MixContext;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXMetadataException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
// import java.rmi.RemoteException;
import java.text.ParseException;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class MixWebservices 
implements gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata
{
	private MixTranslator mixTranslator = new MixTranslator();
	private final static Logger logger = Logger.getLogger(MixWebservices.class);

	// @Override
	public ReportStudyListResponseType getPatientReportStudyList(String datasource,
			RequestorType requestor, FilterType filter, String patientId, Boolean fullTree, // full Tree value ignored; Full returned
			String transactionId, String requestedSite) 
	throws MIXMetadataException 
	{
		setTransactionContext(requestor, transactionId);
		Long startTime = System.currentTimeMillis();
		ReportStudyListResponseType rsrt = null;
        logger.info("start getPatientReportStudyList transaction({})", transactionId);
		MixRouter router = MixContext.getMixRouter();
		if(router == null)
			throw new MIXMetadataException("Internal error, unable to retrieve patient reports/studies");
		
		StudyFilter studyFilter = mixTranslator.transformFilter(filter);			
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("Mix WebApp getStudyList");
		//TODO: look at requesting site number and setRequestingSource 
		transactionContext.setRequestingSource("unknown");		
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		//TODO: get the site number from the request (somewhere). if none is specified then get the site 
		// number from appConfig and go against the local site
		String siteNumber = MixContext.getAppConfiguration().getLocalSiteNumber();// "660";				
		try 
		{
			List<Study> studies = router.getPatientStudyList(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber), 
					PatientIdentifier.icnPatientIdentifier(patientId), studyFilter);
		
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] studyTypes = 
				mixTranslator.transformStudies(studies);
            logger.info("Converted [{}] business studies into [{}] studies to return", studies == null ? 0 : studies.size(), studyTypes == null ? 0 : studyTypes.length);
			transactionContext.setEntriesReturned( studyTypes == null ? 0 : studyTypes.length );
			if (studyTypes != null)
			{
				String dumpExchangeGraphs = System.getenv("dumpvaexchangegraphs");
				if (dumpExchangeGraphs != null && dumpExchangeGraphs.equalsIgnoreCase("true"))
				{
					dumpVaStudyGraph(patientId, studyTypes);
				}
			}
            logger.info("SUCCESS getPatientReportStudyList transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			rsrt = new ReportStudyListResponseType();
			rsrt.setPartialResponse(false); // **** studies.isPartialResult());
			rsrt.setStudies(studyTypes);
			rsrt.setErrors(null); // ***
//		    for (int i = 0; i < studyTypes.length; i++) {
//		    	rsrt.setStudies(i, studyTypes.get(i));
//		     }

			return rsrt;
		}
		catch(InsufficientPatientSensitivityException ipsX)
		{
			logger.info("Insufficient patient sensitivity to view specified patient, returning empty study list for now... This is not being logged as an exception", ipsX);
			transactionContext.setEntriesReturned(0);
            logger.info("SUCCESS getPatientStudyList transaction({}) in {} ms, returned no studies)", transactionId, System.currentTimeMillis() - startTime);
			return rsrt;
		}
		catch(ParseException pX)
		{
			transactionContext.setErrorMessage(pX.getMessage());
			transactionContext.setExceptionClassName(pX.getClass().getSimpleName());
			throw new MIXMetadataException("Internal error, unable to translate study procedure date", pX);
		}
		catch(URNFormatException iurnfX)
		{
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new MIXMetadataException("Internal error, unable to translate study metadata", iurnfX);
		}
		catch(MethodException mX)
		{
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new MIXMetadataException("Internal error, unable to translate study metadata", mX);
		}
		catch(ConnectionException cX)
		{
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new MIXMetadataException("Internal error, unable to translate study metadata", cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new MIXMetadataException("Internal error, unable to translate study metadata", rtfX);
		}
	}
	
	/**
	 * Set the transaction context properties that are passed in the webservices.
	 * @param requestor
	 * @param transactionId
	 */
	private void setTransactionContext(
		gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType requestor,
		java.lang.String transactionId)
	{
		logger.info(
				"setTransactionContext, id='" + transactionId + 
				"', username='" + requestor == null || requestor.getUsername() == null ? "null" : "" + requestor.getUsername() +
				"'.");
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

	private void dumpVaStudyGraph(String patientIcn, gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] exchangeStudies)
	{
		String vixcache = System.getenv("vixcache");
		if (vixcache != null)
		{
			// Fortify change: added try-with-resources and normalized path
			String fileSpec = FilenameUtils.normalize(vixcache + "/vaexchange" + patientIcn + ".xml");
			
			try ( FileOutputStream outStream = new FileOutputStream(fileSpec);
			      BufferedOutputStream bufferOut = new BufferedOutputStream(outStream);
				  XMLEncoder xmlEncoder = new XMLEncoder(bufferOut) )
			{
				xmlEncoder.writeObject(exchangeStudies);
			}
			catch (Exception ex)
			{
                logger.error("Error dumping study graph: {}", ex.getMessage());
			}
		}
	}

//	@Override
//	public ReportStudyListResponseType getPatientReportStudyList(
//			String datasource, RequestorType reqtor, FilterType filtr,
//			String patId, Boolean fullTree, String transactId)
//			throws MIXMetadataException {
//		// TODO Auto-generated method stub
//		return null;
//	}

	@Override
	public ReportType getPatientReport(String datasource, RequestorType reqtor,
			String patId, String studyId, String transactId)
			throws MIXMetadataException {
		// TODO Auto-generated method stub
		return null;
	}

	
}
