/**
 * 
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.datasource;

import java.io.IOException;
import java.util.*;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrn;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrnResult;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.business.ImageFilterResult;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.business.LogAccessImageUrn;
import gov.va.med.imaging.viewer.business.LogAccessImageUrnResult;
import gov.va.med.imaging.viewer.business.QAReviewReportResult;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;
import gov.va.med.imaging.vistadatasource.VistaCommonQueryFactory;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.VistaImagingQueryFactory;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;

/**
 * @author Administrator
 *s
 */
public class ViewerImagingDataSourceService
extends AbstractVistaImagingDataSourceService
implements ViewerImagingDataSourceSpi, ViewerImagingCvixDataSourceSpi
{
	
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";
	public final static String SUPPORTED_CVIX_PROTOCOL = "vista";

	private final static Logger logger = Logger.getLogger(ViewerImagingDataSourceService.class);

	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59"; 
		
	//private SmbStorageUtility storageUtility = new SmbStorageUtility();
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public ViewerImagingDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static ViewerImagingDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new ViewerImagingDataSourceService(resolvedArtifactSource, protocol);
	}
	
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
	
	private VistaSession getVistaSession() 
    throws IOException, ConnectionException, MethodException
    {
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite(), ImagingSecurityContextType.MAG_WINDOWS);
    }
	
	private VistaSession getVistaSession(ImagingSecurityContextType securityContext) 
    throws IOException, ConnectionException, MethodException
    {
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite(), securityContext);
    }
	private Logger getLogger()
	{
		return logger;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImagingPatientDataSource#isVersionCompatible()
	 */
	@Override
    public boolean isVersionCompatible()
    {
		// for this implementation we are not using any MAG rpc calls, just assume version is ok
		return true;
    }

	
	protected String getDataSourceVersion()
	{
		return "1";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi#deleteImage(gov.va.med.RoutingToken, String)
	 */
	@Override
	public List<DeleteImageUrnResult> deleteImages(
			RoutingToken globalRoutingToken,
			List<DeleteImageUrn> imageUrns)
	throws MethodException,ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("deleteImage", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("deleteImage imageUrns({}) TransactionContext ({}).", imageUrns, TransactionContextFactory.get().getTransactionId());
		try
		{
			List<String> p34ImageUrns = getP34ImageFromDeleteImageUrnList(imageUrns);
			List<DeleteImageUrnResult> deletedList = null;
			
			if ((imageUrns != null) && (imageUrns.size() > 0))
			{
				vistaSession = getVistaSession();
				
				Map<String, String> imageUrnMap = MapImageUrnByIen(imageUrns);
				VistaQuery query = ViewerImagingQueryFactory.createDeleteImagesQuery(imageUrns);
				
				String ret = vistaSession.call(query);
				
				deletedList = ViewerImagingTranslator.translateDeleteImagesResult(ret, imageUrnMap);
			}
			
			if ((p34ImageUrns == null) || (p34ImageUrns.size() == 0))
			{
				return deletedList;
			}
			else
			{
				return ViewerImagingTranslator.mergeDeleteImagesErrorResult(
						deletedList, p34ImageUrns);
			}
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
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	private List<String> getP34ImageFromDeleteImageUrnList(List<DeleteImageUrn> imageUrns) 
	{
		List<String> errList = new ArrayList<String>();
		Iterator<DeleteImageUrn> iter = imageUrns.iterator();
		
		while (iter.hasNext()) {
			DeleteImageUrn urn = iter.next();

			if (urn.getValue().toLowerCase(Locale.ENGLISH).startsWith("urn:vap34image:"))
			{
				errList.add(urn.getValue());
				iter.remove();
			}
		}
		
		return errList;
	}

	private Map<String, String> MapImageUrnByIen(List<DeleteImageUrn> imageUrns) {
		Map<String, String> result = new HashMap<String, String>();
		for(int i = 0; i < imageUrns.size(); i++)
		{
			result.put(	
					ViewerImagingTranslator.getImageIen(imageUrns.get(i).getValue()), 
					imageUrns.get(i).getValue());
		}

		return result;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi#flagImagesAsSensitive(gov.va.med.RoutingToken, List)
	 */
	@Override
	public List<FlagSensitiveImageUrnResult> flagImagesAsSensitive(
			RoutingToken globalRoutingToken,
			List<FlagSensitiveImageUrn> imageUrns)
	throws MethodException,ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("flagImagesAsSensitive", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("flagImagesAsSensitive imageUrns({}) TransactionContext ({}).", imageUrns, TransactionContextFactory.get().getTransactionId());
		try
		{
			List<String> p34ImageUrns = getP34ImageFromFlagSensitiveImageUrnList(imageUrns);
			List<FlagSensitiveImageUrnResult> flagSensList = null;

			if ((imageUrns != null) && (imageUrns.size() > 0))
			{
				vistaSession = getVistaSession();
				
				Map<String, String> imageUrnMap = MapFlagSensitiveImageUrnByIen(imageUrns);
				VistaQuery query = ViewerImagingQueryFactory.createFlagSensitiveImagesQuery(imageUrns);
				
				String ret = vistaSession.call(query);

				flagSensList = ViewerImagingTranslator.translateFlagSensitiveImagesResult(
						ret, imageUrnMap);  
			}
			
			if ((p34ImageUrns == null) || (p34ImageUrns.size() == 0))
			{
				return flagSensList;
			}
			else
			{
				return ViewerImagingTranslator.mergeFlagSensitiveErrorResult(flagSensList, p34ImageUrns);
			}
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
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	private List<String> getP34ImageFromFlagSensitiveImageUrnList(List<FlagSensitiveImageUrn> imageUrns) 
	{
		List<String> errList = new ArrayList<String>();
		Iterator<FlagSensitiveImageUrn> iter = imageUrns.iterator();
		
		while (iter.hasNext()) {
			FlagSensitiveImageUrn urn = iter.next();

			if (urn.getImageUrn().toLowerCase(Locale.ENGLISH).startsWith("urn:vap34image:"))
			{
				errList.add(urn.getImageUrn());
				iter.remove();
			}
		}
		
		return errList;
	}


	private Map<String, String> MapFlagSensitiveImageUrnByIen(List<FlagSensitiveImageUrn> imageUrns) {
		Map<String, String> result = new HashMap<String, String>();
		for(int i = 0; i < imageUrns.size(); i++)
		{
			result.put(	
					ViewerImagingTranslator.getImageIen(imageUrns.get(i).getImageUrn()), 
					imageUrns.get(i).getImageUrn());
		}

		return result;
	}

	@Override
	public String getUserInformationByUserId(RoutingToken globalRoutingToken, String userId)
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getUserInformationByUserId", getDataSourceVersion());
		VistaSession vistaSession = null;
        logger.info("getUserInformationByUserId TransactionContext ({}).", TransactionContextFactory.get().getTransactionId());
		try
		{
			vistaSession = getVistaSession();
			VistaQuery query = ViewerImagingQueryFactory.createGetUserInformationByUserIdQuery(userId);
            logger.info("Executing query '{}'.", query.getRpcName());
			String rtn = vistaSession.call(query);
			String[] userInfo = StringUtils.Split(rtn,StringUtils.CARET);
			return userInfo[0] + StringUtils.CARET + userInfo[1];
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
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}		
        }
	}

	@Override
	public List<LogAccessImageUrnResult> logImageAccessByUrns(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			String patientDfn,
			List<LogAccessImageUrn> imageUrns)
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("logImageAccessByUrns", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("logImageAccessByUrns imageUrns({}) TransactionContext ({}).", imageUrns, TransactionContextFactory.get().getTransactionId());
		try
		{
			List<String> p34ImageUrns = getP34ImageFromLogAccessImageUrnList(imageUrns);
			List<LogAccessImageUrnResult> logAccessList = null;

			if ((imageUrns != null) && (imageUrns.size() > 0))
			{
				vistaSession = getVistaSession();
				
				if ((patientDfn == null) || (patientDfn.isEmpty()))
				{
					patientDfn = VistaCommonUtilities.getPatientDFN(vistaSession, patientIcn);
					if ((patientDfn == null) || (patientDfn.isEmpty()))
					{
						return null;
					}
				}

				Map<String, String> imageUrnMap = MapLogAccessImageUrnByIen(imageUrns);
				VistaQuery query = ViewerImagingQueryFactory.createLogAccessImagesQuery(patientDfn, imageUrns);
				
				String ret = vistaSession.call(query);

				logAccessList = ViewerImagingTranslator.translateLogAccessImagesResult(ret, imageUrnMap);
			}
			
			if ((p34ImageUrns == null) || (p34ImageUrns.size() == 0))
			{
				return logAccessList;
			}
			else
			{
				return ViewerImagingTranslator.mergeLogAccessErrorResult(logAccessList, p34ImageUrns);
			}
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
        	// OLD: try{vistaSession.close();} catch(Throwable t){}
        	try{ if(vistaSession != null) { vistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
		}
	}

	private List<String> getP34ImageFromLogAccessImageUrnList(List<LogAccessImageUrn> imageUrns) {
		List<String> errList = new ArrayList<String>();
		Iterator<LogAccessImageUrn> iter = imageUrns.iterator();
		
		while (iter.hasNext()) {
			LogAccessImageUrn urn = iter.next();

			if (urn.getImageUrn().toLowerCase(Locale.ENGLISH).startsWith("urn:vap34image:"))
			{
				errList.add(urn.getImageUrn());
				iter.remove();
			}
		}

		return errList;
	}

	private Map<String, String> MapLogAccessImageUrnByIen(List<LogAccessImageUrn> imageUrns) {
		Map<String, String> result = new HashMap<String, String>();
		for(int i = 0; i < imageUrns.size(); i++)
		{
			result.put(	
					ViewerImagingTranslator.getImageIen(imageUrns.get(i).getImageUrn()), 
					imageUrns.get(i).getImageUrn());
		}

		return result;
	}

	@Override
	public List<TreatingFacilityResult> getTreatingFacilities(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			String patientDfn) 
	throws MethodException, ConnectionException {
		PatientIdentifier patientIdentifier = getPatientIdentifier(patientIcn, patientDfn);

		VistaCommonUtilities.setDataSourceMethodAndVersion("getTreatingFacilities", getDataSourceVersion());
        logger.info("getTreatingSites({}) TransactionContext ({}).", patientIdentifier, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.CPRS_CONTEXT);        	
        	String dfn = VistaCommonUtilities.getPatientDfn(
        			localVistaSession, 
        			patientIdentifier);
        	
        	VistaQuery vm = VistaCommonQueryFactory.createCprsGetTreatingSitesVistaQuery(dfn);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertTreatingFacilities(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in getTreatingFacilities", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in getTreatingFacilities", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(PatientNotFoundException pnfX)
        {
            logger.error("Patient not found [{}]", patientIdentifier, pnfX);
        	// JMW 12/14/2010 - throw the exception now
        	// necessary so we can provide the correct error for XCA requests
        	throw pnfX;
        	// return null;
        	// JMW 9/22/2009
        	// not really sure about this, was returning null but that creating inconsistencies
        	// with Federation which would return an empty array list since the command 
        	// converts the null to the array list, now doing that here instead to be 
        	// consistent.  Might want to throw exception or return null and handle 
        	// differently to allow knowledge of the patient not found versus having now sites.
        	//return new ArrayList<String>(0);
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	private PatientIdentifier getPatientIdentifier(String patientIcn, String patientDfn) 
	{
		PatientIdentifier patientIdentifier = null;
		if ((patientIcn != null) && (!patientIcn.isEmpty()))
		{
			patientIdentifier = 
					PatientIdentifier.icnPatientIdentifier(patientIcn);
		}
		else if ((patientDfn != null) && (!patientDfn.isEmpty()))
		{
			patientIdentifier = 
					PatientIdentifier.dfnPatientIdentifier(patientDfn, getSite().getSiteNumber());
		}
		return patientIdentifier;
	}

	@Override
	public List<CaptureUserResult> getCaptureUsers(
			RoutingToken globalRoutingToken, 
			String appFlag,
			String fromDate,
			String throughDate) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getCaptureUsers", getDataSourceVersion());
        logger.info("getCaptureUsers({},{}) TransactionContext ({}).", fromDate, throughDate, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	
        	VistaQuery vm = VistaCommonQueryFactory.createGetCaptureUsersVistaQuery(appFlag, fromDate, throughDate);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertCaptureUsers(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in getCaptureUsers", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in getCaptureUsers", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	
	@Override
	public List<ImageFilterResult> getImageFilters(
			RoutingToken globalRoutingToken, 
			String userId) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getImageFilters", getDataSourceVersion());
        logger.info("getImageFilters({}) TransactionContext ({}).", userId, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	
        	VistaQuery vm = VistaCommonQueryFactory.createGetImageFiltersVistaQuery(userId);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertImageFilters(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	
	@Override
	public List<ImageFilterFieldValue> getImageFilterDetail(
			RoutingToken globalRoutingToken, 
			String filterIen,
			String filterName,
			String userId
			) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getImageFilterDetail", getDataSourceVersion());
        logger.info("getImageFilterDetail({},{},{}) TransactionContext ({}).", filterIen, filterName, userId, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	
        	VistaQuery vm = VistaCommonQueryFactory.createGetImageFilterDetailVistaQuery(filterIen, filterName, userId);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertImageFilterDetail(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public String saveImageFilter(
			RoutingToken globalRoutingToken, 
			List<ImageFilterFieldValue> imageFilterFieldValues) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("saveImageFilter", getDataSourceVersion());
        logger.info("saveImageFilter({}) TransactionContext ({}).", imageFilterFieldValues, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	HashMap<String, String> params = new HashMap<String, String>(17);
        	params.clear();
        	
        	int i = 0;
			for (ImageFilterFieldValue imageFilterFieldValue : imageFilterFieldValues)
			{
				params.put(Integer.toString(++i),imageFilterFieldValue.getFieldName() + "^" + imageFilterFieldValue.getFieldValue());
			}
    			
        	VistaQuery vm = VistaCommonQueryFactory.createSaveImageFilterVistaQuery(params);
        	return localVistaSession.call(vm);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public String deleteImageFilter(
			RoutingToken globalRoutingToken, 
			String filterIen) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("deleteImageFilter", getDataSourceVersion());
        logger.info("deleteImageFilter({}) TransactionContext ({}).", filterIen, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	
        	VistaQuery vm = VistaCommonQueryFactory.createDeleteImageFilterVistaQuery(filterIen);
        	return localVistaSession.call(vm);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public List<QAReviewReportResult> getQAReviewReports(RoutingToken routingToken, String userId)
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getQAReviewReports", getDataSourceVersion());
        logger.info("getQAReviewReports({}) TransactionContext ({}).", userId, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	
        	VistaQuery vm = VistaCommonQueryFactory.createGetQAReviewReportsVistaQuery(userId);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertQAReviewReports(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public String getQAReviewReportData(RoutingToken routingToken, String flags, String fromDate,
			String throughDate, String mque) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getQAReviewReportData", getDataSourceVersion());
        logger.info("getQAReviewReportData({}, {}, {}, {}) TransactionContext ({}).", flags, fromDate, throughDate, mque, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	
        	VistaQuery vm = VistaCommonQueryFactory.createGetQAReviewReportDataVistaQuery(flags, fromDate, throughDate, mque);
        	return localVistaSession.call(vm);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public String setImageProperties(RoutingToken routingToken,
			List<ImageProperty> imageProperties) 
	throws MethodException, ConnectionException {
		VistaCommonUtilities.setDataSourceMethodAndVersion("setImageProperties", getDataSourceVersion());
        logger.info("setImageProperties({}) TransactionContext ({}).", imageProperties, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	

        	HashMap<String, String> parameters = new HashMap<String, String>();
    		
    		for(int i = 0; i < imageProperties.size(); i++)
    		{
    			parameters.put("\"" + i + "\"", 
    					imageProperties.get(i).getIen() + "^" + 
    					imageProperties.get(i).getName() + "^" +
    					imageProperties.get(i).getValue() + "^" +
    					imageProperties.get(i).getFlags());
    		}
        	
        	VistaQuery vm = VistaCommonQueryFactory.createSetImagePropertiesVistaQuery(parameters);
        	return localVistaSession.call(vm);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
	}

	@Override
	public List<ImageProperty> getImageProperties(RoutingToken routingToken, String imageIEN, String props,
			String flags) 
	throws MethodException, ConnectionException 
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getImageProperties", getDataSourceVersion());
        logger.info("getImageProperties({},{},{}) TransactionContext ({}).", imageIEN, props, flags, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.MAG_WINDOWS);        	
        	//HashMap<String, String> params = new HashMap<String, String>();
        	
        	VistaQuery vm = VistaCommonQueryFactory.createGetImagePropertiesVistaQuery(imageIEN, props, flags);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertImageProperties(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in localVistaSession", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}       	
        }
	}

	@Override
	public List<TreatingFacilityResult> getCvixTreatingFacilities(RoutingToken globalRoutingToken, String patientIcn,
			String patientDfn) throws MethodException, ConnectionException {
		PatientIdentifier patientIdentifier = getPatientIdentifier(patientIcn, patientDfn);

		VistaCommonUtilities.setDataSourceMethodAndVersion("getCvixTreatingFacilities", getDataSourceVersion());
        logger.info("getTreatingSites({}) TransactionContext ({}).", patientIdentifier, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
        try
        {
        	localVistaSession = getVistaSession(ImagingSecurityContextType.CPRS_CONTEXT);        	
        	String dfn = VistaCommonUtilities.getPatientDfn(
        			localVistaSession, 
        			patientIdentifier);
        	
        	VistaQuery vm = VistaCommonQueryFactory.createCprsGetTreatingSitesVistaQuery(dfn);
        	String rtn = localVistaSession.call(vm);
	        return ViewerImagingTranslator.convertCvixTreatingFacilities(rtn);
        } 
        catch (VistaMethodException e)
        {
        	logger.error("Error in getTreatingFacilities", e);
        	throw new MethodException(e.getMessage());
        } 
        catch (InvalidVistaCredentialsException e)
        {
        	logger.error("Error in getTreatingFacilities", e);
        	throw new InvalidCredentialsException(e.getMessage());
        }
        catch(PatientNotFoundException pnfX)
        {
            logger.error("Patient not found [{}]", patientIdentifier, pnfX);
        	// JMW 12/14/2010 - throw the exception now
        	// necessary so we can provide the correct error for XCA requests
        	throw pnfX;
        	// return null;
        	// JMW 9/22/2009
        	// not really sure about this, was returning null but that creating inconsistencies
        	// with Federation which would return an empty array list since the command 
        	// converts the null to the array list, now doing that here instead to be 
        	// consistent.  Might want to throw exception or return null and handle 
        	// differently to allow knowledge of the patient not found versus having now sites.
        	//return new ArrayList<String>(0);
        }
        catch(IOException ioX)
        {
        	logger.error("Exception getting VistA session", ioX);
        	throw new ConnectionException(ioX);
        }
        finally
        {
        	// Fortify change: check for null first
        	// OLD: try{localVistaSession.close();}catch(Throwable t){}
        	try{ if(localVistaSession != null) { localVistaSession.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}       	
        }
	}

}
