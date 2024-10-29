/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 1, 2016
  Developer:  vacotittoc
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
package gov.va.med.imaging.mix.webservices.commands.v1;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.apache.commons.io.FilenameUtils;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.DASCacheIdType;

/**
 * @author VHAISATITTOC
 *
 */
public class MixGetDASCachedDocId
{	
	private String repoId;
	private String docId;
	
	public MixGetDASCachedDocId(String repoId, String docId)
	{
		this.repoId = repoId;
		this.docId = docId;
	}

//	public DASCacheIdType getIDFromLocalCache()
	public String getIDFromLocalCache()
		throws MethodException {
		
		// check input
		if ((repoId==null) || repoId.isEmpty() || (docId==null) || docId.isEmpty())
			throw new MethodException("invalid repoId and/or docId parameter(s)!");

//		DASCacheIdType dasCacheIdType = new DASCacheIdType();
		String longDocId="";
		try {
			longDocId = getEncryptedDocumentId(repoId, docId);
//			dasCacheIdType.setLongDocId(longDocId);
		}
		catch (Exception e) {
			throw new MethodException("Local Cache Read Error:" + e.getMessage());
		}
						
//		return dasCacheIdType;
		return longDocId;
	}
	
    private static String getDasFolder(String repoId) {
		synchronized("CreateDasFolder")
		{
	        String path = System.getenv("vixcache");
	        if (path.length() < 4){
	        	return null;
	        }
	        
	        if (!(path.endsWith("/") || path.endsWith("\\"))){
	        	path += "/";
	        }
	        
	    	path += "dod-metadata-region/das/" + repoId;
	    	
	    	// Fortify change: normalized path
			File folder = new File(FilenameUtils.normalize(path));
			
			if (!folder.exists())
			{
				folder.mkdirs();
			}   	
	
			return path;
		}
    }

	
	/**
	 * Cache a list of document instances into the appropriate cache.
	 * 
	 * @param documentSetResult
	 * @return Returns true if all documents in the list were cached, if one or more document was not cached, then false is returned
	 * @throws IOException 
	 */
	private static String getEncryptedDocumentId(String repositoryId, String documentId) 
	throws IOException
	{
		// Fortify change: added try-with-resources and normalized paths
		
		String path = getDasFolder(repositoryId);
		
		if (path == null)
		{
			throw new IOException("Unable to find DAS Cache folder");
		}

		String encDocId = null;

		synchronized("CacheDasDocument")
		{
			File cacheFile = new File(FilenameUtils.normalize(path), documentId);
			
			if (!cacheFile.exists())
			{
				throw new IOException("Unable to find DAS Cache document: " + documentId);
			}
			
			try ( FileReader inReader = new FileReader(FilenameUtils.normalize(path + "/" + documentId)); 
				  BufferedReader br = new BufferedReader(inReader) )
			{
				encDocId = br.readLine();
			}
			return encDocId;
		}
	
	}

}
