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
public enum EbXMLRsUUID
implements WellKnownUUID
{
	// ================================================================================================================
	// Response Status Codes
	
	/**
	 * The response code (value of the query:AdhocQueryResponse status attribute
	 * indicating success.
	 */
	RESPONSE_STATUS_SUCCESS("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success", Type.RESPONSE_STATUS_TYPE),
	
	/**
	 * The response code (value of the query:AdhocQueryResponse status attribute
	 * indicating failure.
	 */
	RESPONSE_STATUS_PARTIALSUCCESS("urn:ihe:iti:2007:ResponseStatusType:PartialSuccess", Type.RESPONSE_STATUS_TYPE),
	
	/**
	 * The response code (value of the query:AdhocQueryResponse status attribute
	 * indicating failure.
	 */
	RESPONSE_STATUS_FAILURE("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure", Type.RESPONSE_STATUS_TYPE),
	
	/*
	 * Query Language UUIDs
	 */
	QUERY_LANGUAGE_SQL92("urn:uuid:c26215e8-7732-4c7f-8b04-bd8115c325e9", Type.QUERY_LANGUAGE_TYPE), // value="urn:oasis:names:tc:ebxml-regrep:QueryLanguage:SQL-92"
    QUERY_LANGUAGE_EBRS("urn:uuid:55a950c7-c962-4fae-86d4-c935980f2749", Type.QUERY_LANGUAGE_TYPE), // value="urn:oasis:names:tc:ebxml-regrep:QueryLanguage:ebRSFilterQuery"
    QUERY_LANGUAGE_XQUERY("urn:uuid:4b904842-5bf0-4359-aecc-fb8cb15773cb", Type.QUERY_LANGUAGE_TYPE), // value="urn:oasis:names:tc:ebxml-regrep:QueryLanguage:XQuery"/>
    QUERY_LANGUAGE_XPATH("urn:uuid:6f3e5434-c2da-412a-bb02-ac9062e1e4a1", Type.QUERY_LANGUAGE_TYPE); // value="urn:oasis:names:tc:ebxml-regrep:QueryLanguage:XPath"/>
    
	/**
	 * 
	 */
	enum Type
	{
		RESPONSE_STATUS_TYPE,
		QUERY_LANGUAGE_TYPE
	}
	
	// ===================================================================================
	// Static Finds and Gets
	// ===================================================================================
	public static EbXMLRsUUID get(String urnAsString) 
	throws URISyntaxException
	{
		return get(new URI(urnAsString));
	}
	
	public static EbXMLRsUUID get(URI urn)
	{
		if(urn == null)
			return null;
		
		for(EbXMLRsUUID uuid : EbXMLRsUUID.values())
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
	
	EbXMLRsUUID(String urnAsString)
	{
		this(urnAsString, null, null);
	}
	
	EbXMLRsUUID(String urnAsString, String name)
	{
		this(urnAsString, name, null);
	}
	
	EbXMLRsUUID(String urnAsString, Type type)
	{
		this(urnAsString, null, type);
	}
	
	EbXMLRsUUID(String urnAsString, String name, Type type)
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
