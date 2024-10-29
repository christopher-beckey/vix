package gov.va.med.imaging.dicom.importer.rest.exceptions;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

@Provider
public class ImporterConnectionExceptionMapper extends RestExceptionMapper<ConnectionException> 
{
    protected Throwable getRelevantException(ConnectionException ce)
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
}