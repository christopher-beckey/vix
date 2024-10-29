package gov.va.med.imaging.consult.federation.translator;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.URNFactory;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.consult.federation.types.FederationConsultArrayType;
import gov.va.med.imaging.consult.federation.types.FederationConsultType;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.AbstractTranslator;
import gov.va.med.imaging.rest.types.RestStringType;

public class ConsultFederationRestTranslator 
extends AbstractTranslator {
	
	public static RestStringType translateUrn(ConsultURN value) {	
		return (value == null ? null : new RestStringType(value.toString()));
	}
	
	private static FederationConsultType translate(Consult value){
		
		FederationConsultType type = new FederationConsultType();
		
		// Fortify coding and to avoid NPE
		if(value != null) {
			type.setConsultUrn(translateUrn(value.getConsultUrn()));
			type.setDate(value.getDate());
			type.setProcedure(value.getProcedure());
			type.setNumberNotes(value.getNumberNotes());
			type.setService(value.getService());
			type.setStatus(value.getStatus());
		}
		return type;
	}
	

	private static Consult translate(FederationConsultType value) throws URNFormatException{
		
		// Fortify coding and to avoid NPE
		String urnValue = null;
		String date = null;
		String service = null;
		String procedure = null;
		String status = null;
		int numberOfNotes = 0;
		
		if(value != null) {
			urnValue = value.getConsultUrn().getValue();
			date = value.getDate();
			service = value.getService();
			procedure = value.getProcedure();
			status = value.getStatus();
			numberOfNotes = value.getNumberNotes();			
		}

		return (new Consult(URNFactory.create(urnValue, ConsultURN.class), date, service, procedure, status, numberOfNotes));
	}

	public static FederationConsultArrayType translateConsults(List<Consult> consults) 
	{
		if(consults == null)
			return new FederationConsultArrayType();
		
		FederationConsultType[] result = new FederationConsultType[consults.size()];
		int i = 0;
		for(Consult aConsult : consults)
		{
			result[i] = translate(aConsult);
			i++;
		}
		
		return new FederationConsultArrayType(result);
	}

	public static List<Consult> translateFederationConsultTypes(FederationConsultArrayType values) 
	{
		List<Consult> results = new ArrayList<Consult>();
		if(values == null || values.getValues() == null || values.getValues().length < 1)
			return results;
		
		FederationConsultType[] items = values.getValues();
				
		for(FederationConsultType item : items)
		{
			try {
				results.add(translate(item));
			} catch (URNFormatException urnX) {
				// Too lazy to crate a new one for just one log statement
                getLogger().error("ConsultFederationRestTranslator.translateFederationConsultTypes() --> Failed to translate and add Consult [{}] to list: {}", item.getConsultUrn(), urnX.getMessage());
			}
		}
		return results;
	}
}
