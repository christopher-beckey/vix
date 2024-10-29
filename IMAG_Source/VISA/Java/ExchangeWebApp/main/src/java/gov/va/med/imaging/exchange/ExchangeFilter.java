/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 17, 2008
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
package gov.va.med.imaging.exchange;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudyFilterFilterable;

/**
 * @author vhaiswwerfej
 * @deprecated Use ProcedureFilter instead
 *
 */
public class ExchangeFilter 
extends StudyFilter 
{
	private static final long serialVersionUID = 1L;
	private List<String> allowableStudyTypes = new ArrayList<String>(); 
	
	
	public void setAllowableStudyTypes(Collection<String> allowableTypes)
	{
		this.allowableStudyTypes.clear();
		this.allowableStudyTypes.addAll(allowableTypes);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.StudyFilter#Filter(java.util.List)
	 */
	@Override
	public void preFilter(Collection<? extends StudyFilterFilterable> studies) 
	{	
		for(Iterator<? extends StudyFilterFilterable> iter = studies.iterator(); iter.hasNext();)
		{
			StudyFilterFilterable study = iter.next();
			if(!isAllowableStudyType(study.getProcedure()))
				iter.remove();
		}
	}
	
	/**
	 * @return the allowableStudyTypes
	 */
	private List<String> getAllowableStudyTypes() {
		return allowableStudyTypes;
	}

	/**
	 * @param studyType
	 * @return returns true if the given study type is on the allowed list
	 * or if the list is null or empty
	 */
	private boolean isAllowableStudyType(String studyType)
	{
		if(studyType == null)
			return false;
		
		List<String> allowableTypes = getAllowableStudyTypes();
		if(allowableTypes == null || allowableTypes.size() == 0)
			return true;
		
		for(String allowableStudyType : getAllowableStudyTypes())
			if(studyType.equalsIgnoreCase(allowableStudyType))
				return true;
		
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.StudyFilter#toString()
	 */
	@Override
	public String toString() 
	{
		StringBuilder sb = new StringBuilder(super.toString());
		sb.append(" allowable filter size: [" + this.allowableStudyTypes == null ? 0 : this.allowableStudyTypes.size() +"]" );
		return sb.toString();
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime
				* result
				+ ((allowableStudyTypes == null) ? 0 : allowableStudyTypes
						.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		final ExchangeFilter other = (ExchangeFilter) obj;
		if (allowableStudyTypes == null) {
			if (other.allowableStudyTypes != null)
				return false;
		} else if (!allowableStudyTypes.equals(other.allowableStudyTypes))
			return false;
		return true;
	}
	
	

}
