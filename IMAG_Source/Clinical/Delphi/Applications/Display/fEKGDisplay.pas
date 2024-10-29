Unit FEKGDisplay;
{
  Package: EKG Display
  Date Created: 06/05/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  Description: Main form for Displaying EGKs from MUSE Servers
}
{$DEFINE P8}
{DEFINE P33}
{DEFINE StandAlone}
Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  Menus,
  ComCtrls,
  Printers,
  Stdctrls,
  Inifiles,
  Hash,
  DMuseConnection,
  cLoadTestThread,
  cMuseTest,
  cEkgOverlay,
//  DMagMuseDemoConnection,
  Umagutils8,
  Magguini,
  FEKGDisplayOptions,
  UMagClasses

  {$IFDEF P8},
  ImagDMinterface //DmSingle
  {$ENDIF}

  {$IFDEF P33},
  //MagBroker
  {$ENDIF}

  {$IFNDEF P33},
  ImagInterfaces,
  cMagDBBroker,
  ImgList,
  ToolWin{$ENDIF}

  {$IFDEF StandAlone},
  VERGENCECONTEXTORLib_TLB,
  ImgList,
  ToolWin{$ENDIF}
  ;
//Uses Vetted 20090929:cMagPat, MuseDeclarations, Trpcb, OleCtrls, ImgList, ToolWin, Buttons,
Type
  TEKGDisplayForm = Class(TForm)
    ToolBar1: TToolBar;
    TestButton: TToolButton;
    TrkbrZoom: TTrackBar;
    LvwTest: TListView;
    btnSelectTest: TToolButton;
    PnlContent: Tpanel;
    btnPrint: TToolButton;
    btnLockedScroll: TToolButton;
    btnOverlay: TToolButton;
    btnGrid: TToolButton;
    ImglstToolbarImages: TImageList;
    btnFitHeight: TToolButton;
    btnFitWidth: TToolButton;
    LblZoom: Tlabel;
    LblCurrentZoom: Tlabel;
    ToolButton4: TToolButton;
    EdtCurrentPage: TEdit;
    LblPageCount: Tlabel;
    btnFirstPage: TToolButton;
    btnPreviousPage: TToolButton;
    btnLastPage: TToolButton;
    btnNextPage: TToolButton;
    ToolButton10: TToolButton;
    btnOptions: TToolButton;
    btnNextTest: TToolButton;
    btnPreviousTest: TToolButton;
    Label1: Tlabel;
    LblStudy: Tlabel;
    btnStudySeparator: TToolButton;
    ToolButton5: TToolButton;
    MnuMainMenu: TMainMenu;
    MnuFile: TMenuItem;
    MnuHelp: TMenuItem;
    MnuRefresh: TMenuItem;
    MnuHelp2: TMenuItem;
    MnuAbout: TMenuItem;
    btnFirstTest: TToolButton;
    btnLastTest: TToolButton;
    MnuClose: TMenuItem;
    LblSpacer: Tlabel;
    btnTextOverlay: TToolButton;
    btnReset: TToolButton;
    ImgGrid: TImage;
    ImgDottedGrid: TImage;
    MnuPrint: TMenuItem;
    MnuSettings: TMenuItem;
    MnuTools: TMenuItem;
    MnuToggleGrid: TMenuItem;
    MnuToggleTextOverlay: TMenuItem;
    MnuFitHeight: TMenuItem;
    MnuFitWidth: TMenuItem;
    MnuReset: TMenuItem;
    MnuFirstPage: TMenuItem;
    MnuNextPage: TMenuItem;
    MnuPreviousPage: TMenuItem;
    MnuLastPage: TMenuItem;
    MnuFirstStudy: TMenuItem;
    MnuPreviousStudy: TMenuItem;
    MnuNextStudy: TMenuItem;
    MnuLastStudy: TMenuItem;
    MnuLockScrolling: TMenuItem;
    GotoMainWindow1: TMenuItem;
    N1: TMenuItem;
    ActiveForms1: TMenuItem;

    Procedure FormCreate(Sender: Tobject);
    Procedure TrkbrZoomChange(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure btnGridClick(Sender: Tobject);
    Procedure btnSelectTestClick(Sender: Tobject);
    Procedure LvwTestChange(Sender: Tobject; Item: TListItem; Change: TItemChange);
    Procedure PnlContentResize(Sender: Tobject);
    Procedure TestScrollHorizontal(Sender: Tobject);
    Procedure TestScrollVertical(Sender: Tobject);
    Procedure ScrollBoxChange(Sender: TMuseTest; Kind: TScrollBarKind);
    Procedure btnPrintClick(Sender: Tobject);
    Procedure btnOverlayClick(Sender: Tobject);
    Procedure LvwTestCompare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure LvwTestColumnClick(Sender: Tobject;
      Column: TListColumn);
    Procedure btnFitWidthClick(Sender: Tobject);
    Procedure btnFitHeightClick(Sender: Tobject);
    Procedure LvwTestDblClick(Sender: Tobject);
    Procedure btnFirstPageClick(Sender: Tobject);
    Procedure btnPreviousPageClick(Sender: Tobject);
    Procedure btnLastPageClick(Sender: Tobject);
    Procedure btnNextPageClick(Sender: Tobject);
    Procedure btnOptionsClick(Sender: Tobject);
    Procedure btnPreviousTestClick(Sender: Tobject);
    Procedure btnNextTestClick(Sender: Tobject);
    Procedure EdtCurrentPageChange(Sender: Tobject);
    Procedure MnuRefreshClick(Sender: Tobject);
    Procedure btnFirstTestClick(Sender: Tobject);
    Procedure btnLastTestClick(Sender: Tobject);
    Procedure MnuCloseClick(Sender: Tobject);
    Procedure ToolBar1Resize(Sender: Tobject);
    Procedure btnTextOverlayClick(Sender: Tobject);
    Procedure btnResetClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure MnuPrintClick(Sender: Tobject);
    Procedure MnuSettingsClick(Sender: Tobject);
    Procedure MnuToggleGridClick(Sender: Tobject);
    Procedure MnuToggleTextOverlayClick(Sender: Tobject);
    Procedure MnuLockScrollingClick(Sender: Tobject);
    Procedure btnLockedScrollClick(Sender: Tobject);
    Procedure MnuFitHeightClick(Sender: Tobject);
    Procedure MnuFitWidthClick(Sender: Tobject);
    Procedure MnuResetClick(Sender: Tobject);
    Procedure MnuFirstPageClick(Sender: Tobject);
    Procedure MnuPreviousPageClick(Sender: Tobject);
    Procedure MnuNextPageClick(Sender: Tobject);
    Procedure MnuLastPageClick(Sender: Tobject);
    Procedure MnuFirstStudyClick(Sender: Tobject);
    Procedure MnuPreviousStudyClick(Sender: Tobject);
    Procedure MnuNextStudyClick(Sender: Tobject);
    Procedure MnuLastStudyClick(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure MnuHelp2Click(Sender: Tobject);
    Procedure MnuAboutClick(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure ActiveForms1Click(Sender: Tobject);
  Private
{$IFNDEF P33}MagDBBroker1: TMagDBBroker;
{$ENDIF}
{$IFDEF StandAlone}ctxContextor: TContextorControl;
{$ENDIF}
    PatientID: String;
    MuseConnections: Tlist;
    LoadTestThread: TLoadTestThread;
    EKGOverlay: TEKGOverlay;
//    GridLandscapePicture, DottedGrid: TPicture;
    ColumnToSort: Integer;
    SortAscending: Bool;
    VisibleTestList: Tlist;

    Procedure DeleteFiles();
    Procedure FillTestsDropdown(TestList: Tlist);
    Procedure GetMuseSites();
    Procedure GetTestList();
    Procedure ClearPatient();
    Procedure ToggleButtons();
    Procedure TogglePagingButtons();
    Procedure Print();
    Procedure AddConnectionError(Conn: TMagMuseBaseConnection);
    Function StudiesExist(): Boolean;
    Procedure WMGetMinMaxInfo(Var Msg: TMessage); Message WM_GetMinMaxInfo;
  Public
    IsDemoMode: Boolean;

    Procedure TestLoaded(Sender: Tobject);
    Procedure AddMuseSite(Server, Volume, URL, Username, Password, Site, SiteID, Version: String);
    Procedure ChangePatient(Name, SSN: String);
{$IFDEF StandAlone}
    Procedure ctxContextorCommitted(Sender: Tobject);
    Procedure DefaultHandler(Var Message); Override;
{$ENDIF}
    Procedure ServerChanged();
  End;

Var
  EKGDisplayForm: TEKGDisplayForm;

Implementation

Uses
  FMagAbout,
  Umagdisplaymgr,
//  uMagDisplayUtils,
  umagUtils8A
  ;

{$R *.DFM}

{ local functions }
{
  These need to be local so that CompareMUSE_DATE can be used for sorting.
  Won't work as a method.
}

Function PaddedIntToStr(Num: Integer; StringLength: Integer): String;
{
  turn an 'n' digit number into an 'x' character string prepended
  with '0's as needed.
}
Var
  Temp: String;
Begin
  Temp := Inttostr(Num);
  While Length(Temp) < StringLength Do
    Temp := '0' + Temp;
  Result := Temp;
End;

Function BuildDateTimeString(Test: TMuseTest): String;
{
  build the date time string as YYYY/MM/DD HH:MM:DD
  so it will sort correctly
}
Begin
  Result := Inttostr(Test.TestInfo.AcqDate.Year)
    + '/' + PaddedIntToStr(Test.TestInfo.AcqDate.Month, 2)
    + '/' + PaddedIntToStr(Test.TestInfo.AcqDate.Day, 2)
    + ' '
    + PaddedIntToStr(Test.TestInfo.AcqTime.Hour, 2)
    + ':' + PaddedIntToStr(Test.TestInfo.AcqTime.Minute, 2)
    + ':' + PaddedIntToStr(Test.TestInfo.AcqTime.Second, 2);
End;

Function CompareMUSE_DATE(Item1, Item2: Pointer): Integer;
{
  the dates of the two tests
}
Var
  I1, I2: TMuseTest;
Begin
  I1 := Item1;
  I2 := Item2;
  Result := CompareStr(BuildDateTimeString(I1), BuildDateTimeString(I2));
End;

{ Event Handlers }

Procedure TEKGDisplayForm.FormCreate(Sender: Tobject);
{ Initialize custom properties }
Var
  Magini: TIniFile;
Begin
  // initialize some variables
{$IFDEF P8}MagDBBroker1 := idmodobj.GetMagDBBroker1;
{$ENDIF}
{$IFDEF StandAlone}
  MagDBBroker1 := TMagDBBroker.Create(Self);
  MagDBBroker1.CreateBroker();
{$ENDIF}
{$IFDEF StandAlone}
    // connect to the context
  Try
    ctxContextor := TContextorControl.Create(Self);
    ctxContextor.OnCommitted := ctxContextorCommitted;
    ctxContextor.Run('EKGDisplay', '', True, '*');
  Except
    Showmessage('Unable to connect to Context Manager.  Exiting Application.');
    Application.Terminate();
  End;
{$ENDIF}
  MuseConnections := Tlist.Create();
  LoadTestThread := TLoadTestThread.Create(True);
  // load settings stored in the ini file
  Magini := TIniFile.Create(GetConfigFileName);

  IsDemoMode := Uppercase(Magini.ReadString('Workstation Settings', 'MUSE Demo Mode', 'FALSE')) = 'TRUE';
  btnGrid.Down := Uppercase(Magini.ReadString('VISTAMUSE', 'GRIDON', 'TRUE')) = 'TRUE';
  If (btnGrid.Down) Then
    MnuToggleGrid.caption := 'Grid Off'
  Else
    MnuToggleGrid.caption := 'Grid On';
  btnTextOverlay.Down := Uppercase(Magini.ReadString('VISTAMUSE', 'TEXTOVERLAYON', 'TRUE')) = 'TRUE';
  If (btnTextOverlay.Down) Then
    MnuToggleTextOverlay.caption := 'Text Overlay Off'
  Else
    MnuToggleTextOverlay.caption := 'Text Overlay On';
  Magini.Free();
  // Overlay settings
  EKGOverlay := TEKGOverlay.Create(Self);
  EKGOverlay.Visible := False;
  EKGOverlay.Parent := Self;
  EKGOverlay.SetBounds(PnlContent.Left, PnlContent.Top, PnlContent.Width, PnlContent.Height);
  EKGOverlay.Anchors := [akLeft, akTop, akRight, akBottom];
  EKGOverlay.Grid.Picture := ImgGrid.Picture;
  LvwTest.BringToFront(); // Make sure this is ontop of the overlay screen
  VisibleTestList := Tlist.Create();
  // sorting for the test list view
  ColumnToSort := 0;
  SortAscending := True;
  // make sure the correct buttons are enabled
  ToggleButtons();
  // Resize this so it looks correct on different resolutions and dpi settings
  PnlContent.Left := 0;
  PnlContent.Top := ToolBar1.Height;
  PnlContent.Width := ClientWidth + 2;
  PnlContent.Height := ClientHeight - PnlContent.Top + 2;
  GetMuseSites();
{$IFDEF StandAlone}
    // automatically get the current patient
  ctxContextorCommitted(Self);
{$ENDIF}
  Application.BringToFront();
{$IFDEF  StandAlone}WMIdentifier := RegisterWindowMessage('VistA Event - Clinical');
{$ENDIF}
End;

Procedure TEKGDisplayForm.FormClose(Sender: Tobject; Var action: TCloseAction);
{ Save some settings and Pre shutdown cleanup }
Var
  Magini: TIniFile;
Begin
  // save settings
  Magini := TIniFile.Create(GetConfigFileName);
  If (btnGrid.Down) Then
    Magini.Writestring('VISTAMUSE', 'GRIDON', 'TRUE')
  Else
    Magini.Writestring('VISTAMUSE', 'GRIDON', 'FALSE');
  If (btnTextOverlay.Down) Then
    Magini.Writestring('VISTAMUSE', 'TEXTOVERLAYON', 'TRUE')
  Else
    Magini.Writestring('VISTAMUSE', 'TEXTOVERLAYON', 'FALSE');
  Magini.Free();
End;

Procedure TEKGDisplayForm.FormDestroy(Sender: Tobject);
Begin
{$IFDEF StandAlone}
  MagDBBroker1.Broker.Connected := False;
  MagDBBroker1.Free();
{$ENDIF}
  // Clean up the LoadTestThread
  LoadTestThread.Terminate();
  LoadTestThread.Resume();
  LoadTestThread.WaitFor();
  LoadTestThread.Free();
  // Clean up the other stuff
  EKGOverlay.Free();
  ClearPatient();
  VisibleTestList.Free();
  MuseConnections.Free();
End;

{$IFDEF StandAlone}

Procedure TEKGDisplayForm.DefaultHandler(Var Message);
// respond to winmsgs
Var
  Msg: TMessage;
Var
  Buffer: Array[0..255] Of Char;
Begin
  Inherited DefaultHandler(Message);
  Msg := TMessage(Message);
  GlobalGetAtomName(Msg.LParam, Buffer, 255);
  If (Msg.Msg = WMIdentifier) Then
  Begin
    If ((MagPiece(Strpas(Buffer), '^', 1) = 'END')
      And (MagPiece(Strpas(Buffer), '^', 2) = 'CPRS')) Then
      Close();
  End;
End;
{$ENDIF}

Procedure TEKGDisplayForm.PnlContentResize(Sender: Tobject);
{
  Loop through the visible tests and resize the test scroll
  boxes to fit them all in the content panel stacked
  vertically
}
Var
  i, TestHeight: Integer;
  Test: TMuseTest;
Begin
  If VisibleTestList.Count > 0 Then
  Begin
    TestHeight := PnlContent.ClientHeight Div VisibleTestList.Count;
    For i := 0 To (VisibleTestList.Count - 1) Do
    Begin
      Test := TMuseTest(VisibleTestList.Items[i]);
      Test.SetBounds(0, TestHeight * i, PnlContent.ClientWidth, TestHeight);
    End;
  End;
End;

Procedure TEKGDisplayForm.TrkbrZoomChange(Sender: Tobject);
{ Zoom in/out }
Var
  i: Integer;
  Test: TMuseTest;
Begin
  If VisibleTestList <> Nil Then
    {loop through and zoom the tests}
    For i := 0 To (VisibleTestList.Count - 1) Do
    Begin
      Test := TMuseTest(VisibleTestList[i]);
      Test.Zoom := TrkbrZoom.Position;
      // Trigger the resize event
      Test.ResizeImages();
    End;
  EKGOverlay.ResizeGrid(TrkbrZoom.Position);
  // update the current zoom label
  LblCurrentZoom.caption := Inttostr(TrkbrZoom.Position);
End;

Procedure TEKGDisplayForm.LvwTestChange(Sender: Tobject;
  Item: TListItem; Change: TItemChange);
{
  Handle events where the user selects/deselects items in
  the test listview.
}
Var
  Data: Tobject;
  Test: TMuseTest;
Begin
  Data := Item.Data;
  If Data Is TMuseTest Then
  Begin
    Test := TMuseTest(Data);
    If (Item.Selected) Then
    Begin
      If (VisibleTestList.Indexof(Test) < 0) Then
      Begin
        // this is not currently visible but has been selected
        // so make it visible and load it if necessary
        Try
          // add it to the content panel and the visible list
          PnlContent.InsertControl(Test);
          VisibleTestList.Add(Test);
          If (Not Test.Loaded) Then
          Begin
            // hasn't been loaded yet.
            // Tell the LoadTestThread to load it
            Test.Zoom := TrkbrZoom.Position;
            Test.OnLoad := TestLoaded;
            LoadTestThread.Load(Test);
          End;
        Except
          Exit;
        End;
        Test.GridOn := btnGrid.Down;
        Test.TextOverlayOn := btnTextOverlay.Down;
      End;
    End
    Else
    Begin
      {
        this has been deselected, so remove it from
        the content panel
      }
      If (Test.Parent <> Nil) Then
      Begin
        PnlContent.RemoveControl(Test);
        VisibleTestList.Remove(Test);
        Test.OnLoad := Nil;
      End;
      EKGOverlay.Remove(Test);
    End;
    If (LvwTest.Selcount = 1) Then
    Begin
      // set up the paging stuff if only one test is visible
      Test := TMuseTest(VisibleTestList.Items[0]);
      If (Test.Loaded) Then
        EdtCurrentPage.Text := Inttostr(Test.GetVisiblePageNumber())
      Else
        EdtCurrentPage.Text := '1';
      LblPageCount.caption := 'of ' + Inttostr(Test.TestFileInfo.Pages);
    End;
    // trigger resize so the tests will be sized and stacked appropriately
    PnlContentResize(Sender);
    ToggleButtons();
  End
  Else
    If ((Data Is TMuseConnection) And (Item.Selected)) Then
      Showmessage(TMuseConnection(Data).ErrorMessage);
End;

Procedure TEKGDisplayForm.btnGridClick(Sender: Tobject);
// loop through the tests and turn on/off the grids
Var
  Data: Tobject;
  i: Integer;
  Test: TMuseTest;
Begin
  For i := 0 To LvwTest.Items.Count - 1 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If (Data Is TMuseTest) Then
    Begin
      Test := TMuseTest(LvwTest.Items[i].Data);
      Test.GridOn := btnGrid.Down;
      Test.ResizeImages();
    End;
  End;
  EKGOverlay.Grid.Visible := btnGrid.Down;
  If (btnGrid.Down) Then
    MnuToggleGrid.caption := 'Grid Off'
  Else
    MnuToggleGrid.caption := 'Grid On';
End;

Procedure TEKGDisplayForm.btnTextOverlayClick(Sender: Tobject);
// loop through the tests and turn on/off the text overlay
Var
  Data: Tobject;
  i: Integer;
  Test: TMuseTest;
Begin
  For i := 0 To LvwTest.Items.Count - 1 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If (Data Is TMuseTest) Then
    Begin
      Test := TMuseTest(LvwTest.Items[i].Data);
      Test.TextOverlayOn := btnTextOverlay.Down;
      Test.ResizeImages();
    End;
  End;
  If (btnTextOverlay.Down) Then
    MnuToggleTextOverlay.caption := 'Text Overlay Off'
  Else
    MnuToggleTextOverlay.caption := 'Text Overlay On';
End;

Procedure TEKGDisplayForm.btnResetClick(Sender: Tobject);
// loop through the visible tests and move them to the top left
Var
  i: Integer;
  Test: TMuseTest;
Begin
  For i := 0 To VisibleTestList.Count - 1 Do
  Begin
    Test := TMuseTest(VisibleTestList[i]);
    Test.HorzScrollBar.Position := 0;
    Test.VertScrollBar.Position := 0;
    Test.UpdateLabels;
  End;
End;

Procedure TEKGDisplayForm.btnSelectTestClick(Sender: Tobject);
// hide/show the Test listview
Begin
  LvwTest.Visible := btnSelectTest.Down;
  If btnSelectTest.Down Then
    LvwTest.SetFocus();
End;

Procedure TEKGDisplayForm.TestScrollHorizontal(Sender: Tobject);
// event handler to catch when a test is scrolled
Begin
  ScrollBoxChange(TMuseTest(Sender), SbHorizontal);
End;

Procedure TEKGDisplayForm.TestScrollVertical(Sender: Tobject);
// event handler to catch when a test is scrolled
Begin
  ScrollBoxChange(TMuseTest(Sender), SbVertical);
End;

Procedure TEKGDisplayForm.ScrollBoxChange(Sender: TMuseTest; Kind: TScrollBarKind);
{
  if multiple scroll boxes are locked together, loop through
  all the tests and scroll them the same amount as the sender
  was scrolled
}
Var
  i, Delta: Integer;
  Test: TMuseTest;

Begin
  If btnLockedScroll.Enabled And btnLockedScroll.Down Then
  Begin
    If Kind = SbHorizontal Then
      Delta := Sender.HorzDelta
    Else
      Delta := Sender.VertDelta;

    For i := 0 To VisibleTestList.Count - 1 Do
    Begin
      Test := TMuseTest(VisibleTestList.Items[i]);
      If Test <> Sender Then
        Test.Scroll(Delta, Kind);
    End;
  End;
  // update the paging controls if only 1 test is being viewed
  If ((LvwTest.Selcount = 1)
    And (Kind = SbVertical)) Then
  Begin
    Test := TMuseTest(VisibleTestList.Items[0]);
    If (Test.Loaded) Then
    Begin
      EdtCurrentPage.Text := Inttostr(Test.GetVisiblePageNumber());
      TogglePagingButtons();
    End;
  End;
End;

Procedure TEKGDisplayForm.btnPrintClick(Sender: Tobject);
Begin
  Print();
End;

Procedure TEKGDisplayForm.btnOverlayClick(Sender: Tobject);
// overlay functionality is disabled for now
Begin
  EKGOverlay.Visible := btnOverlay.Down;
  PnlContent.Visible := Not btnOverlay.Down;
  If (EKGOverlay.Visible) Then
    EKGOverlay.ResizeGrid(TrkbrZoom.Position);
  ToggleButtons();
End;

Procedure TEKGDisplayForm.LvwTestColumnClick(Sender: Tobject;
  Column: TListColumn);
// sort if one of the columns is clicked
Begin
  If ColumnToSort = Column.Index Then
    SortAscending := Not SortAscending
  Else
    SortAscending := True;
  ColumnToSort := Column.Index;
  (Sender As TCustomListView).AlphaSort();
End;

Procedure TEKGDisplayForm.LvwTestCompare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
// do the sorting based on this compare function
Var
  Data1, Data2: Tobject;
  ItemNumber1, ItemNumber2: Integer;
Begin
  If ColumnToSort = 0 Then
  Begin
    ItemNumber1 := Strtoint(Item1.caption);
    ItemNumber2 := Strtoint(Item2.caption);
    If (ItemNumber1 > ItemNumber2) Then
      Compare := 1
    Else
      If ItemNumber1 < ItemNumber2 Then
        Compare := -1
      Else
        Compare := 0;
  End
  Else
    If ColumnToSort <> 2 Then
      Compare := CompareText(Item1.SubItems[ColumnToSort - 1], Item2.SubItems[ColumnToSort - 1])
    Else
    Begin
    // do a special compare for the date
      Data1 := Item1.Data;
      Data2 := Item2.Data;
      If Not (Data1 Is TMuseTest) Then
        Compare := -1
      Else
        If Not (Data2 Is TMuseTest) Then
          Compare := 1
        Else
          Compare := CompareText(BuildDateTimeString(TMuseTest(Data1)), BuildDateTimeString(TMuseTest(Data2)));
    End;
  If Not SortAscending Then
    Compare := Compare * -1;
End;

Procedure TEKGDisplayForm.btnFitWidthClick(Sender: Tobject);
// Change the zoom to 100% so it fills the width of the window
Begin
  TrkbrZoom.Position := 100;
End;

Procedure TEKGDisplayForm.btnFitHeightClick(Sender: Tobject);
{
  This is more complex than fit width.  Based on the width of
  the screen (which is zoom of 100), calculates the height
  and changes the zoom to that height
}
Var
  Test: TMuseTest;
  IHeight: Integer;
  Picture: TPicture;
Begin
  If VisibleTestList.Count > 0 Then
  Begin
    Test := TMuseTest(VisibleTestList.Items[0]);
    Picture := TEKGImage(Test.Images[0]).Picture;
    // calculate the 100% witdth height
    IHeight := MulDiv(Test.ClientWidth, Picture.Graphic.Height, Picture.Graphic.Width);
    // now calculate the percentage the desired height is if the 100% width height
    TrkbrZoom.Position := Round((Test.Height / IHeight) * 100);
  End;
End;

Procedure TEKGDisplayForm.LvwTestDblClick(Sender: Tobject);
// close the list view on a double click
Begin
  LvwTest.Visible := False;
  btnSelectTest.Down := False;
End;

Procedure TEKGDisplayForm.ToggleButtons();
// depending on what is selected, enables/disables the
// aproptiate buttons
Var
  NumActiveEKGs: Integer;
Begin
  NumActiveEKGs := LvwTest.Selcount;
  btnLockedScroll.Enabled := (NumActiveEKGs > 1) And (Not btnOverlay.Down);
  MnuLockScrolling.Enabled := (NumActiveEKGs > 1) And (Not btnOverlay.Down);
  btnGrid.Enabled := (NumActiveEKGs > 0);
  MnuToggleGrid.Enabled := (NumActiveEKGs > 0);
  btnTextOverlay.Enabled := (NumActiveEKGs > 0);
  MnuToggleTextOverlay.Enabled := (NumActiveEKGs > 0);
  btnPrint.Enabled := (NumActiveEKGs > 0);
  MnuPrint.Enabled := (NumActiveEKGs > 0);
  btnFitWidth.Enabled := (NumActiveEKGs > 0);
  MnuFitWidth.Enabled := (NumActiveEKGs > 0);
  btnFitHeight.Enabled := (NumActiveEKGs > 0);
  MnuFitHeight.Enabled := (NumActiveEKGs > 0);
  btnReset.Enabled := (NumActiveEKGs > 0);
  MnuReset.Enabled := (NumActiveEKGs > 0);

  btnNextTest.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index < LvwTest.Items.Count - 1));
  MnuNextStudy.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index < LvwTest.Items.Count - 1));
  btnPreviousTest.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index > 0));
  MnuPreviousStudy.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index > 0));
  btnFirstTest.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index > 0));
  MnuFirstStudy.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index > 0));
  btnLastTest.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index < LvwTest.Items.Count - 1));
  MnuLastStudy.Enabled := ((NumActiveEKGs = 1) And (LvwTest.Selected.Index < LvwTest.Items.Count - 1));

  TogglePagingButtons();
  If ((LvwTest.Selcount <> 1) Or (btnOverlay.Down)
    Or (TMuseTest(VisibleTestList.Items[0]).TestFileInfo.Pages = 1)) Then
  Begin
    EdtCurrentPage.Text := '';
    LblPageCount.caption := '';
  End;
