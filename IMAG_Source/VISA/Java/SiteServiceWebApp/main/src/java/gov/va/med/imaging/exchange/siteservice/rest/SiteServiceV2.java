/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 5, 2012
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
package gov.va.med.imaging.exchange.siteservice.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.siteservice.commands.SiteServiceGetSiteCommand;
import gov.va.med.imaging.exchange.siteservice.commands.SiteServiceGetSitesCommand;
import gov.va.med.imaging.exchange.siteservice.commands.SiteServiceGetVisnCommand;
import gov.va.med.imaging.exchange.siteservice.commands.SiteServiceGetVisnsCommand;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

/**ImagingServices.xmlImagingServices.xml@author VHAISWWERFEJ
 *
 */
@Path("siteservice")
public class SiteServiceV2
{

	@GET
	@Path("sites")
	@Produces(MediaType.APPLICATION_XML)
	public Response getSites()
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(new SiteServiceGetVisnsCommand().execute());
	}
	
	@GET
	@Path("site/{siteNumber}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getSite(
			@PathParam("siteNumber") String siteNumber)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(new SiteServiceGetSiteCommand(siteNumber).execute());
	}
	
	@GET
	@Path("visn/{visnNumber}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getVisn(
			@PathParam("visnNumber") String visnNumber)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(new SiteServiceGetVisnCommand(visnNumber).execute());
	}
	
	@GET
	@Path("sites/{siteIds}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getSites(
			@PathParam("siteIds") String siteIds)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(new SiteServiceGetSitesCommand(siteIds).execute());
	}
	
	/**
	 * This header should allow other site's clients the ability to retrieve the site service contents
	 * @param result
	 * @return
	 */
	protected Response wrapResultWithResponseHeaders(Object result)
	{		
		return Response.status(Status.OK).header("Access-Control-Allow-Origin", 
				"*").entity(result).build();
	}
}
