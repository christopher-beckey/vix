/* Copyright (c) 2001-2005, David A. Clunie DBA Pixelmed Publishing. All rights reserved. */

package gov.va.med.imaging.dicom.dcftoolkit.common.validation;

// JAXP packages
import javax.xml.XMLConstants;
import javax.xml.transform.Templates;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;

import com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl;

/**
 * <p>make a translet from any XSL-T source file.</p>
 *
 * @author	dclunie
 */
public class CompileXSLTIntoTranslet {
	/***/

	/**
	 * <p>Read the XSLT-C file specified on the command line and make a translate with the same name but a .class extension.</p>
	 *
	 * @param	arg	the name of the file containing the XSLT-C source
	 */
	public static void main(String arg[]) {
		try {
			StreamSource xslt = new StreamSource(arg[0]);
			TransformerFactory factory = TransformerFactory.newInstance("com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl", null);
			factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
			factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
			factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, false);
			factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, false);
			factory.setAttribute("generate-translet", Boolean.TRUE);
			Templates templates = factory.newTemplates(xslt);
		} catch (Exception e) {
			e.printStackTrace(System.err);
		}
	}
}

