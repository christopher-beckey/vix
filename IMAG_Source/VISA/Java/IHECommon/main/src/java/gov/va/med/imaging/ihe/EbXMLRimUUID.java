/**
 * 
 */
package gov.va.med.imaging.ihe;

import java.net.URI;
import java.net.URISyntaxException;

/**
 * NOTE: these are UUIDs in the sense that they are universally unique identifiers,
 * they are NOT UUIDs in the RFC4122 compliant sense and do not derive from the
 * gov.va.med.UUID class. 
 * 
 * @author vhaiswbeckec
 *
 */
public enum EbXMLRimUUID
implements WellKnownUUID
{
	/*
	 * 
	 */
	DOCUMENT_STATUS_SUBMITTED("urn:oasis:names:tc:ebxml-regrep:StatusType:Submitted", Type.STATUS),
	DOCUMENT_STATUS_APPROVED("urn:oasis:names:tc:ebxml-regrep:StatusType:Approved", Type.STATUS),
	DOCUMENT_STATUS_DEPRECATED("urn:oasis:names:tc:ebxml-regrep:StatusType:Deprecated", Type.STATUS),
	
	/*
	 * 
	 */
	RELATIONSHIP_APND("urn:uuid:917dc511-f7da-4417-8664-de25b34d3def", "APND", Type.RELATIONSHIP),
	RELATIONSHIP_RPLC( "urn:uuid:60fd13eb-b8f6-4f11-8f28-9ee000184339", "RPLC", Type.RELATIONSHIP),
	RELATIONSHIP_XFRM( "urn:uuid:ede379e6-1147-4374-a943-8fcdcf1cd620", "XFRM", Type.RELATIONSHIP),
	RELATIONSHIP_XFRM_RPLC("urn:uuid:b76a27c7-af3c-4319-ba4c-b90c1dc45408", "XFRM_RPLC", Type.RELATIONSHIP),
	RELATIONSHIP_SIGNS("urn:uuid:8ea93462-ad05-4cdc-8e54-a8084f6aff94", "signs", Type.RELATIONSHIP),
	
	RIM_OBJECT_TYPE_ASSOCIATION("urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association", Type.REGISTRY_OBJECT);

	
	public enum Type
	{
		STATUS,
		RELATIONSHIP,
		REGISTRY_OBJECT
	}
	
	// ===================================================================================
	// Static Finds and Gets
	// ===================================================================================
	public static EbXMLRimUUID get(String urnAsString) 
	throws URISyntaxException
	{
		return get(new URI(urnAsString));
	}
	
	public static EbXMLRimUUID get(URI urn)
	{
		if(urn == null)
			return null;
		
		for(EbXMLRimUUID uuid : EbXMLRimUUID.values())
			if(urn.equals(uuid.getUrn()))
				return uuid;
		return null;
	}

	// ===================================================================================
	// Instance Members
	// ===================================================================================
	
	private URI urn;
	private final String name;
	private final Type type;		// type is an optional Enum that establishes this UUIDs membership in an grouping
	
	EbXMLRimUUID(String urnAsString)
	{
		this(urnAsString, null, null);
	}
	
	EbXMLRimUUID(String urnAsString, String name)
	{
		this(urnAsString, name, null);
	}
	
	EbXMLRimUUID(String urnAsString, Type type)
	{
		this(urnAsString, null, type);
	}
	
	EbXMLRimUUID(String urnAsString, String name, Type type)
	{
		try 
		{
			this.urn = new URI(urnAsString);
		} 
		catch (URISyntaxException e) 
		{
			e.printStackTrace();
		}
		
		this.name = name;
		this.type = type;
	}

	public URI getUrn() 
	{
		return urn;
	}
	public String getUrnAsString() 
	{
		return getUrn().toASCIIString();
	}
	
	public String getName()
	{
		return this.name;
	}

	public Type getType()
	{
		return this.type;
	}	
}
