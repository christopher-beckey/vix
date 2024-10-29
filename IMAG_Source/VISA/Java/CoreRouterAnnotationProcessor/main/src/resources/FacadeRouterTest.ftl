/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Oct 1, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
 package ${package};
 
 import java.util.Date;
 import org.apache.logging.log4j.LogManager;
 import org.apache.logging.log4j.Logger;
 import gov.va.med.imaging.*;
 import gov.va.med.imaging.core.interfaces.exceptions.*;
 import gov.va.med.imaging.core.interfaces.router.Command;
 import gov.va.med.imaging.core.interfaces.router.CommandFactory;
 import gov.va.med.imaging.core.CommandFactoryImpl;
 import gov.va.med.imaging.core.interfaces.router.AsynchronousCommandResultListener;
 import gov.va.med.exceptions.ValidationException;
 import javax.annotation.Generated;
 import gov.va.med.imaging.core.interfaces.router.CommandContext;

 <#list imports as import>
 import ${import}.*;
 </#list>
 
 /*
 * This is generated code and is recreated on every build.
 * Do not make changes directly in this code, as they will be lost (without warning).
 * Changes may be made to the template that generated this code (FacadeRouterImpl.ftl in
 * the CoreRouterAnnotationProcessor project), such changes will be reflected in
 * all facade router implementations.
 * 
 * This code was generated using FreeMarker, an open-source template processing engine.
 * See http://www.freemarker.org for documentation on the template syntax.
 */
 @Generated(value="gov.va.med.imaging.core.codegenerator.FacadeRouterCodeGenerator")
 public class ${testerName}
 //extends <#if extendsClassName??> ${extendsClassName} <#else>gov.va.med.imaging.core.interfaces.router.AbstractFacadeRouterImpl </#if>
 {
	
 	private Logger logger = LogManager.getLogger(this.getClass());
 	
 	private Logger getLogger()
 	{
 		return logger;
 	}
 	
 	private CommandFactory commandFactory = new CommandFactoryImpl((CommandContext)null);
 	private CommandFactory getCommandFactory()
 	{
 		return commandFactory;
 	}
 
 	/**
 	* The constructor is public so this tester can be created to test
 	*/
 	public ${testerName}()
 	{
 		super();
 	}
 
 	<#list methods as method>
 		${method}
 	</#list>
 }