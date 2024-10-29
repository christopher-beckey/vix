/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 28, 2008
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
package gov.va.med.imaging.url.dicomservices;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLStreamHandler;

/**
 * @author William Peterson
 *
 */
public class Handler 
extends URLStreamHandler 
{

	public static final String protocolScheme = "dicomservices"; 
	
	/* (non-Javadoc)
	 * @see java.net.URLStreamHandler#openConnection(java.net.URL)
	 */
	@Override
	protected URLConnection openConnection(URL url) 
	throws IOException {
		if(url == null)
			throw new MalformedURLException("Null URL passed to DicomServicesStreamHandler.openConnection()");
		
		if(url.getProtocol() == null)
			throw new MalformedURLException("Null protocol in URL passed to DicomServicesStreamHandler.openConnection()");
		if(url.getHost() == null)
			throw new MalformedURLException("Null host in URL passed to DicomServicesStreamHandler.openConnection()");
		if(!protocolScheme.equals(url.getProtocol()) )
			throw new MalformedURLException("Unsupported protocol '" + url.getProtocol() + 
					"' passed to DicomServicesStreamHandler.openConnection()");
		
		return new DicomServicesConnection(url);
	}

}
