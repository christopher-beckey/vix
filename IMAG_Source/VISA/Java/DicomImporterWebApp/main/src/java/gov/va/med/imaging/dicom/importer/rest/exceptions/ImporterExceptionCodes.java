package gov.va.med.imaging.dicom.importer.rest.exceptions;

import gov.va.med.imaging.exchange.business.dicom.importer.exceptions.OutsideLocationConfigurationException;

public class ImporterExceptionCodes 
{
	/**
	* Error code for a generic MethodException
	*/
	public final static int internalServerErrorCode = 500;
	
	/**
	* Error code for a WorkItemNotFoundException
	*/
	public final static int workItemNotFoundErrorCode = 1000;
	
	/**
	* Error code for an InvalidSecurityCredentialsException
	*/
	public final static int invalidWorkItemStatusErrorCode = 1001;
	
	/** 
	 * Error code for an OutsideLocationConfigurationException
	 */
	public final static int outsideLocationConfigurationErrorCode = 2000;
	
}
