/**
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestStringArrayType;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.vistaUserPreference.VistaUserPreferenceContextHolder;
import gov.va.med.imaging.vistaUserPreference.commands.DeleteUserPreferenceCommand;
import gov.va.med.imaging.vistaUserPreference.commands.DeleteUserPreferenceUserEntityCommand;
import gov.va.med.imaging.vistaUserPreference.commands.GetUserPreferenceCommand;
import gov.va.med.imaging.vistaUserPreference.commands.GetUserPreferenceKeysCommand;
import gov.va.med.imaging.vistaUserPreference.commands.GetUserPreferenceKeysUserEntityCommand;
import gov.va.med.imaging.vistaUserPreference.commands.GetUserPreferenceUserEntityCommand;
import gov.va.med.imaging.vistaUserPreference.commands.PostUserPreferenceUserEntityCommand;
import gov.va.med.imaging.vistaUserPreference.commands.PostUserPreferenceCommand;
import gov.va.med.imaging.vistaUserPreference.rest.endpoints.UserPreferenceRestUri;
import gov.va.med.imaging.vistaUserPreference.rest.types.UserPreferenceKeysType;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import java.util.Locale;


/**
 * @author Budy Tjahjo
 *
 */
@Path(UserPreferenceRestUri.userPreferencePath)
public class UserPreferenceService
extends AbstractRestService
{
	@GET
	@Path(UserPreferenceRestUri.userPreferenceGetMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getUserPreference(
			@QueryParam("entity") String entity,
			@QueryParam("key") String key)
	throws MethodException, ConnectionException
	{
		RestStringArrayType lines = (RestStringArrayType) 
				new GetUserPreferenceCommand(
						getLocalSiteNumber(), 
						entity, 
						key, 
						getInterfaceVersion()).execute();

		return getUserPreferenceResponse(lines);
	}

	//For Backward compatible
	@GET
	@Path(UserPreferenceRestUri.userPreferenceGetUserEntityMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getUserPreferenceUserLevel(
			@PathParam("userID") String userID,
			@PathParam("key") String key)
	throws MethodException, ConnectionException
	{
		RestStringArrayType lines = (RestStringArrayType) 
				new GetUserPreferenceUserEntityCommand(
						getLocalSiteNumber(), 
						userID, 
						key, 
						getInterfaceVersion()).execute();
		
		return getUserPreferenceResponse(lines);
	}
	
	private Response getUserPreferenceResponse(RestStringArrayType lines) 
	{
		if ((lines == null) || (lines.getValue() == null) || (lines.getValue().length == 0))
		{
			return Response.status(Status.NO_CONTENT).build();
		}
		else 
		{
			String[] linesArray = lines.getValue();
			if (linesArray[0].equals(""))
			{
				return Response.status(Status.NO_CONTENT).build();
			}
			else if (linesArray[0].startsWith("-1"))
			{
				String err = StringUtils.Piece(linesArray[0],"^", 2);
				return Response.status(Status.INTERNAL_SERVER_ERROR).entity(err).build();
			}
			else
			{
				//Remove the first line
				String[] newLines = new String[linesArray.length-1];
				int i = 0;
				for (String line: linesArray)
				{
					if (i > 0) 
					{
						newLines[i-1] = line;
					}
					i++;
				}
				if (i <= 1)
				{
					return Response.status(Status.NO_CONTENT).build();
				}
				else
				{
					lines.setValue(newLines);
					return wrapResultWithResponseHeaders(lines);
				}
			}
		}
	}

	@POST
	@Path(UserPreferenceRestUri.userPreferenceStoreMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response storeUserPreference(
			@QueryParam("entity") String entity,
			@QueryParam("key") String key,
			String value)
	throws MethodException, ConnectionException
	{
		RestStringType result = (RestStringType) new PostUserPreferenceCommand(
				getLocalSiteNumber(), 
				entity, 
				key,
				value,
				getInterfaceVersion()).execute();

		return storeUserPreferenceUserEntityResponse(result);
	}

	//For backward compatible
	@POST
	@Path(UserPreferenceRestUri.userPreferenceStoreUserEntityMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response storeUserPreferenceUserEntity(
			@PathParam("userID") String userID,
			@PathParam("key") String key,
			String value)
	throws MethodException, ConnectionException
	{
		RestStringType result = (RestStringType) new PostUserPreferenceUserEntityCommand(
				getLocalSiteNumber(), 
				userID, 
				key,
				value,
				getInterfaceVersion()).execute();
		
		return storeUserPreferenceUserEntityResponse(result);
	}

	private Response storeUserPreferenceUserEntityResponse(RestStringType result) 
	{
		if ((result == null) || (result.getValue().equals("")))
		{
			return Response.status(Status.NO_CONTENT).build();
		}
		else if (result.getValue().startsWith("-1"))
		{
			result.setValue(StringUtils.Piece(result.getValue(), ",", 2));
			return Response.status(Status.INTERNAL_SERVER_ERROR).entity(result.getValue()).build();
		}
		else
		{
			result.setValue("User Preference Stored Successfully");
			return wrapResultWithResponseHeaders(result);
		}
	}

	@GET
	@Path(UserPreferenceRestUri.userPreferenceDeleteMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response deleteUserPreference(
			@PathParam("entity") String entity,
			@PathParam("key") String key)
	throws MethodException, ConnectionException
	{
		RestStringType result = (RestStringType) new DeleteUserPreferenceCommand(
						getLocalSiteNumber(), 
						entity, 
						key,
						getInterfaceVersion()).execute();

		return deleteUserPreferenceUserEntityResponse(result);
	}

	//For Backward Compatible
	@GET
	@Path(UserPreferenceRestUri.userPreferenceDeleteUserEntityMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response deleteUserPreferenceUserEntity(
			@PathParam("userID") String userID,
			@PathParam("key") String key)
	throws MethodException, ConnectionException
	{
		RestStringType result = (RestStringType) new DeleteUserPreferenceUserEntityCommand(
						getLocalSiteNumber(), 
						userID, 
						key,
						getInterfaceVersion()).execute();

		return deleteUserPreferenceUserEntityResponse(result);
	}

	private Response deleteUserPreferenceUserEntityResponse(RestStringType result) 
	{
		if ((result == null) || (result.getValue().equals("")))
		{
			return Response.status(Status.NO_CONTENT).build();
		}
		else if (result.getValue().startsWith("-1"))
		{
			result.setValue(StringUtils.Piece(result.getValue(), "^", 2));
			return Response.status(Status.INTERNAL_SERVER_ERROR).entity(result.getValue()).build();
		}
		else
		{
			result.setValue("User Preference Deleted Successfully");
			return wrapResultWithResponseHeaders(result);
		}
	}

	@GET
	@Path(UserPreferenceRestUri.userPreferenceGetKeysMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getUserPreferenceKeys(
			@QueryParam("entity") String entity)
	throws MethodException, ConnectionException
	{
		UserPreferenceKeysType keys = (UserPreferenceKeysType) 
				new GetUserPreferenceKeysCommand(
						getLocalSiteNumber(), 
						entity, 
						getInterfaceVersion()).execute();
		
		return getUserPreferenceKeysResponse(keys);
	}

	//Backward compatible
	@GET
	@Path(UserPreferenceRestUri.userPreferenceGetKeysUserEntityMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getUserPreferenceKeysUserEntity(
			@PathParam("userID") String userID)
	throws MethodException, ConnectionException
	{
		UserPreferenceKeysType keys = (UserPreferenceKeysType) 
				new GetUserPreferenceKeysUserEntityCommand(
						getLocalSiteNumber(), 
						userID, 
						getInterfaceVersion()).execute();
		
		return getUserPreferenceKeysResponse(keys);
	}
	
	private Response getUserPreferenceKeysResponse(UserPreferenceKeysType keys)
	{
		if ((keys == null) || (keys.getUserPreferenceKeys() == null) || (keys.getUserPreferenceKeys().length == 0))
		{
			return Response.status(Status.NO_CONTENT).build();
		}
		else
		{
			String[] usrPrefKeys = keys.getUserPreferenceKeys();
			if (usrPrefKeys[0].toLowerCase(Locale.ENGLISH).equals(""))
			{
				return Response.status(Status.NO_CONTENT).build();
			}

			else if (usrPrefKeys[0].toLowerCase(Locale.ENGLISH).startsWith("-1"))
			{
				String err = StringUtils.Piece(usrPrefKeys[0],"^", 2);
				return Response.status(Status.INTERNAL_SERVER_ERROR).entity(err).build();
			}
			else
			{
				return wrapResultWithResponseHeaders(keys);
			}
		}
	}

	protected String getInterfaceVersion()
	{
		return "V1";
	}

	protected String getLocalSiteNumber()
	{
		return VistaUserPreferenceContextHolder.getUserReferenceContext().getAppConfiguration().getLocalSiteNumber();
	}
}
