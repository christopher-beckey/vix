	package gov.va.med.imaging.router.commands;

	import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.List;

	/**
	 * @author vhaisltjahjb
	 */

	public class PostViewerStudiesForQaReviewCommandImpl 
	extends AbstractStudyCommandImpl<List<Study>>
	{
		private static final long serialVersionUID = -7605009044618118407L;
		private final RoutingToken routingToken;
		private final StudyFilter filter;
		
		public PostViewerStudiesForQaReviewCommandImpl(
				RoutingToken routingToken, 
				StudyFilter filter)
		{
			super();
			this.routingToken = routingToken;
			this.filter = filter;
		}


		public RoutingToken getRoutingToken()
		{
			return this.routingToken;
		}

		public StudyFilter getFilter() {
			return filter;
		}

		/**
		 * @return the siteNumber
		 */
		public String getSiteNumber() {
			return getRoutingToken().getRepositoryUniqueId();
		}
		
		/* (non-Javadoc)
		 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
		 */
		@Override
		public List<Study> callSynchronouslyInTransactionContext()
		throws MethodException, ConnectionException 
		{
			logger.debug("...executing PostViewerStudiesForQaReviewCommandImpl.");
			TransactionContext transactionContext = TransactionContextFactory.get();
			transactionContext.setServicedSource(getRoutingToken().toRoutingTokenString());
			transactionContext.setItemCached(Boolean.FALSE);
			return getStudiesByCprsIdentifiers();
		}
		
		protected List<Study> getStudiesByCprsIdentifiers()
		throws MethodException
		{
			if((getSiteNumber() == null) || (getSiteNumber().length() <= 0))
			{
				throw new MethodException("Missing required site number parameter");
			}
			
			try
			{
				List<Study> studies;
				studies = ImagingContext.getRouter().postViewerStudiesForQaReview(
						getRoutingToken(), 
						getFilter());

                getLogger().info("Got {} studies.", studies == null ? "null" : "" + studies.size());
				// a null Study Set indicates no studies meet the search criteria
				if(studies != null)
				{
					CommonStudyCacheFunctions.cacheStudyList(getCommandContext(), getSiteNumber(), studies);
					return studies;
				}
				else
					return null;
			}
			catch(ConnectionException cX)
			{
				throw new MethodConnectionException(cX);
			}
		}
		
		/* (non-Javadoc)
		 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
		 */
		@Override
		protected String parameterToString() 
		{
			StringBuffer sb = new StringBuffer();
			
			sb.append(this.getRoutingToken());
			sb.append(this.getFilter());		
			
			return sb.toString();
		}

		@Override
		public int hashCode()
		{
			final int prime = 31;
			int result = 1;
			result = prime * result + ((this.routingToken == null) ? 0 : this.routingToken.hashCode());
			return result;
		}

		@Override
		public boolean equals(Object obj)
		{
			if (this == obj)
				return true;
			if (getClass() != obj.getClass())
				return false;
			
			final PostViewerStudiesForQaReviewCommandImpl other = (PostViewerStudiesForQaReviewCommandImpl) obj;
			if (this.routingToken == null)
			{
				if (other.routingToken != null)
					return false;
			}
			else if (!this.routingToken.equals(other.routingToken))
				return false;
			return true;
		}

		
	}