End;

Procedure TEKGDisplayForm.TogglePagingButtons();
Var
  Test: TMuseTest;
  PagingEnabled: Boolean;
  VisiblePage: Integer;
Begin
  Test := Nil;
  If (VisibleTestList.Count > 0) Then
    Test := TMuseTest(VisibleTestList.Items[0]);
  PagingEnabled := ((Test <> Nil) And (LvwTest.Selcount = 1)
    And (Not btnOverlay.Down) And (Test.TestFileInfo.Pages > 1));
  VisiblePage := 1;
  If (PagingEnabled) Then
    VisiblePage := Test.GetVisiblePageNumber();
  btnFirstPage.Enabled := PagingEnabled And (VisiblePage > 1);
  MnuFirstPage.Enabled := PagingEnabled And (VisiblePage > 1);
  btnPreviousPage.Enabled := PagingEnabled And (VisiblePage > 1);
  MnuPreviousPage.Enabled := PagingEnabled And (VisiblePage > 1);
  btnNextPage.Enabled := PagingEnabled And (VisiblePage < Test.TestFileInfo.Pages);
  MnuNextPage.Enabled := PagingEnabled And (VisiblePage < Test.TestFileInfo.Pages);
  btnLastPage.Enabled := PagingEnabled And (VisiblePage < Test.TestFileInfo.Pages);
  MnuLastPage.Enabled := PagingEnabled And (VisiblePage < Test.TestFileInfo.Pages);
  EdtCurrentPage.Enabled := PagingEnabled;
