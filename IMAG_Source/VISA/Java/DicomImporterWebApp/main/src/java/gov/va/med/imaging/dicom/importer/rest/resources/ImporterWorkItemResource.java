package gov.va.med.imaging.dicom.importer.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.CreateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetAndTransitionImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetWorkItemListCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetWorkItemModalitiesCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetWorkItemProceduresCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetWorkItemSourcesCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.ReadDicomReportTextCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.UpdateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.UpdateServiceCommand;
import gov.va.med.imaging.dicom.importer.commands.study.GetOriginIndexListCommand;
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

@Path("importerWorkItem")
public class ImporterWorkItemResource extends BaseImporterResource 
{

    @GET 
    @Path("getAndTransitionWorkItem")
    @Produces("application/xml")
    public String getAndTransitionImporterWorkItem(
    		@QueryParam("workItemId") int workItemId,
    		@QueryParam("expectedStatus") String expectedStatus,
    		@QueryParam("newStatus") String newStatus,
    		@QueryParam("updatingUser") String updatingUser,
    		@QueryParam("updatingApplication") String updatingApplication) 
    throws MethodException, ConnectionException
    {
    	GetAndTransitionImporterWorkItemCommand command = new GetAndTransitionImporterWorkItemCommand(workItemId, expectedStatus, newStatus, updatingUser, updatingApplication, "1.0");
    	return command.execute();
    }
    
    @GET 
    @Path("readDicomImageText")
    @Produces("application/text")
    public String readDicomImageText(
    		@QueryParam("siteId") String siteId,
    		@QueryParam("workItemId") int workItemId,
    		@QueryParam("updatingUser") String updatingUser)
    throws MethodException, ConnectionException
    {
    	ReadDicomReportTextCommand command = new ReadDicomReportTextCommand(siteId, workItemId, updatingUser, "1.0");
    	return command.execute();
    }

    @GET 
    @Path("updateService")
    @Produces("application/text")
    public String updateService(
    		@QueryParam("service") String service,
    		@QueryParam("modality") String modality,
    		@QueryParam("procedure") String procedure,
    		@QueryParam("newService") String newService) 
    throws MethodException, ConnectionException
    {
    	UpdateServiceCommand command = new UpdateServiceCommand(service, modality, procedure, newService, "1.0");
    	return command.execute();
    }

    @POST 
    @Path("getWorkItemList")
    @Produces("application/xml")
    public String getWorkItemList(InputStream importerWorkItemFilterStream) 
    throws MethodException, ConnectionException
    {
    	String importerWorkItemFilterString = readInputStreamAsString(importerWorkItemFilterStream);
    	GetWorkItemListCommand command = new GetWorkItemListCommand(importerWorkItemFilterString, "1.0");
    	return command.execute();
    }    
    
    @GET 
    @Path("getWorkItemSources")
    @Produces("application/xml")
    public String getWorkItemSources()
    throws MethodException, ConnectionException
    {
    	GetWorkItemSourcesCommand command = new GetWorkItemSourcesCommand("1.0");
    	return command.execute();
    }

    @GET 
    @Path("getWorkItemModalities")
    @Produces("application/xml")
    public String getWorkItemModalities()
    throws MethodException, ConnectionException
    {
    	GetWorkItemModalitiesCommand command = new GetWorkItemModalitiesCommand("1.0");
    	return command.execute();
    }

    @GET 
    @Path("getWorkItemProcedures")
    @Produces("application/xml")
    public String getWorkItemProcedures()
    throws MethodException, ConnectionException
    {
    	GetWorkItemProceduresCommand command = new GetWorkItemProceduresCommand("1.0");
    	return command.execute();
    }
    
    @POST 
    @Path("createImporterWorkItem")
    @Produces("application/xml")
    public String createImporterWorkItem(InputStream importerWorkItemStream) 
    throws MethodException, ConnectionException
    {
    	String importerWorkItemString = readInputStreamAsString(importerWorkItemStream);
    	CreateImporterWorkItemCommand command = new CreateImporterWorkItemCommand(importerWorkItemString, "1.0");
    	return command.execute();
    }
    
    @POST 
    @Path("updateImporterWorkItem")
    @Produces("application/xml")
    public String updateImporterWorkItem(
    		InputStream importerWorkItemStream,
    		@QueryParam("workItemId") int workItemId,
    		@QueryParam("expectedStatus") String expectedStatus,
    		@QueryParam("newStatus") String newStatus,
    		@QueryParam("updatingUser") String updatingUser,
    		@QueryParam("updatingApplication") String updatingApplication) 
    throws MethodException, ConnectionException
    {
    	String importerWorkItemString = readInputStreamAsString(importerWorkItemStream);
    	UpdateImporterWorkItemCommand command = new UpdateImporterWorkItemCommand(workItemId, expectedStatus, newStatus, importerWorkItemString, updatingUser, updatingApplication, "1.0");
    	return command.execute();
    }
    
}