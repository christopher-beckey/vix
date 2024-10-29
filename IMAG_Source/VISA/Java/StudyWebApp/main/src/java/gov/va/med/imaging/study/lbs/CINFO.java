// Copyright Laurel Bridge Software, Inc.  All rights reserved.  See distributed license file.
//
// WARNING: This file is generated from CINFO.java. Do not hand edit.
//
// This is the source file for the Component Info (CInfo) class generated
// for the ex_jqr_scp component.
//
package gov.va.med.imaging.study.lbs;

import com.lbs.DCF.DCFException;
import java.io.File;
import java.io.IOException;

import gov.va.med.logging.Logger;

/**
*	Component Info class for ex_jqr_scp.
*/
public class CINFO
	extends com.lbs.DCF.ComponentInfo
{
	private static CINFO	instance = null;
	private final static Logger logger = Logger.getLogger(CINFO.class);

	/**
	* static initializer
	* Constructs the singleton instance, and attempts to initialize it.
	* If AppControl comes up after this, it will ask for a reinitialization.
	*/
	static
	{
		try
		{
			instance = new CINFO();
		}
		catch ( DCFException e )
		{
			instance = null;
		}
	}

	/**
	* Method to ensure that the CINFO class is loaded and initialized.
	* You only need to call this if you are not calling another static
	* or instance method.
	*/
	public static void setup()
	{
	}

	/**
	*	Default constructor.
	*/
	private CINFO()
		throws DCFException
	{
		super( "DicomScp", "java_app", "DicomScp" );
	}


	/**
	* Return the singleton
	*/
	public static CINFO getInstance()
	{
		if (instance == null){
			try {
			instance = new CINFO();
			} catch (Exception ex) {
                logger.error("Cannot get CINFO instance. Exception:\n{}", ex);
			}
			//System.out.println("Returning null CINFO instance first");
		}
		return instance;
	}

	/**
	*	Test debug flags for ex_jqr_scp.
	*	Calling this method is equivalent to calling:
	*	 CINFO.instance().testComponentDebugFlags().
	*	
	*	@param mask the bit mask for flags.
	*	@return true if any flags in the bit mask are currently set.
	*/
	public static boolean testDebugFlags(int mask )
	{
		return instance.testComponentDebugFlags(mask);
	}

	/**
	*	Return the configuration group for this component. If AppControl
	*	has been initialized, returns the group "java_app/ex_jqr_scp"
	*	under the process configuration group. Otherwise, return default	
	*	settings from the group /components/java_app/ex_jqr_scp.
	*	If default settings are not available under the cfg/components group,
	*	getDefaultConfig is called.
	*	Calling this method is equivalent to calling:
	*	CINFO.instance().getComponentConfig().
	*	@return the CFGGroup for this component
	*	@throws CDSException if the group can not be found.
	*/
	public static com.lbs.CDS.CFGGroup getConfig()
		throws com.lbs.CDS.CDSException
	{
		return instance.getComponentConfig();
	}

	/**
	 *	Return the burned-in configuration data for this component. Note that this
	 *	may not be the same data returned by getConfig or getComponentConfig.
	 *	@return CFGGroup for this component created from compiled-in data.
	 */
	public com.lbs.CDS.CFGGroup getDefaultConfig()
		throws com.lbs.CDS.CDSException, com.lbs.CDS.NotFoundException
	{
		//System.out.println("in CINFO.getDefaultConfig()___LOG="+com.lbs.DCF.Framework.DCF_LOG());
		String cfg_data = cfg_data_.replace( "$DCF_VAR{DICOMPORT}", "2000" );
		cfg_data = cfg_data.replace( "$DCF_FUNC{fix_path,$DCF_VAR{DCF_LOG}}", com.lbs.DCF.Framework.DCF_LOG().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_FUNC{fix_path,$DCF_VAR{DCF_TMP}}", com.lbs.DCF.Framework.DCF_TMP().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_VAR{DCF_ROOT}", com.lbs.DCF.Framework.DCF_ROOT().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_VAR{DCF_CFG}", com.lbs.DCF.Framework.DCF_CFG().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_VAR{DCF_LIB}", com.lbs.DCF.Framework.DCF_LIB().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_VAR{DCF_LOG}", com.lbs.DCF.Framework.DCF_LOG().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_VAR{DCF_TMP}", com.lbs.DCF.Framework.DCF_TMP().replace( "\\", "/" ) );
		cfg_data = cfg_data.replace( "$DCF_VAR{DCF_USER_ROOT}", com.lbs.DCF.Framework.DCF_USER_ROOT().replace( "\\", "/" ) );

		com.lbs.CDS.CFGGroup g = com.lbs.CDS_a.CFGDB_a.loadGroupFromString( cfg_data );
		com.lbs.CDS.CFGGroup gg = g.getGroup("lb_scp");
		//System.out.println("in CINFO.getDefaultConfig()___final lb_scp group="+gg);
		return gg;
	}

    public static void refresh() {
		try {
			if(logger.isDebugEnabled()){
                logger.debug("In CINFO.refresh... CINFO.componentName={}", instance.componentName());
                logger.debug("In CINFO.refresh... testDebugFlags(df_SHOW_GENERAL_FLOW) b4={}", instance.testComponentDebugFlags(df_SHOW_GENERAL_FLOW));
                logger.debug("In CINFO.refresh... getComponentConfig() :{}", instance.getComponentConfig());
			}

		instance.getComponentConfig().removeGroup("lb_scp");
		instance = null;
		instance = new CINFO();
		//instance.reinit();
			if(logger.isDebugEnabled()){
                logger.debug("In CINFO.refresh... testDebugFlags(df_SHOW_GENERAL_FLOW) af={}", instance.testComponentDebugFlags(df_SHOW_GENERAL_FLOW));
                logger.debug("In CINFO.refresh... getComponentConfig() :{}", instance.getComponentConfig());
			}
		logger.info("CINFO refreshed.");
		} catch (Exception e) {
            logger.error("Cannot refresh CINFO! Exception:\n{}", e);
		}
	}
	
	//
	// Component debug flags for ex_jqr_scp.
	//
public static final int df_SHOW_CONSTRUCTORS=0x0001;
public static final int df_SHOW_DESTRUCTORS=0x0002;
public static final int df_SHOW_GENERAL_FLOW=0x0004;
public static final int df_SIMULATE_HARDWARE=0x0008;
public static final int df_SHOW_CFG_INFO=0x0010;
public static final int df_SHOW_EXC_THROW=0x0020;
public static final int df_SHOW_WARNINGS=0x0040;


	private static final String cfg_data_ = "\n"
+"#==============================================================================\n"
+"# per-instance information for the ex_jqr_scp component\n"
+"#==============================================================================\n"
+"[ ex_jqr_scp ]\n"
+"debug_flags = 0x00000\n"
+"\n"
+"#\n"
+"# if true, demostrate the DataSetByteReader class for making\n"
+"# a a decoded, and re-encoded network C-Store-Request look like\n"
+"# a ReadableByteChannel or InputStream object.\n"
+"#\n"
+"use_byte_reader = YES\n"
+"";


}
