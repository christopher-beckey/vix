package gov.va.med.imaging.utils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import gov.va.med.imaging.StringUtil;

/**
 * Utility class designed to centralize certain operations to minimize footprint for Fortify and other scans and
 * to find solutions to satisfy its criteria in a single place.
 */
public class FileUtilities {
    private FileUtilities() {
        // ---
    }

    public static Path getPath(String path) throws IOException {
        return Paths.get(StringUtil.cleanString(path));
    }

    public static File getFile(String parent, String path) throws IOException {
        return new File(StringUtil.cleanString(parent), StringUtil.cleanString(path));
    }

    public static File getFile(File parent, String path) throws IOException {
        return new File(parent, StringUtil.cleanString(path));
    }

    public static File getFile(String path) throws IOException {
        return new File(StringUtil.cleanString(path));
    }
}
