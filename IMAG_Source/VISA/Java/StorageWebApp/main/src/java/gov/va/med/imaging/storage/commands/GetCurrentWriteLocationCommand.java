/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.storage.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.exchange.business.storage.Place;
import gov.va.med.imaging.exchange.business.storage.Provider;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.storage.StorageRouter;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class GetCurrentWriteLocationCommand 
extends AbstractStorageCommand<NetworkLocationInfo, String>
{
	private final String interfaceVersion;
	private final String siteNumber;
	
	public GetCurrentWriteLocationCommand(String siteNumber, String interfaceVersion)
	{
		super("authenticateUser");
		this.interfaceVersion = interfaceVersion;
		this.siteNumber = siteNumber;
	}

	@Override
	protected NetworkLocationInfo executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		// Create a provider so we can pace the place id down to the datasource
		Place place = new Place();
		place.setSiteNumber(siteNumber);
		Provider provider = new Provider();
		provider.setPlace(place);
		
		// Create the router and call the method
		StorageRouter router = getRouter();		
		NetworkLocationInfo info = router.getCurrentWriteLocation(provider);
        getLogger().info("{}, transaction({}) got {}", getMethodName(), getTransactionId(), info == null ? "null" : "1" + " network location for site " + siteNumber);
		setEntriesReturned((info == null ? 0 : 1));
		return info;
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(NetworkLocationInfo routerResult) 
	throws TranslationException 
	{

    	// Get and configure XStream
		XStream xstream = getXStream();
    	xstream.alias("NetworkLocationInfo", NetworkLocationInfo.class);
    	
    	return xstream.toXML(routerResult);
	}

	@Override
	protected String getMethodParameterValuesString() {
		// TODO Auto-generated method stub
		return null;
	}
	
}
