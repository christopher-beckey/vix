/**
 * 
 */
package gov.va.med.imaging;

import gov.va.med.NamespaceIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.StudyURNFactory;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.WellKnownOID;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.exceptions.ImageURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.utility.Base32ConversionUtility;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 * 
 *  * Defines the syntax of a URN used to identify VA images to the outside world.
 * An P34ImageURN is defined to be in the following format:
 * "urn" + ":" + "vap34image" + ":" + <site-id> + "-" + <assigned-id> + "-" + <studyId> + "-" + <patientId> [+ "-" + <modality>]
 * where:
 *   <site-id> is either the site from which the image originated or the string "va-imaging"
 *   <assigned-id> is the permanent, immutable ID as assigned by the originating site or a 
 *   VA-domain unique ID (an Imaging GUID).
 *   <studyId> is the study IEN in VistA
 *   <imageIcn> is the unique VA identifier for the patient
 *   <modality> is the modality of the image
 *   
 * notes:
 *   Externally, the site-id should not be interpreted as a location component.  It should be 
 *   interpreted as no more than a specifier in a GUID (i.e. just a component that restricts 
 *   the required domain of uniqueness).  Initially and internally to the VA only, it may 
 *   be used as a location hint.  External code that relies on the site ID as a location
 *   may cease functioning without warning.
 *
 *   P34ImageURN follows the syntax of a URN as defined in W3C RFC2141 with the following additional
 *   rules on the namespace specific string:
 *   The character '-' is a reserved character, used to delimit portions of the namespace
 *   specific string.  Specifically it is used to delimit the originating site ID from the
 *   site-assigned image ID.
 *   The namespace specific string must consist of uppercase, lowercase and numeric characters
 *   with a '-' somewhere in the middle.
 *   
 *   @see http://www.ietf.org/rfc/rfc2141.txt
 *   
 * NOTE: both this class and DocumentURN MUST implement GlobalArtifactIdentifier
 *
 */