End;

Procedure TEKGDisplayForm.btnFirstPageClick(Sender: Tobject);
// go to the first page of the test
Var
  Test: TMuseTest;
Begin
  Test := TMuseTest(VisibleTestList.Items[0]);
  If (Test.Loaded) Then
  Begin
    Test.ShowPage(1);
    EdtCurrentPage.Text := '1';
  End;
End;

Procedure TEKGDisplayForm.btnLastPageClick(Sender: Tobject);
// go to the last page of the test
Var
  Test: TMuseTest;
Begin
  Test := TMuseTest(VisibleTestList.Items[0]);
  If (Test.Loaded) Then
  Begin
    Test.ShowPage(Test.TestFileInfo.Pages);
    EdtCurrentPage.Text := Inttostr(Test.TestFileInfo.Pages);
  End;
End;

Procedure TEKGDisplayForm.btnPreviousPageClick(Sender: Tobject);
// go to the previous page of the test
Var
  Test: TMuseTest;
  PageNum: Integer;
Begin
  Test := TMuseTest(VisibleTestList.Items[0]);
  If (Test.Loaded) Then
  Begin
    PageNum := Test.GetVisiblePageNumber();
    // can't go below page 1
    If (PageNum > 1) Then
    Begin
      Test.ShowPage(PageNum - 1);
      EdtCurrentPage.Text := Inttostr(PageNum - 1);
    End;
  End;
