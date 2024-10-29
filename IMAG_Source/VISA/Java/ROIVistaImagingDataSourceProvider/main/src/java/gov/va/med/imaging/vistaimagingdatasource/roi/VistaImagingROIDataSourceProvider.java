/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 17, 2012
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
package gov.va.med.imaging.vistaimagingdatasource.roi;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.roi.datasource.ExportQueueDataSourceSpi;
import gov.va.med.imaging.roi.datasource.CommunityCareROIDataSourceSpi;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VistaImagingROIDataSourceProvider
extends Provider
{
	private static final String PROVIDER_NAME = "VistaImagingROIDataSource";
	private static final double PROVIDER_VERSION = 1.0d;
	private static final String PROVIDER_INFO = 
		"Implements: \n" + 
		"StudyGraphDataSource, ImageDataSource, and ImageAccessLoggingDataSource SPI \n" + 
		"backed by a VistA data store.";

	private static final long serialVersionUID = 1L;
	
	private final SortedSet<ProviderService> services;

	/**
	 * The public "nullary" constructor that is used by the ServiceLoader class
	 * to create instances.
	 */
	public VistaImagingROIDataSourceProvider()
	{
		this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
	}

	/**
	 * @param name
	 * @param version
	 * @param info
	 */
	private VistaImagingROIDataSourceProvider(String name, double version, String info)
	{
		super(name, version, info);

		services = new TreeSet<ProviderService>();
		
		services.add(
				new ProviderService(
					this,
					ExportQueueDataSourceSpi.class,
					VistaImagingROIExportQueueDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					VistaImagingROIExportQueueDataSourceService.class)
				);

		services.add(
				new ProviderService(
					this,
					CommunityCareROIDataSourceSpi.class,
					CommunityCareROIDataSourceService.SUPPORTED_PROTOCOL,
					1.0F,
					CommunityCareROIDataSourceService.class)
				);

	}
	

	@Override
	public SortedSet<ProviderService> getServices()
	{
		return Collections.unmodifiableSortedSet(services);
	}

}