/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 19, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.exchange.configuration;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

public class DicomCategoryFilterConfiguration extends AbstractBaseFacadeConfiguration {
	private Map<String, Set<String>> categories = new HashMap<String, Set<String>>();

	private static final String[] CL_RADIOLOGY = { "AS", "RAD AS", "BD", "RAD BD", "BDUS", "RAD BDUS", "BI", "RAD BI",
			"BMD ", "RAD BMD ", "CD", "RAD CD", "CF", "RAD CF", "CP", "RAD CP", "CR", "RAD CR", "CS", "RAD CS", "CT",
			"RAD CT", "DD", "RAD DD", "DF", "RAD DF", "DG", "RAD DG", "DM", "RAD DM", "DR", "RAD DR", "DS ", "RAD DS ",
			"DX", "RAD DX", "EC", "RAD EC", "ES", "RAD ES", "FA", "RAD FA", "FID", "RAD FID", "FS", "RAD FS", "GM",
			"RAD GM", "IO", "RAD IO", "LP", "RAD LP", "LS", "RAD LS", "MA", "RAD MA", "MG", "RAD MG", "MR", "RAD MR",
			"MS", "RAD MS", "NM", "RAD NM", "PT", "RAD PT", "RF", "RAD RF", "RG", "RAD RG", "RTDOSE", "RAD RTDOSE",
			"RTIMAGE", "RAD RTIMAGE", "RTPLAN", "RAD RTPLAN", "RTRAD", "RAD RTRAD", "RTRECORD", "RAD RTRECORD",
			"RTSEGANN", "RAD RTSEGANN", "RTSTRUCT", "RAD RTSTRUCT", "ST", "RAD ST", "TG", "RAD TG", "US", "RAD US",
			"VF", "RAD VF", "XA", "RAD XA", "XC", "RAD XC" };
	private static final String[] CL_DENTAL = { "IO", "PX", "IO RAD", "PX RAD" };
	private static final String[] CL_EYECARE = { "AR", "EOG", "FA", "FS", "IOL", "IVOCT", "KER", "LEN", "OAM", "OCT",
			"OP", "OPM", "OPR", "OPT", "OPTBSV", "OPTENF", "OPV", "SRF", "VA", "RAD AR", "RAD EOG", "RAD FA", "RAD FS",
			"RAD IOL", "RAD IVOCT", "RAD KER", "RAD LEN", "RAD OAM", "RAD OCT", "RAD OP", "RAD OPM", "RAD OPR",
			"RAD OPT", "RAD OPTBSV", "RAD OPTENF", "RAD OPV", "RAD SRF", "RAD VA" };
	private static final String[] CL_CARDIOLOGY = { "EC", "ECG", "EEG", "EPS", "MA", "EC RAD", "ECG RAD", "EEG RAD",
			"EPS RAD", "MA RAD" };
	private static final String[] CL_DERMATOLOGY = {"DMS", "RAD DMS"};
	private static final String[] CL_OTHER = { "ANN", "ASMT", "AU", "DOC", "EMG", "HC", "HD", "IVUS", "KO", "M3D",
			"OSS", "OT", "PLAN", "POS", "PR", "RAD ANN", "RAD ASMT", "RAD AU", "RAD DOC", "RAD EMG", "RAD HC", "RAD HD",
			"RAD IVUS", "RAD KO", "RAD M3D", "RAD OSS", "RAD OT", "RAD PLAN", "RAD POS", "RAD PR", "RAD REG",
			"RAD RESP", "RAD RTINTENT", "RAD RWV", "RAD SEG", "RAD SM", "RAD SMR", "RAD SR", "RAD STAIN",
			"RAD TEXTUREMAP", "RAD XAPROTOCOL", "REG", "RESP", "RTINTENT", "RWV", "SEG", "SM", "SMR", "SR", "STAIN",
			"TEXTUREMAP", "XAPROTOCOL" };
	
	public DicomCategoryFilterConfiguration() {
		super();
	}

	public Map<String, Set<String>> getCategories() {
		return categories;
	}

	public void setCategories(Map<String, Set<String>> categories) {
		this.categories = categories;
	}

	private static List<String> upper(List<String> list) {
		list.replaceAll(e -> e.toUpperCase());
		return list;
	}

	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() {

		Set<String> cl_radiology = new HashSet<String>();
		cl_radiology.addAll(upper(Arrays.asList(CL_RADIOLOGY)));

		Set<String> cl_eyecare = new HashSet<String>();
		cl_eyecare.addAll(upper(Arrays.asList(CL_EYECARE)));

		Set<String> cl_dental = new HashSet<String>();
		cl_dental.addAll(upper(Arrays.asList(CL_DENTAL)));

		Set<String> cl_cardiology = new HashSet<String>();
		cl_cardiology.addAll(upper(Arrays.asList(CL_CARDIOLOGY)));

		Set<String> cl_dermatology = new HashSet<String>();
		cl_dermatology.addAll(upper(Arrays.asList(CL_DERMATOLOGY)));
		
		Set<String> cl_other = new HashSet<String>();
		cl_other.addAll(upper(Arrays.asList(CL_OTHER)));

		Set<String> cl_dicom = new HashSet<String>();
		cl_dicom.addAll(upper(Arrays.asList(CL_RADIOLOGY)));
		cl_dicom.addAll(upper(Arrays.asList(CL_EYECARE)));
		cl_dicom.addAll(upper(Arrays.asList(CL_DENTAL)));
		cl_dicom.addAll(upper(Arrays.asList(CL_CARDIOLOGY)));
		cl_dicom.addAll(upper(Arrays.asList(CL_DERMATOLOGY)));
		cl_dicom.addAll(upper(Arrays.asList(CL_OTHER)));

		categories.put("cl_dicom", cl_dicom); // ALL
		categories.put("cl_radiology", cl_radiology);
		categories.put("cl_eyecare", cl_eyecare);
		categories.put("cl_dental", cl_dental);
		categories.put("cl_cardiology", cl_cardiology);
		categories.put("cl_dermatology", cl_dermatology);
		categories.put("cl_other", cl_other);

		return this;
	}

	public static synchronized DicomCategoryFilterConfiguration getConfiguration() {
		try {
			return FacadeConfigurationFactory.getConfigurationFactory()
					.getConfiguration(DicomCategoryFilterConfiguration.class);
		} catch (CannotLoadConfigurationException clcX) {
			// no need to log, already logged
			return null;
		}
	}

	public static void main(String[] args) {
		DicomCategoryFilterConfiguration config = getConfiguration();
		config.storeConfiguration();
	}

}
