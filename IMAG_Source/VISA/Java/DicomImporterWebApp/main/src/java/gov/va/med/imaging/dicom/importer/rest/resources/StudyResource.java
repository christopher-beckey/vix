package gov.va.med.imaging.dicom.importer.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.CreateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.study.GetImportStatusCommand;
import gov.va.med.imaging.dicom.importer.commands.study.GetOriginIndexListCommand;
import gov.va.med.imaging.dicom.importer.commands.study.GetUIDActionListCommand;
import gov.va.med.imaging.exchange.business.dicom.importer.Order;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

import java.io.InputStream;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

// The Java class will be hosted at the URI path "/greeting"

@Path("/study")
public class StudyResource extends BaseImporterResource 
{

    // and implement the following GET method 
    @POST 
    @Path("/importStatus")
    @Produces("application/xml")
    public String getImportStatus(InputStream studyXml) 
    throws MethodException, ConnectionException 
    {

    	String studyAsString = readInputStreamAsString(studyXml);
    	GetImportStatusCommand command = new GetImportStatusCommand(studyAsString, "1.0");
    	return command.execute();

    }
    
    // and implement the following GET method 
    @GET 
    @Path("/getOriginIndexList")
    @Produces("application/xml")
    public String getOriginIndexList() 
    throws MethodException, ConnectionException 
    {
    	GetOriginIndexListCommand command = new GetOriginIndexListCommand("1.0");
    	return command.execute();
    }
    
    // and implement the following GET method 
    @GET 
    @Path("/getUIDActionList")
    @Produces("application/xml")
    public String getUIDActionList() 
    throws MethodException, ConnectionException 
    {
    	GetUIDActionListCommand command = new GetUIDActionListCommand("1.0");
    	return command.execute();
    }

}