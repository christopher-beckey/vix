/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib.document;

import java.util.Collection;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import gov.va.med.imaging.exchange.business.ArtifactResultError;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;

/**
 * @author vhaiswbeckec
 *
 */
public class PatientArtifactResultErrorCollectionTag
extends AbstractArtifactResultErrorCollectionTag
{
	private static final long serialVersionUID = 1L;
	
	protected AbstractDocumentSetResultTag getParentTag()
	{
		return (AbstractDocumentSetResultTag)TagSupport.findAncestorWithClass(this, AbstractDocumentSetResultTag.class);
	}
	
	protected DocumentSetResult getBusinessObject() 
	throws JspException
	{
		return getParentTag().getBusinessObject();
	}
	
	/**
	 * The method that actually gets the data from the router.
	 * @see gov.va.med.imaging.exchange.business.taglib.document.AbstractDocumentSetCollectionTag#getCollection()
	 */
	@Override
	protected Collection<ArtifactResultError> getCollection() 
	throws JspException
	{
		return getBusinessObject().getArtifactResultErrors();
	}
}