End;

Procedure TEKGDisplayForm.btnNextPageClick(Sender: Tobject);
// go to the next page of the test
Var
  Test: TMuseTest;
  PageNum: Integer;
Begin
  Test := TMuseTest(VisibleTestList.Items[0]);
  If (Test.Loaded) Then
  Begin
    PageNum := Test.GetVisiblePageNumber();
    // can't go past last page
    If (PageNum < Test.TestFileInfo.Pages) Then
    Begin
      Test.ShowPage(PageNum + 1);
      EdtCurrentPage.Text := Inttostr(PageNum + 1);
    End;
  End;
End;

Procedure TEKGDisplayForm.MnuSettingsClick(Sender: Tobject);
Begin
  btnOptionsClick(Sender);
End;

Procedure TEKGDisplayForm.btnOptionsClick(Sender: Tobject);
// open the options form
Begin
  // Center the options form in the middle of the current form
  EKGDisplayOptionsForm.Top := Self.Top + ((Self.Height Div 2) - (EKGDisplayOptionsForm.Height Div 2));
  EKGDisplayOptionsForm.Left := Self.Left + ((Self.Width Div 2) - (EKGDisplayOptionsForm.Width Div 2));
  // Show the form
  EKGDisplayOptionsForm.Showmodal();
End;

