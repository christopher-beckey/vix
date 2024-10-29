package gov.va.med.imaging.utils;

import gov.va.med.logging.Logger;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Utility class designed to centralize certain operations to minimize footprint for Fortify and other scans and
 * to find solutions to satisfy its criteria in a single place.
 */
public class AccessUtilities {
    private static final Logger LOGGER = Logger.getLogger(AccessUtilities.class);

    // Lazy switch if this blows everything up
    private static final boolean SET_ACCESSIBLE = false;

    private AccessUtilities() {
        // ---
    }

    public static void setAccessible(Field field, boolean accessible) {
        LOGGER.debug("[AccessUtilities] - Field \"{}\".\"{}\" attempting accessibility change", field.getDeclaringClass().getName(), field.getName(), new Exception("Call stack"));
        if (SET_ACCESSIBLE) {
            //field.setAccessible(accessible);
        }
    }

    public static void setAccessible(Field field) {
        LOGGER.debug("[AccessUtilities] - Field \"{}\".\"{}\" attempting accessibility change", field.getDeclaringClass().getName(), field.getName(), new Exception("Call stack"));
        if (SET_ACCESSIBLE) {
            //field.setAccessible(true);
        }
    }

    public static void setAccessible(Method method) {
        LOGGER.debug("[AccessUtilities] - Method \"{}\".\"{}\" attempting accessibility change", method.getDeclaringClass().getName(), method.getName(), new Exception("Call stack"));
        if (SET_ACCESSIBLE) {
            //method.setAccessible(true);
        }
    }
}
