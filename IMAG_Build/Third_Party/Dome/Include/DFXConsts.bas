Attribute VB_Name = "DFXConsts"

'
' This file contains constants used by the DimFileX ActiveX.
'

' parameter values
'  new
Public Const DFX_ID_OLD  As Long = -10
Public Const DFX_ID_NOID As Long = -11

Public Const DFX_WAIT_ALL As Long = 1

Public Const DFX_IMAGE_UNDEFINED As Long = 0
Public Const DFX_IMAGE_NOTLAST   As Long = 1
Public Const DFX_IMAGE_LAST      As Long = 2

Public Const DFX_CANCELDISPLAY  As Long = 1

Public Const DFX_MORE_QUIT      As Long = 0
Public Const DFX_MORE_CONTINUE  As Long = 1
Public Const DFX_MORE_FINALHIER As Long = 2
Public Const DFX_MORE_REPRODUCE As Long = 3
Public Const DFX_MORE_NEXTFRAME As Long = 4

Public Const DFX_DICOM_DOPART10 As Long = &H10000

Public Const DFX_DICOM_ELEMENT_PROMOTE_UNSIGNED          As Long = &H1
Public Const DFX_DICOM_ELEMENT_PROMOTE_ALL               As Long = &H2
Public Const DFX_DICOM_ELEMENT_CONVERT_NUMERICSTRINGS    As Long = &H4
Public Const DFX_DICOM_ELEMENT_DEMOTE_SIGNED             As Long = &H8
Public Const DFX_DICOM_ELEMENT_RETURN_ARRAY_MASK         As Long = &H3000
Public Const DFX_DICOM_ELEMENT_RETURN_ARRAY              As Long = &H1000
Public Const DFX_DICOM_ELEMENT_RETURN_SCALAR             As Long = &H2000
Public Const DFX_DICOM_ELEMENT_RETURN_UNSIGNED_MASK      As Long = &HC000
Public Const DFX_DICOM_ELEMENT_RETURN_UNSIGNED           As Long = &H4000
Public Const DFX_DICOM_ELEMENT_RETURN_UNSIGNED_AS_SIGNED As Long = &H8000

Public Const DFX_PROGRESSIVE_HIERARCHICAL  As Long = &H1
Public Const DFX_PROGRESSIVE_PAINTDOWN     As Long = &H2
Public Const DFX_PROGRESSIVE_LOAD_ALL      As Long = &HFF
Public Const DFX_PROGRESSIVE               As Long = &HFFFF

Public Const DFX_FIT_TYPE_MASK       As Long = &HFF
Public Const DFX_FIT_TYPE_NOFIT      As Long = &H0    ' not fitted
Public Const DFX_FIT_TYPE_MAX        As Long = &H1
Public Const DFX_FIT_TYPE_ROTATABLE  As Long = &H2
Public Const DFX_FIT_TYPE_FINALSIZE  As Long = &H3    ' not fitted
Public Const DFX_FIT_NOUPSCALE       As Long = &H100 ' don't resize above final size

Public Const DFX_SPACE_RGB_OR_GRAY   As Long = -1
'  old

' Err.Number
'  new
Public Const DFX_SCODE_DIMPL_ERROR              As Long = 2000
Public Const DFX_SCODE_NOSUCHID                 As Long = 2001
Public Const DFX_SCODE_UNUSED_001               As Long = 2002
Public Const DFX_SCODE_NO_FILE                  As Long = 2003
Public Const DFX_SCODE_NO_IMAGE                 As Long = 2004
Public Const DFX_SCODE_NOT_AN_IMAGE             As Long = 2005
Public Const DFX_SCODE_INVALID_MORE             As Long = 2006
Public Const DFX_SCODE_FILE_NOT_FOUND           As Long = 2007
Public Const DFX_SCODE_INVALID_COLORSPACE       As Long = 2008
Public Const DFX_SCODE_NOT_FILEIMAGE            As Long = 2009
Public Const DFX_SCODE_NOT_PALETTEIMAGE         As Long = 2010
Public Const DFX_SCODE_NOT_DICOMIMAGE           As Long = 2011
Public Const DFX_SCODE_JOB_PENDING              As Long = 2012
Public Const DFX_SCODE_JOB_IN_PROGRESS          As Long = 2013
Public Const DFX_SCODE_JOB_ABORTED              As Long = 2014
'  old
Public Const DFX_SCODE_CREATE_IMAGE_FROM_DP     As Long = 1000
Public Const DFX_SCODE_CREATE_IMAGE_FROM_URL    As Long = 1001
Public Const DFX_SCODE_CANT_CHANGE_NOW          As Long = 1002
'  shared
Public Const DFX_SCODE_UNKNOWN                  As Long = 30000
Public Const DFX_SCODE_INTERNAL                 As Long = 30001
Public Const DFX_SCODE_NYI                      As Long = 32767

' return values
'  new
'  old
Public Const DFX_ERROR_SUCCESS               As Long = 0
Public Const DFX_NO_ERROR                    As Long = 0   ' for backward compatibility with Beta 2.0
Public Const DFX_ERROR_UNKNOWN               As Long = -1
Public Const DFX_ERROR_NO_SESSION            As Long = -2
Public Const DFX_ERROR_FILE_NOT_FOUND        As Long = -3
Public Const DFX_ERROR_FILE_IO               As Long = -4
Public Const DFX_ERROR_FILE_NOT_DICOM        As Long = -5
Public Const DFX_ERROR_ELEMENT_NOT_FOUND     As Long = -6
Public Const DFX_ERROR_VR_MISMATCH           As Long = -7
Public Const DFX_ERROR_BAD_PARAM_TYPE        As Long = -8
Public Const DFX_ERROR_MEMORY_ALLOCATION     As Long = -9
Public Const DFX_ERROR_ELEMENT_ZERO_LENGTH   As Long = -10

Public Function DFD_VR(c0 As String, c1 As String) As Long
    DFD_VR = 2 ^ 8 * Asc(c1) + Asc(c0)
End Function

Public Function DFD_VR1(c As String) As Long
    DFD_VR1 = 2 ^ 8 * Asc(Mid(c, 2, 1)) + Asc(Mid(c, 1, 1))
End Function

Public Function D_COMP_JPEG_QUALITY(ByVal quality As Integer) As Long
    Select Case quality
    Case Is < 0
        quality = 0
    Case Is > D_COMP_JPEG_MAX_QUALITY
        quality = D_COMP_JPEG_MAX_QUALITY
    End Select
    D_COMP_JPEG_QUALITY = D_COMP_JPEG Or quality
End Function

Public Function D_COMP_JPEG_PROG_QUALITY(ByVal quality As Integer) As Long
    Select Case quality
    Case Is < 0
        quality = 0
    Case Is > D_COMP_JPEG_MAX_QUALITY
        quality = D_COMP_JPEG_MAX_QUALITY
    End Select
    D_COMP_JPEG_PROG_QUALITY = D_COMP_JPEG_PROG Or quality
End Function

Public Function D_COMP_JPEG_LL_HIER_FRAMES(ByVal nHierarchies As Integer) As Long
    Select Case nHierarchies
    Case Is < 1
        nHierarchies = 1
    Case Is > D_COMP_JPEG_LL_HIER_MAX_FRAMES
        nHierarchies = D_COMP_JPEG_LL_HIER_MAX_FRAMES
    End Select
    D_COMP_JPEG_LL_HIER_FRAMES = D_COMP_JPEG_LL_HIER Or nHierarchies
End Function

