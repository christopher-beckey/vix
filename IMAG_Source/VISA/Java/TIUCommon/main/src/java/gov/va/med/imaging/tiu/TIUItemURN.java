/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu;

import java.io.Serializable;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierImpl;
import gov.va.med.NamespaceIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.URNFormatException;

/**
 * @author Julian Werfel
 *
 */
@URNType(namespace="tiu")
public class TIUItemURN
extends URN
implements Serializable, GlobalArtifactIdentifier, TIUItemIdentifier
{
	private static final long serialVersionUID = 1L;
	
	protected String originatingSiteId;
	protected String itemId;
	
	
	private static final String namespace = "tiu";
	public static final WellKnownOID DEFAULT_HOME_COMMUNITY_ID = WellKnownOID.VA_RADIOLOGY_IMAGE;
	
	private static final String namespaceSpecificStringRegex = 
		"([^-]+)" + 								// the site ID 
		URN.namespaceSpecificStringDelimiter +
		"([^-]+)";									// the item ID
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);
	private static final int SITE_ID_GROUP = 1;
	private static final int ITEM_ID_GROUP = 2;
	
	private static NamespaceIdentifier namespaceIdentifier = new NamespaceIdentifier(namespace);
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		return namespaceIdentifier;
	}
	
	public static TIUItemURN create(String originatingSiteId, 
			String itemId)
	throws URNFormatException
	{	
		return new TIUItemURN(TIUItemURN.getManagedNamespace(),
				originatingSiteId, itemId);
	}
	
	public static TIUItemURN create(URNComponents urnComponents, 
			SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		return new TIUItemURN(urnComponents, serializationFormat);
	}
	
	/**
	 * Used directly and a pass through for derived classes.
	 * The constructor called by the URN class when a URN derived class
	 * is being created from a String representation.
	 * 
	 * @param components
	 * @throws URNFormatException
	 */
	protected TIUItemURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
	}
	
	protected TIUItemURN(NamespaceIdentifier namespaceIdentifier,
			String originatingSiteId, 
			String itemId)
	throws URNFormatException
	{
		super(namespaceIdentifier);
		setOriginatingSiteId(originatingSiteId);
		setItemId(itemId);
	}

	@Override
	public String getHomeCommunityId()
	{
		// Images are always in the VA community
		return WellKnownOID.VA_RADIOLOGY_IMAGE.getCanonicalValue().toString();
	}

	@Override
	public String getRepositoryUniqueId()
	{
		return originatingSiteId;
	}

	@Override
	public boolean isEquivalent(RoutingToken that)
	{
		return RoutingTokenImpl.isEquivalent(this, that);
	}

	@Override
	public boolean isIncluding(RoutingToken that)
	{
		return RoutingTokenImpl.isIncluding(this, that);
	}

	@Override
	public String toRoutingTokenString()
	{
		return getHomeCommunityId() + "," + getRepositoryUniqueId();
	}

	@Override
	public int compareTo(GlobalArtifactIdentifier o)
	{
		return GlobalArtifactIdentifierImpl.compareTo(this, o);
	}

	@Override
	public boolean equalsGlobalArtifactIdentifier(GlobalArtifactIdentifier that)
	{
		return GlobalArtifactIdentifierImpl.equalsGlobalArtifactIdentifier(this, that);
	}
	
	@Override
	public TIUItemURN clone() 
	throws CloneNotSupportedException
	{
		try
		{
			return create(getOriginatingSiteId(), getItemId());
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
	}

	/**
	 * @return the itemId
	 */
	public String getItemId()
	{
		return itemId;
	}

	/**
	 * @param itemId the itemId to set
	 */
	public void setItemId(String itemId)
	{
		this.itemId = itemId;
	}

	public String getOriginatingSiteId()
	{
		return originatingSiteId;
	}

	public void setOriginatingSiteId(String originatingSiteId)
	{
		this.originatingSiteId = originatingSiteId;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.URN#toString()
	 */
	@Override
	public String toString()
	{
		StringBuilder ahnold = new StringBuilder();
		
		// build the scheme identifier
		ahnold.append(urnSchemaIdentifier);
		ahnold.append(urnComponentDelimiter);

		// build the namespace identifier
		ahnold.append(this.getNamespaceIdentifier());
		ahnold.append(urnComponentDelimiter);
		
		ahnold.append(this.getNamespaceSpecificString());
		
		return ahnold.toString();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.URN#toStringAsNative()
	 */
	@Override
	protected String toStringNative()
	{
		StringBuilder ahnold = new StringBuilder();
		
		// build the scheme identifier
		ahnold.append(urnSchemaIdentifier);
		ahnold.append(urnComponentDelimiter);

		// build the namespace identifier
		ahnold.append(this.getNamespaceIdentifier());
		ahnold.append(urnComponentDelimiter);
		
		// restore any RFC2141 illegal characters
		ahnold.append( RFC2141_ESCAPING.unescapeIllegalCharacters(this.getNamespaceSpecificString()) );
		
		return ahnold.toString();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.URN#toStringAsVAInternal()
	 */
	@Override
	public String toStringCDTP()
	{
		StringBuilder ahnold = new StringBuilder();
		
		// build the scheme identifier
		ahnold.append(urnSchemaIdentifier);
		ahnold.append(urnComponentDelimiter);

		// build the namespace identifier
		ahnold.append(this.getNamespaceIdentifier());
		ahnold.append(urnComponentDelimiter);
		
		String nss = this.getNamespaceSpecificString();
		// escape any filename illegal characters
		nss = FILENAME_ESCAPING.escapeIllegalCharacters(nss);
		ahnold.append(nss);
		
		String additionalIdentifiers = this.getAdditionalIdentifiersString();
		// escape any filename illegal characters
		additionalIdentifiers = FILENAME_ESCAPING.escapeIllegalCharacters(additionalIdentifiers);
		ahnold.append(additionalIdentifiers);
		
		return ahnold.toString();	
	}

	/**
	 * 
	 */
	@Override
	public String getNamespaceSpecificString(SERIALIZATION_FORMAT serializationFormat)
	{
		StringBuilder ahnold = new StringBuilder();
		
		// build the namespace specific string
		ahnold.append(this.originatingSiteId);
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(this.itemId);
		
		return ahnold.toString();
	}

	@Override
	public void parseNamespaceSpecificString(NamespaceIdentifier namespace,
			String namespaceSpecificString,
			SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException			
	{
		if(namespaceSpecificString == null)
			throw new URNFormatException("The namespace specific string for a(n) " + this.getClass().getSimpleName() + " cannot be null.");
		
		Matcher nssMatcher = namespaceSpecificStringPattern.matcher(namespaceSpecificString);
		
		if(! nssMatcher.matches())
		{
			final String msg = "Namespace specific string '" + namespaceSpecificString + "' is not valid.";
			final String cleanMsg = StringUtil.cleanString(msg);
			Logger.getAnonymousLogger().warning(cleanMsg);
			throw new URNFormatException(cleanMsg);
		}
	
		setOriginatingSiteId( nssMatcher.group(TIUItemURN.SITE_ID_GROUP).trim() );
		setItemId( nssMatcher.group(TIUItemURN.ITEM_ID_GROUP).trim() );	
	}

	@Override
	public String getDocumentUniqueId()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(getItemId());
		
		return sb.toString();
	}
}