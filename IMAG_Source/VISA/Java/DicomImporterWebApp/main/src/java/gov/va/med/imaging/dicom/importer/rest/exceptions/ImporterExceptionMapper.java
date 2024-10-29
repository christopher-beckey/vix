package gov.va.med.imaging.dicom.importer.rest.exceptions;


import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

@Provider
public class ImporterExceptionMapper extends RestExceptionMapper<Exception>
{
}