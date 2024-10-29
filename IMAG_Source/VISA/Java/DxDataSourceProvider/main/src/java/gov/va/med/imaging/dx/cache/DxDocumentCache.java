/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 2, 2017
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
package gov.va.med.imaging.dx.cache;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;

import javax.ws.rs.core.MediaType;

import gov.va.med.imaging.utils.FileUtilities;
import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dx.rest.proxy.DxBasicAuthRestClient;
import gov.va.med.imaging.dx.rest.proxy.DxRestGetClient;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.url.vista.StringUtils;


public class DxDocumentCache
//extends AbstractCacheDecorator
{
	private final static Logger logger = Logger.getLogger(DxDocumentCache.class);

	public static Logger getLogger()
	{
		return logger;
	}

	
	/**
	 * Cache a list of document instances into the appropriate cache.
	 * 
	 * @param documentSetResult
	 * @return Returns true if all documents in the list were cached, if one or more document was not cached, then false is returned
	 * @throws IOException 
	 */
	public static void cacheDocuments(DocumentSetResult documentSetResult) 
	throws IOException
	{
        getLogger().info("Caching [{}] documentset.", documentSetResult.getArtifacts().size());
		
		for(DocumentSet documentSet : documentSetResult.getArtifacts())
		{
            getLogger().info("Caching [{}] documents.", documentSet.size());
			for(Document document : documentSet)
			{
				GlobalArtifactIdentifier docArtifact = document.getGlobalArtifactIdentifier();
				String repoId = docArtifact.getRepositoryUniqueId();
                getLogger().info("Caching on repository ID: {}", repoId);

				String dasFolder = getDasFolder(repoId);
                getLogger().info("Das Folder for document caching: {}", dasFolder);

				if (dasFolder == null)
				{
					throw new IOException("Caching document error: Unable to create DAS cache folder.");
				}
				
				String docId = docArtifact.getDocumentUniqueId();
				
				String encDocId = getEncryptedDocumentId(document.getDescription());

				//Remove the encryption string from the description
				String description = getDescription(document.getDescription());
				document.setDescription(description);

                getLogger().info("Das document Id to cache: {} encrypted: {}", docId, encDocId);

				try {
					createCacheDocument(dasFolder, docId, encDocId);
				} catch (IOException e) {
					throw new IOException("Caching document error: " + e.getMessage());
				}
			}
		}
		
	}
	
	private static String getDescription(String description) {
		return StringUtils.Piece(description, " [DX: ", 1);
	}

	private static String getEncryptedDocumentId(String description) 
	{
		String encDocId = StringUtils.Piece(description, " [DX: ", 2);
		encDocId = StringUtils.Piece(encDocId, "]", 1);
		return encDocId;
	}


	private static void createCacheDocument(String dasFolder, String docId, String complexUrl) 
	throws IOException 
	{
		synchronized("CacheDasDocument")
		{
			try
			{
				PrintWriter writer = new PrintWriter(new FileOutputStream(FileUtilities.getFile(dasFolder + "/" + docId), false));
				writer.println(complexUrl);
				writer.close();
			} 
			catch (IOException e)
			{
				throw new IOException("Unable to create create DAS cache document. Error: " + e.getMessage());
			}
		}
	}
		

    public static String getDasFolder(String repoId) {
		synchronized("CreateDasFolder")
		{
	        String path= System.getenv("vixcache");
	        if (path.length() < 4){
	        	return null;
	        }
	        
	        if (!(path.endsWith("/") || path.endsWith("\\"))){
	        	path += "/";
	        }
	        
	    	path += "dod-metadata-region/das/" + repoId;

	        try {
				File folder = FileUtilities.getFile(path);
				if (!folder.exists()) {
					folder.mkdirs();
				}
			} catch (Exception e) {
	        	// Ignore
			}
	
			return path;
		}
    }

    public static String getComplexURL( 
    		String documentHostIp, 
    		String repositoryId,
    		String docId,
    		String keyStoreUrl, 
    		String keyStorePassword,
    		String alexdelargePassword)
    {
    	String url = "https://" + documentHostIp + "/MIXWebApp/restservices/mix/DasCachedDocumentId?repoId=" + repositoryId + "&docId=" + docId;
        getLogger().debug("Url to get ComplexURL: {}", url);
    	DxBasicAuthRestClient getClient = new DxBasicAuthRestClient(url, alexdelargePassword);
		return getClient.getDataFromServer(keyStoreUrl, keyStorePassword);
    }
	
	/**
	 * Cache a list of document instances into the appropriate cache.
	 * 
	 * @param documentSetResult
	 * @return Returns true if all documents in the list were cached, if one or more document was not cached, then false is returned
	 * @throws IOException 
	 * @throws MethodException 
	 * @throws ConnectionException 
	 */
	public static String getEncryptedDocumentId(
			String repositoryId, String documentId, 
			String localHostIp, 
			String keyStoreUrl, String keyStorePassword,
			String alexdelargePassword) 
	throws IOException, ConnectionException, MethodException
	{
		String[] hostIpParse = documentId.split("-");
		String documentHostIp = hostIpParse[hostIpParse.length-1];   //StringUtils.Piece(documentId, "-", 2);
		String path = null;

        getLogger().debug("Local Host:{}", localHostIp);
        getLogger().debug("Document Host:{}", documentHostIp);

		if (localHostIp.equals(documentHostIp))
		{
			path = getDasFolder(repositoryId);
            getLogger().debug("Vix Local Cache path:{}", path);

			if (path == null)
			{
				throw new IOException("Unable to find DAS Cache folder");
			}

		}
		else
		{
			String complexUrl = getComplexURL(
					documentHostIp, repositoryId, documentId, 
					keyStoreUrl, keyStorePassword, alexdelargePassword);
            getLogger().debug("ComplexUrl:{}", complexUrl);
			return complexUrl;
		}

		String encDocId = null;

		synchronized("CacheDasDocument")
		{
			File cacheFile = FileUtilities.getFile(path, documentId);
			if (!cacheFile.exists())
			{
				throw new IOException("Unable to find DAS Cache document: " + documentId);
			}
			
			String cacheFilename = path + "/" + documentId;
			BufferedReader br = new BufferedReader(new FileReader(FileUtilities.getFile(cacheFilename)));
			try
			{
				encDocId = br.readLine();
			}
			finally
			{
				br.close();
			}
		
			return encDocId;
		}
	
	}
	
//	public DxDocumentCache (
//			Cache wrappedCache,
//			String metadataRegionName) 
//	{
//		if(wrappedCache == null)
//			throw new IllegalArgumentException(getClass().getSimpleName() + " was passed a null wrapped cache parameter.");
//		if(metadataRegionName == null)
//			throw new IllegalArgumentException(getClass().getSimpleName() + " was passed a null metadata region name parameter.");
//		
//		this.wrappedCache = wrappedCache;
//		this.metadataRegionName = metadataRegionName;
//		
//		logger.info("DxDocumentCache <ctor> backed with cache '" + wrappedCache.getName() + "'.");
//	}
//		
//	

	
	// =======================================================================================
	// Document Caching
	// =======================================================================================
//	@Override
//	public ImmutableInstance createDocumentContent(GlobalArtifactIdentifier gaid) 
//	throws CacheException
//	{
//		String[] groups = AbstractCacheDecorator.createExternalInstanceGroupKeys(gaid, false);
//		String instanceKey = AbstractCacheDecorator.createDocumentKey(gaid);
//		
//		Instance instance = getWrappedCache().getOrCreateInstance(
//				getMetadataRegionName(), 
//				groups, 
//				instanceKey );
//
//		return instance == null ? null : new ImmutableInstance( instance );
//	}
//	
//	@Override
//	public ImmutableInstance getDocumentContent(GlobalArtifactIdentifier gaid) 
//	throws CacheException
//	{
//		String[] groups = AbstractCacheDecorator.createExternalInstanceGroupKeys(gaid, false);
//		String instanceKey = AbstractCacheDecorator.createDocumentKey(gaid);
//		
//		Instance instance = getWrappedCache().getInstance(
//				getMetadataRegionName(), 
//				groups, 
//				instanceKey );
//		
//		return instance == null ? null : new ImmutableInstance( instance );
//	}
//
//
//	@Override
//	protected Cache getWrappedCache() {
//		return wrappedCache;
//	}
//	
//	
//	@Override
//	protected String getMetadataRegionName() {
//		return metadataRegionName;
//	}
//
//
//	@Override
//	public void createStudy(Study study) throws CacheException {
//		// NOT USED
//	}
//	
//	
//	@Override
//	public Study getStudy(GlobalArtifactIdentifier gai) throws CacheException {
//		// NOT USED
//		return null;
//	}
//	
//	@Override
//	protected String getImageRegionName() {
//		return null;
//	}
//	

}
