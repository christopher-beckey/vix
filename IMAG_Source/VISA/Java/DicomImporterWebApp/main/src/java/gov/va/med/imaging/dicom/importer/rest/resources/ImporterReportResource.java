package gov.va.med.imaging.dicom.importer.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.CreateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetAndTransitionImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetWorkItemListCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.UpdateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.report.GetImporterReportCommand;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemDetails;
import gov.va.med.imaging.exchange.business.dicom.importer.Reconciliation;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

@Path("importerReport")
public class ImporterReportResource {

    @POST 
    @Path("getReport")
    @Produces("application/xml")
    public String createImporterWorkItem(InputStream reportParametersStream) 
    throws MethodException, ConnectionException
    {
    	String reportParametersString = readInputStreamAsString(reportParametersStream);
    	GetImporterReportCommand command = new GetImporterReportCommand(reportParametersString, "1.0");
    	return command.execute();
    }
    
    private String readInputStreamAsString(InputStream in) throws MethodException 
    {
    	try
    	{
			BufferedInputStream bis = new BufferedInputStream(in);
			ByteArrayOutputStream buf = new ByteArrayOutputStream();
			int result = bis.read();
			while (result != -1) {
				byte b = (byte) result;
				buf.write(b);
				result = bis.read();
			}
			return buf.toString();
		}
    	catch (IOException ioe)
    	{
    		throw new MethodException(ioe);
    	}
	}
    
}