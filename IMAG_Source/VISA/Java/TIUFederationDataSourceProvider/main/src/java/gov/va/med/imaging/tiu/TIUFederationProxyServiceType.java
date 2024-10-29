package gov.va.med.imaging.tiu;

import gov.va.med.imaging.proxy.ids.IDSOperation;
import gov.va.med.imaging.proxy.services.ProxyServiceType;

public class TIUFederationProxyServiceType 
extends 
ProxyServiceType 
{
	public TIUFederationProxyServiceType()
	{
		super("TIU", IDSOperation.IDS_OPERATION_TIUNOTEDATASOURCE);
	}


}
