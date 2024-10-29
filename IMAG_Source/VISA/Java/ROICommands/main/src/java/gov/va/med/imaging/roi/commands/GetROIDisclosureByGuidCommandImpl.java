/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 3, 2012
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
package gov.va.med.imaging.roi.commands;

import java.io.IOException;
import java.io.InputStream;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.channels.CompositeIOException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.roi.cache.ROIDisclosureCache;
import gov.va.med.imaging.router.commands.AbstractImagingCommandImpl;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public class GetROIDisclosureByGuidCommandImpl
extends AbstractImagingCommandImpl<InputStream>
{
	private static final long serialVersionUID = -2025499413759927221L;
	
	private final GUID guid;
	private final PatientIdentifier patientIdentifier;
	
	public GetROIDisclosureByGuidCommandImpl(PatientIdentifier patientIdentifier, String guid)
	{
		super();
		this.guid = new GUID(guid);
		this.patientIdentifier = patientIdentifier;
	}

	public GetROIDisclosureByGuidCommandImpl(PatientIdentifier patientIdentifier, GUID guid)
	{
		super();
		this.guid = guid;
		this.patientIdentifier = patientIdentifier;
	}
	
	public GUID getGuid()
	{
		return guid;
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	@Override
	public InputStream callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(getLocalRealmRadiologyRoutingToken().toRoutingTokenString());
		transactionContext.addDebugInformation("Retrieving ROI disclosure for GUID '" + getGuid().toLongString() + "'.");

        getLogger().info("getROIDisclosure - Transaction ID [{}] for GUID [{}].", transactionContext.getTransactionId(), getGuid().toString());

		try
		{
			ROIDisclosureCache disclosureCache = ROIDisclosureCache.getInstance(getCommandContext(), 
					getPatientIdentifier(), getGuid());
			InputStream cacheStream = disclosureCache.getInputStreamItemFromCache();
			//InputStream cacheStream =
			//		ROICacheFunctions.streamROIDisclosureFromCache(getCommandContext(), getStudyUrn(), getGuid());
			if(cacheStream != null)
			{
				transactionContext.setItemCached(Boolean.TRUE);
                getLogger().info("ROI Disclosure guid '{}' for patient '{}' found in the cache and returned stream.", getGuid(), getPatientIdentifier());

				return cacheStream;
				// new ImageMetadata(imageUrn, response.imageFormat, null, response.bytesReturnedFromDataSource, response.bytesReturnedFromDataSource);
			}			
		}
		catch(CompositeIOException cioX) 
		{
			// if we know that no bytes have been written then we we can continue
			// otherwise we have to stop here and throw an error 
			if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
			{
                getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
			}
			else
			{
				// exception occurred, we can't continue because the image may be partially written
				getLogger().error(cioX);
				throw new MethodException(
					"IO Exception when reading from cache, cannot continue because " + cioX.getBytesWritten() + 
					" bytes were known to have been written, continuing could result in corrupted image. " +
					"Caused by : [" + cioX.getMessage() +
					"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext()"
				);
			}
		}
		catch(IOException ioX)
		{
			// exception occurred, we can't continue because the image may be partially written
			getLogger().error(ioX);
			throw new MethodException(
				"IO Exception when reading from cache, cannot continue because some bytes may be written, " + 
				"continuing could result in corrupted image. " +
				"Caused by : [" + ioX.getMessage() +
				"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext()"
			);
		}
        getLogger().info("Did not get ROI disclosure guid [{}] from cache", getGuid());
		throw new ImageNotFoundException("Cannot find ROI Disclosure [" + getGuid() + "] in cache, might have been purged from cache.");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return getGuid().toLongString();
	}

}
