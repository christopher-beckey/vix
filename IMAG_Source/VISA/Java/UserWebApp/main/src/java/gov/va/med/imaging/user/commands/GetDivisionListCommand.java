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
package gov.va.med.imaging.user.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.exchange.business.AuditEvent;
import gov.va.med.imaging.exchange.business.Division;
import gov.va.med.imaging.exchange.business.UserCredentials;
import gov.va.med.imaging.exchange.business.WelcomeMessage;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.user.UserContext;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

import java.util.HashMap;
import java.util.List;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

/**
 * @author vhaiswlouthj
 *
 */
public class GetDivisionListCommand 
extends AbstractUserCommand<List<Division>, String>
{
	private final String interfaceVersion;
	private final String accessCode;
	
	public GetDivisionListCommand(String accessCode, String interfaceVersion)
	{
		super("getDivisionList");
		this.interfaceVersion = interfaceVersion;
		this.accessCode = accessCode;
	}

	@Override
	protected List<Division> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		List<Division> divisions = UserContext.getRouter().getDivisionList(getAccessCode(), getLocalRoutingToken());
		return divisions;
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(List<Division> divisions) 
	throws TranslationException 
	{		
		XStream xstream = new XStream() {
            protected MapperWrapper wrapMapper(MapperWrapper next) {
                return new FieldUpperCaseMapper(next);
            }
    	};
    	
    	xstream.alias("Division", Division.class);
		xstream.alias("ArrayOfDivision", List.class);
    	return xstream.toXML(divisions);
	}

	@Override
	protected String getMethodParameterValuesString() {
		// TODO Auto-generated method stub
		return getAccessCode();
	}

	public String getAccessCode() {
		return accessCode;
	}
	
}
