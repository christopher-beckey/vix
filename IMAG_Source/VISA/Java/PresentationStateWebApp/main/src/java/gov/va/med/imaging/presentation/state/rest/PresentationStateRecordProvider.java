package gov.va.med.imaging.presentation.state.rest;

import javax.ws.rs.Consumes;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.ext.ContextResolver;
import javax.ws.rs.ext.Provider;
import javax.xml.bind.JAXBContext;

import gov.va.med.logging.Logger;

import com.sun.jersey.api.json.JSONConfiguration;
import com.sun.jersey.api.json.JSONJAXBContext;

import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordType;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordsType;

@Provider
@Consumes(MediaType.APPLICATION_JSON)
public class PresentationStateRecordProvider implements ContextResolver<JAXBContext> {
    private JAXBContext context;
    private Class<?>[] types = {PresentationStateRecordType.class,
    							PresentationStateRecordsType.class};
    
	private final Logger logger = Logger.getLogger(PresentationStateRecordProvider.class);


    public PresentationStateRecordProvider() throws Exception {
    	logger.debug("Constructor called.");
        this.context = new JSONJAXBContext(JSONConfiguration.natural()
        		.rootUnwrapping(true)
        		.build(),
                types);
    }
    
    public JAXBContext getContext(Class<?> objectType) {
        logger.debug("{} getContext method called.", this.getClass().getName());
        for (Class<?> type : types) {
            logger.debug("Class Type: {}", type);
            if (type.equals(objectType)) {
                return context;
            }
        }
        logger.debug("Did not find a JAXB Context.");
        return null;
    }
}