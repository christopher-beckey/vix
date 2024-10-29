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
package gov.va.med.imaging.dicom.importer.commands.order;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.DicomImporterRouter;
import gov.va.med.imaging.dicom.importer.commands.AbstractDicomImporterCommand;
import gov.va.med.imaging.exchange.business.dicom.importer.DiagnosticCode;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderingLocation;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import java.util.List;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class GetDiagnosticCodeListCommand 
extends AbstractDicomImporterCommand<List<DiagnosticCode>, String>
{
	private final String interfaceVersion;
	private final String siteId;
	
	public GetDiagnosticCodeListCommand(String siteId, String interfaceVersion)
	{
		super("getDiagnosticCodeListCommand");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<DiagnosticCode> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		DicomImporterRouter router = getRouter();		
		List<DiagnosticCode> result = router.getDiagnosticCodeList(siteId);
		setEntriesReturned(result.size());
		return result;
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "";
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(List<DiagnosticCode> routerResult) 
	throws TranslationException 
	{
		XStream xstream = ImporterUtils.getXStream();
		xstream.alias("ArrayOfDiagnosticCode", List.class);
    	return xstream.toXML(routerResult);
	}

}
