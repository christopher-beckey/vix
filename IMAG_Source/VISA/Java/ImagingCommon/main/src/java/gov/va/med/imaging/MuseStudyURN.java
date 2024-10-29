/**
 * 
 */
package gov.va.med.imaging;

import gov.va.med.NamespaceIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.imaging.exceptions.StudyURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.utility.Base32ConversionUtility;

import gov.va.med.logging.Logger;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author William Peterson
 * 
 * Defines the syntax of a URN used to identify VA studies to the outside world.
 * An StudyURN is defined to be in the following format:
 * "urn" + ":" + "vastudy" + ":" + <site-id> + "-" + <assigned-id> + "-" + <patientICN>
 * where:
 *   <site-id> is either the site from which the image originated or the string "va-imaging"
 *   <assigned-id> is the permanent, immutable ID as assigned by the originating site or a
 *   VA-domain unique ID (an Imaging GUID) 
 *   <patientICN> is the VA Enterprise identifier for the patient of the study
 *
 */
@URNType(namespace="musestudy")
public class MuseStudyURN 
extends StudyURN {

	private static final long serialVersionUID = -5365423670534489054L;

	private static final String namespace = "musestudy";

	private static final String namespaceSpecificStringRegex = 
			"([^-]+)" + 								// the site ID
			URN.namespaceSpecificStringDelimiter +
			"([^-]+)" +									// the group or study ID 
			URN.namespaceSpecificStringDelimiter + 
			"([^-]+)" +									// the patient ID 
			URN.namespaceSpecificStringDelimiter + 
			"([^-]+)";									// the Muse Server ID 
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);
	private static final int MUSE_SERVER_GROUP = 4;
	
	
	protected static NamespaceIdentifier namespaceIdentifier = new NamespaceIdentifier(namespace);
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		return namespaceIdentifier;
	}

	static
	{
		System.out.println("MuseStudyURN regular expression is '" + namespaceSpecificStringRegex + "'.");
	}

	private final static Logger logger = Logger.getLogger(MuseStudyURN.class);

	/**
	 * @param originatingSiteId
	 * @param assignedId
	 * @param patientId
	 * @param isNewDataStructure
	 * @return
	 */
	public static MuseStudyURN create(String originatingSiteId, String assignedId, String patientId, String museServerId)
	throws URNFormatException
	{
		return new MuseStudyURN(originatingSiteId, assignedId, patientId, museServerId);
	}
	
	/**
	 * 
	 * @param urnComponents
	 * @return
	 * @throws URNFormatException
	 */
	public static MuseStudyURN create(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		try
		{
			return new MuseStudyURN(urnComponents, serializationFormat);
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
	public static MuseStudyURN createFromBase32(URNComponents urnComponents) 
	throws URNFormatException
	{
		try
		{
			return new MuseStudyURN(urnComponents, SERIALIZATION_FORMAT.PATCH83_VFTP);
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

	private String museServerId;

	/**
	 * @param nid
	 * @throws URNFormatException
	 */
	protected MuseStudyURN(NamespaceIdentifier nid) throws URNFormatException {
		super(nid);
		setMuse(true);
	}
	
	/**
	 * Provided only as a pass through for derived classes.
	 * 
	 */
	protected MuseStudyURN(
		NamespaceIdentifier namespaceIdentifier, 
		String namespaceSpecificString, 
		String... additionalIdentifiers) 
	throws URNFormatException
	{
		super(namespaceIdentifier, namespaceSpecificString, additionalIdentifiers);
		setMuse(true);
	}
	
	/**
	 * Used directly and a pass through for derived classes.
	 * The constructor called by the URN class when a URN derived class
	 * is being created from a String representation.
	 * 
	 * @param components
	 * @throws URNFormatException
	 */
	protected MuseStudyURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
		setMuse(true);
	}


	/**
	 * 
	 * @param originatingSiteId
	 * @param studyId
	 * @param patientId
	 * @param isNewDataStructure
	 * @throws URNFormatException
	 */
	protected MuseStudyURN(
		String originatingSiteId, 
		String studyId, 
		String patientId,
		String museServerId)
	throws URNFormatException
	{
		this(MuseStudyURN.getManagedNamespace(), originatingSiteId, studyId, patientId, museServerId);
		setMuse(true);
	}
	
	/**
	 * 
	 * @param originatingSiteId
	 * @param studyId
	 * @param patientId
	 * @throws URNFormatException
	 */
	protected MuseStudyURN(
		String originatingSiteId, 
		String studyId, 
		String patientId)
	throws URNFormatException
	{
		this(StudyURN.getManagedNamespace(), originatingSiteId, studyId, patientId);
		setMuse(true);
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
	protected MuseStudyURN(
		NamespaceIdentifier namespaceIdentifier,
		String originatingSiteId, 
		String studyId, 
		String patientId)
	throws URNFormatException
	{
		super(namespaceIdentifier);
		setMuse(true);

		setOriginatingSiteId(originatingSiteId);
		
		setStudyId(studyId);
		
		setPatientId(patientId);
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
	protected MuseStudyURN(
		NamespaceIdentifier namespaceIdentifier,
		String originatingSiteId, 
		String studyId, 
		String patientId,
		String museServerId)
	throws URNFormatException
	{
		super(namespaceIdentifier);
		setMuse(true);

		setOriginatingSiteId(originatingSiteId);
		
		setStudyId(studyId);
		
		setPatientId(patientId);
		
		setMuseServerId(museServerId);
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
	
		setOriginatingSiteId( nssMatcher.group(MuseStudyURN.SITE_ID_GROUP).trim() );
		setPatientId( nssMatcher.group(MuseStudyURN.PATIENT_ID_GROUP).trim() );
		String tmpStudyId = nssMatcher.group(MuseStudyURN.GROUP_ID_GROUP).trim();
		
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
		
		setMuseServerId(nssMatcher.group(MuseStudyURN.MUSE_SERVER_GROUP).trim());

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
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(getMuseServerId());
		
		
		return ahnold.toString();
	}

	
	@Override
	public String getImagingIdentifier()
	{
		String studyIEN = getStudyId();
		if(isMuse()){
			studyIEN = MUSE_PREFIX + studyIEN;
		}
		return studyIEN;
	}

	
	@Override
	public MuseStudyURN clone() 
	throws CloneNotSupportedException
	{
		try
		{
			return create(getOriginatingSiteId(), getStudyId(), getPatientId(), getMuseServerId());
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
		return MuseStudyURN.namespaceIdentifier;
	}
	
	public String getMuseServerId(){
		return this.museServerId;
	}
	
	public void setMuseServerId(String museServerId){
		this.museServerId = museServerId;
	}

}
