/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: June, 2018
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaisltjahjb
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

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaimagingdatasource.worklist.WorkItemDAO;

public class VistaImagingExternalPackageDataSourceServiceV6 
extends VistaImagingExternalPackageDataSourceServiceV5
{
	public final static String MAG_REQUIRED_VERSION = "3.0P197";
	
	public VistaImagingExternalPackageDataSourceServiceV6(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	{
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
		return "6";
	}


	@Override
	public List<WorkItem> getRemoteWorkItemListFromDataSource(
			RoutingToken globalRoutingToken, 
			String idType, 
			String patientId,
			String cptCode) 
	throws MethodException, ConnectionException 
	{
		getLogger().debug("...executing getRemoteWorkItemListFromDataSource method in V6.");
		VistaCommonUtilities.setDataSourceMethodAndVersion("getRemoteWorkItemListFromDataSource", getDataSourceVersion());

		WorkItemDAO dao = new WorkItemDAO(this);
		return dao.findByCpt(idType, patientId, cptCode);
	}
	
	@Override
	public boolean deleteRemoteWorkItemFromDataSource(
			RoutingToken globalRoutingToken,
			String id) 
	throws MethodException, ConnectionException 
	{
		getLogger().debug("...executing deleteRemoteWorkItemFromDataSource method in V6.");
		VistaCommonUtilities.setDataSourceMethodAndVersion("deletePreCacheRemoteWorkItem", getDataSourceVersion());

		WorkItemDAO dao = new WorkItemDAO(this);
		dao.delete(Integer.valueOf(id));
		return true;
	}
}
