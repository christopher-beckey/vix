/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2017
  Developer:  VHAISLTJAHJB
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
package gov.va.med.imaging.federation.proxy.v8;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageAnnotationURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationSource;
import gov.va.med.imaging.federation.rest.endpoints.FederationImageAnnotationRestUri;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationImageAnnotationDetailsType;
import gov.va.med.imaging.federation.rest.types.FederationImageAnnotationType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.federation.proxy.v5.FederationRestImageAnnotationProxyV5;

/**
 * @author VHAISLTJAHJB
 *
 */
public class FederationRestImageAnnotationProxyV8
extends FederationRestImageAnnotationProxyV5
{
	public FederationRestImageAnnotationProxyV8(ProxyServices proxyServices, 
			FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}

	@Override
	protected String getDataSourceVersion()
	{
		return "8";
	}

	public List<ImageAnnotation> getImageAnnotations(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestImageAnnotationProxyV8.getImageAnnotations() --> Transaction Id [{}] initiated, image '{}'.", transactionId, imagingUrn.toString());
		setDataSourceMethodAndVersion("getImageAnnotations");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{imagingUrn}", imagingUrn.toString());
		String url = getWebResourceUrl(FederationImageAnnotationRestUri.imageAnnotationsPath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);		
		FederationImageAnnotationType [] imageAnnotations = getClient.executeRequest(FederationImageAnnotationType[].class);
        getLogger().info("FederationRestImageAnnotationProxyV8.getImageAnnotations() --> Transaction Id [{}] returned [{}] patient sensitivity webservice object.", transactionId, imageAnnotations == null ? "null" : "not null");
		List<ImageAnnotation> result = null;
		try
		{
			result = FederationRestTranslator.translate(imageAnnotations);
		}
		catch(URNFormatException urnfX)
		{
			String msg = "FederationRestVistaRadProxyV4.getImageAnnotations() --> Encountered URNFormatException while translating image annotations: " + urnfX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, urnfX);
		}

        getLogger().info("FederationRestImageAnnotationProxyV8.getImageAnnotations() --> Transaction Id [{}] returned [{}] image annotations.", transactionId, result == null ? "null" : result.size());
		return result;
	}
	
	public ImageAnnotationDetails getAnnotationDetails(
			AbstractImagingURN imagingUrn,
			ImageAnnotationURN imageAnnotationUrn) 
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestImageAnnotationProxyV8.getAnnotationDetails() --> Transaction Id [{}] initiated, image annotation '{}'.", transactionId, imageAnnotationUrn.toString());
		setDataSourceMethodAndVersion("getAnnotationDetails");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{imagingUrn}", imagingUrn.toString());
		urlParameterKeyValues.put("{imageAnnotationUrn}", imageAnnotationUrn.toString());
		String url = getWebResourceUrl(FederationImageAnnotationRestUri.imageAnnotationDetailsPath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		
		FederationImageAnnotationDetailsType imageAnnotationDetails = 
			getClient.executeRequest(FederationImageAnnotationDetailsType.class);

        getLogger().info("FederationRestImageAnnotationProxyV8.getAnnotationDetails() --> Transaction Id [{}] returned [{}] image annotation details webservice object.", transactionId, imageAnnotationDetails == null ? "null" : "not null");
		ImageAnnotationDetails result = null;
		try
		{
			result = FederationRestTranslator.translate(imageAnnotationDetails);
		}
		catch(URNFormatException urnfX)
		{
			String msg = "FederationRestVistaRadProxyV4.getAnnotationDetails() --> Encountered URNFormatException while translating image annotation details: " + urnfX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, urnfX);
		}

        getLogger().info("FederationRestImageAnnotationProxyV8.getAnnotationDetails() --> Transaction Id [{}] returned [{}] image annotation details.", transactionId, result == null ? "null" : "not null");
		return result;
	}
	
	public ImageAnnotation storeImageAnnotationDetails(AbstractImagingURN imagingUrn,
			String annotationDetails, String annotationVersion, ImageAnnotationSource annotationSource)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestImageAnnotationProxyV8.storeImageAnnotationDetails() --> Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		setDataSourceMethodAndVersion("storeImageAnnotationDetails");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{imagingUrn}", imagingUrn.toString());
		urlParameterKeyValues.put("{version}", annotationVersion);
		urlParameterKeyValues.put("{source}", FederationRestTranslator.translate(annotationSource).name());
		String url = getWebResourceUrl(FederationImageAnnotationRestUri.storeImageAnnotationPath, urlParameterKeyValues);
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		
		FederationImageAnnotationType imageAnnotation = 
			postClient.executeRequest(FederationImageAnnotationType.class, annotationDetails);

        getLogger().info("FederationRestImageAnnotationProxyV8.storeImageAnnotationDetails() --> Transaction Id [{}] returned [{}] image annotation webservice object.", transactionId, imageAnnotation == null ? "null" : "not null");
		ImageAnnotation result = null;
		try
		{
			result = FederationRestTranslator.translate(imageAnnotation);
		}
		catch(URNFormatException urnfX)
		{
			String msg = "FederationRestVistaRadProxyV4.storeImageAnnotationDetails() --> Encountered URNFormatException while storing image annotation details: " + urnfX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, urnfX);
		}

        getLogger().info("FederationRestImageAnnotationProxyV8.storeImageAnnotationDetails() --> Transaction Id [{}] returned [{}] image annotation.", transactionId, result == null ? "null" : "not null");
		return result;
	}
}
