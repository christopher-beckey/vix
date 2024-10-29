	/**
	 * 
	  Package: MAG - VistA Imaging
	  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
	  Date Created: Jan 9, 2017
	  Site Name:  Washington OI Field Office, Silver Spring, MD
	  Developer:  vhaisltjahjb
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
	 * Command to retrieve a study from a given CPRS identifier from a specific site.
	 * 
	 * @author vhaisltjahjb
	 *
	 */
	public class PostStudiesByCprsIdentifiersCommandImpl 
	extends AbstractStudyCommandImpl<List<Study>>
	{
		private static final long serialVersionUID = 8260267630760877164L;
		private final RoutingToken routingToken;
		private final List<CprsIdentifier> cprsIdentifiers;
		private final PatientIdentifier patientIdentifier;
		
		public PostStudiesByCprsIdentifiersCommandImpl(
				PatientIdentifier patientIdentifier, 
				RoutingToken routingToken,
				List<CprsIdentifier> cprsIdentifiers)
		{
			super();
			this.cprsIdentifiers = cprsIdentifiers;
			this.routingToken = routingToken;
			this.patientIdentifier = patientIdentifier;
		}


		public RoutingToken getRoutingToken()
		{
			return this.routingToken;
		}

		/**
		 * @return the patientIdentifier
		 */
		public PatientIdentifier getPatientIdentifier()
		{
			return patientIdentifier;
		}

		/**
		 * @return the cprsIdentifiers
		 */
		public List<CprsIdentifier> getCprsIdentifiers() 
		{
			return cprsIdentifiers;
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
			logger.debug("...executing PostStudiesByCprsIdentifiersCommand.");
			TransactionContext transactionContext = TransactionContextFactory.get();
			transactionContext.setServicedSource(getRoutingToken().toRoutingTokenString());
			transactionContext.setPatientID(getPatientIdentifier().toString());
			transactionContext.setItemCached(Boolean.FALSE);
			return getStudiesByCprsIdentifiers();
		}
		
		protected List<Study> getStudiesByCprsIdentifiers()
		throws MethodException
		{
			
			if(getPatientIdentifier() == null)
			{
				throw new MethodException("Missing required patient Id parameter");
			}
			
			if((getSiteNumber() == null) || (getSiteNumber().length() <= 0))
			{
				throw new MethodException("Missing required site number parameter");
			}
			
			List<CprsIdentifier> lst = getCprsIdentifiers();
			for (CprsIdentifier item: lst) {
				getLogger().debug(item.getCprsIdentifier());
			}
			
						
			try
			{
				List<Study> studies;
				studies = ImagingContext.getRouter().postStudiesByCprsIdentifiers(
						getRoutingToken(), 
						getPatientIdentifier(),
						getCprsIdentifiers());

                getLogger().info("Got {} patient '{}' studies.", studies == null ? "null" : "" + studies.size(), getPatientIdentifier());
                getLogger().debug("Study List: {}", studies.toString());
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
			
			sb.append(this.getPatientIdentifier());		
			sb.append(this.getRoutingToken());
			sb.append(this.getCprsIdentifiers());		
			
			return sb.toString();
		}

		@Override
		public int hashCode()
		{
			final int prime = 31;
			int result = 1;
			result = prime * result + ((this.cprsIdentifiers == null) ? 0 : this.cprsIdentifiers.hashCode());
			result = prime * result + ((this.patientIdentifier == null) ? 0 : this.patientIdentifier.hashCode());
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
			
			final PostStudiesByCprsIdentifiersCommandImpl other = (PostStudiesByCprsIdentifiersCommandImpl) obj;
			if (this.cprsIdentifiers == null)
			{
				if (other.cprsIdentifiers != null)
					return false;
			}
			else if (!this.cprsIdentifiers.equals(other.cprsIdentifiers))
				return false;
			
			if (this.patientIdentifier == null)
			{
				if (other.patientIdentifier != null)
					return false;
			}
			else if (!this.patientIdentifier.equals(other.patientIdentifier))
				return false;
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
