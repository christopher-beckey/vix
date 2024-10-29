/**
 * 
 */
package gov.va.med.imaging.viewerservices.proxy.rest;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.ClientResponse;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.encryption.AesEncryption;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author William Peterson
 *
 */
public class ViewerServicesRestPostClient 
extends AbstractViewerServicesRestClient {

	private String vixSecurityToken = "";

	/**
	 * @param url
	 * @param mediaType
	 * @param metadataTimeoutMs
	 */
	public ViewerServicesRestPostClient(String url, String mediaType,
			int metadataTimeoutMs) {
		super(url, mediaType, metadataTimeoutMs);
	}

	public ViewerServicesRestPostClient(String url, MediaType mediaType,
			int metadataTimeoutMs) {
		super(url, mediaType, metadataTimeoutMs);
	}

	public <T> T executeRequest(Class<T> c, Object... postParameter)
			throws MethodException, ConnectionException {
		if(postParameter != null)
		{
			for(Object pp : postParameter)
			{	
				//WFP-May want to change media type to application/xml.
				getRequest().entity(pp, MediaType.APPLICATION_XML_TYPE); //TEXT_XML_TYPE
			}
		}
		getLogger().debug("Finished building request message body.  Now executing the Request.");
		return super.executeRequest(c);
	}

	@Override
	protected <T> ClientResponse executeMethodInternal(Class<T> c) {
		return getRequest().post(ClientResponse.class);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.rest.AbstractRestClient#addTransactionHeaders()
	 */
	@Override
	protected void addTransactionHeaders() 
	{
		request.header(httpHeaderConnectionType, "Keep-Alive");
		request.header(httpHeaderContentType, "application/xml");
		request.header(httpHeaderSecurityToken, getVixSecurityToken());
	}

	private String getVixSecurityToken() 
	{
		if ((vixSecurityToken == null) || vixSecurityToken.isEmpty() )
		{
			vixSecurityToken = getSecurityToken();
		}
		
		return vixSecurityToken;
	}

	private String getSecurityToken() 
	{
		String delimiter = "||";
		
		TransactionContext transactionContext = TransactionContextFactory.get();

		StringBuilder sb = new StringBuilder();
		sb.append(transactionContext.getFullName()); //0 = Fullname
		sb.append(delimiter);
		sb.append(transactionContext.getDuz()); // 1 = duz
		sb.append(delimiter);
		sb.append(transactionContext.getSsn()); // 2 = ssn
		sb.append(delimiter);
		sb.append(transactionContext.getSiteName()); // 3 = sitename
		sb.append(delimiter);
		sb.append(transactionContext.getSiteNumber()); // 4 = sitenumber
		sb.append(delimiter);
		sb.append(transactionContext.getBrokerSecurityToken()); // 5 = broker security token
		sb.append(delimiter);
		sb.append(transactionContext.getAccessCode()); //6
		sb.append(delimiter);
		sb.append(transactionContext.getVerifyCode()); // 7
		try {
			return AesEncryption.encrypt(sb.toString());
		} catch (AesEncryptionException e) {
			return "";
		}
	}


}
