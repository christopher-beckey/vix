VERSION 5.00
Object = "{531B6D8D-1BC0-4630-9886-F1C72B7933F4}#1.0#0"; "igformats13a.ocx"
Object = "{A4404E29-2D42-44D6-9D36-C3F7F4FB748A}#1.0#0"; "igdisplay13a.ocx"
Object = "{F7BE3867-ED1F-4D44-9838-DBACE371A80D}#1.0#0"; "igdlgs13a.ocx"
Object = "{4AF0FFFE-C54F-4FE4-BE99-E31152780791}#1.0#0"; "igArt13a.ocx"
Object = "{52AF6CF7-2B3E-4F18-92E0-25F20A64C937}#1.0#0"; "igview13a.ocx"
Object = "{AFED7894-8392-45B1-82FB-AA31CD665BC4}#1.0#0"; "igprocessing13a.ocx"
Object = "{15C1631C-83BF-40A4-B96A-5F298CA92941}#1.0#0"; "igcore13a.ocx"
Begin VB.UserControl AnnTool 
   ClientHeight    =   5880
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4050
   ScaleHeight     =   5880
   ScaleWidth      =   4050
   Begin GearDISPLAYLibCtl.IGDisplayCtl IGDisplayCtl1 
      Left            =   1560
      OleObjectBlob   =   "AnnTool.ctx":0000
      Top             =   4800
   End
   Begin GearVIEWLibCtl.IGPageViewCtl IGPageViewCtl1 
      Height          =   2535
      Left            =   360
      OleObjectBlob   =   "AnnTool.ctx":0024
      TabIndex        =   0
      Top             =   600
      Width           =   3015
   End
   Begin GearCORELibCtl.IGCoreCtl IGCoreCtl1 
      Left            =   1320
      OleObjectBlob   =   "AnnTool.ctx":008A
      Top             =   3960
   End
   Begin GearPROCESSINGLibCtl.IGProcessingCtl IGProcessingCtl1 
      Left            =   1560
      OleObjectBlob   =   "AnnTool.ctx":00AE
      Top             =   3120
   End
   Begin GearARTLibCtl.IGArtCtl IGArtCtl1 
      Left            =   360
      OleObjectBlob   =   "AnnTool.ctx":00D2
      Top             =   4440
   End
   Begin GearDIALOGSLibCtl.IGDlgsCtl IGDlgsCtl1 
      Left            =   600
      OleObjectBlob   =   "AnnTool.ctx":00EE
      Top             =   3480
   End
   Begin GearFORMATSLibCtl.IGFormatsCtl IGFormatsCtl1 
      Left            =   2040
      OleObjectBlob   =   "AnnTool.ctx":0112
      Top             =   3480
   End
End
Attribute VB_Name = "AnnTool"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Private Declare Function TranslateColor Lib "olepro32.dll" Alias "OleTranslateColor" (ByVal clr As OLE_COLOR, ByVal palet As Long, col As Long) As Long

Public Version As String 'variable that holds the annotationOCX version


'enumerated type for the possible tools the user may use
Public Enum PossibleTools
NoTool = 0
pointer = 1
FreehandLine = 2
StraightLine = 4
HollowRectangle = 5
FilledRectangle = 6
TypedText = 7
Arrow = 8
Plus = 9
Minus = 10
hollowellipse = 11
FilledEllipse = 12
End Enum


'enumerated type for the possible zoom views
Public Enum PossibleViews
BestFit = 0
ToWidth = 1
ToHeight = 2
ViewStandard = 3
End Enum

'enumerated type for the possible annotation styles
Public Enum PossibleAnnotationStyle
Opaque = 0
Transparent = 1
End Enum

