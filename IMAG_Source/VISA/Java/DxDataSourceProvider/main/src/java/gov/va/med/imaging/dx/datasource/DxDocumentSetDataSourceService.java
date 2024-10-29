/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2017
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

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.DocumentSetDataSourceSpi;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.dx.datasource.configuration.DxSiteConfiguration;
import gov.va.med.imaging.dx.proxy.DxDataSourceProxy;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import java.net.MalformedURLException;
import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class DxDocumentSetDataSourceService
extends AbstractVersionableDataSource
implements DocumentSetDataSourceSpi 
{
	private final static Logger LOGGER = Logger.getLogger(DxDocumentDataSourceService.class);
	
	public final static String SUPPORTED_PROTOCOL = "dx";

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public DxDocumentSetDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	{
		super(resolvedArtifactSource, protocol);
	}

	@Override
	protected DxDataSourceConfiguration getConfiguration()
	{
		return (DxDataSourceConfiguration)super.getConfiguration();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DocumentSetDataSource#getPatientDocumentSets(java.lang.String, gov.va.med.imaging.exchange.business.DocumentFilter)
	 */
	@Override
	public DocumentSetResult getPatientDocumentSets(RoutingToken globalRoutingToken, DocumentFilter filter) 
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setDataSourceVersion("1");
		transactionContext.setDataSourceMethod("getDocumentSets");
        LOGGER.info("DxDocumentSetDataSourceService.getPatientDocumentSets('{}') made by {}", filter.getPatientId(), transactionContext.getDisplayIdentity());

		ResolvedArtifactSource fixedUpResolvedArtifactSource = null;
		if(getConfiguration() != null)
		{
			DxSiteConfiguration siteConfiguration = getConfiguration().findSiteConfiguration(getResolvedArtifactSource());
			try
			{
				fixedUpResolvedArtifactSource = getConfiguration().fixupURLPaths( getResolvedArtifactSource(), siteConfiguration );
                LOGGER.info("DxDocumentSetDataSourceService.getPatientDocumentSets('{}') --> Using configuration - fixedUpResolvedArtifactSource [{}]", filter.getPatientId(), fixedUpResolvedArtifactSource);
			}
			catch (MethodException x)
			{
				String message = 
					"DxDocumentSetDataSourceService.getPatientDocumentSets(" + filter.getPatientId() + "') --> Unable to fix up URL paths for resolved artifact source [" + getResolvedArtifactSource().toString() + 
					"] using configuration [" + siteConfiguration.toString() + "]";
				LOGGER.error(message);
				throw new MethodException(message, x);
			}
		}
		else
		{
			fixedUpResolvedArtifactSource = getResolvedArtifactSource();
            LOGGER.debug("DxDocumentSetDataSourceService.getPatientDocumentSets({}') --> configuration - fixedUpResolvedArtifactSource [{}]", filter.getPatientId(), fixedUpResolvedArtifactSource);
		}	
		
		DocumentSetResult result = null;
		try {
			DxDataSourceProxy proxy = new DxDataSourceProxy(fixedUpResolvedArtifactSource, getConfiguration());
			result = proxy.getPatientDocumentSets(filter);
		} 
		catch (ConnectionException e)
		{
			String msg = "DxDocumentSetDataSourceService.getPatientDocumentSets(" + filter.getPatientId() + "') --> Encountered ConnectionException: " + e.getMessage();
			LOGGER.debug(msg);
			throw new MethodException(msg, e);
		}
		catch (InterruptedException e)
		{
			String msg = "DxDocumentSetDataSourceService.getPatientDocumentSets(" + filter.getPatientId() + "') --> Encountered InterruptedException: " + e.getMessage();
			LOGGER.debug(msg);
			throw new MethodException(msg, e);
		}

		return result;
		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DocumentSetDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		return true;
	}	
}
