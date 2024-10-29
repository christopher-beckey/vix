/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 1, 2009
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
package gov.va.med.imaging.clinicaldisplay.webservices;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.ImagingClinicalDisplayContext;
import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.webservices.common.WebservicesCommon;

import java.rmi.RemoteException;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayWebservices 
{
	
	protected abstract String getWepAppName();
	
	private final static Logger logger = Logger.getLogger(AbstractClinicalDisplayWebservices.class);
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	public String getImageDevFields(String imageId, String flags,
			String transactionId)
	throws RemoteException 
	{
		long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay getImageDevFields transaction({})", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(imageId, SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageDevFields");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(urn.toString());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			String response = rtr.getImageDevFields(urn, flags);
            logger.info("complete ClinicalDisplay getImageDevFields transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "'" + imageId + "' is not a valid image identifier (ImageURN).";
			logger.info(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", e);
        } 
		catch(URNFormatException iurnfX)
		{
            logger.info("FAIlED getImageDevFields transaction ({}), unable to translate image Id", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            logger.info("FAILED getImageDevFields method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, infX);
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image dev fields", infX);
		}
		catch(ConnectionException ioX)
		{
            logger.info("FAILED getImageDevFields method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, ioX);
			transactionContext.setErrorMessage(ioX.getMessage());
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image dev fields", ioX);
		}
		catch(MethodException mX)
		{
            logger.info("FAILED getImageDevFields method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve image dev fields", mX);
		}
		catch(Exception ex)
		{
            getLogger().error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}
	
	public String getImageInformation(String imageId, String transactionId) 
	throws RemoteException 
	{
		long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay getImageInformation transaction({})", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(imageId, SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageInformation");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(urn.toString());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			String response = rtr.getImageInformation(urn);
            logger.info("complete ClinicalDisplay getImageInformation transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "'" + imageId + "' is not a valid image identifier (ImageURN).";
			logger.info(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", e);
        } 
		catch(URNFormatException iurnfX)
		{
            logger.info("FAIlED getImageInformation transaction ({}), unable to translate image Id", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            logger.info("FAILED getImageInformation method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, infX);
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException ioX)
		{
            logger.info("FAILED getImageInformation method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, ioX);
			transactionContext.setErrorMessage(ioX.getMessage());
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image information", ioX);
		}
		catch(MethodException mX)
		{
            logger.info("FAILED getImageInformation method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve image information", mX);
		}
		catch(Exception ex)
		{
            getLogger().error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}
	
	public String getImageSystemGlobalNode(String imageId, String transactionId)
	throws RemoteException 
	{
		long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay getImageSystemGlobalNode transaction({})", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(imageId, SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageSystemGlobalNode");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(urn.toString());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			String response = rtr.getImageSystemGlobalNode(urn);
            logger.info("complete ClinicalDisplay getImageSystemGlobalNode transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "'" + imageId + "' is not a valid image identifier (ImageURN).";
			logger.info(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", e);
        } 
		catch(URNFormatException iurnfX)
		{
            logger.info("FAIlED getImageSystemGlobalNode transaction ({}), unable to translate image Id", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            logger.info("FAILED getImageSystemGlobalNode method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, infX);
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image global node", infX);
		}
		catch(ConnectionException ioX)
		{
            logger.info("FAILED getImageSystemGlobalNode method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, ioX);
			transactionContext.setErrorMessage(ioX.getMessage());
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image global node", ioX);
		}
		catch(MethodException mX)
		{
            logger.info("FAILED getImageSystemGlobalNode method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve image global node", mX);
		}
		catch(Exception ex)
		{
            getLogger().error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}
	
	public String getStudyReport(String studyId, String transactionId)
	throws RemoteException
	{
		long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay getStudyReport transaction({})", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyURN studyUrn = null;
		String response = null;
		try
		{
			URN urn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP);
			if(urn instanceof StudyURN)
			{
				studyUrn = (StudyURN)urn;
			}
			else if(urn instanceof ImageURN)
			{
				ImageURN imageUrn = (ImageURN)urn;
				studyUrn = imageUrn.getParentStudyURN();
			}
			
			// Fortify change: check for null first
			// OLD: transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setPatientID(studyUrn != null ? studyUrn.getPatientId() : "");
			transactionContext.setRequestType(getWepAppName() + " getStudyReport");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(studyId);
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			Study study = rtr.getPatientStudy(studyUrn);
			if(study != null)
				response = study.getRadiologyReport();
            logger.info("complete ClinicalDisplay getStudyReport transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}		
		catch(URNFormatException iurnfX)
		{
            logger.info("FAIlED getStudyReport transaction ({}), unable to translate image Id", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate image Id", iurnfX);
		}
		catch(ConnectionException ioX)
		{
            logger.info("FAILED getStudyReport method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, ioX);
			transactionContext.setErrorMessage(ioX.getMessage());
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve image global node", ioX);
		}
		catch(MethodException mX)
		{
            logger.info("FAILED getStudyReport method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve image global node", mX);
		}
		catch(Exception ex)
		{
            getLogger().error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}
	
	
	protected ClinicalDisplayWebAppConfiguration getClinicalDisplayConfiguration()
	{
		return ClinicalDisplayWebAppConfiguration.getConfiguration();
	}	
	
	protected void handleMethodException(MethodException mX)
	throws RemoteException  
	{
		try
		{
			WebservicesCommon.throwSecurityCredentialsExceptionFromMethodException(mX);
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			TransactionContextFactory.get().setExceptionClassName(sceX.getClass().getSimpleName());
			throw new RemoteException(sceX.getMessage());
		}
	}
}
