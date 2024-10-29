/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.web.rest.exceptions;

import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import gov.va.med.logging.Logger;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractRestService
{

	protected Response wrapResultWithResponseHeaders(Object result)
	{		
		return Response.status(Status.OK).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
				TransactionContextFactory.get().getMachineName()).entity(result).build();
	}

}
