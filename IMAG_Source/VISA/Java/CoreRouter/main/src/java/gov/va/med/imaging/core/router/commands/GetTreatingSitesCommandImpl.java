/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.OID;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.WellKnownOID;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.exceptions.OIDFormatException;
import gov.va.med.imaging.exchange.business.SiteNumberArtifactSourceTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class GetTreatingSitesCommandImpl 
extends AbstractCommandImpl<List<ResolvedArtifactSource>> 
{
	private static final long serialVersionUID = -7099152556482314638L;
	private static final Logger logger = Logger.getLogger(GetTreatingSitesCommandImpl.class);
	
	private final RoutingToken routingToken;
	private final PatientIdentifier patientIdentifier;
	private final boolean includeTrailingCharactersForSite200;
	private final SiteNumberArtifactSourceTranslator siteNumberArtifactSourceTranslator;
	
	/**
	 * @param commandContext
	 */
	public GetTreatingSitesCommandImpl(
		RoutingToken routingToken,
		PatientIdentifier patientIdentifier,
		boolean includeTrailingCharactersForSite200,
		SiteNumberArtifactSourceTranslator siteNumberArtifactSourceTranslator)
	{
		super();
		
		this.routingToken = routingToken;
		this.patientIdentifier = patientIdentifier;
		this.includeTrailingCharactersForSite200 = includeTrailingCharactersForSite200;
		this.siteNumberArtifactSourceTranslator = siteNumberArtifactSourceTranslator;
	}
	
	public GetTreatingSitesCommandImpl(
			RoutingToken routingToken,
			PatientIdentifier patientIdentifier,
			boolean includeTrailingCharactersForSite200)
	{
		this(routingToken, patientIdentifier, includeTrailingCharactersForSite200, null);
	}
	
	public GetTreatingSitesCommandImpl(
			RoutingToken routingToken,
			PatientIdentifier patientIdentifier)
	{
		this(routingToken, patientIdentifier, false, null);
	}

	@Override
	public RoutingToken getRoutingToken()
	{
		return this.routingToken;
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return this.patientIdentifier;
	}

	public boolean isIncludeTrailingCharactersForSite200()
	{
		return this.includeTrailingCharactersForSite200;
	}

	/**
	 * @return the siteNumberArtifactSourceTranslator
	 */
	public SiteNumberArtifactSourceTranslator getSiteNumberArtifactSourceTranslator()
	{
		return siteNumberArtifactSourceTranslator;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public List<ResolvedArtifactSource> callSynchronouslyInTransactionContext()
	throws MethodException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(getRoutingToken().toRoutingTokenString());

        logger.info("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Starts transaction Id [{}] from site [{}] for patient [{}]", transactionContext.getTransactionId(), this.routingToken.toString(), this.patientIdentifier);
		OID routingTokenOid = null;
		
		try
		{
			routingTokenOid = OID.create( getRoutingToken().getHomeCommunityId() );
		}
		catch (OIDFormatException x)
		{
			logger.warn("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Unable to create treating facility artifact source list because routing token home community ID is not a valid OID.");
			return new ArrayList<ResolvedArtifactSource>(0);
		}
		
		if( !WellKnownOID.VA_RADIOLOGY_IMAGE.isApplicable(routingTokenOid) && !WellKnownOID.VA_DOCUMENT.isApplicable(routingTokenOid) )
		{
			logger.warn("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Unable to create treating facility artifact source list because routing token does not point to the VA home community ID.");
			return new ArrayList<ResolvedArtifactSource>(0);
		}
		
		try
		{
			List<String> siteNumbers = InternalContext.getRouter().getTreatingSitesFromDataSource(
				getRoutingToken(),
				getPatientIdentifier(),
				isIncludeTrailingCharactersForSite200());
            logger.debug("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Got [{}] site numbers for patient [{}]", (siteNumbers == null || siteNumbers.size() == 0) ? "no" : siteNumbers.size(), this.patientIdentifier);
			
			// a null Study Set indicates no studies meet the search criteria
			if(siteNumbers != null && siteNumbers.size() > 0)
			{
				List<ResolvedArtifactSource> artifactSources = new ArrayList<ResolvedArtifactSource>();
				Map<String, String> addedSiteNumbers = new HashMap<String, String>();
				for(String siteNumber : siteNumbers)
				{
					RoutingToken rt;
					try
					{						
						String originalSiteNumber = siteNumber;
						if(getSiteNumberArtifactSourceTranslator() != null)
						{
							siteNumber = getSiteNumberArtifactSourceTranslator().translateSiteNumberToArtifactSourceSiteNumber(siteNumber);
						}
						if(siteNumber == null)
						{
                            logger.debug("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Site number has been translated from [{}] to null indicating that it should be discarded.", originalSiteNumber);
						}
						else
						{
							rt = RoutingTokenImpl.createVARadiologySite(siteNumber);
							
							// JMW 7/23/2012 P124, field testing has found that patients who have been seen at both 200 and 200DOD are showing
							// duplicate DoD buttons on the remote site toolbar in the AWIV Web App. Adding a check to ensure only unique
							// sites are added to the artifactSources result since there is no reason to show the same site number twice
							if(addedSiteNumbers.containsKey(siteNumber))
							{
                                logger.debug("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Excluding duplicate site number [{}] from artifact sources result.", siteNumber);
							}
							else
							{	
								// NOTE: do not use the internal getSite() overload here
								// we are not calling a data source
								ResolvedArtifactSource resolvedSite = getCommandContext().getResolvedArtifactSource(rt);
								if(resolvedSite != null)
								{
									artifactSources.add(resolvedSite);
									addedSiteNumbers.put(siteNumber, "");
								}
								else
                                    logger.warn("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Unable to resolve site number [{}]", siteNumber);
							}
						}
					}
					catch (RoutingTokenFormatException x)
					{
                        logger.warn("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Encountered RoutingTokenFormatException for resolve site number [{}]: {}", siteNumber, x.getMessage());
					}
				}
				
				// not sure why this was down here...
				//TransactionContextFactory.get().setDatasourceProtocol(patientUrl.getProtocol());
				StringBuilder sb = new StringBuilder();
				sb.append("GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Got [" + artifactSources.size() + "] artifact sources from [" + this.routingToken.toRoutingTokenString() + "]: ");
				String prefix = "";
				for(ResolvedArtifactSource resolvedArtifactSource : artifactSources)
				{
					sb.append(prefix);
					sb.append(resolvedArtifactSource.getArtifactSource().getRepositoryId());
					prefix = ", ";
				}
				transactionContext.addDebugInformation(sb.toString());
				return artifactSources;
			}
			else
			{
				return new ArrayList<ResolvedArtifactSource>(0);
			}
		}
		catch(ConnectionException cX)
		{
			String msg = "GetTreatingSitesCommandImpl.callSynchronouslyInTransactionContext() --> Encountered ConnectionException: " + cX.getMessage();
			logger.error(msg);
			throw new MethodConnectionException(msg, cX);
		}
	}

	@Override
	protected String parameterToString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append("Patient Id:");
		sb.append(this.patientIdentifier);
		sb.append(" - Routing token: ");
		sb.append(this.routingToken.toString());
		
		return sb.toString();
	}

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
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
		final GetTreatingSitesCommandImpl other = (GetTreatingSitesCommandImpl) obj;
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