Procedure TEKGDisplayForm.btnPreviousTestClick(Sender: Tobject);
// display the previous test
Var
  Data: Tobject;
  Index, i: Integer;
Begin
  Index := LvwTest.Selected.Index;
  For i := Index - 1 Downto 0 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If Data Is TMuseTest Then
    Begin
      LvwTest.Selected.Selected := False;
      LvwTest.Items[i].Selected := True;
      Break;
    End;
  End;

End;

Procedure TEKGDisplayForm.btnNextTestClick(Sender: Tobject);
// display the next test
Var
  Data: Tobject;
  Index, i: Integer;
Begin
  Index := LvwTest.Selected.Index;
  For i := Index + 1 To LvwTest.Items.Count - 1 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If Data Is TMuseTest Then
    Begin
      LvwTest.Selected.Selected := False;
      LvwTest.Items[i].Selected := True;
      Break;
    End;
  End;
End;

Procedure TEKGDisplayForm.btnFirstTestClick(Sender: Tobject);
Var
  Data: Tobject;
  i: Integer;
Begin
  LvwTest.Selected.Selected := False;
  // loop through and select the first study
  For i := 0 To LvwTest.Items.Count - 1 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If Data Is TMuseTest Then
    Begin
      LvwTest.Items[i].Selected := True;
      Break;
    End;
  End;
