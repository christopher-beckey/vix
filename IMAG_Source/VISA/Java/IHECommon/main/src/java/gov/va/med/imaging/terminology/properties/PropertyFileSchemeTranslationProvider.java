/**
 * 
 */
package gov.va.med.imaging.terminology.properties;

import gov.va.med.imaging.terminology.CodingScheme;
import gov.va.med.imaging.terminology.SchemeTranslationProvider;
import java.util.ArrayList;
import java.util.List;
import gov.va.med.logging.Logger;

/**
 * This is a simple, property file based, scheme translation
 * implementation.  This provider includes service implementations
 * for SNOMED to VA, LOINC to VA, VA to LOINC and VA to SNOMED.
 * The translation tables themselves are named according to the 
 * following format:
 * <SourceScheme>To<DestinationScheme>.xml
 * The properties files are XML format using the schema defined at:
 * http://java.sun.com/dtd/properties.dtd
 * The properties files must be accessible as resources at runtime.
 * 
 * @see java.util.Properties
 * 
 * @author vhaiswbeckec
 *
 */
public class PropertyFileSchemeTranslationProvider
extends SchemeTranslationProvider
{
	private Logger logger = Logger.getLogger(PropertyFileSchemeTranslationProvider.class);
	
	private List<SchemeTranslationServiceMapping> serviceMapping = 
		new ArrayList<SchemeTranslationServiceMapping>();
	
	/**
	 * 
	 */
	public PropertyFileSchemeTranslationProvider()
	{
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.LOINC, 
			CodingScheme.VADOCUMENTCLASS, 
			LOINCtoVADOCUMENTCLASStranslationservice.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.VADOCUMENTCLASS, 
			CodingScheme.LOINC, 
			VADOCUMENTCLASStoLOINCtranslationservice.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.VADOCUMENTCLASS, 
			CodingScheme.MHS, 
			VADOCUMENTCLASStoMHStranslationservice.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.MHS, 
			CodingScheme.VADOCUMENTCLASS, 
			MHStoVADOCUMENTCLASStranslationservice.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.SNOMED, 
			CodingScheme.VASPECIALTY, 
			SnomedToVaSpecialtyTranslationService.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.VASPECIALTY, 
			CodingScheme.SNOMED, 
			VaSpecialtyToSnomedTranslationService.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.SNOMED, 
			CodingScheme.VAPROCEDURE, 
			SnomedToVaProcedureTranslationService.class));
		serviceMapping.add(new SchemeTranslationServiceMapping(
			"VIProperties", 
			CodingScheme.VAPROCEDURE, 
			CodingScheme.SNOMED, 
			VaProcedureToSnomedTranslationService.class));
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.terminology.SchemeTranslationProvider#getSchemeTranslationServiceMappings()
	 */
	@Override
	public List<SchemeTranslationServiceMapping> getSchemeTranslationServiceMappings()
	{
		return serviceMapping;
	}
}