'Default Property Values:
Const m_def_SelectAll = 0
Const m_def_Undo = 0
'Const m_def_CurrColorType = 0
Const m_def_Strikethrough = 0
Const m_def_Underline = 0
Const m_def_Bold = 0
Const m_def_Italic = 0
Const m_def_CurrStyle = 0
Const m_def_FillColor = 0
Const m_def_FontColor = 0
Const m_def_FontSize = 0
Const m_def_FontName = "0"
Const m_def_LineColor = 0
Const m_def_LineWidth = 0
Const m_def_ClearAnnotations = 0
Const m_def_CopytoClipboard = 0
Const m_def_ZoomLevel = 0
Const m_def_CurrView = 0
Const m_def_DeleteCurrAnnotation = 0
Const m_def_BackColor = 0
Const m_def_ForeColor = 0
Const m_def_Enabled = 0
Const m_def_BackStyle = 0
Const m_def_BorderStyle = 0
Const m_def_OpenFile = "0"
Const m_def_SaveFile = "0"
Const m_def_CurrTool = 0
'Const m_def_ZoomLevel = 0
Const m_def_ClearDisplay = 0
'Property Variables:
Dim m_SelectAll As Boolean
Dim m_Undo As Boolean
'Dim m_CurrColorType As Variant
Dim m_Strikethrough As Boolean
Dim m_Underline As Boolean
Dim m_Bold As Boolean
Dim m_Italic As Boolean
Dim m_CurrStyle As PossibleAnnotationStyle
Dim m_FillColor As OLE_COLOR
Dim m_FontColor As OLE_COLOR
Dim m_FontSize As Integer
Dim m_FontName As String
Dim m_LineColor As OLE_COLOR
Dim m_LineWidth As Integer
Dim m_ClearAnnotations As Boolean
Dim m_CopytoClipboard As Boolean
Dim m_ZoomLevel As Integer
'Dim m_CurrView As Integer
Dim m_CurrView As PossibleViews
Dim m_DeleteCurrAnnotation As Boolean
Dim m_BackColor As Long
Dim m_ForeColor As Long
Dim m_Enabled As Boolean
'Dim m_Font As Font
Dim m_BackStyle As Integer
Dim m_BorderStyle As Integer
Dim m_OpenFile As String
Dim m_SaveFile As String
'Dim m_CurrTool As Integer
Dim m_CurrTool As PossibleTools
'Dim m_ZoomLevel As Single
Dim m_ClearDisplay As Boolean
'Event Declarations:
Event Click()
Attribute Click.VB_Description = "Occurs when the user presses and then releases a mouse button over an object."
Event DblClick()
Attribute DblClick.VB_Description = "Occurs when the user presses and releases a mouse button and then presses and releases it again over an object."
Event KeyDown(KeyCode As Integer, Shift As Integer)
Attribute KeyDown.VB_Description = "Occurs when the user presses a key while an object has the focus."
Event KeyPress(KeyAscii As Integer)
Attribute KeyPress.VB_Description = "Occurs when the user presses and releases an ANSI key."
Event KeyUp(KeyCode As Integer, Shift As Integer)
Attribute KeyUp.VB_Description = "Occurs when the user releases a key while an object has the focus."
Event MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseDown.VB_Description = "Occurs when the user presses the mouse button while an object has the focus."
Event MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseMove.VB_Description = "Occurs when the user moves the mouse."
Event MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseUp.VB_Description = "Occurs when the user releases the mouse button while an object has the focus."

Public BurnFile As Boolean ' value if the annotations should be burned to the image
Public ImageChanged As Boolean 'value if the image has been changed
Public LastError As String


'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,0
Public Property Get BackColor() As Long
Attribute BackColor.VB_Description = "Returns/sets the background color used to display text and graphics in an object."
    BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As Long)
    m_BackColor = New_BackColor
    PropertyChanged "BackColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,0
Public Property Get ForeColor() As Long
Attribute ForeColor.VB_Description = "Returns/sets the foreground color used to display text and graphics in an object."
    ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As Long)
    m_ForeColor = New_ForeColor
    PropertyChanged "ForeColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Returns/sets a value that determines whether an object can respond to user-generated events."
    Enabled = m_Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    m_Enabled = New_Enabled
    PropertyChanged "Enabled"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get BackStyle() As Integer
Attribute BackStyle.VB_Description = "Indicates whether a Label or the background of a Shape is transparent or opaque."
    BackStyle = m_BackStyle
End Property

Public Property Let BackStyle(ByVal New_BackStyle As Integer)
    m_BackStyle = New_BackStyle
    PropertyChanged "BackStyle"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get BorderStyle() As Integer
Attribute BorderStyle.VB_Description = "Returns/sets the border style for an object."
    BorderStyle = m_BorderStyle
End Property

Public Property Let BorderStyle(ByVal New_BorderStyle As Integer)
    m_BorderStyle = New_BorderStyle
    PropertyChanged "BorderStyle"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=5
Public Sub Refresh()
Attribute Refresh.VB_Description = "Forces a complete repaint of a object."
     
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=13,0,0,0
Public Property Get OpenFile() As String
    OpenFile = m_OpenFile
End Property

Public Property Let OpenFile(ByVal New_OpenFile As String)
    m_OpenFile = New_OpenFile
    PropertyChanged "OpenFile"
    'check to make sure new_openfile has data
    If New_OpenFile <> "" Then
        LoadImage New_OpenFile 'Call the function to load the image
    End If
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=13,0,0,0
Public Property Get SaveFile() As String
    SaveFile = m_SaveFile
End Property

Public Property Let SaveFile(ByVal New_SaveFile As String)
    m_SaveFile = New_SaveFile
    On Error GoTo sErrHand
    PropertyChanged "SaveFile"
    If New_SaveFile <> "" Then 'check to make sure a file was given
    
    IGProcessingCtl1.ConvertToGray CurIGPage    'convert the image to gray
    If BurnFile = True Then 'if burnfile is true
        If IsValidEnv() Then
            ' burn the annotations and promote the image for the colors
            artPage.ImageBurnIn ART_BURN_IN_ALL + ART_BURN_IN_AUTO_PROMOTE, "[Untitled]"
        End If
    End If

    Dim dialogSaveOptions As IGFileDlgPageSaveOptions
    
    Set dialogSaveOptions = IGDlgsCtl1.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGESAVEOBJ)
    dialogSaveOptions.Page = CurIGPage
    ' set the filename
    dialogSaveOptions.Filename = New_SaveFile

        ' save the page to specified filename
        IGFormatsCtl1.SavePageToFile CurIGPage, dialogSaveOptions.Filename, _
            dialogSaveOptions.PageNum, IG_PAGESAVEMODE_DEFAULT, IG_SAVE_TGA_RLE ',   IG_SAVE_TIF_JPG ', IG_SAVE_TIF_G4     '  dialogSaveOptions.Format
   End If
    
    Exit Property
