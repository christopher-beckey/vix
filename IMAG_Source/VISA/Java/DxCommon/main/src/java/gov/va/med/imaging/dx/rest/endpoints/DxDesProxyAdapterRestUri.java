package gov.va.med.imaging.dx.rest.endpoints;

/**
 * @author vhaisltjahjb
 *
 */
public class DxDesProxyAdapterRestUri 
{
	public final static String dxServicePath = "des_proxy_adapter";
	
	public final static String dpasQueryPath = "filter/dmix/dataservice/{version}/mhs/query/{provider}/ICN:{icn}/{loinc}?requestSource={requestSource}";
	
	public final static String dpasPollerPath = "filter/dmix/dataservice/{version}/mhs/poller/{queryId}";

	public final static String dpasDocumentPath = "filter/dmix/dataservice/{version}/mhs/document/{encDocId}?requestSource={requestSource}";

}
