using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;
using ClearCanvas.Dicom.Iod;
using ClearCanvas.Dicom.Utilities;

namespace Hydra.Dicom
{
    // condition constants
    public enum E_Condition
    {
        // successful completion
        EC_Normal,
        // error, function called with illegal parameters
        EC_IllegalParameter,
        // failure, memory exhausted
        EC_MemoryExhausted,
        /// invalid tag
        EC_InvalidTag,
        /// tag not found
        EC_TagNotFound,
        /// invalid VR
        EC_InvalidVR,
        /// invalid stream
        EC_InvalidStream,
        /// end of stream
        EC_EndOfStream,
        /// corrupted data
        EC_CorruptedData,
        /// illegal call, perhaps wrong parameters
        EC_IllegalCall,
        /// sequence end
        EC_SequEnd,
        /// doubled tag
        EC_DoubledTag,
        /// I/O suspension or premature end of stream
        EC_StreamNotifyClient,
        /// stream mode (R/W, random/sequence) is wrong
        EC_WrongStreamMode,
        /// item end
        EC_ItemEnd,
        /// compressed/uncompressed pixel representation not found
        EC_RepresentationNotFound,
        /// Pixel representation cannot be changed to requested transfer syntax
        EC_CannotChangeRepresentation,
        /// Unsupported compression or encryption
        EC_UnsupportedEncoding,
        /// Parser failure: Putback operation failed
        EC_PutbackFailed,
        /// Too many compression filters
        EC_DoubleCompressionFilters,
        /// Storage media application profile violated
        EC_ApplicationProfileViolated,
        /// Invalid offset
        EC_InvalidOffset,
        /// Too many bytes requested
        EC_TooManyBytesRequested,
        // Invalid basic offset table
        EC_InvalidBasicOffsetTable,
        /// Element length is larger than (explicit) length of surrounding item
        EC_ElemLengthLargerThanItem,
        /// File meta information header missing
        EC_FileMetaInfoHeaderMissing,
        /// Item or sequence content larger than explicit 32-bit length field permits
        EC_SeqOrItemContentOverflow,
        /// Value Representation (VR) violated
        EC_ValueRepresentationViolated,
        /// Value Multiplicity (VM) violated
        EC_ValueMultiplicityViolated,
        /// Maximum VR length violated
        EC_MaximumLengthViolated,
        /// Element length is larger than 16-bit length field permits
        EC_ElemLengthExceeds16BitField,

        // name specific error conditions for module dcmsr.

        /// error: the document type (SOP class UID) is unknown or not supported
        SR_EC_UnknownDocumentType,

        /// error: the document status is invalid
        SR_EC_InvalidDocument,

        /// error: the document tree is invalid (corrupted structure)
        SR_EC_InvalidDocumentTree,

        /// error: a mandatory attribute is missing
        SR_EC_MandatoryAttributeMissing,

        /// error: a value is invalid according to the standard
        SR_EC_InvalidValue,

        /// error: a value is not supported by this implementation
        SR_EC_UnsupportedValue,

        /// error: an unknown value type is used
        SR_EC_UnknownValueType,

        /// error: an unknown relationship type is used
        SR_EC_UnknownRelationshipType,

        /// error: the by-value relationship between two content items is not allowed
        SR_EC_InvalidByValueRelationship,

        /// error: the by-reference relationship between two content items is not allowed
        SR_EC_InvalidByReferenceRelationship,

        /// error: the specified SOP instance could not be found
        SR_EC_SOPInstanceNotFound,

        /// error: a SOP instance has different SOP classes
        SR_EC_DifferentSOPClassesForAnInstance,

        /// error: the specified coding scheme designator could not be found
        SR_EC_CodingSchemeNotFound,

        /// error: the XML structure is corrupted (XML parser error)
        SR_EC_CorruptedXMLStructure
    }

    public static class OFCondition
    {
        /// pointer to the condition base object
        static OFConditionBase theCondition;

        static OFCondition()
        {
            //theCondition = basestring;
        }
        /// returns true if status is OK
        public static bool good(this E_Condition cond)
        {
            //OFStatus s = theCondition.status();
            //return (s == OFStatus.OF_ok);
            OFStatus s = (cond == E_Condition.EC_Normal ? OFStatus.OF_ok : OFStatus.OF_error);
            return (s == OFStatus.OF_ok);
        }

        /// returns true if status is not OK, i. e. error or failure
        public static bool bad(this E_Condition cond)
        {
            //OFStatus s = theCondition.status();
            //return (s != OFStatus.OF_ok);
            OFStatus s = (cond == E_Condition.EC_Normal ? OFStatus.OF_ok : OFStatus.OF_error);
            return (s != OFStatus.OF_ok);
        }
    }

    // this enumeration describes the return status of an operation.
    public enum OFStatus
    {
        /// no error, operation has completed successfully
        OF_ok,

        /// operation has not completed successfully
        OF_error,

        /// application failure
        OF_failure
    };

    public abstract class OFConditionBase
    {
        public OFConditionBase()
        {
        }

        public OFConditionBase(OFConditionBase anArg /* arg */)
        {
        }

        ~OFConditionBase()
        {
        }

        public abstract OFConditionBase clone();

        public abstract long codeAndModule();

        // returns the status for this object.
        public abstract OFStatus status();

        public abstract string text();

        /// returns the module identifier for this object.
        ushort module()
        {
            return Convert.ToUInt16((codeAndModule()>> 16) & 0xFFFF);

        }
        /// returns the status code identifier for this object.
        ushort code()
        {
            return Convert.ToUInt16(codeAndModule() & 0xFFFF);
        }
    }

    public class OFConditionConst : OFConditionBase
    {
        /// code/module identification. Code is lower 16 bits, module is upper 16 bits
        long theCodeAndModule;
        /// status
        OFStatus theStatus;

        /// condition description
        string theText;

        /// default constructor
        public OFConditionConst(ushort aModule, ushort aCode, OFStatus aStatus, string aText)
            :base()
        {
            theStatus = aStatus;
            theCodeAndModule = aCode;
            theText = aText;
        }

        /// copy constructor
        public OFConditionConst(ref OFConditionConst arg)
            :base(arg)
        {
            theStatus = arg.theStatus;
            theCodeAndModule = arg.theCodeAndModule;
            theText = arg.theText;
        }

        /// destructor
        ~OFConditionConst()
        {
        }

        /** this method returns a pointer to a OFConditionBase object containing a clone
        *  of this object. In this case, deletable() is false and clone just returns a pointer to this.
        *  @return alias of this object
        */
        public override OFConditionBase clone()
        {
            return this;
        }

        /** returns a combined code and module for this object.
        *  code is lower 16 bits, module is upper 16 bits
       */
        public override long codeAndModule()
        {
            return theCodeAndModule;
        }

        /// returns the status for this object.
       public override OFStatus status()
       {
           return theStatus;
       }

      /// returns the error message text for this object.
      public override string text()
      {
          return theText;
      }

      /** checks if this object is deletable, e.g. all instances
       *  of this class are allocated on the heap.
       *  @return always false for this class
       */
      public virtual bool deletable()
      {
          return false;
      }

        /*---------------------------------*
        *  constant definitions (part 2)  *
        *---------------------------------*/

        /*
         *  DCMTK module numbers for modules which create their own error codes.
         *  Module numbers > 1023 are reserved for user code.
         */

        ushort OFM_dcmdata  =  1;
        ushort OFM_ctndisp  =  2;   /* retired */
        ushort OFM_dcmimgle =  3;
        ushort OFM_dcmimage =  4;
        ushort OFM_dcmjpeg  =  5;
        ushort OFM_dcmnet   =  6;
        ushort OFM_dcmprint =  7;
        ushort OFM_dcmpstat =  8;
        ushort OFM_dcmsign  =  9;
        ushort OFM_dcmsr    = 10;
        ushort OFM_dcmtls   = 11;
        ushort OFM_imagectn = 12;
        ushort OFM_wlistctn = 13;   /* retired */
        ushort OFM_dcmwlm   = 14;
        ushort OFM_dcmpps   = 15;
        ushort OFM_dcmdbsup = 16;
        ushort OFM_dcmppswm = 17;
        ushort OFM_dcmjp2k  = 18;
        ushort OFM_dcmjpls  = 19;
        ushort OFM_dcmwave  = 20;
        ushort OFM_dcmrt    = 21;
        ushort OFM_dcmloco  = 22;
        ushort OFM_dcmstcom = 23;
        ushort OFM_dcmppscu = 24;

         // conditions
         OFConditionConst ECC_UnknownDocumentType    = new OFConditionConst(10,  1, OFStatus.OF_error, "Unknown Document Type");
         OFConditionConst ECC_InvalidDocument = new OFConditionConst(10, 2, OFStatus.OF_error, "Invalid Document");
         OFConditionConst ECC_InvalidDocumentTree = new OFConditionConst(10, 3, OFStatus.OF_error, "Invalid Document Tree");
         OFConditionConst ECC_MandatoryAttributeMissing = new OFConditionConst(10, 4, OFStatus.OF_error, "Mandatory Attribute missing");
         OFConditionConst ECC_InvalidValue = new OFConditionConst(10, 5, OFStatus.OF_error, "Invalid Value");
         OFConditionConst ECC_UnsupportedValue = new OFConditionConst(10, 6, OFStatus.OF_error, "Unsupported Value");
         OFConditionConst ECC_UnknownValueType = new OFConditionConst(10, 7, OFStatus.OF_error, "Unknown Value Type");
         OFConditionConst ECC_UnknownRelationshipType = new OFConditionConst(10, 8, OFStatus.OF_error, "Unknown Relationship Type");
         OFConditionConst ECC_InvalidByValueRelationship = new OFConditionConst(10, 9, OFStatus.OF_error, "Invalid by-value Relationship");
         OFConditionConst ECC_InvalidByReferenceRelationship = new OFConditionConst(10, 10, OFStatus.OF_error, "Invalid by-reference Relationship");
         OFConditionConst ECC_SOPInstanceNotFound = new OFConditionConst(10, 11, OFStatus.OF_error, "SOP Instance not found");
         OFConditionConst ECC_DifferentSOPClassesForAnInstance = new OFConditionConst(10, 12, OFStatus.OF_error, "Different SOP Classes for an Instance");
         OFConditionConst ECC_CodingSchemeNotFound = new OFConditionConst(10, 13, OFStatus.OF_error, "Coding Scheme Designator not found");
         OFConditionConst ECC_CorruptedXMLStructure = new OFConditionConst(10, 14, OFStatus.OF_error, "Corrupted XML structure");

         //OFCondition SR_EC_UnknownDocumentType       = new OFCondition(ECC_UnknownDocumentType);
         //OFCondition SR_EC_InvalidDocument                      = new OFCondition(ECC_InvalidDocument);
         //OFCondition SR_EC_InvalidDocumentTree                  = new OFCondition(ECC_InvalidDocumentTree);
         //OFCondition SR_EC_MandatoryAttributeMissing            = new OFCondition(ECC_MandatoryAttributeMissing);
         //OFCondition SR_EC_InvalidValue                         = new OFCondition(ECC_InvalidValue);
         //OFCondition SR_EC_UnsupportedValue                     = new OFCondition(ECC_UnsupportedValue);
         //OFCondition SR_EC_UnknownValueType                     = new OFCondition(ECC_UnknownValueType);
         //OFCondition SR_EC_UnknownRelationshipType              = new OFCondition(ECC_UnknownRelationshipType);
         //OFCondition SR_EC_InvalidByValueRelationship           = new OFCondition(ECC_InvalidByValueRelationship);
         //OFCondition SR_EC_InvalidByReferenceRelationship       = new OFCondition(ECC_InvalidByReferenceRelationship);
         //OFCondition SR_EC_SOPInstanceNotFound                  = new OFCondition(ECC_SOPInstanceNotFound);
         //OFCondition SR_EC_DifferentSOPClassesForAnInstance     = new OFCondition(ECC_DifferentSOPClassesForAnInstance);
         //OFCondition SR_EC_CodingSchemeNotFound                 = new OFCondition(ECC_CodingSchemeNotFound);
         //OFCondition SR_EC_CorruptedXMLStructure = new OFCondition(ECC_CorruptedXMLStructure);
    };

    public class OFConditionString : OFConditionBase
    {
        /// code/module identification. Code is lower 16 bits, module is upper 16 bits
        long theCodeAndModule;
        /// status
        OFStatus theStatus;

        /// condition description
        string theText;

        /// default constructor
        public OFConditionString(ushort aModule, ushort aCode, OFStatus aStatus, string aText)
            :base()
        {
            theStatus = aStatus;
            theCodeAndModule = aCode;
            theText = aText;
        }

        /// copy constructor
        public OFConditionString(ref OFConditionString arg)
            :base(arg)
        {
            theStatus = arg.theStatus;
            theCodeAndModule = arg.theCodeAndModule;
            theText = arg.theText;
        }

        /// destructor
        ~OFConditionString()
        {
        }

        /** this method returns a pointer to a OFConditionBase object containing a clone
        *  of this object. In this case, deletable() is false and clone just returns a pointer to this.
        *  @return alias of this object
        */
        public override OFConditionBase clone()
        {
            return this;
        }

        /** returns a combined code and module for this object.
        *  code is lower 16 bits, module is upper 16 bits
       */
        public override long codeAndModule()
        {
            return theCodeAndModule;
        }

        /// returns the status for this object.
       public override OFStatus status()
       {
           return theStatus;
       }

      /// returns the error message text for this object.
      public override string text()
      {
          return theText;
      }

      /** checks if this object is deletable, e.g. all instances
       *  of this class are allocated on the heap.
       *  @return always false for this class
       */
      public virtual bool deletable()
      {
          return false;
      }
    };

    public enum E_DocumentType
    {
        /// internal type used to indicate an error
        DT_invalid,
        /// internal type used to indicate an unknown/unsupported document type
        DT_unknown = DT_invalid,
        /// DICOM IOD: Basic Text SR
        DT_BasicTextSR,
        /// DICOM IOD: Enhanced SR
        DT_EnhancedSR,
        /// DICOM IOD: Comprehensive SR
        DT_ComprehensiveSR,
        /// DICOM IOD: Key Object Selection Document
        DT_KeyObjectSelectionDocument,
        /// DICOM IOD: Mammography CAD SR
        DT_MammographyCadSR,
        /// DICOM IOD: Chest CAD SR
        DT_ChestCadSR,
        /// DICOM IOD: Colon CAD SR
        DT_ColonCadSR,
        /// DICOM IOD: Procedure Log
        DT_ProcedureLog,
        /// DICOM IOD: X-Ray Radiation Dose SR
        DT_XRayRadiationDoseSR,
        /// DICOM IOD: Spectacle Prescription Report
        DT_SpectaclePrescriptionReport,
        /// DICOM IOD: Macular Grid Thickness and Volume Report
        DT_MacularGridThicknessAndVolumeReport,
        /// DICOM IOD: Implantation Plan SR Document
        DT_ImplantationPlanSRDocument,
        /// internal type used to mark the last entry
        DT_last = DT_ImplantationPlanSRDocument
    };

    /** SR relationship types
     */
    public enum E_RelationshipType
    {
        /// internal type used to indicate an error
        RT_invalid,
        /// internal type used to indicate an unknown relationship type (defined term)
        RT_unknown,
        /// internal type used for the document root
        RT_isRoot,
        /// DICOM Relationship Type: CONTAINS
        RT_contains,
        /// DICOM Relationship Type: HAS OBS CONTEXT
        RT_hasObsContext,
        /// DICOM Relationship Type: HAS ACQ CONTEXT
        RT_hasAcqContext,
        /// DICOM Relationship Type: HAS CONCEPT MOD
        RT_hasConceptMod,
        /// DICOM Relationship Type: HAS PROPERTIES
        RT_hasProperties,
        /// DICOM Relationship Type: INFERRED FROM
        RT_inferredFrom,
        /// DICOM Relationship Type: SELECTED FROM
        RT_selectedFrom,
        /// internal type used to mark the last entry
        RT_last = RT_selectedFrom
    };

    /** SR value types
     */
    public enum E_ValueType
    {
        /// internal type used to indicate an error
        VT_invalid,
        /// DICOM Value Type: TEXT
        VT_Text,
        /// DICOM Value Type: CODE
        VT_Code,
        /// DICOM Value Type: NUM
        VT_Num,
        /// DICOM Value Type: DATETIME
        VT_DateTime,
        /// DICOM Value Type: DATE
        VT_Date,
        /// DICOM Value Type: TIME
        VT_Time,
        /// DICOM Value Type: UIDREF
        VT_UIDRef,
        /// DICOM Value Type: PNAME
        VT_PName,
        /// DICOM Value Type: SCOORD
        VT_SCoord,
        /// DICOM Value Type: SCOORD3D
        VT_SCoord3D,
        /// DICOM Value Type: TCOORD
        VT_TCoord,
        /// DICOM Value Type: COMPOSITE
        VT_Composite,
        /// DICOM Value Type: IMAGE
        VT_Image,
        /// DICOM Value Type: WAVEFORM
        VT_Waveform,
        /// DICOM Value Type: CONTAINER
        VT_Container,
        /// internal type used to indicate by-reference relationships
        VT_byReference,
        /// internal type used to mark the last entry
        VT_last = VT_byReference
    };