sErrHand:
LastError = "Unable to save file " & New_SaveFile
    
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get CurrTool() As PossibleTools
    CurrTool = m_CurrTool
End Property
Public Property Let CurrTool(ByVal New_currTool As PossibleTools)
    m_CurrTool = New_currTool
    PropertyChanged "CurrTool"
    If New_currTool = Arrow Then 'if the tool selected is arrow
'        artPage.GlobalAttrArrowType = arrowPointer
        SetGlobalMarkType markArrow
    ElseIf New_currTool = FilledRectangle Then 'if the tool selected is filled rectangle
        SetGlobalMarkType markFilledRectangle
'        IGPageViewCtl1.MousePointer = wiMPFilledRect 'set the mouse pointer to filled rectangle
    ElseIf New_currTool = FreehandLine Then 'if the tool selected is freehand line
        SetGlobalMarkType markFreehandLine
        'ImgEdit1.MousePointer = wiMPFreehandLine 'set the mouse pointer to freehand line
    ElseIf New_currTool = HollowRectangle Then 'if the tool selected is hollow rectangle
        SetGlobalMarkType markHollowRectangle
'        ImgEdit1.MousePointer = wiMPHollowRect 'set the mouse pointer to hollow rectangle
    ElseIf New_currTool = Minus Then 'if the tool selected is minus
'        ImgEdit1.MousePointer = wiMPCustom '  = wiMPCross
    ElseIf New_currTool = NoTool Then 'if the tool selected is no tool
        SetGlobalMarkType markSelect
'        ImgEdit1.MousePointer = wiMPNoDrop 'set the pointer to nothing
    ElseIf New_currTool = Plus Then 'if the tool selected is plus
'        ImgEdit1.MousePointer = wiMPCross 'set the pointer to the cross
    ElseIf New_currTool = pointer Then 'if the tool selected is pointer
        SetGlobalMarkType markSelect ' set the pointer
'        IGPageViewCtl1.MousePointer = wiMPArrow '= wiMPDefault
    ElseIf New_currTool = StraightLine Then 'if the tool selected is straight line
        SetGlobalMarkType markStraightLine
'        ImgEdit1.MousePointer = wiMPSelect ' = wiMPCross
    ElseIf New_currTool = TypedText Then 'if the tool selected is typed text
        SetGlobalMarkType markTypedText
'        ImgEdit1.MousePointer = wiMPText 'set the mouse pointer to text
    ElseIf New_currTool = hollowellipse Then
        SetGlobalMarkType markHollowEllipse
    ElseIf New_currTool = FilledEllipse Then
        SetGlobalMarkType markFilledEllipse
    End If
'    SetPointer New_currTool

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get ClearDisplay() As Boolean
    ClearDisplay = m_ClearDisplay
End Property

Public Property Let ClearDisplay(ByVal New_ClearDisplay As Boolean)
    m_ClearDisplay = New_ClearDisplay
    PropertyChanged "ClearDisplay"
    CurIGPage.Clear 'clear the page
    IGPageViewCtl1.UpdateView 'update the view
    ImageChanged = False 'set changed to false
    m_ClearDisplay = False
End Property


Private Function SetPointer(Tool As PossibleTools)
If Tool = Arrow Then 'if the tool is an arrow
    MousePointer = 10 ' set the mouse pointer to the arrow
Else 'if the tool is anything else
    MousePointer = 0 ' set the mouse pointer to the arrow
End If
End Function

Private Sub IGPageViewCtl1_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Long, ByVal y As Long)
    Dim hMarkIndex, hMarkSelected As Long
    Dim fSelected As Boolean
    Dim dwSelectCount As Long
    
    igCurPoint.XPos = x 'get the current X
    igCurPoint.YPos = y 'get the current Y
    If IsValidEnv() Then 'if the image is valid
        If 1 = Button Then 'if the button is 1
            ' make the button move work
            artPage.InteractionProcess Button, 1, igCurPoint 'turn on the interaction
            ImageChanged = True 'set the image changed
        ElseIf Button = 2 Then 'if the button is 2
            'SetGlobalMarkType markSelect 'set the tool to the pointer
            Me.CurrTool = pointer 'set the tool to the pointer
        End If
    End If
End Sub

