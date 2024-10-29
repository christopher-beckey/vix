package gov.va.med.imaging.utils;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * Utility class designed to centralize certain operations to minimize footprint for Fortify and other scans and
 * to find solutions to satisfy its criteria in a single place.
 */
public class NetUtilities {
    private NetUtilities() {
        // ---
    }

    public static String getUnsafeLocalHostName() /*throws UnknownHostException*/ {
        return getUnsafeLocalHostName("localhost");
    }

    public static String getUnsafeLocalHostName(String defaultValue) /*throws UnknownHostException*/ {
        // Unsafe method according to Fortify, but works
        // InetAddress inetAddress = InetAddress.getLocalHost();
        // return inetAddress.getHostName();

        // Another method (windows only)
        String windowsComputerName = System.getenv("COMPUTERNAME");
        if ((windowsComputerName != null) && (windowsComputerName.length() != 0)) {
            return windowsComputerName;
        }

        return defaultValue;
    }

    public static InetAddress getUnsafeLocalInetAddress() throws UnknownHostException {
        return InetAddress.getByName(getUnsafeLocalHostName("localhost"));
    }
}
