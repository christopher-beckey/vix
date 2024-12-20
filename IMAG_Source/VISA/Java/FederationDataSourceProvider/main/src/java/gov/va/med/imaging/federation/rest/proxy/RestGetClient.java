/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 17, 2010
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
package gov.va.med.imaging.federation.rest.proxy;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.ClientResponse;

import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;

/**
 * @author vhaiswwerfej
 *
 */
//WFP-Class not in use.  Its twin is FederationRestGetClient and it appears everyone calls that.
//	Should put this class in "deprecated".
public class RestGetClient 
extends AbstractFederationRestClient
{
	public RestGetClient(String url, MediaType mediaType, 
			FederationConfiguration federationConfiguration)
	{
		super(url, mediaType, federationConfiguration);
	}
	
	@Override
	protected <T> ClientResponse executeMethodInternal(Class<T> c) 
	{
		return getRequest().get(ClientResponse.class);
	}
}