Private Sub IGPageViewCtl1_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Long, ByVal y As Long)
    Dim pointsArray  As New IGPointArray
    igCurPoint.XPos = x
    igCurPoint.YPos = y
    If IsValidEnv() Then
        pointsArray.Resize 1
        pointsArray.XPos(0) = x
        pointsArray.YPos(0) = y

        igPageDisp.ConvertCoordinates IGPageViewCtl1.hWnd, 0, pointsArray, IG_DSPL_CONV_DEVICE_TO_IMAGE
        
        x = pointsArray.XPos(0)
        y = pointsArray.YPos(0)
        If x < 0 Or y < 0 Or x > CurIGPage.ImageWidth Or y > CurIGPage.ImageHeight Then
'            MousePointer = vbDefault
        Else
             
    '        artPage.InteractionProcess Button, 0, igCurPoint
    '        Screen.
'            MousePointer = vbCustom
    '        Screen.
'            MouseIcon = artPage.MouseIconQuery(igCurPoint)
        End If

    End If
End Sub

Private Sub IGPageViewCtl1_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Long, ByVal y As Long)
    igCurPoint.XPos = x
    igCurPoint.YPos = y
    If IsValidEnv() Then
        If 1 = Button Then 'if the button is 1
            artPage.InteractionProcess Button, 2, igCurPoint 'turn off the interaction
            ImageChanged = True 'set the image as has changed
        End If
    End If
End Sub

Private Sub HandleEditDelete()
    Dim i As Long
    Dim Selected As Boolean
    Dim NextMark As Long

    ' Group the deletes into a single undo
    artPage.EditUndoRecord True

    i = artPage.MarkFirst
    While i >= 0 'loop through all of the annotations
        Selected = artPage.MarkIsSelected(i)
        NextMark = artPage.MarkNext(i)
        If Selected = True Then 'if the annotation is selected
            artPage.MarkVisible i, True 'set the annotations visible
            artPage.MarkDelete i 'delete the annotations
        End If
        i = NextMark 'move to the next annotation
    Wend
    
    artPage.EditUndoRecord False
    IGPageViewCtl1.UpdateView
End Sub

Private Sub HandleMenuProperties()
' I don't think this code is used...
    Dim hMarkIndex As Long
    hMarkIndex = artPage.MarkSelectedFirst()
    If hMarkIndex <> ART_INVALID_ID Then
        artPage.MarkAttributesShow hMarkIndex
    End If
End Sub

Private Sub UserControl_Initialize()

' set the version variable to the applications version
Version = App.Major & "." & App.Minor & "." & App.Revision
BurnFile = False    'set the burn file to false
ArrowCount = 0
PlusCount = 0
    ' handle errors with On Error Goto XXX
    IGCoreCtl1.Result.NotificationFlags = IG_ERR_OLE_ERROR
    
    ' licensing stuffs
    IGCoreCtl1.License.SetSolutionName ("AccuSoft 1-100-13")
    ' associate controls with core
    IGCoreCtl1.AssociateComponent IGFormatsCtl1.ComponentInterface
    IGCoreCtl1.AssociateComponent IGDisplayCtl1.ComponentInterface
    IGCoreCtl1.AssociateComponent IGProcessingCtl1.ComponentInterface
    IGCoreCtl1.AssociateComponent IGArtCtl1.ComponentInterface

    ' associate formats control with file dialog and create load/save file dialog
    IGDlgsCtl1.GearFormats = IGFormatsCtl1.ComponentInterface
    IGDlgsCtl1.GearCore = IGCoreCtl1.ComponentInterface

    IGDlgsCtl1.GearDisplay = IGDisplayCtl1.ComponentInterface

    Set igFileDialog = IGDlgsCtl1.CreateFileDlg

    ' reset global sample variables, set them again in a moment
    currentPageNumber = -1
    totalLocationPageCount = 0
    
    ' create new page and page display objects
    Set CurIGPage = IGCoreCtl1.CreatePage
    Set igPageDisp = IGDisplayCtl1.CreatePageDisplay(CurIGPage)
    ' associate new active page display with page view control
    IGPageViewCtl1.PageDisplay = igPageDisp
    
    'Initialize the IGDDB
    Set IGDDB = Nothing
    
    ' update the view control to repaint the new page
    IGPageViewCtl1.UpdateView
    
    
    ' create new save and load options
    Set saveOptions = IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_SAVEOPTIONS)
    saveOptions.Format = IG_SAVE_UNKNOWN
    Set loadOptions = IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_LOADOPTIONS)
    loadOptions.Format = IG_FORMAT_UNKNOWN
    
    Set igCurPoint = IGCoreCtl1.CreateObject(IG_OBJ_POINT)
End Sub

'Initialize Properties for User Control
Private Sub UserControl_InitProperties()
    m_BackColor = m_def_BackColor
    m_ForeColor = m_def_ForeColor
    m_Enabled = m_def_Enabled
'    Set m_Font = Ambient.Font
    m_BackStyle = m_def_BackStyle
    m_BorderStyle = m_def_BorderStyle
    m_OpenFile = m_def_OpenFile
    m_SaveFile = m_def_SaveFile
    m_CurrTool = m_def_CurrTool
