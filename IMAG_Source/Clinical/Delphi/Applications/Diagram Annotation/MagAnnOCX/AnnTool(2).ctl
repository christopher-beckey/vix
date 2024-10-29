VERSION 5.00
Object = "{6D940288-9F11-11CE-83FD-02608C3EC08A}#2.2#0"; "imgedit.ocx"
Begin VB.UserControl AnnTool 
   ClientHeight    =   4920
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7200
   ScaleHeight     =   4920
   ScaleWidth      =   7200
   Begin ImgeditLibCtl.ImgEdit ImgEdit1 
      Height          =   1695
      Left            =   1560
      TabIndex        =   0
      Top             =   960
      Width           =   1335
      _Version        =   131074
      _ExtentX        =   2355
      _ExtentY        =   2990
      _StockProps     =   96
      BorderStyle     =   1
      ImageControl    =   "ImgEdit"
      UndoBufferSize  =   76588288
      OcrZoneVisibility=   -3516
      AnnotationOcrType=   25801
      ForceFileLinking1x=   -1  'True
      MagnifierZoom   =   25801
      sReserved1      =   -3516
      sReserved2      =   -3516
      lReserved1      =   1241728
      lReserved2      =   1241728
      bReserved1      =   -1  'True
      bReserved2      =   -1  'True
   End
End
Attribute VB_Name = "AnnTool"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Dim InitialPoint As point ' the initial mouse point for clicks
Dim TerminatePoint As point ' the terminating point for mouse clicks

Public Version As String 'variable that holds the annotationOCX version


'enumerated type for the possible tools the user may use
Public Enum PossibleTools
NoTool = 0
Pointer = 1
FreehandLine = 2
StraightLine = 4
HollowRectangle = 5
FilledRectangle = 6
TypedText = 7
Arrow = 8
Plus = 9
Minus = 10
End Enum

' enumerated type for the possible color options to save the image as
Public Enum ColorTypes
BlackAndWhite = 1
Gray16 = 2
Gray256 = 3
Color16 = 4
Color256 = 5
Color24Bit = 6
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
Public CurrColorType As ColorTypes
Dim CurrMark As String
Dim ArrowCount As Long
Dim PlusCount As Long

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
        ImageChanged = False 'set the image changed to false
        ImgEdit1.Image = New_OpenFile 'open the image
        ImgEdit1.Display 'display the image
        ImgEdit1.AutoRefresh = True 'set autorefresh to true
        ImgEdit1.Zoom = 100 'set the zoom to 100%
        ZoomLevel = 100 ' set the zoom level
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
    'check to make sure the file is valid
    If New_SaveFile <> "" Then
        Dim pType As Integer 'holds the page type
        Dim cType As Integer 'holds the compression
        If CurrColorType = BlackAndWhite Then
            pType = 1 ' set for a color type 1
            cType = 3 ' set the compression to Group3(Modified Huffman)
        ElseIf CurrColorType = Gray16 Then
            pType = 2 ' set for a color type 2
            cType = 9 ' set the compression to LZW
        ElseIf CurrColorType = Gray256 Then
            pType = 3 ' set for a color type 3
            cType = 9 ' set the compression to LZW
        ElseIf CurrColorType = Color16 Then
            pType = 4 ' set for a color type 4
            cType = 9 ' set the compression to LZW
        ElseIf CurrColorType = Color256 Then
            pType = 5 ' set for a color type 5
            cType = 9 ' set the compression to LZW
        ElseIf CurrColorType = Color24Bit Then
            pType = 6 ' set for a color type 6
            cType = 9 ' set the compression to LZW
        End If
        If BurnFile = True Then 'check to see if the user wants to burn the annotations
            ImgEdit1.ConvertPageType pType ' convert the image to the correct format
            ImgEdit1.BurnInAnnotations 0, 2 'burn the annotations
        End If
        
        ' Save the file using the correct compression and file type
'        ImgEdit1.SaveAs New_SaveFile, 1, pType, cType
        If CurrColorType = BlackAndWhite Then
            ImgEdit1.SaveAs New_SaveFile, 1, pType, cType
        ElseIf CurrColorType = Color24Bit Then
            ImgEdit1.SaveAs New_SaveFile, 6, pType, 6, 512
        End If
        
        
        
    End If
    Exit Property
