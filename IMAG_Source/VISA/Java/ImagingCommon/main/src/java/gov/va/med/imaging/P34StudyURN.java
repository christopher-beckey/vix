/**
 * 
 */
package gov.va.med.imaging;

import gov.va.med.NamespaceIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.exceptions.StudyURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.utility.Base32ConversionUtility;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import gov.va.med.logging.Logger;


/**
 * @author William Peterson
 * 
 * Defines the syntax of a URN used to identify VA P34 new data Structure studies to the outside world.
 * An P34StudyURN is defined to be in the following format:
 * "urn" + ":" + "vap34study" + ":" + <site-id> + "-" + <assigned-id> + "-" + <patientICN>
 * where:
 *   <site-id> is either the site from which the image originated or the string "va-imaging"
 *   <assigned-id> is the permanent, immutable ID as assigned by the originating site or a
 *   VA-domain unique ID (an Imaging GUID) 
 *   <patientICN> is the VA Enterprise identifier for the patient of the study
 *
 */
@URNType(namespace="vap34study")
public class P34StudyURN 
extends StudyURN {

	private static final long serialVersionUID = -4386051423181803748L;
	
	private static final String namespace = "vap34study";

	private static final String namespaceSpecificStringRegex = 
		"([^-]+)" + 								// the site ID
		URN.namespaceSpecificStringDelimiter +
		"([^-]+)" +									// the group or study ID 
		URN.namespaceSpecificStringDelimiter + 
		"([^-]+)";									// the patient ID 
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);

	protected static NamespaceIdentifier namespaceIdentifier = new NamespaceIdentifier(namespace);
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		return namespaceIdentifier;
	}

	static
	{
		System.out.println("P34StudyURN regular expression is '" + namespaceSpecificStringRegex + "'.");
	}

	private final static Logger logger = Logger.getLogger(P34StudyURN.class);

	/**
	 * @param originatingSiteId
	 * @param assignedId
	 * @param patientId
	 * @param isNewDataStructure
	 * @return
	 */
	public static P34StudyURN create(String originatingSiteId, String assignedId, String patientId)
	throws URNFormatException
	{
		return new P34StudyURN(originatingSiteId, assignedId, patientId);
	}
	
	/**
	 * 
	 * @param urnComponents
	 * @return
	 * @throws URNFormatException
	 */
	public static P34StudyURN create(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		try
		{
			return new P34StudyURN(urnComponents, serializationFormat);
		}
		catch(URNFormatException urnfX)
		{
			// if the study URN originating Site ID is site 200 then this is really a BHIE URN,
			// ClinicalDisplay does not recognize anything but VA URNs, this kludge insulates
			// the rest of the system from that.
			// If this isn't a BHIE study URN then throw the original exception.
			//try{return BhieStudyURN.create(urnComponents, serializationFormat);}
			//catch(URNFormatException urnfX2){throw urnfX;}
			throw urnfX;
		}
	}
	
	/**
	 * 
	 * @param urnComponents
	 * @return
	 * @throws URNFormatException
	 */
	public static P34StudyURN createFromBase32(URNComponents urnComponents) 
	throws URNFormatException
	{
		try
		{
			return new P34StudyURN(urnComponents, SERIALIZATION_FORMAT.PATCH83_VFTP);
		}
		catch(URNFormatException urnfX)
		{
			// if the study URN originating Site ID is site 200 then this is really a BHIE URN,
			// ClinicalDisplay does not recognize anything but VA URNs, this kludge insulates
			// the rest of the system from that.
			//return BhieStudyURN.createFromBase32(urnComponents);
			throw urnfX;
		}
	}

	
	/**
	 * 
	 * @param homeCommunityId
	 * @param repositoryId
	 * @param documentId
	 * @return
	 * @throws URNFormatException
	 */
	public static P34StudyURN createFromGlobalArtifactIdentifiers(
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
	public static P34StudyURN createFromGlobalArtifactIdentifiers(
		String homeCommunityId, 
		String repositoryId, 
		String documentId,
		String... additionalIdentifiers)
	throws URNFormatException
	{
		if( P34StudyURN.isApplicableHomeCommunityId(homeCommunityId, repositoryId, documentId) )
			return new P34StudyURN( repositoryId, documentId );
		else
			throw new URNFormatException("Home community ID '" + homeCommunityId + "' cannot be used to create an ImageURN or its derivatives.");
	}


	/**
	 * @param nid
	 * @throws URNFormatException
	 */
	protected P34StudyURN(NamespaceIdentifier nid) throws URNFormatException {
		super(nid);
		setNewDataStructure(true);
	}
	
	/**
	 * Provided only as a pass through for derived classes.
	 * 
	 */
	protected P34StudyURN(
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
	protected P34StudyURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
		setNewDataStructure(true);
	}


	/**
	 * 
	 * @param originatingSiteId
	 * @param studyId
	 * @param patientId
	 * @param isNewDataStructure
	 * @throws URNFormatException
	 */
	protected P34StudyURN(
		String originatingSiteId, 
		String studyId, 
		String patientId)
	throws URNFormatException
	{
		this(P34StudyURN.getManagedNamespace(), originatingSiteId, studyId, patientId);
		setNewDataStructure(true);
	}
	
	/**
	 * Defined to allow passthrough from derived classes
	 * 
	 * @param namespaceIdentifier
	 * @param originatingSiteId
	 * @param studyId
	 * @param patientId
	 * @throws URNFormatException
	 */
	protected P34StudyURN(
		NamespaceIdentifier namespaceIdentifier,
		String originatingSiteId, 
		String studyId, 
		String patientId)
	throws URNFormatException
	{
		super(namespaceIdentifier);
		setNewDataStructure(true);

		setOriginatingSiteId(originatingSiteId);
		
		setStudyId(studyId);
		
		setPatientId(patientId);
	}

	/**
	 * 
	 * @param repositoryUniqueId
	 * @param documentId
	 * @throws URNFormatException
	 */
	protected P34StudyURN(String repositoryUniqueId, String documentId) 
	throws URNFormatException
	{
		this(StudyURN.getManagedNamespace(), repositoryUniqueId, documentId);
	}

	/**
	 * Constructor from the GAI (IHE) identifiers
	 * 
	 * @param repositoryUniqueId
	 * @param documentId
	 * @throws URNFormatException 
	 */
	protected P34StudyURN(NamespaceIdentifier namespaceIdentifier, String repositoryUniqueId, String documentId) 
	throws URNFormatException
	{
		super(namespaceIdentifier);
		try
		{
			this.originatingSiteId = repositoryUniqueId;
			parseDocumentUniqueId(documentId);
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
	 * @throws URNFormatException 
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
			throw new StudyURNFormatException(msg);
		}
	
		setOriginatingSiteId( nssMatcher.group(P34StudyURN.SITE_ID_GROUP).trim() );
		setPatientId( nssMatcher.group(P34StudyURN.PATIENT_ID_GROUP).trim() );
		String tmpStudyId = nssMatcher.group(P34StudyURN.GROUP_ID_GROUP).trim();
		switch(serializationFormat)
		{
		case PATCH83_VFTP:
			setStudyId( Base32ConversionUtility.base32Decode(tmpStudyId));
			break;
		case RFC2141:
		case VFTP:
		case NATIVE:
		case RAW:
			setStudyId(tmpStudyId);
			break;
		case CDTP:
			setStudyId(URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpStudyId));
			break;
		}
	}

	/**
	 * 
	 */
	@Override
	public String getNamespaceSpecificString(SERIALIZATION_FORMAT serializationFormat)
	{
		StringBuilder ahnold = new StringBuilder();
		
		// build the namespace specific string
		ahnold.append(getOriginatingSiteId());
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(getStudyId());
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(getPatientId());
		
		return ahnold.toString();
	}

	@Override
	public String getImagingIdentifier()
	{
		String studyIEN = getStudyId();
		if(isNewDataStructure()){
			studyIEN = NEWDATASTRUCTURE_PREFIX + studyIEN;
		}
		return studyIEN;
	}
	
	@Override
	public P34StudyURN clone() 
	throws CloneNotSupportedException
	{
		try
		{
			return create(getOriginatingSiteId(), getStudyId(), getPatientId());
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
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
		ahnold.append(this.getNamespaceIdentifier().getNamespace());
		ahnold.append(urnComponentDelimiter);
		ahnold.append(getOriginatingSiteId());
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append( SERIALIZATION_FORMAT.PATCH83_VFTP.serialize(this.getGroupId()) );
		if(getPatientId() != null)
		{
			ahnold.append(URN.namespaceSpecificStringDelimiter);
			ahnold.append( this.getPatientId() );
		}
		
		return ahnold.toString();
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

	@Override
	public NamespaceIdentifier getNamespaceIdentifier()
	{
		return P34StudyURN.namespaceIdentifier;
	}



}