'    m_ZoomLevel = m_def_ZoomLevel
    m_ClearDisplay = m_def_ClearDisplay
    m_DeleteCurrAnnotation = m_def_DeleteCurrAnnotation
    m_CurrView = m_def_CurrView
    m_ZoomLevel = m_def_ZoomLevel
    m_CopytoClipboard = m_def_CopytoClipboard
    m_ClearAnnotations = m_def_ClearAnnotations
    m_LineColor = m_def_LineColor
    m_LineWidth = m_def_LineWidth
    m_FontColor = m_def_FontColor
    m_FontSize = m_def_FontSize
    m_FontName = m_def_FontName
    m_FillColor = m_def_FillColor
    m_CurrStyle = m_def_CurrStyle
    m_Bold = m_def_Bold
    m_Italic = m_def_Italic
    m_Strikethrough = m_def_Strikethrough
    m_Underline = m_def_Underline
'    m_CurrColorType = m_def_CurrColorType
    m_Undo = m_def_Undo
    m_SelectAll = m_def_SelectAll
End Sub


'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    m_BackColor = PropBag.ReadProperty("BackColor", m_def_BackColor)
    m_ForeColor = PropBag.ReadProperty("ForeColor", m_def_ForeColor)
    m_Enabled = PropBag.ReadProperty("Enabled", m_def_Enabled)
'    Set m_Font = PropBag.ReadProperty("Font", Ambient.Font)
    m_BackStyle = PropBag.ReadProperty("BackStyle", m_def_BackStyle)
    m_BorderStyle = PropBag.ReadProperty("BorderStyle", m_def_BorderStyle)
    m_OpenFile = PropBag.ReadProperty("OpenFile", m_def_OpenFile)
    m_SaveFile = PropBag.ReadProperty("SaveFile", m_def_SaveFile)
    m_CurrTool = PropBag.ReadProperty("CurrTool", m_def_CurrTool)
'    m_ZoomLevel = PropBag.ReadProperty("ZoomLevel", m_def_ZoomLevel)
    m_ClearDisplay = PropBag.ReadProperty("ClearDisplay", m_def_ClearDisplay)
    m_DeleteCurrAnnotation = PropBag.ReadProperty("DeleteCurrAnnotation", m_def_DeleteCurrAnnotation)
    m_CurrView = PropBag.ReadProperty("CurrView", m_def_CurrView)
    m_ZoomLevel = PropBag.ReadProperty("ZoomLevel", m_def_ZoomLevel)
    m_CopytoClipboard = PropBag.ReadProperty("CopytoClipboard", m_def_CopytoClipboard)
    m_ClearAnnotations = PropBag.ReadProperty("ClearAnnotations", m_def_ClearAnnotations)
    m_LineColor = PropBag.ReadProperty("LineColor", m_def_LineColor)
    m_LineWidth = PropBag.ReadProperty("LineWidth", m_def_LineWidth)
    m_FontColor = PropBag.ReadProperty("FontColor", m_def_FontColor)
    m_FontSize = PropBag.ReadProperty("FontSize", m_def_FontSize)
    m_FontName = PropBag.ReadProperty("FontName", m_def_FontName)
    m_FillColor = PropBag.ReadProperty("FillColor", m_def_FillColor)
    m_CurrStyle = PropBag.ReadProperty("CurrStyle", m_def_CurrStyle)
    m_Bold = PropBag.ReadProperty("Bold", m_def_Bold)
    m_Italic = PropBag.ReadProperty("Italic", m_def_Italic)
    m_Strikethrough = PropBag.ReadProperty("Strikethrough", m_def_Strikethrough)
    m_Underline = PropBag.ReadProperty("Underline", m_def_Underline)
'    m_CurrColorType = PropBag.ReadProperty("CurrColorType", m_def_CurrColorType)
    m_Undo = PropBag.ReadProperty("Undo", m_def_Undo)
    m_SelectAll = PropBag.ReadProperty("SelectAll", m_def_SelectAll)
End Sub

Private Sub UserControl_Resize()
'set the resize for the image to fill the screen
IGPageViewCtl1.Left = UserControl.ScaleLeft
IGPageViewCtl1.Top = UserControl.ScaleTop
IGPageViewCtl1.Width = UserControl.ScaleWidth
IGPageViewCtl1.Height = UserControl.ScaleHeight

End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    Call PropBag.WriteProperty("BackColor", m_BackColor, m_def_BackColor)
    Call PropBag.WriteProperty("ForeColor", m_ForeColor, m_def_ForeColor)
    Call PropBag.WriteProperty("Enabled", m_Enabled, m_def_Enabled)
'    Call PropBag.WriteProperty("Font", m_Font, Ambient.Font)
    Call PropBag.WriteProperty("BackStyle", m_BackStyle, m_def_BackStyle)
    Call PropBag.WriteProperty("BorderStyle", m_BorderStyle, m_def_BorderStyle)
    Call PropBag.WriteProperty("OpenFile", m_OpenFile, m_def_OpenFile)
    Call PropBag.WriteProperty("SaveFile", m_SaveFile, m_def_SaveFile)
    Call PropBag.WriteProperty("CurrTool", m_CurrTool, m_def_CurrTool)
