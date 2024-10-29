/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 10, 2013
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
package gov.va.med.imaging.study;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.exchange.ProcedureFilter;
import gov.va.med.imaging.exchange.business.StudyFilterFilterable;
import gov.va.med.imaging.exchange.configuration.DicomCategoryFilterConfiguration;
import gov.va.med.imaging.exchange.enums.ProcedureFilterMatchMode;
import gov.va.med.imaging.study.rest.types.StudyFilterResultType;

/**
 * @author VHAISWWERFEJ
 *
 */
public class StudyFacadeFilter
extends ProcedureFilter
{
	private static final long serialVersionUID = -8281472689714436561L;
	
	protected final static Logger LOGGER = Logger.getLogger(StudyFacadeFilter.class);
	
	private final boolean includeRadiology;
	private final boolean includeArtifacts;
	
	private StudyFilterResultType resultType = StudyFilterResultType.all;
	
	public static StudyFacadeFilter createRadiologyFilter()
	{
		return new StudyFacadeFilter(ProcedureFilterMatchMode.existInProcedureList);
	}
	
	public static StudyFacadeFilter createArtifactsFilter()
	{
		return new StudyFacadeFilter(ProcedureFilterMatchMode.excludedInProcedureList);
	}
	
	public static StudyFacadeFilter createAllFilter()
	{
		return new StudyFacadeFilter(ProcedureFilterMatchMode.all);
	}
	
	public static StudyFacadeFilter createSpecializationFilter(StudyFilterResultType resultType) {
		StudyFacadeFilter sff = new StudyFacadeFilter(ProcedureFilterMatchMode.all);
		sff.setResultType(resultType);
		return sff;
	}
	
	public StudyFilterResultType getResultType() {
		return resultType;
	}

	public void setResultType(StudyFilterResultType resultType) {
		this.resultType = resultType;
	}
	
	private StudyFacadeFilter(ProcedureFilterMatchMode procedureFilterMatchMode)
	{
		super(procedureFilterMatchMode);
		switch(procedureFilterMatchMode)
		{
			case all:
				this.includeArtifacts = true;
				this.includeRadiology = true;				
				break;
			case excludedInProcedureList:
				this.includeArtifacts = true;
				this.includeRadiology = false;
				break;
			case existInProcedureList:
				this.includeArtifacts = false;
				this.includeRadiology = true;
				break;
			default:
				this.includeArtifacts = true;
				this.includeRadiology = true;
				break;
		}
	}

	public boolean isIncludeRadiology()
	{
		return includeRadiology;
	}

	public boolean isIncludeArtifacts()
	{
		return includeArtifacts;
	}
	
	public void preFilter(Collection<? extends StudyFilterFilterable> studies)
	{
		if(LOGGER.isDebugEnabled()) {
            LOGGER.debug("filtering starting with {} study records", studies.size());
		}
	
//		================================ FUTURE ======================================
//
//		HashSet<String> cptSet = new HashSet<String>();
//		cptSet.addAll(getCptCodes());
//		
//		HashSet<String> modalitiesSet = new HashSet<String>();
//		modalitiesSet.addAll(getModalityCodes());
//				
//		//CPT CODE(S) FILTER
//		if (cptSet.size() > 0) {
//			for (Iterator<? extends StudyFilterFilterable> iter = studies.iterator(); iter.hasNext();) {
//				StudyFilterFilterable study = iter.next();
//				// Exclude all CptCode filters passed in
//				if (!cptSet.contains(study.getCptCode()) || study.getModalities() == null) {
//					LOGGER.debug("removing record with cpt code " + study.getCptCode());
//					iter.remove();
//				}
//			}
//		}
//		
//		//MODALITY(S) FILTER
//		if (modalitiesSet.size() > 0) {
//			for (Iterator<? extends StudyFilterFilterable> iter = studies.iterator(); iter.hasNext();) {
//				StudyFilterFilterable study = iter.next();
//				boolean found = false;
//				for(String aModality : study.getModalities()) {
//					if (modalitiesSet.contains(aModality)) {
//						found = true;
//						break;
//					}
//				}
//				if(!found) {
//					LOGGER.debug("removing record with modality " + study.getModalities());
//					iter.remove();
//				}
//			}
//		}
		
		DicomCategoryFilterConfiguration config = DicomCategoryFilterConfiguration.getConfiguration();
		if(LOGGER.isDebugEnabled()) {
            LOGGER.debug("config categories size = {}", config.getCategories().size());
		}
		
		// Apply one of the new cl_ category filters
		if (config.getCategories().get(getResultType().toString()) != null) {
			Set<String> allowedModalities = config.getCategories().get(getResultType().toString());
			
			if(LOGGER.isDebugEnabled()) {
                LOGGER.debug("Category {} : {}", getResultType().toString(), allowedModalities);
			}
			
			for (Iterator<? extends StudyFilterFilterable> iter = studies.iterator(); iter.hasNext();) {
				StudyFilterFilterable study = iter.next();
				
				//Test for both Modalities and procedure
				
				
				Set<String> values = new HashSet<String>();
				values.add(study.getProcedure());
				for( String entry: study.getModalities() ) {
					//Could be a comma separated list ie. 200CRNR
					if( !entry.isEmpty() ) {
						for( String one: entry.split(",")) {
							values.add(one.trim());
						}
					}
				}
				
				boolean allowed = false;
				
				if(LOGGER.isDebugEnabled()) {
                    LOGGER.debug("test values: {}", values);
				}
				
				for( String one: values) {
					if( allowedModalities.contains(one.toUpperCase()) ) {
						allowed = true;
						if(LOGGER.isDebugEnabled()) {
                            LOGGER.debug("allowed: {}", one.toUpperCase());
						}
						break;
					}
				}
				
				if(!allowed) {
					if(LOGGER.isDebugEnabled()) {
                        LOGGER.debug("removing record using category {} with modality {} and procedure {}", getResultType().toString(), study.getModalities(), study.getProcedure());
					}
					iter.remove();
				}
			}
		} else {
			// Otherwise apply the existing "all", "artifact", "radiology" filter
			super.preFilter(studies);
		}
		
		if(LOGGER.isDebugEnabled()) {
            LOGGER.debug("after filtering the studylist has {} study records", studies.size());
		}
		
	}

}
