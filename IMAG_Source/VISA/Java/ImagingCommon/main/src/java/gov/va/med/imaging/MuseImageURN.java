package gov.va.med.imaging;

import gov.va.med.NamespaceIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.StudyURNFactory;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.exceptions.ImageURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.utility.Base32ConversionUtility;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


@URNType(namespace="museimage")
public class MuseImageURN 
extends ImageURN {

	private static final long serialVersionUID = -7616723084757942356L;
	private static final String NAMESPACE = "museimage";
	
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
		"([^-]+)" +									// the muse server ID 
		"(?:" + URN.namespaceSpecificStringDelimiter + ")?" + 
		"([^-]+)?";									// the optional modality
	
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);
	private static final int MUSE_SERVER_GROUP = 5;
	private static final int MODALITY_GROUP = 6;


	static
	{
		System.out.println("MuseImageURN NSS regular expression is '" + namespaceSpecificStringRegex + "'.");
	}
	
	/**
	 * 
	 * @param originatingSiteId - if the site ID is '200' then the returned instance will be
	 *                            a BhieImageURN
	 * @param assignedId
	 * @param studyId
	 * @param patientIcn
	 * @param imageModality
	 * @return
	 * @throws ImageURNFormatException
	 */
	public static MuseImageURN create(
		String originatingSiteId, 
		String assignedId, 
		String studyId,
		String patientIcn,
		String museServerId) 
	throws URNFormatException
	{
		return new MuseImageURN(originatingSiteId, assignedId, studyId, patientIcn, museServerId, null);		
	}
	
	public static MuseImageURN create(
			String originatingSiteId, 
			String assignedId, 
			String studyId,
			String patientIcn,
			String museServerId,
			String modality) 
		throws URNFormatException
		{
			return new MuseImageURN(originatingSiteId, assignedId, studyId, patientIcn, museServerId, modality);		
		}

	/**
	 * Create a DocumentURN instance from an ImageURN.
	 * This provide the translation within the datasource, using the same
	 * RPCs as image retrieval and presenting results in Document semantics.
	 * @param documentUrn
	 * @return
	 * @throws URNFormatException
	 */
	/**
	public static MuseImageURN create(DocumentURN documentUrn)
	throws URNFormatException
	{
		return create(
			documentUrn.getOriginatingSiteId(),
			documentUrn.getDocumentId(),
			documentUrn.getDocumentSetId(), 
			documentUrn.getPatientId()
		);
	}
	**/
	
	/**
	 * 
	 * @param urnComponents
	 * @return
	 * @throws URNFormatException
	 */
	public static MuseImageURN create(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		return new MuseImageURN(urnComponents, serializationFormat);
	}
		

	/**
	 * 
	 */
	public static MuseImageURN createFromGlobalArtifactIdentifiers(
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
	public static MuseImageURN createFromGlobalArtifactIdentifiers(
		String homeCommunityId, 
		String repositoryId, 
		String documentId,
		String... additionalIdentifiers)
	throws URNFormatException
	{
		if( MuseImageURN.isApplicableHomeCommunityId(homeCommunityId, repositoryId, documentId) )
			return new MuseImageURN( repositoryId, documentId );
		else
			throw new URNFormatException("Home community ID '" + homeCommunityId + "' cannot be used to create an ImageURN or its derivatives.");
	}

	public static Matcher getNamespaceSpecificStringMatcher(CharSequence input)
	{
		return MuseImageURN.namespaceSpecificStringPattern.matcher(input);
	}
	
	private String museServerId;

	/**
	 * Provided only as a pass through for derived classes.
	 * 
	 * @param nid
	 * @throws URNFormatException
	 */
	protected MuseImageURN(NamespaceIdentifier nid) 
	throws URNFormatException
	{
		super(nid);
	}
	
	/**
	 * Provided only as a pass through for derived classes.
	 * 
	 */
	protected MuseImageURN(
		NamespaceIdentifier namespaceIdentifier, 
		String namespaceSpecificString, 
		String... additionalIdentifiers) 
	throws URNFormatException
	{
		super(namespaceIdentifier, namespaceSpecificString, additionalIdentifiers);
	}
	
	/**
	 * Used directly and a pass through for derived classes.
	 * The constructor called by the URN class when a URN derived class
	 * is being created from a String representation.
	 * 
	 * @param components
	 * @throws URNFormatException
	 */
	protected MuseImageURN(URNComponents urnComponents, SERIALIZATION_FORMAT serialFormat) 
	throws URNFormatException
	{
		super(urnComponents, serialFormat);
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
	private MuseImageURN(
		String originatingSiteId, 
		String assignedId, 
		String studyId, 
		String patientId,
		String museServerId,
		String imageModality) 
	throws URNFormatException 
	{
		super(MuseImageURN.getManagedNamespace());
		
		originatingSiteId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(originatingSiteId);
		assignedId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(assignedId);
		studyId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(studyId);
		patientId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(patientId);
		imageModality = URN.RFC2141_ESCAPING.escapeIllegalCharacters(imageModality);
		museServerId = URN.RFC2141_ESCAPING.escapeIllegalCharacters(museServerId);

		
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

		if( !AbstractImagingURN.groupIdPattern.matcher(museServerId).matches() )
			throw new URNFormatException("The Muse Server ID '" + museServerId + "' does not match the pattern '" + AbstractImagingURN.groupIdPattern.pattern());
		this.museServerId = museServerId;

		if(imageModality != null && imageModality.length() <= 0)
			imageModality = null;
		if( imageModality != null && !AbstractImagingURN.modalityPattern.matcher(imageModality).matches() )
			throw new URNFormatException("The modality '" + imageModality + "' does not match the pattern '" + AbstractImagingURN.modalityPattern.pattern());
		this.imageModality = imageModality;
		

		}
	
	/**
	 * Constructor from the GAI (IHE) identifiers
	 * 
	 * @param repositoryUniqueId
	 * @param documentId
	 * @throws URNFormatException 
	 */
	private MuseImageURN(String repositoryUniqueId, String assignedId) 
	throws URNFormatException
	{
		super(ImageURN.getManagedNamespace());
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
			throw new ImageURNFormatException(msg);
		}
	
		this.originatingSiteId = nssMatcher.group(SITE_ID_GROUP).trim();
		String tmpInstanceId = nssMatcher.group(INSTANCE_ID_GROUP).trim();
		String tmpGroupId = nssMatcher.group(GROUP_ID_GROUP).trim();

		switch(serializationFormat)
		{
		case PATCH83_VFTP:
			setGroupId( Base32ConversionUtility.base32Decode(tmpGroupId) );
			setInstanceId( Base32ConversionUtility.base32Decode(tmpInstanceId) );
			break;
		case RFC2141:
			this.groupId = tmpGroupId;
			this.instanceId = tmpInstanceId;
			break;
		case VFTP:
			this.groupId = tmpGroupId;
			this.instanceId = tmpInstanceId;
			break;
		case RAW:
			this.groupId = tmpGroupId;
			this.instanceId = tmpInstanceId;
			break;
		case CDTP:
			this.groupId = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpGroupId);
			this.instanceId = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpInstanceId);
			break;
		case NATIVE:
			setGroupId(tmpGroupId);
			setInstanceId(tmpInstanceId);
			break;
		}

		this.patientId = URN.RFC2141_ESCAPING.escapeIllegalCharacters( nssMatcher.group(PATIENT_ID_GROUP).trim() );
		this.museServerId = nssMatcher.group(MUSE_SERVER_GROUP).trim();
		
		if(nssMatcher.group(MODALITY_GROUP) != null)
			this.imageModality = URN.RFC2141_ESCAPING.escapeIllegalCharacters( 
				nssMatcher.group(MODALITY_GROUP).trim().length() > 0 ? nssMatcher.group(MODALITY_GROUP).trim() : null );
		else
			this.imageModality = null;
	}


	@Override
	public NamespaceIdentifier getNamespaceIdentifier()
	{
		return MuseImageURN.getManagedNamespace();
	}
	
	@Override
	public String getImagingIdentifier()
	{
		String imageIEN = getImageId();
		if(isMuse()){
			imageIEN = MUSE_PREFIX + imageIEN;
		}
		return imageIEN;
	}

	

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
		MuseImageURN other = (MuseImageURN) obj;
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
		ahnold.append(MuseImageURN.getManagedNamespace().toString());
		ahnold.append(urnComponentDelimiter);
		ahnold.append(getOriginatingSiteId());
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(this.getInstanceId()) );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(this.getGroupId()) );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( getPatientId() );
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(getMuseServerId());
		if(getImageModality() != null)
		{
			ahnold.append(URN.namespaceSpecificStringDelimiter);
			ahnold.append( getImageModality() );
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
		ahnold.append( this.getMuseServerId());
		if(getImageModality() != null)
		{
			ahnold.append(URN.namespaceSpecificStringDelimiter);
			ahnold.append( getImageModality() );
		}
		return ahnold.toString();
	}

	@Override
	public MuseImageURN clone() 
	throws CloneNotSupportedException
	{
		try
		{
			return create(getOriginatingSiteId(), getImageId(), getStudyId(), getPatientId(), getMuseServerId(), getImageModality() );
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
	}
	
	public MuseStudyURN getParentStudyURN() 
	throws URNFormatException
	{
		MuseStudyURN studyUrn =
				StudyURNFactory.create(getOriginatingSiteId(), getStudyId(), 
						getPatientId(), getMuseServerId(), MuseStudyURN.class);
		studyUrn.setPatientIdentifierTypeIfNecessary(getPatientIdentifierType());
		return studyUrn;
	}

	private void parseDocumentUniqueIdIntoFields(String documentId)
	throws GlobalArtifactIdentifierFormatException
	{
		String[] components = parseDocumentUniqueId(documentId);
		instanceId = components[0];
		groupId = components[1];
		patientId = components[2];
	}

	public String getMuseServerId(){
		return this.museServerId;
	}
	
	public void setMuseServerId(String museServerId){
		this.museServerId = museServerId;
	}

}