End;

Procedure TEKGDisplayForm.btnLastTestClick(Sender: Tobject);
Var
  Data: Tobject;
  i: Integer;
Begin
  For i := LvwTest.Items.Count - 1 Downto 0 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If Data Is TMuseTest Then
    Begin
      LvwTest.Selected.Selected := False;
      LvwTest.Items[i].Selected := True;
      Break;
    End;
  End;
End;

Procedure TEKGDisplayForm.EdtCurrentPageChange(Sender: Tobject);
// go to the page that was entered
Var
  Test: TMuseTest;
  Page: Integer;
Begin
  If ((VisibleTestList.Count > 0) And (Trim(EdtCurrentPage.Text) <> '')) Then
  Begin
    Test := TMuseTest(VisibleTestList.Items[0]);
    Try
      Page := Strtoint(Trim(EdtCurrentPage.Text));
      // make sure it is a valid page number
      If (Page <= Test.TestFileInfo.Pages) Then
      Begin
        If ((Test.Loaded) And (Trim(EdtCurrentPage.Text) <> '')) Then
          Test.ShowPage(Strtoint(EdtCurrentPage.Text));
      End
    Except
      On EConvertError Do
        EdtCurrentPage.Text := Inttostr(Test.GetVisiblePageNumber());
    End;
    TogglePagingButtons();
  End;
End;

Procedure TEKGDisplayForm.MnuRefreshClick(Sender: Tobject);
Begin
  ClearPatient();
  MuseConnections.Clear();
  GetMuseSites();
  GetTestList();
End;

Procedure TEKGDisplayForm.MnuCloseClick(Sender: Tobject);
// terminate app if this is a standalone, otherwise hide the window
Begin
  If (Application.ExeName = 'EKGDisplay.exe') Then
    Application.Terminate()
  Else
    Hide();
End;

Procedure TEKGDisplayForm.ToolBar1Resize(Sender: Tobject);
Begin
  If (btnStudySeparator.Top = 0) Then
    LblSpacer.Width := ToolBar1.Width - btnStudySeparator.Left
      - btnStudySeparator.Width
      - btnLastTest.Width * 6
      - LblStudy.Width
  Else
    // it must have wrapped around to the next line, so bring it back up
    LblSpacer.Width := 0;
End;

Procedure TEKGDisplayForm.MnuPrintClick(Sender: Tobject);
Begin
  Print();
End;

{$IFDEF StandAlone}

Procedure TEKGDisplayForm.ctxContextorCommitted(Sender: Tobject);
Var
  DFN: String;
  Result: String;
  Status: Boolean;
  TSSN : String;
Begin
  Try
    DFN := ctxContextor.CurrentContext.Item('patient.id.mrn.dfn_660').Value;
  Except
    Showmessage('Unable to retrieve current patient from Context Manager.  Shutting Down.');
    Application.Terminate();
  End;
  MagDBBroker1.RPMagPatInfo(Status, Result, DFN);

  //p130t11 dmmn 4/22/13 - new piece that hold the 9digit SSN for both VA and IHS
  TSSN := MagPiece(Result, '^', 16);
  if TSSN = '' then
  Begin
    ShowMessage('The patient doesn''t have a social security number. Shutting Down.');
    Application.Terminate();
  end

  ChangePatient(MagPiece(Result, '^', 3), TSSN);
End;
{$ENDIF}

Procedure TEKGDisplayForm.MnuToggleGridClick(Sender: Tobject);
Begin
  btnGrid.Down := Not btnGrid.Down;
  btnGridClick(Sender);
End;

Procedure TEKGDisplayForm.MnuToggleTextOverlayClick(Sender: Tobject);
Begin
  btnTextOverlay.Down := Not btnTextOverlay.Down;
  btnTextOverlayClick(Sender);
End;

Procedure TEKGDisplayForm.MnuLockScrollingClick(Sender: Tobject);
Begin
  btnLockedScroll.Down := Not btnLockedScroll.Down;
  btnLockedScrollClick(Sender);
End;

Procedure TEKGDisplayForm.btnLockedScrollClick(Sender: Tobject);
Begin
  If (btnLockedScroll.Down) Then
    MnuLockScrolling.caption := 'Unlock Scrolling'
  Else
    MnuLockScrolling.caption := 'Lock Scrolling';
End;

Procedure TEKGDisplayForm.MnuFitHeightClick(Sender: Tobject);
Begin
  btnFitHeightClick(Sender);
End;

Procedure TEKGDisplayForm.MnuFitWidthClick(Sender: Tobject);
Begin
  btnFitWidthClick(Sender);
End;

Procedure TEKGDisplayForm.MnuResetClick(Sender: Tobject);
Begin
  btnResetClick(Sender);
End;

Procedure TEKGDisplayForm.MnuFirstPageClick(Sender: Tobject);
Begin
  btnFirstPageClick(Sender);
End;

Procedure TEKGDisplayForm.MnuPreviousPageClick(Sender: Tobject);
Begin
  btnPreviousPageClick(Sender);
End;

Procedure TEKGDisplayForm.MnuNextPageClick(Sender: Tobject);
Begin
  btnNextPageClick(Sender);
End;

Procedure TEKGDisplayForm.MnuLastPageClick(Sender: Tobject);
Begin
  btnLastPageClick(Sender);
End;

Procedure TEKGDisplayForm.MnuFirstStudyClick(Sender: Tobject);
Begin
  btnFirstTestClick(Sender);
End;

Procedure TEKGDisplayForm.MnuPreviousStudyClick(Sender: Tobject);
Begin
  btnPreviousTestClick(Sender);
End;

Procedure TEKGDisplayForm.MnuNextStudyClick(Sender: Tobject);
Begin
  btnNextTestClick(Sender);
End;

Procedure TEKGDisplayForm.MnuLastStudyClick(Sender: Tobject);
Begin
  btnLastTestClick(Sender);
End;

Procedure TEKGDisplayForm.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Showmessage(Chr(Key));
End;

Procedure TEKGDisplayForm.MnuHelp2Click(Sender: Tobject);
Begin
 //45,95 Helpfile := ExtractFilePath(application.exename)+ '\MagEKGView.hlp';
 //45,95 Application.HelpCommand(HELP_CONTENTS, 0);
  Application.HelpContext(7);
