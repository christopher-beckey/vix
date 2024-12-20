/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 12, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.vistaimaging.codegenerator.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 
 * @author VHAISWWERFEJ
 *
 */
@Retention(RetentionPolicy.SOURCE)
@Target(ElementType.METHOD)
public @interface VistaImagingGeneratedDataSourceMethod
{
	
	/**
	 * The name of the public static method to call to create the query. This should either be a 
	 * fully qualified method (including package) if not available in the imports
	 * @return
	 */
	public String queryFactoryMethodName() ;
	
	/**
	 * Comma separated list of parameters to pass to create the query, if omitted then all of the input parameters are
	 * passed to the query factory method
	 * @return
	 */
	public String queryFactoryParameters() default "";
	
	/**
	 * The name of the public static method to call to translate the results from calling the query.  This 
	 * should either be a fully qualified method (including package) if not available in the imports
	 */
	public String translationResultMethodName() default "";
	
	/**
	 * Comma separated list of parameters to pass to translate the results from VistA. If omitted then only the String 
	 * result is passed to the translator
	 * @return
	 */
	public String translationResultMethodParameters() default "";
	
	/**
	 * Comma separated list of objects to output that describe the input parameters. This property is translated into Java code
	 * so a method may be called on one of these parameters. For example: imageId,routingToken.toRoutingTokenString() is valid
	 * 
	 * The parameters can also be separated by colons (:) to provide a description. For example: routingToken.toRoutingTokenString(),image identifier:imageId
	 * 
	 * @return
	 */
	public String inputParametersDescription() default "";
	

}
