/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import javax.xml.bind.JAXBElement.GlobalScope;
import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierImpl;
import gov.va.med.URN;
import gov.va.med.imaging.DocumentURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exceptions.URNFormatException;

/**
 * @author vhaiswbeckec
 *
 */
public class CrossGatewayRetrieveRequest
{
	private String homeCommunityId;
	private String repositoryUniqueId;
	private String documentUniqueId;
	private URN documentUrn;				// this is only available if the request is for a VA document
	
	/**
	 * @param homeCommunityId
	 * @param repositoryUniqueId
	 * @param documentUniqueId
	 */
	public CrossGatewayRetrieveRequest(
		String homeCommunityId,
		String repositoryUniqueId, 
		String documentUniqueId)
	{
		super();
		this.homeCommunityId = homeCommunityId;
		this.repositoryUniqueId = repositoryUniqueId;
		this.documentUniqueId = documentUniqueId;
		
//		try
//		{
//			this.documentUrn = URN.create(documentUniqueId);
//			if(documentUrn instanceof ImageURN )
//			{
//				this.repositoryUniqueId = ((ImageURN)documentUrn).getOriginatingSiteId();
//				this.documentUniqueId = ((ImageURN)documentUrn).getImageId();
//			}
//			else if( documentUrn instanceof DocumentURN )
//			{
//				this.repositoryUniqueId = ((DocumentURN)documentUrn).getOriginatingSiteId();
//				this.documentUniqueId = ((DocumentURN)documentUrn).getDocumentId();
//			}
//			else
//				this.documentUrn = null;
//		}
//		catch (URNFormatException x)
//		{
//			// if the document ID is not parsable as a URN then just assure that the documentUrn field is null,
//			// i.e. this is not a VA document or image
//			documentUrn = null;
//		}
	}
	
	public String getHomeCommunityId()
	{
		return this.homeCommunityId;
	}
	public String getRepositoryUniqueId()
	{
		return this.repositoryUniqueId;
	}
	public String getDocumentUniqueId()
	{
		return this.documentUniqueId;
	}
	
	/**
	 * If the request is for a VA artifact then this property will be
	 * set to the URN of the artifact, the document ID will not be a complete
	 * document URN any longer, just a document ID.
	 * 
	 * @return
	 */
	public URN getLocalUrn()
	{
		return this.documentUrn;
	}
	
	/**
	 * 
	 * @return
	 */
	public boolean isRequestForVADocument()
	{
		return getLocalUrn() instanceof DocumentURN;
	}
	
	public boolean isRequestForVAImage()
	{
		return getLocalUrn() instanceof ImageURN;
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();

		sb.append( this.getClass().getSimpleName() );
		sb.append( ' ' );
		if(isRequestForVADocument() || isRequestForVAImage())
			sb.append(getLocalUrn());
		else
		{
			sb.append(documentUniqueId);
			sb.append('@');
			sb.append(repositoryUniqueId);
			sb.append('.');
			sb.append(homeCommunityId);
		}
		return sb.toString();
	}

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime
				* result
				+ ((this.documentUniqueId == null) ? 0 : this.documentUniqueId
						.hashCode());
		result = prime
				* result
				+ ((this.documentUrn == null) ? 0 : this.documentUrn.hashCode());
		result = prime
				* result
				+ ((this.homeCommunityId == null) ? 0 : this.homeCommunityId
						.hashCode());
		result = prime
				* result
				+ ((this.repositoryUniqueId == null) ? 0
						: this.repositoryUniqueId.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final CrossGatewayRetrieveRequest other = (CrossGatewayRetrieveRequest) obj;
		
		if(isRequestForVADocument() || isRequestForVAImage())
		{
			if (this.documentUrn == null)
			{
				if (other.documentUrn != null)
					return false;
			}
			else if (!this.documentUrn.equals(other.documentUrn))
				return false;
		}
		else
		{
			if (this.documentUniqueId == null)
			{
				if (other.documentUniqueId != null)
					return false;
			}
			else if (!this.documentUniqueId.equals(other.documentUniqueId))
				return false;
			if (this.homeCommunityId == null)
			{
				if (other.homeCommunityId != null)
					return false;
			}
			else if (!this.homeCommunityId.equals(other.homeCommunityId))
				return false;
			if (this.repositoryUniqueId == null)
			{
				if (other.repositoryUniqueId != null)
					return false;
			}
			else if (!this.repositoryUniqueId.equals(other.repositoryUniqueId))
				return false;
		}
		return true;
	}
	
	
}