End;

Procedure TEKGDisplayForm.MnuAboutClick(Sender: Tobject);
Begin
  FrmAbout.Execute;
End;

{ Methods }

Procedure TEKGDisplayForm.DeleteFiles();
{ Clean out the temp directory }
Var
  Path: String;
  SearchRec: TSearchRec;
Begin
  Path := ExtractFilePath(Application.ExeName) + 'cache\';
  If FindFirst(Path + '*.emf', FaAnyFile, SearchRec) = 0 Then
  Begin
    DeleteFile(Path + SearchRec.Name);
    While FindNext(SearchRec) = 0 Do
      DeleteFile(Path + SearchRec.Name);
  End;
End;

Procedure TEKGDisplayForm.AddMuseSite(Server, Volume, URL, Username, Password, Site, SiteID, Version: String);
// create a muse connection object based on the data passed in
Var
  Conn: TMuseConnection;
  ApplicationDataFolder: String;
Begin
  Conn := TMuseConnection.Create(Self);
  Conn.Site := Site;
  Try
    Conn.SiteID := Strtoint(SiteID);
  Except
    On EConvertError Do
      Conn.SiteID := 1;
  End;
  Conn.Server := Server;
  Conn.Volume := Volume;
  Conn.MagFileSecurity.Username := Username;
  Conn.MagFileSecurity.Password := Decrypt(Password);
  Conn.OutputFolder := ExtractFilePath(Application.ExeName) + 'cache\';
  ApplicationDataFolder := GetEnvironmentVariable('AppData');
  If ApplicationDataFolder <> '' Then Conn.OutputFolder := ApplicationDataFolder + '\icache\';
  Conn.Version := Version;
  MuseConnections.Add(Conn);
End;

Procedure TEKGDisplayForm.GetMuseSites();
{
  connect to VistA and get a list of MUSE sites.  Then
  loop through the list and create MuseConnection Objects.
}
Var
  i: Integer;
  Temp: String;
  Success: Boolean;
  RPmsg: String;
  Shares: Tstringlist;
  Magini: TIniFile;
  Conn: TMagMuseBaseConnection;
  ApplicationDataFolder: String;
