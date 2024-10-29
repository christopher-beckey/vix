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
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.storage.StorageRouter;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class GetNetworkLocationDetailsCommand 
extends AbstractStorageCommand<NetworkLocationInfo, String>
{
	private final String interfaceVersion;
	private final String networkLocationIen;
	public GetNetworkLocationDetailsCommand(String networkLocationIen, String interfaceVersion)
	{
		super("authenticateUser");
		this.interfaceVersion = interfaceVersion;
		this.networkLocationIen = networkLocationIen;
	}

	@Override
	protected NetworkLocationInfo executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		StorageRouter router = getRouter();		
		NetworkLocationInfo info = router.getNetworkLocationDetails(networkLocationIen);
        getLogger().info("{}, transaction({}) got {}", getMethodName(), getTransactionId(), info == null ? "null" : "1" + " network location for IEN " + networkLocationIen);
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
