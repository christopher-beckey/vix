/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;

/**
 * @author Administrator
 *
 */
@SPI(description="Defines the interface for retrieving imaging index terms.")
public interface IndexTermDataSourceSpi
extends VersionableDataSourceSpi
{

	public abstract List<IndexTermValue> getOrigins(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException;
	
	public abstract List<IndexTermValue> getSpecialties(RoutingToken globalRoutingToken, 
			List<IndexClass> indexClasses, List<IndexTermURN> eventUrns)
	throws MethodException, ConnectionException;
	
	public abstract List<IndexTermValue> getProcedureEvents(RoutingToken globalRoutingToken, 
			List<IndexClass> indexClasses, List<IndexTermURN> specialtyUrns)
	throws MethodException, ConnectionException;
	
	public abstract List<IndexTermValue> getTypes(RoutingToken globalRoutingToken,
		List<IndexClass> indexClasses)
	throws MethodException, ConnectionException;
	
	/**
	 * Returns a set of index terms (specified in the list)
	 * @param globalRoutingToken
	 * @param terms
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	//public abstract List<IndexTermValue> getIndexTermValues(RoutingToken globalRoutingToken, List<IndexTerm> terms)
	//throws MethodException, ConnectionException;
}
