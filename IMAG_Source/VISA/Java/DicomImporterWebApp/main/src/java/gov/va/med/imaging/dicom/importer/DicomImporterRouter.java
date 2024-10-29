/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 15, 2008
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
package gov.va.med.imaging.dicom.importer;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.dicom.ImporterFilter;
import gov.va.med.imaging.exchange.business.dicom.OriginIndex;
import gov.va.med.imaging.exchange.business.dicom.UIDActionConfig;
import gov.va.med.imaging.exchange.business.dicom.importer.DiagnosticCode;
import gov.va.med.imaging.exchange.business.dicom.importer.ImagingLocation;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderFilter;
import gov.va.med.imaging.exchange.business.dicom.importer.ProcedureModifier;
import gov.va.med.imaging.exchange.business.dicom.importer.Report;
import gov.va.med.imaging.exchange.business.dicom.importer.ReportParameters;
import gov.va.med.imaging.exchange.business.dicom.importer.StandardReport;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.exchange.business.dicom.importer.Order;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderingLocation;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderingProvider;
import gov.va.med.imaging.exchange.business.dicom.importer.Procedure;

import java.util.List;

/**
 * @author vhaiswlouthj
 *
 */
@FacadeRouterInterface()
public interface DicomImporterRouter 
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false)
	public abstract List<OriginIndex> getOriginIndexList(RoutingToken routingToken) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract Study getStudyImportStatus(Study study) 
	throws MethodException, ConnectionException;

    // Order-related methods
	@FacadeRouterMethod(asynchronous=false)
	public abstract List<Order> getOrderListForPatient(OrderFilter orderFilter) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<OrderingProvider> getOrderingProviderList(String siteId, String searchString) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<OrderingLocation> getOrderingLocationList(String siteId) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<ImagingLocation> getImagingLocationList(String siteId) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<StandardReport> getStandardReportList(String siteId) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<DiagnosticCode> getDiagnosticCodeList(String siteId) 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<Procedure> getProcedureList(String siteId, String imagingLocationIen, String procedureIen) 
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public abstract List<ProcedureModifier> getProcedureModifierList(String siteId) 
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public abstract Report getImporterReport(ReportParameters reportParameters)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public abstract String getImporterVersionCompatible(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false)
	public List<UIDActionConfig> getDgwUIDActionTable(String type, String subType, String action) 
		throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<ImporterFilter> getWorkItemSources() 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<ImporterFilter> getWorkItemModalities() 
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false)
	public abstract List<ImporterFilter> getWorkItemProcedures() 
	throws MethodException, ConnectionException;
}
