/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 24, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.dx.datasource.configuration;

import gov.va.med.OID;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.URLComponentMerger;
import gov.va.med.exceptions.RoutingTokenFormatException;
import java.io.Serializable;

/**
 * Contains configuration information about a site that provides an DX interface
 * 
 * Server and port are included in the event the server and port from the site service are not
 * correct for the DX interface.  In most cases, the server and port should not come from
 * the DxSiteConfiguration but should come from the site service, they are here just in case
 * they are needed (you never know...).
 * 
 * @author vhaisltjahjb
 *
 */
public class DxSiteConfiguration
implements Serializable
{
	private static final long serialVersionUID = -5364350214562839313L;

	// Map key
	private final RoutingTokenImpl routingToken;

	// components to merge the URLs from site resolution with the additional fields we need
	private final URLComponentMerger queryComponentMerger;
	private final URLComponentMerger retrieveComponentMerger;
	
	public static DxSiteConfiguration create(
		OID homeCommunityId, String repositoryId,
		URLComponentMerger queryComponentMerger, URLComponentMerger retrieveComponentMerger) 
	throws RoutingTokenFormatException
	{
		if(homeCommunityId == null)
			throw new IllegalArgumentException("The home community ID may not be null.");
		
		if(repositoryId == null)
			throw new IllegalArgumentException("The repository ID may not be null, use '*' for wildcard.");
		
		return new DxSiteConfiguration(homeCommunityId, repositoryId, queryComponentMerger, retrieveComponentMerger);
	}
	
	/**
	 * 
	 * @param homeCommunityId
	 * @param repositoryId
	 * @throws RoutingTokenFormatException 
	 */
	private DxSiteConfiguration(
		OID homeCommunityId, String repositoryId,
		URLComponentMerger queryComponentMerger, URLComponentMerger retrieveComponentMerger) 
	throws RoutingTokenFormatException
	{
		super();
		this.routingToken = (RoutingTokenImpl)RoutingTokenImpl.create(homeCommunityId, repositoryId);
		this.queryComponentMerger = queryComponentMerger;
		this.retrieveComponentMerger = retrieveComponentMerger;
	}

	/**
	 * @return the routingToken
	 */
	public RoutingTokenImpl getRoutingToken()
	{
		return this.routingToken;
	}

	/**
	 * @return the queryComponentMerger
	 */
	public URLComponentMerger getQueryComponentMerger()
	{
		return this.queryComponentMerger;
	}

	/**
	 * @return the retrieveComponentMerger
	 */
	public URLComponentMerger getRetrieveComponentMerger()
	{
		return this.retrieveComponentMerger;
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();

		sb.append(getRoutingToken().toString());
		sb.append("=>");
		sb.append(getQueryComponentMerger().toString());
		sb.append("==");
		sb.append(getRetrieveComponentMerger().toString());
		
		return sb.toString();
	}
}
