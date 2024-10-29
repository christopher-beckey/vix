/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.consult;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.protocol.vista.VistaCommonTranslator;
import gov.va.med.imaging.url.vista.StringUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author Julian Werfel
 *
 */
public class VistaImagingConsultTranslator
{
	
	/*
	 * 
	 	1
		10^3140210.1349^EKG^^PENDING^0
	 */
	public static List<Consult> translateConsults(String vistaResult, PatientIdentifier patientIdentifier, Site site)
	throws MethodException
	{
		String [] lines = StringUtils.Split(vistaResult,  StringUtils.NEW_LINE);
		List<Consult> result = new ArrayList<Consult>();
		for(int i = 1; i < lines.length; i++)
		{
			String [] pieces = StringUtils.Split(lines[i].trim(), StringUtils.CARET);
			String ien = pieces[0];
			String mDate = pieces[1];
			String service = pieces[2];
			String procedure = pieces[3];
			String status = pieces[4];
			int numNotes = Integer.parseInt(pieces[5]);
			//Date date = VistaCommonTranslator.convertMDateToDate(mDate);
			try
			{
				ConsultURN consultUrn = ConsultURN.create(site.getRepositoryId(), ien, patientIdentifier);
				result.add(new Consult(consultUrn, mDate, service, procedure, status, numNotes));
				
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
			
		}
		return result;
	}
}
