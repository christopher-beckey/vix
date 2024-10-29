/**
 * 
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.commands.configuration.CommandConfiguration;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.storage.cache.AbstractCacheDecorator;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * An abstract superclass of Study-related commands, grouped because there is significant
 * overlap in the Study commands that is contained here.
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractStudyCommandImpl<R extends Object> 
extends AbstractImagingCommandImpl<R> {
	
	private static final long serialVersionUID = -4942954920091003627L;
	public static Map<String, Study> tinyCache = new ConcurrentHashMap<>();

	public AbstractStudyCommandImpl() {
		super();
	}
	
	protected List<Study> getPatientStudyList(RoutingToken routingToken, PatientIdentifier patientId, StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException {
		
		StudySetResult studySet = getPatientStudySetResult(routingToken, patientId, filter, studyLoadLevel);
		
		if(studySet == null || studySet.getArtifacts() == null) {
			return new ArrayList<Study>();
		}
		
		SortedSet<Study> studies = studySet.getArtifacts();
		
		List<Study> studyList = new ArrayList<Study>(studies == null ? 0 : studies.size());
		studyList.addAll(studies);
		
		return studyList;
	}

	protected StudySetResult getPatientStudySetResult(RoutingToken routingToken, PatientIdentifier patientId, StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException {
		
		if(filter == null) {
			String errMsg = "AbstractStudyCommandImpl.getPatientStudySetResult() --> a StudyFilter object is required but not given.";
			logger.error(errMsg);
			throw new MethodException(errMsg);
		}
		
		if(!filter.isSiteAllowed(routingToken.getRepositoryUniqueId())) {
			getLogger().info("Site number [" + routingToken + "] is excluded in the StudyFilter, not loading study list from this site");

			return StudySetResult.createFullResult(new TreeSet<Study>());			
		}

		// By default, the Study service and other paths using this do not include MUSE
		// Explicitly query and retrieve MUSE studies as part of this specific query
		// VAI-1202: not necessary to include MUSE in certain queries
		StudySetResult museResult = null;
		Set<Study> museStudies = new HashSet<Study>();

		// Query for "normal" (non-MUSE) patient artifacts
		try {
			
			StudySetResult studyResult = ImagingContext.getRouter().getStudySet(routingToken, patientId, filter, studyLoadLevel);
			int studyCount = ((studyResult == null) || (studyResult.getArtifacts() == null)) ? (0) : (studyResult.getArtifacts().size());

			logger.info("Got " + ((studyResult == null || studyResult.getArtifacts() == null || studyResult.getArtifacts().size() == 0) ? "no" : studyResult.getArtifacts().size()) + 
					" patient Id [" + patientId + "] studies.");

			// Query for MUSE artifacts as specified
			if (filter.isIncludeMuseOrders()) {
				museResult = getMuseResult(routingToken, patientId, filter, studyCount);

				if(museResult != null) {
					museStudies = museResult.getArtifacts();
				}
			}

			// Return MUSE or empty if we had had no response at all
			if(studyResult == null) {
				if (museStudies.size() > 0) {
					return museResult;
				} else {
					return StudySetResult.createFullResult(null);
				}
			}

			// Return MUSE or empty if we had a study result but no artifacts
			if(studyResult.getArtifacts() == null) {
				if (museStudies.size() > 0) {
					return museResult;
				} else {
					return studyResult;
				}
			}
			
			// need to check to see if the studies or the images contain consolidated site numbers and need to be "fixed" up
			studyResult = CommonStudyFunctions.updateConsolidatedSitesInStudySetResult(studyResult, getCommandContext());
			
			Set<Study> studies = studyResult.getArtifacts();

			// Add the MUSE studies (if we have any) into the result set. This may not be necessary since this is for caching
			studies.addAll(museStudies);
			
			// 1/24/2011 - decided we won't kick off the async request, just allow the the request to be made
			// to the secondary VIX and the secondary VIX will just get the image without having the metadata 			
				
			// regardless of the studyLoadLevel, try to cache the studies
			// if this returns false then 1 or more study was not fully loaded
			// studies from DoD should always be fully loaded, so this should always return true for DoD
			if(!CommonStudyCacheFunctions.cacheStudyList(getCommandContext(), routingToken.getRepositoryUniqueId(), studies)) {
				
				// we don't kick of an async request for the local site because if the request was to a remote site
				// through Federation, the async request will come from the original site, not the local site.
				// so site 1 calls site 2 for a shallow study list.  Site 1 will kick off the async request for the
				// full graph and call site 2. We don't want site 2 making the same async request since that will
				// just duplicate the work.
				if(!routingToken.getRepositoryUniqueId().equals(getCommandContext().getRouter().getAppConfiguration().getLocalSiteNumber())) {
					if(studies.size() > 0) {
						if(!studyLoadLevel.isFullyLoaded()) {
							logger.info("At least 1 study was not cached because it was not fully loaded, requesting study graph again async fully loaded");
							// if this study data is from a remote site
							// create an asynch request to re-request this patient studies with the full data
							startAsyncFullStudyGraphRequest(routingToken, patientId, filter);
						} else {
							logger.info("At least 1 study was not cached because it was not fully loaded, but current request was for fully loaded studies, not trying again.");
						}
					} else {
						logger.info("No studies were found for patient '" + patientId + "' from site '" + routingToken + "', not getting fully loaded studies.");
					}
				} else {
					logger.info("At least 1 study was not cached because it was not fully loaded, but request for local site - not submitting request for full graph");
				}
			}

			/* Merge the MUSE results into the study set
			 * QN: already done by studies.addAll(museStudies);
			 * no harm b/c of Set data type but doing it twice
			if (museResult != null) {
				// Basically the same as ???
				studyResult.getArtifacts().addAll(museResult.getArtifacts());
			}
			*/
			return studyResult;
			
		} catch (MethodException e) {
			// If we ran into an exception querying normal (non-MUSE) studies and we have MUSE results, just return those
			if (museResult != null) {
				logger.debug("Encountered a MethodException while retrieving images, but have MUSE results; returning those");
				return museResult;
			} else {
				throw e;
			}
		} catch(ConnectionException cX) {
			String errMsg = "Encountered [ConnectionException] while querying for images: " + cX.getMessage();
			logger.error(errMsg);
			throw new MethodConnectionException(errMsg, cX);
		}
	}
	
	private void startAsyncFullStudyGraphRequest(RoutingToken routingToken, PatientIdentifier patientId, StudyFilter filter) {
		
		ImagingContext.getRouter().getStudyList(routingToken, patientId, filter);			
	}
	
	protected Study getPatientStudy(GlobalArtifactIdentifier artifactId, boolean includeDeletedImages)
	throws MethodException {
		
		// by default use old behavior to allow data from cache if it is there
		return getPatientStudy(artifactId, includeDeletedImages, true, null);
	}
	
	protected Study getPatientStudy(GlobalArtifactIdentifier artifactId, boolean includeDeletedImages, boolean allowedFromCache)
	throws MethodException {
				
		// by default use old behavior to allow data from cache if it is there
		return getPatientStudy(artifactId, includeDeletedImages, allowedFromCache, null);
	}
	
	// VAI-1202: added
	protected Study getPatientStudy(GlobalArtifactIdentifier artifactId, boolean includeDeletedImages, StudyFilter studyFilter)
	throws MethodException {
		
		// by default use old behavior to allow data from cache if it is there
		return getPatientStudy(artifactId, includeDeletedImages, true, studyFilter);
	}

	protected Study getPatientStudy(GlobalArtifactIdentifier artifactId, boolean includeDeletedImages, boolean allowedFromCache, StudyFilter studyFilter)
	throws MethodException {
		
		TransactionContext txContext = TransactionContextFactory.get();
		
		PatientIdentifier patientId = ((StudyURN) artifactId).getThePatientIdentifier();
		
		Study study = null;
		// JMW 5/7/2012 P130 - use option to not get study metadata from cache if always want latest and greatest
		if(allowedFromCache) {
			study = getStudyFromCache(artifactId);
		}

		if(study != null) {
			// JMW 9/3/2010 - p104, updated 9/23/2010
			// if a study was found in the cache and the user requested the study include
			// deleted images, check to see if the study can include deleted images and if it
			// does in fact contain deleted images
			// if not, set the study = null to get the study again from the data source
			if(includeDeletedImages && study.getStudyDeletedImageState().isCanIncludeDeletedImages() && !study.getStudyDeletedImageState().isDeletedImagesLoaded()) {
				logger.info("Found study [" + study + "] in cache but does not contain deleted images which user requested and the study can potentially contain deleted images, will not use study from cache.");
				study = null;
			}
		}
		
		if(study == null) {
			
			StudyFilter finalFilter = studyFilter == null ? new StudyFilter(artifactId) : studyFilter;
			finalFilter.setIncludeDeleted(includeDeletedImages);
			
			logger.info("getPatientStudy(1) --> finalFilter --> " + finalFilter);
			
			List<Study> studies = getPatientStudyList(artifactId, patientId, finalFilter, StudyLoadLevel.FULL);

			if(studies.size() > 0) {
				study = studies.get(0);
				logger.info("Found study [" + artifactId.toString() + "] from data source");
				txContext.setItemCached(Boolean.FALSE);
			} else {
				logger.info("Unable to find study [" + artifactId.toString() + "] from data source");
			}
		} else {
			logger.info("Found study [" + artifactId.toString() + "] in cache");
			txContext.setServicedSource(artifactId.toRoutingTokenString());
			txContext.setItemCached(Boolean.TRUE);
		}

		return study;
	}	

	protected Study getStudyFromCache(GlobalArtifactIdentifier gaid) {
		
		return CommonStudyCacheFunctions.getStudyFromCache(getCommandContext(), gaid);
	}

	protected Map<String,Image> extractImagesFromStudy(Study study) {
		
		Map<String,Image> images = new HashMap<>(study.getImageCount());
		for(Series ser : study.getSeries()) {
			for(Image image : ser) {
				images.put(image.getIen(), image);
			}
		}
		
		return images;
	}

    protected Image findImageInCachedStudyGraph(ImageURN imageUrn) {
    	
	    Image image = null;
	    
	    logger.info("ImageURN is [" + (imageUrn == null ? "null" : imageUrn.toString()) + "]");
	    
	    if(imageUrn == null) {
	    	return null;
	    }
	    
		try	{

			StudyURN studyUrn = imageUrn.getParentStudyURN();
			logger.info("StudyURN is [" + (studyUrn == null ? "null" : studyUrn.toString()) + "]");

			Study study = getStudyFromCacheSimple(studyUrn);
			if(study == null) {
				study = getStudyFromCache(studyUrn);
			}

			if(study != null) {
				// JMW 7/13/2009
				// if the imageId is the same as the study Id, this indicates the user is requesting the 
				// first image in a single image study where the RPC gave the imageId as the studyId
				// in this case we just want to return the 'FirstImage' in the study.
				// In most cases the imageId requested won't be the study Id but if the site does
				// not have Patch 83 this will happen on single image groups and this allows the
				// cache to be used.
				// If the studyId is the imageId, it won't find the image in the study
				if(imageUrn.getImageId().equals(imageUrn.getStudyId())) {
					return study.getFirstImage();
				}
				
				Map<String,Image> images = extractImagesFromStudy(study);
				if(images.containsKey(imageUrn.getImageId())) {
					image = images.get(imageUrn.getImageId());
				}
			}
		} catch(URNFormatException iurnfX) {
			logger.error(iurnfX);
		}
		
	    return image;
    }

    private String getCacheFileName(StudyURN studyUrn) {
    	
		String [] groups = AbstractCacheDecorator.createInternalInstanceGroupKeys(studyUrn, true);

		StringBuilder sb= new StringBuilder(System.getenv("vixcache"));
		
		sb.append(File.separator);
		sb.append(studyUrn.isOriginDOD() ? "dod-metadata-region" : "va-metadata-region");
		sb.append(File.separator);
		sb.append(groups[0]);
		sb.append(File.separator);
		sb.append(groups[1]);
		sb.append(File.separator);
		sb.append(groups[2]);
		sb.append(File.separator);
		sb.append("study.xml");
		
    	return sb.toString();
    }

    private Study getStudyFromCacheSimple(StudyURN studyUrn) {
		
		try {
			
			String fileName = getCacheFileName(studyUrn);
			
			if(tinyCache.containsKey(fileName)) {
				Study study = tinyCache.get(fileName);
				return addStudyToMemCache(study, fileName);//cleans up
			}
			
			Study study = serializeStudyFromCacheStudy(studyUrn, fileName);
			if(study == null) {
				CommandConfiguration commandConfiguration = CommandConfiguration.getCommandConfiguration();
				long sleepDelay = commandConfiguration == null ? 100 : commandConfiguration.getSimpleStudyCacheReadDelayMillis();
				Thread.sleep(sleepDelay);
				study = serializeStudyFromCacheStudy(studyUrn, fileName);
			}
			return addStudyToMemCache(study, fileName);
		} catch (Exception e) {
			logger.warn("GetStudyFromCacheSimple failed to get file for " + studyUrn + " msg: " + e.getMessage());
			return null;
		}
	}

	private static Study addStudyToMemCache(Study study, String fileName) {
		
		cleanupTinyCache();
		
		if (study == null) {
			return null;
		}
		
		tinyCache.put(fileName, study);
		
		return study;
	}

	private static void cleanupTinyCache() {
		
		CommandConfiguration commandConfiguration = CommandConfiguration.getCommandConfiguration();
		int maxStudiesCached = commandConfiguration == null ? 5 : commandConfiguration.getMaxMemCacheStudies();
		
		if(tinyCache.keySet().size() > maxStudiesCached) {
			tinyCache.clear();
		}
	}

	private Study serializeStudyFromCacheStudy(StudyURN studyUrn, String fileName) {
		
		try(FileInputStream fileInputStream = new FileInputStream(fileName);
			ObjectInputStream objectInputStream = new ObjectInputStream(fileInputStream)) {
			return (Study) objectInputStream.readObject();
		} catch (Exception e) {
			logger.warn("GetStudyFromCacheSimple failed to get file for " + studyUrn + " msg: " + e.getMessage());
			return null;
		}
	}

	// VAI-1202: abstracted out for clarity
	private StudySetResult getMuseResult(RoutingToken routingToken, PatientIdentifier patientId, StudyFilter filter, int studyCount) {
		// If we have a filter and that filter does not either have a study ID or it had one and got no results back, don't query MUSE
		if ((filter != null) && (! ((filter.getStudyId() == null) || ((filter.getStudyId() != null) && (studyCount == 0))))) {
			return null;
		}

		StudySetResult museResult = null;
		Set<Study> museStudies = new HashSet<Study>();
		
		try {
			// Update the filter to include the MUSE patient identifier
			if (filter != null) {
				// For single studies, MUSE uses the SSN, so query for that information
				Patient patient = ImagingContext.getRouter().getPatientInformation(getRoutingToken(), patientId);
				if ((patient != null) && (patient.getSsn() != null)) {
					filter.setMusePatientId(patient.getSsn());
				}
			}

			// Query for the MUSE artifacts
			ArtifactResults artifactResults = ImagingContext.getRouter().getStudyOnlyPatientArtifactResultsFromSiteMuse(routingToken, patientId, filter, true, true);
			if (artifactResults != null) {
				museResult = artifactResults.getStudySetResult();
				if (museResult != null) {
					// Filter the studies to ensure the identifier matches
					museStudies = museResult.getArtifacts();

					// Get a list of items to remove (iterator not guaranteed to implement remove())
					List<Study> studiesToRemove = new ArrayList<Study>();
					for (Study museStudy : museStudies) {
						// Ensure we have a filter, study identifier, and muse study identifier
						if ((filter != null) && (filter.getStudyId() != null) && (museStudy.getStudyUrn() != null)) {
							// There are two formats this can be provided in. For a VIX, it's "musestudy", but for a CVIX it's "vastudy"
							// VIX typically looks like: urn:musestudy:siteId-museServerId-patientICN-otherIdentifier
							// CVIX typically looks like: urn:vastudy:siteId-museServerId-patientICN
							// If neither matches, we'll add it to the list of items to remove
							String studyId = filter.getStudyId().toString();
							String museId = museStudy.getStudyUrn().toString();
							if (studyId.equals(museId)) {
								// This is a direct match and we can accept it
								continue;
							} else if (museId.replaceFirst("urn:musestudy:(.*)-\\d+", "urn:vastudy:$1").equals(studyId)) {
								// This is a CVIX format match after some manipulation
								continue;
							} else {
								// This isn't a match, so we remove it from the list
								studiesToRemove.add(museStudy);
							}
						}
					}
					
					// Remove the items from the list (getArtifacts() returns the underlying collection)
					studiesToRemove.forEach(museStudies::remove);
				}
			}
		} catch (Exception e) {
			logger.info("StudySetResult --> Couldn't get MUSE data for given patient Id [" + patientId + "]. Possible reason: a) Unknown MUSE server b) Unresolvable site c) patient not found");
		}
		
		return museResult;
	}
}
