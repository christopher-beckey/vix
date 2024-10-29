package gov.va.med.imaging.consult;

import gov.va.med.imaging.proxy.ids.IDSOperation;
import gov.va.med.imaging.proxy.services.ProxyServiceType;

public class ConsultFederationProxyServiceType 
extends ProxyServiceType 
{
	public ConsultFederationProxyServiceType()
	{
		super("Consult", IDSOperation.IDS_OPERATION_CONSULTDATASOURCE);
	}
}
