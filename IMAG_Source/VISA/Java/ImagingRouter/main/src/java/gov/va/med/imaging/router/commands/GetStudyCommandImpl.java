/**
 * 
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * A command to get a List of Study instances:
 * 1.) from a single Site
 * 2.) related to a single patient
 * 3.) meeting the criteria of the given StudyFilter instance
 * 
 * @author vhaiswbeckec
 *
 */
public class GetStudyCommandImpl 
extends AbstractStudyCommandImpl<Study> {
	private static final long serialVersionUID = -4963797794965394068L;
	
	private final GlobalArtifactIdentifier studyId;
	private final boolean includeDeletedImages;
	private final StudyFilter studyFilter;
	
	/**
	 * @param GlobalArtifactIdentifier		study Id
	 */
	public GetStudyCommandImpl(GlobalArtifactIdentifier studyId) {
		this(studyId, false, null);
	}
	
	/**
	 * @param GlobalArtifactIdentifier		study Id
	 * @param boolean						include delete images flag
	 */
	public GetStudyCommandImpl(GlobalArtifactIdentifier studyId, boolean includeDeletedImages)	{
		this(studyId, includeDeletedImages, null);
	}

	/**
	 * @param GlobalArtifactIdentifier		study Id
	 * @param StudyFilter 					study filter object
	 */
	public GetStudyCommandImpl(GlobalArtifactIdentifier studyId, StudyFilter studyFilter) {
		this(studyId, false, studyFilter);
	}

	/**
	 * @param GlobalArtifactIdentifier		study Id
	 * @param boolean						include delete images flag
	 * @param StudyFilter					StudyFilter object			
	 */
	public GetStudyCommandImpl(GlobalArtifactIdentifier studyId, boolean includeDeletedImages, StudyFilter studyFilter)	{
		super();
		this.studyId = studyId;
		this.includeDeletedImages = includeDeletedImages;
		this.studyFilter = studyFilter;
	}

	public GlobalArtifactIdentifier getStudyIdentifier() {
		return this.studyId;
	}

	public boolean isIncludeDeletedImages() {
		return this.includeDeletedImages;
	}
	
	public StudyFilter getStudyFilter()	{
		return this.studyFilter;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#parameterToString()
	 */
	@Override
	protected String parameterToString() {
		StringBuilder sb = new StringBuilder();
		
		sb.append(this.getStudyIdentifier());
		sb.append(this.isIncludeDeletedImages());
		sb.append(this.studyFilter.toString());
		
		return sb.toString();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#callInTransactionContext()
	 */
	@Override
	public Study callSynchronouslyInTransactionContext()
	throws MethodException {
		TransactionContextFactory.get().setServicedSource(studyId.toRoutingTokenString());
		logger.info("GetStudyCommandImpl.callSync() --> studyFilter --> " + getStudyFilter());
		return (studyFilter == null ? this.getPatientStudy(getStudyIdentifier(), isIncludeDeletedImages())
								    : this.getPatientStudy(getStudyIdentifier(), isIncludeDeletedImages(), getStudyFilter()));
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.studyId == null) ? 0 : this.studyId.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		final GetStudyCommandImpl other = (GetStudyCommandImpl) obj;
		if (this.studyId == null) {
			if (other.studyId != null)
				return false;
		} else if (!this.studyId.equals(other.studyId)) return false;
		return true;
	}
}
