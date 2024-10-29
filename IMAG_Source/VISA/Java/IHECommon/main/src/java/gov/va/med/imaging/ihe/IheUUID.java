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
public enum IheUUID
implements WellKnownUUID
{
	// ==================================================================================================
	// Transaction UUIDs
	// see http://www.ihe.net/Technical_Framework/upload/IHE_ITI_TF_Supplement_XDS_Stored_Query_TI_2007_08_20-2.pdf
	// Page 20
	
	// The IHE UUID assigned for the FindDocumentQuery transaction
	// NOTE: The IHE UUID assigned for the CrossGatewayQuery transaction
	// is the same value as the FIND_DOCUMENTS_UUID
	FIND_DOCUMENTS_UUID( "urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d", "FindDocuments", IheType.Transaction ),
	
	FIND_SUBMISSION_SETS_UUID("urn:uuid:f26abbcb-ac74-4422-8a30-edb644bbc1a9", "FindDocumentSets", IheType.Transaction),
	FIND_FOLDERS_UUID("urn:uuid:958f3006-baad-4929-a4deff1114824431", "FindFolders", IheType.Transaction),
	GET_ALL_UUID("urn:uuid:10b545ea-725c-446d-9b95-8aeb444eddf3", "GetAll", IheType.Transaction),

	// The IHE UUID assigned for the GetDocument transaction
	// The IHE UUID assigned for the CrossGatewayRetrieve transaction
	// is the same value as GET_DOCUMENTS_UID
	GET_DOCUMENTS_UUID( "urn:uuid:5c4f972b-d56b-40ac-a5fc-c8ca9b40b9d4", "GetDocuments", IheType.Transaction ),
	
	GET_FOLDERS_UUID("urn:uuid:5737b14c-8a1a-4539-b659-03a34a5e1e4", "GetFolders", IheType.Transaction),
	GET_ASSOCIATIONS_UUID("urn:uuid:a7ae438b-4bc2-4642-93e9-be891f7bb155", "GetAssociations", IheType.Transaction),
	GET_DOCUMENTS_AND_ASSOCIATIONS("urn:uuid:bab9529a-4a10-40b3-a01ff68a615d247a", "GetDocumentsAndAssociations", IheType.Transaction),
	GET_SUBMISSION_SETS("urn:uuid:51224314-5390-4169-9b91-b1980040715a", "GetSubmissionSets", IheType.Transaction),
	GET_SUBMISSION_SET_AND_CONTENTS_UUID("urn:uuid:e8e3cb2c-e39c-46b9-99e4-c12f57260b83", "GetSubmissionSetAndContents", IheType.Transaction),
	
	// The IHE UUID assigned for the GetFolderAndContents transaction
	GET_FOLDER_AND_CONTENTS_UUID( "urn:uuid:b909a503-523d-4517-8acf-8e5834dfc4c7", "GetFolderAndContents", IheType.Transaction ),
	
	GET_FOLDERS_FOR_DOCUMENTS_UUID("urn:uuid:10cae35a-c7f9-4cf5-b61efc3278ffb578", "GetFoldersForDocument", IheType.Transaction),
	
	// The IHE UUID assigned for the GetRelatedDocument transaction
	GET_RELATED_DOCUMENTS_UUID( "urn:uuid:d90e5407-b356-4d91-a89f-873917b4b0e6", "GetRelatedDocuments", IheType.Transaction ),	
	
	// ==================================================================================================
	// Document Entry Related UUIDs
	
	/** IHE assigned UUID for Document Entry Object */
	DOC_ENTRY( "urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1", "XDSDocumentEntry", EbXMLRimType.CLASSIFICATION_NODE ),
	
	/** IHE assigned UUID for Document Entry Author */
	DOC_ENTRY_AUTHOR( "urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d", "XDSDocumentEntry.author", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
	
	/** IHE assigned UUID for Document Entry Class Code */
	DOC_ENTRY_CLASS_CODE( "urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a", "XDSDocumentEntry.classCode", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
	
	/** IHE assigned UUID for Document Entry Confidentiality Code */
	DOC_ENTRY_CONFIDENTIALITY_CODE( "urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f", "XDSDocumentEntry.confidentialityCode", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
	
	/** IHE assigned UUID for Document Entry Event Code */
	DOC_ENTRY_EVENT_CODE( "urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4", "XDSDocumentEntry.eventCodeList", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
	
	/** IHE assigned UUID for Document Entry Format Code */
	DOC_ENTRY_FORMAT_CODE( "urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d", "XDSDocumentEntry.formatCode", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
	
	/** IHE assigned UUID for Document Entry Healthcare Facility Code */
	DOC_ENTRY_HEALTH_CARE_FACILITY_CODE( "urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1", "XDSDocumentEntry.healthCareFacilityTypeCode", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
	
	/** IHE assigned UUID for Document Entry Practice Setting Code */
    DOC_ENTRY_PRACTICE_SETTING_CODE( "urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead", "XDSDocumentEntry.practiceSettingCode", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
    
	/** IHE assigned UUID for Document Type Code */
    DOC_ENTRY_TYPE_CODE( "urn:uuid:f0306f51-975f-434e-a61c-c59651d33983", "XDSDocumentEntry.typeCode", EbXMLRimType.EXTERNAL_CLASSIFICATION_SCHEME ),
    
	/** IHE assigned UUID for Document Entry Unique Id */
	DOC_ENTRY_UNIQUE_IDENTIFICATION( "urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab", "XDSDocumentEntry.uniqueId", EbXMLRimType.EXTERNAL_IDENTIFIER ),
	
	/** IHE assigned UUID for Document Entry Patient Id */
	DOC_ENTRY_PATIENT_IDENTIFICATION( "urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427", "XDSDocumentEntry.patientId", EbXMLRimType.EXTERNAL_IDENTIFIER ),
	
	// ================================================================================================================
	// XDSSubmissionSet values
	/** IHE assigned UUID for Submission Set Object */
	SUBMISSON_SET( "urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd", "XDSSubmissionSet", IheType.RIM_UUID ),
	
	/** IHE assigned UUID for Submission Set author */
	SUBMISSON_SET_AUTHOR( "urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d", "XDSSubmissionSet.author", IheType.RIM_UUID ),
	
	/** IHE assigned UUID for Submission Set Content Type Code */
    SUBMISSION_SET_CONTENT_TYPE_CODE( "urn:uuid:aa543740-bdda-424e-8c96-df4873be8500", "XDSSubmissionSet.contentTypeCode", IheType.RIM_UUID ),
    
    /** IHE assigned UUID for Submission Set Source ID */
	SUBMISSION_SET_SOURCE_IDENTIFICATION( "urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832", "XDSSubmissionSet.sourceId", IheType.RIM_UUID ),
	
	/** IHE assigned UUID for Submission Set Unique Id */
	SUBMISSION_SET_UNIQUE_IDENTIFICATION( "urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8", "XDSSubmissionSet.uniqueId", IheType.RIM_UUID ),
	
	/** IHE assigned UUID for Submission Set Patient Id */
	SUBMISSION_SET_PATIENT_IDENTIFICATION( "urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446", "XDSSubmissionSet.patientId", IheType.RIM_UUID ),
	
	// ================================================================================================================
	//XDSFolder/values
	/** IHE assigned UUID for Folder Object */
	FOLDER_OBJECT( "urn:uuid:d9d542f3-6cc4-48b6-8870-ea235fbc94c2", "XDSFolder", IheType.RIM_UUID ),
	
	/** IHE assigned UUID for Folder Code */
	FOLDER_CODE_LIST( "urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5", "XDSFolder.codeList", IheType.RIM_UUID ),
	
	/** IHE assigned UUID for Folder Unique Id */
	FOLDER_UNIQUE_IDENTIFICATION( "urn:uuid:75df8f67-9973-4fbe-a900-df66cefecc5a", "XDSFolder.uniqueId", IheType.RIM_UUID ),
	//	 old version - XDS 2004
	/*
	public static final String FOLDER_UNIQUE_IDENTIFICATION_SCHEME = 
		"urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a";	
	*/
	/** IHE assigned UUID for Folder Patient ID */
	FOLDER_PATIENT_IDENTIFICATION( "urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a", "XDSFolder.patientId", IheType.RIM_UUID ),
	
	// ================================================================================================================
	//uuid for "HasMember, needed in the ObjectRef declaration, but not used
	// in the "HasMember" association
	/** IHE assigned UUID for Has Member Association */
	HAS_MEMBER_UUID( "urn:uuid:2d03bffb-f426-4830-8413-bab8537a995b", IheType.RIM_UUID ),
	
	// ================================================================================================================
	/** IHE assigned UUID for Document Entry Parent Document Relationship Code */
	OTHER_DOCUMENT_STUB("urn:uuid:10aa1a4b-715a-4120-bfd0-9760414112c8", "XDSDocumentEntryStub", IheType.RIM_UUID),
	OTHER_ASSOCIATION_DOCUMENTATION( "urn:uuid:abd807a3-4432-4053-87b4-fd82c643d1f3", "Association Documentation", IheType.RIM_UUID );
	
	
	public enum IheType
	{
		RIM_UUID,
		Transaction
	}
	
	public enum EbXMLRimType
	{
		CLASSIFICATION_NODE,
		EXTERNAL_CLASSIFICATION_SCHEME,
		EXTERNAL_IDENTIFIER
	}
	
	// ===================================================================================
	// Static Finds and Gets
	// ===================================================================================
	public static IheUUID get(String urnAsString) 
	throws URISyntaxException
	{
		return get(new URI(urnAsString));
	}
	
	public static IheUUID get(URI urn)
	{
		if(urn == null)
			return null;
		
		for(IheUUID uuid : IheUUID.values())
			if(urn.equals(uuid.getUrn()))
				return uuid;
		return null;
	}

	// ===================================================================================
	// Instance Members
	// ===================================================================================
	
	private URI urn;
	private final String name;
	private final IheType iheType;
	private final EbXMLRimType ebXmlRimType;		// type is an optional Enum that establishes this UUIDs membership in an grouping
	
	IheUUID(String urnAsString)
	{
		this(urnAsString, null, null, null);
	}
	
	IheUUID(String urnAsString, String name)
	{
		this(urnAsString, name, null, null);
	}
	
	IheUUID(String urnAsString, IheType iheType)
	{
		this(urnAsString, null, null, iheType);
	}
	
	IheUUID(String urnAsString, String name, IheType iheType)
	{
		this(urnAsString, name, null, iheType);
	}
	
	IheUUID(String urnAsString, String name, EbXMLRimType ebXmlRimType)
	{
		this(urnAsString, name, ebXmlRimType, null);
	}
	
	IheUUID(String urnAsString, String name, EbXMLRimType ebXmlRimType, IheType iheType)
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
		this.ebXmlRimType = ebXmlRimType;
		this.iheType = iheType;
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

	public Enum<?> getType()
	{
		return this.ebXmlRimType != null ? this.ebXmlRimType : this.iheType;
	}	
}
