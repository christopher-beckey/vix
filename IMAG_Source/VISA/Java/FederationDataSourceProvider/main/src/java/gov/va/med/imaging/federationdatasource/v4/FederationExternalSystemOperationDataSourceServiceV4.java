/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 22, 2010
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

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.proxy.v4.FederationRestExternalSystemOperationProxyV4;
import gov.va.med.imaging.federationdatasource.AbstractFederationExternalSystemOperationDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationExternalSystemOperationDataSourceServiceV4
extends AbstractFederationExternalSystemOperationDataSourceService
{
	private final static String DATASOURCE_VERSION = "4";
	private FederationRestExternalSystemOperationProxyV4 proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationExternalSystemOperationDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
	}

	@Override
	public String getDataSourceVersion()
	{
		return DATASOURCE_VERSION;
	}

	@Override
	public boolean initiateExamPrefetchOperation(StudyURN studyUrn) 
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.initiateExamPrefetchOperation() --> For StudyURN [{}], transaction Id [{}]", studyUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalSystemOperationDataSourceServiceV4.initiateExamPrefetchOperation() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().initiateExamPrefetchOperation(studyUrn);
	}

	@Override
	public void refreshSiteServiceCache() 
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.refreshSiteServiceCache() --> Transaction Id [{}]", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalSystemOperationDataSourceServiceV4.refreshSiteServiceCache() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		getProxy().refreshSiteServiceCache();	
	}
	
	protected FederationRestExternalSystemOperationProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationExternalSystemOperationDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestExternalSystemOperationProxyV4(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

	@Override
	public void prefetchPatientStudies(RoutingToken globalRoutingToken,
			String patientIcn, StudyFilter filter, StudyLoadLevel studyLoadLevel)
			throws MethodException, ConnectionException
	{
        getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.prefetchPatientStudies() --> For patient Id [{}], StudyLoadLevel [{}], transaction identity [{}]", patientIcn, studyLoadLevel, TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalSystemOperationDataSourceServiceV4.prefetchPatientStudies() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}					
		if(filter != null)
		{
			if(filter.isStudyIenSpecified())
			{
                getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.prefetchPatientStudies() --> Filtering study by study Id [{}]", filter.getStudyId());
			}
		}
		getProxy().prefetchPatientStudies(patientIcn, filter, globalRoutingToken, studyLoadLevel);
	}

	@Override
	public void prefetchExamImage(ImageURN imageUrn, ImageFormatQualityList imageFormatQualityList,	boolean includeTextFile)
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.prefetchExamImage() --> For image URN [{}], ImageFormatQualityList [{}], transaction Id [{}]", imageUrn.toString(), imageFormatQualityList.getAcceptString(true, true), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalSystemOperationDataSourceServiceV4.prefetchExamImage() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		getProxy().prefetchExamImage(imageUrn, imageFormatQualityList, includeTextFile);
	}

	@Override
	public void prefetchGai(GlobalArtifactIdentifier gai)
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.prefetchGai() --> For GAI [{}], transaction identity [{}]", gai.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalSystemOperationDataSourceServiceV4.prefetchGai() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		getProxy().prefetchGai(gai);
	}

	@Override
	public void prefetchImage(ImageURN imageUrn,
			ImageFormatQualityList imageFormatQualityList)
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationExternalSystemOperationDataSourceServiceV4.prefetchImage() --> For image URN [{}], ImageFormatQualityList [{}], transaction identity [{}]", imageUrn.toString(), imageFormatQualityList.getAcceptString(true, true), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalSystemOperationDataSourceServiceV4.prefetchImage() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		getProxy().prefetchImage(imageUrn, imageFormatQualityList);
	}
}