    /** SR graphic types.  Used for content item SCOORD.
     */
    public enum E_GraphicType
    {
        /// internal type used to indicate an error
        GT_invalid,
        /// internal type used to indicate an unknown graphic type (defined term)
        GT_unknown = GT_invalid,
        /// DICOM Graphic Type: POINT
        GT_Point,
        /// DICOM Graphic Type: MULTIPOINT
        GT_Multipoint,
        /// DICOM Graphic Type: POLYLINE
        GT_Polyline,
        /// DICOM Graphic Type: CIRCLE
        GT_Circle,
        /// DICOM Graphic Type: ELLIPSE
        GT_Ellipse,
        /// internal type used to mark the last entry
        GT_last = GT_Ellipse
    };

    /** SR graphic types (3D).  Used for content item SCOORD3D.
     */
    public enum E_GraphicType3D
    {
        /// internal type used to indicate an error
        GT3_invalid,
        /// internal type used to indicate an unknown graphic type (defined term)
        GT3_unknown = GT3_invalid,
        /// DICOM Graphic Type: POINT
        GT3_Point,
        /// DICOM Graphic Type: MULTIPOINT
        GT3_Multipoint,
        /// DICOM Graphic Type: POLYLINE
        GT3_Polyline,
        /// DICOM Graphic Type: POLYGON
        GT3_Polygon,
        /// DICOM Graphic Type: ELLIPSE
        GT3_Ellipse,
        /// DICOM Graphic Type: ELLIPSOID
        GT3_Ellipsoid,
        /// internal type used to mark the last entry
        GT3_last = GT3_Ellipsoid
    };

    /** SR temporal range types.  Used for content item TCOORD.
     */
    public enum E_TemporalRangeType
    {
        /// internal type used to indicate an error
        TRT_invalid,
        /// internal type used to indicate an unknown range type (defined term)
        TRT_unknown = TRT_invalid,
        /// DICOM Temporal Range Type: POINT
        TRT_Point,
        /// DICOM Temporal Range Type: MULTIPOINT
        TRT_Multipoint,
        /// DICOM Temporal Range Type: SEGMENT
        TRT_Segment,
        /// DICOM Temporal Range Type: MULTISEGMENT
        TRT_Multisegment,
        /// DICOM Temporal Range Type: BEGIN
        TRT_Begin,
        /// DICOM Temporal Range Type: END
        TRT_End,
        /// internal type used to mark the last entry
        TRT_last = TRT_End
    };

    /** SR continuity of content flag. Used for content item CONTAINER.
     */
    public enum E_ContinuityOfContent
    {
        /// internal type used to indicate an error
        COC_invalid,
        /// DICOM enumerated value: SEPARATE
        COC_Separate,
        /// DICOM enumerated value: CONTINUOUS
        COC_Continuous,
        /// internal type used to mark the last entry
        COC_last = COC_Continuous
    };

    /** SR document preliminary flag
     */
    public enum E_PreliminaryFlag
    {
        /// internal type used to indicate an error or the absence of this flag
        PF_invalid,
        /// DICOM enumerated value: PRELIMINARY
        PF_Preliminary,
        /// DICOM enumerated value: FINAL
        PF_Final,
        /// internal type used to mark the last entry
        PF_last = PF_Final
    };

    /** SR document completion flag
     */
    public enum E_CompletionFlag
    {
        /// internal type used to indicate an error
        CF_invalid,
        /// DICOM enumerated value: PARTIAL
        CF_Partial,
        /// DICOM enumerated value: COMPLETE
        CF_Complete,
        /// internal type used to mark the last entry
        CF_last = CF_Complete
    };

    /** SR document verification flag
     */
    public enum E_VerificationFlag
    {
        /// internal type used to indicate an error
        VF_invalid,
        /// DICOM enumerated value: UNVERIFIED
        VF_Unverified,
        /// DICOM enumerated value: VERIFIED
        VF_Verified,
        /// internal type used to mark the last entry
        VF_last = VF_Verified
    };

    /** Specific character set
     */
    public enum E_CharacterSet
    {
        /// internal type used to indicate an error
        CS_invalid,
        /// internal type used to indicate an unknown/unsupported character set
        CS_unknown = CS_invalid,
        /// ISO 646 (ISO-IR 6): ASCII
        CS_ASCII,
        /// ISO-IR 100: Latin alphabet No. 1
        CS_Latin1,
        /// ISO-IR 101: Latin alphabet No. 2
        CS_Latin2,
        /// ISO-IR 109: Latin alphabet No. 3
        CS_Latin3,
        /// ISO-IR 110: Latin alphabet No. 4
        CS_Latin4,
        /// ISO-IR 144: Cyrillic
        CS_Cyrillic,
        /// ISO-IR 127: Arabic
        CS_Arabic,
        /// ISO-IR 126: Greek
        CS_Greek,
        /// ISO-IR 138: Hebrew
        CS_Hebrew,
        /// ISO-IR 148: Latin alphabet No. 5
        CS_Latin5,
        /// ISO-IR 13: Japanese (Katakana/Romaji)
        CS_Japanese,
        /// ISO-IR 166: Thai
        CS_Thai,
        // UTF-8: Unicode in UTF-8
        CS_UTF8,
        /// internal type used to mark the last entry
        CS_last = CS_UTF8
    };

    /** Add node mode
     */
    public enum E_AddMode
    {
        /// add new node after current one (sibling)
        AM_afterCurrent,
        /// add new node before current one (sibling)
        AM_beforeCurrent,
        /// add new node below current one (after last child)
        AM_belowCurrent
    };

    public enum E_MarkupMode
    {
        /// HTML (Hyper Text Markup Language)
        MM_HTML,
        /// HTML 3.2 (Hyper Text Markup Language)
        MM_HTML32,
        /// XHTML (Extensible Hyper Text Markup Language)
        MM_XHTML,
        /// XML (Extensible Markup Language)
        MM_XML
    };

    public class DSRTypes
    {
        /// <summary>
        /// 
        /// </summary>
        class S_DocumentTypeNameMap
        {
            public E_DocumentType Type { get; set; }
            public string SOPClassUID { get; set; }
            public bool EnhancedEquipmentModule { get; set; }
            public string Modality { get; set; }
            public string ReadableName { get; set; }