sErrHand:
LastError = "Unable to save file " & New_SaveFile

    
'-----------------------NOTE ABOUT SAVEFILE PROPERTY!!!!-----------------------
'When you use the savefile property, after saving the image, the image you are working on is the old image!
'You will not be working on your new image after the savefile property is called.  '
'If you annotate file1 and call the savefile property to save it as file2, and then you continue annotating,
'you will still be working on file1, not file2.  This "problem" could be solved be having the annotation
'program reopen the new saved image after the save property is called.  At the moment, this is not a problem
'because the annotation program will be set to automatically close after the image is saved.  Also, at the
'moment, the user will not be saving the image directly, the code will do it in the background.
    
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
        ImgEdit1.AnnotationType = wiStraightLine 'set the annotation type property
        ArrowCount = ArrowCount + 1 'increment the arrow count
        ImgEdit1.AddAnnotationGroup "Arrow" & ArrowCount ' create a new annotation group for the arrow
        ImgEdit1.MousePointer = wiMPUpArrow ' set the mouse pointer to the arrow
    ElseIf New_currTool = FilledRectangle Then 'if the tool selected is filled rectangle
        ImgEdit1.AnnotationType = wiFilledRect 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPFilledRect 'set the mouse pointer to filled rectangle
    ElseIf New_currTool = FreehandLine Then 'if the tool selected is freehand line
        ImgEdit1.AnnotationType = wiFreehandLine 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPFreehandLine 'set the mouse pointer to freehand line
    ElseIf New_currTool = HollowRectangle Then 'if the tool selected is hollow rectangle
        ImgEdit1.AnnotationType = wiHollowRect 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPHollowRect 'set the mouse pointer to hollow rectangle
    ElseIf New_currTool = Minus Then 'if the tool selected is minus
        ImgEdit1.AnnotationType = wiStraightLine 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPCross    '
    ElseIf New_currTool = NoTool Then 'if the tool selected is no tool
        ImgEdit1.AnnotationType = wiNone 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPNoDrop 'set the pointer to nothing
    ElseIf New_currTool = Plus Then 'if the tool selected is plus
        ImgEdit1.AnnotationType = wiStraightLine 'set the annotation type property
        PlusCount = PlusCount + 1 ' increment the plus counter
        ImgEdit1.AddAnnotationGroup "Plus" & PlusCount 'create a new annotation group for the plus sign
        ImgEdit1.MousePointer = wiMPCross 'set the pointer to the cross
    ElseIf New_currTool = Pointer Then 'if the tool selected is pointer
        ImgEdit1.AnnotationType = wiAnnotationSelection 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPArrow '= wiMPDefault
    ElseIf New_currTool = StraightLine Then 'if the tool selected is straight line
        ImgEdit1.AnnotationType = wiStraightLine 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPSelect ' = wiMPCross
    ElseIf New_currTool = TypedText Then 'if the tool selected is typed text
        ImgEdit1.AnnotationType = wiText 'set the annotation type property
        ImgEdit1.AddAnnotationGroup "NONE" ' set the group to NONE
        ImgEdit1.MousePointer = wiMPText 'set the mouse pointer to text
    End If
    LastError = ImgEdit1.GetCurrentAnnotationGroup 'set the last error

End Property


'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get ClearDisplay() As Boolean
    ClearDisplay = m_ClearDisplay
End Property

Public Property Let ClearDisplay(ByVal New_ClearDisplay As Boolean)
    m_ClearDisplay = New_ClearDisplay
    PropertyChanged "ClearDisplay"
    'check to see if the clear display is true and if an image is displayed
    If New_ClearDisplay = True And ImgEdit1.ImageDisplayed = True Then
        ImgEdit1.ClearDisplay 'clear the display
        ImageChanged = False 'set the image changed value to false
    End If
    m_ClearDisplay = False
End Property

Private Sub ImgEdit1_KeyDown(KeyCode As Integer, Shift As Integer)
' if the user presses the delete key and an image is displayed
If KeyCode = 46 And ImgEdit1.ImageDisplayed = True Then
    DeleteSelectedAnnotation 'call the function to delete the annotation group
