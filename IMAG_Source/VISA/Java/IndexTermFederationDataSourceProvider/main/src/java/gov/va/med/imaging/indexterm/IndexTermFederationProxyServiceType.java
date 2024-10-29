package gov.va.med.imaging.indexterm;

import gov.va.med.imaging.proxy.ids.IDSOperation;
import gov.va.med.imaging.proxy.services.ProxyServiceType;

public class IndexTermFederationProxyServiceType 
extends ProxyServiceType 
{
	public IndexTermFederationProxyServiceType()
	{
		super("IndexTerm", IDSOperation.IDS_OPERATION_INDEXTERMDATASOURCE);
	}

}