            public S_DocumentTypeNameMap(E_DocumentType type, string sopClassUID, bool enhancedEquipmentModule, string modality, string readableName)
            {
                Type = type;
                SOPClassUID = sopClassUID;
                EnhancedEquipmentModule = enhancedEquipmentModule;
                Modality = modality;
                ReadableName = readableName;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_DocumentTypeNameMap[] DocumentTypeNameMap = 
        {
            new S_DocumentTypeNameMap(E_DocumentType.DT_invalid, "",false, "", "invalid document type"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_BasicTextSR, SopClass.BasicTextSrStorageUid, false, "SR", "Basic Text SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_EnhancedSR, SopClass.EnhancedSrStorageUid, false, "SR", "Enhanced SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_ComprehensiveSR, SopClass.ComprehensiveSrStorageUid, false, "SR", "Comprehensive SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_KeyObjectSelectionDocument, SopClass.KeyObjectSelectionDocumentStorageUid, false, "KO", "Key Object Selection Document"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_MammographyCadSR, SopClass.MammographyCadSrStorageUid, false, "SR", "Mammography CAD SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_ChestCadSR, SopClass.ChestCadSrStorageUid, false, "SR", "Chest CAD SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_ColonCadSR, SopClass.ColonCadSrStorageUid, true,  "SR", "Colon CAD SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_ProcedureLog, SopClass.ProcedureLogStorageUid, false, "SR", "Procedure Log"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_XRayRadiationDoseSR, SopClass.XRayRadiationDoseSrStorageUid, true,  "SR", "X-Ray Radiation Dose SR"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_SpectaclePrescriptionReport, SopClass.SpectaclePrescriptionReportStorageUid, true,  "SR", "Spectacle Prescription Report"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_MacularGridThicknessAndVolumeReport, SopClass.MacularGridThicknessAndVolumeReportStorageUid, true,  "SR", "Macular Grid Thickness and Volume Report"),
            new S_DocumentTypeNameMap(E_DocumentType.DT_ImplantationPlanSRDocument, SopClass.ImplantationPlanSrStorageUid, true,  "SR", "Implantation Plan SR Document")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_RelationshipTypeNameMap
        {
            public E_RelationshipType Type { get; set; }
            public string DefinedTerm { get; set; }
            public string ReadableName { get; set; }

            public S_RelationshipTypeNameMap(E_RelationshipType type, string definedTerm, string readableName)
            {
                Type = type;
                DefinedTerm = definedTerm;
                ReadableName = readableName;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_RelationshipTypeNameMap[] RelationshipTypeNameMap =
        {
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_invalid, "", "invalid relationship type"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_unknown, "", "unknown relationship type"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_isRoot, "", ""),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_contains, "CONTAINS", "contains"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_hasObsContext, "HAS OBS CONTEXT", "has obs context"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_hasAcqContext, "HAS ACQ CONTEXT", "has acq context"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_hasConceptMod, "HAS CONCEPT MOD", "has concept mod"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_hasProperties, "HAS PROPERTIES",  "has properties"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_inferredFrom,  "INFERRED FROM",  "inferred from"),
            new S_RelationshipTypeNameMap(E_RelationshipType.RT_selectedFrom,  "SELECTED FROM", "selected from")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_ValueTypeNameMap
        {
            public E_ValueType Type { get; set; }
            public string DefinedTerm { get; set; }
            public string XMLTagName { get; set; }
            public string ReadableName { get; set; }

            public S_ValueTypeNameMap(E_ValueType type, string definedTerm, string xmlTagName, string readableName)
            {
                Type = type;
                DefinedTerm = definedTerm;
                XMLTagName = xmlTagName;
                ReadableName = readableName;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_ValueTypeNameMap[] ValueTypeNameMap =
        {
            new S_ValueTypeNameMap(E_ValueType.VT_invalid,     "",               "item",      "invalid/unknown value type"),
            new S_ValueTypeNameMap(E_ValueType.VT_Text,        "TEXT",           "text",      "Text"),
            new S_ValueTypeNameMap(E_ValueType.VT_Code,        "CODE",           "code",      "Code"),
            new S_ValueTypeNameMap(E_ValueType.VT_Num,         "NUM",            "num",       "Number"),
            new S_ValueTypeNameMap(E_ValueType.VT_DateTime,    "DATETIME",       "datetime",  "Date/Time"),
            new S_ValueTypeNameMap(E_ValueType.VT_Date,        "DATE",           "date",      "Date"),
            new S_ValueTypeNameMap(E_ValueType.VT_Time,        "TIME",           "time",      "Time"),
            new S_ValueTypeNameMap(E_ValueType.VT_UIDRef,      "UIDREF",         "uidref",    "UID Reference"),
            new S_ValueTypeNameMap(E_ValueType.VT_PName,       "PNAME",          "pname",     "Person Name"),
            new S_ValueTypeNameMap(E_ValueType.VT_SCoord,      "SCOORD",         "scoord",    "Spatial Coordinates"),
            new S_ValueTypeNameMap(E_ValueType.VT_SCoord3D,    "SCOORD3D",       "scoord3d",  "Spatial Coordinates (3D)"),
            new S_ValueTypeNameMap(E_ValueType.VT_TCoord,      "TCOORD",         "tcoord",    "Temporal Coordinates"),
            new S_ValueTypeNameMap(E_ValueType.VT_Composite,   "COMPOSITE",      "composite", "Composite Object"),
            new S_ValueTypeNameMap(E_ValueType.VT_Image,       "IMAGE",          "image",     "Image"),
            new S_ValueTypeNameMap(E_ValueType.VT_Waveform,    "WAVEFORM",       "waveform",  "Waveform"),
            new S_ValueTypeNameMap(E_ValueType.VT_Container,   "CONTAINER",      "container", "Container"),
            new S_ValueTypeNameMap(E_ValueType.VT_byReference, "(by-reference)", "reference", "(by-reference)")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_GraphicTypeNameMap
        {
            public E_GraphicType Type { get; set; }
            public string EnumeratedValue { get; set; }
            public string ReadableName { get; set; }

            public S_GraphicTypeNameMap(E_GraphicType type, string enumeratedValue, string readableName)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
                ReadableName = readableName;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_GraphicTypeNameMap[] GraphicTypeNameMap =
        {
            new S_GraphicTypeNameMap(E_GraphicType.GT_invalid,    "",           "invalid/unknown graphic type"),
            new S_GraphicTypeNameMap(E_GraphicType.GT_Point,      "POINT",      "Point"),
            new S_GraphicTypeNameMap(E_GraphicType.GT_Multipoint, "MULTIPOINT", "Multiple Points"),
            new S_GraphicTypeNameMap(E_GraphicType.GT_Polyline,   "POLYLINE",   "Polyline"),
            new S_GraphicTypeNameMap(E_GraphicType.GT_Circle,     "CIRCLE",     "Circle"),
            new S_GraphicTypeNameMap(E_GraphicType.GT_Ellipse,    "ELLIPSE",    "Ellipse")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_GraphicType3DNameMap
        {
            public E_GraphicType3D Type { get; set; }
            public string EnumeratedValue { get; set; }
            public string ReadableName { get; set; }

            public S_GraphicType3DNameMap(E_GraphicType3D type, string enumeratedValue, string readableName)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
                ReadableName = readableName;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_GraphicType3DNameMap[] GraphicType3DNameMap =
        {
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_invalid,    "",           "invalid/unknown graphic type"),
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_Point,      "POINT",      "Point"),
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_Multipoint, "MULTIPOINT", "Multiple Points"),
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_Polyline,   "POLYLINE",   "Polyline"),
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_Polygon ,   "POLYGON",    "Polygon"),
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_Ellipse,    "ELLIPSE",    "Ellipse"),
            new S_GraphicType3DNameMap(E_GraphicType3D.GT3_Ellipsoid,  "ELLIPSOID",  "Ellipsoid")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_TemporalRangeTypeNameMap
        {
            public E_TemporalRangeType Type { get; set; }
            public string EnumeratedValue { get; set; }
            public string ReadableName { get; set; }

            public S_TemporalRangeTypeNameMap(E_TemporalRangeType type, string enumeratedValue, string readableName)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
                ReadableName = readableName;
            }
        };

        static S_TemporalRangeTypeNameMap[] TemporalRangeTypeNameMap =
        {
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_invalid,      "",             ""),
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_Point,        "POINT",        "Point"),
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_Multipoint,   "MULTIPOINT",   "Multiple Points"),
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_Segment,      "SEGMENT",      "Segment"),
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_Multisegment, "MULTISEGMENT", "Multiple Segments"),
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_Begin,        "BEGIN",        "Begin"),
            new S_TemporalRangeTypeNameMap(E_TemporalRangeType.TRT_End,          "END",          "End")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_ContinuityOfContentNameMap
        {
            public E_ContinuityOfContent Type { get; set; }
            public string EnumeratedValue { get; set; }

            public S_ContinuityOfContentNameMap(E_ContinuityOfContent type, string enumeratedValue)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_ContinuityOfContentNameMap[] ContinuityOfContentNameMap =
        {
            new S_ContinuityOfContentNameMap(E_ContinuityOfContent.COC_invalid,    ""),
            new S_ContinuityOfContentNameMap(E_ContinuityOfContent.COC_Separate,   "SEPARATE"),
            new S_ContinuityOfContentNameMap(E_ContinuityOfContent.COC_Continuous, "CONTINUOUS")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_PreliminaryFlagNameMap
        {
            public E_PreliminaryFlag Type { get; set; }
            public string EnumeratedValue { get; set; }

            public S_PreliminaryFlagNameMap(E_PreliminaryFlag type, string enumeratedValue)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_PreliminaryFlagNameMap[] PreliminaryFlagNameMap =
        {
            new S_PreliminaryFlagNameMap(E_PreliminaryFlag.PF_invalid,      ""),
            new S_PreliminaryFlagNameMap(E_PreliminaryFlag.PF_Preliminary,  "PRELIMINARY"),
            new S_PreliminaryFlagNameMap(E_PreliminaryFlag.PF_Final,        "FINAL")
        };

        class S_CompletionFlagNameMap
        {
            public E_CompletionFlag Type { get; set; }
            public string EnumeratedValue { get; set; }

            public S_CompletionFlagNameMap(E_CompletionFlag type, string enumeratedValue)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_CompletionFlagNameMap[] CompletionFlagNameMap =
        {
            new S_CompletionFlagNameMap(E_CompletionFlag.CF_invalid,  ""),
            new S_CompletionFlagNameMap(E_CompletionFlag.CF_Partial,  "PARTIAL"),
            new S_CompletionFlagNameMap(E_CompletionFlag.CF_Complete, "COMPLETE")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_VerificationFlagNameMap
        {
            public E_VerificationFlag Type { get; set; }
            public string EnumeratedValue { get; set; }

            public S_VerificationFlagNameMap(E_VerificationFlag type, string enumeratedValue)
            {
                Type = type;
                EnumeratedValue = enumeratedValue;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_VerificationFlagNameMap[] VerificationFlagNameMap =
        {
            new S_VerificationFlagNameMap(E_VerificationFlag.VF_invalid,    ""),
            new S_VerificationFlagNameMap(E_VerificationFlag.VF_Unverified, "UNVERIFIED"),
            new S_VerificationFlagNameMap(E_VerificationFlag.VF_Verified,   "VERIFIED")
        };

        /// <summary>
        /// 
        /// </summary>
        class S_CharacterSetNameMap
        {
            public E_CharacterSet Type { get; set; }
            public string DefinedTerm { get; set; }
            public string HTMLName { get; set; }
            public string XMLName { get; set; }

            public S_CharacterSetNameMap(E_CharacterSet type, string definedTerm, string htmlName, string xmlName)
            {
                Type = type;
                DefinedTerm = definedTerm;
                HTMLName = htmlName;
                XMLName = xmlName;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_CharacterSetNameMap[] CharacterSetNameMap =
        {
            // columns: enum, DICOM, HTML, XML (if "?" a warning is reported)
            new S_CharacterSetNameMap(E_CharacterSet.CS_invalid,  "",           "",           ""),
            new S_CharacterSetNameMap(E_CharacterSet.CS_ASCII,    "ISO_IR 6",   "",           "UTF-8"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Latin1,   "ISO_IR 100", "ISO-8859-1", "ISO-8859-1"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Latin2,   "ISO_IR 101", "ISO-8859-2", "ISO-8859-2"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Latin3,   "ISO_IR 109", "ISO-8859-3", "ISO-8859-3"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Latin4,   "ISO_IR 110", "ISO-8859-4", "ISO-8859-4"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Cyrillic, "ISO_IR 144", "ISO-8859-5", "ISO-8859-5"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Arabic,   "ISO_IR 127", "ISO-8859-6", "ISO-8859-6"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Greek,    "ISO_IR 126", "ISO-8859-7", "ISO-8859-7"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Hebrew,   "ISO_IR 138", "ISO-8859-8", "ISO-8859-8"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Latin5,   "ISO_IR 148", "ISO-8859-9", "ISO-8859-9"),
            new S_CharacterSetNameMap(E_CharacterSet.CS_Japanese, "ISO_IR 13",  "?",          "?"),  /* JIS_X0201 ? */
            new S_CharacterSetNameMap(E_CharacterSet.CS_Thai,     "ISO_IR 166", "?",          "?"),  /* TIS-620 ? */
            new S_CharacterSetNameMap(E_CharacterSet.CS_UTF8,     "ISO_IR 192", "UTF-8",      "UTF-8")
        };

        /// <summary>
        /// 
        /// </summary>
        public class S_DCMModalityTableMap
        {
            public string SOPClassUID { get; set; }
            public string Modality { get; set; }
            public ulong AverageSize { get; set; }

            public S_DCMModalityTableMap(string sopClassUID, string modality, ulong averageSize)
            {
                SOPClassUID = sopClassUID;
                Modality = modality;
                AverageSize = averageSize;
            }

            public static string dcmSOPClassUIDToModality(string sopClassUID)
            {
                if (sopClassUID == null)
                {
                    return null;
                }
                /* check for known SOP class */
                for (int i = 0; i < DCMModalityTableMap.Length; i++)
                {
                    if (string.Compare(DCMModalityTableMap[i].SOPClassUID, sopClassUID) == 0)
                    {
                        return DCMModalityTableMap[i].Modality;
                    }
                }
                /* SOP class not found */
                return null;
            }

            public static ulong dcmGuessModalityBytes(string sopClassUID)
            {
                ulong nbytes = 1048576;

                if (sopClassUID == null)
                {
                    return nbytes;
                }

                for (int i = 0; i < DCMModalityTableMap.Length; i++)
                {
                    if (string.Compare(DCMModalityTableMap[i].SOPClassUID, sopClassUID) == 0)
                    {
                        nbytes = DCMModalityTableMap[i].AverageSize;
                    }
                }
                return nbytes;
            }
        };

        /// <summary>
        /// 
        /// </summary>
        static S_DCMModalityTableMap[] DCMModalityTableMap = 
        {
            new S_DCMModalityTableMap(SopClass.AmbulatoryEcgWaveformStorageUid, "ECA", 4096),
            new S_DCMModalityTableMap(SopClass.ArterialPulseWaveformStorageUid, "WVa", 4096),
            new S_DCMModalityTableMap(SopClass.AutorefractionMeasurementsStorageUid, "OPa", 4096),
            new S_DCMModalityTableMap(SopClass.BasicStructuredDisplayStorageUid, "SD", 4096),
            new S_DCMModalityTableMap(SopClass.BasicTextSrStorageUid, "SRt", 4096),
            new S_DCMModalityTableMap(SopClass.BasicVoiceAudioWaveformStorageUid, "AUV", 4096),
            new S_DCMModalityTableMap(SopClass.BlendingSoftcopyPresentationStateStorageSopClassUid, "PSb", 4096),
            new S_DCMModalityTableMap(SopClass.BreastTomosynthesisImageStorageUid, "BT", 4096 * 4096 * 2),
            new S_DCMModalityTableMap(SopClass.CardiacElectrophysiologyWaveformStorageUid, "WVc", 4096),
            new S_DCMModalityTableMap(SopClass.ChestCadSrStorageUid, "SRh", 4096),
            new S_DCMModalityTableMap(SopClass.ColonCadSrStorageUid, "SRo", 4096),
            new S_DCMModalityTableMap(SopClass.ColorSoftcopyPresentationStateStorageSopClassUid, "PSc", 4096),
            new S_DCMModalityTableMap(SopClass.ComprehensiveSrStorageUid, "SRc", 4096),
            new S_DCMModalityTableMap(SopClass.ComputedRadiographyImageStorageUid, "CR", 2048 * 2048 * 2),
            new S_DCMModalityTableMap(SopClass.CtImageStorageUid, "CT", 512 * 512 * 2),
            new S_DCMModalityTableMap(SopClass.DeformableSpatialRegistrationStorageUid, "RGd", 4096),
            new S_DCMModalityTableMap(SopClass.DigitalIntraOralXRayImageStorageForPresentationUid, "DXo", 1024 * 1024 * 2),
            new S_DCMModalityTableMap(SopClass.DigitalIntraOralXRayImageStorageForProcessingUid, "DPo", 1024 * 1024 * 2),
            new S_DCMModalityTableMap(SopClass.DigitalMammographyXRayImageStorageForPresentationUid, "DXm", 4096 * 4096 * 2),
            new S_DCMModalityTableMap(SopClass.DigitalMammographyXRayImageStorageForProcessingUid, "DPm", 4096 * 4096 * 2),
            new S_DCMModalityTableMap(SopClass.DigitalXRayImageStorageForPresentationUid, "DX", 2048 * 2048 * 2),
            new S_DCMModalityTableMap(SopClass.DigitalXRayImageStorageForProcessingUid, "DP", 2048 * 2048 * 2),
            new S_DCMModalityTableMap(SopClass.EncapsulatedCdaStorageUid, "CDA", 4096),
            new S_DCMModalityTableMap(SopClass.EncapsulatedPdfStorageUid, "PDF", 1024 * 1024),
            new S_DCMModalityTableMap(SopClass.EnhancedCtImageStorageUid, "CTe", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.EnhancedMrColorImageStorageUid, "MRc", 256 * 512 * 512 * 3 ),
            new S_DCMModalityTableMap(SopClass.EnhancedMrImageStorageUid, "MRe", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.EnhancedPetImageStorageUid, "PIe", 512 * 512 * 2),
            new S_DCMModalityTableMap(SopClass.EnhancedSrStorageUid, "SRe", 4096),
            new S_DCMModalityTableMap(SopClass.EnhancedUsVolumeStorageUid, "USe", 512 * 512),
            new S_DCMModalityTableMap(SopClass.EnhancedXaImageStorageUid, "XAe", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.EnhancedXrfImageStorageUid, "RFe", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.GeneralAudioWaveformStorageUid, "AUG", 4096),
            new S_DCMModalityTableMap(SopClass.GeneralEcgWaveformStorageUid, "ECG", 4096),
            new S_DCMModalityTableMap(SopClass.GenericImplantTemplateStorageUid, "IT", 4096),
            new S_DCMModalityTableMap(SopClass.GrayscaleSoftcopyPresentationStateStorageSopClassUid, "PSg", 4096),
            new S_DCMModalityTableMap(SopClass.HemodynamicWaveformStorageUid, "WVh", 4096),
            new S_DCMModalityTableMap(SopClass.ImplantAssemblyTemplateStorageUid, "ITa", 4096),
            new S_DCMModalityTableMap(SopClass.ImplantationPlanSrStorageUid, "SRi", 4096),
            new S_DCMModalityTableMap(SopClass.ImplantTemplateGroupStorageUid, "ITg", 4096),
            new S_DCMModalityTableMap(SopClass.IntraocularLensCalculationsStorageUid, "OPc", 4096),
            new S_DCMModalityTableMap(SopClass.KeratometryMeasurementsStorageUid, "OPk", 4096),
            new S_DCMModalityTableMap(SopClass.KeyObjectSelectionDocumentStorageUid, "KO", 4096),
            new S_DCMModalityTableMap(SopClass.LensometryMeasurementsStorageUid, "OPl", 4096),
            new S_DCMModalityTableMap(SopClass.MacularGridThicknessAndVolumeReportStorageUid, "SRg", 4096),
            new S_DCMModalityTableMap(SopClass.MammographyCadSrStorageUid, "SRm", 4096),
            new S_DCMModalityTableMap(SopClass.MrImageStorageUid, "MR", 256 * 256 * 2),
            new S_DCMModalityTableMap(SopClass.MrSpectroscopyStorageUid, "MRs", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.MultiFrameGrayscaleByteSecondaryCaptureImageStorageUid, "SCb", 512 * 512),
            new S_DCMModalityTableMap(SopClass.MultiFrameGrayscaleWordSecondaryCaptureImageStorageUid, "SCw", 512 * 512 * 2),
            new S_DCMModalityTableMap(SopClass.MultiFrameSingleBitSecondaryCaptureImageStorageUid, "SCs", 1024 * 1024),
            new S_DCMModalityTableMap(SopClass.MultiFrameTrueColorSecondaryCaptureImageStorageUid, "SCc", 512 * 512 * 3),
            new S_DCMModalityTableMap(SopClass.NuclearMedicineImageStorageUid, "NM", 64 * 64 * 2),
            new S_DCMModalityTableMap(SopClass.OphthalmicAxialMeasurementsStorageUid, "OPx", 4096),
            new S_DCMModalityTableMap(SopClass.OphthalmicPhotography16BitImageStorageUid, "OPw", 768 * 576 * 6),
            new S_DCMModalityTableMap(SopClass.OphthalmicPhotography8BitImageStorageUid, "OPb", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.OphthalmicTomographyImageStorageUid, "OPb", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.OphthalmicVisualFieldStaticPerimetryMeasurementsStorageUid, "OPp", 4096),
            new S_DCMModalityTableMap(SopClass.PositronEmissionTomographyImageStorageUid, "PI", 512 * 512 * 2),
            new S_DCMModalityTableMap(SopClass.ProcedureLogStorageUid, "SRp", 4096),
            new S_DCMModalityTableMap(SopClass.PseudoColorSoftcopyPresentationStateStorageSopClassUid, "PSp", 4096),
            new S_DCMModalityTableMap(SopClass.RawDataStorageUid, "RAW", 512 * 512 * 256),
            new S_DCMModalityTableMap(SopClass.RealWorldValueMappingStorageUid, "RWM", 4096),
            new S_DCMModalityTableMap(SopClass.RespiratoryWaveformStorageUid, "WVr", 4096),
            new S_DCMModalityTableMap(SopClass.RtBeamsTreatmentRecordStorageUid, "RTb", 4096),
            new S_DCMModalityTableMap(SopClass.RtBrachyTreatmentRecordStorageUid, "RTr", 4096),
            new S_DCMModalityTableMap(SopClass.RtDoseStorageUid, "RD", 4096),
            new S_DCMModalityTableMap(SopClass.RtImageStorageUid, "RI", 4096),
            new S_DCMModalityTableMap(SopClass.RtIonBeamsTreatmentRecordStorageUid, "RTi", 4096),
            new S_DCMModalityTableMap(SopClass.RtIonPlanStorageUid, "RPi", 4096),
            new S_DCMModalityTableMap(SopClass.RtPlanStorageUid, "RP", 4096),
            new S_DCMModalityTableMap(SopClass.RtStructureSetStorageUid, "RS", 4096),
            new S_DCMModalityTableMap(SopClass.RtTreatmentSummaryRecordStorageUid, "RTs", 4096),
            new S_DCMModalityTableMap(SopClass.SecondaryCaptureImageStorageUid, "SC", 512 * 512 * 2),
            new S_DCMModalityTableMap(SopClass.SegmentationStorageUid, "SG", 4096),
            new S_DCMModalityTableMap(SopClass.SpatialFiducialsStorageUid, "FID", 4096),
            new S_DCMModalityTableMap(SopClass.SpatialRegistrationStorageUid, "RGs", 4096),
            new S_DCMModalityTableMap(SopClass.SpectaclePrescriptionReportStorageUid, "SRs", 4096),
            new S_DCMModalityTableMap(SopClass.StereometricRelationshipStorageUid, "OPr", 4096),
            new S_DCMModalityTableMap(SopClass.SubjectiveRefractionMeasurementsStorageUid, "OPs", 4096),
            new S_DCMModalityTableMap(SopClass.SurfaceSegmentationStorageUid, "SGs", 4096),
            new S_DCMModalityTableMap(SopClass.Sop12LeadEcgWaveformStorageUid, "TLE", 4096),
            new S_DCMModalityTableMap(SopClass.UltrasoundImageStorageUid, "US", 512 * 512),
            new S_DCMModalityTableMap(SopClass.UltrasoundMultiFrameImageStorageUid, "USm", 512 * 512),
            new S_DCMModalityTableMap(SopClass.VideoEndoscopicImageStorageUid, "VVe", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VideoMicroscopicImageStorageUid, "VVm", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VideoPhotographicImageStorageUid, "VVp", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VisualAcuityMeasurementsStorageUid, "OPv", 4096),
            new S_DCMModalityTableMap(SopClass.VlEndoscopicImageStorageUid, "VLe", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VlMicroscopicImageStorageUid, "VLm", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VlPhotographicImageStorageUid, "VLp", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VlSlideCoordinatesMicroscopicImageStorageUid, "VLs", 768 * 576 * 3),
            new S_DCMModalityTableMap(SopClass.VlWholeSlideMicroscopyImageStorageUid, "VLw", 10000 * 10000 * 3),
            new S_DCMModalityTableMap(SopClass.XaXrfGrayscaleSoftcopyPresentationStateStorageUid, "PSx", 4096),
            new S_DCMModalityTableMap(SopClass.XRay3dAngiographicImageStorageUid, "XA3", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.XRay3dCraniofacialImageStorageUid, "XC3", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.XRayAngiographicImageStorageUid, "XA", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.XRayRadiationDoseSrStorageUid, "SRd", 4096),
            new S_DCMModalityTableMap(SopClass.XRayRadiofluoroscopicImageStorageUid, "RF", 256 * 512 * 512),
            new S_DCMModalityTableMap(SopClass.HardcopyColorImageStorageSopClassRetiredUid, "HC", 4096),
            new S_DCMModalityTableMap(SopClass.HardcopyGrayscaleImageStorageSopClassRetiredUid, "HG", 4096),
            new S_DCMModalityTableMap(SopClass.NuclearMedicineImageStorageRetiredUid, "NMr", 64 * 64 * 2),
            new S_DCMModalityTableMap(SopClass.StandaloneCurveStorageRetiredUid, "CV", 4096),
            new S_DCMModalityTableMap(SopClass.StandaloneModalityLutStorageRetiredUid, "ML", 4096 * 2),
            new S_DCMModalityTableMap(SopClass.StandaloneOverlayStorageRetiredUid, "OV", 512 * 512),
            new S_DCMModalityTableMap(SopClass.StandalonePetCurveStorageRetiredUid, "PC", 4096),
            new S_DCMModalityTableMap(SopClass.StandaloneVoiLutStorageRetiredUid, "VO", 4096 * 2),
            new S_DCMModalityTableMap(SopClass.StoredPrintStorageSopClassRetiredUid, "SP", 4096),
            new S_DCMModalityTableMap(SopClass.UltrasoundImageStorageRetiredUid, "USr", 512 * 512),
            new S_DCMModalityTableMap(SopClass.UltrasoundMultiFrameImageStorageRetiredUid, "USf", 512 * 512),
            new S_DCMModalityTableMap(SopClass.XRayAngiographicBiPlaneImageStorageRetiredUid, "XB", 4096),
            new S_DCMModalityTableMap(SopClass.RtBeamsDeliveryInstructionStorageTrialRetiredUid, "RBd", 4096),
            new S_DCMModalityTableMap(SopClass.AudioSrStorageTrialRetiredUid, "SRw", 4096),
            new S_DCMModalityTableMap(SopClass.ComprehensiveSrStorageTrialRetiredUid, "SRx", 4096),
            new S_DCMModalityTableMap(SopClass.DetailSrStorageTrialRetiredUid, "SRy", 4096),
            new S_DCMModalityTableMap(SopClass.TextSrStorageTrialRetiredUid, "SRz", 4096),
            new S_DCMModalityTableMap(SopClass.WaveformStorageTrialRetiredUid, "WVd", 4096),
        };

        public class S_UIDNameMap
        {
            public string UID { get; set; }
            public string Name { get; set; }

            public S_UIDNameMap(string uID, string name)
            {
                UID = uID;
                Name = name;
            }

            public static string dcmFindNameOfUID(string uid)
            {
                if (uid == null)
                {
                    return null;
                }
                for (int i = 0; i < UIDNameMap.Length; i++)
                {
                    if (UIDNameMap[i].UID != null)
                    {
                        if (string.Compare(UIDNameMap[i].UID, uid) == 0)
                        {
                            return UIDNameMap[i].Name;
                        }
                    }
                }
                return null;
            }
        };

        static S_UIDNameMap[] UIDNameMap = 
        {
            new S_UIDNameMap(DicomUids.ImplicitVRLittleEndian.UID, "LittleEndianImplicit"),
            new S_UIDNameMap(DicomUids.ExplicitVRLittleEndian.UID, "LittleEndianExplicit"),
            new S_UIDNameMap(DicomUids.ExplicitVRBigEndian.UID, "BigEndianExplicit"),
            new S_UIDNameMap(DicomUids.JPEGProcess1.UID, "JPEGBaseline"),
            new S_UIDNameMap(DicomUids.JPEGProcess2_4.UID, "JPEGExtended:Process2+4"),
            new S_UIDNameMap(DicomUids.JPEGProcess3_5Retired.UID, "JPEGExtended:Process3+5"),
            new S_UIDNameMap(DicomUids.JPEGProcess6_8Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process6+8"),
            new S_UIDNameMap(DicomUids.JPEGProcess7_9Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process7+9"),
            new S_UIDNameMap(DicomUids.JPEGProcess10_12Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process10+12"),
            new S_UIDNameMap(DicomUids.JPEGProcess11_13Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process11+13"),
            new S_UIDNameMap(DicomUids.JPEGProcess14.UID, "JPEGSpectralSelection:Non-hierarchical:Process14"),
            new S_UIDNameMap(DicomUids.JPEGProcess15Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process15"),
            new S_UIDNameMap(DicomUids.JPEGProcess16_18Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process16+18"),
            new S_UIDNameMap(DicomUids.JPEGProcess17_19Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process17+19"),
            new S_UIDNameMap(DicomUids.JPEGProcess20_22Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process20+22"),
            new S_UIDNameMap(DicomUids.JPEGProcess21_23Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process21+23"),
            new S_UIDNameMap(DicomUids.JPEGProcess24_26Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process24+26"),
            new S_UIDNameMap(DicomUids.JPEGProcess25_27Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process25+27"),
            new S_UIDNameMap(DicomUids.JPEGProcess28Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process28"),
            new S_UIDNameMap(DicomUids.JPEGProcess29Retired.UID, "JPEGSpectralSelection:Non-hierarchical:Process29"),
            new S_UIDNameMap(DicomUids.JPEGProcess14SV1.UID, "JPEGLossless:Non-hierarchical-1stOrderPrediction"),
            new S_UIDNameMap(DicomUids.JPEGLSLossless.UID, "JPEGLSLossless"),
            new S_UIDNameMap(DicomUids.JPEGLSNearLossless.UID, "JPEGLSLossy"),
            new S_UIDNameMap(DicomUids.RLELossless.UID, "RLELossless"),
            new S_UIDNameMap(DicomUids.DeflatedExplicitVRLittleEndian.UID, "DeflatedLittleEndianExplicit"),
            new S_UIDNameMap(DicomUids.JPEG2000Lossless.UID, "JPEG2000LosslessOnly"),
            new S_UIDNameMap(DicomUids.JPEG2000Lossy.UID, "JPEG2000"),
            new S_UIDNameMap(DicomUids.MPEG2.UID, "MPEG2MainProfile@MainLevel"),
            new S_UIDNameMap(DicomUids.AmbulatoryECGWaveformStorage.UID, "AmbulatoryECGWaveformStorage"),
            new S_UIDNameMap(DicomUids.BasicTextSR.UID, "BasicTextSRStorage"),
            new S_UIDNameMap(DicomUids.BasicVoiceAudioWaveformStorage.UID, "BasicVoiceAudioWaveformStorage"),
            new S_UIDNameMap(DicomUids.BlendingSoftcopyPresentationStateStorage.UID, "BlendingSoftcopyPresentationStateStorage"),
            new S_UIDNameMap(DicomUids.CardiacElectrophysiologyWaveformStorage.UID, "CardiacElectrophysiologyWaveformStorage"),
            new S_UIDNameMap(DicomUids.ChestCADSR.UID, "ChestCADSRStorage"),
            new S_UIDNameMap(DicomUids.ColorSoftcopyPresentationStateStorage.UID, "ColorSoftcopyPresentationStateStorage"),
            new S_UIDNameMap(DicomUids.ComprehensiveSR.UID, "ComprehensiveSRStorage"),
            new S_UIDNameMap(DicomUids.ComputedRadiographyImageStorage.UID, "ComputedRadiographyImageStorage"),
            new S_UIDNameMap(DicomUids.CTImageStorage.UID, "CTImageStorage"),
            new S_UIDNameMap(DicomUids.DigitalIntraoralXRayImageStorageForPresentation.UID, "DigitalIntraOralXRayImageStorageForPresentation"),
            new S_UIDNameMap(DicomUids.DigitalIntraoralXRayImageStorageForProcessing.UID, "DigitalIntraOralXRayImageStorageForProcessing"),
            new S_UIDNameMap(DicomUids.DigitalMammographyXRayImageStorageForPresentation.UID, "DigitalMammographyXRayImageStorageForPresentation"),
            new S_UIDNameMap(DicomUids.DigitalMammographyXRayImageStorageForProcessing.UID, "DigitalMammographyXRayImageStorageForProcessing"),
            new S_UIDNameMap(DicomUids.DigitalXRayImageStorageForPresentation.UID, "DigitalXRayImageStorageForPresentation"),
            new S_UIDNameMap(DicomUids.DigitalXRayImageStorageForProcessing.UID, "DigitalXRayImageStorageForProcessing"),
            new S_UIDNameMap(DicomUids.EncapsulatedPDFStorage.UID, "EncapsulatedPDFStorage"),
            new S_UIDNameMap(DicomUids.EnhancedCTImageStorage.UID, "EnhancedCTImageStorage"),
            new S_UIDNameMap(DicomUids.EnhancedMRImageStorage.UID, "EnhancedMRImageStorage"),
            new S_UIDNameMap(DicomUids.EnhancedSR.UID, "EnhancedSRStorage"),
            new S_UIDNameMap(DicomUids.GeneralECGWaveformStorage.UID, "GeneralECGWaveformStorage"),
            new S_UIDNameMap(DicomUids.GrayscaleSoftcopyPresentationStateStorage.UID, "GrayscaleSoftcopyPresentationStateStorage"),
            new S_UIDNameMap(DicomUids.HangingProtocolStorage.UID, "HangingProtocolStorage"),
            new S_UIDNameMap(DicomUids.HemodynamicWaveformStorage.UID, "HemodynamicWaveformStorage"),
            new S_UIDNameMap(DicomUids.KeyObjectSelectionDocument.UID, "KeyObjectSelectionDocument"),
            new S_UIDNameMap(DicomUids.MammographyCADSR.UID, "MammographyCADSRStorage"),
            new S_UIDNameMap(DicomUids.MediaStorageDirectoryStorage.UID, "MediaStorageDirectoryStorage"),
            new S_UIDNameMap(DicomUids.MRImageStorage.UID, "MRImageStorage"),
            new S_UIDNameMap(DicomUids.MRSpectroscopyStorage.UID, "MRSpectroscopyStorage"),
            new S_UIDNameMap(DicomUids.MultiframeGrayscaleByteSecondaryCaptureImageStorage.UID, "MultiframeGrayscaleByteSecondaryCaptureImageStorage"),
            new S_UIDNameMap(DicomUids.MultiframeGrayscaleWordSecondaryCaptureImageStorage.UID, "MultiframeGrayscaleWordSecondaryCaptureImageStorage"),
            new S_UIDNameMap(DicomUids.MultiframeSingleBitSecondaryCaptureImageStorage.UID, "MultiframeSingleBitSecondaryCaptureImageStorage"),
            new S_UIDNameMap(DicomUids.MultiframeTrueColorSecondaryCaptureImageStorage.UID, "MultiframeTrueColorSecondaryCaptureImageStorage"),
            new S_UIDNameMap(DicomUids.NuclearMedicineImageStorage.UID, "NuclearMedicineImageStorage"),
            new S_UIDNameMap(DicomUids.OphthalmicPhotography16BitImageStorage.UID, "OphthalmicPhotography16BitImageStorage"),
            new S_UIDNameMap(DicomUids.OphthalmicPhotography8BitImageStorage.UID, "OphthalmicPhotography8BitImageStorage"),
            new S_UIDNameMap(DicomUids.PositronEmissionTomographyImageStorage.UID, "PositronEmissionTomographyImageStorage"),
            new S_UIDNameMap(DicomUids.ProcedureLogStorage.UID, "ProcedureLogStorage"),
            new S_UIDNameMap(DicomUids.PseudoColorSoftcopyPresentationStateStorage.UID, "PseudoColorSoftcopyPresentationStateStorage"),
            new S_UIDNameMap(DicomUids.RawDataStorage.UID, "RawDataStorage"),
            new S_UIDNameMap(DicomUids.RealWorldValueMappingStorage.UID, "RealWorldValueMappingStorage"),
            new S_UIDNameMap(DicomUids.RTBeamsTreatmentRecordStorage.UID, "RTBeamsTreatmentRecordStorage"),
            new S_UIDNameMap(DicomUids.RTBrachyTreatmentRecordStorage.UID, "RTBrachyTreatmentRecordStorage"),
            new S_UIDNameMap(DicomUids.RTDoseStorage.UID, "RTDoseStorage"),
            new S_UIDNameMap(DicomUids.RTImageStorage.UID, "RTImageStorage"),
            new S_UIDNameMap(DicomUids.RTIonBeamsTreatmentRecordStorage.UID, "RTIonBeamsTreatmentRecordStorage"),
            new S_UIDNameMap(DicomUids.RTIonPlanStorage.UID, "RTIonPlanStorage"),
            new S_UIDNameMap(DicomUids.RTPlanStorage.UID, "RTPlanStorage"),
            new S_UIDNameMap(DicomUids.RTStructureSetStorage.UID, "RTStructureSetStorage"),
            new S_UIDNameMap(DicomUids.RTTreatmentSummaryRecordStorage.UID, "RTTreatmentSummaryRecordStorage"),
            new S_UIDNameMap(DicomUids.SecondaryCaptureImageStorage.UID, "SecondaryCaptureImageStorage"),
            new S_UIDNameMap(DicomUids.SpatialFiducialsStorage.UID, "SpatialFiducialsStorage"),
            new S_UIDNameMap(DicomUids.SpatialRegistrationStorage.UID, "SpatialRegistrationStorage"),
            new S_UIDNameMap(DicomUids.StereometricRelationshipStorage.UID, "StereometricRelationshipStorage"),
            new S_UIDNameMap(DicomUids.TwelveLeadECGWaveformStorage.UID, "TwelveLeadECGWaveformStorage"),
            new S_UIDNameMap(DicomUids.UltrasoundImageStorage.UID, "UltrasoundImageStorage"),
            new S_UIDNameMap(DicomUids.UltrasoundMultiframeImageStorage.UID, "UltrasoundMultiframeImageStorage"),
            new S_UIDNameMap(DicomUids.VideoEndoscopicImageStorage.UID, "VideoEndoscopicImageStorage"),
            new S_UIDNameMap(DicomUids.VideoMicroscopicImageStorage.UID, "VideoMicroscopicImageStorage"),
            new S_UIDNameMap(DicomUids.VideoPhotographicImageStorage.UID, "VideoPhotographicImageStorage"),
            new S_UIDNameMap(DicomUids.VLEndoscopicImageStorage.UID, "VLEndoscopicImageStorage"),
            new S_UIDNameMap(DicomUids.VLMicroscopicImageStorage.UID, "VLMicroscopicImageStorage"),
            new S_UIDNameMap(DicomUids.VLPhotographicImageStorage.UID, "VLPhotographicImageStorage"),
            new S_UIDNameMap(DicomUids.VLSlideCoordinatesMicroscopicImageStorage.UID, "VLSlideCoordinatesMicroscopicImageStorage"),
            new S_UIDNameMap(DicomUids.XRayAngiographicImageStorage.UID, "XRayAngiographicImageStorage"),
            new S_UIDNameMap(DicomUids.XRayRadiationDoseSR.UID, "XRayRadiationDoseSRStorage"),
            new S_UIDNameMap(DicomUids.XRayRadiofluoroscopicImageStorage.UID, "XRayRadiofluoroscopicImageStorage"),
            new S_UIDNameMap(DicomUids.HardcopyColorImageStorage.UID, "RETIRED_HardcopyColorImageStorage"),
            new S_UIDNameMap(DicomUids.HardcopyGrayscaleImageStorage.UID, "RETIRED_HardcopyGrayscaleImageStorage"),
            new S_UIDNameMap(DicomUids.NuclearMedicineImageStorageRetired.UID, "RETIRED_NuclearMedicineImageStorage"),
            new S_UIDNameMap(DicomUids.StandaloneCurveStorage.UID, "RETIRED_StandaloneCurveStorage"),
            new S_UIDNameMap(DicomUids.StandaloneModalityLUTStorage.UID, "RETIRED_StandaloneModalityLUTStorage"),
            new S_UIDNameMap(DicomUids.StandaloneOverlayStorage.UID, "RETIRED_StandaloneOverlayStorage"),
            new S_UIDNameMap(DicomUids.StandalonePETCurveStorage.UID, "RETIRED_StandalonePETCurveStorage"),
            new S_UIDNameMap(DicomUids.StandaloneVOILUTStorage.UID, "RETIRED_StandaloneVOILUTStorage"),
            new S_UIDNameMap(DicomUids.StoredPrintStorage.UID, "RETIRED_StoredPrintStorage"),
            new S_UIDNameMap(DicomUids.UltrasoundImageStorageRetired.UID, "RETIRED_UltrasoundImageStorage"),
            new S_UIDNameMap(DicomUids.UltrasoundMultiframeImageStorageRetired.UID, "RETIRED_UltrasoundMultiframeImageStorage"),
            new S_UIDNameMap(DicomUids.VLImageStorageRetired.UID, "RETIRED_VLImageStorage"),
            new S_UIDNameMap(DicomUids.VLMultiframeImageStorageRetired.UID, "RETIRED_VLMultiframeImageStorage"),
            new S_UIDNameMap(DicomUids.XRayAngiographicBiPlaneImageStorageRetired.UID, "RETIRED_XRayAngiographicBiPlaneImageStorage"),
            new S_UIDNameMap(DicomUids.PatientRootQueryRetrieveInformationModelFIND.UID, "FINDPatientRootQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.StudyRootQueryRetrieveInformationModelFIND.UID, "FINDStudyRootQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.PatientRootQueryRetrieveInformationModelGET.UID, "GETPatientRootQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.StudyRootQueryRetrieveInformationModelGET.UID, "GETStudyRootQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.PatientRootQueryRetrieveInformationModelMOVE.UID, "MOVEPatientRootQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.StudyRootQueryRetrieveInformationModelMOVE.UID, "MOVEStudyRootQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.PatientStudyOnlyQueryRetrieveInformationModelFIND.UID, "RETIRED_FINDPatientStudyOnlyQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.PatientStudyOnlyQueryRetrieveInformationModelGET.UID, "RETIRED_GETPatientStudyOnlyQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.PatientStudyOnlyQueryRetrieveInformationModelMOVE.UID, "RETIRED_MOVEPatientStudyOnlyQueryRetrieveInformationModel"),
            new S_UIDNameMap(DicomUids.GeneralPurposeWorklistInformationModelFIND.UID, "FINDGeneralPurposeWorklistInformationModel"),
            new S_UIDNameMap(DicomUids.ModalityWorklistInformationModelFIND.UID, "FINDModalityWorklistInformationModel"),
            new S_UIDNameMap(DicomUids.GeneralPurposePerformedProcedureStepSOPClass.UID, "GeneralPurposePerformedProcedureStepSOPClass"),
            new S_UIDNameMap(DicomUids.GeneralPurposeScheduledProcedureStepSOPClass.UID, "GeneralPurposeScheduledProcedureStepSOPClass"),
            new S_UIDNameMap(DicomUids.GeneralPurposeWorklistManagementMetaSOPClass.UID, "GeneralPurposeWorklistManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.ModalityPerformedProcedureStepNotification.UID, "ModalityPerformedProcedureStepNotificationSOPClass"),
            new S_UIDNameMap(DicomUids.ModalityPerformedProcedureStepRetrieve.UID, "ModalityPerformedProcedureStepRetrieveSOPClass"),
            new S_UIDNameMap(DicomUids.ModalityPerformedProcedureStep.UID, "ModalityPerformedProcedureStepSOPClass"),
            new S_UIDNameMap(DicomUids.StorageCommitmentPullModel.UID, "RETIRED_StorageCommitmentPullModelSOPClass"),
            new S_UIDNameMap(DicomUids.StorageCommitmentPullModelSOPInstance.UID, "RETIRED_StorageCommitmentPullModelSOPInstance"),
            new S_UIDNameMap(DicomUids.StorageCommitmentPushModel.UID, "StorageCommitmentPushModelSOPClass"),
            new S_UIDNameMap(DicomUids.StorageCommitmentPushModelSOPInstance.UID, "StorageCommitmentPushModelSOPInstance"),
            new S_UIDNameMap(DicomUids.HangingProtocolInformationModelFIND.UID, "FINDHangingProtocolInformationModel"),
            new S_UIDNameMap(DicomUids.HangingProtocolInformationModelMOVE.UID, "MOVEHangingProtocolInformationModel"),
            new S_UIDNameMap(DicomUids.BreastImagingRelevantPatientInformationQuery.UID, "BreastImagingRelevantPatientInformationQuery"),
            new S_UIDNameMap(DicomUids.CardiacRelevantPatientInformationQuery.UID, "CardiacRelevantPatientInformationQuery"),
            new S_UIDNameMap(DicomUids.PatientInformationQuery.UID, "GeneralRelevantPatientInformationQuery"),
            new S_UIDNameMap(DicomUids.BasicAnnotationBox.UID, "BasicAnnotationBoxSOPClass"),
            new S_UIDNameMap(DicomUids.BasicColorImageBox.UID, "BasicColorImageBoxSOPClass"),
            new S_UIDNameMap(DicomUids.BasicColorPrintManagement.UID, "BasicColorPrintManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.BasicFilmBoxSOP.UID, "BasicFilmBoxSOPClass"),
            new S_UIDNameMap(DicomUids.BasicFilmSession.UID, "BasicFilmSessionSOPClass"),
            new S_UIDNameMap(DicomUids.BasicGrayscaleImageBox.UID, "BasicGrayscaleImageBoxSOPClass"),
            new S_UIDNameMap(DicomUids.BasicGrayscalePrintManagement.UID, "BasicGrayscalePrintManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.PresentationLUT.UID, "PresentationLUTSOPClass"),
            new S_UIDNameMap(DicomUids.PrintJob.UID, "PrintJobSOPClass"),
            new S_UIDNameMap(DicomUids.PrinterConfigurationRetrieval.UID, "PrinterConfigurationRetrievalSOPClass"),
            new S_UIDNameMap(DicomUids.PrinterConfigurationRetrievalSOPInstance.UID, "PrinterConfigurationRetrievalSOPInstance"),
            new S_UIDNameMap(DicomUids.Printer.UID, "PrinterSOPClass"),
            new S_UIDNameMap(DicomUids.PrinterSOPInstance.UID, "PrinterSOPInstance"),
            new S_UIDNameMap(DicomUids.BasicPrintImageOverlayBox.UID, "RETIRED_BasicPrintImageOverlayBoxSOPClass"),
            new S_UIDNameMap(DicomUids.ImageOverlayBox.UID, "RETIRED_ImageOverlayBoxSOPClass"),
            new S_UIDNameMap(DicomUids.PrintQueueManagement.UID, "RETIRED_PrintQueueManagementSOPClass"),
            new S_UIDNameMap(DicomUids.PrintQueueSOPInstance.UID, "RETIRED_PrintQueueSOPInstance"),
            new S_UIDNameMap(DicomUids.PullPrintRequest.UID, "RETIRED_PullPrintRequestSOPClass"),
            new S_UIDNameMap(DicomUids.PullStoredPrintManagement.UID, "RETIRED_PullStoredPrintManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.ReferencedColorPrintManagementRetired.UID, "RETIRED_ReferencedColorPrintManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.ReferencedGrayscalePrintManagementRetired.UID, "RETIRED_ReferencedGrayscalePrintManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.ReferencedImageBoxRetired.UID, "RETIRED_ReferencedImageBoxSOPClass"),
            new S_UIDNameMap(DicomUids.VOILUTBox.UID, "VOILUTBoxSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedInterpretationManagement.UID, "RETIRED_DetachedInterpretationManagementSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedPatientManagementMetaSOPClass.UID, "RETIRED_DetachedPatientManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedPatientManagement.UID, "RETIRED_DetachedPatientManagementSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedResultsManagementMetaSOPClass.UID, "RETIRED_DetachedResultsManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedResultsManagement.UID, "RETIRED_DetachedResultsManagementSOPClass"),            
            new S_UIDNameMap(DicomUids.DetachedStudyManagementMetaSOPClass.UID, "RETIRED_DetachedStudyManagementMetaSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedStudyManagement.UID, "RETIRED_DetachedStudyManagementSOPClass"),
            new S_UIDNameMap(DicomUids.DetachedVisitManagement.UID, "RETIRED_DetachedVisitManagementSOPClass"),
            new S_UIDNameMap(DicomUids.ProceduralEventLoggingSOPClass.UID, "ProceduralEventLoggingSOPClass"),
            new S_UIDNameMap(DicomUids.ProceduralEventLoggingSOPInstance.UID, "ProceduralEventLoggingSOPInstance"),
            new S_UIDNameMap(DicomUids.MediaCreationManagementSOPClass.UID, "MediaCreationManagementSOPClass"),
            new S_UIDNameMap(DicomUids.StorageServiceClass.UID, "StorageServiceClass"),
            new S_UIDNameMap(DicomUids.InstanceAvailabilityNotificationSOPClass.UID, "InstanceAvailabilityNotificationSOPClass"),
            new S_UIDNameMap(DicomUids.BasicStudyContentNotification.UID, "RETIRED_BasicStudyContentNotificationSOPClass"),
            new S_UIDNameMap(DicomUids.StudyComponentManagement.UID, "RETIRED_StudyComponentManagementSOPClass"),
            new S_UIDNameMap(DicomUids.Verification.UID, "VerificationSOPClass"),
            new S_UIDNameMap(DicomUids.DICOMControlledTerminologyCodingScheme.UID, "DICOMControlledTerminologyCodingScheme"),
            new S_UIDNameMap(DicomUids.UniversalCoordinatedTime.UID, "RETIRED_DetachedInterpretationManagementSOPClass"),
            new S_UIDNameMap(DicomUids.ICBM452T1FrameOfReference.UID, "ICBM452T1FrameOfReference"),
            new S_UIDNameMap(DicomUids.ICBMSingleSubjectMRIFrameOfReference.UID, "ICBMSingleSubjectMRIFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2AVG152PDFrameOfReference.UID, "SPM2AVG152PDFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2AVG152T1FrameOfReference.UID, "SPM2AVG152T1FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2AVG152T2FrameOfReference.UID, "SPM2AVG152T2FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2AVG305T1FrameOfReference.UID, "SPM2AVG305T1FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2BRAINMASKFrameOfReference.UID, "SPM2BRAINMASKFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2CSFFrameOfReference.UID, "SPM2CSFFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2EPIFrameOfReference.UID, "SPM2EPIFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2FILT1FrameOfReference.UID, "SPM2FILT1FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2GRAYFrameOfReference.UID, "SPM2GRAYFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2PDFrameOfReference.UID, "SPM2PDFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2PETFrameOfReference.UID, "SPM2PETFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2SINGLESUBJT1FrameOfReference.UID, "SPM2SINGLESUBJT1FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2SPECTFrameOfReference.UID, "SPM2SPECTFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2T1FrameOfReference.UID, "SPM2T1FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2T2FrameOfReference.UID, "SPM2T2FrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2TRANSMFrameOfReference.UID, "SPM2TRANSMFrameOfReference"),
            new S_UIDNameMap(DicomUids.SPM2WHITEFrameOfReference.UID, "SPM2WHITEFrameOfReference"),
            new S_UIDNameMap(DicomUids.TalairachBrainAtlasFrameOfReference.UID, "TalairachBrainAtlasFrameOfReference")
        };

        /// read digital signatures from dataset
        public static int RF_readDigitalSignatures = 1 << 0;

        /// accept unknown/missing relationship type
        public static int RF_acceptUnknownRelationshipType = 1 << 1;

        /// ignore relationship constraints for this document class
        public static int RF_ignoreRelationshipConstraints = 1 << 2;

        /// do not abort on content item errors (e.g. missing value type specific attributes)
        public static int RF_ignoreContentItemErrors = 1 << 3;

        /// do not abort when detecting an invalid content item, skip invalid sub-tree instead
        public static int RF_skipInvalidContentItems = 1 << 4;

        /// show the currently processed content item (e.g. "1.2.3")
        public static int RF_showCurrentlyProcessedItem = 1 << 5;

        /// external: never expand child nodes inline
        public static int HF_neverExpandChildrenInline = 1 << 0;

        /// external: always expand child nodes inline
        public static int HF_alwaysExpandChildrenInline = 1 << 1;

        /// external: render codes even if they appear inline
        public static int HF_renderInlineCodes = 1 << 2;

        /// external: render code details as a tooltip (not with HTML 3.2)
        public static int HF_useCodeDetailsTooltip = 1 << 3;

        /// external: render concept name codes (default: code meaning only)
        public static int HF_renderConceptNameCodes = 1 << 4;

        /// external: render the code of the numeric measurement unit
        public static int HF_renderNumericUnitCodes = 1 << 5;

        /// external: use code meaning for the numeric measurement unit (default: code value)
        public static int HF_useCodeMeaningAsUnit = 1 << 6;

        /// external: use patient information as document title (default: document type)
        public static int HF_renderPatientTitle = 1 << 7;

        /// external: render no general document information (header)
        public static int HF_renderNoDocumentHeader = 1 << 8;

        /// external: render dcmtk/dcmsr comment at the end of the document
        public static int HF_renderDcmtkFootnote = 1 << 9;

        /// external: render the full data of all content items
        public static int HF_renderFullData = 1 << 10;

        /// external: render section titles inline (default: separate paragraph)
        public static int HF_renderSectionTitlesInline = 1 << 11;

        /// external: copy Cascading Style Sheet (CSS) content to HTML file
        public static int HF_copyStyleSheetContent = 1 << 12;

        /// external: output compatible to HTML version 3.2 (default: 4.01)
        public static int HF_HTML32Compatibility = 1 << 13;

        /// external: output compatible to XHTML version 1.1 (default: HTML 4.01)
        public static int HF_XHTML11Compatibility = 1 << 14;

        /// external: add explicit reference to HTML document type (DTD)
        public static int HF_addDocumentTypeReference = 1 << 15;

        /// external: omit generator meta element referring to the DCMTK
        public static int HF_omitGeneratorMetaElement = 1 << 16;

        /// internal: render items separately (for container with SEPARATE flag)
        public static int HF_renderItemsSeparately = 1 << 17;

        /// internal: expand items inline when they are short and have no child nodes
        public static int HF_renderItemInline = 1 << 18;

        /// internal: content item is rendered fully inside the annex
        public static int HF_currentlyInsideAnnex = 1 << 19;

        /// internal: create footnote references
        public static int HF_createFootnoteReferences = 1 << 20;

        /// internal: convert non-ASCII characters (> #127) to &\#nnn;
        public static int HF_convertNonASCIICharacters = 1 << 21;

        /// shortcut: render all codes
        public static int HF_renderAllCodes = DSRTypes.HF_renderInlineCodes | DSRTypes.HF_renderConceptNameCodes | DSRTypes.HF_renderNumericUnitCodes;

        /// shortcut: filter all flags that are only used internally
        public static int HF_internalUseOnly = DSRTypes.HF_renderItemsSeparately | DSRTypes.HF_renderItemInline |
                                             DSRTypes.HF_currentlyInsideAnnex | DSRTypes.HF_createFootnoteReferences | DSRTypes.HF_convertNonASCIICharacters;

        /// write: write all tags even if their value is empty
        public static int XF_writeEmptyTags = 1 << 0;

        /// write: write template identification information (TID and mapping resource)
        public static int XF_writeTemplateIdentification = 1 << 1;

        /// write: always write item identifier "id", not only when item is referenced
        public static int XF_alwaysWriteItemIdentifier = 1 << 2;

        /// write: encode code value, coding scheme designator and coding scheme version as attribute instead of element text
        public static int XF_codeComponentsAsAttribute = 1 << 3;

        /// write: encode relationship type as attribute instead of element text
        public static int XF_relationshipTypeAsAttribute = 1 << 4;

        /// write: encode value type as attribute instead of element text
        public static int XF_valueTypeAsAttribute = 1 << 5;

        /// write: encode template identifier as attribute instead of element text
        public static int XF_templateIdentifierAsAttribute = 1 << 6;

        /// write: add DCMSR namespace declaration to the XML output
        public static int XF_useDcmsrNamespace = 1 << 7;

        /// write: add Schema reference to XML document
        public static int XF_addSchemaReference = 1 << 8;

        /// read: validate content of XML document against Schema
        public static int XF_validateSchema = 1 << 9;

        /// read/write: template identification element encloses content items
        public static int XF_templateElementEnclosesItems = 1 << 10;

        /// shortcut: combines all XF_xxxAsAttribute write flags (see above)
        public static int XF_encodeEverythingAsAttribute = DSRTypes.XF_codeComponentsAsAttribute | DSRTypes.XF_relationshipTypeAsAttribute |
                                                               DSRTypes.XF_valueTypeAsAttribute | DSRTypes.XF_templateIdentifierAsAttribute;

        /// print item position ("1.2.3") instead of line indentation
        public static int PF_printItemPosition = 1 << 0;

        /// shorten long item value (e.g. long texts)
        public static int PF_shortenLongItemValues = 1 << 1;

        /// print SOP instance UID of referenced objects
        public static int PF_printSOPInstanceUID = 1 << 2;

        /// print coding scheme designator/version and code value of concept names
        public static int PF_printConceptNameCodes = 1 << 3;

        /// print no general document information (header)
        public static int PF_printNoDocumentHeader = 1 << 4;

        /// print template identification (TID and mapping resource)
        public static int PF_printTemplateIdentification = 1 << 5;

        /// shortcut: print all codes
        public static int PF_printAllCodes = DSRTypes.PF_printConceptNameCodes;

        /// update the position string using the node ID
        public static int CM_updatePositionString = 1 << 0;

        /// update the node ID using the position string
        public static int CM_updateNodeID = 1 << 1;

        /// reset the reference target flag for all nodes
        public static int CM_resetReferenceTargetFlag = 1 << 2;

        // private coding scheme designator used for internal codes
        public static string OFFIS_CODING_SCHEME_DESIGNATOR = "99_OFFIS_DCMTK";

        ~DSRTypes()
        {

        }

        /** convert SR document type to SOP class UID
         ** @param  documentType  SR document type to be converted
         ** @return SOP class UID if successful, empty string otherwise (never NULL)
         */
        public static string documentTypeToSOPClassUID(E_DocumentType documentType)
        {
            foreach (var _mapData in DocumentTypeNameMap)
            {
                if (_mapData.Type != documentType)
                {
                    continue;
                }

                return _mapData.SOPClassUID;
            }

            return null;
        }

        /** convert SR document type to modality
         ** @param  documentType  SR document type to be converted
         ** @return modality if successful, empty string otherwise (never NULL)
         */
        public static string documentTypeToModality(E_DocumentType documentType)
        {
            foreach (var _mapData in DocumentTypeNameMap)
            {
                if (_mapData.Type != documentType)
                {
                    continue;
                }

                return _mapData.Modality;
            }

            return null;
        }

        /** convert SR document type to readable name.
         *  Such a readable name is better suited for printing/rendering.
         ** @param  documentType  SR document type to be converted
         ** @return readable name if successful, empty string otherwise (never NULL)
         */
        public static string documentTypeToReadableName(E_DocumentType documentType)
        {
            foreach (var _mapData in DocumentTypeNameMap)
            {
                if (_mapData.Type != documentType)
                {
                    continue;
                }

                return _mapData.ReadableName;
            }

            return null;
        }

        /** convert SR document type to document title.
         *  This document title is used for printing/rendering.
         ** @param  documentType   SR document type to be converted
         *  @param  documentTitle  reference to variable where the resulting string is stored
         ** @return document title if successful, empty string otherwise (never NULL)
         */
        public static string documentTypeToDocumentTitle(E_DocumentType documentType, ref string documentTitle)
        {
            // avoid doubling of term "Document" and/or "Report"
            documentTitle = documentTypeToReadableName(documentType);
            if (string.IsNullOrEmpty(documentTitle) == false &&
                (documentTitle.Contains("Document") == false) &&
                (documentTitle.Contains("Report") == false))
            {
                documentTitle += " Document";
            }

            return documentTitle;
        }

        /** check whether SR document type requires Enhanced General Equipment Module
         ** @param  documentType  SR document type to be checked
         ** @return true if Enhanced General Equipment Module is required, false otherwise
         */
        public static bool requiresEnhancedEquipmentModule(E_DocumentType documentType)
        {
            foreach (var _mapData in DocumentTypeNameMap)
            {
                if (_mapData.Type != documentType)
                {
                    continue;
                }

                return _mapData.EnhancedEquipmentModule;
            }

            return false;
        }

        /** convert relationship type to DICOM defined term
         ** @param  relationshipType  relationship type to be converted
         ** @return defined term if successful, empty string otherwise (never NULL)
         */
        public static string relationshipTypeToDefinedTerm(E_RelationshipType relationshipType)
        {
            foreach (var _mapData in RelationshipTypeNameMap)
            {
                if (_mapData.Type != relationshipType)
                {
                    continue;
                }

                return _mapData.DefinedTerm;
            }

            return null;
        }

        /** convert relationship type to readable name.
         *  Such a readable name is better suited for printing/rendering.
         ** @param  relationshipType  relationship type to be converted
         ** @return readable name if successful, empty string otherwise (never NULL)
         */
        public static string relationshipTypeToReadableName(E_RelationshipType relationshipType)
        {
            foreach (var _mapData in RelationshipTypeNameMap)
            {
                if (_mapData.Type != relationshipType)
                {
                    continue;
                }

                return _mapData.ReadableName;
            }

            return null;
        }

        /** convert value type to DICOM defined term
         ** @param  valueType  value type to be converted
         ** @return defined term if successful, empty string otherwise (never NULL)
         */
        public static string valueTypeToDefinedTerm(E_ValueType valueType)
        {
            foreach (var _mapData in ValueTypeNameMap)
            {
                if (_mapData.Type != valueType)
                {
                    continue;
                }

                return _mapData.DefinedTerm;
            }

            return null;
        }

        /** convert value type to XML tag name
         ** @param  valueType  value type to be converted
         ** @return XML tag name if successful, empty string otherwise (never NULL)
         */
        public static string valueTypeToXMLTagName(E_ValueType valueType)
        {
            foreach (var _mapData in ValueTypeNameMap)
            {
                if (_mapData.Type != valueType)
                {
                    continue;
                }

                return _mapData.XMLTagName;
            }

            return null;
        }

        /** convert value type to readable name.
         *  Such a readable name is better suited for printing/rendering.
         ** @param  valueType  value type to be converted
         ** @return readable name if successful, empty string otherwise (never NULL)
         */
        public static string valueTypeToReadableName(E_ValueType valueType)
        {
            foreach (var _mapData in ValueTypeNameMap)
            {
                if (_mapData.Type != valueType)
                {
                    continue;
                }

                return _mapData.ReadableName;
            }

            return null;
        }

        /** convert graphic type to DICOM enumerated value
         ** @param  graphicType  graphic type to be converted
         ** @return enumerated value if successful, empty string otherwise (never NULL)
         */
        public static string graphicTypeToEnumeratedValue(E_GraphicType graphicType)
        {
            foreach (var _mapData in GraphicTypeNameMap)
            {
                if (_mapData.Type != graphicType)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert graphic type to readable name.
         *  Such a readable name is better suited for printing/rendering.
         ** @param  graphicType  graphic type to be converted
         ** @return readable name if successful, empty string otherwise (never NULL)
         */
        public static string graphicTypeToReadableName(E_GraphicType graphicType)
        {
            foreach (var _mapData in GraphicTypeNameMap)
            {
                if (_mapData.Type != graphicType)
                {
                    continue;
                }

                return _mapData.ReadableName;
            }

            return null;
        }

        /** convert graphic type (3D) to DICOM enumerated value
         ** @param  graphicType  graphic type (3D) to be converted
         ** @return enumerated value if successful, empty string otherwise (never NULL)
         */
        public static string graphicType3DToEnumeratedValue(E_GraphicType3D graphicType3D)
        {
            foreach (var _mapData in GraphicType3DNameMap)
            {
                if (_mapData.Type != graphicType3D)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert graphic type (3D) to readable name.
         *  Such a readable name is better suited for printing/rendering.
         ** @param  graphicType  graphic type (3D) to be converted
         ** @return readable name if successful, empty string otherwise (never NULL)
         */
        public static string graphicType3DToReadableName(E_GraphicType3D graphicType3D)
        {
            foreach (var _mapData in GraphicType3DNameMap)
            {
                if (_mapData.Type != graphicType3D)
                {
                    continue;
                }

                return _mapData.ReadableName;
            }

            return null;
        }

        /** convert temporal range type to DICOM enumerated value
         ** @param  temporalRangeType  temporal range type to be converted
         ** @return enumerated value if successful, empty string otherwise (never NULL)
         */
        public static string temporalRangeTypeToEnumeratedValue(E_TemporalRangeType temporalRangeType)
        {
            foreach (var _mapData in TemporalRangeTypeNameMap)
            {
                if (_mapData.Type != temporalRangeType)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert temporal range type to readable name.
         *  Such a readable name is better suited for printing/rendering.
         ** @param  temporalRangeType  temporal range type to be converted
         ** @return readable name if successful, empty string otherwise (never NULL)
         */
        public static string temporalRangeTypeToReadableName(E_TemporalRangeType temporalRangeType)
        {
            foreach (var _mapData in TemporalRangeTypeNameMap)
            {
                if (_mapData.Type != temporalRangeType)
                {
                    continue;
                }

                return _mapData.ReadableName;
            }

            return null;
        }

        /** convert continuity of content flag to DICOM enumerated value
         ** @param  continuityOfContent  continuity of content flag to be converted
         ** @return enumerated value if successful, empty string otherwise (never NULL)
         */
        public static string continuityOfContentToEnumeratedValue(E_ContinuityOfContent continuityOfContent)
        {
            foreach (var _mapData in ContinuityOfContentNameMap)
            {
                if (_mapData.Type != continuityOfContent)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert preliminary flag to DICOM enumerated value
         ** @param  preliminaryFlag  preliminary flag to be converted
         ** @return enumerated value if successful, empty string otherwise (never NULL)
         */
        public static string preliminaryFlagToEnumeratedValue(E_PreliminaryFlag preliminaryFlag)
        {
            foreach (var _mapData in PreliminaryFlagNameMap)
            {
                if (_mapData.Type != preliminaryFlag)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert completion flag to DICOM enumerated value
        ** @param  completionFlag  completion flag to be converted
        ** @return enumerated value if successful, empty string otherwise (never NULL)
        */
        public static string completionFlagToEnumeratedValue(E_CompletionFlag completionFlag)
        {
            foreach (var _mapData in CompletionFlagNameMap)
            {
                if (_mapData.Type != completionFlag)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert verification flag to DICOM enumerated value
         ** @param  verificationFlag  verification flag to be converted
         ** @return enumerated value if successful, empty string otherwise (never NULL)
         */
        public static string verificationFlagToEnumeratedValue(E_VerificationFlag verificationFlag)
        {
            foreach (var _mapData in VerificationFlagNameMap)
            {
                if (_mapData.Type != verificationFlag)
                {
                    continue;
                }

                return _mapData.EnumeratedValue;
            }

            return null;
        }

        /** convert character set to DICOM defined term
         ** @param  characterSet  character set to be converted
         ** @return defined term if successful, empty string otherwise (never NULL)
         */
        public static string characterSetToDefinedTerm(E_CharacterSet characterSet)
        {
            foreach (var _mapData in CharacterSetNameMap)
            {
                if (_mapData.Type != characterSet)
                {
                    continue;
                }

                return _mapData.DefinedTerm;
            }

            return null;
        }

        /** convert character set to HTML name.
         *  This HTML (IANA) name is used to specify the character set in an HTML document.
         ** @param  characterSet  character set to be converted
         ** @return HTML name if successful, empty string or "?" otherwise (never NULL)
         */
        public static string characterSetToHTMLName(E_CharacterSet characterSet)
        {
            foreach (var _mapData in CharacterSetNameMap)
            {
                if (_mapData.Type != characterSet)
                {
                    continue;
                }

                return _mapData.HTMLName;
            }

            return null;
        }

        /** convert character set to XML name.
         *  This XML name is used to specify the character set in an XML document.
         ** @param  characterSet  character set to be converted
         ** @return XML name if successful, empty string or "?" otherwise (never NULL)
         */
        public static string characterSetToXMLName(E_CharacterSet characterSet)
        {
            foreach (var _mapData in CharacterSetNameMap)
            {
                if (_mapData.Type != characterSet)
                {
                    continue;
                }

                return _mapData.XMLName;
            }

            return null;
        }

        /** convert SOP class UID to SR document type
         ** @param  sopClassUID  SOP class UID to be converted
         ** @return SR document type if successful, DT_invalid otherwise
         */
        public static E_DocumentType sopClassUIDToDocumentType(string sopClassUID)
        {
            foreach (var _mapData in DocumentTypeNameMap)
            {
                if (_mapData.SOPClassUID != sopClassUID)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_DocumentType.DT_invalid;
        }

        /** convert DICOM defined term to relationship type
         ** @param  definedTerm  defined term to be converted
         ** @return relationship type if successful, RT_invalid otherwise
         */
        public static E_RelationshipType definedTermToRelationshipType(string definedTerm)
        {
            foreach (var _mapData in RelationshipTypeNameMap)
            {
                if (_mapData.DefinedTerm != definedTerm)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_RelationshipType.RT_invalid;
        }

        /** convert DICOM defined term to value type
         ** @param  definedTerm  defined term to be converted
         ** @return value type if successful, VT_invalid otherwise
         */
        public static E_ValueType definedTermToValueType(string definedTerm)
        {
            foreach (var _mapData in ValueTypeNameMap)
            {
                if (_mapData.DefinedTerm != definedTerm)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_ValueType.VT_invalid;
        }

        /** convert XML tag name to value type
        ** @param  xmlTagName  XML tag name to be converted
        ** @return value type if successful, VT_invalid otherwise
        */
        public static E_ValueType xmlTagNameToValueType(string xmlTagName)
        {
            foreach (var _mapData in ValueTypeNameMap)
            {
                if (_mapData.XMLTagName != xmlTagName)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_ValueType.VT_invalid;
        }

        /** convert DICOM enumerated value to graphic type
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return graphic type if successful, GT_invalid otherwise
         */
        public static E_GraphicType enumeratedValueToGraphicType(string enumeratedValue)
        {
            foreach (var _mapData in GraphicTypeNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_GraphicType.GT_unknown;
        }

        /** convert DICOM enumerated value to graphic type (3D)
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return graphic type if successful, GT3_invalid otherwise
         */
        public static E_GraphicType3D enumeratedValueToGraphicType3D(string enumeratedValue)
        {
            foreach (var _mapData in GraphicType3DNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_GraphicType3D.GT3_invalid;
        }

        /** convert DICOM enumerated value to temporal range type
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return temporal range type if successful, TRT_invalid otherwise
         */
        public static E_TemporalRangeType enumeratedValueToTemporalRangeType(string enumeratedValue)
        {
            foreach (var _mapData in TemporalRangeTypeNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_TemporalRangeType.TRT_invalid;
        }

        /** convert DICOM enumerated value to continuity of content flag
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return continuity of content flag type if successful, COC_invalid otherwise
         */
        public static E_ContinuityOfContent enumeratedValueToContinuityOfContent(string enumeratedValue)
        {
            foreach (var _mapData in ContinuityOfContentNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_ContinuityOfContent.COC_invalid;
        }

        /** convert DICOM enumerated value to preliminary flag
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return preliminary flag type if successful, CF_invalid otherwise
         */
        public static E_PreliminaryFlag enumeratedValueToPreliminaryFlag(string enumeratedValue)
        {
            foreach (var _mapData in PreliminaryFlagNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_PreliminaryFlag.PF_invalid;
        }

        /** convert DICOM enumerated value to completion flag
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return completion flag type if successful, CF_invalid otherwise
         */
        public static E_CompletionFlag enumeratedValueToCompletionFlag(string enumeratedValue)
        {
            foreach (var _mapData in CompletionFlagNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_CompletionFlag.CF_Complete;
        }

        /** convert DICOM enumerated value to verification flag
         ** @param  enumeratedValue  enumerated value to be converted
         ** @return verification flag type if successful, VF_invalid otherwise
         */
        public static E_VerificationFlag enumeratedValueToVerificationFlag(string enumeratedValue)
        {
            foreach (var _mapData in VerificationFlagNameMap)
            {
                if (_mapData.EnumeratedValue != enumeratedValue)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_VerificationFlag.VF_invalid;
        }

        /** convert DICOM defined term to character set
         ** @param  definedTerm  defined term to be converted
         ** @return character set if successful, CS_invalid otherwise
         */
        public static E_CharacterSet definedTermToCharacterSet(string definedTerm)
        {
            foreach (var _mapData in CharacterSetNameMap)
            {
                if (_mapData.DefinedTerm != definedTerm)
                {
                    continue;
                }

                return _mapData.Type;
            }

            return E_CharacterSet.CS_invalid;
        }

        // --- misc helper functions ---

        /** check whether specified SR document type is supported by this library.
         *  Currently all three general SOP classes, the Key Object Selection Document, the
         *  Mammography and Chest CAD SR class as defined in the DICOM 2003 standard are supported.
         ** @param  documentType  SR document type to be checked
         ** @return status, true if SR document type is supported, false otherwise
         */
        public static bool isDocumentTypeSupported(E_DocumentType documentType)
        {
            return (documentType != E_DocumentType.DT_invalid);
        }

        /** get current date in DICOM 'DA' format. (YYYYMMDD)
         ** @param  dateString  string used to store the current date.
         *                      ('19000101' if current date could not be retrieved)
         ** @return resulting character string (see 'dateString')
         */
        public static string currentDate(string dateString)
        {
            return DSRUtils.getCurrentDate(dateString);
        }

        /** get current time in DICOM 'TM' format. (HHMMSS)
         *  The optional UTC notation (e.g. +0100) is currently not supported.
         ** @param  timeString  string used to store the current time
         *                      ('000000' if current time could not be retrieved)
         ** @return resulting character string (see 'timeString')
         */
        public static string currentTime(string timeString)
        {
            return DSRUtils.getCurrentTime(timeString);
        }

        /** get current date and time in DICOM 'DT' format. (YYYYMMDDHHMMSS)
         *  The optional UTC notation (e.g. +0100) as well as the optional fractional second
         *  part are currently not supported.
         ** @param  dateTimeString  string used to store the current date and time
         *                          ('19000101000000' if current date/time could not
         *                           be retrieved)
         ** @return resulting character string (see 'dateTimeString')
         */
        public static string currentDateTime(string dateTimeString)
        {
            return DSRUtils.getISOFormattedDateTime();
        }

        /** convert DICOM date string to readable format.
         *  The ISO format "YYYY-MM-DD" is used for the readable format.
         ** @param  dicomDate     date in DICOM DA format (YYYYMMDD)
         *  @param  readableDate  reference to variable where the resulting string is stored
         ** @return reference to resulting string (might be empty)
         */
        public static string dicomToReadableDate(string dicomDate, string readableDate)
        {
            DateTime dateTime = new DateTime();
            DateParser.Parse(dicomDate, out dateTime);
            return DSRUtils.getISOFormattedDate(dateTime, true);
        }

        /** convert DICOM time string to readable format.
         *  The ISO format "HH:MM" or "HH:MM:SS" (if seconds are available) is used for the
         *  readable format.
         ** @param  dicomTime     time in DICOM TM format (HHMM or HHMMSS...)
         *  @param  readableTime  reference to variable where the resulting string is stored
         ** @return reference to resulting string (might be empty)
         */
        public static string dicomToReadableTime(string dicomTime, string readableTime)
        {
            DateTime dateTime = new DateTime();
            TimeParser.Parse(dicomTime, out dateTime);
            return DSRUtils.getISOFormattedTime(dateTime, true);
        }

        /** convert DICOM date time string to readable format.
         *  The format "YYYY-MM-DD, HH:MM" or "YYYY-MM-DD, HH:MM:SS" is used for the readable format.
         ** @param  dicomDateTime     time in DICOM DT format (YYYYMMDDHHMMSS...). Possible suffixes
         *                            (fractional second or UTC notation) are currently ignored.
         *  @param  readableDateTime  reference to variable where the resulting string is stored
         ** @return reference to resulting string (might be empty)
         */
        public static string dicomToReadableDateTime(string dicomDateTime, string readableDateTime)
        {
            DateTime dateTime = new DateTime();
            DateTimeParser.Parse(dicomDateTime, out dateTime);
            return DSRUtils.getISOFormattedDateTime(dateTime, true);
        }

        /** convert DICOM person name to readable format.
         *  The format "<prefix> <first_name> <middle_name> <last_name>, <suffix>" is used for the
         *  readable format.
         *  Please note that only the first component group (characters before the first '=') of
         *  the DICOM person name is used - see DcmPersonName::getNameComponents() for details.
         ** @param  dicomPersonName     person name in DICOM PN format (ln^fn^mn^p^s)
         *  @param  readablePersonName  reference to variable where the resulting string is stored
         ** @return reference to resulting string (might be empty)
         */
        public static string dicomToReadablePersonName(string dicomPersonName, string readablePersonName)
        {
            try
            {
                PersonName personName = new PersonName(dicomPersonName);
                if (personName != null)
                {
                    DSRUtils.getFormattedNameFromComponents(personName.LastName, personName.FirstName, personName.MiddleName, personName.Title, personName.Suffix, ref readablePersonName);
                }
            }
            catch (Exception)
            {
            }
            return readablePersonName;
        }

        /** convert DICOM person name to XML format.
         *  The tags \<prefix\>, \<first\>, \<middle\>, \<last\> and \<suffix\> are used for the XML
         *  format of a person name.  The string is automatically converted to the markup notation
         *  (see convertToMarkupString()).  Two tags are separated by a newline.
         *  Please note that only the first component group (characters before the first '=') of
         *  the DICOM person name is used - see DcmPersonName::getNameComponents() for details.
         ** @param  dicomPersonName  person name in DICOM PN format (ln^fn^mn^p^s)
         *  @param  xmlPersonName    reference to variable where the resulting string is stored
         *  @param  writeEmptyValue  optional flag indicating whether an empty value should be written
         ** @return reference to resulting string (might be empty)
         */
        public static string dicomToXMLPersonName(string dicomPersonName, string xmlPersonName, bool writeEmptyValue = false)
        {
            //TODO: DSRTypes: dicomToXMLPersonName
            return string.Empty;
        }

        /** convert unsigned integer number to character string
         ** @param  number       unsigned integer number to be converted
         *  @param  stringValue  character string used to store the result
         ** @return pointer to the first character of the resulting string (may be NULL if 'string' was NULL)
         */
        public static string numberToString(int number, string stringValue)
        {
            if (stringValue == null)
            {
                return stringValue;
            }

            return number.ToString();
        }

        /** convert string to unsigned integer number
         ** @param  stringValue  character string to be converted
         ** @return resulting unsigned integer number if successful, 0 otherwise
         */
        public static int stringToNumber(string stringValue)
        {
            if (string.IsNullOrEmpty(stringValue))
            {
                return 0;
            }

            return int.Parse(stringValue);
        }

        /** convert character string to print string.
         *  This method is used to convert character strings for text "print" output.  Newline characters
         *  "\n" are replaced by "\\n", return characters "\r" by "\\r", etc.
         ** @param  sourceString  source string to be converted
         *  @param  printString   reference to character string where the result should be stored
         ** @return reference to resulting 'printString' (might be empty if 'sourceString' was empty)
         */
        public static string convertToPrintString(string sourceString, ref string printString)
        {
            /* start with empty string */
            printString = string.Empty;

            /* char ptr allows fastest access to the string */
            foreach(char _char in sourceString.ToCharArray())
            {
                /* newline: depends on OS */
                if (_char == '\n')
                {
                    printString += "\\n";
                }
                /*else if (_char == '\012')
                {
                    // line feed: LF
                    printString += "\\012";
                }*/
                else if (_char == '\r')
                {
                    printString += "\\r";
                    /* other character: just append */
                }
                else
                {
                    printString += _char;
                }
            }

            return printString;
        }

        /** convert character string to HTML mnenonic string.
         *  corresponding mnenonics (e.g. "&lt;" and "&amp;").  If flag 'HF_convertNonASCIICharacters'
         *  is set all characters > #127 are also converted (useful if only HTML 3.2 is supported which
         *  does not allow to specify the character set).
         ** @param  sourceString     source string to be converted
         *  @param  markupString     reference to character string where the result should be stored
         *  @param  flags            optional flags, checking HF_convertNonASCIICharacters,
                                     HF_HTML32Compatibility and HF_XHTML11Compatibility only
         *  @param  newlineAllowed   optional flag indicating whether newlines are allowed or not.
         *                           If they are allowed the text "<br>" is used, "&para;" otherwise.
         *                           The following combinations are accepted: LF, CR, LF CR, CF LF.
         ** @return reference to resulting 'markupString' (might be empty if 'sourceString' was empty)
         */
        public static string convertToHTMLString(string sourceString, string markupString, int flags = 0, bool newlineAllowed = false)
        {
            bool convertNonASCII = (flags & HF_convertNonASCIICharacters) > 0;
            E_MarkupMode markupMode = ((flags & HF_XHTML11Compatibility) > 0) ? E_MarkupMode.MM_XHTML : ((flags & HF_HTML32Compatibility) > 0) ? E_MarkupMode.MM_HTML32 : E_MarkupMode.MM_HTML;
            /* call the real function */
            return DSRUtils.convertToMarkupString(sourceString, markupString, convertNonASCII, markupMode, newlineAllowed);
        }

        /** convert character string to XML mnenonic string.
         *  corresponding mnenonics (e.g. "&lt;" and "&amp;").
         ** @param  sourceString  source string to be converted
         *  @param  markupString  reference to character string where the result should be stored
         ** @return reference to resulting 'markupString' (might be empty if 'sourceString' was empty)
         */
        public static string convertToXMLString(string sourceString, string markupString)
        {
            //TODO: DSRTypes: convertToXMLString
            return string.Empty;
        }

        /** check string for valid UID format.
         *  The string should be non-empty and consist only of integer numbers separated by "." where
         *  the first and the last character of the string are always figures (0..9). Example: 1 or 1.2.3.
         *  Please note that this test is not as strict as specified for value representation UI in the
         *  DICOM standard (e.g. regarding even length padding or leading '0' for the numbers).
         ** @param  stringValue  character string to be checked
         ** @result true if 'string' conforms to UID format, false otherwise
         */
        public static bool checkForValidUIDFormat(string stringValue)
        {
            bool result = false;
            /* empty strings are invalid */
            if (!string.IsNullOrEmpty(stringValue))
            {
                char[] stringData = stringValue.ToCharArray();
                int index = 0;

                /* check for leading number */
                while(char.IsDigit(stringData[index]))
                {
                    result = true;
                    index++;
                    if (index >= stringData.Length)
                    {
                        break;
                    }
                }

                if (index >= stringData.Length)
                {
                    return result;
                }

                /* check for separator */
                while ((stringData[index] == '.') && result)
                {
                    /* trailing '.' is invalid */
                    result = false;
                    index++;

                    /* check for trailing number */
                    while (char.IsDigit(stringData[index]))
                    {
                        result = true;
                        index++;
                        if (index >= stringData.Length)
                        {
                            break;
                        }
                    }

                    if (index >= stringData.Length)
                    {
                        break;
                    }
                }

                /* all characters checked? */
                if (index != stringData.Length)
                {
                    result = false;
                }
            }

            return result;
        }

        /** create specified SR IOD content relationship contraint checker object.
         *  Please note that the created object has to be deleted by the caller.
         ** @param  documentType  associated SR document type for which the checker object is created
         ** @return pointer to new IOD checker object if successful, NULL if document type is not supported
         */
        public static DSRIODConstraintChecker createIODConstraintChecker(E_DocumentType documentType)
        {
            DSRIODConstraintChecker checker = null;
            switch (documentType)
            {
                case E_DocumentType.DT_BasicTextSR:
                    checker = new DSRBasicTextSRConstraintChecker();
                    break;
                case E_DocumentType.DT_EnhancedSR:
                    checker = new DSREnhancedSRConstraintChecker();
                    break;
                case E_DocumentType.DT_ComprehensiveSR:
                    checker = new DSRComprehensiveSRConstraintChecker();
                    break;
                case E_DocumentType.DT_KeyObjectSelectionDocument:
                    checker = new DSRKeyObjectSelectionDocumentConstraintChecker();
                    break;
                case E_DocumentType.DT_MammographyCadSR:
                    checker = new DSRMammographyCadSRConstraintChecker();
                    break;
                case E_DocumentType.DT_ChestCadSR:
                    checker = new DSRChestCadSRConstraintChecker();
                    break;
                case E_DocumentType.DT_ColonCadSR:
                    checker = new DSRColonCadSRConstraintChecker();
                    break;
                case E_DocumentType.DT_ProcedureLog:
                    checker = new DSRProcedureLogConstraintChecker();
                    break;
                case E_DocumentType.DT_XRayRadiationDoseSR:
                    checker = new DSRXRayRadiationDoseSRConstraintChecker();
                    break;
                case E_DocumentType.DT_SpectaclePrescriptionReport:
                    checker = new DSRSpectaclePrescriptionReportConstraintChecker();
                    break;
                case E_DocumentType.DT_MacularGridThicknessAndVolumeReport:
                    checker = new DSRMacularGridThicknessAndVolumeReportConstraintChecker();
                    break;
                case E_DocumentType.DT_ImplantationPlanSRDocument:
                    checker = new DSRImplantationPlanSRDocumentConstraintChecker();
                    break;
                default:
                    break;
            }

            return checker;
        }

        /** create specified document tree node.
         *  This is a shortcut and the only location where document tree nodes are created.
         *  It facilitates the introduction of new relationship/value types and the maintenance.
         ** @param  relationshipType  relationship type of the node to be created
         *  @param  valueType         value type of the node to be created
         ** @return pointer to the new document tree nodeif successful, NULL otherwise
         */
        public static DSRDocumentTreeNode createDocumentTreeNode(E_RelationshipType relationshipType, E_ValueType valueType)
        {
            DSRDocumentTreeNode node = null;
            switch (valueType)
            {
                case E_ValueType.VT_Text:
                    node = new DSRTextTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Code:
                    node = new DSRCodeTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Num:
                    node = new DSRNumTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_DateTime:
                    node = new DSRDateTimeTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Date:
                    node = new DSRDateTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Time:
                    node = new DSRTimeTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_UIDRef:
                    node = new DSRUIDRefTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_PName:
                    node = new DSRPNameTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_SCoord:
                    node = new DSRSCoordTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_SCoord3D:
                    node = new DSRSCoord3DTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_TCoord:
                    node = new DSRTCoordTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Composite:
                    node = new DSRCompositeTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Image:
                    node = new DSRImageTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Waveform:
                    node = new DSRWaveformTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_Container:
                    node = new DSRContainerTreeNode(relationshipType);
                    break;
                case E_ValueType.VT_byReference:
                    node = new DSRByReferenceTreeNode(relationshipType);
                    break;
                default:
                    break;
            }

            return node;
        }

        // --- DICOM data structure access functions ---

        /** add given element to the dataset.
         *  The element is only added if 'result' is EC_Normal and the 'delem' pointer is not NULL.
         ** @param  result      reference to status variable (checked before adding and updated afterwards!)
         *  @param  dataset     reference to DICOM dataset to which the element should be added
         *  @param  delem       pointer to DICOM element which should be added. deleted if not inserted.
         *  @param  vm          value multiplicity (according to the data dictionary) to be checked for.
         *                      (valid value: "1", "1-2", "1-3", "1-8", "1-99", "1-n", "2", "2-n", "2-2n",
         *                                    "3", "3-n", "3-3n", "4", "6", "9", "16", "32"),
         *                      interpreted as cardinality (number of items) for sequence attributes
         *  @param  type        value type (valid value: "1", "2" or something else which is not checked)
         *  @param  moduleName  optional module name to be printed (default: "SR document" if NULL)
         ** @return current value of 'result', EC_Normal if successful, an error code otherwise
         */
        public static E_Condition addElementToDataset(DicomAttributeCollection dataset,
                                               DicomAttribute delem,
                                               string vm,
                                               string type,
                                               string moduleName = null)
        {
            E_Condition result = E_Condition.EC_Normal;
            if (delem != null)
            {
                if (result.good())
                {
                    if ((type == "2") || delem.IsEmpty == false)
                    {
                        /* insert non-empty element or empty "type 2" element */
                        dataset[delem.Tag.TagValue] = delem;
                        checkElementValue(delem, vm, type, result, moduleName);
                    }
                    else if (type == "1")
                    {
                        /* empty element value not allowed for "type 1" */
                        result = E_Condition.EC_IllegalParameter;
                        checkElementValue(delem, vm, type, result, moduleName);
                    }
                }
            }
            else
            {
                result = E_Condition.EC_MemoryExhausted;
            }
            return result;
        }

        /** remove given attribute from the sequence.
        *  All occurrences of the attribute in all items of the sequence are removed.
        ** @param  sequence  reference to DICOM sequence from which the attribute should be removed
        *  @param  tagKey    DICOM tag specifying the attribute which should be removed
        */
        public static void removeAttributeFromSequence(DicomAttribute sequence, DicomAttribute tagKey)
        {
            //TODO: DSRTypes: removeAttributeFromSequence
        }

        /** get element from dataset
         ** @param  dataset  reference to DICOM dataset from which the element should be retrieved.
         *                   (Would be 'const' if the methods from 'dcmdata' would also be 'const'.)
         *  @param  delem    reference to DICOM element which should be retrieved.  The return value
         *                   is also stored in this parameter.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public static E_Condition getElementFromDataset(DicomAttributeCollection dataset, ref DicomAttribute delem)
        {
            if (dataset == null || delem == null)
            {
                return E_Condition.EC_IllegalParameter;
            }

            DicomAttribute dcmAttribute;
            dataset.TryGetAttribute(delem.Tag, out dcmAttribute);
            if (dcmAttribute == null)
            {
                return E_Condition.EC_InvalidTag;
            }

            delem = dcmAttribute;

            return E_Condition.EC_Normal;
        }

        /** get string value from element
         ** @param  delem  DICOM element from which the string value should be retrieved
         ** @return pointer to character string if successful, NULL otherwise
         */
        public static string getStringValueFromElement(DicomAttribute delem)
        {
            if (delem == null)
            {
                return string.Empty;
            }

            return delem.ToString();
        }

        /** get string value from element
         ** @param  delem        reference to DICOM element from which the string value should be retrieved
         *  @param  stringValue  reference to character string where the result should be stored
         ** @return reference character string if successful, empty string otherwise
         */
        public static string getStringValueFromElement(DicomAttribute delem, ref string stringValue)
        {
            if (delem == null)
            {
                return string.Empty;
            }

            stringValue = delem.ToString();

            return stringValue;
        }

        /** get string value from element and convert to "print" format
         ** @param  delem        reference to DICOM element from which the string value should be retrieved
         *  @param  stringValue  reference to character string where the result should be stored
         ** @return reference character string if successful, empty string otherwise
         */
        public static string getPrintStringFromElement(DicomAttribute delem, ref string stringValue)
        {
            string tempString = string.Empty;
            return convertToPrintString(getStringValueFromElement(delem, ref tempString), ref stringValue);
        }

        /** get string value from element and convert to HTML/XML
         ** @param  delem            reference to DICOM element from which the string value should be retrieved
         *  @param  stringValue      reference to character string where the result should be stored
         *  @param  convertNonASCII  convert non-ASCII characters (> #127) to numeric value (&\#nnn;) if OFTrue
         ** @return reference character string if successful, empty string otherwise
         */
        public static string getMarkupStringFromElement(DicomAttribute delem, string stringValue, bool convertNonASCII = false)
        {
            //TODO: DSRTypes: getMarkupStringFromElement
            return string.Empty;
        }

        /** get string value from dataset
         ** @param  dataset      reference to DICOM dataset from which the string should be retrieved.
         *                       (Would be 'const' if the methods from 'dcmdata' would also be 'const'.)
         *  @param  tagKey       DICOM tag specifying the attribute from which the string should be retrieved
         *  @param  stringValue  reference to character string in which the result should be stored.
         *                       (This parameter is automatically cleared if the tag could not be found.)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public static bool getStringValueFromDataset(DicomAttributeCollection dataset, DicomAttribute tagKey, ref string stringValue)
        {
            getElementFromDataset(dataset, ref tagKey);
            if (tagKey != null)
            {
                stringValue = tagKey.ToString();

                return true;
            }

            return false;
        }

        /** put string value to dataset
         ** @param  dataset      reference to DICOM dataset to which the string should be put.
         *  @param  tag          DICOM tag specifying the attribute to which the string should be put
         *  @param  stringValue  character string specifying the value to be set
         *  @param  allowEmpty   allow empty element to be inserted if OFTrue.
         *                       Do not insert empty element otherwise.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public static E_Condition putStringValueToDataset(DicomAttributeCollection dataset, DicomAttribute tag, string stringValue, bool allowEmpty = true)
        {
            E_Condition result = E_Condition.EC_Normal;
            if (dataset == null || tag == null)
            {
                return E_Condition.EC_IllegalParameter;
            }

            if (allowEmpty || !string.IsNullOrEmpty(stringValue))
            {
                dataset[tag.Tag].SetStringValue(stringValue);
            }

            return result;
        }

        /** check element value for correct value multipicity and type.
         ** @param  delem       DICOM element to be checked
         *  @param  vm          value multiplicity (according to the data dictionary) to be checked for.
         *                      (valid value: "1", "1-2", "1-3", "1-8", "1-99", "1-n", "2", "2-n", "2-2n",
         *                                    "3", "3-n", "3-3n", "4", "9", "6", "16", "32"),
         *                      interpreted as cardinality (number of items) for sequence attributes
         *  @param  type        value type (valid value: "1", "1C", "2", something else)
         *  @param  searchCond  optional flag indicating the status of a previous 'search' function call
         *  @param  moduleName  optional module name to be printed (default: "SR document" if NULL)
         ** @return OFTrue if element value is correct, OFFalse otherwise
         */
        public static bool checkElementValue(DicomAttribute delem, string vm, string type, E_Condition searchCond = E_Condition.EC_Normal, string moduleName = null)
        {
            if (delem == null)
            {
                return false;
            }

            bool result = true;
            if (((type == "1") || (type == "2")) && searchCond.bad())
            {
                result = false;
            }
            else if (delem.IsEmpty)
            {
                if (((type == "1") || (type == "1C")) && searchCond.good())
                {
                    result = false;
                }
            }
            else
            {
                if (delem.Count == 0)
                {
                    result = false;
                }
            }

            return result;
        }

        /** get element from dataset and check it for correct value multipicity and type.
         ** @param  dataset     reference to DICOM dataset from which the element should be retrieved.
         *                      (Would be 'const' if the methods from 'dcmdata' would also be 'const'.)
         *  @param  delem       DICOM element used to store the value
         *  @param  vm          value multiplicity (according to the data dictionary) to be checked for.
         *                      (valid value: "1", "1-2", "1-3", "1-8", "1-99", "1-n", "2", "2-n", "2-2n",
         *                                    "3", "3-n", "3-3n", "4", "6", "9", "16", "32"),
         *                      interpreted as cardinality (number of items) for sequence attributes
         *  @param  type        value type (valid value: "1", "1C", "2", something else which is not checked)
         *  @param  moduleName  optional module name to be printed (default: "SR document" if NULL)
         ** @return status, EC_Normal if element could be retrieved and value is correct, an error code otherwise
         */
        public static E_Condition getAndCheckElementFromDataset(DicomAttributeCollection dataset,
                                                         ref DicomAttribute delem,
                                                         string vm,
                                                         string type,
                                                         string moduleName = null)
        {
            E_Condition result = getElementFromDataset(dataset, ref delem);
            if (!checkElementValue(delem, vm, type, result, moduleName))
            {
                result = E_Condition.SR_EC_InvalidValue;
            }

            return result;
        }

        /** get string value from dataset and check it for correct value multipicity and type.
         ** @param  dataset      reference to DICOM dataset from which the element should be retrieved.
         *                       (Would be 'const' if the methods from 'dcmdata' would also be 'const'.)
         *  @param  tagKey       DICOM tag specifying the attribute from which the string should be retrieved
         *  @param  stringValue  reference to character string in which the result should be stored.
         *                       (This parameter is automatically cleared if the tag could not be found.)
         *  @param  vm           value multiplicity (according to the data dictionary) to be checked for.
         *                       (valid value: "1", "1-2", "1-3", "1-8", "1-99", "1-n", "2", "2-n", "2-2n",
         *                                     "3", "3-n", "3-3n", "4", "6", "9", "16", "32"),
         *                       interpreted as cardinality (number of items) for sequence attributes
         *  @param  type         value type (valid value: "1", "1C", "2", something else which is not checked)
         *  @param  moduleName   optional module name to be printed (default: "SR document" if NULL)
         ** @return status, EC_Normal if element could be retrieved and value is correct, an error code otherwise
         */
        public static E_Condition getAndCheckStringValueFromDataset(DicomAttributeCollection dataset,
                                                             DicomAttribute tagKey,
                                                             ref string stringValue,
                                                             string vm,
                                                             string type,
                                                             string moduleName = null)
        {
            if (dataset == null || tagKey == null)
            {
                return E_Condition.EC_IllegalParameter;
            }

            E_Condition result = E_Condition.SR_EC_InvalidValue;
            DicomAttribute dcmAttribute;
            dataset.TryGetAttribute(tagKey.Tag, out dcmAttribute);
            if (dcmAttribute != null)
            {
                result = E_Condition.EC_Normal;
                if (checkElementValue(dcmAttribute, vm, type, result, moduleName))
                {
                    stringValue = dcmAttribute.ToString();
                }
                else
                {
                    result = E_Condition.EC_CorruptedData;
                }
            }
            else
            {
                if ((type == "1") || (type == "2"))
                {
                    //TODO: Log
                }
            }

            if (result.bad())
            {
                stringValue = null;
            }

            return result;
        }

        // --- output functions ---

        /** print the warning message that the current content item is invalid/incomplete.
         *  The value type (for DEBUG mode also the node ID) is added if the 'node' if specified.
         *  @param  action    text describing the current action (e.g. 'Reading'), 'Processing' if NULL
         *  @param  node      pointer to document tree node for which the message should be printed
         *  @param  location  position of the affected content item (e.g. '1.2.3', not printed if NULL)
         */
        public static void printInvalidContentItemMessage(string action, DSRDocumentTreeNode node, string location = null)
        {
            string message = string.Empty;
            if (!string.IsNullOrEmpty(action))
            {
                message += action;
            }
            else
            {
                message += "Processing";
            }

            message += " invalid/incomplete content item";
            if (node != null)
            {
                message += " ";
                message += valueTypeToDefinedTerm(node.getValueType());
            }

            if (!string.IsNullOrEmpty(location))
            {
                message += " \"";
                message += location;
                message += "\"";
            }
            //DCMSR_WARN(message);
        }

        /** print an error message for the current content item.
        *  The value type (for DEBUG mode also the node ID) is added if the 'node' if specified.
        *  @param  action    text describing the current action (e.g. 'Reading'), 'Processing' if NULL
        *  @param  result    status used to print more information on the error (no message if EC_Normal)
        *  @param  node      pointer to document tree node for which the message should be printed
        *  @param  location  position of the affected content item (e.g. '1.2.3', not printed if NULL)
        */
        public static void printContentItemErrorMessage(string action, E_Condition result, DSRDocumentTreeNode node, string location = null)
        {
            if (result.bad())
            {
                string message = string.Empty;
                if (!string.IsNullOrEmpty(action))
                {
                    message += action;
                }
                else
                {
                    message += "Processing";
                }

                message += " content item";
                if (node != null)
                {
                    message += " ";
                    message += valueTypeToDefinedTerm(node.getValueType());
                }

                if (!string.IsNullOrEmpty(location))
                {
                    message += " \"";
                    message += location;
                    message += "\"";
                }

                //DCMSR_ERROR(message);
            }
        }

        /** print a warning message that an unknown/unsupported value has been determined
         *  @param  valueName  name of the unknown/unsupported value
         *  @param  readValue  value that has been read (optional)
         *  @param  action     text describing the current action (default: 'Reading'), 'Processing' if NULL
         */
        public static void printUnknownValueWarningMessage(string valueName, string readValue = null, string action = "Reading")
        {
            if (!string.IsNullOrEmpty(valueName))
            {
                string message = string.Empty;
                if (action != null)
                    message += action;
                else
                    message += "Processing";
                message += " unknown/unsupported ";
                message += valueName;
                if ((readValue != null) && (readValue.Length > 0))
                {
                    message += " (";
                    message += readValue;
                    message += ")";
                }
                //DCMSR_WARN(message);
            }
        }

        /** write string value to XML output stream.
         *  The output looks like this: "<" tagName ">" stringValue "</" tagName ">"
         ** @param  stream           output stream to which the XML document is written
         *  @param  stringValue      string value to be written
         *  @param  tagName          name of the XML tag used to surround the string value
         *  @param  writeEmptyValue  optional flag indicating whether an empty value should be written
         ** @return OFTrue if tag/value has been written, OFFalse otherwise
         */
        public static bool writeStringValueToXML(StringBuilder stream, string stringValue, string tagName, bool writeEmptyValue = false)
        {
            //TODO: DSRTypes: writeStringValueToXML
            return false;
        }

        /** write string value from DICOM element to XML output stream.
         *  The output looks like this: "<" tagName ">" stringValue "</" tagName ">"
         *  For elements with DICOM VR=PN the function dicomToXMLPersonName() is used internally.
         ** @param  stream           output stream to which the XML document is written
         *  @param  delem            reference to DICOM element from which the value is retrieved
         *  @param  tagName          name of the XML tag used to surround the string value
         *  @param  writeEmptyValue  optional flag indicating whether an empty value should be written
         ** @return OFTrue if tag/value has been written, OFFalse otherwise
         */
        public static bool writeStringFromElementToXML(StringBuilder tream, DicomAttribute delem, string tagName, bool writeEmptyValue = false)
        {
            //TODO: DSRTypes: writeStringFromElementToXML
            return false;
        }

        /** create an HTML annex entry with hyperlinks.
         *  A reference text is added to the main document and a new annex entry to the document annex
         *  with HTML hyperlinks between both.  Example for a reference: '[for details see Annex 1]'
         ** @param  docStream      output stream used for the main document
         *  @param  annexStream    output stream used for the document annex
         *  @param  referenceText  optional text added to the main document (e.g. 'for details see')
         *  @param  annexNumber    reference to the variable where the current annex number is stored.
         *                         Value is increased automatically by 1 after the new entry has been added.
         *  @param  flags          optional flag used to customize the output (see DSRTypes::HF_xxx)
         ** @return current annex number after the new entry has been added
         */
        public static int createHTMLAnnexEntry(StringBuilder docStream, StringBuilder annexStream, string referenceText, ref int annexNumber, int flags = 0)
        {
            /* hyperlink to corresponding annex */
            string attrName = ((flags & DSRTypes.HF_XHTML11Compatibility) != 0) ? "id" : "name";
            docStream.Append("[");
            if (!string.IsNullOrEmpty(referenceText))
            {
                docStream.Append(referenceText);
                docStream.Append(" ");
            }
            docStream.Append("<a ");
            docStream.Append(attrName);
            docStream.Append("=\"annex_src_");
            docStream.Append(annexNumber);
            docStream.Append("\" href=\"#annex_dst_");
            docStream.Append(annexNumber);
            docStream.Append("\">Annex ");
            docStream.Append(annexNumber);
            docStream.Append("</a>]");
            docStream.Append(Environment.NewLine);
            /* create new annex */
            annexStream.Append("<h2><a ");
            annexStream.Append(attrName);
            annexStream.Append("=\"annex_dst_");
            annexStream.Append(annexNumber);
            annexStream.Append("\" href=\"#annex_src_");
            annexStream.Append(annexNumber);
            annexStream.Append("\">Annex ");
            annexStream.Append(annexNumber);
            annexStream.Append("</a></h2>");
            annexStream.Append(Environment.NewLine);
            /* increase annex number, return previous number */
            return annexNumber++;
        }

        /** create an HTML footnote with hyperlinks
         ** @param  docStream       output stream used for the main document
         *  @param  footnoteStream  output stream used for the footnote text
         *  @param  footnoteNumber  reference to the variable where the current footnote number is stored.
         *                          Value is increased automatically by 1 after the new entry has been added.
         *  @param  nodeID          unique numerical identifier of the current node for which this footnote
         *                          is created.  Used to create a unique name for the hyperlink.
         *  @param  flags           optional flag used to customize the output (see DSRTypes::HF_xxx)
         ** @return current footnote number after the new entry has been added
         */
        public static int createHTMLFootnote(StringBuilder docStream, StringBuilder footnoteStream, ref int footnoteNumber, int nodeID, int flags = 0)
        {
            /* hyperlink to corresponding footnote */
            string attrName = ((flags & DSRTypes.HF_XHTML11Compatibility) != 0 ) ? "id" : "name";
            if ((flags & HF_XHTML11Compatibility) != 0)
            {
                docStream.Append("<span class=\"super\">");
            }
            else
            {
                docStream.Append("<small><sup>");
            }
            docStream.Append("<a "); docStream.Append(attrName); docStream.Append("=\"footnote_src_"); docStream.Append(nodeID); docStream.Append("_"); docStream.Append(footnoteNumber); docStream.Append("\" ");
            docStream.Append("href=\"#footnote_dst_"); docStream.Append(nodeID); docStream.Append("_"); docStream.Append(footnoteNumber); docStream.Append("\">"); docStream.Append(footnoteNumber); docStream.Append("</a>");
            if ((flags & HF_XHTML11Compatibility) != 0)
            {
                docStream.Append("</span>"); docStream.Append(Environment.NewLine);
            }
            else
            {
                docStream.Append("</sup></small>"); docStream.Append(Environment.NewLine);
            }
            /* create new footnote */
            footnoteStream.Append("<b><a "); footnoteStream.Append(attrName); footnoteStream.Append("=\"footnote_dst_"); footnoteStream.Append(nodeID); footnoteStream.Append("_"); footnoteStream.Append(footnoteNumber); footnoteStream.Append("\" ");
            footnoteStream.Append("href=\"#footnote_src_"); footnoteStream.Append(nodeID); footnoteStream.Append("_"); footnoteStream.Append(footnoteNumber); footnoteStream.Append("\">Footnote "); footnoteStream.Append(footnoteNumber); footnoteStream.Append("</a></b>"); footnoteStream.Append(Environment.NewLine);
            /* increase footnote number, return previous number */
            return footnoteNumber++;
        }

        /** append one output stream to another.
         ** @param  mainStream  stream to which the other should be added
         *  @param  tempStream  (string) stream to be added to the other
         *  @param  heading     (optional) string which is added to the 'mainStream' before the 'tempStream'.
         *                      This string is only added if 'tempStream' is not empty.
         ** @return status, EC_Normal if stream has been added successfully, an error code otherwise
         */
        public static E_Condition appendStream(ref StringBuilder mainStream, ref StringBuilder tempStream, string heading = null)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* add final 0 byte (if required) */
            if (tempStream == null)
            {
                tempStream = new StringBuilder();
            }
            tempStream.Append("");
            /* freeze/get string (now we have full control over the array) */
            string tempString = tempStream.ToString();
            /* should never be NULL */
            if (tempString != null)
            {
                if (tempString.Length > 0)
                {
                    /* append optional heading */
                    if (heading != null)
                    {
                        mainStream.Append(heading);
                        mainStream.Append(Environment.NewLine);
                    }
                    /* append temporal document to main document */
                    mainStream.Append(tempString);
                }
                /* very important! since we have full control we are responsible for deleting the array */
                tempString = string.Empty;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tag"></param>
        /// <returns></returns>
        public static DicomAttribute getDicomAttribute(uint tag)
        {
            return DicomTagDictionary.GetDicomTag(tag).CreateDicomAttribute();
        }
    };
}