End If
End Sub

Public Function DeleteSelectedAnnotation()
If ImgEdit1.ImageDisplayed = True Then 'ensure there is an image displayed
On Error Resume Next
    ' if the current annotation is an arrow or a plus
    If Mid(CurrMark, 1, 5) = "Arrow" Or Mid(CurrMark, 1, 4) = "Plus" Then
        ImgEdit1.DeleteAnnotationGroup CurrMark ' delete the group
    Else
        ImgEdit1.DeleteSelectedAnnotations  ' delete the selected annotations
    End If
End If

End Function


Private Sub ImgEdit1_MarkEnd(ByVal Left As Long, ByVal Top As Long, ByVal Width As Long, ByVal Height As Long, ByVal MarkType As Integer, ByVal GroupName As String)
If MarkType = 7 Or MarkType = 11 Then Exit Sub
'If CurrTool <> Pointer And CurrTool <> TypedText Then
    ImgEdit1.SelectAnnotationGroup "GROUPTHATDOESNOTEXIST"
'End If
End Sub

Private Sub ImgEdit1_MarkMove(ByVal MarkType As Integer, ByVal GroupName As String)
If Mid(GroupName, 1, 4) = "Plus" Then
    ImgEdit1.DeleteAnnotationGroup GroupName
    xPoint = TerminatePoint.x / Screen.TwipsPerPixelX 'determine the x coordinate
    yPoint = TerminatePoint.y / Screen.TwipsPerPixelY   'determine the y coordinate

    LastError = TerminatePoint.x & ", " & TerminatePoint.y 'set the last error

    PlusCount = PlusCount + 1 'increment the plus count
    ImgEdit1.AddAnnotationGroup "Plus" & PlusCount 'create a new annotation group for the plus
    Dim aType As Integer 'variable to hold the current annotation type
    aType = ImgEdit1.AnnotationType 'get the annotation type
    ImgEdit1.AnnotationType = wiStraightLine
    ImgEdit1.Draw xPoint - 15, yPoint, 30, 0    'draw the first line
    ImgEdit1.Draw xPoint, yPoint - 15, 0, 30    'draw the second line
    ImgEdit1.AnnotationType = aType 'reset the annotation type

End If
End Sub

Private Sub ImgEdit1_MarkSelect(ByVal Button As Integer, ByVal Shift As Integer, ByVal Left As Long, ByVal Top As Long, ByVal Width As Long, ByVal Height As Long, ByVal MarkType As Integer, ByVal GroupName As String)
CurrMark = GroupName 'set the current mark group
End Sub

Private Sub ImgEdit1_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
ImageChanged = ImgEdit1.ImageModified   ' set the imagechanged variable to the imagemodified value
If CurrTool = Arrow Then    'if the current tool is arrow
    InitialPoint.x = x  ' set the x coordinate of the initial point
    InitialPoint.y = y  ' set the y coordinate of the initial point
End If

If Button = 2 Then 'if the user right clicks
    CurrTool = Pointer 'set the tool to the pointer
End If

End Sub

Private Sub ImgEdit1_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
TerminatePoint.x = x    ' set the terminating point to x
TerminatePoint.y = y    ' set the terminating point to y
End Sub

Private Sub ImgEdit1_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
ImageChanged = ImgEdit1.ImageModified   ' set the image changed value
If ImgEdit1.ImageDisplayed = False Then ' if no image is displayed
    Exit Sub    'exit the sub
