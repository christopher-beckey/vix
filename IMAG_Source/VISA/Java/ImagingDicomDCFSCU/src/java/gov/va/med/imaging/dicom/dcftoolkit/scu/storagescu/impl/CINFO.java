//=========================================================================
// Copyright (C) 2000-2007, Laurel Bridge Software, Inc.
// 160 East Main St.
// Newark, Delaware 19711 USA
// All Rights Reserved
//=========================================================================
//
// WARNING: This file is generated from CINFO.java. Do not hand edit.
//
// This is the source file for the Component Info (CInfo) class generated
// for the DicomStoreSCUImpl component.
//
package gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.impl;

import com.lbs.DCF.DCFException;

/**
*	Component Info class for DicomStoreSCUImpl.
*/
public class CINFO
	extends com.lbs.DCF.ComponentInfo
{
	private static CINFO	instance_ = null;

	/**
	* static initializer
	* Constructs the singleton instance, and attempts to initialize it.
	* If AppControl comes up after this, it will ask for a reinitialization.
	*/
	static
	{
		try {
		instance_ = new CINFO();
		}
		catch (DCFException de) {
			de.printStackTrace();
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
	private CINFO() throws DCFException
	{
		super( "DicomStoreSCUImpl", "java_app", "/apps/defaults/DicomStoreSCUImpl" );
	}


	/**
	* Return the singleton
	*/
	public static CINFO instance()
	{
		return instance_;
	}

	/**
	*	Test debug flags for DicomStoreSCUImpl.
	*	Calling this method is equivalent to calling:
	*	 CINFO.instance().testComponentDebugFlags().
	*	
	*	@param mask the bit mask for flags.
	*	@return true if any flags in the bit mask are currently set.
	*/
	public static boolean testDebugFlags(int mask )
	{
		return instance_.testComponentDebugFlags(mask);
	}

	/**
	*	Return the configuration group for this component. If AppControl
	*	has been initialized, returns the group "java_app/DicomStoreSCUImpl"
	*	under the process configuration group. Otherwise, return default	
	*	settings from the group /components/java_app/DicomStoreSCUImpl.
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
		return instance_.getComponentConfig();
	}

	/**
	 *	Return the burned-in configuration data for this component. Note that this
	 *	may not be the same data returned by getConfig or getComponentConfig.
	 *	@return CFGGroup for this component created from compiled-in data.
	 */
	public com.lbs.CDS.CFGGroup getDefaultConfig()
		throws com.lbs.CDS.CDSException, com.lbs.CDS.NotFoundException
	{
		com.lbs.CDS.CFGGroup g = com.lbs.CDS_a.CFGDB_a.loadGroupFromString( cfg_data_ );
		com.lbs.CDS.CFGGroup gg = g.getGroup("DicomStoreSCUImpl");
		return gg;
	}

	//
	// Component debug flags for DicomStoreSCUImpl.
	//
public static final int df_SHOW_CONSTRUCTORS=0x0001;
public static final int df_SHOW_DESTRUCTORS=0x0002;
public static final int df_SHOW_GENERAL_FLOW=0x0004;
public static final int df_SIMULATE_HARDWARE=0x0008;
public static final int df_SHOW_CFG_INFO=0x0010;
public static final int df_SHOW_EXC_THROW=0x0020;
public static final int df_EXAMPLE=0x10000;
public static final int df_SHOW_NOTIFICATIONS=0x20000;


	private static final String cfg_data_ = "\n"
+"#==============================================================================\n"
+"# per-instance information for the ex_jstore_scu component\n"
+"#==============================================================================\n"
+"[ DicomStoreSCUImpl ]\n"
+"debug_flags = 0x00000\n"
+"";


}
