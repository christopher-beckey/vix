/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2009
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
package gov.va.med.imaging.vistaimagingdatasource;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.CprsIdentifier.CprsIdentifierType;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaSessionFactory;
import gov.va.med.imaging.vistaobjects.VistaGroup;
import gov.va.med.imaging.vistaobjects.VistaImage;


/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractBaseVistaImagingExternalPackageDataSourceService 
extends AbstractVistaImagingDataSourceService
implements ExternalPackageDataSourceSpi, VistaSessionFactory
{

	private final static Logger logger = 
		Logger.getLogger(AbstractBaseVistaImagingExternalPackageDataSourceService.class);
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public AbstractBaseVistaImagingExternalPackageDataSourceService(ResolvedArtifactSource resolvedArtifactSource,
		String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}
	
	protected abstract String getDataSourceVersion();

	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
	protected ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	protected Site getSite()
	{
		return getResolvedSite().getSite();
	}

	protected Logger getLogger()
	{
		return logger;
	}
	
	/**
	 * Return the required version of VistA Imaging necessary to use this service
	 * @return
	 */
	protected abstract String getRequiredVistaImagingVersion();
	
	/**
	 * Fully populate a study with the images in the study. Different implementations will do this
	 * differently
	 * 
	 * @param vistaSession
	 * @param group
	 * @param patientDfn
	 * @return
	 * @throws InvalidVistaCredentialsException
	 * @throws VistaMethodException
	 * @throws IOException
	 */
	protected abstract Study fullyPopulateGroupIntoStudy(
		VistaSession vistaSession, 
		Study study, 
		String patientDfn)
	throws InvalidVistaCredentialsException, VistaMethodException, IOException;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible()
	throws SecurityCredentialsExpiredException
	{
		VistaSession localVistaSession = null;
        logger.info("isVersionCompatible searching for version [{}], TransactionContext ({}).", getRequiredVistaImagingVersion(), TransactionContextFactory.get().getDisplayIdentity());
		try
		{
			localVistaSession = getVistaSession();	
			return VistaImagingCommonUtilities.isVersionCompatible(getRequiredVistaImagingVersion(), 
					localVistaSession);			
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			// caught here to be sure it gets thrown as SecurityCredentialsExpiredException, not ConnectionException
			throw sceX;
		}
		catch(MethodException mX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", mX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (mX == null ? "<null error>" : "" + mX.getMessage()));
		}
		catch(ConnectionException cX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", cX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (cX == null ? "<null error>" : "" + cX.getMessage()));
		}
		catch(IOException ioX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", ioX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (ioX == null ? "<null error>" : "" + ioX.getMessage()));
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
		}		
		return false;	
	}	
	
	/**
	 * 
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSource#getStudyFromCprsIdentifier(java.lang.String, gov.va.med.imaging.CprsIdentifier)
	 */
	@Override
	public List<Study> getStudiesFromCprsIdentifier(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			CprsIdentifier cprsIdentifier) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getStudiesFromCprsIdentifier", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getStudyFromCprsIdentifier({}, {}) TransactionContext ({}).", patientIcn, cprsIdentifier, TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			
			List<VistaImage> vistaImages = null;
			if(cprsIdentifier.getCprsIdentifierType() == CprsIdentifierType.TIU)
			{
				vistaImages = getVistaImageListFromTiuNote(vistaSession, cprsIdentifier);
			}
			else if(cprsIdentifier.getCprsIdentifierType() == CprsIdentifierType.RAD_EXAM)
			{
				vistaImages = getVistaImageListFromRadExam(vistaSession, cprsIdentifier);
			}
			else
			{
				throw new MethodException("Unknown CprsIdentifier Type for CprsIdentifier '" + cprsIdentifier.getCprsIdentifier() + "'");
			}

            getLogger().info("Found '{}' images from cprs identifier", vistaImages.size());
			if(vistaImages.size() <= 0)
				// return null?
				return null;
			PatientIdentifier patientIdentifier = PatientIdentifier.icnPatientIdentifier(patientIcn);
			
			List<Study> studies = findStudiesForImages(vistaSession, patientIdentifier, vistaImages, cprsIdentifier);
            getLogger().info("Found '{}' studies from the images associated with the cprs identifier.", studies.size());

			//Fill contextID and AlternateExamNumber
			for(Study study: studies)
			{
				study.setContextId(cprsIdentifier.getCprsIdentifier());
				String alternateExamNumber = StringUtil.Piece(cprsIdentifier.getCprsIdentifier(),StringUtil.CARET,5); 
				if(cprsIdentifier.getCprsIdentifierType() == CprsIdentifierType.TIU)
				{
					study.setAlternateExamNumber("TIU-" + alternateExamNumber);
				}
				else if(cprsIdentifier.getCprsIdentifierType() == CprsIdentifierType.RAD_EXAM)
				{
					study.setAlternateExamNumber("RA DT-" + alternateExamNumber);
				}
			}

			
			// temp until method signature is changed
			return studies;			
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{vistaSession.close();}catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
		}
	}
	
	@Override
	public List<Study> getStudiesFromCprsIdentifierAndFilter(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			CprsIdentifier cprsIdentifier, 
			StudyFilter filter)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(ExternalPackageDataSourceSpi.class, "getStudiesFromCprsIdentifierAndFilter");
	}


	/**
	 * 
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSource#postStudiesFromCprsIdentifiers(java.lang.String, gov.va.med.imaging.CprsIdentifier)
	 */
	@Override
	public List<Study> postStudiesFromCprsIdentifiers(
			RoutingToken globalRoutingToken, 
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers) 
	throws MethodException, ConnectionException 
	{
		throw new UnsupportedServiceMethodException(ExternalPackageDataSourceSpi.class, "postStudiesFromCprsIdentifiers");
	}
	
	@Override
	public List<Study> postStudiesFromCprsIdentifiersAndFilter(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers, StudyFilter filter)
	throws MethodException, ConnectionException 
	{
		throw new UnsupportedServiceMethodException(ExternalPackageDataSourceSpi.class, "postStudiesFromCprsIdentifiersAndFilter");
	}

	@Override
	public List<Study> postViewerStudiesForQaReview(
			RoutingToken globalRoutingToken,
			StudyFilter filter)
	throws MethodException, ConnectionException 
	{
		throw new UnsupportedServiceMethodException(ExternalPackageDataSourceSpi.class, "postViewerStudiesForQaReview");
	}

	private List<Study> findStudiesForImages(VistaSession vistaSession, PatientIdentifier patientIdentifier, 
			List<VistaImage> vistaImages, CprsIdentifier cprsIdentifier)
	throws InvalidVistaCredentialsException, IOException, VistaMethodException, ConnectionException, MethodException
	{
		List<Study> result = new ArrayList<Study>();
		SortedSet<Study> groups = null;
		String patientDfn = null;
		while(vistaImages.size() > 0)
		{
			int imageCount = vistaImages.size();
            getLogger().info("Currently '{}' images from CPRS identifier, finding studies containing images.", vistaImages.size());
			VistaImage vistaImage = vistaImages.get(0);
			String groupIen = findGroupIen(vistaSession, vistaImage);
			// only need to get the DFN once for the patient						
			if(patientDfn == null)
			{
				patientDfn = getPatientDfn(vistaSession, patientIdentifier);
			}
			
			// only need to get the groups once for the patient
			if(groups == null)
			{
				groups = findPatientGroups(vistaSession, patientIdentifier, patientDfn);
			}
			Study study = findStudy(vistaSession, groups, groupIen, vistaImage, patientDfn, cprsIdentifier);
			result.add(study);
            getLogger().info("Added study '{}' with '{}' images to result.", study.getStudyUrn().toString(), study.getImageCount());
			Iterator<VistaImage> imageIterator = vistaImages.iterator();
			while(imageIterator.hasNext())
			{
				VistaImage image = imageIterator.next();
				if(isImageInStudy(image, study))
				{
					imageIterator.remove();
				}
			}
			if(vistaImages.size() >= imageCount)
			{
				// if the image count has not been reduced, this means the image was not found
				// so it will never be found so throw an exception to break out of this loop
				// hopefully this will never happen!
				throw new MethodException("Attempted to process image '" + vistaImage.getIen() + "' from site '" + getSite().getSiteNumber() + "' but did not find a study containing this image. This will cause an infinite loop, breaking now!");
			}
		}
		
		return result;
	}
	
	
	private boolean isImageInStudy(VistaImage vistaImage, Study study)
	{
		for(Series series : study.getSeries())
		{
			for(Image image : series)
			{
				if(image.getIen().equals(vistaImage.getIen()))
				{
					return true;
				}
			}
		}
		return false;
	}
	
	private Study findStudy(VistaSession vistaSession, SortedSet<Study> groups, String groupIen, 
			VistaImage image, String patientDfn, CprsIdentifier cprsIdentifier)
	throws MethodException, InvalidVistaCredentialsException, VistaMethodException, IOException
	{
		Study group = null;
		try 
		{
			for(Study study : groups)
			{
				if(groupIen.equals(study.getStudyIen()))
				{
					getLogger().info("Found group that matches group Ien from image list");
					group = study;
					break;
				}
				if(image.getIen().equals(study.getStudyIen()))
				{
					getLogger().info("Found group that matches first image in the CPRS image list response, implies this is a single image group with an image node");
					group = study;
					break;
				}
			}
			
			// Fortify change: check for null first
            getLogger().info("Fully populating group '{}' with images and returning study.", group != null ? group.getStudyIen() : "None");
			return fullyPopulateGroupIntoStudy(vistaSession, group, patientDfn);
		}
		catch (Exception e) 
		{
			getLogger().error(e);
			throw new MethodException(e);
		}
	}
	
	private String findGroupIen(VistaSession vistaSession, VistaImage vistaImage)
	throws InvalidVistaCredentialsException, IOException, VistaMethodException
	{
		String imageIen = vistaImage.getIen();
        getLogger().info("Finding group for image IEN '{}'", imageIen);
		VistaQuery getGroupIenQuery = VistaImagingQueryFactory.createGetImageGroupIENVistaQuery(imageIen);
		String groupIenResult = vistaSession.call(getGroupIenQuery);			
		String groupIen = VistaImagingTranslator.extractGroupIenFromNode0Response(groupIenResult);
		if(groupIen == null)
		{
            getLogger().info("Group IEN is null, indicating image found is group IEN already, using imageIen '{}' as group IEN", imageIen);
			groupIen = imageIen;
		}
		else
		{
            getLogger().info("Found group IEN '{}' for image '{}'.", groupIen, vistaImage.getIen());
		}		
		return groupIen;
	}
	
	private SortedSet<Study> findPatientGroups(VistaSession vistaSession, 
			PatientIdentifier patientIdentifier, String patientDfn)
	throws IOException, MethodException, ConnectionException
	{
		
		SortedSet<Study> groups = getPatientGroups(
			vistaSession, 
			getSite(), 
			null, 
			patientIdentifier, 
			patientDfn);
		return groups;
	}
	
	
	/**
	 * Retrieve the list of images from a TIU note identifier
	 * 
	 * @param vistaSession
	 * @param patientIcn
	 * @param cprsIdentifier
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ConnectionException
	 */
	private List<VistaImage> getVistaImageListFromTiuNote(
		VistaSession vistaSession,
		CprsIdentifier cprsIdentifier)
	throws MethodException, IOException, ConnectionException
	{
        getLogger().info("getImageListFromTiuNote({}) executing.", cprsIdentifier);
		try
		{
			VistaQuery query = VistaImagingQueryFactory.createGetImagesForCprsTiuNote(cprsIdentifier);
			String imageListRtn = vistaSession.call(query);
			List<VistaImage> vistaImages = VistaImagingTranslator.extractVistaImageListFromVistaResult(imageListRtn);

			return vistaImages;
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
	}
	
	/**
	 * Retrieve the list of images from a Rad exam identifier
	 * 
	 * @param vistaSession
	 * @param patientIcn
	 * @param cprsIdentifier
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ConnectionException
	 */
	private List<VistaImage> getVistaImageListFromRadExam(
		VistaSession vistaSession, 
		CprsIdentifier cprsIdentifier)
	throws MethodException, IOException, ConnectionException
	{
        getLogger().info("getImageListFromRadExam({}) executing.", cprsIdentifier);
		try
		{
			VistaQuery query = VistaImagingQueryFactory.createGetImagesForCprsRadExam(cprsIdentifier);
			String imageListRtn = vistaSession.call(query);
			List<VistaImage> vistaImages = VistaImagingTranslator.extractVistaImageListFromVistaResult(imageListRtn);

			return vistaImages;
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
	}

	
	public VistaSession getVistaSession() 
    throws IOException, ConnectionException, MethodException, SecurityCredentialsExpiredException
    {
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite());
    }
	
	
	protected SortedSet<Study> getPatientGroups(VistaSession session, Site site, 
			StudyFilter filter, PatientIdentifier patientIdentifier)
	throws MethodException, IOException, ConnectionException
	{
		return getPatientGroups(session, site, filter, patientIdentifier, null);
	}
	
	/**
	 * 
	 * @param session
	 * @param site - the VistaImaging site that we are getting the data from (the site that the session is connected to) 
	 * @param filter - the criteria to filter the result set on
	 * @param patientIcn
	 * @param patientDfn
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ConnectionException
	 */
	protected SortedSet<Study> getPatientGroups(
		VistaSession session, 
		Site site, 
		StudyFilter filter, 
		PatientIdentifier patientIdentifier, 
		String patientDfn)
	throws MethodException, IOException, ConnectionException
	{
        logger.info("getPatientGroups({}) TransactionContext ({}).", patientIdentifier, TransactionContextFactory.get().getDisplayIdentity());

		// filter results based on the patient sensitivity
        try
        {
        	if((patientDfn == null) || (patientDfn.length() <= 0))
        		patientDfn = getPatientDfn(session, patientIdentifier);
        } 
        catch(PatientNotFoundException pnfX)
        {
        	throw new MethodException(pnfX);
        }
		VistaQuery vm = VistaImagingQueryFactory.createGetGroupsVistaQuery(patientDfn, filter);
		
		String rtn = null;
		try
		{
			rtn = session.call(vm);
			// check to be sure first character is a 1 (means result is ok)
			
			// if no images for patient, response is [0^No images for filter: All Images]
			
			if(rtn.charAt(0) == '1') 
			{			
				SortedSet<VistaGroup> groups = VistaImagingTranslator.createGroupsFromGroupLinesHandleSingleImageGroup(
					site, rtn, patientIdentifier, StudyLoadLevel.FULL, StudyDeletedImageState.cannotIncludeDeletedImages);
				return VistaImagingTranslator.transform(ObjectOrigin.VA, site, groups);
			}
			else if(rtn.startsWith("0^No images for filter")) 
			{
				logger.info("0 response from MAG4 PAT GET IMAGES rpc, no images found");
				return new TreeSet<Study>();
			}
			else if(rtn.startsWith("0^No Such Patient:")) 
			{
				logger.info("0 response from MAG4 PAT GET IMAGES rpc");
				throw new VistaMethodException("No patient [ "+ patientIdentifier + "] found in database");
			}
			else 
			{
				logger.info("0 response from MAG4 PAT GET IMAGES rpc");
				throw new VistaMethodException(rtn);
			}
		}
		catch (Exception ex)
		{
			logger.error(ex);
			throw new MethodException(ex);
		}
	}
}
