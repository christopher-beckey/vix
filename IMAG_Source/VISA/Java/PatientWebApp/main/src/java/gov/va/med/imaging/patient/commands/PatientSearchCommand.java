/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.patient.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.patient.PatientRouter;

import java.util.List;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.converters.basic.DateConverter;

/**
 * @author vhaiswlouthj
 *
 */
public class PatientSearchCommand 
extends AbstractPatientCommand<List<Patient>, String>
{
	private final String searchCriteria;
	private final String interfaceVersion;
	
	public PatientSearchCommand(String searchCriteria, 
			String interfaceVersion)
	{
		super("searchPatients");
		this.searchCriteria = searchCriteria;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<Patient> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		PatientRouter router = getRouter();		
		List<Patient> patients = 
			router.getPatientList(searchCriteria, getLocalRoutingToken());
        getLogger().info("{}, transaction({}) got {} Patient business objects from router.", getMethodName(), getTransactionId(), patients == null ? "null" : "" + patients.size());
		setEntriesReturned(patients.size());
		return patients;
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "search criteria: [" + searchCriteria + "]";
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(List<Patient> routerResult) 
	throws TranslationException 
	{

    	// Get and configure XStream
		XStream xstream = getXStream();
    	xstream.alias("ArrayOfPatient", List.class);
    	xstream.alias("Patient", Patient.class);
    	xstream.registerConverter(new DateConverter("MM/dd/yyyy", new String[] {"MM/dd/yyyy"}));
    	
    	String result = xstream.toXML(routerResult);
    	return result;
	}

	public String getSearchCriteria()
	{
		return searchCriteria;
	}

}
