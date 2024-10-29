/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 17, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.roi.queue;

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
import gov.va.med.imaging.exceptions.ImageURNFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;

import java.io.Serializable;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
@URNType(namespace="exportqueue")
public abstract class AbstractExportQueueURN
extends URN
implements Serializable, GlobalArtifactIdentifier
{

	private static final long serialVersionUID = 1L;
	
	protected String queueId;
	protected String originatingSiteId;
	
	//private static final String namespace = "exportqueue";
	public static final WellKnownOID DEFAULT_HOME_COMMUNITY_ID = WellKnownOID.VA_RADIOLOGY_IMAGE;
	
	private static final String namespaceSpecificStringRegex = 
		"([^-]+)" + 								// the site ID
		URN.namespaceSpecificStringDelimiter +
		"([^-]+)";									// the queue ID 
	private static final Pattern namespaceSpecificStringPattern = Pattern.compile(namespaceSpecificStringRegex);
	private static final int SITE_ID_GROUP = 1;
	private static final int QUEUE_ID_GROUP = 2;
	
	private final static Logger logger = Logger.getLogger(AbstractExportQueueURN.class);

	/*
	private static NamespaceIdentifier namespaceIdentifier = new NamespaceIdentifier(namespace);
	public static synchronized NamespaceIdentifier getManagedNamespace()
	{
		return namespaceIdentifier;
	}*/
	
	/**
	 * Used directly and a pass through for derived classes.
	 * The constructor called by the URN class when a URN derived class
	 * is being created from a String representation.
	 * 
	 * @param components
	 * @throws URNFormatException
	 */
	protected AbstractExportQueueURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
	}
	
	protected AbstractExportQueueURN(NamespaceIdentifier namespaceIdentifier,
			String originatingSiteId, 
			String queueId)
	throws URNFormatException
	{
		super(namespaceIdentifier);
		setOriginatingSiteId(originatingSiteId);
		setQueueId(queueId);
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
		return formatDocumentUniqueId( getQueueId() );
	}

	@Override
	public boolean equalsGlobalArtifactIdentifier(GlobalArtifactIdentifier that)
	{
		return GlobalArtifactIdentifierImpl.equalsGlobalArtifactIdentifier(this, that);
	}

	@Override
	public GlobalArtifactIdentifier clone() 
	throws CloneNotSupportedException
	{
		throw new CloneNotSupportedException("Clone not supported in ExportQueueURN");
	}

	public String getQueueId()
	{
		return queueId;
	}

	public void setQueueId(String queueId)
	{
		this.queueId = queueId;
	}

	public String getOriginatingSiteId()
	{
		return originatingSiteId;
	}

	public void setOriginatingSiteId(String originatingSiteId)
	{
		this.originatingSiteId = originatingSiteId;
	}

	protected static String formatDocumentUniqueId(String queueId)
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(queueId);
		
		return sb.toString();
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
		ahnold.append(this.queueId);		
		
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
			String msg = "Namespace specific string '" + namespaceSpecificString + "' is not valid.";
			logger.warn(msg);
			throw new ImageURNFormatException(msg);
		}
	
		setOriginatingSiteId( nssMatcher.group(SITE_ID_GROUP).trim() );
		setQueueId( nssMatcher.group(AbstractExportQueueURN.QUEUE_ID_GROUP).trim() );
		/*
		switch(serializationFormat)
		{
		case PATCH83_VFTP:
		case RFC2141:
		case VFTP:
		case NATIVE:
		case RAW:
			setQueueId(tmpAnnotationId);
			setImageId(tmpImageId);
			break;
		case CDTP:
			this.annotationId = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpAnnotationId);
			this.imageId = URN.FILENAME_TO_RFC2141_ESCAPING.escapeIllegalCharacters(tmpImageId);
			break;
		}*/
	}
}