@URNType(namespace="vap34image")
public class P34ImageURN 
extends ImageURN {

	private static final long serialVersionUID = 1L;
	public static final String NAMESPACE = "vap34image";
	
	private static NamespaceIdentifier namespaceIdentifier = null;
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		if(namespaceIdentifier == null)
			namespaceIdentifier = new NamespaceIdentifier(NAMESPACE);
		return namespaceIdentifier;
	}
	
	// the additional plus '+' makes the component regular expressions into possessive quantifiers
	// and thereby improves performance (to the point of usability)
	// see http://www.regular-expressions.info/possessive.html for an explanation
	private static final String namespaceSpecificStringRegex = 
		"([^-]+)" + 								// the site ID
		URN.namespaceSpecificStringDelimiter +
		"([^-]+)" +									// the image ID 
		URN.namespaceSpecificStringDelimiter +
		"([^-]+)" +									// the group or study ID 
		URN.namespaceSpecificStringDelimiter + 
		"([^-]+)" +									// the patient ID 
		URN.namespaceSpecificStringDelimiter + 
		"([^-]+)" +									// the artifact ien for abstract image 
		URN.namespaceSpecificStringDelimiter + 
		"([^-]+)" +									// the artifact ien for full image
		"(?:" + URN.namespaceSpecificStringDelimiter + ")?" + 
		"([^-]+)?";									// the optional modality
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);
	private static final int ARTIFACT_IEN_ABS = 5;
	private static final int ARTIFACT_IEN_FULL = 6;
	//private static final int FILENAME_FULL = 7;
	//private static final int FILENAME_ABS = 8;
	private static final int MODALITY_GROUP = 7;
	
	public static final int ADDITIONAL_IDENTIFIER_PATIENT_IDENTIFIER_TYPE_INDEX = 0;

	private final static Logger logger = Logger.getLogger(P34ImageURN.class);

	static
	{
		System.out.println("P34ImageURN NSS regular expression is '" + namespaceSpecificStringRegex + "'.");
	}
	
	/**
	 * 
	 * @param originatingSiteId
	 * @param assignedId
	 * @param studyId
	 * @param patientIcn
	 * @return
	 * @throws URNFormatException
	 */
	public static P34ImageURN create(
		String originatingSiteId, 
		String assignedId, 
		String studyId, 
		String patientIcn,
		String artifactIenAbs,
		String artifactIenFull)
	throws URNFormatException
	{
		return create(originatingSiteId, assignedId, studyId, patientIcn, artifactIenAbs, artifactIenFull, null);
	}

	public static P34ImageURN create(
			String originatingSiteId, 
			String assignedId, 
			String studyId, 
			String patientIcn)
		throws URNFormatException
		{
			return create(originatingSiteId, assignedId, studyId, patientIcn, null);
		}

	/**
	 * 
	 * @param originatingSiteId
	 * @param assignedId
	 * @param studyId
	 * @param patientIcn
	 * @param imageModality
	 * @return
	 * @throws ImageURNFormatException
	 */
	public static P34ImageURN create(
		String originatingSiteId, 
		String assignedId, 
		String studyId,
		String patientIcn,
		String artifactIenAbs,
		String artifactIenFull,
		String imageModality) 
	throws URNFormatException
	{
		return new P34ImageURN(originatingSiteId, assignedId, studyId, patientIcn, artifactIenAbs, artifactIenFull, imageModality);		
	}
	
	public static P34ImageURN create(
			String originatingSiteId, 
			String assignedId, 
			String studyId,
			String patientIcn,
			String imageModality) 
		throws URNFormatException
		{
			return new P34ImageURN(originatingSiteId, assignedId, studyId, patientIcn, imageModality);		
		}

	/**
	 * 
	 * @param urnComponents
	 * @return
	 * @throws URNFormatException
	 */
	public static P34ImageURN create(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		P34ImageURN imageUrn = null;

		imageUrn = new P34ImageURN(urnComponents, serializationFormat);
		
		// JMW 1/3/13 P130 - ImageURNs can now contain additional identifiers to hold the PatientIdentifierType			
		//if(urnComponents.getAdditionalIdentifers() != null && urnComponents.getAdditionalIdentifers().length > 0)
		//	throw new URNFormatException("The urn components include additional identifiers, which is not valid for an P34ImageURN.");
		
		return imageUrn;
	}	
	
	/**
	 * 
	 */
	public static P34ImageURN createFromGlobalArtifactIdentifiers(
		String homeCommunityId, 
		String repositoryId,
		String documentId) 
	throws URNFormatException
	{
		return createFromGlobalArtifactIdentifiers( homeCommunityId, repositoryId, documentId, (String[])null);
	}
	
	/**
	 * 
	 * @param homeCommunityId
	 * @param repositoryId
	 * @param documentId
	 * @return
	 * @throws URNFormatException
	 */
	public static P34ImageURN createFromGlobalArtifactIdentifiers(
		String homeCommunityId, 
		String repositoryId, 
		String documentId,
		String... additionalIdentifiers)
	throws URNFormatException
	{
		if( P34ImageURN.isApplicableHomeCommunityId(homeCommunityId, repositoryId, documentId) )
			return new P34ImageURN( repositoryId, documentId );
		else
			throw new URNFormatException("Home community ID '" + homeCommunityId + "' cannot be used to create an ImageURN or its derivatives.");
	}


	/**
	 * Required static method, must return TRUE when this class can represent 
	 * a global artifact ID with the given home community ID.
	 * 
	 * @param homeCommunityId
	 * @param repositoryId 
	 * @param documentId 
	 * @return
	 */
	public static boolean isApplicableHomeCommunityId(String homeCommunityId, String repositoryId, String documentId)
	{
		return 
			P34ImageURN.NAMESPACE.equalsIgnoreCase(homeCommunityId) ||
			WellKnownOID.VA_RADIOLOGY_IMAGE.isApplicable(homeCommunityId);
	}
	
	
	public static Matcher getNamespaceSpecificStringMatcher(CharSequence input)
	{
		return P34ImageURN.namespaceSpecificStringPattern.matcher(input);
	}
	
	// =======================================================================================
	// Instance Members
	// =======================================================================================
	//protected String diskIenFull;
	//protected String diskIenAbs;
	//protected String filenameFull;
	//protected String filenameAbs;
	protected String artifactIenFull;
	protected String artifactIenAbs;
	// ===================================================================================================
	// Instance Constructors
	// ===================================================================================================
	
	/**
	 * Provided only as a pass through for derived classes.
	 * 
	 * @param nid
	 * @throws URNFormatException
	 */
	protected P34ImageURN(NamespaceIdentifier nid) 
	throws URNFormatException
	{
		super(nid);
		setNewDataStructure(true);
	}
	
	/**
	 * Provided only as a pass through for derived classes.
	 * 
	 */
	protected P34ImageURN(
		NamespaceIdentifier namespaceIdentifier, 
		String namespaceSpecificString, 
		String... additionalIdentifiers) 
	throws URNFormatException
	{
		super(namespaceIdentifier, namespaceSpecificString, additionalIdentifiers);
		setNewDataStructure(true);
	}
	
	/**
	 * Used directly and a pass through for derived classes.
	 * The constructor called by the URN class when a URN derived class
	 * is being created from a String representation.
	 * 
	 * @param components
	 * @throws URNFormatException
	 */
	protected P34ImageURN(URNComponents urnComponents, SERIALIZATION_FORMAT serialFormat) 
	throws URNFormatException
	{
		super(urnComponents, serialFormat);
		setNewDataStructure(true);
	}

	/**
	 * 
	 * @param originatingSiteId
	 * @param imageId
	 * @param studyId
	 * @param patientIcn
	 * @param imageModality
	 * @throws URNFormatException
	 */
	private P34ImageURN(
		String originatingSiteId, 
		String assignedId, 
		String studyId, 
		String patientId,
		String artifactIenAbs,
		String artifactIenFull,
		String imageModality) 
	throws URNFormatException 
	{
		super(P34ImageURN.getManagedNamespace());
		setNewDataStructure(true);
		
		originatingSiteId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(originatingSiteId);
		assignedId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(assignedId);
		studyId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(studyId);
		patientId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(patientId);
		artifactIenAbs = URN.RFC2141_ESCAPING.escapeIllegalCharacters(artifactIenAbs);
		artifactIenFull = URN.RFC2141_ESCAPING.escapeIllegalCharacters(artifactIenFull);
		//filenameFull = URN.RFC2141_ESCAPING.escapeIllegalCharacters(filenameFull);
		//filenameAbs = URN.RFC2141_ESCAPING.escapeIllegalCharacters(filenameAbs);
		imageModality = URN.RFC2141_ESCAPING.escapeIllegalCharacters(imageModality);
		
		
		if( !AbstractImagingURN.siteIdPattern.matcher(originatingSiteId).matches() )
			throw new URNFormatException("The site ID '" + originatingSiteId + "' does not match the pattern '" + AbstractImagingURN.siteIdPattern.pattern());
		this.originatingSiteId = originatingSiteId;
		
		if( !AbstractImagingURN.imageIdPattern.matcher(assignedId).matches() )
			throw new URNFormatException("The image ID '" + assignedId + "' does not match the pattern '" + AbstractImagingURN.imageIdPattern.pattern());
		this.instanceId = assignedId;
		
		if( !AbstractImagingURN.groupIdPattern.matcher(studyId).matches() )
			throw new URNFormatException("The group ID '" + studyId + "' does not match the pattern '" + AbstractImagingURN.groupIdPattern.pattern());
		this.groupId = studyId;
		
		if( !AbstractImagingURN.patientIdPattern.matcher(patientId).matches() )
			throw new URNFormatException("The patient ID '" + patientId + "' does not match the pattern '" + AbstractImagingURN.patientIdPattern.pattern());
		this.patientId = patientId;
		
		if(imageModality != null && imageModality.length() <= 0)
			imageModality = null;
		if( imageModality != null && !AbstractImagingURN.modalityPattern.matcher(imageModality).matches() )
			throw new URNFormatException("The modality '" + imageModality + "' does not match the pattern '" + AbstractImagingURN.modalityPattern.pattern());
		
		
		//WFP-Check artifact iens like above.
		this.artifactIenFull = artifactIenFull;
		this.artifactIenAbs = artifactIenAbs;
		//this.filenameFull = filenameFull;
		//this.filenameAbs = filenameAbs;
		this.imageModality = imageModality;
	}

	private P34ImageURN(
			String originatingSiteId, 
			String assignedId, 
			String studyId, 
			String patientId,
			String imageModality) 
		throws URNFormatException 
		{
			super(P34ImageURN.getManagedNamespace());
			setNewDataStructure(true);
			
			originatingSiteId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(originatingSiteId);
			assignedId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(assignedId);
			studyId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(studyId);
			patientId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(patientId);
			imageModality = URN.RFC2141_ESCAPING.escapeIllegalCharacters(imageModality);
			
			
			if( !AbstractImagingURN.siteIdPattern.matcher(originatingSiteId).matches() )
				throw new URNFormatException("The site ID '" + originatingSiteId + "' does not match the pattern '" + AbstractImagingURN.siteIdPattern.pattern());
			this.originatingSiteId = originatingSiteId;
			
			if( !AbstractImagingURN.imageIdPattern.matcher(assignedId).matches() )
				throw new URNFormatException("The image ID '" + assignedId + "' does not match the pattern '" + AbstractImagingURN.imageIdPattern.pattern());
			this.instanceId = assignedId;
			
			if( !AbstractImagingURN.groupIdPattern.matcher(studyId).matches() )
				throw new URNFormatException("The group ID '" + studyId + "' does not match the pattern '" + AbstractImagingURN.groupIdPattern.pattern());
			this.groupId = studyId;
			
			if( !AbstractImagingURN.patientIdPattern.matcher(patientId).matches() )
				throw new URNFormatException("The patient ID '" + patientId + "' does not match the pattern '" + AbstractImagingURN.patientIdPattern.pattern());
			this.patientId = patientId;
			
			if(imageModality != null && imageModality.length() <= 0)
				imageModality = null;
			if( imageModality != null && !AbstractImagingURN.modalityPattern.matcher(imageModality).matches() )
				throw new URNFormatException("The modality '" + imageModality + "' does not match the pattern '" + AbstractImagingURN.modalityPattern.pattern());
			
			this.artifactIenFull = "null";
			this.artifactIenAbs = "null";
			//this.filenameFull = "null";
			//this.filenameAbs = "null";
			this.imageModality = imageModality;
		}

	/**
	 * Constructor from the GAI (IHE) identifiers
	 * 
	 * @param repositoryUniqueId
	 * @param documentId
	 * @throws URNFormatException 
	 */
	private P34ImageURN(String repositoryUniqueId, String assignedId) 
	throws URNFormatException
	{
		super(P34ImageURN.getManagedNamespace());
		repositoryUniqueId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(repositoryUniqueId);
		assignedId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(assignedId);
		
		try
		{
			parseDocumentUniqueIdIntoFields(assignedId);
			this.originatingSiteId = repositoryUniqueId;
		}
		catch (GlobalArtifactIdentifierFormatException x)
		{
			throw new URNFormatException(x);
		}
	}
	
	
	/**
	 * Override the do-nothing version of this method to parse the
	 * namespace specific portion and find the component parts.
	 * 
	 * @param namespaceSpecificString
	 * @throws ImageURNFormatException 
	 */
	@Override
	public void parseNamespaceSpecificString(NamespaceIdentifier namespace, String namespaceSpecificString, SERIALIZATION_FORMAT serializationFormat)
	throws URNFormatException
	{
		if(namespaceSpecificString == null)
			throw new URNFormatException("The namespace specific string for a(n) " + this.getClass().getSimpleName() + " cannot be null.");
		
		Matcher nssMatcher = namespaceSpecificStringPattern.matcher(namespaceSpecificString);
		
		if(! nssMatcher.matches())
		{
			String msg = "Namespace specific string '" + namespaceSpecificString + "' is not valid.";
			logger.warn(msg);
			throw new ImageURNFormatException(msg);
		}
	
		this.originatingSiteId = nssMatcher.group(SITE_ID_GROUP).trim();
		String tmpInstanceId = nssMatcher.group(INSTANCE_ID_GROUP).trim();
		String tmpGroupId = nssMatcher.group(GROUP_ID_GROUP).trim();
		this.artifactIenAbs = nssMatcher.group(ARTIFACT_IEN_ABS).trim();
		this.artifactIenFull = nssMatcher.group(ARTIFACT_IEN_FULL).trim();
		//String tmpFilenameFull = nssMatcher.group(FILENAME_FULL).trim();
		//String tmpFilenameAbs = nssMatcher.group(FILENAME_ABS).trim();

		switch(serializationFormat)
		{
		case PATCH83_VFTP:
			setGroupId( Base32ConversionUtility.base32Decode(tmpGroupId) );
			setInstanceId( Base32ConversionUtility.base32Decode(tmpInstanceId) );
			//setFilenameFull(Base32ConversionUtility.base32Decode(tmpFilenameFull));
			//setFilenameAbs(Base32ConversionUtility.base32Decode(tmpFilenameAbs));
			break;
		case RFC2141:
			this.groupId = tmpGroupId;
			this.instanceId = tmpInstanceId;
			//this.filenameFull = tmpFilenameFull;
			//this.filenameAbs = tmpFilenameAbs;
			break;
		case VFTP:
			this.groupId = tmpGroupId;
			this.instanceId = tmpInstanceId;
			//this.filenameFull = tmpFilenameFull;
			//this.filenameAbs = tmpFilenameAbs;
			break;
		case RAW:
			this.groupId = tmpGroupId;
			this.instanceId = tmpInstanceId;
			//this.filenameFull = tmpFilenameFull;
			//this.filenameAbs = tmpFilenameAbs;
			break;
		case CDTP:
			this.groupId = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpGroupId);
			this.instanceId = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpInstanceId);
			//this.filenameFull = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpFilenameFull);
			//this.filenameAbs = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpFilenameAbs);
			break;
		case NATIVE:
			setGroupId(tmpGroupId);
			setInstanceId(tmpInstanceId);
			//setFilenameFull(tmpFilenameFull);
			//setFilenameAbs(tmpFilenameAbs);
			break;
		}

		this.patientId = URN.RFC2141_ESCAPING.escapeIllegalCharacters( nssMatcher.group(PATIENT_ID_GROUP).trim() );
		if(nssMatcher.group(MODALITY_GROUP) != null)
			this.imageModality = URN.RFC2141_ESCAPING.escapeIllegalCharacters( 
				nssMatcher.group(MODALITY_GROUP).trim().length() > 0 ? nssMatcher.group(MODALITY_GROUP).trim() : null );
		else
			this.imageModality = null;
	}
	
	private void parseDocumentUniqueIdIntoFields(String documentId)
	throws GlobalArtifactIdentifierFormatException
	{
		String[] components = parseDocumentUniqueId(documentId);
		instanceId = components[0];
		groupId = components[1];
		patientId = components[2];
	}

	
	@Override
	public NamespaceIdentifier getNamespaceIdentifier()
	{
		return P34ImageURN.getManagedNamespace();
	}
		
	// ===========================================================================
	// Generated hashCode() and equals(), the modality should not be included
	// in the comparison.
	// Modified equals() to exclude super.equals()
	// ===========================================================================

	/**
	 * 
	 */
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((this.groupId == null) ? 0 : this.groupId.hashCode());
		result = prime * result + ((this.instanceId == null) ? 0 : this.instanceId.hashCode());
		result = prime * result + ((this.originatingSiteId == null) ? 0 : this.originatingSiteId.hashCode());
		result = prime * result + ((this.patientId == null) ? 0 : this.patientId.hashCode());
		result = prime * result + ((this.artifactIenAbs == null) ? 0 : this.artifactIenAbs.hashCode());
		result = prime * result + ((this.artifactIenFull == null) ? 0 : this.artifactIenFull.hashCode());
		//result = prime * result + ((this.filenameFull == null) ? 0 : this.filenameFull.hashCode());
		//result = prime * result + ((this.filenameAbs == null) ? 0 : this.filenameAbs.hashCode());
		return result;
	}

	/**
	 * 
	 * 	Modified equals() to exclude super.equals()
	 */
	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		P34ImageURN other = (P34ImageURN) obj;
		if (this.groupId == null)
		{
			if (other.groupId != null)
				return false;
		}
		else if (!this.groupId.equals(other.groupId))
			return false;
		if (this.instanceId == null)
		{
			if (other.instanceId != null)
				return false;
		}
		else if (!this.instanceId.equals(other.instanceId))
			return false;
		if (this.originatingSiteId == null)
		{
			if (other.originatingSiteId != null)
				return false;
		}
		else if (!this.originatingSiteId.equals(other.originatingSiteId))
			return false;
		if (this.patientId == null)
		{
			if (other.patientId != null)
				return false;
		}
		else if (!this.patientId.equals(other.patientId))
			return false;
		return true;
	}

	// ===========================================================================
	// Serialization formats
	// ===========================================================================
	
	/**
	 * Stringified into the Patch83 VFTP format,
	 * i.e. urn:vaimage:200-<base32 encoded instance ID>-<base32 encoded group ID>-<patient ICN>-<modality>
	 * The instance ID and group ID are base 32 encoded,
	 * the patient ICN and modality, if it exists, are not BASE32 encoded 
	 * the namespace is "vaimage" and 
	 * the site ID is the originating site ID.
	 * 
	 * @see gov.va.med.URN#toStringPatch83VFTP()
	 */
	@Override
	protected String toStringPatch83VFTP()
	{
		StringBuilder ahnold = new StringBuilder();
		
		// build the scheme identifier
		ahnold.append(urnSchemaIdentifier);
		ahnold.append(urnComponentDelimiter);

		// build the namespace identifier
		ahnold.append(P34ImageURN.getManagedNamespace().toString());
		ahnold.append(urnComponentDelimiter);
		ahnold.append(getOriginatingSiteId());
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(this.getInstanceId()));
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(this.getGroupId()));
		if(getPatientId() != null)
		{
			ahnold.append(URN.namespaceSpecificStringDelimiter);
			ahnold.append( getPatientId() );
		}
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(getArtifactIenAbs());
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(getArtifactIenFull());
		//ahnold.append(URN.namespaceSpecificStringDelimiter);
		//ahnold.append(SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(getFilenameFull()));
		//ahnold.append(URN.namespaceSpecificStringDelimiter);
		//ahnold.append(SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(getFilenameAbs()));

		if(getImageModality() != null && getImageModality().length() > 0)
		{
			ahnold.append(URN.namespaceSpecificStringDelimiter);
			ahnold.append( this.getImageModality() );
		}
		return ahnold.toString();
	}

	/**
	 * 
	 */
	@Override
	public String getNamespaceSpecificString(SERIALIZATION_FORMAT serializationFormat)
	{
		serializationFormat = serializationFormat == null ? SERIALIZATION_FORMAT.RFC2141 : serializationFormat;
		StringBuilder ahnold = new StringBuilder();
		
		// build the namespace specific string
		ahnold.append( this.getOriginatingSiteId() );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( this.getInstanceId() );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( serializationFormat.serialize(this.getGroupId()) );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( this.getPatientId() );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( this.getArtifactIenAbs() );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( this.getArtifactIenFull() );
		//ahnold.append(URN.namespaceSpecificStringDelimiter);
		//ahnold.append( this.getFilenameFull() );
		//ahnold.append(URN.namespaceSpecificStringDelimiter);
		//ahnold.append( this.getFilenameAbs() );
		
		if(getImageModality() != null)		// if no modality, leave it off, no "null"
		{
			ahnold.append(URN.namespaceSpecificStringDelimiter);
			ahnold.append(getImageModality());
		}
		
		return ahnold.toString();
	}
	
	
	@Override
	public P34ImageURN clone() 
	throws CloneNotSupportedException
	{
		try
		{
			return create(getOriginatingSiteId(), getImageId(), getStudyId(), getPatientId(), getArtifactIenAbs(),
					getArtifactIenFull(), getImageModality());
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
	}
	
	@Override
	public String getImagingIdentifier()
	{
		String imageIEN = getImageId();
		if(isNewDataStructure()){
			imageIEN = NEWDATASTRUCTURE_PREFIX + imageIEN;
		}
		return imageIEN;
	}
	
	public P34StudyURN getParentStudyURN() 
	throws URNFormatException
	{
		P34StudyURN studyUrn =
				StudyURNFactory.create(getOriginatingSiteId(), getStudyId(), getPatientId(), P34StudyURN.class);
		studyUrn.setPatientIdentifierTypeIfNecessary(getPatientIdentifierType());
		return studyUrn;
	}

	@Override
	protected int getPatientIdentifierTypeAdditionalIdentifierIndex()
	{
		return ADDITIONAL_IDENTIFIER_PATIENT_IDENTIFIER_TYPE_INDEX;
	}
	
	public P34ImageURN cloneWithNewSite(String newOriginatingSiteId)
	throws CloneNotSupportedException
	{
		try
		{
			P34ImageURN urn = create(newOriginatingSiteId, getImageId(), getStudyId(), getPatientId(), 
									getArtifactIenAbs(), getArtifactIenFull(), getImageModality());
			urn.setPatientIdentifierTypeIfNecessary(this.getPatientIdentifierType());
			return urn;
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
	}

	public String getArtifactIenFull() {
		return artifactIenFull;
	}

	public void setArtifactIenFull(String artifactIenFull) {
		this.artifactIenFull = artifactIenFull;
	}

	public String getArtifactIenAbs() {
		return artifactIenAbs;
	}

	public void setArtifactIenAbs(String artifactIenAbs) {
		this.artifactIenAbs = artifactIenAbs;
	}
	
	

	/*
	public String getDiskIenFull() {
		return diskIenFull;
	}

	public void setDiskIenFull(String diskIenFull) {
		this.diskIenFull = diskIenFull;
	}

	public String getDiskIenAbs() {
		return diskIenAbs;
	}

	public void setDiskIenAbs(String diskIenAbs) {
		this.diskIenAbs = diskIenAbs;
	}

	public String getFilenameFull() {
		return filenameFull;
	}

	public void setFilenameFull(String filenameFull) {
		this.filenameFull = filenameFull;
	}

	public String getFilenameAbs() {
		return filenameAbs;
	}

	public void setFilenameAbs(String filenameAbs) {
		this.filenameAbs = filenameAbs;
	}
	*/
	
	
	
}
