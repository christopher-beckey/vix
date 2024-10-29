/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 30, 2013
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.vixserverhealth.monitorederror.rest;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.monitorederrors.MonitoredError;
import gov.va.med.imaging.monitorederrors.MonitoredErrorConfiguration;
import gov.va.med.imaging.monitorederrors.MonitoredErrors;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.vixserverhealth.monitorederror.rest.types.MonitoredErrorTranslator;
import gov.va.med.imaging.vixserverhealth.monitorederror.rest.types.MonitoredErrorsType;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("monitorederror")
public class MonitoredErrorRestService
{
	
	@GET
	@Path("monitorederrors")
	@Produces(MediaType.APPLICATION_XML)
	public MonitoredErrorsType getMonitoredErrors()
	{
		List<MonitoredError> monitoredErrors =
				MonitoredErrors.getMonitoredErrors();
		return MonitoredErrorTranslator.translate(monitoredErrors);
	}
	
	@POST
	@Path("add")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public RestBooleanReturnType addMonitoredError(
			RestStringType monitoredError)
	{
		MonitoredErrorConfiguration configuration = MonitoredErrorConfiguration.getMonitoredConfiguration();
		String monitoredErrorValue = monitoredError.getValue();
		boolean result = false;
		if(monitoredErrorValue != null && monitoredErrorValue.length() > 0)
		{
			if(configuration.addUniqueMonitoredError(monitoredError.getValue()))
			{
				updateMonitoredErrorConfiguration(configuration);
				result = true;
			}
		}
		return new RestBooleanReturnType(result);
	}
	
	@POST
	@Path("delete")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public RestBooleanReturnType deleteMonitoredError(
			RestStringType monitoredError)
	{
		MonitoredErrorConfiguration configuration = MonitoredErrorConfiguration.getMonitoredConfiguration();
		List<String> errorsToKeep = new ArrayList<String>();
		List<String> monitoredErrors = configuration.getMonitoredErrors();
		String monitoredErrorToDelete = monitoredError.getValue();
		for(String currentMonitoredError : monitoredErrors)
		{
			if(!currentMonitoredError.equals(monitoredErrorToDelete))
			{
				errorsToKeep.add(currentMonitoredError);
			}
		}
		configuration.getMonitoredErrors().clear();
		configuration.getMonitoredErrors().addAll(errorsToKeep);
		updateMonitoredErrorConfiguration(configuration);
		
		return new RestBooleanReturnType(true);
	}

	protected void updateMonitoredErrorConfiguration(MonitoredErrorConfiguration configuration)
	{
		configuration.storeConfiguration();
		FacadeConfigurationFactory.getConfigurationFactory().clearConfiguration(MonitoredErrorConfiguration.class);
		MonitoredErrors.reloadFromConfiguration();
	}
}
