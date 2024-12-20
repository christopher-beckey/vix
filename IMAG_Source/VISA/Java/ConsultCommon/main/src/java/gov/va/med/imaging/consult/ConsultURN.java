/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierImpl;
import gov.va.med.NamespaceIdentifier;
import gov.va.med.PatientArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.URNType;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.AbstractPatientURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.ImageURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;

import java.io.Serializable;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Julian Werfel
 *
 */
@URNType(namespace="consult")
public class ConsultURN
extends AbstractPatientURN
implements Serializable, PatientArtifactIdentifier
{
	private static final long serialVersionUID = 1L;
	
	protected String patientId;
	protected String consultId;
	protected String originatingSiteId;
	
	private static final String namespace = "consult";
	public static final WellKnownOID DEFAULT_HOME_COMMUNITY_ID = WellKnownOID.VA_RADIOLOGY_IMAGE;
	
	private static final String namespaceSpecificStringRegex = 
		"([^-]+)" + 								// the site ID
		URN.namespaceSpecificStringDelimiter +
		"([^-]+)" +									// the consult ID
		URN.namespaceSpecificStringDelimiter + 
		"([^-]+)";									// the patient ID 
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);
	private static final int SITE_ID_GROUP = 1;
	private static final int CONSULT_ID_GROUP = 2;
	private static final int PATIENT_ID_GROUP = 3;
	
	private static NamespaceIdentifier namespaceIdentifier = new NamespaceIdentifier(namespace);
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		return namespaceIdentifier;
	}
	
	public static ConsultURN create(String originatingSiteId, 
		String consultId, PatientIdentifier patientIdentifier)
	throws URNFormatException
	{
		ConsultURN urn = create(originatingSiteId, consultId, patientIdentifier.getValue());
		urn.setPatientIdentifierTypeIfNecessary(patientIdentifier.getPatientIdentifierType());
		return urn;
	}
	
	
	public static ConsultURN create(String originatingSiteId, 
			String consultId, String patientId)
	throws URNFormatException
	{	
		return new ConsultURN(ConsultURN.getManagedNamespace(),
				originatingSiteId, consultId, patientId);
	}
	
	public static ConsultURN create(URNComponents urnComponents, 
			SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		return new ConsultURN(urnComponents, serializationFormat);
	}
	
	/**
	 * Used directly and a pass through for derived classes.
	 * The constructor called by the URN class when a URN derived class
	 * is being created from a String representation.
	 * 
	 * @param components
	 * @throws URNFormatException
	 */
	protected ConsultURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
	}
	
	protected ConsultURN(NamespaceIdentifier namespaceIdentifier,
			String originatingSiteId, 
			String consultId, 
			String patientId)
	throws URNFormatException
	{
		super(namespaceIdentifier);
		setOriginatingSiteId(originatingSiteId);
		setConsultId(consultId);
		setPatientId(patientId);
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
	public String getDocumentUniqueId()
	{
		return formatDocumentUniqueId( getConsultId(), getPatientId() );
	}

	@Override
	public boolean equalsGlobalArtifactIdentifier(GlobalArtifactIdentifier that)
	{
		return GlobalArtifactIdentifierImpl.equalsGlobalArtifactIdentifier(this, that);
	}

	@Override
	public String getPatientIdentifier()
	{
		return getPatientId();
	}

	@Override
	public ConsultURN clone() 
	throws CloneNotSupportedException
	{
		try
		{
			ConsultURN consultUrn = create(getOriginatingSiteId(), getConsultId(), 
					getPatientId());
			consultUrn.setPatientIdentifierTypeIfNecessary(getPatientIdentifierType());
			return consultUrn;
		} 
		catch (URNFormatException e)
		{
			throw new CloneNotSupportedException(e.getMessage());
		}
	}

	public String getPatientId()
	{
		return patientId;
	}

	public void setPatientId(String patientId)
	{
		this.patientId = patientId;
	}

	/**
	 * @return the consultId
	 */
	public String getConsultId()
	{
		return consultId;
	}

	/**
	 * @param consultId the consultId to set
	 */
	public void setConsultId(String consultId)
	{
		this.consultId = consultId;
	}

	public String getOriginatingSiteId()
	{
		return originatingSiteId;
	}

	public void setOriginatingSiteId(String originatingSiteId)
	{
		this.originatingSiteId = originatingSiteId;
	}

	protected static String formatDocumentUniqueId(String consultId, String patientId)
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(consultId);
		sb.append(URN.namespaceSpecificStringDelimiter);
		sb.append(patientId);
		
		return sb.toString();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.URN#toString()
	 */
	@Override
	public String toString()
	{
		return toString(SERIALIZATION_FORMAT.RAW);
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
		ahnold.append(this.consultId);
		ahnold.append(URN.namespaceSpecificStringDelimiter);
		ahnold.append(this.patientId);
		
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
			throw new ImageURNFormatException(cleanMsg);
		}
	
		setOriginatingSiteId( nssMatcher.group(SITE_ID_GROUP).trim() );
		setPatientId( nssMatcher.group(ConsultURN.PATIENT_ID_GROUP).trim() );
		setConsultId(nssMatcher.group(ConsultURN.CONSULT_ID_GROUP).trim() );		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.AbstractPatientURN#getPatientIdentifierTypeAdditionalIdentifierIndex()
	 */
	@Override
	protected int getPatientIdentifierTypeAdditionalIdentifierIndex()
	{
		return 0;
	}

}