'    Call PropBag.WriteProperty("ZoomLevel", m_ZoomLevel, m_def_ZoomLevel)
    Call PropBag.WriteProperty("ClearDisplay", m_ClearDisplay, m_def_ClearDisplay)
    Call PropBag.WriteProperty("DeleteCurrAnnotation", m_DeleteCurrAnnotation, m_def_DeleteCurrAnnotation)
    Call PropBag.WriteProperty("CurrView", m_CurrView, m_def_CurrView)
    Call PropBag.WriteProperty("ZoomLevel", m_ZoomLevel, m_def_ZoomLevel)
    Call PropBag.WriteProperty("CopytoClipboard", m_CopytoClipboard, m_def_CopytoClipboard)
    Call PropBag.WriteProperty("ClearAnnotations", m_ClearAnnotations, m_def_ClearAnnotations)
    Call PropBag.WriteProperty("LineColor", m_LineColor, m_def_LineColor)
    Call PropBag.WriteProperty("LineWidth", m_LineWidth, m_def_LineWidth)
    Call PropBag.WriteProperty("FontColor", m_FontColor, m_def_FontColor)
    Call PropBag.WriteProperty("FontSize", m_FontSize, m_def_FontSize)
    Call PropBag.WriteProperty("FontName", m_FontName, m_def_FontName)
    Call PropBag.WriteProperty("FillColor", m_FillColor, m_def_FillColor)
    Call PropBag.WriteProperty("CurrStyle", m_CurrStyle, m_def_CurrStyle)
    Call PropBag.WriteProperty("Bold", m_Bold, m_def_Bold)
    Call PropBag.WriteProperty("Italic", m_Italic, m_def_Italic)
    Call PropBag.WriteProperty("Strikethrough", m_Strikethrough, m_def_Strikethrough)
    Call PropBag.WriteProperty("Underline", m_Underline, m_def_Underline)
'    Call PropBag.WriteProperty("CurrColorType", m_CurrColorType, m_def_CurrColorType)
    Call PropBag.WriteProperty("Undo", m_Undo, m_def_Undo)
    Call PropBag.WriteProperty("SelectAll", m_SelectAll, m_def_SelectAll)
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get DeleteCurrAnnotation() As Boolean
    DeleteCurrAnnotation = m_DeleteCurrAnnotation
End Property

Public Property Let DeleteCurrAnnotation(ByVal New_DeleteCurrAnnotation As Boolean)
    m_DeleteCurrAnnotation = New_DeleteCurrAnnotation
    PropertyChanged "DeleteCurrAnnotation"
    'check to see if deletecurrannotation is true and if there is an image displayed
    If New_DeleteCurrAnnotation = True Then
        If IsValidEnv() Then
            HandleEditDelete
        End If
    End If
    New_DeleteCurrAnnotation = False    'set new_deletecurrannotion to false
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
'Public Property Get CurrView() As Integer
Public Property Get CurrView() As PossibleViews
    CurrView = m_CurrView
End Property

'Public Property Let CurrView(ByVal New_CurrView As Integer)
Public Property Let CurrView(ByVal New_currView As PossibleViews)
    m_CurrView = New_currView
    
    
    Dim zoomzoom As IGDisplayZoomInfo
    Set zoomzoom = igPageDisp.GetZoomInfo(IGPageViewCtl1.hWnd)

    ' update zoom object with new values
    zoomzoom.Mode = IG_DSPL_ZOOM_H_NOT_FIXED Or IG_DSPL_ZOOM_V_NOT_FIXED
    ' set the zoom object
    igPageDisp.UpdateZoomFrom zoomzoom
    
    If m_CurrView = 0 Then  ' if the curr view is best fit
        igPageDisp.Layout.FitMode = IG_DSPL_FIT_TO_DEVICE
        ' update the view control to repaint the page
        IGPageViewCtl1.UpdateView
    ElseIf m_CurrView = 1 Then  'if the curr view is to width
        igPageDisp.Layout.FitMode = IG_DSPL_FIT_TO_WIDTH
        ' update the view control to repaint the page
        IGPageViewCtl1.UpdateView
    ElseIf m_CurrView = 2 Then  'if the curr view is to height
        igPageDisp.Layout.FitMode = IG_DSPL_FIT_TO_HEIGHT
        ' update the view control to repaint the page
        IGPageViewCtl1.UpdateView
    ElseIf m_CurrView = 3 Then  'if the curr view is to zoom level
        igPageDisp.Layout.FitMode = IG_DSPL_ACTUAL_SIZE
         ' update the view control to repaint the page
        IGPageViewCtl1.UpdateView
        

    End If
    PropertyChanged "CurrView"
    Set zoomzoom = igPageDisp.GetZoomInfo(IGPageViewCtl1.hWnd)
    ZoomLevel = zoomzoom.HZoom / 0.01
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get ZoomLevel() As Integer
    ZoomLevel = m_ZoomLevel
