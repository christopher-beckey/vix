/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 12, 2011
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
package gov.va.med.imaging.dd.web.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dd.commands.DataDictionaryGetFileCommand;
import gov.va.med.imaging.dd.commands.DataDictionaryGetFilesCommand;
import gov.va.med.imaging.dd.commands.DataDictionaryGetValueCommand;
import gov.va.med.imaging.dd.commands.DataDictionaryQueryCommand;
import gov.va.med.imaging.dd.commands.DataDictionarySearchCommand;
import gov.va.med.imaging.dd.rest.types.DataDictionaryFileType;
import gov.va.med.imaging.dd.rest.types.DataDictionaryResultEntryType;
import gov.va.med.imaging.dd.rest.types.DataDictionaryResultType;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("")
public class DataDictionaryRestService
{
	
//	@GET
//	@Path("query/{file}/{fields}")
//	@Produces("application/xml")
//	public DataDictionaryResultType query(
//			@PathParam("file") String file,
//			@PathParam("fields") String fields) 
//	throws MethodException, ConnectionException
//	{
//		DataDictionaryQueryCommand command = 
//			new DataDictionaryQueryCommand(file, fields);
//		return command.execute();
//	}
	
//	@GET
//	@Path("query/{file}/{fields}/{maxResults}")
//	@Produces("application/xml")
//	public DataDictionaryResultType query(
//			@PathParam("file") String file,
//			@PathParam("fields") String fields,
//			@PathParam("maxResults") Integer maxResults) 
//	throws MethodException, ConnectionException
//	{
//		DataDictionaryQueryCommand command = 
//			new DataDictionaryQueryCommand(file, fields, maxResults);
//		return command.execute();
//	}

//	@GET
//	@Path("query/{file}/{fields}/{maxResults}/{moreParameter}")
//	@Produces("application/xml")
//	public DataDictionaryResultType query(
//			@PathParam("file") String file,
//			@PathParam("fields") String fields,
//			@PathParam("maxResults") Integer maxResults,
//			@PathParam("moreParameter") String moreParameter) 
//	throws MethodException, ConnectionException
//	{
//		DataDictionaryQueryCommand command = 
//			new DataDictionaryQueryCommand(file, fields, maxResults, moreParameter);
//		return command.execute();
//	}
	
	@GET
	@Path("file")
	@Produces("application/xml")
	public DataDictionaryFileType [] getFiles()
	throws MethodException, ConnectionException
	{
		DataDictionaryGetFilesCommand command = 
			new DataDictionaryGetFilesCommand();
		return command.execute();
	}
	
	@GET
	@Path("file/{file}")
	@Produces("application/xml")
	public DataDictionaryFileType getFile(
			@PathParam("file") String file)
	throws MethodException, ConnectionException
	{
		DataDictionaryGetFileCommand command = 
			new DataDictionaryGetFileCommand(file);
		return command.execute();
	}

	@GET
	@Path("entry/{file}")
	@Produces("application/xml")
	public DataDictionaryResultType getRecords(
			@PathParam("file") String file,
			@DefaultValue("1000") @QueryParam("maxResults") Integer maxResults,
			@DefaultValue("") @QueryParam("more") String more)
	throws MethodException, ConnectionException
	{
		String fields = "*";
		DataDictionaryQueryCommand command =
			new DataDictionaryQueryCommand(file, fields, maxResults, more);
		return command.execute();
	}
	
	@GET
	@Path("entry/{file}/{ien}")
	@Produces("application/xml")
	public DataDictionaryResultEntryType getRecord(
			@PathParam("file") String file,
			@PathParam("ien") String ien)
	throws MethodException, ConnectionException
	{
		String fields = "*";
		DataDictionaryGetValueCommand command =
			new DataDictionaryGetValueCommand(file, ien, fields);
		return command.execute();
	}

	@GET
	@Path("entry/{file}/{fieldNum}/{fieldValue}")
	@Produces("application/xml")
	public DataDictionaryResultType search(
			@PathParam("file") String file,
			@PathParam("fieldNum") String fieldNum,
			@PathParam("fieldValue") String fieldValue)
	throws MethodException, ConnectionException
	{
		DataDictionarySearchCommand command =
			new DataDictionarySearchCommand(file, "*", fieldNum, fieldValue);
		return command.execute();
	}
}
