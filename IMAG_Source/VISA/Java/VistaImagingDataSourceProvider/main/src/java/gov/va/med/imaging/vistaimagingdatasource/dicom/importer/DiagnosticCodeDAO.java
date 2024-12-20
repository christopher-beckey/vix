/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Mar 18, 2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author vhaiswlouthj
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.vistaimagingdatasource.dicom.importer;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.dicom.importer.DiagnosticCode;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaSessionFactory;

import java.util.ArrayList;
import java.util.List;

import com.thoughtworks.xstream.XStream;

public class DiagnosticCodeDAO extends BaseImporterDAO<DiagnosticCode>
{
	private static String FIND_ALL = "MAGV GET RAD DX CODES";
	//
	// Constructor
	//
	public DiagnosticCodeDAO(){}
	public DiagnosticCodeDAO(VistaSessionFactory sessionFactory)
	{
		this.setSessionFactory(sessionFactory);
	}
	
	public List<DiagnosticCode> findDiagnosticCodesForDivision(String divisionId) 
	throws MethodException, ConnectionException 
	{
		VistaQuery vm = generateFindDiagnosticCodesQuery(divisionId);
		String results = executeRPC(vm);
		return translateFindDiagnosticCodes(results);
		
	}

	public VistaQuery generateFindDiagnosticCodesQuery(String divisionId) throws MethodException
	{
		VistaQuery vm = new VistaQuery(FIND_ALL);
//		vm.addParameter(VistaQuery.LITERAL, divisionId);
		
		return vm;
	}
	
	public List<DiagnosticCode> translateFindDiagnosticCodes(String results) 
	throws MethodException
	{
		// The string contains an XML representation of the Diagnostic Code list. Use 
		// XStream to convert it to business objects
		XStream xstream = ImporterUtils.getXStream();
		xstream.alias("ArrayOfDiagnosticCode", List.class);
		
		List<DiagnosticCode> diagnosticCodes = (List<DiagnosticCode>) xstream.fromXML(results);
			
		return diagnosticCodes;	
	}
	
}
