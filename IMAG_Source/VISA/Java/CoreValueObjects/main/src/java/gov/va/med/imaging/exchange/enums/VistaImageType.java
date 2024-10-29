/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 10, 2008
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
package gov.va.med.imaging.exchange.enums;

/**
 * This is a VistA specific enumeration that describes the Image Type field stored in VistA.
 * This is similar but NOT the same as ImageFormat which describes the format of an image.
 * This does not define a MIME type. This simply makes it easier to understand what the 
 * numeric image type value corresponds to as defined by VistA.
 * 
 *  The following definitions come from VistA and should not be modified unless they are changed
 *  in VistA
 * 
 * @author VHAISWWERFEJ
 *
 */
public enum VistaImageType 
{
	JPEG(1, "JPEG Image", ImageFormat.JPEG.getMime(), "JPG", true),
	BWMED(9, "Black and White med images", ImageFormat.TGA.getMime(), "TGA", true),
	ECG(13, "DICOM ECG Image", ImageFormat.DICOM.getMime(), "DCM", true),
	COLOR_SCAN(17, "Color Scan", ImageFormat.JPEG.getMime(), "JPG", true),
	PATIENT_PHOTO(18, "Patient Photo Id", ImageFormat.JPEG.getMime(), "JPG", true),
	XRAY_JPEG(19, "JPEG XRay image", ImageFormat.JPEG.getMime(), "JPG", true),
	TIFF(15, "TIFF image", ImageFormat.TIFF.getMime(), "TIF", true),
	MOTION_VIDEO(21, "Motion Video (AVI, MPG)", ImageFormat.AVI.getMime(), "AVI", false),
	HTML(101, "HTML Document", ImageFormat.HTML.getMime(), "HTM", false),
	WORD_DOCUMENT(102, "Word Document", ImageFormat.DOC.getMime(), "DOC", false),
	ASCII_TEXT(103, "ASCII Text", ImageFormat.TEXT_PLAIN.getMime(), "TXT", false),
	PDF(104, "PDF Document", ImageFormat.PDF.getMime(), "PDF", false),
	RTF(105, "RTF Document", ImageFormat.RTF.getMime(), "RTF", false),
	AUDIO(106, "Audio File (WAV, MP3)", ImageFormat.WAV.getMime(), "WAV", false),
	XRAY(3, "TGA Image", ImageFormat.TGA.getMime(), "TGA", true), //TGA
	DICOM(100, "DICOM Image", ImageFormat.DICOM.getMime(), "DCM", true),
	XML(107, "XML File", ImageFormat.XML.getMime(), "XML", false),
	NCAT(501, "DoD NCAT Reports", ImageFormat.PDF.getMime(), "PDF", false),
	UNKNOWN_IMAGING_TYPE(502, "Type not known to VistA Imaging", ImageFormat.ANYTHING.getMime(), "", false),
	DOD_JPG(503, "JPG from the DoD", ImageFormat.JPEG.getMime(), "JPG", false),
	DOD_WORD_DOCUMENT(504, "Word Document from the DoD", ImageFormat.DOC.getMime(), "DOC", false),
	DOD_ASCII_TEXT(505, "ASCII Test from the DoD", ImageFormat.TEXT_PLAIN.getMime(), "TXT", false),
	DOD_PDF(506, "PDF Document from the DoD", ImageFormat.PDF.getMime(), "PDF", false),
	DOD_RTF(507, "RTF Document from the DoD", ImageFormat.RTF.getMime(), "RTF", false),
	BMP(1, "BMP Image", ImageFormat.BMP.getMime(), "BMP", true),
	PNG(1, "PNG Image", ImageFormat.PNG.getMime(), "PNG", true),
	MP4(21, "MPEG4 Video", ImageFormat.MP4.getMime(), "MP4", false);

	//DOD_DOCX_DOCUMENT(508, "Word Document in DOCX format", ImageFormat.DOCX.getMime());

	
	private final int imageType;
	private final String description;
	private final String defaultMimeType;
	private final String defaultFileExtension;
	
	private final boolean generateThumbnail;
	
	VistaImageType(int imageType, String description, String defaultMimeType, String defaultFileExtension, boolean generateThumbnail)
	{
		this.imageType = imageType;
		this.description = description;
		this.defaultMimeType = defaultMimeType;
		this.defaultFileExtension = defaultFileExtension;
		this.generateThumbnail = generateThumbnail;
	}

	/**
	 * Convert a numeric image type into the VistaImageType that represents that value.
	 * @param imageType
	 * @return
	 */
	public static VistaImageType valueOfImageType(int imageType)
	{
		for(VistaImageType vistaImageType : VistaImageType.values())
		{
			if(vistaImageType.imageType == imageType)
			{
				return vistaImageType;
			}
		}
		return null;
	}

	/**
	 * @return the imageType
	 */
	public int getImageType() {
		return imageType;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return the defaultMimeType
	 */
	public String getDefaultMimeType() {
		return defaultMimeType;
	}

	public String getDefaultFileExtension()
	{
		return defaultFileExtension;
	}	
		
	private static VistaImageType [] radiologyImageTypes = new VistaImageType[] {
		VistaImageType.XRAY, 
		VistaImageType.DICOM
	};

	public static boolean isRadiologyImageType(VistaImageType vistaImageType)
	{
		for(VistaImageType radiologyImageType : radiologyImageTypes)
		{
			if(vistaImageType == radiologyImageType)
				return true;
		}
		return false;
	}
	
	public static boolean isRadiologyImageType(int imageType)
	{
		for(VistaImageType radiologyImageType : radiologyImageTypes)
		{
			if(imageType == radiologyImageType.getImageType())
				return true;
		}
		return false;
	}
	
	/**
	 * @return the generateThumbnail
	 */
	public boolean isGenerateThumbnail()
	{
		return generateThumbnail;
	}

	public static VistaImageType getFromImageFormat(ImageFormat imageFormat)
	{
		switch(imageFormat)
		{
			case DICOM:
			case DICOMJPEG:
			case DICOMJPEG2000:
			case DICOMPDF:
				return VistaImageType.DICOM;
			case AVI:
			case MPG:
				return VistaImageType.MOTION_VIDEO;
			case BMP:
				return VistaImageType.BMP;
			case JPEG:
				return VistaImageType.JPEG;
			case DOC:
				return VistaImageType.WORD_DOCUMENT;
			case DOCX:
				return VistaImageType.DOD_WORD_DOCUMENT;
			case RTF:
				return VistaImageType.RTF;
			case HTML:
				return VistaImageType.HTML;
			case MP3:
				return VistaImageType.AUDIO;
			case TEXT_PLAIN:
				return VistaImageType.ASCII_TEXT;
			case PDF:
				return VistaImageType.PDF;
			case TGA:
				return VistaImageType.XRAY;
			case TIFF:
				return VistaImageType.TIFF;
			case PNG:
				return VistaImageType.PNG;
			case MP4:
				return VistaImageType.MP4;
			
		
		}
		
		return null;
	}
}
