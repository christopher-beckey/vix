/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 9, 2010
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
package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.imaging.BaseWebFacadeRouter;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.exchange.business.Site;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.jsp.JspException;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class VaSiteCollectionTag 
extends AbstractArtifactSourceCollectionTag 
{
	private static final long serialVersionUID = 1L;

	private static final Logger LOGGER = Logger.getLogger(VaSiteCollectionTag.class);
	private String excludedSiteNumbers;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.taglib.artifactsource.AbstractArtifactSourceCollectionTag#getArtifactSources()
	 */
	@Override
	protected Collection<ResolvedArtifactSource> getArtifactSources()
	throws JspException 
	{
    	try 
    	{
        	BaseWebFacadeRouter router = null;
        	
    		try
    		{
    			router = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
    		} 
    		catch (Exception x)
    		{
                LOGGER.error("VaSiteCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation:{}", x.getMessage());
    			throw new JspException("VaSiteCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation", x);
    		}
    		
    		List<ResolvedArtifactSource> artifactSources = router.getResolvedArtifactSourceList();
    		List<ResolvedArtifactSource> result = new ArrayList<ResolvedArtifactSource>();
    		
    		for(ResolvedArtifactSource source : artifactSources)
    		{
    			if(source.getArtifactSource().isVaRadiology())
    			{
    				if(isSiteNumberIncluded(source.getArtifactSource().getRepositoryId()))
    				{
    					result.add(source);
    				}
    			}
    		}
    		
    		Collections.sort(result, new ResolvedArtifactSourceComparator());
    		return result;
    	}
       	catch(Exception ex)
    	{
            LOGGER.error("VaSiteCollectionTag.getArtifactSources() --> Unable to get Artifact Source List:{}", ex.getMessage());
			throw new JspException("VaSiteCollectionTag.getArtifactSources() --> Unable to get Artifact Source List", ex);
    	}
	}
	
	/**
	 * @return the excludedSiteNumbers
	 */
	public String getExcludedSiteNumbers() {
		return this.excludedSiteNumbers;
	}

	/**
	 * @param excludedSiteNumbers the excludedSiteNumbers to set
	 */
	public void setExcludedSiteNumbers(String excludedSiteNumbers) {
		this.excludedSiteNumbers = excludedSiteNumbers;
	}

	private boolean isSiteNumberIncluded(String siteNumber)
	{
		if(getExcludedSiteNumbers() == null)
			return true;
		
		String [] siteNumbers = StringUtil.split(getExcludedSiteNumbers(), StringUtil.COMMA);
		if(siteNumbers == null)
			return true;
		
		for(String sNumber : siteNumbers)
		{
			if(siteNumber.equals(sNumber))
			{
				return false;
			}
		}
		return true;		
	}
	
	class ResolvedArtifactSourceComparator 
	implements Comparator<ResolvedArtifactSource>
	{

		/* (non-Javadoc)
		 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
		 */
		@Override
		public int compare(ResolvedArtifactSource source1, ResolvedArtifactSource source2)
		{
			ArtifactSource a1 = source1.getArtifactSource();
			ArtifactSource a2 = source2.getArtifactSource();
			if(a1 instanceof Site && a2 instanceof Site)
			{
				Site s1 = (Site)a1;
				Site s2 = (Site)a2;
				return s1.getSiteName().compareToIgnoreCase(s2.getSiteName());
			}
			return 0;
		}
	}
}
