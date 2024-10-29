/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2010
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

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.proxy.ExchangeProxy;
import gov.va.med.imaging.exchange.proxy.v1.ExchangeProxyServices;
import gov.va.med.imaging.exchange.proxy.v1.ImageXChangeProxy;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType;
import gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorTypePurposeOfUse;
import gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadata;
import gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataServiceLocator;
import gov.va.med.imaging.exchange.webservices.translator.v2.ExchangeTranslatorV2;
import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.ImagingProxy;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.configuration.ExchangeConfiguration;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class ImageXChangeProxyV2
extends ImagingProxy
implements ExchangeProxy
{
	private static final Logger LOGGER = Logger.getLogger(ImageXChangeProxyV2.class);
	
	protected final ExchangeConfiguration exchangeConfiguration;
	protected final static String defaultDatasource = "200";
	
	public ImageXChangeProxyV2(ProxyServices proxyServices, ExchangeConfiguration exchangeConfiguration)
	{
		super(proxyServices, true);
		this.exchangeConfiguration = exchangeConfiguration;
	}
	
	protected ImageMetadata getImageMetadataService() 
	throws ConnectionException
	{
		URL localTestUrl = null;
		try
		{
			localTestUrl = new URL(proxyServices.getProxyService(ProxyServiceType.metadata).getConnectionURL());
			ImageMetadataServiceLocator locator = new ImageMetadataServiceLocator();
			ImageMetadata imageMetadata = locator.getImageMetadataV2(localTestUrl);
			
			return imageMetadata;		
		}
		catch(MalformedURLException murlX)
		{
			String msg = "ImageXChangeProxyV2.getImageMetadataService() --> MalformedURLExceptione with URL [" + localTestUrl + "]: " + murlX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, murlX);
		}
		catch(ServiceException sX)
		{
			String msg = "ImageXChangeProxyV2.getImageMetadataService() --> ServiceException with URL [" + localTestUrl + "]: " + sX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, sX);
		}
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod)
	{
		// not needed here
	}

	@Override
	protected ProxyServiceType getInstanceRequestProxyServiceType()
	{
		return ProxyServiceType.image;
	}

	@Override
	protected ProxyServiceType getTextFileRequestProxyServiceType()
	{
		return ProxyServiceType.text;
	}	
	
	public String getStudyReport(String patientIcn,
			GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		ImageMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters are not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		// JMW 8/13/08 - set the connection socket timeout to 30 seconds (default of 600 seconds)
		((org.apache.axis.client.Stub)imageMetadata).setTimeout(30000);
		RequestorType rt = 
				new RequestorType(
						transactionContext.getFullName(), 
						transactionContext.getSsn(), 
						transactionContext.getSiteNumber(), 
						transactionContext.getSiteName(), 
				RequestorTypePurposeOfUse.value1);		
		
		String datasource = defaultDatasource;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		ReportType reportType = null;
		try
		{
			StudyURN studyUrn = (StudyURN) studyId;
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			reportType = 
				imageMetadata.getPatientReport(datasource, rt, patientIcn, 
						transactionContext.getTransactionId(), studyUrn.toString(SERIALIZATION_FORMAT.NATIVE));
			
		}
		catch(RemoteException rX)
		{
			String msg = "ImageXChangeProxyV2.getStudyReport() --> RemoteException: " + rX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("ImageXChangeProxyV2.getStudyReport() --> returned [{}] study report response", reportType == null ? "null report type" : (reportType.getRadiologyReport() == null ? "null report" : reportType.getRadiologyReport().length() + " bytes"));
		
		return ExchangeTranslatorV2.translate(reportType);	

	}
	
	protected void setMetadataCredentials(ImageMetadata imageMetadata)
	{
		try
		{
			ProxyService metadataService = proxyServices.getProxyService(ProxyServiceType.metadata);

			if(metadataService.getUid() != null)
				((Stub)imageMetadata)._setProperty(Stub.USERNAME_PROPERTY, metadataService.getUid());
			
			if(metadataService.getCredentials() != null)
				((Stub)imageMetadata)._setProperty(Stub.PASSWORD_PROPERTY, metadataService.getCredentials());
		
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            LOGGER.warn("ImageXChangeProxy.setMetadataCredentials() --> Proxy not found for [{}]: {}", ProxyServiceType.metadata, psnfX.getMessage());
		}
	}
	
	@Override
	public String getAlienSiteNumber()
	{
		if(proxyServices instanceof ExchangeProxyServices)
		{
			ExchangeProxyServices eps = (ExchangeProxyServices)proxyServices;
			return eps.getAlienSiteNumber();
		}
		return null;
	}
}