End Property

Public Property Let ZoomLevel(ByVal New_ZoomLevel As Integer)
    'check to make sure the zoomlevel is valid
    m_ZoomLevel = New_ZoomLevel
    
    Dim zoomzoom As IGDisplayZoomInfo
    Set zoomzoom = igPageDisp.GetZoomInfo(IGPageViewCtl1.hWnd)
    
    ' update zoom object with new values
    zoomzoom.HZoom = 0.01 * New_ZoomLevel 'zoomzoom.HZoom * 1.25
    zoomzoom.VZoom = 0.01 * New_ZoomLevel 'zoomzoom.VZoom * 1.25
    zoomzoom.Mode = IG_DSPL_ZOOM_H_FIXED Or IG_DSPL_ZOOM_V_FIXED
    ' set the zoom object
    igPageDisp.UpdateZoomFrom zoomzoom
    ' update the view control to repaint the page
    IGPageViewCtl1.UpdateView
    
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get CopytoClipboard() As Boolean
    CopytoClipboard = m_CopytoClipboard
End Property

Public Property Let CopytoClipboard(ByVal New_CopytoClipboard As Boolean)
    m_CopytoClipboard = New_CopytoClipboard
    PropertyChanged "CopytoClipboard"
    'check to make sure new_copytoclipboard is true and there is an image displayed
    If New_CopytoClipboard = True Then
        'copy the image and annotations to the clipboard
        artPage.EditCopy 'copy to clipboard
    End If
    New_CopytoClipboard = False 'set the copy to false
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get ClearAnnotations() As Boolean
    ClearAnnotations = m_ClearAnnotations
End Property

Public Property Let ClearAnnotations(ByVal New_ClearAnnotations As Boolean)
    m_ClearAnnotations = New_ClearAnnotations
    PropertyChanged "ClearAnnotations"
    'check to make sure clear is true and image has been displayed
        Dim count As Integer
        Dim i As Long
        If IsValidEnv() Then
        
            i = artPage.MarkFirst
            Do While i <> -1 'loop through all of the marks
                artPage.markSelect i, True
                i = artPage.MarkNext(i)
            Loop
        End If
        If IsValidEnv() Then
            HandleEditDelete
        End If
        ImageChanged = False    'image changed is now false (not changed)

    New_ClearAnnotations = False
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,0
Public Property Get LineColor() As OLE_COLOR
    LineColor = m_LineColor
End Property

Public Property Let LineColor(ByVal New_LineColor As OLE_COLOR)
    m_LineColor = New_LineColor
    PropertyChanged "LineColor"
    Dim RGBvalue As Long
    TranslateColor New_LineColor, 0, RGBvalue 'translate from OLE_COLOR to RGB
    ' set the values
    artPage.GlobalAttrForeColor.RGB_B = CStr((RGBvalue And &HFF0000) / 2 ^ 16)
    artPage.GlobalAttrForeColor.RGB_G = CStr((RGBvalue And &HFF00&) / 2 ^ 8)
    artPage.GlobalAttrForeColor.RGB_R = CStr(RGBvalue And &HFF&)
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get LineWidth() As Integer
    LineWidth = m_LineWidth
End Property

Public Property Let LineWidth(ByVal New_LineWidth As Integer)
    m_LineWidth = New_LineWidth
    PropertyChanged "LineWidth"
        artPage.GlobalAttrLineSize = New_LineWidth 'set the line width
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,0
Public Property Get FontColor() As OLE_COLOR
    FontColor = m_FontColor
End Property

Public Property Let FontColor(ByVal New_FontColor As OLE_COLOR)
    m_FontColor = New_FontColor
    PropertyChanged "FontColor"
   
    
    'ImgEdit1.AnnotationFontColor = New_FontColor 'set the font color
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get FontSize() As Integer
    FontSize = m_FontSize
End Property

Public Property Let FontSize(ByVal New_FontSize As Integer)
    m_FontSize = New_FontSize
    PropertyChanged "FontSize"
    ' check to make sure the font size is in the valid range
    If New_FontSize >= 0 And New_FontSize <= 2048 Then
        artPage.GlobalAttrFont.Size = New_FontSize 'set the font size
    End If
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=13,0,0,0
Public Property Get FontName() As String
    FontName = m_FontName
End Property

Public Property Let FontName(ByVal New_FontName As String)
    m_FontName = New_FontName
    PropertyChanged "FontName"
    If New_FontName <> "" Then 'make sure a value is passed
        artPage.GlobalAttrFont.Name = New_FontName 'set the font name
    End If
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,0
Public Property Get FillColor() As OLE_COLOR
    FillColor = m_FillColor
End Property

Public Property Let FillColor(ByVal New_FillColor As OLE_COLOR)
    m_FillColor = New_FillColor
    PropertyChanged "FillColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14,0,0,0
