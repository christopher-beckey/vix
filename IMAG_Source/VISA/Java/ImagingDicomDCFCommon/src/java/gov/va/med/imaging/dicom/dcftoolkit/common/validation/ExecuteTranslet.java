/* Copyright (c) 2001-2005, David A. Clunie DBA Pixelmed Publishing. All rights reserved. */

package gov.va.med.imaging.dicom.dcftoolkit.common.validation;

import gov.va.med.imaging.utils.FileUtilities;

import java.io.File;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * <p>Use a translet from an XSL-T source file to transform one XML file to another.</p>
 *
 * @author	dclunie
 */
public class ExecuteTranslet {
	/***/

	/**
	 * <p>Apply the XSL-T translet.</p>
	 *
	 * @param	arg	the name of the class file containing the XSL-T translet, the name of the imput XML file and the name of the output file
	 */
	public static void main(String arg[]) {
		try {
			Source transformSource = new StreamSource(arg[0]);
			TransformerFactory tf = TransformerFactory.newInstance("com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl", null);
			Transformer transformer = tf.newTransformer(transformSource);
			tf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
			tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, false);
			tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, false);
			StreamSource inputSource = new StreamSource(arg[1]);
			StreamResult outputResult = new StreamResult(FileUtilities.getFile(arg[2]));
			transformer.transform(inputSource,outputResult);
			
		} catch (Exception e) {
			e.printStackTrace(System.err);
		}
	}
}

