package gov.va.med.imaging.dicom.importer.rest.exceptions;

import gov.va.med.imaging.core.interfaces.exceptions.InvalidWorkItemStatusException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.WorkItemNotFoundException;
import gov.va.med.imaging.exchange.business.dicom.importer.exceptions.OutsideLocationConfigurationException;

import javax.ws.rs.ext.Provider;

@Provider
public class ImporterMethodExceptionMapper extends RestExceptionMapper<MethodException> 
{
    protected Throwable getRelevantException(MethodException ce)
    {
    	if (ce.getCause() != null)
    	{
    		return ce.getCause();
    	}
    	else
    	{
    		return ce;
    	}
    }
    
	@Override
	protected int getErrorCode(Throwable relevantException)
	{
		if(relevantException instanceof WorkItemNotFoundException)
			return ImporterExceptionCodes.workItemNotFoundErrorCode;
		
		if(relevantException instanceof InvalidWorkItemStatusException)
			return ImporterExceptionCodes.invalidWorkItemStatusErrorCode;
		
		if(relevantException instanceof OutsideLocationConfigurationException)
			return ImporterExceptionCodes.outsideLocationConfigurationErrorCode;
		
		return ImporterExceptionCodes.internalServerErrorCode;
	}

}