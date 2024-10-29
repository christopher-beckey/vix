/**
 * 
 */
package gov.va.med.imaging.vistaimagingdatasource;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaobjects.CprsIdentifierImages;
import gov.va.med.imaging.vistaobjects.VistaImage;

/**
 * @author William Peterson
 *
 */
//WFP-Need to add this to appropriate resource gatherer.
public class VistaImagingExternalPackageDataSourceServiceV4 extends
		VistaImagingExternalPackageDataSourceServiceV3 {

	public final static String MAG_REQUIRED_VERSION = "3.0P185";

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingExternalPackageDataSourceServiceV4(
			ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistadatasource.AbstractBaseVistaExternalPackageDataSourceService#getRequiredVistaImagingVersion()
	 */
	@Override
	protected String getRequiredVistaImagingVersion() 
	{
		return VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				VistaImagingDataSourceProvider.getVistaConfiguration(), this.getClass(), 
				MAG_REQUIRED_VERSION);
	}

	@Override
	protected String getDataSourceVersion()
	{
		return "4";
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi#getStudiesFromCprsIdentifier(gov.va.med.RoutingToken, java.lang.String, gov.va.med.imaging.CprsIdentifier, gov.va.med.imaging.exchange.business.StudyFilter)
	 */
	//WFP-Still need to work this code.
	@Override
	public List<Study> getStudiesFromCprsIdentifierAndFilter(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			CprsIdentifier cprsIdentifier, 
			StudyFilter filter)
	throws MethodException, ConnectionException 
	{
				getLogger().debug("...executing getStudiesFromCprsIdentifierAndFilter method in V4.");

		VistaCommonUtilities.setDataSourceMethodAndVersion("getStudiesFromCprsIdentifierAndFilter", getDataSourceVersion());
        getLogger().info("getStudiesFromCprsIdentifierAndFilter({}, {}) TransactionContext ({}).", patientIcn, cprsIdentifier, TransactionContextFactory.get().getTransactionId());
		
		List<CprsIdentifier> cprsIdentifiers = new ArrayList<CprsIdentifier>();
		cprsIdentifiers.add(cprsIdentifier);
		PatientIdentifier patientIdentifier = PatientIdentifier.icnPatientIdentifier(patientIcn);
		
		return postStudiesFromCprsIdentifiersAndFilter(
				globalRoutingToken,
				patientIdentifier,
				cprsIdentifiers,
				filter
				);

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
		CprsIdentifier cprsIdentifier,
		StudyFilter filter)
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
		CprsIdentifier cprsIdentifier,
		StudyFilter filter)
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

	private List<Study> findStudiesForImages(VistaSession vistaSession, PatientIdentifier patientIdentifier, 
			List<VistaImage> vistaImages, CprsIdentifier cprsIdentifier, StudyFilter filter)
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
			Study study = findStudy(vistaSession, groups, groupIen, vistaImage, patientDfn, cprsIdentifier, filter);
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

	private Study findStudy(VistaSession vistaSession, SortedSet<Study> groups, String groupIen, 
			VistaImage image, String patientDfn, CprsIdentifier cprsIdentifier, StudyFilter filter)
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
			//WFP-Determine if there is a need to pass the StudyFilter class in this method.
			return fullyPopulateGroupIntoStudy(vistaSession, group, patientDfn);
		}
		catch (Exception e) 
		{
			getLogger().error(e);
			throw new MethodException(e);
		}
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistaimagingdatasource.AbstractBaseVistaImagingExternalPackageDataSourceService#postStudiesFromCprsIdentifiers(gov.va.med.RoutingToken, gov.va.med.PatientIdentifier, java.util.List)
	 */
	@Override
	public List<Study> postStudiesFromCprsIdentifiersAndFilter(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers,
			StudyFilter filter) 
	throws MethodException,ConnectionException 
	{
		getLogger().debug("...executing postStudiesFromCprsIdentifiersAndFilter method in V4.");
		VistaCommonUtilities.setDataSourceMethodAndVersion("postStudiesFromCprsIdentifiers", getDataSourceVersion());
		VistaSession vistaSession = null;

        getLogger().debug("postStudiesFromCprsIdentifiersAndfilter({}, ) TransactionContext ({}).", patientIdentifier, TransactionContextFactory.get().getTransactionId());

		List<Study> result = new ArrayList<Study>();

		try
		{
			vistaSession = getVistaSession();
			
			CprsIdentifierImages cprsIdentifierImages = 
					getVistaImageListFromCprsIdentifiers(vistaSession, getSite(), patientIdentifier, filter, cprsIdentifiers);
			
			for(CprsIdentifier item: cprsIdentifiers)
			{
				String cprsIdentifier = item.getCprsIdentifier();
				List<Study> studies = cprsIdentifierImages.getVistaStudies().get(cprsIdentifier);
				result.addAll(studies);
			}
			
		}
		catch(IOException ioX)
		{
			throw new ConnectionException(ioX);
		}
		finally
		{
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
				}
			}
		}
		
		return result;
	}

	/**
	 * Retrieve the list of images from list of cprs identifier
	 * 
	 * @param vistaSession
	 * @param patientIcn
	 * @param cprsIdentifiers
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ConnectionException
	 */
	private CprsIdentifierImages getVistaImageListFromCprsIdentifiers(
		VistaSession vistaSession,
		Site site,
		PatientIdentifier patientIdentifier,
		StudyFilter filter,
		List<CprsIdentifier> cprsIdentifiers)
	throws MethodException, IOException, ConnectionException
	{
		try
		{
			getLogger().debug("...executing getVistaImageListFromCprsIdentifiers method in V4.");

			VistaQuery query = VistaImagingQueryFactory.createGetImagesForCprsIdentifiers(cprsIdentifiers, filter);
			String vistaResponse = vistaSession.call(query);
			return VistaImagingTranslator.extractCprsImageListFromVistaResult(site, patientIdentifier, vistaResponse, filter);
		}
		catch(VistaMethodException vmX)
		{
			throw new MethodException(vmX);
		}
		catch(InvalidVistaCredentialsException icX)
		{
			throw new InvalidCredentialsException(icX);
		}
		catch(TranslationException trX)
		{
			throw new IOException(trX);
		} 
		catch (URNFormatException urnX)
		{
			throw new IOException(urnX);
		}
	}

	
}
