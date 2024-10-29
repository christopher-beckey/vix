package gov.va.med.imaging.dicom.importer.rest.exceptions;


import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

public class RestExceptionMapper<E extends Throwable> implements ExceptionMapper<E>
{
	@Override
    public Response toResponse(E ex) 
    {
		Throwable relevantException = getRelevantException(ex);
		String stackTrace = getStackTrace(relevantException);
		
    	ResponseBuilder response = Response.status(Status.INTERNAL_SERVER_ERROR);
    	response.entity(stackTrace);
    	response.header("xxx-error-code", getErrorCode(relevantException));
    	response.header("xxx-error-message", relevantException.getMessage());
    	response.type("text/plain");
    	return response.build();
    }
    
    protected Throwable getRelevantException(E e)
    {
    	return e;
    }
    
	/**
	 * Get the appropriate error code based on the exception type. Default to 500, but can
	 * be overridden in subclasses
	 *  
	 * @param relevantException
	 * @return
	 */
	protected int getErrorCode(Throwable relevantException)
	{
		return 500;
	}

    protected String getStackTrace(Throwable aThrowable) {
        Writer result = new StringWriter();
        PrintWriter printWriter = new PrintWriter(result);
        aThrowable.printStackTrace(printWriter);
        return result.toString();
      }

}