End If
If CurrTool = Arrow Then    ' if the current tool is an arrow
    If distance(InitialPoint, TerminatePoint) <= 0# Then 'check for distance of 0
        Exit Sub 'if the distance is <= 0, exit sub
    End If
    
    PI = 3.14159    'set PI
    
    Dim init As point ' make an initial point
    Dim term As point 'make a terminating point
    init.x = InitialPoint.x ' set the initial x
    init.y = InitialPoint.y 'set the initial y
    term.x = TerminatePoint.x ' set the terminating x
    term.y = TerminatePoint.y 'set the terminating y

    Dim vec As point ' create a vector
    vec = findHalfArrow(init, term, 135) ' find the coordinates for the first line
    Dim vec2 As point
    vec2 = findHalfArrow(init, term, 225) ' find the coordinates for the second line
    
    Dim xPoint As Long  'create a x point
    Dim yPoint As Long  'create a y point
    
    xPoint = (term.x + vec.x) / Screen.TwipsPerPixelX 'determine the x coordinate
    yPoint = (term.y + vec.y) / Screen.TwipsPerPixelY 'determine the y coordinate
    
    Dim deltX As Long ' variable for the change in x
    Dim deltY As Long 'variable for the change in y
    deltX = (term.x / Screen.TwipsPerPixelX) - xPoint 'determine the x change
    deltY = (term.y / Screen.TwipsPerPixelY) - yPoint 'determine the y change
    
    ImgEdit1.Draw xPoint, yPoint, deltX, deltY  'draw the first line
    
    xPoint = (term.x + vec2.x) / Screen.TwipsPerPixelX  'determine the 2nd x coordinate
    yPoint = (term.y + vec2.y) / Screen.TwipsPerPixelY  'determine the 2nd y coordinate
    
    deltX = (term.x / Screen.TwipsPerPixelX) - xPoint 'determine the x change
    deltY = (term.y / Screen.TwipsPerPixelY) - yPoint 'determine the y change
    
    ImgEdit1.Draw xPoint, yPoint, deltX, deltY  'draw the second line
    
    ArrowCount = ArrowCount + 1
    ImgEdit1.AddAnnotationGroup "Arrow" & ArrowCount
    
ElseIf CurrTool = Plus Then ' if the current tool is a plus
    xPoint = TerminatePoint.x / Screen.TwipsPerPixelX 'determine the x coordinate
    yPoint = TerminatePoint.y / Screen.TwipsPerPixelY   'determine the y coordinate
    
    ImgEdit1.Draw xPoint - 15, yPoint, 30, 0    'draw the first line
    ImgEdit1.Draw xPoint, yPoint - 15, 0, 30    'draw the second line
    
    PlusCount = PlusCount + 1
    ImgEdit1.AddAnnotationGroup "Plus" & PlusCount

ElseIf CurrTool = Minus Then    ' if the current tool is a minus
    xPoint = TerminatePoint.x / Screen.TwipsPerPixelX   'determine the x coordinate
    yPoint = TerminatePoint.y / Screen.TwipsPerPixelY   'determine the y coordinate
    
    ImgEdit1.Draw xPoint - 15, yPoint, 30, 0    'draw the line

End If
End Sub

Private Sub UserControl_Initialize()
' set the version variable to the applications version
Version = App.Major & "." & App.Minor & "." & App.Revision
BurnFile = False    'set the burn file to false
CurrColorType = BlackAndWhite
ImgEdit1.AnnotationLineStyle = wiOpaque ' set the style to opaque
ImgEdit1.AnnotationFillStyle = wiOpaque 'set the fill style to opaque
ImgEdit1.AnnotationType = wiAnnotationSelection ' set the annotation type to pointer
ArrowCount = 0
PlusCount = 0
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
End Sub

Private Sub UserControl_Resize()
'set the resize for the image to fill the screen
ImgEdit1.Left = UserControl.ScaleLeft
ImgEdit1.Top = UserControl.ScaleTop
ImgEdit1.Width = UserControl.ScaleWidth
ImgEdit1.Height = UserControl.ScaleHeight

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
    If New_DeleteCurrAnnotation = True And ImgEdit1.ImageDisplayed = True Then
        If Mid(CurrMark, 1, 5) = "Arrow" Or Mid(CurrMark, 1, 4) = "Plus" Then
            ImgEdit1.DeleteAnnotationGroup CurrMark
        Else
            ImgEdit1.DeleteSelectedAnnotations  ' delete the selected annotations
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
    
    If m_CurrView = 0 Then  ' if the curr view is best fit
        ImgEdit1.FitTo 0, True  'set the view
        ZoomLevel = ImgEdit1.Zoom   'set the zoom level
    ElseIf m_CurrView = 1 Then  'if the curr view is to width
        ImgEdit1.FitTo 1, True  ' set the view
        ZoomLevel = ImgEdit1.Zoom   'set the zoom level
    ElseIf m_CurrView = 2 Then  'if the curr view is to height
        ImgEdit1.FitTo 2, True  'set the view
        ZoomLevel = ImgEdit1.Zoom   'set the zoom level
    ElseIf m_CurrView = 3 Then  'if the curr view is to zoom level
        ZoomLevel = 100 ' set the zoom
    End If
    PropertyChanged "CurrView"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get ZoomLevel() As Integer
    ZoomLevel = m_ZoomLevel
