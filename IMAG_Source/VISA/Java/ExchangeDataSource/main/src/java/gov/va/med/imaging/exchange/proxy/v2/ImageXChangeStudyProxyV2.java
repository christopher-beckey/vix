/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 14, 2011
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
package gov.va.med.imaging.exchange.proxy.v2;

import java.rmi.RemoteException;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorTypePurposeOfUse;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType;
import gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadata;
import gov.va.med.imaging.exchange.webservices.translator.v2.ExchangeTranslatorV2;
import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.configuration.ExchangeConfiguration;

/**
 * @author vhaiswwerfej
 *
 */
public class ImageXChangeStudyProxyV2
extends ImageXChangeProxyV2
{
	private static final Logger LOGGER = Logger.getLogger(ImageXChangeStudyProxyV2.class);
	
	private final Site site;	
	private final static String defaultRemoteRepository = "*"; // get from all remote sites
	
	public ImageXChangeStudyProxyV2(ProxyServices proxyServices, Site site, ExchangeConfiguration exchangeConfiguration)
	{
		super(proxyServices, exchangeConfiguration);
		this.site = site;
	}
	
	public StudySetResult getPatientStudies(String patientIcn,
			StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		ImageMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters are not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		// JMW 8/13/08 - set the connection socket timeout to 30 seconds (default of 600 seconds)
		((org.apache.axis.client.Stub)imageMetadata).setTimeout(exchangeConfiguration.getMetadataTimeout());
		RequestorType rt = 
				new RequestorType(
						transactionContext.getFullName(), 
						transactionContext.getSsn(), 
						transactionContext.getSiteNumber(), 
						transactionContext.getSiteName(), 
				RequestorTypePurposeOfUse.value1);
		
		FilterType ft = ExchangeTranslatorV2.translate(filter);
		
		String datasource = defaultDatasource;
		StudyListResponseType studyListResponse = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			studyListResponse = imageMetadata.getPatientStudyList(
					datasource, 
					rt, 
					ft, 
					patientIcn, 
					transactionContext.getTransactionId(),
					defaultRemoteRepository
			);
		}
		catch(RemoteException rX)
		{
			String msg = "ImageXChangeStudyProxyV2.getPatientStudies() --> RemoteException: " + rX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("ImageXChangeStudyProxyV2.getPatientStudies() --> returned [{}] study list response", studyListResponse == null ? "null" : "not null");
		
		StudySetResult result = ExchangeTranslatorV2.translate(studyListResponse, site, filter,
				exchangeConfiguration.getEmptyStudyModalities());

        LOGGER.info("ImageXChangeStudyProxyV2.getPatientStudies() --> translated: {}", result == null ? "null" : result.toString(true));
		transactionContext.addDebugInformation("StudySetResult: " + (result == null ? "null" : result.toString(true)));
		return result;
	}
}
