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
import gov.va.med.imaging.exchange.business.dicom.ImporterFilter;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaSessionFactory;

import java.util.ArrayList;
import java.util.List;

import com.thoughtworks.xstream.XStream;

public class WorkItemSourceDAO extends BaseImporterDAO<ImporterFilter>
{
	private static String GET_WORK_ITEM_SOURCES = "MAGV GET WORK ITEM SOURCES";

	//
	// Constructor
	//
	public WorkItemSourceDAO(){}
	public WorkItemSourceDAO(VistaSessionFactory sessionFactory)
	{
		this.setSessionFactory(sessionFactory);
	}
	
	public List<ImporterFilter> getWorkItemSources() 
	throws MethodException, ConnectionException 
	{
		VistaQuery vm = generateGetWorkItemSourcesQuery();
		String results = executeRPC(vm);
		return translateImporterFilter(results);
	}

	public VistaQuery generateGetWorkItemSourcesQuery() throws MethodException
	{
		// Create the query
		VistaQuery vm = new VistaQuery(GET_WORK_ITEM_SOURCES);
		return vm;
	}

	public List<ImporterFilter> translateImporterFilter(String results) 
	throws MethodException
	{
		// Split the result into lines
		String[] lines = StringUtils.Split(results, LINE_SEPARATOR);
		
		// Split the first line into fields
		String[] fields = StringUtils.Split(lines[0], FIELD_SEPARATOR);
		
		// If the code is less than 0, throw an exception with the message
		int code = Integer.parseInt(fields[0]);
		if (code < 0)
		{
			throw new MethodException(fields[1]);
		}
		
		// We made it here, so create the list of work items
		List<ImporterFilter> sources = new ArrayList<ImporterFilter>();

		// Skip the first line (which was the record count)
		for (int i=1; i<lines.length; i++)
		{
			sources.add(new ImporterFilter(lines[i]));
		}
		
		return sources;
	}
	
}