End Property

Public Property Let ZoomLevel(ByVal New_ZoomLevel As Integer)
    'check to make sure the zoomlevel is valid
    If New_ZoomLevel > 2 And New_ZoomLevel < 6553 Then
        m_ZoomLevel = New_ZoomLevel
        PropertyChanged "ZoomLevel"
        ImgEdit1.Zoom = New_ZoomLevel   'set the zoom level
    End If
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
    If New_CopytoClipboard = True And ImgEdit1.ImageDisplayed = True Then
        ImgEdit1.BurnInAnnotations 0, 2 'burn the annotations to the image
        'copy the image and annotations to the clipboard
        ImgEdit1.ClipboardCopy 0, 0, ImgEdit1.ImageScaleWidth, ImgEdit1.ImageScaleHeight
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
    If New_ClearAnnotations = True And ImgEdit1.ImageDisplayed = True Then
        ImgEdit1.Display 'clears all unsaved annotations
        ImageChanged = False    'image changed is now false (not changed)
    End If
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
    ImgEdit1.AnnotationLineColor = New_LineColor 'set the line color
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get LineWidth() As Integer
    LineWidth = m_LineWidth
End Property

Public Property Let LineWidth(ByVal New_LineWidth As Integer)
    m_LineWidth = New_LineWidth
    PropertyChanged "LineWidth"
    ' check to make sure the line width is in the valid range
    If New_LineWidth >= 1 And New_LineWidth <= 999 Then ' error checking for valid range
        ImgEdit1.AnnotationLineWidth = New_LineWidth    'set the line width
    End If
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,0
Public Property Get FontColor() As OLE_COLOR
    FontColor = m_FontColor
End Property

Public Property Let FontColor(ByVal New_FontColor As OLE_COLOR)
    m_FontColor = New_FontColor
    PropertyChanged "FontColor"
    ImgEdit1.AnnotationFontColor = New_FontColor 'set the font color
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
        ImgEdit1.AnnotationFont.Size = New_FontSize 'set the font size
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
    ImgEdit1.AnnotationFont.Name = New_FontName 'set the font name
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,0
Public Property Get FillColor() As OLE_COLOR
    FillColor = m_FillColor
End Property

Public Property Let FillColor(ByVal New_FillColor As OLE_COLOR)
    m_FillColor = New_FillColor
    PropertyChanged "FillColor"
    ImgEdit1.AnnotationFillColor = New_FillColor 'set the fill color
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
        ImgEdit1.AnnotationFillStyle = wiOpaque 'set the fill style
        ImgEdit1.AnnotationLineStyle = wiOpaque 'set the line style
    Else 'the style is translucent
        ImgEdit1.AnnotationFillStyle = wiTransparent 'set the fill style
        ImgEdit1.AnnotationLineStyle = wiTransparent 'set the line style
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
    ImgEdit1.AnnotationFont.Bold = New_Bold 'set the bold property
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Italic() As Boolean
    Italic = m_Italic
End Property

Public Property Let Italic(ByVal New_Italic As Boolean)
    m_Italic = New_Italic
    PropertyChanged "Italic"
    ImgEdit1.AnnotationFont.Italic = New_Italic 'set the italic property
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Strikethrough() As Boolean
    Strikethrough = m_Strikethrough
End Property

Public Property Let Strikethrough(ByVal New_Strikethrough As Boolean)
    m_Strikethrough = New_Strikethrough
    PropertyChanged "Strikethrough"
    ImgEdit1.AnnotationFont.Strikethrough = New_Strikethrough 'set the strikethrough property
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get Underline() As Boolean
    Underline = m_Underline
End Property

Public Property Let Underline(ByVal New_Underline As Boolean)
    m_Underline = New_Underline
    PropertyChanged "Underline"
    ImgEdit1.AnnotationFont.Underline = New_Underline 'set the underline property
End Property

