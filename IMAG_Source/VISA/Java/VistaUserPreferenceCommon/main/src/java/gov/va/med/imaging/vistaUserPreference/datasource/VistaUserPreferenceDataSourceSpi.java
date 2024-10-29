/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;

/**
 * @author Budy Tjahjo
 *
 */
@SPI(description="This SPI defines operations providing access to raw User Preference")
public interface VistaUserPreferenceDataSourceSpi
extends VersionableDataSourceSpi
{
	
	public abstract List<String> getUserPreference(
			RoutingToken globalRoutingToken, 
			String entity, 
			String key)
	throws MethodException, ConnectionException;

	public abstract String postUserPreference(
			RoutingToken globalRoutingToken, 
			String entity,
			String key,
			String value)
	throws MethodException, ConnectionException;
	
	public abstract String deleteUserPreference(
			RoutingToken globalRoutingToken, 
			String entity,
			String key)
	throws MethodException, ConnectionException;
	
	public abstract List<String> getUserPreferenceKeys(
			RoutingToken globalRoutingToken, 
			String userID)
	throws MethodException, ConnectionException;

}
