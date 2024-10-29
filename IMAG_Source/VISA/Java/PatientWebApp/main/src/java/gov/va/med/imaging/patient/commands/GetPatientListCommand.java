/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 7, 2019
  Developer:  VHAISLTJAHJB
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

import java.util.List;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.converters.basic.DateConverter;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.patient.PatientRouter;

/**
 * @author VHAISLTJAHJB
 *
 */
public class GetPatientListCommand
extends AbstractPatientCommand<List<Patient>, String>
{
	private final String siteId;
	private final String searchCriteria;
	private final String interfaceVersion;

	/**
	 * @param methodName
	 */
	public GetPatientListCommand(
			String siteId, 
			String searchCriteria, 
			String interfaceVersion)
	{
		super("getPatientList");
		this.siteId = siteId;
		this.searchCriteria = searchCriteria;
		this.interfaceVersion = interfaceVersion;
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getSearchCriteria()
	{
		return searchCriteria;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<Patient> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		
		PatientRouter router = getRouter();		
		try
		{
			RoutingToken routingToken =
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());

			List<Patient> patients = 
					router.getPatientList(searchCriteria, routingToken);
            getLogger().info("{}, transaction({}) got {} Patient business objects from router.", getMethodName(), getTransactionId(), patients == null ? "null" : "" + patients.size());
			setEntriesReturned(patients.size());
			return patients;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for site '" + getSiteId() + 
				" search criteria: [" + getSearchCriteria() + "]";
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
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getInterfaceVersion()
	 */
	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}
	

}
