package gov.va.med.imaging.utils;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import java.io.Writer;

/**
 * Utility class designed to centralize certain operations to minimize footprint for Fortify and other scans and
 * to find solutions to satisfy its criteria in a single place.
 */
public class JspUtilities {
    private JspUtilities() {
        // ---
    }

    public static void write(PageContext pageContext, String value) throws JspException {
        // Explicitly do not close writer; this is shared by other tags and handled by the JSP processor
        if (value != null) {
            try {
                Writer writer = pageContext.getOut();
                if (writer != null) {
                    writer.write(value);
                }
            } catch (Exception e) {
                throw new JspException("Error writing to pageContext output writer", e);
            }
        }
    }
}
