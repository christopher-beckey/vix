/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2009
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.dx.datasource;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.DocumentURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.DocumentDataSourceSpi;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.dx.datasource.configuration.DxSiteConfiguration;
import gov.va.med.imaging.dx.proxy.DxDataSourceProxy;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import java.net.MalformedURLException;
import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class DxDocumentDataSourceService
extends AbstractVersionableDataSource
implements DocumentDataSourceSpi
{
	private final static Logger LOGGER = Logger.getLogger(DxDocumentDataSourceService.class);
	
	public final static String SUPPORTED_PROTOCOL = "dx";

    /**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public DxDocumentDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	{
		super(resolvedArtifactSource, protocol);
	}

	@Override
	protected DxDataSourceConfiguration getConfiguration()
	{
		return (DxDataSourceConfiguration)super.getConfiguration();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DocumentDataSource#getDocument(gov.va.med.imaging.DocumentURN)
	 */
	@Override
	public ImageStreamResponse getDocument(DocumentURN documentUrn)
	throws MethodException, ConnectionException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        LOGGER.info("DxDocumentDataSourceService.getDocument('{}') made by {}", documentUrn.toString(), transactionContext.getDisplayIdentity());
		// cast it to a GAI so it doesn't get stuck in an infinite loop calling itself
		GlobalArtifactIdentifier gai = (GlobalArtifactIdentifier)documentUrn;		
		return getDocument(gai);
	}

	/**
	 * While the homeCommunityId and repositoryUniqueId may be used to find the destinations server,
	 * this should have been done previous to this call by the core components.  The homeCommunityId and 
	 * repositoryUniqueId are used here only to form the Dx retrieve request.
	 */
	@Override
	public ImageStreamResponse getDocument(
			GlobalArtifactIdentifier gai)
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setDataSourceMethod("getDocument");
		transactionContext.setDataSourceVersion("1");
        LOGGER.info("DxDocumentDataSourceService.getDocument('{}:{}:{}') made by {}", gai.getHomeCommunityId(), gai.getRepositoryUniqueId(), gai.getDocumentUniqueId(), transactionContext.getDisplayIdentity());

		ResolvedArtifactSource fixedUpResolvedArtifactSource = null;
		if(getConfiguration() != null)
		{
			DxSiteConfiguration siteConfiguration = getConfiguration().findSiteConfiguration(getResolvedArtifactSource());
			
			try
			{
				fixedUpResolvedArtifactSource = getConfiguration().fixupURLPaths( getResolvedArtifactSource(), siteConfiguration );
			}
			catch (MethodException x)
			{
				String message = 
					"DxDocumentDataSourceService.getDocument() --> Unable to fix up URL paths for resolved artifact source [" + getResolvedArtifactSource().toString() + 
					"] using configuration [" + siteConfiguration.toString() + "]: " + x.getMessage();
				LOGGER.error(message);
				throw new MethodException(message, x);
			}		
		}		
		else
		{
			fixedUpResolvedArtifactSource = getResolvedArtifactSource();
			LOGGER.warn("DxDocumentDataSourceService.getDocument() --> No DX Data Source Configuration is set, no fix-up of application path or file is being applied.");
		}
		
		DxDataSourceProxy proxy = new DxDataSourceProxy(fixedUpResolvedArtifactSource, getConfiguration());
		ImageStreamResponse response = proxy.getPatientDocument(gai.getHomeCommunityId(), 
				gai.getRepositoryUniqueId(), gai.getDocumentUniqueId());

        LOGGER.info("DxDocumentDataSourceService.getDocument() --> Done. Returning {}", response == null ? "null" : "response");
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DocumentDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		return true;
	}
}