Begin
  If (IsDemoMode) Then
  Begin
  (*
    Conn := TMagMuseDemoConnection.Create(Self);
    Conn.OutputFolder := ExtractFilePath(Application.ExeName) + 'cache\';
    ApplicationDataFolder := GetEnvironmentVariable('AppData');
    If ApplicationDataFolder <> '' Then
      Conn.OutputFolder := ApplicationDataFolder + '\icache\';
    MuseConnections.Add(Conn);
    Exit;
    *)
  End;
  Magini := TIniFile.Create(GetConfigFileName);
  Shares := Tstringlist.Create();
  MuseConnections.Clear();
  Try
    // try to connect to the broker server based on data in the MagIni
{$IFDEF StandAlone}
    MagDBBroker1.SelectServer(Magini.ReadString('Login Options', 'Local VistA', 'BROKERSERVER')
      , Magini.ReadString('Login Options', 'Local VistA port', '9200'));
    MagDBBroker1.RPMagGetNetLoc(Success, RPmsg, Shares, 'EKG');
{$ENDIF}
    // Get the Muse locations and authentication info from the broker
{$IFNDEF P33}MagDBBroker1.RPMagGetNetLoc(Success, RPmsg, Shares, 'EKG');
{$ENDIF}
{$IFDEF P33}RPMagGetNetLoc(Success, RPmsg, Shares, 'EKG');
{$ENDIF}
    For i := 0 To Shares.Count - 1 Do
    Begin
      Temp := Shares[i];
      Temp := MagPiece(Shares[i], '^', 2) + '\';
      AddMuseSite(MagPiece(Temp, '\', 3),
        MagPiece(Temp, '\', 4),
        MagPiece(Shares[i], '^', 10),
        MagPiece(Shares[i], '^', 5),
        MagPiece(Shares[i], '^', 6),
        MagPiece(Shares[i], '^', 9),
        MagPiece(Shares[i], '^', 7),
        MagPiece(Shares[i], '^', 8));
    End;
  Except
    On Exception Do
    Begin
      Showmessage('Unable to connect to the VistA server.  Shutting down.');
      Application.Terminate();
    End;
  End;
  Magini.Free();
  Shares.Free();
End;

Procedure TEKGDisplayForm.GetTestList();
// go through the MuseConnections and get a list of
// tests from each MuseConnection
Var
  TestList, Templist: Tlist;
  i, j: Integer;
  Test: TMuseTest;
  Conn: TMagMuseBaseConnection;
Begin
  TestList := Tlist.Create();
  For i := 0 To MuseConnections.Count - 1 Do
  Begin
    Conn := TMagMuseBaseConnection(MuseConnections[i]);
    Try
      Screen.Cursor := crHourGlass;
      Templist := Conn.GetTestList(PatientID, CSE_ALLTESTS);
      If (Templist <> Nil) Then
      Begin
        For j := 0 To Templist.Count - 1 Do
        Begin
          Test := TMuseTest.Create(Self);
          Test.MuseConnection := Conn;
          Test.PatientID := PatientID;
          Test.TestInfo := Templist[j];
          Test.OnScrollHorz := TestScrollHorizontal;
          Test.OnScrollVert := TestScrollVertical;
          Test.GridLandscapePicure := ImgGrid.Picture;
          Test.DottedGrid := ImgDottedGrid.Picture;
          TestList.Add(Test);
        End;
      End
      Else
        // an error occured in getting the list
        AddConnectionError(Conn);
    Finally
      Screen.Cursor := crDefault;
    End;
  End;
  FillTestsDropdown(TestList);
End;

Procedure TEKGDisplayForm.AddConnectionError(Conn: TMagMuseBaseConnection);
Var
  Item: TListItem;
Begin
  Item := LvwTest.Items.Add();
  Item.caption := '0';
  Item.SubItems.Add('Connection');
  Item.SubItems.Add('Failed');
  Item.SubItems.Add(Conn.Site);
  Item.SubItems.Add('Yes');
  Item.Data := Conn;
End;

Procedure TEKGDisplayForm.FillTestsDropdown(TestList: Tlist);
{ Fill the dropdown with the list of tests grabbed from the muse }
Var
  Data: Tobject;
  i: Integer;
  Test: TMuseTest;
  Item: TListItem;
Begin
  // sort it by date ascending
  TestList.Sort(CompareMUSE_DATE);
  // do this in reverse so it is in date descending order
  For i := (TestList.Count - 1) Downto 0 Do
  Begin
    Test := TestList[i];
    Item := LvwTest.Items.Add();
    Item.Data := Test;
    Item.caption := Inttostr(TestList.Count - i);
    Item.SubItems.Add(Test.GetName());
    Item.SubItems.Add(Test.GetDate());
    Item.SubItems.Add(Test.MuseConnection.Site);
    If (Test.TestInfo.Status = 1) Or (Test.TestInfo.Status = 2) Then
      Item.SubItems.Add('Yes')
    Else
      Item.SubItems.Add('No')
  End;
  If (LvwTest.Items.Count > 0) Then
    // loop through and select the first study
    For i := 0 To LvwTest.Items.Count - 1 Do
    Begin
      Data := LvwTest.Items[i].Data;
      If Data Is TMuseTest Then
      Begin
        LvwTest.Items[i].Selected := True;
        Break;
      End;
    End;
End;

Procedure TEKGDisplayForm.TestLoaded(Sender: Tobject);
// event handler that is called when a test loads
Var
  Test: TMuseTest;
Begin
  Test := TMuseTest(Sender);
  EKGOverlay.Add(Test);
  If (LvwTest.Selcount = 1) Then
  Begin
    EdtCurrentPage.Text := '1';
    LblPageCount.caption := 'of ' + Inttostr(Test.TestFileInfo.Pages);
  End;
  Test.ResizeImages();
  ToggleButtons();
End;

Procedure TEKGDisplayForm.ChangePatient(Name, SSN: String);
// get a list of tests for a new patient
Var
  i, FailedConnections: Integer;
  Conn: TMagMuseBaseConnection;
Begin
  ClearPatient();
  PatientID := SSN;
  caption := 'VistA Imaging EKG Display: ' + Name;
  GetTestList();
  LvwTest.Visible := True;
  btnSelectTest.Down := True;
  LvwTest.SetFocus();

  FailedConnections := 0;
  For i := 0 To MuseConnections.Count - 1 Do
  Begin
    Conn := TMagMuseBaseConnection(MuseConnections.Items[i]);
    If (Not Conn.Accessible) Then
      FailedConnections := FailedConnections + 1;
  End;

  If (MuseConnections.Count = 0) Then
    Showmessage('No MUSE Servers available.');

  If (Not StudiesExist()) Then
  Begin
    If (FailedConnections > 0) Then
    Begin
      If (FailedConnections = MuseConnections.Count) Then
        Showmessage('No MUSE Servers available.  Select a failed connection to see the error code.')
      Else
        Showmessage('No MUSE EKGs on file for this patient from the currently available MUSE server(s).'
          + Chr(13) + Chr(10)
          + 'Select a failed connection to see the error code.');
    End
    Else
    Begin
      Showmessage('No MUSE EKGs on file for this patient');
    End;
  End;
//  end;
End;

Function TEKGDisplayForm.StudiesExist(): Boolean;
Var
  i: Integer;
  Data: Tobject;
Begin
  Result := False;
  For i := 0 To LvwTest.Items.Count - 1 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If Data Is TMuseTest Then
    Begin
      Result := True;
      Break;
    End;
  End;
End;

Procedure TEKGDisplayForm.ClearPatient();
// clear old patient data and free associated memory
Var
  Data: Tobject;
  i: Integer;
  Test: TMuseTest;
Begin
  If ((VisibleTestList <> Nil) And (VisibleTestList.Count > 0)) Then
    VisibleTestList.Clear();
  // stop loading all the tests before destroying them
  LoadTestThread.Clear();
  For i := 0 To LvwTest.Items.Count - 1 Do
  Begin
    Data := LvwTest.Items[i].Data;
    If (Data Is TMuseTest) Then
    Begin
      Test := TMuseTest(LvwTest.Items[i].Data);
      LvwTest.Items[i].Data := Nil;
      Test.Parent := Nil;
//      Test.Free();
    End;
  End;
  LvwTest.Items.Clear();
  DeleteFiles();
End;

Procedure TEKGDisplayForm.Print();            {BM-ImagePrint- MUSE has Seperate Print}
{
  loop through all the visible tests and print them
}
Var
  i: Integer;
  PrintDialog: TPrintDialog;
  Xmsg, Reason: String;
  IObj: TImageData; //45
Begin
  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;
  If Not idmodobj.GetMagUtilsDB1.GetReason(1, Reason) Then Exit;
  IObj := TImageData.Create();
  IObj.ServerName := '';
  IObj.ServerPort := 0;

  idmodobj.GetMagDBBroker1.RPLogCopyAccess(Reason + '^^' + 'EKG' + '^' +
    'Print Image' + '^' + idmodobj.GetMagPat1.M_DFN + '^' + '1', IObj, PRINT_IMAGE); //

  PrintDialog := TPrintDialog.Create(Self);
  PrintDialog.MinPage := 1;
  PrintDialog.MaxPage := 0;
  // calculate number of pages
  For i := 0 To VisibleTestList.Count - 1 Do
    PrintDialog.MaxPage := PrintDialog.MaxPage + TMuseTest(VisibleTestList.Items[i]).Images.Count;
  PrintDialog.ToPage := PrintDialog.MaxPage;

  If PrintDialog.Execute Then
  Begin
    Printer.Orientation := PoLandscape;
    Printer.BeginDoc();
    Try
      // loop through the tests and print them
      For i := 0 To VisibleTestList.Count - 1 Do
      Begin
        // always check for aborts between pages
        If Printer.Aborted Then
          Break;
        // if this isn't the first test, create a new page for the next test
        If i > 0 Then
          Printer.Newpage();
        // print the test
        TMuseTest(VisibleTestList.Items[i]).Print(btnGrid.Down, EKGDisplayOptionsForm.PrintDottedGrid);
      End;
    Finally
      Printer.Enddoc();
    End;
  End;
  PrintDialog.Free();
End;

Procedure TEKGDisplayForm.WMGetMinMaxInfo(Var Msg: TMessage);
Var
  Maxmin: PMinMaxInfo;
  i, Min: Integer;
Begin
  Inherited;
  Maxmin := PMinMaxInfo(Msg.LParam);
  Min := 0;
  For i := 0 To ToolBar1.ControlCount - 1 Do
  Begin
    If (ToolBar1.Controls[i] <> LblSpacer) Then
      Min := Min + ToolBar1.Controls[i].Width;
  End;
  Maxmin.PtMinTrackSize.x := Min;
  Maxmin.PtMinTrackSize.y := 300;
End;

Procedure TEKGDisplayForm.ServerChanged();
Begin
  GetMuseSites();
End;

Procedure TEKGDisplayForm.FormResize(Sender: Tobject);
Begin
  LvwTest.Left := Self.ClientWidth - LvwTest.Width - 20;
End;

Procedure TEKGDisplayForm.ActiveForms1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

End.
