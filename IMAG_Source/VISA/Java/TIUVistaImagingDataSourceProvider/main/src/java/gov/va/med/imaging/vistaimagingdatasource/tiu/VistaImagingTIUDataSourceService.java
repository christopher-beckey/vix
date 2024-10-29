/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.tiu;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ElectronicSignatureResult;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.EncryptionUtils;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.VistaImagingQueryFactory;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaimagingdatasource.tiu.VistaImagingTIUQueryFactory.UpdateNoteStatus;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingTIUDataSourceService
extends AbstractVistaImagingDataSourceService
implements TIUNoteDataSourceSpi
{

	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	private final static Logger logger = Logger.getLogger(VistaImagingTIUDataSourceService.class);
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59"; 		
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingTIUDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static VistaImagingTIUDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaImagingTIUDataSourceService(resolvedArtifactSource, protocol);
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
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite());
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
	throws SecurityCredentialsExpiredException
	{
		String version = VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				getVistaImagingConfiguration(), this.getClass(), 
				MAG_REQUIRED_VERSION);

        logger.info("isVersionCompatible searching for version [{}], TransactionContext ({}).", version, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
		try {
			localVistaSession = getVistaSession();	
			return VistaImagingCommonUtilities.isVersionCompatible(version, localVistaSession);	
		} catch(SecurityCredentialsExpiredException sceX) {
			// caught here to be sure it gets thrown as SecurityCredentialsExpiredException, not ConnectionException
			throw sceX;
		} catch (Exception e) {
			logger.error("There was an error finding the installed Imaging version from VistA", e);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (e == null ? "<null error>" : e.getMessage()));
		} finally {
			if (localVistaSession != null) {
				try {
					localVistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}		
		return false;
	}
	
	protected String getDataSourceVersion()
	{
		return "1";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#getMatchingTIUNotes(gov.va.med.RoutingToken, java.lang.String)
	 */
	@Override
	public List<TIUNote> getMatchingTIUNotes(RoutingToken globalRoutingToken,
		String searchText, String titleList)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getMatchingTIUNotes", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getMatchingTIUNotes ({}) TransactionContext ({}).", searchText, TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();			
			VistaQuery query = VistaImagingTIUQueryFactory.createGetTiuNotesQuery(searchText, titleList);
			String rtn = vistaSession.call(query);
			return VistaImagingTIUTranslator.translateTIUNotes(rtn, getSite());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting matching TIU notes from vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#getAuthors(gov.va.med.RoutingToken, java.lang.String)
	 */
	@Override
	public List<TIUAuthor> getAuthors(RoutingToken globalRoutingToken,
		String searchText) 
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getAuthors", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getAuthors ({}) TransactionContext ({}).", searchText, TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();			
			VistaQuery query = VistaImagingTIUQueryFactory.createGetTiuAuthors(searchText);
			String rtn = vistaSession.call(query);
			return VistaImagingTIUTranslator.translateAuthors(rtn, getSite());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting authors from vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#getLocations(gov.va.med.RoutingToken, java.lang.String)
	 */
	@Override
	public List<TIULocation> getLocations(RoutingToken globalRoutingToken,
		String searchText) 
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getLocations", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getLocations ({}) TransactionContext ({}).", searchText, TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();			
			VistaQuery query = VistaImagingTIUQueryFactory.createGetTiuLocations(searchText);
			String rtn = vistaSession.call(query);
			return VistaImagingTIUTranslator.translateLocations(rtn, getSite());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting locations from vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#associateImageWithTIUNote(gov.va.med.imaging.ImageURN, gov.va.med.imaging.tiu.TIUItemURN)
	 */
	@Override
	public Boolean associateImageWithTIUNote(AbstractImagingURN imagingUrn,
		PatientTIUNoteURN tiuNoteUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("associateImageWithTIUNote", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("associateImageWithTIUNote ({}, {}) TransactionContext ({}).", imagingUrn.toString(SERIALIZATION_FORMAT.RAW), tiuNoteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();			
			VistaQuery query = VistaImagingTIUQueryFactory.createAssociateImageWithNoteQuery(imagingUrn, tiuNoteUrn);
			String rtn = vistaSession.call(query);
			if(rtn.startsWith("1"))
			{
                getLogger().info("Associated image [{}] with TIU Note [{}], {}", imagingUrn.toString(SERIALIZATION_FORMAT.RAW), tiuNoteUrn.toString(), rtn);
				return true;
			}
			throw new MethodException("Error associated image with TIU note, " + rtn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error associating image with tiu note via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#createTIUNote(gov.va.med.RoutingToken, gov.va.med.PatientIdentifier, java.lang.String, gov.va.med.imaging.tiu.TIUItemURN, java.util.Date, gov.va.med.imaging.tiu.TIUItemURN, java.lang.String)
	 */
	@Override
	public PatientTIUNoteURN createTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
		TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("createTIUNote", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("createTIUNote ({}, {}) TransactionContext ({}).", patientIdentifier, noteUrn, TransactionContextFactory.get().getTransactionId());

		try {
			vistaSession = getVistaSession();
			String patientDfn = getPatientDfn(vistaSession, patientIdentifier);
			VistaQuery query = VistaImagingTIUQueryFactory.createTIUNoteQuery(patientDfn, locationUrn, noteDate, noteUrn, consultUrn, noteText, authorUrn);
			String rtn = vistaSession.call(query);
			if (rtn.startsWith("0")) {
				throw new MethodException("Error creating TIU Note, " + rtn);
			}
			String ien = StringUtils.MagPiece(rtn, StringUtils.CARET, 1);		
			return PatientTIUNoteURN.create(getSite().getRepositoryId(), ien, patientIdentifier);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error creating tiu note via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#electronicallySignTIUNote(gov.va.med.imaging.tiu.TIUItemURN, java.lang.String)
	 */
	@Override
	public Boolean electronicallySignTIUNote(PatientTIUNoteURN tiuNoteUrn,
		String electronicSignature)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("electronicallySignTIUNote", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("electronicallySignTIUNote ({}) TransactionContext ({}).", tiuNoteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			String hashedElectronicSignature = verifyElectronicSignature(vistaSession, electronicSignature);					
			String patientDfn = getPatientDfn(vistaSession, tiuNoteUrn.getThePatientIdentifier());
			VistaQuery query = VistaImagingTIUQueryFactory.createModifyTIUNoteQuery(patientDfn, tiuNoteUrn.getItemId(), UpdateNoteStatus.electronicallySigned, hashedElectronicSignature);
			String rtn = vistaSession.call(query);
			if (rtn.startsWith("0")) {
				throw new MethodException("Error updating TIU Note, " + rtn);
			}
			return true;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error electronically signing TIU note via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}
	
	private String verifyElectronicSignature(VistaSession vistaSession, String electronicSignature) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException, MethodException
	{
		VistaQuery vistaQuery = VistaImagingQueryFactory.createVerifyElectronicSignatureQuery(electronicSignature);
		
		String rtn = vistaSession.call(vistaQuery);
		ElectronicSignatureResult electronicSignatureResult = VistaImagingTranslator.translateElectronicSignature(rtn);
		if(electronicSignatureResult.isSuccess())
		{
			return EncryptionUtils.encrypt(electronicSignature);
		}
		else
		{
			throw new MethodException("Invalid electronic signature");
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#electronicallyFileTIUNote(gov.va.med.imaging.tiu.TIUItemURN, gov.va.med.PatientIdentifier)
	 */
	@Override
	public Boolean electronicallyFileTIUNote(PatientTIUNoteURN tiuNoteUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("electronicallyFileTIUNote", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("electronicallyFileTIUNote ({}) TransactionContext ({}).", tiuNoteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			String patientDfn = getPatientDfn(vistaSession, tiuNoteUrn.getThePatientIdentifier());
			VistaQuery query = VistaImagingTIUQueryFactory.createModifyTIUNoteQuery(patientDfn, tiuNoteUrn.getItemId(), UpdateNoteStatus.electronicallyFiled, null);
			String rtn = vistaSession.call(query);
			if (rtn.startsWith("0")) {
				throw new MethodException("Error updating TIU Note, " + rtn);
			}
			return true;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error electronically filing TIU note via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#isTIUNote(gov.va.med.imaging.tiu.TIUItemURN)
	 */
	@Override
	public Boolean isTIUNoteAConsult(TIUItemURN tiuNoteUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("isTIUNoteAConsult", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("isTIUNoteAConsult ({}) TransactionContext ({}).", tiuNoteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			VistaQuery query = VistaImagingTIUQueryFactory.createIsNoteAConsultQuery(tiuNoteUrn);
			String rtn = vistaSession.call(query);
			if (rtn.equals("1")) {
				return true;
			}
			return false;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if TIU note is a consult via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#isValidAdvanceDirective(gov.va.med.imaging.tiu.TIUItemURN, boolean)
	 */
	@Override
	public Boolean isNoteValidAdvanceDirective(TIUItemURN noteUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("isNoteValidAdvanceDirective", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("isNoteValidAdvanceDirective ({}) TransactionContext ({}).", noteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			VistaQuery query = VistaImagingTIUQueryFactory.createIsAdvanceDirectiveQuery(noteUrn.getItemId(), true);
			String rtn = vistaSession.call(query);
			if (rtn.startsWith("1")) {
				return true;
			}
			return false;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if note is valid advance directive via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#isPatientNoteValidAdvanceDirective(gov.va.med.imaging.tiu.PatientTIUNoteURN)
	 */
	@Override
	public Boolean isPatientNoteValidAdvanceDirective(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("isPatientNoteValidAdvanceDirective", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("isPatientNoteValidAdvanceDirective ({}) TransactionContext ({}).", noteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			VistaQuery query = VistaImagingTIUQueryFactory.createIsAdvanceDirectiveQuery(noteUrn.getNoteId(), false);
			String rtn = vistaSession.call(query);
			if (rtn.startsWith("1")) {
				return true;
			}
			return false;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if patient note is a valid advance directive via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#getPatientTIUNotes(gov.va.med.RoutingToken, gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus, gov.va.med.PatientIdentifier, java.util.Date, java.util.Date, java.lang.String, int, boolean)
	 */
	@Override
	public List<PatientTIUNote> getPatientTIUNotes(
		RoutingToken globalRoutingToken, TIUNoteRequestStatus noteStatus,
		PatientIdentifier patientIdentifier, Date fromDate, Date toDate,
		String authorDuz, int count, boolean ascending)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getPatientTIUNotes", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getPatientTIUNotes ({}, {}) TransactionContext ({}).", patientIdentifier.toString(), noteStatus, TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			String patientDfn = getPatientDfn(vistaSession, patientIdentifier);
			VistaQuery query = VistaImagingTIUQueryFactory.createGetPatientTIUNotesQuery(noteStatus, patientDfn, fromDate, toDate, authorDuz, count, ascending);
			String rtn = vistaSession.call(query);
			return VistaImagingTIUTranslator.translatePatientTiuNotes(rtn, patientIdentifier, getSite());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting patient tiu notes via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#getTIUNoteDetails(gov.va.med.imaging.tiu.PatientTIUNoteURN)
	 */
	@Override
	public String getTIUNoteText(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("getTIUNoteText", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("getTIUNoteText ({}) TransactionContext ({}).", noteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			VistaQuery query = VistaImagingTIUQueryFactory.createGetTIUNoteDetailsQuery(noteUrn);
			String rtn = vistaSession.call(query);
			return rtn;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu note text via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi#createTIUNoteAddendum(gov.va.med.imaging.tiu.TIUItemURN, gov.va.med.PatientIdentifier, java.util.Date, java.lang.String)
	 */
	@Override
	public PatientTIUNoteURN createTIUNoteAddendum(PatientTIUNoteURN noteUrn, Date date, String addendumText)
	throws MethodException, ConnectionException
	{
		VistaCommonUtilities.setDataSourceMethodAndVersion("createTIUNoteAddendum", getDataSourceVersion());
		VistaSession vistaSession = null;
        getLogger().info("createTIUNoteAddendum ({}) TransactionContext ({}).", noteUrn.toString(), TransactionContextFactory.get().getTransactionId());
		try {
			vistaSession = getVistaSession();
			PatientIdentifier patientIdentifier = noteUrn.getThePatientIdentifier();
			String patientDfn = getPatientDfn(vistaSession, patientIdentifier);
			VistaQuery query = VistaImagingTIUQueryFactory.createTIUNoteAddendumQuery(patientDfn, noteUrn, date, addendumText);
			String rtn = vistaSession.call(query);
			String addendumIen = StringUtils.MagPiece(rtn,  StringUtils.CARET, 1);
			if(Integer.parseInt(addendumIen) > 0)
			{
				try
				{
					return PatientTIUNoteURN.create(getSite().getRepositoryId(), addendumIen, patientIdentifier);
				}
				catch(URNFormatException urnfX)
				{
					throw new MethodException(urnfX);
				}
			}
			throw new MethodException("Error creating addendum, " + rtn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error creating tiu note addendum via vista", e);
		} finally {
			if (vistaSession != null) {
				try {
					vistaSession.close();
				} catch (Throwable t) {
					// Ignore
				}
			}
		}
	}

	@Override
	public Boolean isTIUNoteValid(RoutingToken globalRoutingToken, TIUItemURN noteUrn, PatientTIUNoteURN patientNoteUrn,
			String typeIndex) 
	throws MethodException, ConnectionException 
	{
		try {
			boolean advDirective = typeIndex.equals("ADVANCE DIRECTIVE");
			if (advDirective) {
				if (noteUrn == null && patientNoteUrn == null) {
					throw new MethodException("Image is configured as an ADVANCE DIRECTIVE and must be associated with a ADVANCE DIRECTIVE note.\nPlease select an ADVANCE DIRECTIVE note to store this image");
				}
			}

			if (noteUrn == null && patientNoteUrn == null) {
				// not an ADVANCE DIRECTIVE and no TIU note - no problem
				return true;
			}

			boolean isAdvanceDirectiveNode = false;

			if (noteUrn != null) {
				isAdvanceDirectiveNode = isNoteValidAdvanceDirective(noteUrn);
			} else if (patientNoteUrn != null) {
				isAdvanceDirectiveNode = isPatientNoteValidAdvanceDirective(patientNoteUrn);
			}

			if ((!isAdvanceDirectiveNode && !advDirective) || (isAdvanceDirectiveNode && advDirective)) {
				// all good - nothing to do, keep working to store image
			} else {
				if (!isAdvanceDirectiveNode) {
					throw new MethodException("ADVANCE DIRECTIVE images must be associated with an ADVANCE DIRECTIVE note\n\nSelect an ADVANCE DIRECTIVE Note to continue");
				}
				if (!advDirective) {
					throw new MethodException("Images associated with an ADVANCE DIRECTIVE Note must have Doc/Image Type of: ADVANCE DIRECTIVE");
				}
			}
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if tiu note is valid", e);
		}
		
		return true;
	}

}
