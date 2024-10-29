/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 9, 2012
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
package gov.va.med.imaging.roi.cache;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

//import org.apache.commons.io.IOUtils;
import org.apache.commons.configuration.ConfigurationException;
import gov.va.med.logging.Logger;
import org.nibblesec.tools.SerialKiller;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.exchange.storage.cache.VASourcedCache;
import gov.va.med.imaging.exchange.storage.cache.VASourcedCacheDecorator;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.storage.cache.Cache;
import gov.va.med.imaging.storage.cache.Instance;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
//import gov.va.med.lookahead.LookAheadObjectInputStream;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIVASourcedCacheDecorator 
extends VASourcedCacheDecorator
implements ROIVASourcedCache
{
	private static ROIVASourcedCache roiVaSourcedCache = null;
	private String serialKillerConfigFilename = System.getenv("vixconfig") + "/serialkiller.config";
	private final static Logger logger = Logger.getLogger(ROIVASourcedCacheDecorator.class);
	
	public synchronized static ROIVASourcedCache getInstance(VASourcedCache vaSourcedCache)
	{
		if(roiVaSourcedCache == null)
		{
			roiVaSourcedCache = new ROIVASourcedCacheDecorator(vaSourcedCache.getWrappedCache(), 
					vaSourcedCache.getMetadataRegionName(), vaSourcedCache.getImageRegionName());
		}
		return roiVaSourcedCache;
	}
		
	private ROIVASourcedCacheDecorator(Cache wrappedCache,
			String metadataRegionName, 
			String imageRegionName)
	{
		super(wrappedCache, metadataRegionName, imageRegionName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.cache.ROIVASourcedCache#getROIRequest(gov.va.med.imaging.GUID)
	 */
	@Override
	public ROIStudyList getROIStudyList(PatientIdentifier patientIdentifier, String guid) 
	throws CacheException
	{
		String[] groups = createROIRequestGroupName(patientIdentifier);
		String groupKey = createROIRequestKey(guid);
		
		return getMetadataFromImageRegion(ROIStudyList.class, groups, groupKey);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.cache.ROIVASourcedCache#createROIRequest(gov.va.med.imaging.roi.ROIRequest)
	 */
	@Override
	public void createROIStudyList(PatientIdentifier patientIdentifier, String guid, 
			ROIStudyList roiStudyList) 
	throws CacheException
	{
		String[] groups = createROIRequestGroupName(patientIdentifier);
		String groupKey = createROIRequestKey(guid);
		
		createMetadataInImageRegion(groups, groupKey, roiStudyList);
	}
	
	protected <T> void createMetadataInImageRegion(
			String[] groups, 
			String groupKey, 
			T metadata) 
		throws CacheException
		{
			WritableByteChannel metadataWritable = null;
			ObjectOutputStream metadataOutStream = null;
			OutputStream innerStream = null;
			try
			{
				if( getWrappedCache().isEnabled().booleanValue() )
				{
					Instance metadataInstance = getWrappedCache().getOrCreateInstance(
							getImageRegionName(), 
							groups, 
							groupKey);
					if(metadataInstance != null)
					{
						metadataWritable = metadataInstance.getWritableChannel();
						innerStream = Channels.newOutputStream(metadataWritable);
						metadataOutStream = new ObjectOutputStream(innerStream);
						
						metadataOutStream.writeObject(metadata);
					}
					else
						logger.warn("Unable to write to cache and cache is enabled.  Application will continue to operate with reduced performance.");
				}
			} 
			catch (IOException e)
			{
				e.printStackTrace();
			}
			finally
			{
				try{if(metadataOutStream != null) metadataOutStream.close();}
				catch(Throwable t){}
				try{if(innerStream != null) innerStream.close();}
				catch(Throwable t){}
			}
			
			return;
		}
	
	protected <T> T getMetadataFromImageRegion(Class<T> expectedResultClass, String[] groups, String groupKey) 
	throws CacheException
	{
		T result = null;
		
		ReadableByteChannel metadataReadable = null;
		ObjectInputStream metadataInStream = null;
		try
		{
			Instance studyMetadataInstance = getWrappedCache().getInstance(
					getImageRegionName(), 
					groups, 
					groupKey);
			
			if(studyMetadataInstance != null)
			{
				metadataReadable = studyMetadataInstance.getReadableChannel();
				
				//metadataInStream = new ObjectInputStream(Channels.newInputStream(metadataReadable));
				//return expectedResultClass.cast(LookAheadObjectInputStream
				//		.deserialize(IOUtils.toByteArray(Channels.newInputStream(metadataReadable)) , expectedResultClass.getClass().getName())); 
				try
				{
					metadataInStream = new SerialKiller(Channels.newInputStream(metadataReadable),serialKillerConfigFilename);
					return expectedResultClass.cast(metadataInStream.readObject());
				}
				catch (org.apache.commons.configuration.ConfigurationException ce)
				{
					ce.printStackTrace();
				}
			}
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		} 
		catch (ClassNotFoundException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try{if(metadataInStream != null)metadataInStream.close();}
			catch(Throwable t){}
		}
		
		return result;	
	}
	
	private String[] createROIRequestGroupName(PatientIdentifier patientIdentifier)
	{
		return new String [] 
				{
				VASourcedCacheDecorator.filenameOctetEscaping.escapeIllegalCharacters("roi"),
				VASourcedCacheDecorator.filenameOctetEscaping.escapeIllegalCharacters(patientIdentifier.toString()),
				VASourcedCacheDecorator.filenameOctetEscaping.escapeIllegalCharacters("metadata") 
				};
	}
	
	private String createROIRequestKey(String guid)
	{
		return VASourcedCacheDecorator.filenameOctetEscaping.escapeIllegalCharacters(guid);
	}
	

}