Public Property Get CurrStyle() As PossibleAnnotationStyle ' As Variant
    CurrStyle = m_CurrStyle
End Property

Public Property Let CurrStyle(ByVal New_CurrStyle As PossibleAnnotationStyle) ' As Variant)
    m_CurrStyle = New_CurrStyle
    PropertyChanged "CurrStyle"
    If New_CurrStyle = Opaque Then 'if the style is opaque
        artPage.GlobalAttrHighlight = False
    Else 'the style is transparent
        artPage.GlobalAttrHighlight = True
    End If
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Bold() As Boolean
    Bold = m_Bold
End Property

Public Property Let Bold(ByVal New_Bold As Boolean)
    m_Bold = New_Bold
    PropertyChanged "Bold"
    artPage.GlobalAttrFont.Bold = New_Bold 'set the bold value
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Italic() As Boolean
    Italic = m_Italic
End Property

Public Property Let Italic(ByVal New_Italic As Boolean)
    m_Italic = New_Italic
    PropertyChanged "Italic"
    artPage.GlobalAttrFont.Italic = New_Italic 'set italic
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Strikethrough() As Boolean
    Strikethrough = m_Strikethrough
End Property

Public Property Let Strikethrough(ByVal New_Strikethrough As Boolean)
    m_Strikethrough = New_Strikethrough
    PropertyChanged "Strikethrough"
    artPage.GlobalAttrFont.Strikethrough = New_Strikethrough 'set strikethrough
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Underline() As Boolean
    Underline = m_Underline
End Property

Public Property Let Underline(ByVal New_Underline As Boolean)
    m_Underline = New_Underline
    PropertyChanged "Underline"
    artPage.GlobalAttrFont.Underline = New_Underline 'set underline
End Property

Private Function LoadImage(Filename As String)
    Dim bEnable As Boolean
    bEnable = False

    Dim dialogLoadOptions As IGFileDlgPageLoadOptions
    Set dialogLoadOptions = IGDlgsCtl1.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGELOADOBJ)
        ' load the page specified by dialog filename
        ' reset some of the global sample variables, set them again in a moment
        dialogLoadOptions.Filename = Filename
        CurIGPage.Clear
        Set ioLocation = Nothing
        currentPageNumber = -1
        totalLocationPageCount = 0
        
        ' create io location object used to read in page count
        ' if file read successful, it will be used elsewhere (format info dialog)
        Set ioLocation = IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_IOFILE)
        ioLocation.Filename = dialogLoadOptions.Filename
        
        ' load the image (could use loadpage here but want to demonstrate loadpagefromfile instead)
        IGFormatsCtl1.LoadPageFromFile CurIGPage, dialogLoadOptions.Filename, dialogLoadOptions.PageNum
        ' no need to create new display for the page since one already exists
        
        ' set the current and total page numbers (sample global)
        currentPageNumber = dialogLoadOptions.PageNum
        totalLocationPageCount = IGFormatsCtl1.GetPageCount(ioLocation, IG_FORMAT_UNKNOWN)
        'Set initial gamma/brightness/contrast values
        curGamma = 1
        curContrast = 1
        curBrightness = 0
        
        If Not CurIGPage Is Nothing Then
            bEnable = CurIGPage.IsValid
        End If

        ' update the view control to repaint the new active page
        IGPageViewCtl1.UpdateView
        
        If bEnable Then
        
            Set artPage = IGArtCtl1.CreateArtPage(CurIGPage, igPageDisp, IGPageViewCtl1.hWnd)
            
        End If
End Function

Private Sub SetGlobalMarkType(newType As enumIGArtMarkType)
    If IsValidEnv() Then
        artPage.GlobalAttrMarkType = newType 'set the annotation tool type
'        IGArtCtl1.ToolBarButtonCheck artPage.GlobalAttrMarkType, True
    End If
End Sub

Private Function IsValidEnv() As Boolean
    Dim bRetVal As Boolean
    bRetVal = False
    If (Not artPage Is Nothing) And CurIGPage.IsValid Then
        bRetVal = True
    End If
    IsValidEnv = bRetVal
End Function
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Undo() As Boolean
    Undo = m_Undo
End Property

Public Property Let Undo(ByVal New_Undo As Boolean)
    m_Undo = New_Undo
    PropertyChanged "Undo"
    If New_Undo = True Then
        If IsValidEnv() Then
            artPage.EditUndo 'undo last change
        End If
        IGPageViewCtl1.UpdateView 'update the view
    End If
    New_Undo = False
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get SelectAll() As Boolean
    SelectAll = m_SelectAll
End Property

Public Property Let SelectAll(ByVal New_SelectAll As Boolean)
    m_SelectAll = New_SelectAll
    PropertyChanged "SelectAll"
    Dim i As Long
    If IsValidEnv() Then
    
        i = artPage.MarkFirst
        Do While i <> -1 'loop through all marks
            artPage.markSelect i, True 'select mark
            i = artPage.MarkNext(i)
        Loop
    End If
    m_SelectAll = False
End Property

