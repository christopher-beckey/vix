/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 25, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.federation.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaiswwerfej
 *
 */
@XmlRootElement
public class FederationDocumentSetResultType
{
	private FederationArtifactResultStatusType artifactResultStatus;
	private FederationArtifactResultErrorType [] errors;
	private FederationDocumentSetType [] documentSets;
	
	public FederationDocumentSetResultType()
	{
		super();
	}

	public FederationArtifactResultStatusType getArtifactResultStatus()
	{
		return artifactResultStatus;
	}

	public void setArtifactResultStatus(
			FederationArtifactResultStatusType artifactResultStatus)
	{
		this.artifactResultStatus = artifactResultStatus;
	}

	public FederationArtifactResultErrorType[] getErrors()
	{
		return errors;
	}

	public void setErrors(FederationArtifactResultErrorType[] errors)
	{
		this.errors = errors;
	}

	public FederationDocumentSetType[] getDocumentSets()
	{
		return documentSets;
	}

	public void setDocumentSets(FederationDocumentSetType[] documentSets)
	{
		this.documentSets = documentSets;
	}

	public int getArtifactSize()
	{
		return (this.documentSets == null) ?  0 : this.documentSets.length;
	}
}
