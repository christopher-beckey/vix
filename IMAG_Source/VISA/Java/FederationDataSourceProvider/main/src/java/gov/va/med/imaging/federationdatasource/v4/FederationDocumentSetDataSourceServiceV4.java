/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 23, 2010
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
package gov.va.med.imaging.federationdatasource.v4;

import java.io.IOException;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DocumentSetDataSourceSpi;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.federation.proxy.v4.FederationRestDocumentSetProxyV4;
import gov.va.med.imaging.federationdatasource.AbstractFederationDocumentSetDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;

/**
 * Version 4 of this interface actually calls the remote VIX with a DocumentSet datasource rather than calling
 * with the StudyGraph SPI 
 * 
 * @author vhaiswwerfej
 *
 */
public class FederationDocumentSetDataSourceServiceV4
extends AbstractFederationDocumentSetDataSourceService 
implements DocumentSetDataSourceSpi 
{
	private final static String DATASOURCE_VERSION = "4";
	private FederationRestDocumentSetProxyV4 proxy = null;
	public final static String SUPPORTED_PROTOCOL = "vftp";
	
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationDocumentSetDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
	}
	
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DocumentSetDataSourceSpi#getPatientDocumentSets(java.lang.String, gov.va.med.imaging.exchange.business.DocumentFilter)
	 */
	@Override
	public DocumentSetResult getPatientDocumentSets(RoutingToken globalRoutingToken, DocumentFilter filter) 
	throws MethodException, ConnectionException 
	{
        getLogger().info("getPatientDocumentSets for patient ({}), TransactionContext ({}).", filter.getPatientId(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			getLogger().error("Error getting patient document sets", ioX);
			throw new FederationConnectionException(ioX);
		}					
		if(filter != null)
		{
			if(filter.isStudyIenSpecified())
			{
                getLogger().info("Filtering study by study Id [{}]", filter.getStudyId());
			}
		}
		DocumentSetResult documentSetResult = 
			getProxy().getDocumentSets(filter, globalRoutingToken);
        getLogger().info("getPatientDocumentSets got [{}] document sets from site [{}]", documentSetResult == null ? "0" : "" + documentSetResult.getArtifactSize(), getSite().getSiteNumber());
		return documentSetResult;					
	}
	
	protected FederationRestDocumentSetProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestDocumentSetProxyV4(proxyServices, 
					FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
	
	@Override
	public boolean isVersionCompatible() 
	throws SecurityException 
	{
		if(getFederationProxyServices() == null)
			return false;		
		try
		{
            getLogger().debug("Found FederationProxyServices, looking for '{}' service type at site [{}].", ProxyServiceType.metadata, getSite().getSiteNumber());
			getFederationProxyServices().getProxyService(ProxyServiceType.metadata);
            getLogger().debug("Found service type '{}' at site [{}], returning true for version compatible.", ProxyServiceType.metadata, getSite().getSiteNumber());
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("Cannot find proxy service type '{}' at site [{}]", ProxyServiceType.metadata, getSite().getSiteNumber());
			return false;
		}
	}
}
