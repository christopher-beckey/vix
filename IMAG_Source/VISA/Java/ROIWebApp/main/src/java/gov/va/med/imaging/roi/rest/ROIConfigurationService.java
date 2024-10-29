/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 19, 2013
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
package gov.va.med.imaging.roi.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.roi.commands.ROIGetConfigurationCommand;
import gov.va.med.imaging.roi.commands.ROIPostConfigurationCommand;
import gov.va.med.imaging.roi.rest.types.ROIConfigurationType;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import gov.va.med.imaging.roi.commands.ROIGetCommunityCareProvidersCommand; 

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("configuration")
public class ROIConfigurationService
{
	
	@Path("")
	@GET
	@Produces(MediaType.APPLICATION_XML)
	public ROIConfigurationType getConfiguration()
	throws ConnectionException, MethodException
	{
		return new ROIGetConfigurationCommand().execute();
	}
	
	@Path("")
	@POST
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public ROIConfigurationType updateConfiguration(
			ROIConfigurationType configuration)
	throws ConnectionException, MethodException
	{
		return new ROIPostConfigurationCommand(configuration).execute();
	}

	@Path("getCommunityCareProviders")
	@GET
	@Produces(MediaType.APPLICATION_XML)
	public String getCommunityCareProviders()
	throws ConnectionException, MethodException
	{
		return new ROIGetCommunityCareProvidersCommand().execute();
	}

}
