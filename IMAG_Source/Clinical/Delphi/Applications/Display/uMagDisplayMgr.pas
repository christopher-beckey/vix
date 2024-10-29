Unit Umagdisplaymgr;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:     2002
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==    unit uMagDisplayMgr;
 Description: This unit in intended for code that is needed to manage
        Imaging Display.  Source that needs hardcoded, various functions that
        aren't incorporated in a Class yet.
        Interactions, associations between objects that are created dynamically
        (-- most of this code was in the Image Display main window, back when all
        code was there.  In an attempt to find an appropriate helper Class, or
        unit for the functionality, we put some methods here first, to be moved later.
         ==]
 Note:
  }
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)                   { TODO -ogarrett -c149+ : 
when change status of image to QA Reviewed,  icon doesn't change .. the refresh icon doesn't display
but when change to Needs Review it works as expected }


Interface
Uses
  Classes,
  Dialogs, StdCtrls, {/ P122 T15 - JK 7/18/2012 /}
  cMag4Vgear,
  cmag4viewer,
  cMagDBBroker,
  cMagListView,
  FmagReasonSelect, {/ P122 T15 - JK 7/18/2012 /}
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
//RCA  Maggmsgu,
  Controls,
  Graphics,
  ImagInterfaces,
  UMagClasses,
  UMagDefinitions,
  WinTypes ,
  FmagFullRes
  ;

//Uses Vetted 20090929:TemplateToHTML, fmagVideoOptions, cmagDBDemo, magexewait, MagFileVersion, fmagVerifyStats, TemplateToText, fmagDialogSelection, fmagIconLegend, fmagActiveForms, fmagDeleteImage, fEKGDisplayOptions, fEKGDisplay, fmagGroupAbs, fMagVideoPlayer, fmagimageinfo, fmagFullRes, fmagImageList, fMagAbstracts, fmagDialogSaveAs, magguini, magTiuWinu, dmsingle, cmagimagelist, maggut9, umagkeymgr, magresources, MagImageManager, maggut1, umagutils, trpcb, inifiles, fmxutils, shellapi, Dialogs, sysutils, forms

Procedure Transformdate(Var Dt: String);
{/p94t3 gek 11-30-09  decouple from fmagamin.}
Procedure Listtoradlistwin;
{/p94t3 gek 11-30-09  decouple from fmagamin.}
        {   Gets all images for a Rad Exam (clicked in Rad Exam list window) and
            displays the images as abstracts in the Group Abstract window.}
Procedure RadExamImagesToGroup(Radstring: String);
{/p94t2 gek 11/23/09 refactoring}
Function ImageJukeBoxOffLine(IObj: TImageData): Boolean;
{/p94t2 gek 11/23/09 refactoring}
Function CanOverrideBlockedImage(): Boolean;
Function WantOverrideBlockedImage(VIobj: TImageData): Boolean;
{/p94t2 gek 11/19/09 moved to DBMVista for Decouple }//function IENtoTImageData(ien : string; var rstat: boolean; var rmsg : string): TImageData; // p93t8
Procedure ColumnSetSave(LV: TMagListView);
Procedure ColumnSetApply(LV: TMagListView; Value: String);
Function ColumnSetGet(LV: TMagListView): String;
//function DetailedDescStringGen(filter : TImagefilter) : string;
//function DetailedDescGen(filter : TImagefilter) : Tstrings;
Function DetailedDescGen(Filter: TImageFilter; ForMsgDlgDisplay: Boolean = False): TStrings;
Function XwbGetVarValue2(Value: String): String;

Procedure IconShortCutLegend; //59
//moved to umagdisplayutils procedure SwitchToForm;      //59
        {       Prototype: user can enter Image IEN and that image will open
                in a seperate window.}
Procedure OpenImageByID;
        {       prototype: When user selects images in Abs Viewer, the Image list
                will mark it as selected also.}
//procedure SyncListWithAbs(Iobj : TimageData);
        {       prototype: When user selects images in Image list, the Abs Viewer
                will mark it as selected also.}
//procedure SyncAbsWithList(Iobj : TImageData);
        //procedure CheckImagingVersion;
        {       AbsWindow, Main and Image list windows all display information
                about number of images in current filter, and total for patient.
                if clearcount = TRUE the displayed message will be ''.}
Procedure ImageCountDisplay(ClearCount: Boolean = False);
        {       Called by ImageCountDisplay}
Procedure ImageCountUpdate(ctDesc, Fltname, Fltdesc: String);
        {       Displays a message that FltDesc is loading... to Main,Abs,ImageList}
Procedure ImageFilterMsgLoading(Fltdesc: String);
        {       Change the MagDBBroker pointer to point to the Demo DataBase
                component TMagDBDemo}
Procedure SetDBDemo;
        {       Change the MagDBBroker pointer to point to the VistA M DataBase
                component TMagDBMVista}
Procedure SetDBMVista;
        {       Set the TMagDBBroker properties of certain objects to
                point to the MagDBBroker1 object in Data Module1 (dmod) }
Procedure SetAppDBPointers;
        {       This is the Call to open an Image.  Called from various forms,
                objects etc.
                RightLeft, Count, TotalCount, DemoGroup  are for RadWindow
                duplicate : is passed to Viewer.
                  If image is already loaded and duplicate = TRUE, load it again
                UseRadViewer : (Prototype, not used }
Function OpenSelectedImage(IObj: TImageData; RightLeft: byte; Count, TotalCount, DemoGroup: Integer; Duplicate: Boolean = False; UseRadViewer: Boolean = False; WhichViewer: TMag4Viewer = Nil):
  String;

        {       Each type of image has a method to open it.
                These methods are called by OpenSelectedImage}
Procedure OpenVideoImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Procedure OpenFullImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer; Duplicate: Boolean = False; WhichViewer: TMag4Viewer = Nil);
Procedure OpenHTMLImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Procedure OpenWordImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Procedure OpenTextImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Procedure OpenPDFImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer; WhichViewer: TMag4Viewer = Nil);
Procedure OpenRTFImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Procedure OpenAudioImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Procedure OpenRadImage(IObj: TImageData; RightLeft: Integer);
        {       Used by the Open....Image methods to get a temporary filename.
                The ImageFile is then copied and renamed to the temp filename.}
Function GetTempFileName(TmpExt: String): String;

Procedure OpenRadiologyWindow();
Procedure SetCTPresets();
Procedure CloseRadiologyWindow();
        {       Iobj is an Image Group that has been selected somewhere. This
                method will perform necessary steps to load images to
                group abstract window.}
Procedure LoadGroupAbstracts(IObj: TImageData);
        {       Not Implemented.}
Procedure LogActions(Window, action, Ien: String);
        {       Called by LogActions. Not Implemented.}
Procedure LogActionsToFile(Var f: Textfile);
        {       Not Implemented.}
Procedure LogActionSave(Txt: String);
        {       returns TRUE if the image referenced by IObj has been deleted
                by this user, during this session.}
Function ImageDeletedThisSession(IObj: TImageData; Msgdlg: Boolean = True): Boolean;

Procedure OpenEKGWin;
        {       Called by OpenEKGwin, to create other needed EKG Windows.}
Procedure CreateEKGWindows;
        {       Called when Patient images are cleared.}
Procedure CloseEKGWin;
        {       Prefetch all images for a patient. }
Procedure PrefetchPatientImages;
        {       Users with MAG EDIT key can save image to Hard Drive.}
Function ImageSaveAs(IObj: TImageData; Var Saveasfile: String): Boolean;
        {       Function to copy file }
Function CopyTheFile(FromFile, ToDir: String): Boolean;
        {}
Procedure ImagePrintEsigReason(MagVGear: TMag4VGear);         {BM-ImagePrint- interface}
        {}
Procedure ImageCopyEsigReason(MagVGear: TMag4VGear);
        {This is a Copy of Delphi Utility in Fmxutils.pas  'ExecuteFile'.
        This extends that, by allowing filenames of length <= 280,
        and implements the 'print' operation. (not used yet, maybe later) }
  //function MagExecuteFile(const FileName, Params, DefaultDir: string;  ShowCmd: Integer; oper : string = 'open'): THandle;

        {       Buttons and menu's are disabled until a patient is selected.
                - Refresh Patient Images, Rad Exam listing, Abstract window etc.
                Enabled only when a Patient has been selected. }
Procedure EnablePatientButtonsAndMenus(Status: Boolean; pMuseEnabled: Boolean = False);
        {       Enables/Disabels Patient lookup options on the Main Window.
                Disabled when Application is opened from CPRS.  Because of the
                way we communicate with CPRS , (we listen they talk) we have
                to Disable the ability to open a patient.}
Procedure EnablePatientLookupLogin(Setting: Boolean);
        {       After Security keys have been retrieved from DB, we
                enable certain menu items, buttons.
                i.e. MAG SYSTEM key holders have more menu items available.}
Procedure InitializeKeyDependentObjects;

{/p94t2 gek 11/19/09 moved to Tmagimagemanager   GetImageTxtFileText}
//procedure MgrOpenImageTxtFile(Iobj : TImageData; var t : tstrings; xmsg: string);

Function MgrImageDelete(IObj: TImageData; Var Xmsg: String; var NeedsReview: Boolean): Boolean;

{/ P122 T15 - JK 7/18/2012 - add a custom button dialog to make the YES/NO/CANCEL choices obvious. /}
function DeleteAnnotatedDialog(const Msg: string; DlgType: TMsgDlgType; Buttons:
         TMsgDlgButtons; HelpCtx: Integer; Prnt: TWinControl; FocusCaption: String): TModalResult;

//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}

Procedure PatientIDMismatchLog(MagVGear: TMag4VGear);

Procedure FullResClose;
Procedure FullResWindowOpen;
Procedure SetCurSelectedImageObj(IObj: TImageData);
Function MakeNewsObject(Vcode: Integer = 0; Vint: Integer = 0; Vstr: String = '';
  VchangeObj: Tobject = Nil; VInitiater: Tobject = Nil; VTopic: Integer = 0): TMagNewsObject;

//function IsViewAbleStatus(Iobj : TimageData; var msg : string): boolean;

  {JK 1/13/2009}
Function StripLineFeed(s: String): String;
Function IsThisImageLocaltoDB(imageobj: TImageData; dbBroker: TMagDBBroker; Var Rmsg: String): Boolean;
Procedure OpenVerifyReport(Owner: TComponent; Dtfrom, Dtto, Desc: String);
Procedure OpenImageInfoSys(IObj: TImageData);

{/ P117 - JK 8/30/2010 - Close the Report Manager window /}
procedure CloseMagReportMgrWin;
{/ P122 T15 - JK 7/18/2012 - refactored CurrentImageStatusChange from being in fmagImageList so
   other methods elsewhere can use it. /}
procedure CurrentImageStatusChange(IObj: TImageData; value: integer; var rstat: Boolean; var rmsg: String);

Procedure OpenXMLImage(Var Filename: String; IObj: TImageData);

Var

    {   Old vs New.   tRadList is the patient Radiology Exam list, this is used
       by Main window, and Radexam list window (and others) }
  TRadList: TStrings;

  FIsAppMinimized: Boolean;
  FisCPInstalled: Boolean;
  FCurSelectedImageObj: TImageData;

  FDisablePatSelection: Boolean; {used when switching patients. Forces
                                         patient switching to be synchronized}
  FWrksAbsCacheON: Boolean;

  MagVideoProcessInfo: TprocessInformation;

  Testreshandle: THandle;
  {     determines if there has been a new login since the Rad viewer was last displayed}
  NewLogin: Boolean;
  {     Quick and dirty way of saying to the functions, we want to show the image(s) in a different
         Mag4Viewer,  referenced by newViewer}
  Newviewer: TMag4Viewer; //93

  //ShowDeletedImagePlaceholderInfo: Boolean;
  {/ P117 - JK 9/21/2010 - global used to pass the 'D' flag to
                                              RPMag4GetImageInfo which can be called from the group abstract form. /}
Implementation
Uses
  cMagImageList,
  //122 T15 commented this out.    Dialogs,
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  FEKGDisplay,
  FEKGDisplayOptions,
  FMagAbstracts,
  FmagActiveForms,
  FMagCTConfigure,
  FmagDeleteImage,
  FmagDialogSaveAs,
  FmagDialogSelection,
//RCA move above   FmagFullRes,
  FMagGroupAbs,
  FmagIconLegend,
  FMagImageInfo,
  FMagImageInfoSys,
  FMagImageList,
  //FmagMain,
  FmagRadViewer,
  //fmagVerifyStats,  {/ JK 8/4/2010 - P117 - removed /}
  fMagReportMgr,
  FmagVideoPlayer,
  Fmxutils,
  Forms,
  Inifiles,
  Magguini,
  Maggut1,
  Maggut9,
  MagImageManager,
  MagResources,
  MagTIUWinu,
  Magradlistwinu,
  Shellapi,
  SysUtils,
  TemplateToText,
  Trpcb,
  Umagkeymgr,
  Umagutils8
  ;

Procedure Listtoradlistwin;
Var
  j, k: Integer;
  St: String;
Begin
    { this'll be gone with MultiProcedure listing which will use a TMagListView
       and/or TMagTreeView.}
  Radlistwin.DFN.Text := idmodobj.GetMagPat1.M_DFN;

  Radlistwin.Stg1.RowCount := TRadList.Count;
  Radlistwin.Stg1.ColCount := Maglength(TRadList[0], '^');
  For j := 0 To TRadList.Count - 1 Do
  Begin
    For k := 1 To Radlistwin.Stg1.ColCount Do
    Begin
      St := MagPiece(TRadList[j], '^', k);
      If (k = 4) And (j > 0) Then
        Transformdate(St);
      Radlistwin.Stg1.Cells[k - 1, j] := St;
    End;
  End;
End;

Procedure Transformdate(Var Dt: String);
Var
  x: String;
Begin
  x := Dt;
  Dt := MagPiece(x, '/', 3) + ' - ' + MagPiece(x, '/', 1) + '/' + MagPiece(x,
    '/', 2); {  }
End;

Procedure RadExamImagesToGroup(Radstring: String);
Var
  t: Tstringlist;
  DayCase: String;
  Sysradstring: String;
  Magien: String;
  Rmsg: String;
  Rstat: Boolean;
Begin
  MagAppMsg('', 'Checking Exam  : ' + MagPiece(Radstring, '^', 3) + '  for Images...');
  t := Tstringlist.Create;
  Try
    DayCase := MagPiece(Radstring, '^', 2);
    Sysradstring := DayCase + ' - ' + MagPiece(Radstring, '^', 3) + ' - ' +
      MagPiece(Radstring, '^', 4)
      + ' - RARPT: ' + MagPiece(Radstring, '^', 16);
    LogActions('RADEXAM', 'IMAGES', DayCase);

    idmodobj.GetMagDBBroker1.RPMaggRadImage(Rstat, Rmsg, t, Radstring);
    If Not Rstat Then
    Begin
      If MagPiece(t[0], '^', 1) = '-2' Then
        MagAppMsg('DEQA', Rmsg)
      Else
        MagAppMsg('de', Rmsg);
      MagAppMsg('s', 'Rad Report info : ' + Sysradstring);
      Exit;
    End;
    MagAppMsg('', MagPiece(t[0], '^', 1) + ' ' + MagPiece(t[0], '^', 2));
    Magien := MagPiece(t[0], '^', 5);
    t.Delete(0);
        {-------------------------------}
    If Not Doesformexist('frmGroupAbs') Then
      UprefToGroupWindow(Upref);
    FrmGroupAbs.Visible := True;
//idmodobj.GetMagPat1.M_NameDisplay
    Try
      FrmGroupAbs.SetInfo('Radiology Exam, Images -- ' +
//                frmMain.edtPatient.Text,
{p94t3 gek 11/30/03 decouple  below for above}
        idmodobj.GetMagPat1.M_NameDisplay,
        '  ' + MagPiece(Radstring, '^', 2)
        + '  ' + MagPiece(Radstring, '^', 3) + ' '
        + MagPiece(Radstring, '^', 4)
        + '  ' + Inttostr(t.Count) + '  Images',
        '', Magien,
        MagPiece(Radstring, '^', 2)
        + '  ' + MagPiece(Radstring, '^', 3) + ' '
        + MagPiece(Radstring, '^', 4));
      FrmGroupAbs.MagImageList1.LoadGroupList(t, '', '');
      FrmGroupAbs.Show;
    Except
      On e: Exception Do
      Begin
        Showmessage('exception : ' + e.Message);
        FrmGroupAbs.FGroupIEN := '';
      End;
    End;
        {------------------------}
  Finally
    t.Free;
  End;

End;

Procedure OpenImageInfoSys(IObj: TImageData);
Begin
    (*  P93T8   Modify this Dialog to implement the execute method.  Low Coupling.
        if not DoesFormExist('frmMagImageInfoSys') then
        begin
            Application.CreateForm(TfrmMagImageInfoSys, frmMagImageInfoSys);
                // := TfrmMagImageInfoSys.create(self);
        end;
        frmMagImageInfoSys.DisplayImageInfo(Iobj);
        frmMagImageInfoSys.show;
    *)
  FrmMagImageInfoSys.Execute(IObj)
End;

procedure OpenVerifyReport(Owner: TComponent; Dtfrom, Dtto, Desc: String);
begin
  {/ JK 8/4/2010 - P117 - Removed call to TfrmVerifyStats. Use fMagReportMgr instead /}
  frmMagReportMgr.Execute(Owner, 'QASTATS','','','');
end;

Function IsThisImageLocaltoDB(imageobj: TImageData; dbBroker: TMagDBBroker; Var Rmsg: String): Boolean;
Begin
  Try
    If Not dbBroker.IsConnected Then
      Raise Exception.Create('You need to Login to VistA.');
    If imageObj = Nil Then
      Raise Exception.Create('You need to select an Image.');
    If imageObj.Mag0 = '' Then
      Raise Exception.Create('Image IEN is invalid');
    If ((imageObj.ServerName <> dbbroker.GetServer)
      Or (imageObj.ServerPort <> dbbroker.GetListenerPort)) Then
      Raise Exception.Create('Image is from a Remote Site.');
    Result := True;
  Except
    On e: Exception Do
    Begin
      Rmsg := e.Message;
      Result := False;
    End;
  End;

End;

Procedure SetCurSelectedImageObj(IObj: TImageData);
Begin
  If IObj = Nil Then //93t12
  Begin
    FCurSelectedImageObj.Free;
    FCurSelectedImageObj := Nil;
  End;
//FCurSelectedImageObj := Iobj;
  If IObj <> Nil Then
  Begin
    If FCurSelectedImageObj = Nil Then FCurSelectedImageObj := TImageData.Create;
    FCurSelectedImageObj.MagAssign(IObj);
  End;
End;

Procedure ColumnSetApply(LV: TMagListView; Value: String);
Begin
  LV.ColumnSetApply(Value);
End;

Procedure ColumnSetSave(LV: TMagListView);
Var
  XCap, XHeader, Xprompt, Fsetname, Fsetvalue, Temp: String;
  i: Integer;
  t: TStrings;
  Magini: TIniFile;
Begin
  Fsetname := '';
  Magini := TIniFile.Create(GetConfigFileName);
  t := Tstringlist.Create;
  Try
    Magini.ReadSection('Field Set', t);
///////////
    Begin
      XCap := 'Save As Column Set';
      XHeader := 'Column Sets:';
      Xprompt := 'Save As:';
    End;
    If FrmDialogSaveAs.Execute(t, XCap, XHeader, Xprompt, False, Fsetname, Temp) Then
      //  fsetvalue := '';
      //  fsetname := inputbox('Field Set','Save as','');
      //  if fsetname <> '' then
    Begin
      For i := 0 To LV.Columns.Count - 1 Do
      Begin
        Fsetvalue := Fsetvalue + Inttostr(LV.Columns[i].Width) + ',';
      End;
      Fsetvalue := StripFirstLastComma(Fsetvalue);
      SetIniEntry('Field Set', Fsetname, Fsetvalue);
    End;

  Finally
    t.Free;
  End;
End;

Function ColumnSetGet(LV: TMagListView): String;
Var
  Value, XCap, XHeader, Xprompt, Fldsetname, FldSetvalue: String;
  i: Integer;
  t: TStrings;
  Magini: TIniFile;
Begin
  Result := '';
  Magini := TIniFile.Create(GetConfigFileName);
  t := Tstringlist.Create;
  Try
    Magini.ReadSection('Field Set', t);
    XCap := 'Save As Column Set';
    XHeader := 'Column Sets:';
    Xprompt := 'Save As:';
    If FrmDialogSelection.Execute(LV, t, 'Select Column set', 'Column Sets:',
      'Selected', Fldsetname, FldSetvalue) Then Value := GetIniEntry('Field Set', Fldsetname);

  Finally
    t.Free;
    Result := Value
  End;
End;

{/ P122 T15 - JK 7/18/2012 - add a custom button dialog to make the YES/NO/CANCEL choices obvious. /}
function DeleteAnnotatedDialog(const Msg: string; DlgType: TMsgDlgType; Buttons:
         TMsgDlgButtons; HelpCtx: Integer; Prnt: TWinControl; FocusCaption: String): TModalResult;
var
  i: Integer;
  Wdth: Integer;
begin
  {CreateMessageDialog is the method to customize the standard button captions used in MessageDlg.}
  with CreateMessageDialog(Msg, DlgType, Buttons) do
  begin
    try
      {Prnt is Parent}
//      Top  := Prnt.Top  + ((Prnt.Height div 2) - (Height div 2));
//      Left := Prnt.Left + ((Prnt.Width div 2)  - (Width div 2));

      position := poScreenCenter;

      {Need to explicitly calculate button positions because if a client user sets the desktop font
       from "standard" to "large" or "extra large" in the screen settings/theme, button placement will
       not be correct in all cases. }

      Wdth := (TButton(FindComponent('Yes')).Width +
               TButton(FindComponent('No')).Width +
               TButton(FindComponent('Cancel')).Width +
               30) div 2;

      TButton(FindComponent('Yes')).Left    := (Width div 2) - Wdth;
      TButton(FindComponent('Yes')).Caption := 'Delete';
      TButton(FindComponent('Yes')).Width   := 60;

      TButton(FindComponent('No')).Left     := TButton(FindComponent('Yes')).Left + TButton(FindComponent('Yes')).Width + 15;
      TButton(FindComponent('No')).Caption  := 'Needs Review';
      TButton(FindComponent('No')).Width    := 120;

      TButton(FindComponent('Cancel')).Left := TButton(FindComponent('Yes')).Left +
                                               TButton(FindComponent('Yes')).Width +
                                               15 +
                                               TButton(FindComponent('No')).Width +
                                               15;

      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i] is TButton then
        begin
          if TButton(Components[i]).Caption = FocusCaption then
          begin
            TButton(Components[i]).Default  := True;
            TButton(Components[i]).TabOrder := 0;
            TButton(Components[i]).UpdateControlState;
          end;
        end;
      end;

      ActiveControl :=  TButton(FindComponent(FocusCaption));

      Result:= ShowModal;

    finally
      Free;
    end;
  end;
end;

Function MgrImageDelete(IObj: TImageData; Var Xmsg: String; var NeedsReview: Boolean): Boolean;
Var
  i: Integer;
  Rstat: Boolean;
  Rlist: TStrings;
  Reason: String;
  Sl: String;
  AllowGrpDel: Boolean;
  rmsg2: String;  {/ P122 T15 - JK 7/25/2012 /}
Begin
  Result := False;
  AllowGrpDel := (Userhaskey('MAG DELETE')); //AND UserHasKey('MAG SYSTEM'));
  If Not AllowGrpDel Then
    AllowGrpDel := (IObj.GroupCount = 1);

  {/ P122 T15 - JK 7/16/2012 - If annotations are associated with the image, prompt the user first to
     tell them that they will permanently lose the annotations, or let them put the image or group into "Needs Review" status /}
  NeedsReview := False;

  if IObj.Annotated then
    if IObj.GroupCount > 1 then
    begin
      case DeleteAnnotatedDialog(
        'One or more images in the group you are about to delete contain annotations and annotation audit history that also will be deleted.' + #13#10#13#10 +
        'Click the "Delete" button to delete the images in the image group along with their image annotations and annotation audit history' + #13#10 +
        'Click "Needs Review" to block the image group from being viewed' + #13#10 +
        'Click the "Cancel" button to not delete this group', mtConfirmation, mbYesNoCancel, 0, Application.MainForm, 'Cancel') of

        mrNo: begin
          CurrentImageStatusChange(IObj, MistNeedsReview, rstat, rmsg2);
          if rstat then
            Showmessage('Image ID#: ' + IObj.Mag0 + ' is now in QA Needs Review status.')
          else
            Showmessage('Image ID#: ' + IObj.Mag0 + ' could not be put into QA Needs Review status.');
          NeedsReview := True;
          Result := True;
          Exit;
        end;
        mrCancel: begin
          Sl := 'Deletion Canceled : ' + #13 + Xmsg + #13 + 'Image ID#: ' + IObj.Mag0;
          MagAppMsg('d', Sl);
          Result := False;
          Exit
        end;
      end;
    end
    else
    begin
      case DeleteAnnotatedDialog(
        'The image you are about to delete contains annotations and annotation audit history that also will be deleted.' + #13#10#13#10 +
        'Click the "Delete" button to delete the image along with the image annotations and annotation audit history' + #13#10 +
        'Click "Needs Review" to block the image from being viewed' + #13#10 +
        'Click the "Cancel" button to not delete this image', mtConfirmation, mbYesNoCancel, 0, Application.MainForm, 'Cancel') of

        mrNo: begin
          CurrentImageStatusChange(IObj, MistNeedsReview, rstat, rmsg2);
          if rstat then
            Showmessage('Image ID#: ' + IObj.Mag0 + ' is now in QA Needs Review status.')
          else
            Showmessage('Image ID#: ' + IObj.Mag0 + ' could not be put into QA Needs Review status.');
          NeedsReview := True;
          Result := rstat;
          Exit;
        end;
        mrCancel: begin
          Sl := 'Deletion Canceled : ' + #13 + Xmsg + #13 + 'Image ID#: ' + IObj.Mag0;
          MagAppMsg('d', Sl);
          Result := False;
          Exit;
        end;
      end;
    end;
  Sl := '';
  Rlist := Tstringlist.Create;
  Try
    If Not FrmDeleteImage.ConfirmDeletion(Xmsg, Rlist, IObj, Reason) Then
    Begin
      Sl := 'Deletion Canceled : ' + #13 + Xmsg + #13 + 'Image ID#: ' + IObj.Mag0;
        //LogMsg('',sl);
      MagAppMsg('d', Sl); {JK 10/6/2009 - Maggmsgu refactoring} {JK 1/20/2010 - added the 'd' param}
      Exit;
    End;

    //LogMsg('', 'Deleting Image ID# ' + Iobj.Mag0 + '...');
    MagAppMsg('', 'Deleting Image ID# ' + IObj.Mag0 + '...'); {JK 10/6/2009 - Maggmsgu refactoring}

    idmodobj.GetMagDBBroker1.RPMaggImageDelete(Rstat, Xmsg, Rlist, IObj.Mag0, '', Reason, AllowGrpDel);
    If Not Rstat Then
    Begin
      For i := 0 To Rlist.Count - 1 Do
        Sl := Sl + MagPiece(Rlist[i], '^', 2) + #13;

        //LogMsg('de', sl);
      MagAppMsg('de', Sl); {JK 10/6/2009 - Maggmsgu refactoring}
      For i := 0 To Rlist.Count - 1 Do
          //LogMsg('s', rlist[i]);
        MagAppMsg('s', Rlist[i]); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;
    Result := True;
    //LogMsg('d', xmsg);
    MagAppMsg('d', Xmsg); {JK 10/6/2009 - Maggmsgu refactoring}
    {TODO: here we can notify anyone who wants to know that an Image has
           been deleted Have to use observer pattern.    }
    For i := 0 To Rlist.Count - 1 Do
      Deletedimages.Add(Rlist[i]);
  Finally
    Rlist.Free;
  End;
End;
{/p94t2 gekj 11/19/09 moved to TMagImageManager}
(*
procedure MgrOpenImageTxtFile(Iobj : TImageData; var t : tstrings; xmsg: string);
var textfile : Tfilename;
begin
t.clear;
textfile := extractfilepath(Iobj.FFile)  + magpiece(extractfilename(Iobj.ffile),'.',1)+ '.txt';
t.Add('Image .TXT File : '+ textfile );
try
if not  idmodobj.GetMagFileSecurity.MagOpenSecurePath(textfile,xmsg) then
  begin
    t.Add(xmsg);
    exit;
  end;
if not fileexists(textfile) then
  begin
    t.Add('------ Image .TXT file does not exist. -----');
    exit;
  end;

t.LoadFromFile(textfile);
finally
idmodobj.GetMagFileSecurity.MagCloseSecurity(xmsg);
end;
end;
  *)
{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = magmsginfo);
//begin
//  idmodobj.GetMagLogManager.LogEvent(nil, MsgType, Msg, Priority);
//end;

Procedure PatientIDMismatchLog(MagVGear: TMag4VGear);
Begin
  idmodobj.GetMagDBBroker1.RPLogCopyAccess('IMGMM^^' +
    TMag4VGear(MagVGear).PI_ptrData.Mag0 + '^' + 'ICN/SSN mismatch' + '^' +
    TMag4VGear(MagVGear).PI_ptrData.DFN + '^' + '1',
    TMag4VGear(MagVGear).PI_ptrData,
    PATIENT_ID_MISMATCH);
End;

Procedure ImagePrintEsigReason(MagVGear: TMag4VGear);        {BM-ImagePrint-Implementation}
Var
  Xmsg, Reason, reascode: String;
  Stat: Boolean;
Begin

  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;
  InitializeKeyDependentObjects; // for display app
  If Not idmodobj.GetMagUtilsDB1.GetReason(1, Reason) Then Exit;
  idmodobj.GetMagUtilsDB1.ImagePrint(MagVGear, Stat, Xmsg);       {BM-ImagePrint- calls TMagUtilsDB.ImagePrint***}
 // idmodobj.GetMagDBBroker1.RPLogCopyAccess(reason);
 // if idmodobj.GetMagDBBroker1 <> nil then
  reascode := MagPiece(Reason, '^', 1);
  idmodobj.GetMagDBBroker1.RPLogCopyAccess(reascode + '^^' +
    TMag4VGear(MagVGear).PI_ptrData.Mag0 + '^' + 'Print Image' + '^' +
    TMag4VGear(MagVGear).PI_ptrData.DFN + '^' + '1' + '^' + MagPiece(Reason, '^', 2),
    TMag4VGear(MagVGear).PI_ptrData, PRINT_IMAGE);

End;
        {}

Procedure ImageCopyEsigReason(MagVGear: TMag4VGear);
Var
  Xmsg, Reason, reascode: String;
  Stat: Boolean;
Begin
  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;
  InitializeKeyDependentObjects;
  If Not idmodobj.GetMagUtilsDB1.GetReason(2, Reason) Then Exit;
  idmodobj.GetMagUtilsDB1.ImageCopy(MagVGear, Stat, Xmsg, True);
  // this gives data in wrong nodes.
  reascode := MagPiece(Reason, '^', 1);
  idmodobj.GetMagDBBroker1.RPLogCopyAccess(reascode + '^^' +
    TMag4VGear(MagVGear).PI_ptrData.Mag0 + '^' + 'Copy Image' + '^' +
    TMag4VGear(MagVGear).PI_ptrData.DFN + '^' + '1' + '^' + MagPiece(Reason, '^', 2),
    TMag4VGear(MagVGear).PI_ptrData, COPY_TO_CLIPBOARD);

End;

Procedure FullResWindowOpen;
Begin
  UprefToFullView(Upref);
End;

Procedure FullResClose;
Begin
  If Doesformexist('frmFullRes') Then FrmFullRes.Close;
End;

{TODO -cRefactor: This needs to be in TImageData...  (put the function with the data) }
(*function IsViewAbleStatus(Iobj : TimageData; var msg : string): boolean;
begin
result := (Iobj.MagViewStatus < 10);
if not result then
   begin
   msg := 'Non Viewable Status : '+ inttostr(IObj.MagViewStatus);
       case IObj.MagViewStatus of
       10:  msg := msg + 'In Progress ';
       11:  msg := msg + 'Needs Review ';
       12:  msg := msg + 'Deleted Image ';
       21:  msg := msg + 'Questionable Integrity ';
       22:  msg := msg + 'TIU Authorization failed. ';
       23:  msg := msg + 'Rad Exam Status failed. ';
       else msg := msg + 'UnDefined Reason. ';
       end;
  end;
end;   *)

Function CanOverrideBlockedImage(): Boolean;
Begin
{/P117 GEK  override blocked images with 'TEMP IGNORE BLOCK' key}
  Result := Userhaskey('MAG EDIT')
         or Userhaskey('MAG SYSTEM')
         or Userhaskey('TEMP IGNORE BLOCK') ;
End;

Function WantOverrideBlockedImage(VIobj: TImageData): Boolean;
Var
  s: String;
Begin
{/P117 GEK  override blocked images with 'TEMP IGNORE BLOCK' key}
  Result := False;
  Result := Userhaskey('TEMP IGNORE BLOCK');
  if result then exit;
  
  If CanOverrideBlockedImage Then
  Begin
    s := 'Image is blocked. ' + #13 + VIobj.GetViewStatusMsg + #13 + #13
      + '(click Ignore to override the block and open the Image)' + #13;

    If Messagedlg(s, MtWarning, [Mbok, mbIgnore], 0) = mrIgnore Then Result := True;
  End;

End;

Function OpenSelectedImage(IObj: TImageData; RightLeft: byte; Count, TotalCount, DemoGroup: Integer;
  Duplicate: Boolean = False; UseRadViewer: Boolean = False; WhichViewer: TMag4Viewer = Nil): String;
{ RightLeft  = (Which Rad Window)   1 for left, 2 for right
  Count      = image # in group
  TotalCount = groupcount
  demoGroup  = 1 if demo is on}{ this is Pre- Patch 8, it will be gone soon}
Var
  Thisfile, Xmsg: String;
  i: Integer;
  ImageThreadedCached: Boolean;
  ImgResult: TMagImageTransferResult;
  overrideblock: Boolean;
Begin
  overrideblock := False;
  ImgResult := Nil;
  ImageThreadedCached := False;
  Result := '1^Okay';
    { change Patient name if needed. }{TODO: This looks wrong, needs looked at}
  If idmodobj.GetMagPat1.M_UseFakeName Then IObj.PtName := idmodobj.GetMagPat1.M_FakePatientName;

  Try { finally will assure Cursor is default }
  //LogMsg('', '');
    MagAppMsg('', ''); {JK 10/6/2009 - Maggmsgu refactoring}
    If Doesformexist('frmMagImageInfo') Then FrmMagImageInfo.ShowInfo(IObj);

  {   Quit if this image is of Questionable Integrity {}
    If (IObj.QAMsg <> '') Then
    Begin
      Result := '0^' + IObj.QAMsg;
      //LogMsg('DEQA', IObj.QAMsg);
      MagAppMsg('DEQA', IObj.QAMsg); {JK 10/6/2009 - Maggmsgu refactoring}
      //LogMsg('s', 'Image IEN in Question: ' + Iobj.Mag0);
      MagAppMsg('s', 'Image IEN in Question: ' + IObj.Mag0); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;

    If IObj.MagStatus = MistNeedsReview Then
    Begin
      If CanOverrideBlockedImage Then
      Begin
        overrideblock := WantOverrideBlockedImage(IObj);
        If Not overrideBlock Then
        Begin
       {we already opened a Dialog in the WantOver... call,  no need to open Dialog again}
          Result := '0^' + IObj.GetViewStatusMsg;
       //logmsg('s',Iobj.GetViewStatusMsg,magmsginfo);
          MagAppMsg('s', IObj.GetViewStatusMsg, magmsginfo); {JK 10/6/2009 - Maggmsgu refactoring}
       //LogMsg('s', 'Image IEN in Question: ' + Iobj.Mag0);
          MagAppMsg('s', 'Image IEN in Question: ' + IObj.Mag0); {JK 10/6/2009 - Maggmsgu refactoring}
          Exit;
        End;
      End;
    End;


    {/p117 BB, GEk  check for override any other Block}    { = overrideblock or  haskey...}
    overrideblock := overrideblock or userHasKey('TEMP IGNORE BLOCK');
    { //93 After QI Check the old way, we'll check for blocked images}
    If ((Not IObj.IsViewAble) And (Not overrideblock)) Then
    Begin
       {    Normal users get here.  They'll see a Dialog about the Blocked Image.}
      Result := '0^' + IObj.GetViewStatusMsg;
       //logmsg('DI',Iobj.GetViewStatusMsg,magmsginfo);
      MagAppMsg('DI', IObj.GetViewStatusMsg, magmsginfo); {JK 10/6/2009 - Maggmsgu refactoring}
       //LogMsg('s', 'Image IEN in Question: ' + Iobj.Mag0);
      MagAppMsg('s', 'Image IEN in Question: ' + IObj.Mag0); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;

  //  not used in 2.5 +
  (*Logactions('OpenSelectedImage', '', IObj.mag0);*)

  { quit if image has been deleted during this current Imaging Session {}
    If ImageDeletedThisSession(IObj) Then
    Begin
      Result := '0^Deleted Image.';
      Exit;
    End;

  {11 = Group Type.  It applies to All Groups: Xray, and Full Color (Med, GI etc.)}
    If IObj.IsImageGroup Then
    Begin
      {     Later: based on user pref, open Group Abs window OR open first image.}
      LoadGroupAbstracts(IObj);
      Exit;
    End;

//  maggmsgf.magmsg('','Queue a Copy from JukeBox');
  //LogMsg('','Queue a Copy from JukeBox');
    MagAppMsg('', 'Queue a Copy from JukeBox'); {JK 10/6/2009 - Maggmsgu refactoring}
  {TODO: this could be after the Load , need all speed in loading image}
    idmodobj.GetMagDBBroker1.RPMaggQueImage(IObj);

  {Quit if image is OffLine as defined by Stuarts 'OffLine images file' in Mumps, }
  {LATER , have to figure where to put this FullOffLine test, because having it here, will
   stop BIG files from being viewed if only the Full Res Image is offline }
  {p94t2 gek 11/23/09 refactoring }
  //if frmmain.ImageJukeBoxOffLine(Iobj) then
    If ImageJukeBoxOffLine(IObj) Then
    Begin
      Result := '0^JukeBox is offline.';
      Exit;
    End;

  { Here we check to see if Admin Document and User has MAGDISP ADMIN Key}
    If Not CanUserViewImage(IObj, Xmsg) Then
    Begin
      Result := '0^Key needed to View Image.';
//      maggmsgf.magmsg('D', xmsg, frmmain.pmsg);
      {TODO: not sure if this is right, was using panel on main form}
      //LogMsg('D', xmsg);
      MagAppMsg('D', Xmsg); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;

    {/ P117 NCAT - JK 11/10/2010 /}
    if IObj.ImgType = 501 then
      if UserHasKey('MAG REVIEW NCAT') = False then
      begin
        MagAppMsg('DI', 'You are not authorized to view NCAT documents', magmsginfo);
        Exit;
      end;

  { test for Restricted View for certain images.  Quit now before we attempt
       connection, copy from NetWork.}
    Try {Video, Full Color, Radiology}
      Case IObj.ImgType Of
        1, 3, 9, 17, 18, 19, 21, 100:
          begin
          magappmsg('','GNoRestrictView ' + magbooltostr(GNoRestrictView));
          if (NOT UserHasKey('TEMP NO RESTRICT')) and (NOT GNoRestrictView) then       {p161}
             If (RestrictView(IObj) = 1) Then Exit;
          end;
      End;
    Except
        {exception testing restrict view, we will continue}
//        maggmsgf.MagMsg('s','Exception resolving screen resolution.  Continuing...');
        //LogMsg('s','Exception resolving screen resolution.  Continuing...');
      MagAppMsg('s', 'Exception resolving screen resolution.  Continuing...'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;

  {P8T41, for slow networks, lets see if the cached file exists first.
      this way we won't have to try and connect (which sometimes can take seconds)}

  // JMW 2/15/08 P72 - Need to use getFile because it handles images from the ViX    }
        { TODO : Check if getImageGuarenteed should be used. }
    ImgResult := MagImageManager1.GetFile(IObj.FFile, IObj.PlaceCode, IObj.ImgType, False, False);
    Thisfile := ImgResult.FDestinationFilename;
    If ImgResult.FTransferStatus <> IMAGE_COPIED Then
    Begin
      MagImageManager1.SafeCloseNetworkConnections();
      Result := '0^File doesn''t exist.';
//    maggmsgf.magmsg('de', 'File Does Not Exist !, Notify IRM');
//    maggmsgf.magmsg('s', 'File Does Not Exist : ' + IObj.FFile);
    //LogMsg('de', 'File Does Not Exist !, Notify IRM');

     if not overrideblock then    {/p117 bb, gek stop the Dialog box if we are overriding block}
         MagAppMsg('de', 'File Does Not Exist !, Notify IRM'); {JK 10/6/2009 - Maggmsgu refactoring}
    //LogMsg('s', 'File Does Not Exist : ' + IObj.FFile);
      MagAppMsg('s', 'File Does Not Exist : ' + IObj.FFile); {JK 10/6/2009 - Maggmsgu refactoring}
      If ImgResult <> Nil Then
        FreeAndNil(ImgResult);
      Exit;
    End;
    If ImgResult <> Nil Then
      FreeAndNil(ImgResult);

  { image exists }
//  maggmsgf.magmsg('s', 'opening image type -' + inttostr(IObj.imgtype) +
//                                '  desc -  ' + Iobj.ExpandedDescription(false));
  //LogMsg('s', 'opening image type -' + inttostr(IObj.imgtype) +
  //                              '  desc -  ' + Iobj.ExpandedDescription(false));
    MagAppMsg('s', 'opening image type -' + Inttostr(IObj.ImgType) +
      '  desc -  ' + IObj.ExpandedDescription(False)); {JK 10/6/2009 - Maggmsgu refactoring}
    Screen.Cursor := crHourGlass;

  { Special Case Rad Images. Quit here.  Rad Window logs Access,Closes Security}

  //  JMW P72 set Rad images to go to Full Res
    Case IObj.ImgType Of
      3, 100: {Radiology Type}
        Begin
          OpenRadImage(IObj, RightLeft);
          Exit;
        End;
    End;

    Try { ..finally will CloseSecurity }
  { log Action 'IMG^'  = image has been viewed }

      idmodobj.GetMagDBBroker1.RPMag3Logaction('IMG^' + idmodobj.GetMagPat1.M_DFN + '^' + IObj.Mag0, IObj);
  {NetWorkFile}

  {/ P122 - T15 JK 8/9/2012 - CR - Printing a non-RAD image from a remote site does not print with SSN
            The IObj.DFN sometimes comes from the remote site as an ICN which causes the condition below
            to clear the IObj.SSN. Adding new checks for ICN /}
//122t15 commented this out      If IObj.DFN = Dmod.MagPat1.M_DFN Then
//122t15 commented this out        IObj.SSN := Dmod.MagPat1.M_SSNdisplay
//122t15 commented this out      Else
//122t15 commented this out        IObj.SSN := '';
        if (IObj.DFN = idmodobj.GetMagPat1.M_DFN) or
           (MagPiece(IObj.DFN, 'V', 1) = idmodobj.GetMagPat1.M_ICN) or
           (MagPiece(IObj.DFN, 'V', 2) = idmodobj.GetMagPat1.M_ICN) or
           (IObj.DFN = idmodobj.GetMagPat1.M_ICN) then
          IObj.SSN := idmodobj.GetMagPat1.M_SSNdisplay
        else
        IObj.SSN := '';
//Testing  ..... yes it evaluates correctly  Whichviewer is set to ListWinFullViewer.
//if FrmImageList.ListWinFullViewer = WhichViewer then showmessage('ImageList Full Viewer');
      Case IObj.ImgType Of
        15, 3, 100: {DOCUMENT Type} {if 3,100 get here, open in full}
          OpenFullImage(Thisfile, IObj, DemoGroup, Duplicate, WhichViewer);
        21: {VIDEO Type}
          OpenVideoImage(Thisfile, IObj, DemoGroup);
        1, 9, 17, 18, 19, 503: {Still Color Images} {/ P117 JK 2/9/2011 - add in viewer support for DoD imgtype 503 (JPG) /}
          OpenFullImage(Thisfile, IObj, DemoGroup, Duplicate, WhichViewer);
        101: {HTML}
          OpenHTMLImage(Thisfile, IObj, DemoGroup);
        102, 504: {Word}  {/ P117 JK 2/9/2011 - add in viewer support for DoD imgtype 504 (DOC) /}
          OpenWordImage(Thisfile, IObj, DemoGroup);

//        103: {TEXT }
//          OpenTextImage(Thisfile, IObj, DemoGroup); //*** BB 08/24/2010 text image opened with full image viewer for multi image print
//          //OpenFullImage(thisfile, IObj, demogroup, duplicate, whichviewer);

        {/ P117 JK 2/9/2011 - add in viewer support for DoD imgtype 505 (ASCII) /}
        103, 505: {TEXT }   {/ P117-NCAT JK 11/24/2010 - Added fix from BB to re-enable the call to OpentTextImage with multi-image ROI enabled /}
          if userHasKey('TEMP IGNORE BLOCK') then
            OpenFullImage(thisfile, IObj, demogroup, duplicate, whichviewer) //*** BB 08/24/2010 text image opened with full image viewer for multi image print
          else
            OpenTextImage(Thisfile, IObj, DemoGroup);



        104, 501, 506: {ADOBE }
          OpenPDFImage(Thisfile, IObj, DemoGroup, WhichViewer);  {/ P117-NCAT JK 11/24/2010 - added the 501 NCAT type to the Acrobat viewer /}
        105, 507: {RichTEXT }  {/ P117 JK 2/9/2011 - add in viewer support for DoD imgtype 507 (RTF) /}
          OpenRTFImage(Thisfile, IObj, DemoGroup);
        106: {AUDIO }
          OpenAudioImage(Thisfile, IObj, DemoGroup);
        107: {XML }
          OpenXmlImage(ThisFile, IObj); 
      End; {case}
    Finally
    // JMW 4/25/2005 p45 - if this image was auto-cached then security has already been closed
    // this check might not be needed anymore since a check is done in the security manager
      If Not ImageThreadedCached Then
      Begin
        MagImageManager1.SafeCloseNetworkConnections();
//      idmodobj.GetMagFileSecurity.MagCloseSecurity(xmsg);
      End;
    End;
  Finally
    If Screen.Cursor <> crDefault Then Screen.Cursor := crDefault;
  End;
End;

Procedure OpenRadImage(IObj: TImageData; RightLeft: Integer);
Var
  t: Tlist;
  ImgList: TMagImageList;
  StudyObj: TImageData;
  CurViewer: TMag4Viewer;
Begin

        //RightLeft indicates if open in 2nd Rad window (value of 2)
  t := Tlist.Create();
  OpenRadiologyWindow();
  FrmRadViewer.Show();

  FrmRadViewer.MagViewerTB1.Invalidate;
  FrmRadViewer.MagViewerTB1.Update;
  FrmRadViewer.caption := 'Radiology Viewer: ' + IObj.PtName;
  If IObj.StudyIEN = '' Then
  Begin
    t.Add(IObj);
  End
  Else
  Begin
    StudyObj := TImageData.Create();
    StudyObj.Mag0 := IObj.StudyIEN;
    StudyObj.ServerName := IObj.ServerName;
    StudyObj.ServerPort := IObj.ServerPort;

    ImgList := idmodobj.GetMagImageListManager.GetOrCreateStudy(StudyObj);
    t := ImgList.ObjList;
    IObj := ImgList.ObjList.Items[0];
  End;
  Screen.Cursor := crHourGlass;
  FrmRadViewer.OpenStudy(IObj, t, IObj.ExpandedDescription(False), RightLeft, -1);
  Screen.Cursor := crDefault;
End;

Procedure OpenHTMLImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Begin
  //fmagHTMLViewerForm.LoadTheImage(filename,desc,magrecord);

  // templateHTML.LoadTheImage(filename, Iobj);    // Patch 59, try the next line instead.
  Magexecutefile(Filename, '', '', SW_SHOW);
End;

Procedure OpenWordImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Var
  OldFileName: String;
  FileExt: String;
Begin
  // ?  CHange Attributes to READ ONLY
  (*  we were renaming, now we are not. Ruth - no need.*)
  (* OldFileName := Filename;
  fileext := ExtractFileExt(filename);
  FileName := GetTempFileName(fileext);
  ReNameFile(Oldfilename, FileName);
  *)
  Magexecutefile(Filename, '', '', SW_SHOW);
  {fmagWordform.LoadTheImage(filename,desc,magrecord);}
End;

Function GetTempFileName(TmpExt: String): String;
Var
  i: Integer;
  Tempname: String;
Begin
  (*  we were renaming, now we are not. Ruth - no need.*)
  For i := 1 To 1000 Do
  Begin
    Tempname := (AppPath + '\Cache\TempImage' + Inttostr(i) + TmpExt);
    If Not FileExists(Tempname) Then Break;
  End;
  Result := Tempname;
End;

Procedure OpenTextImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Begin
  //fmagTextForm.LoadTheImage(filename,desc,magrecord);
  TemplateTEXT.LoadTheImage(Filename, IObj);
  // MagExecuteFile(filename, '', '', SW_SHOW);
End;

Procedure OpenPDFImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer; WhichViewer: TMag4Viewer = Nil);
Var
  OldFileName: String;
  FileExt: String;
  PDFHandle: THandle;
  cmd: String;
Begin
//  If Upref.UseAltViewerForPDF Then
  If Upref.UseAltViewerForPDF and not((FrmImageList.ListWinFullViewer <> WhichViewer) and (whichviewer <> nil)) then
   //P117 BB *** if multi image print  show in full image
  Begin
 // cmd :=  '"' +  filename + '"' ;
 //  WinExecNoWait32(cmd, 1, MagVideoProcessInfo);
  //  two above instead of below
   // {
    PDFHandle := Magexecutefile(Filename, '', '', SW_SHOW);
    If (PDFHandle <= 32) Then
    Begin
         //LogMsg('DE', ' Acrobat Reader error: # '+inttostr(PDFHandle));
      MagAppMsg('DE', ' Acrobat Reader error: # ' + Inttostr(PDFHandle)); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
    //}
  End
  Else
  Begin
    OpenFullImage(Filename, IObj, DemoGrp, False, WhichViewer);
  End;
End;

Procedure OpenRTFImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Var
  OldFileName: String;
  FileExt: String;
Begin
  // ?  CHange Attributes to READ ONLY
  (*  we were renaming, now we are not. Ruth - no need.
  OldFileName := Filename;
  fileext := ExtractFileExt(filename);
  FileName := GetTempFileName(fileext);
  ReNameFile(Oldfilename, FileName);
  *)
  Magexecutefile(Filename, '', '', SW_SHOW);
  //  executefile('winword.exe',filename, '', SW_SHOW);
  //  executefile('wordpad.exe',filename, '', SW_SHOW);
  {fmagWordform.LoadTheImage(filename,desc,magrecord);}
End;

Procedure OpenAudioImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Begin
  Magexecutefile(Filename, '', '', SW_SHOW);
  // not using this
{  MediaPlayer1.FileName := filename;
  MediaPlayer1.visible := true;
  MediaPlayer1.BringToFront;
  MediaPlayer1.Open;
  //EndPos := TrackLength[1] div 2;
  MediaPlayer1.Play;
  }
End;

Procedure OpenFullImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer; Duplicate: Boolean = False; WhichViewer: TMag4Viewer = Nil);
Var
  ObjList: Tlist;
  StudyObj: TImageData;
  ImgList: TMagImageList;
Begin
(* this is needed for GroupAbs in Mag4vGear
 if vGearObj <> nil then
   begin
     vGearObj.LoadTheImage(Iobj);
     exit;

   end;   *)
{ p93t8  This is a big cludge, QAD to bring up ImageList window, if it is minimized and user
    clicks on an Abstract from Abs or Group window. }
    {  /p117 ... more cludgy because of ROI Print window with Viewer.....
      If FrmImageList.Pnlfullres.Visible Then
      FormToNormalSize(FrmImageList)                }

 { TODO -oGarrett -crefactor : Need to use WhichViewer parameter from all calls, then optimize this code. }

  {/p117 *** BB - this block updated in P117 for the multi image print, if the line below equates to true,
  then this is called by multi image print functionality and code exected, else run code from
  earlier patches}
  if (FrmImageList.ListWinFullViewer <> WhichViewer) and (whichviewer <> nil) then  //mulit image print
  begin
    Whichviewer.Invalidate;
    Whichviewer.Update;
    ObjList := Tlist.Create;
    ObjList.Add(IObj);
    Whichviewer.ImagesToMagView(ObjList, Duplicate);
    If (IObj.ImgType = 15) Or (IObj.ImgType = 104) Then Whichviewer.ScrollCornerTR;
    ObjList.Free;
    Exit;
  end
  else  // other functionality
  begin
    If FrmImageList.Pnlfullres.Visible Then
      FormToNormalSize(FrmImageList)
    Else
      If Doesformexist('frmFullRes')
          Then FormToNormalSize(FrmFullRes);
    If Assigned(Newviewer) Then
    Begin
      Newviewer.Invalidate;
      Newviewer.Update;
      ObjList := Tlist.Create;
      ObjList.Add(IObj);
      Newviewer.ImagesToMagView(ObjList, Duplicate);

      {JK 2/11/2009 - Fixes D75.  ImgType 15 = document bmp. ImgType 104 = PDF}
      If (IObj.ImgType = 15) Or (IObj.ImgType = 104) Then
        Newviewer.ScrollCornerTR;

      ObjList.Free;
      //
      Exit;
    End;
  end;
  {*** BB}

  If WhichViewer = Nil Then
  Begin
    If Not Doesformexist('frmFullRes') Then UprefToFullView(Upref);
    FormToNormalSize(FrmFullRes);
    Try
      FrmFullRes.Show;
      FrmFullRes.ImageDesc.caption := '';
      FrmFullRes.MagViewerTB1.Invalidate;
      FrmFullRes.MagViewerTB1.Update;

      FrmFullRes.caption := 'Full Resolution View: ' + IObj.PtName;
  // code to load Mag4Viewer.
      ObjList := Tlist.Create;
  {
  // this code opens 1 image per viewer window
  ObjList.Add(Iobj);
  frmFullRes.Mag4Viewer1.ImagesToMagView(objlist, duplicate);
//  LogMsg('s','Opening Image [' + IObj.Mag0 + ']', MagLogERROR);
  ObjList.Free;
  }

  // open the study in 1 cMag4VGear component
      If (IObj.StudyIEN = '') Or (Not Upref.LoadStudyInSingleImageFullRes) Then
      Begin
        ObjList.Add(IObj);
        FrmFullRes.Mag4Viewer1.ImagesToMagView(ObjList, Duplicate);
      End
      Else
      Begin

        StudyObj := TImageData.Create();
        StudyObj.Mag0 := IObj.StudyIEN;
        StudyObj.ServerName := IObj.ServerName;
        StudyObj.ServerPort := IObj.ServerPort;

        ImgList := idmodobj.GetMagImageListManager.GetOrCreateStudy(StudyObj);

        IObj := ImgList.StudyObj;
    {
    studyObj.Free;
    studyObj := TImageData.Create();
    studyObj.magAssign(IObj);
    objList.add(studyObj);
    }
        ObjList.Add(IObj);
        FrmFullRes.Mag4Viewer1.ImagesToMagView(ObjList, Duplicate);
   //    frmFullRes.Mag4Viewer1.ImagesToMagView(imgList.Objlist, duplicate);
      End;

   {JK 2/11/2009 - Fixes D75.  ImgType 15 = document bmp. ImgType 104 = PDF}
      If (IObj.ImgType = 15) Or (IObj.ImgType = 104) Then
        FrmFullRes.Mag4Viewer1.ScrollCornerTR;

      ObjList.Free;

    Except
      On e: Exception Do
      Begin
             //logmsg('s','Ignoring exception: ' + E.Message);
        MagAppMsg('s', 'Ignoring exception: ' + e.Message); {JK 10/6/2009 - Maggmsgu refactoring}
              // above instead of below in 93 T11.
              //93t11 MessageDlg('Ignoring exception: ' + E.Message, mtInformation, [mbOK], 0);
      End;
    End;
  End
  Else {if whichviewer = nil....  so whichviewer is defined, lets show the image in that viewer.}
  Begin
  ///////////////////////////////////////
   {        HERE PROTOTYPE , IMAGES IN DIFFERENT MAIN VIEWER.
   }
    If Not WhichViewer.Visible Then WhichViewer.Visible := True;

  // code to load Mag4Viewer.
    ObjList := Tlist.Create;
  // this code opens 1 image per viewer window
    ObjList.Add(IObj);
    WhichViewer.ImagesToMagView(ObjList, Duplicate);
  //  LogMsg('s','Opening Image [' + IObj.Mag0 + ']', MagLogERROR);
    ObjList.Free;
  /////////////////////////////////////
  End;
End;

Procedure OpenVideoImage(Var Filename: String; IObj: TImageData; DemoGrp: Integer);
Var
  altviewer: String;
  OldFileName: String;
  FileExt: String;
  cmd: String;
Begin

     {
  MagVideoProcessInfo: TprocessInformation;
  WinExecNoWait32(cmd, 1, MagVideoProcessInfo);
  if IsProcessRunning(MagVideoProcessInfo) then MagTerminateProcess(0, MagVideoProcessInfo);

Cmd := '"' + apppath + '\MagScan75N.bat' + '"';
  }

  {DONE:  We want to consider the renaming of file to incremental temp(x) files.
    Ruth - no need.}
  // ?  CHange Attributes to READ ONLY
  (*  we were renaming, now we are not. Ruth - no need.
  OldFileName := Filename;
  fileext := ExtractFileExt(filename);
  FileName := GetTempFileName(fileext);
  ReNameFile(Oldfilename, FileName);
  *)

  //if not frmVideoOptions.rbAltVideoPlayer.checked then
  If Not Upref.UseAltViewerForVideo Then
  Begin
    If Not Doesformexist('frmVideoPlayer') Then Application.CreateForm(TfrmVideoPlayer, FrmVideoPlayer); // := TfrmVideoPlayer.Create(frmmain);
    Application.Processmessages;
    FrmVideoPlayer.ImageData := IObj;
    FormToNormalSize(FrmVideoPlayer);
    FrmVideoPlayer.Show;

    FrmVideoPlayer.InitFile(Filename, IObj.ExpandedDescription(False));
    FrmVideoPlayer.caption := 'Video Player : ' + IObj.PtName;
    ;
    FrmVideoPlayer.Update;
    Application.Processmessages;
    If Upref.PlayVideoOnOpen Then FrmVideoPlayer.StartPlay;
    Screen.Cursor := crDefault;
  End
  Else
  Begin
    altviewer := GetIniEntry('Workstation settings', 'Alternate Video Viewer');
    If (altviewer <> '') Then
    Begin
          //cmd :=  '"' + altviewer + ' ' + filename + '"' ;
          //WinExecNoWait32(cmd, 1, MagVideoProcessInfo);
          // two above in, 1 below out
      Magexecutefile(altviewer, Filename, '', SW_SHOW)
    End
    Else
    Begin
          //cmd := '"' + filename + '"' ;
          //cmd := '"' +  'C:\WINDOWS\system32\mplay32.exe' + ' ' + filename + '"' ;
         //WinExecNoWait32(cmd, 1, MagVideoProcessInfo);
          // two above instead of below.
      Testreshandle := Magexecutefile(Filename, '', '', SW_SHOW);
    End;
  End;
End;

Procedure OpenEKGWin;
Begin
  If Doesformexist('EKGDisplayForm') Then
    EKGDisplayForm.Show()
  Else
    CreateEKGWindows;
End;

Procedure CloseEKGWin;
Begin
  If Doesformexist('EKGDisplayForm') Then
  Begin
    EKGDisplayForm.Close;
  End;
End;

Procedure CreateEKGWindows;
Begin
  Application.CreateForm(TEKGDisplayForm, EKGDisplayForm);
//  maggmsgf.magmsg('s', 'Creating MUSE settings Window');
  //LogMsg('s', 'Creating MUSE settings Window');
  MagAppMsg('s', 'Creating MUSE settings Window'); {JK 10/6/2009 - Maggmsgu refactoring}
  Application.CreateForm(TEKGDisplayOptionsForm, EKGDisplayOptionsForm);
  Application.Processmessages;
End;

Procedure CloseRadiologyWindow();
Begin
  If Doesformexist('frmRadViewer') Then
  Begin
    FrmRadViewer.ClearViewer();
    FrmRadViewer.Close();
  End;
End;

Procedure OpenRadiologyWindow();
Begin
  If Not Doesformexist('frmRadViewer') Then
  Begin
    Application.CreateForm(TfrmRadViewer, FrmRadViewer);
    // JMW 5/15/08 - this needs to be moved because if the user logs into
    // a new DB, they won't get the new settings. I don't want this done
    // everytime however since it makes an RPC call that is only necessary
    // when connecting to a new DB.
    // JMW 6/26/08 - moved below
    //setCTPresets();
  End;
  // JMW 5/15/08 P72t22 - do these each time so that if the user changed DB
  // or a new user logged in, we get the right settings for that user
  //frmRadViewer.SetFormUPrefs(upref);
  // JMW 6/26/08 p72t23 - if there was a new login, then we set
  // the CT presets and the user preferences. if no new login then don't want
  // to reset any settings.
  If FrmRadViewer.NewLogin Then
  Begin
    SetCTPresets();
    FrmRadViewer.SetFormUPrefs(Upref);
  End;
  FrmRadViewer.NewLogin := False;
  FrmRadViewer.CurrentPatient := idmodobj.GetMagPat1;
  //frmRadViewer.OnLogEvent := idmodobj.GetMagLogManager.OnLogEvent;   {JK 10/6/2009 - Maggmsgu refactoring}
  FormToNormalSize(FrmRadViewer);
  FrmRadViewer.MnuViewInfoInformationAdvanced.Visible := (Userhaskey('MAG SYSTEM'));
  FrmRadViewer.MnuViewInfoDICOMHeader.Visible := (Userhaskey('MAG SYSTEM'));
  FrmRadViewer.CTConfigureEnabled := (Userhaskey('MAG RAD SETTINGS'));
  // check for key and enable/disable CT settings configuration menu option

  // don't need to set this since calling functions to do copy/print
  // DO NEED THESE TO VIEW IMAGE REPORT!
  FrmRadViewer.SetUtilsDB(idmodobj.GetMagUtilsDB1);

  FrmRadViewer.OpenCompletd := True;
End;

{/ P117 - JK 8/30/2010 /}
procedure CloseMagReportMgrWin;
begin
  if DoesFormExist('frmMagReportMgr') then
    frmMagReportMgr.Free;
end;

Procedure SetCTPresets();
Var
  Rstat: Boolean;
  Rmsg: String;
  Presets: String;
  VCTPresets: TStrings;
Begin
  VCTPresets := Tstringlist.Create();
  Rstat := False;
  idmodobj.GetMagDBBroker1.RPCTPresetsGet(Rstat, Rmsg, Presets);
  If Rstat Then
  Begin
    VCTPresets.Add(MagPiece(Presets, '~', 1));
    VCTPresets.Add(MagPiece(Presets, '~', 2));
    VCTPresets.Add(MagPiece(Presets, '~', 3));
    VCTPresets.Add(MagPiece(Presets, '~', 4));
    VCTPresets.Add(MagPiece(Presets, '~', 5));
    VCTPresets.Add(MagPiece(Presets, '~', 6));
    VCTPresets.Add(MagPiece(Presets, '~', 7));
    VCTPresets.Add(MagPiece(Presets, '~', 8));
    VCTPresets.Add(MagPiece(Presets, '~', 9));
  End
  Else
  Begin
    VCTPresets.Add('Abdomen|350|1040');
    VCTPresets.Add('Bone|500|1274');
    VCTPresets.Add('Disk|950|1240');
    VCTPresets.Add('Head|80|1040');
    VCTPresets.Add('Lung|1000|300');
    VCTPresets.Add('Mediastinum|500|1040');
    VCTPresets.Add('');
    VCTPresets.Add('');
    VCTPresets.Add('');
  End;
  FrmRadViewer.CTPresets := VCTPresets;
  If Not Doesformexist('frmCTConfigure') Then
  Begin
    Application.CreateForm(TfrmCTConfigure, FrmCTConfigure);
    FrmCTConfigure.Broker := idmodobj.GetMagDBBroker1;
  End;
End;

Procedure LoadGroupAbstracts(IObj: TImageData);
Var
  Temp: Tstringlist;
  OldLeft: Integer;
  FbaseList: TStrings;
  ObjList: Tlist;
  i: Integer;
  ImgList: TMagImageList;
  NewImg: TImageData;
Begin
  Upref.UseGroupAbsWindow := True; //gek 93 debug.  force this to TRUE.  It's not being used, and
  // this gets called when the user clicks on the image in the abs window and
  // they clicked on the first image in the study and have not loaded the full
  // study yet

  If Not Upref.UseGroupAbsWindow Then
  Begin

  {This loads the study (if not already loaded) and then opens the first image in the study}
    ObjList := Tlist.Create();
    ImgList := idmodobj.GetMagImageListManager.GetOrCreateStudy(IObj);
    NewImg := ImgList.ObjList.Items[0];
    NewImg.StudyIEN := IObj.Mag0;
   //  objList.add(newImg);
  // could put some crazy code in here to see if image is rad image, pass study to
  // frmRadViewer and then open all images of the study in the Rad Viewer?
    OpenSelectedImage(NewImg, 1, 0, 1, 0);
    Exit;
  {----------------------------------------------------------------------------}

   (*
  {this next part loads the study and puts the first image of the study into the full res viewer}
  if not DoesFormExist('frmFullRes') then  upreftoFullview(upref);
  objList := TList.Create();
  FormToNormalSize(frmFullRes);
  frmFullRes.Show;
  frmFullRes.ImageDesc.Caption := '';
  frmFullRes.magViewerTB1.Invalidate;
  frmFullRes.magViewerTB1.Update;
  frmFullRes.Caption := 'Full Resolution View: ' + IObj.PtName;

  imgList := idmodobj.GetMagImageListManager.getOrCreateStudy(IObj);
//  IObj := imgList.Objlist.Items[0]; // this makes it so the entire study goes into 1 vGear component (if commented out)
  objList.add(IObj);
  frmFullRes.Mag4Viewer1.ImagesToMagView(objlist, false);
  exit;
  {----------------------------------------------------------------------------}
   *)
  End
  Else
  Begin

    Temp := Tstringlist.Create;
    Try
      Begin
        {/ P117 - JK 9/2/2010 - Add in the D parameter for deleted images /}
        if frmImageList.FCurrentFilter.ShowDeletedImageInfo then
          idmodobj.GetMagDBBroker1.RPMaggGroupImages(IObj, Temp, False, 'D')
        else
          idmodobj.GetMagDBBroker1.RPMaggGroupImages(IObj, Temp, False, '');

//      maggmsgf.magmsg('', 'Image Group selected, accessing Group Images...');
      //LogMsg('', 'Image Group selected, accessing Group Images...');
        MagAppMsg('', 'Image Group selected, accessing Group Images...'); {JK 10/6/2009 - Maggmsgu refactoring}
        If Temp.Count = 1 Then //maggmsgf.magmsg('s', magpiece(temp.strings[0], '^', 2));
        //LogMsg('s', magpiece(temp.strings[0], '^', 2));
          MagAppMsg('s', MagPiece(Temp.Strings[0], '^', 2)); {JK 10/6/2009 - Maggmsgu refactoring}
        idmodobj.GetMagDBBroker1.RPMaggQueImageGroup('A', IObj);
      End;

      If (Temp.Count = 0) Or (Temp.Count = 1) Then
      Begin
//        maggmsgf.magmsg('D', 'ERROR: Accessing Group Images.  See VistA Error Log.');
        //LogMsg('D', 'ERROR: Accessing Group Images.  See VistA Error Log.');
        MagAppMsg('D', 'ERROR: Accessing Group Images.  See VistA Error Log.'); {JK 10/6/2009 - Maggmsgu refactoring}

        Screen.Cursor := crDefault;
        Exit;
      End;
      Temp.Delete(0);

    //LogMsg('', 'Loading Images to group window');
      MagAppMsg('', 'Loading Images to group window'); {JK 10/6/2009 - Maggmsgu refactoring}
    {------------------------}

      If Not Doesformexist('frmGroupAbs') Then UprefToGroupWindow(Upref);
      OldLeft := FrmGroupAbs.Left;
   // frmGroupAbs.visible := true;
      If FrmGroupAbs.Left <> OldLeft Then FrmGroupAbs.Left := OldLeft;
    //try
    {/ P117 - JK 8/31/2010 - TBD if asked for: add a check to see if the user selected "include deleted images" and
       if so, update the info to say x images, y deleted from the group. Do not show the deleted image abstracts because
       the RPC RPMAGGGroupImages does not return them at this point in time. /}
      FrmGroupAbs.SetInfo('', IObj.ExpandedDescription(False) + '  - ' + Inttostr(Temp.Count) + '  Images',
        IObj.ExpandedDescription(False) + '  - ' + Inttostr(Temp.Count) + '  Images',
        IObj.Mag0, IObj.ExpandedDescription(False));

      FrmGroupAbs.MagImageList1.LoadGroupList(Temp, '', '');
     {  move to where mouse is.}
     {  This was a 93 GUI Change,  but it's out, maybe 94... }
//     frmGroupAbs.Left :=  mouse.CursorPos.x;
//     frmGroupAbs.top :=  mouse.CursorPos.y;
      FrmGroupAbs.Show;

      Exit;

     { could add here pass to full res a cmagimagelist for it to open in a TMag4VGear}

        (*

     try
     {
       if (IObj.ImgType = 3) or (IObj.ImgType = 100) then
       begin
         if not DoesformExist('frmRadViewer') then Application.CreateForm(TfrmRadViewer, frmRadViewer);
         FormToNormalSize(frmRadViewer);
         frmRadViewer.Show();
         //frmRadViewer.ImageDesc.Caption := '';
         frmRadViewer.magViewerTB1.Invalidate;
         frmRadViewer.magViewerTB1.Update;
         frmRadViewer.Caption := 'Full Resolution View: ' + IObj.PtName;
         frmRadViewer.magImageList1.LoadGroupList(temp, '', '');
         exit;
       end;
       }
       if not DoesFormExist('frmFullRes') then  upreftoFullview(upref);
       FormToNormalSize(frmFullRes);

       frmFullRes.Show;
       frmFullRes.ImageDesc.Caption := '';
       frmFullRes.magViewerTB1.Invalidate;
       frmFullRes.magViewerTB1.Update;
       frmFullRes.Caption := 'Full Resolution View: ' + IObj.PtName;
       {
       imgList := TMagImageList.Create(nil);
       FBaseList := TStringList.Create();
       FBaseList.Clear;
       FBaseList.add('old^Style');
       for i := 0 to temp.count - 1 do
       begin
         FBaseList.Add('conv^|' + copy(temp[i], pos('^', temp[i]) + 1, 999)); //
       end;
       objList := imgList.ConvertImageListToTImageData(FBaseList,'');
       imgList.Free();
       }
       frmFullRes.Mag4Viewer1.StudyToMagView(iobj, temp, false);
       //frmFullRes.Mag4Viewer1.ImagesToMagView(objlist, false);

    except
      on e: exception do
        begin
          showmessage('exception : ' + e.message);
          frmGroupAbs.FGroupIEN := '';
        end;
    end;
    *)

    {------------------------}
//    maggmsgf.magmsg('', '');
    //LogMsg('', '');
      MagAppMsg('', ''); {JK 10/6/2009 - Maggmsgu refactoring}
    Finally
      Temp.Free;
    End;

  End;
End;

Procedure LogActions(Window, action, Ien: String);
Var
  Dt, Tm, Dttm, Dttmx: String;
Begin
  Exit;
  // we are quitting for now, this is not supported in version 2.5
  { here we log the user actions for this session}
  { user is DUZ, patient is MAGDFN }
(*
  if not IniLogAction then exit;
  datetimetostring(tm, 'hh:mm:ss', now);
  DATETIMETOSTRING(DTTM, 'mm/dd/yy@hh:mm:ss', NOW);
  if window = 'START SESSION' then
    begin
      datetimetostring(dt, 'mm/dd/yy', now);

      DATETIMETOSTRING(DTTMX, 'hhmmss', now);

     AssignFile(LogFile, Apppath + '\temp\' + Copy(WSID, 2, 2) + dttmx + '.log');
     rewrite(LogFile);
      frmmain.LOGMEMO.lines.add(window + '^' + action + '^' + DUZ + '^' + dttm + '^' + WSID);
      exit;
    end;
  if window = 'END SESSION' then
    begin
      frmmain.LOGMEMO.lines.add(window + '^' + action + '^' + DUZ + '^' + dttm + '^' + WSID);
      LogActionsToFile(LogFile);
      exit;
    end;
  frmmain.LOGMEMO.lines.add(window + '^' + action + '^' + IEN + '^' + tm);
  if frmmain.logmemo.lines.count > 10 then LogActionsToFile(LogFile);
*)
End;

Procedure LogActionSave(Txt: String);
Begin
  Exit;
(*
Append(LogFile);
Writeln(LogFile,txt);
*)
//CloseFile(LogFile);
End;

Procedure LogActionsToFile(Var f: Textfile);
Var
  i: Integer;
Begin
  Exit;
 (*
  Append(F);
  for i := 0 to frmmain.logmemo.lines.count - 1 do Writeln(F, frmmain.logmemo.lines[i]);
  frmmain.logmemo.clear;
  CloseFile(F);
 *)
End;

Procedure SetDBDemo;
Begin
 //outUntil Demo is Reimplemented idmodobj.GetMagDBBroker1 := idmodobj.GetMagDBDemo1;
  SetAppDBPointers;
End;

Procedure SetAppDBPointers;
Begin

    idmodobj.GetMagPat1.M_DBBroker := idmodobj.GetMagDBBroker1;
    idmodobj.GetMagUtilsDB1.MagBroker := idmodobj.GetMagDBBroker1;
    idmodobj.GetMagDBSysUtils1.Broker := idmodobj.GetMagDBBroker1.GetBroker;
    FrmImageList.MagImageList1.MagDBBroker := idmodobj.GetMagDBBroker1;
    If Doesformexist('frmimagelist_1') Then Showmessage(' 2 frmImageList windows');
 {p94t2 moved back to frmMain...  where it belongs  gek.}
 // frmMain.magpatphoto1.MagDBBroker := idmodobj.GetMagDBBroker1;
End;

Function ImageDeletedThisSession(IObj: TImageData; Msgdlg: Boolean = True): Boolean;
Begin
  If (Deletedimages.Indexof(IObj.Mag0) > -1) Then
  Begin
    Result := True;
    If Msgdlg Then //maggmsgf.magmsg('d', 'You''ve deleted : ' + IObj.imgdes);
        //LogMsg('d', 'You''ve deleted : ' + IObj.imgdes);
      MagAppMsg('d', 'You''ve deleted : ' + IObj.ImgDes); {JK 10/6/2009 - Maggmsgu refactoring}
  End
  Else
    Result := False;
End;


(*  RCA OUT.  NOT USED.
Procedure OpenDirectoryImages;
Var
  OpenDiaglog1: TOpenDialog;
  Dir: String;
Begin
  With OpenDiaglog1.Create(Nil) Do
  Begin
    If Execute Then
         //  dir := opendialog1.fi
  End;

End; *)

Procedure SetDBMVista;
Begin
 //outUntil Demo is Reimplemented  idmodobj.GetMagDBBroker1 := idmodobj.GetMagDBMVista1;
  SetAppDBPointers;
End;

(*
function IENtoTImageData(ien : string; var rstat: boolean; var rmsg : string): TImageData;
var
i: integer;
s : string;
t : Tstrings;
begin
try
t := tstringlist.Create;
result := TImageData.Create;
result := nil;

    // new/different ImageInfo call - 4/21/2005
    idmodobj.GetMagDBBroker1.RPMaggImageInfo(rstat,rmsg,t,ien,true);
    if not rstat then   exit;
  result :=  result.StringToTImageData(rmsg,idmodobj.GetMagDBBroker1.GetServer,idmodobj.GetMagDBBroker1.GetListenerPort);
finally
end;
end;
*)

Procedure OpenImageByID;
Var
  Magien: String;
  Rstat: Boolean;
  Rmsg: String;
  Rlist: TStrings;
  TempIobj: TImageData;
  ObjList: Tlist;
  NewFullRes: TfrmFullRes;
Begin
  ObjList := Tlist.Create;
  Rlist := Tstringlist.Create;
  Try
    Magien := '';
    If InputQuery('Open Image ID #', 'Enter Image ID# ', Magien) Then
    Begin
      If Magien <> '' Then
     ////p93t8  idmodobj.GetMagDBBroker1.RPMaggImageInfo(rstat,rmsg,rlist,magien);
     ////p93t8  if not rstat then exit;
     ////p93t8  Iobj := Iobj.StringToTImageData(rmsg,idmodobj.GetMagDBBroker1.GetServer,idmodobj.GetMagDBBroker1.GetListenerPort);
     // ? compare patients, if Diff Patient than MagPat1, then open in diff window.
        TempIobj := idmodobj.GetMagDBMVista1.IENtoTImageData(Magien, Rstat, Rmsg);
      If TempIobj = Nil Then Exit;
     //??? this was stopping image dispaly, if it wasn't same patient.
     /// If TempIobj.DFN = idmodobj.GetMagPat1.M_DFN Then    {p149}
     if true then    {p149}
     
      Begin
        NewFullRes := TfrmFullRes.Create(Nil);
        NewFullRes.caption := 'Opening Image(s) by ID #';
        NewFullRes.Color := clPurple;
        NewFullRes.Mag4Viewer1.Align := alclient; // was -> alnone;    {p149}
        NewFullRes.Mag4Viewer1.SetBounds(NewFullRes.Mag4Viewer1.Left + 10, NewFullRes.Mag4Viewer1.Top + 10, NewFullRes.Mag4Viewer1.Width - 20, NewFullRes.Mag4Viewer1.Height - 20);
        NewFullRes.Mag4Viewer1.Anchors := [akLeft, akTop, akRight, akBottom];
        NewFullRes.Color := clBlue;
        NewFullRes.Show;
        Application.Processmessages;
        ObjList.Add(TempIobj);
        NewFullRes.Mag4Viewer1.ImagesToMagView(ObjList);
      End
      Else
      Begin
       // create new window
      End;
    End;

  Finally
    Rlist.Free;
    ObjList.Free;
  End;
End;

Procedure ImageFilterMsgLoading(Fltdesc: String);
Var
  Xmsg: String;
Begin
  Xmsg := ' Loading images for Filter: "' + Fltdesc + '"...';
  If Fltdesc = '' Then Xmsg := '';

  If Doesformexist('frmMagAbstracts') Then
    With FrmMagAbstracts Do
    Begin
      LbImagecount.caption := Xmsg;
      LbImagecount.Hint := '';
      LbImagecount.Update;
    End;
  If Doesformexist('frmImageList') Then
    With FrmImageList Do
    Begin
      PnlFilterDesc.caption := Xmsg;
      PnlFilterDesc.Hint := '';
      PnlFilterDesc.Update;
    End;
End;

Procedure ImageCountDisplay(ClearCount: Boolean = False);
Var
  s: String;
Begin
  If ClearCount Then
  Begin
    ImageCountUpdate('', '', '');
    Exit;
  End;
  If Application.Terminated Then Exit;
  If idmodobj.GetMagPat1.M_DFN = '' Then
    s := ''
  Else
    s := Inttostr(FrmImageList.MagListView1.Items.Count) + ' of ' +
      idmodobj.GetMagPat1.M_TotalImageCount + ' Images match Filter';
  ImageCountUpdate(s, FrmImageList.MagImageList1.ListName, FrmImageList.MagImageList1.ListDesc);
End;

Procedure ImageCountUpdate(ctDesc, Fltname, Fltdesc: String);
Begin
  If Doesformexist('frmMagAbstracts') Then
    With FrmMagAbstracts Do
    Begin
      If ctDesc = '' Then
      Begin
        LbImagecount.caption := '';
        caption := 'Abstracts:';
      End
      Else
      Begin
        FImageCountmsg := ctDesc + ': " ' + Fltname + ' "';
        LbImagecount.caption := FImageCountmsg;
        LbImagecount.Hint := '" ' + Fltname + ' "  ' + ctDesc + ' ' + ' Desc: ' + Fltdesc;
        caption := 'Abstracts: ' + idmodobj.GetMagPat1.M_NameDisplay;
      End;
    End;
  If Doesformexist('frmImageList') Then
    With FrmImageList Do
    Begin
      PnlFilterDesc.caption := ctDesc + ': " ' + Fltname + ' "'; // p8t35
    End;
End;

Procedure PrefetchPatientImages;
Begin
  If (idmodobj.GetMagPat1.M_DFN = '') Then
  Begin
//      maggmsgf.magmsg('d', 'You must first select a Patient ');
      //LogMsg('d', 'You must first select a Patient ');
    MagAppMsg('d', 'You must first select a Patient '); {JK 10/6/2009 - Maggmsgu refactoring}
    Exit;
  End;
  If Messagedlg('To enable faster display of a Patient''s Images.' + #13 + #13 +
    'Copy all Images for ' + idmodobj.GetMagPat1.M_NameDisplay +
    '  from the JukeBox to the Imaging Network Directory' + #13 +
    'OK to Continue ? ', Mtconfirmation, [Mbok, Mbcancel], 0) = MrCancel Then Exit;

  idmodobj.GetMagDBBroker1.RPMaggQuePatient('AF', idmodobj.GetMagPat1.M_DFN);
End;

Function ImageSaveAs(IObj: TImageData; Var Saveasfile: String): Boolean;
Begin
  Result := False;
  With TOpenDialog.Create(Application.MainForm) Do
  Begin
    Filename := Saveasfile;
    If Execute Then
    Begin
      Saveasfile := Filename;
      Showmessage(Saveasfile);
    End
    Else
    Begin
    End;
  End;

    //
End;

Function CopyTheFile(FromFile, ToDir: String): Boolean;
Begin
  Try
    CopyFile(FromFile, ToDir);
    Result := True;
  Except
    Result := False;
  End;

End;

(* Function MagExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer; oper : string): THandle;

Return Values

If the function succeeds, the return value is the instance handle of the application
that was run, or the handle of a dynamic data exchange (DDE) server application.
If the function fails, the return value is an error value that is
less than or equal to 32. The following table lists these error values:

Value	Meaning
0	The operating system is out of memory or resources.
ERROR_FILE_NOT_FOUND	The specified file was not found.
ERROR_PATH_NOT_FOUND	The specified path was not found.
ERROR_BAD_FORMAT	The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).
SE_ERR_ACCESSDENIED	The operating system denied access to the specified file.
SE_ERR_ASSOCINCOMPLETE	The filename association is incomplete or invalid.
SE_ERR_DDEBUSY	The DDE transaction could not be completed because other DDE transactions were being processed.
SE_ERR_DDEFAIL	The DDE transaction failed.
SE_ERR_DDETIMEOUT	The DDE transaction could not be completed because the request timed out.
SE_ERR_DLLNOTFOUND	The specified dynamic-link library was not found.
SE_ERR_FNF	The specified file was not found.
SE_ERR_NOASSOC	There is no application associated with the given filename extension.
SE_ERR_OOM	There was not enough memory to complete the operation.
SE_ERR_PNF	The specified path was not found.
SE_ERR_SHARE	A sharing violation occurred.

*)

    (*
function MagExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer; oper : string = 'open'): THandle;
var
  zOper, zFileName, zParams, zDir: array[0..279] of Char;

begin
 //                              HWND                lpOperation
  Result := ShellExecute(Application.MainForm.Handle,strPcopy(zOper,oper),
  //      lpFile                      lpParameters
  StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
  //      lpDirectory          nShowCmd
   StrPCopy(zDir, DefaultDir), ShowCmd);
end;
      *)

(*
procedure TImageMain.copyimage(magrecord: magrecordptr; trpt: string);
{Count=image # in group}
var
  NTfile, tmpgdir, st, tabs, saveabs, xmsg, txtfile, savetext: string;
begin
  tmpgdir := '';
{Group Type}
  if ImageDeletedThisSession(magrecord) then exit;

  if magrecord^.ImgType = 11 then
  begin {call VistA for group members}
    savedialog1.title := 'Directory for Group''s Images.';
    savedialog1.filename := ('GroupDir');
    if savedialog1.EXECUTE then
    begin
      tmpgdir := EXTRACTFILEPATH(SAVEDIALOG1.FILENAME);
    end
    else
      exit;
  end;

  if not CanOpenSecureFile(magrecord^.Ffile, true, false) then exit;

  NTFile := magrecord^.FFile;
// here somewhere we have to copy the .txt file also.
  savedialog1.title := 'Save Image As...';
  savedialog1.filename := extractfilename(NTfile);
  if savedialog1.EXECUTE then
  begin
    WinMsg('', 'Copying Image to: ' + savedialog1.filename);
    COPYfile(NTfiLE, EXTRACTFILEPATH(SAVEDIALOG1.FILENAME));

    if uppercase(extractfileext(savedialog1.filename)) = '.TIF'
      then begin tabs := NTfile; saveabs := savedialog1.filename; end
    else
    begin
      tabs := magpiece(NTFILE, '.', 1) + '.abs';
      saveabs := magpiece(savedialog1.filename, '.', 1) + '.abs';
      txtfile := magpiece(NTFILE, '.', 1) + '.txt';
      savetext := magpiece(savedialog1.filename, '.', 1) + '.txt';

    end;
    if fileexists(tabs) then
    begin
      WinMsg('', 'Copying Abstract to: ' + saveabs);
      COPYfile(tabs, EXTRACTFILEPATH(SAVEDIALOG1.FILENAME));
    end
    else saveabs := '';
    if fileexists(txtfile) then
    begin
      WinMsg('', 'Copying Text File  to: ' + savetext);
      COPYfile(txtfile, EXTRACTFILEPATH(SAVEDIALOG1.FILENAME));
    end;

    WinMsg('', 'Done copying.');
    DEMOMEMO.CLEAR;
    if (not FILEEXISTS(EXTRACTFILEPATH(SAVEDIALOG1.FILENAME) + '\DemoList.TXT')) then
      DEMOMEMO.LINES.ADD('A2^888')
    else DEMOMEMO.LINES.LOADFROMFILE(EXTRACTFILEPATH(SAVEDIALOG1.FILENAME) + '\DemoList.TXT');
    st := 'B2^' + inttostr(demomemo.lines.count) + '^' + savedialog1.filename + '^' +
      saveabs + '^' + ptrMagRecord^.Imgdes + '^^' + inttostr(ptrMagRecord^.Imgtype) +
      '^' + ptrMagRecord^.Proc + '^' + ptrMagRecord^.Date + '^' + trpt + '^' + ptrMagRecord^.AbsLocation
      + '^^' + tmpgdir;
    demomemo.lines.add(st);
    demomemo.lines.savetofile(EXTRACTFILEPATH(SAVEDIALOG1.FILENAME) + '\DemoList.TXT');

    savedialog1.initialdir := EXTRACTFILEPATH(SAVEDIALOG1.FILENAME);
  end;

  MagFileSecurity.MagCloseSecurity(xmsg); {CloseSecurity;}
  Screen.cursor := crDefault;

end;

*)

Procedure EnablePatientButtonsAndMenus(Status: Boolean; pMuseEnabled: Boolean = False);
Begin
  With FrmImageList Do
  Begin
 // tbtnImageListWin.enabled := status;
    TbtnAbstracts.Enabled := Status;
//  tbtnEkg.enabled := status;
//  tbtnDHCPRpt.enabled := status;

    MnuRefreshPatientImages.Enabled := Status;
//  mnuClearPatient.enabled := status;
//  mnuImagelist.enabled := status;
    MnuThumbnails1.Enabled := Status;
    MnuReports1.Enabled := Status;
    MnuHealthSummary1.Enabled := Status;
    MnuPatientProfile1.Enabled := Status;
    MnuDischargeSummary1.Enabled := Status;
    MnuPrefetch1.Enabled := Status And (SecurityKeys.Indexof('MAG PREFETCH') > -1);
  {   The next menu items, etc depend on Patient and MAGDISP CLIN KEY
      so if Patient and Not MAGDISP CLIN Key,  then disable all. {}
    If Status And (SecurityKeys.Indexof('MAGDISP CLIN') = -1) Then Status := False;

//  mnuRadiologyExams1.enabled := (status and (SecurityKeys.indexof('MAGDISP CLIN') > -1));
//  mnuProgressNotes1.enabled := (status and (SecurityKeys.indexof('MAGDISP CLIN') > -1));
//  mnuClinicalProcedures1.enabled := (status and (SecurityKeys.indexof('MAGDISP CLIN') > -1) and FisCPInstalled);
//  mnuConsults1.enabled := (status and (SecurityKeys.indexof('MAGDISP CLIN') > -1));

    MnuRadiologyExams1.Enabled := Status;
    MnuProgressNotes1.Enabled := Status;
    MnuClinicalProcedures1.Enabled := (Status And FisCPInstalled);
    MnuConsults1.Enabled := Status;

    mnuMUSEekglistIL.Enabled := Status And pMuseEnabled;

  End;
End;

Procedure EnablePatientLookupLogin(Setting: Boolean);
Begin
  FrmImageList.MnuSelectPatient1.Enabled := Setting;
  FrmImageList.TbtnPatient.Enabled := Setting;
  FrmImageList.MnuCPRSSyncOptions1.Enabled := Not Setting;

End;

Procedure InitializeKeyDependentObjects;
Begin

  FrmImageList.MnuManager.Visible := Userhaskey('MAG SYSTEM');
//  FrmImageList.mnuUtilities.Visible := (Userhaskey('MAG EDIT') Or Userhaskey('MAG SYSTEM'));
{/p117 gek.  below, because we depend on new keys.}
    FrmImageList.mnuUtilities.Visible := (Userhaskey('MAG EDIT') or Userhaskey('MAG QA REVIEW') or Userhaskey('MAG SYSTEM') or UserHasKey('MAG ROI'));
End;

(*
procedure SwitchToForm;
begin
   frmActiveforms.execute;
end;
*)

Procedure IconShortCutLegend;
Begin
  FrmIconLegend.Execute;
End;

(*
function DetailedDescGen(filter : TImagefilter) : Tstrings;
var s, stype, sspec, sproc : string;
 ixien : string;
i, ixp,ixl, ixi : integer;

begin

result := Tstringlist.create;
  Result.add(' Filter Details:    ' +filter.Name);
  result.add('*********************************');
//  result.add('');

  s := ClassesToString(filter.Classes);
  if s='' then s := 'Any';
  result.add('[Class]:        '+s);
//  result.add('');

  s := filter.Origin;
  if s='' then s := 'Any';
  if pos(',',s) =1 then s := copy(s,2,999);
  result.add('[Origin]:       '+s);
//  result.add('');

  // we have a few if, rather that if then else for a reason
  //  we want to make sure the date properties are getting cleared when
  //  they should.  Only one of the IF's below, should be TRUE.
  //   If not, then we'll see it and know of a problem.
  if ((filter.FromDate <> '') or (filter.ToDate <> '')) then
  begin
  result.add('[Dates]:        '+'from: '+filter.FromDate+'  thru  '+filter.ToDate);
  end;
  if (filter.MonthRange <> 0) then
  begin
  result.add('[Dates]:        for the last '+inttostr(abs(filter.MonthRange))+' months.');
  end;
  if (filter.MonthRange = 0) and (filter.FromDate ='') and (filter.ToDate = '') then
  result.add('[Dates]:        All Dates.');
//  result.add('');

  s := PackagesToString(filter.Packages);
  if s='' then s := 'Any';
  result.add('[Packages]:  '+s);
  result.add('');

  result.add('[Types]: ');
  stype := filter.Types;
  s := '';
  if stype = ''
          then s := '        Any'
          else
          begin
          ixl := maglength(stype,',');
             for ixi := 1 to ixl do
             begin
             ixien := magpiece(stype,',',ixi);
             if ixien <> '' then  S := S + '        ' +  XwbGetVarValue2('$P($G(^MAG(2005.83,'+ixien+',0)),U,1)') + #13 ;
             end;
          end;
  result.add(s);
//  result.add('');

  result.add('[Specialty/SubSpecialty]:');
  sspec := filter.SpecSubSpec;
  s := '';
  if sspec = '' then s := '        Any'
          else
          begin
          ixl := maglength(sspec,',');
             for ixi := 1 to ixl do
             begin
             ixien := magpiece(sspec,',',ixi);
             if ixien <> '' then  S := S + '        ' +  XwbGetVarValue2('$P($G(^MAG(2005.84,'+ixien+',0)),U,1)') + #13 ;
             end;
          end;
  result.add(s);
//  result.add('');

  result.add('[Procedure/Event]:');
  sproc := filter.ProcEvent;
  s := '';
  if sproc = '' then s := '        Any'
          else
          begin
          ixl := maglength(sproc,',');
             for ixi := 1 to ixl do
             begin
             ixien := magpiece(sproc,',',ixi);
             if ixien <> '' then  S := S + '        ' +  XwbGetVarValue2('$P($G(^MAG(2005.85,'+ixien+',0)),U,1)') + #13;
             end;
          end;
  result.add(s);
  result.add('');

  {  s := filter.Origin;
  if s='' then s := 'Any';
  if pos(',',s) =1 then s := copy(s,2,999);
  result.add('Origin :       '+s);}

   s := filter.Status;
   if s='' then s := 'Any';
   result.Add('[Status]:                             '+s);

   ixien := filter.SavedBy;   //new   ImageCapturedBy
   if ixien <> '' then
     s := XwbGetVarValue2('$P($G(^VA(200,'+ixien+',0)),U,1)') + #13
     else s := 'Any';
   result.add('[Saved By]:                         ' + s);

   s := magbooltostr(filter.UseCapDt);
   result.add('[Search on Capture Date]:  '+ s);

   //result.Add('Short Description has:');
   s := filter.ShortDescHas;
   if s = '' then s := 'Any';
   result.Add('[Short Description has]:       ' + s);

end;
*)

{JK 12/30/2008.  Modified DetailedDescGen to add tabbed columns for cleaner display.
 Also added a ForMsgDlgDisplay param option for making any MessageDlg popups display
 a two column list a bit nicer and without displaying non-printing characters as
 a hollow box.}

Function DetailedDescGen(Filter: TImageFilter; ForMsgDlgDisplay: Boolean = False): TStrings;
Const
  CRLF = #13#10;
Var
  s, Stype, Sspec, Sproc: String;
  Ixien, Mthdesc: String;
  i, Ixp, Ixl, Ixi: Integer;
  Tab: String;
Begin
  If ForMsgDlgDisplay Then
    Tab := #32#32#32#32#32
  Else
    Tab := #9;

  Result := Tstringlist.Create;

  If ForMsgDlgDisplay Then
    Result.Add('Active Filter: ' + Filter.Name + CRLF + '**********************************')
  Else
  Begin
    Result.Add('Filter Details:' + Tab + Filter.Name);
    Result.Add('***************' + Tab + '************************');
  End;

  s := ClassesToString(Filter.Classes);

  If s = '' Then
    s := 'Any';
  Result.Add('[Class]:' + Tab + s);

  s := Filter.Origin;
  If s = '' Then
    s := 'Any';
  If Pos(',', s) = 1 Then
    s := Copy(s, 2, 999);

  Result.Add('[Origin]:' + Tab + s);

  // we have a few if, rather that if then else for a reason
  //  we want to make sure the date properties are getting cleared when
  //  they should.  Only one of the IF's below, should be TRUE.
  //   If not, then we'll see it and know of a problem.
  If ((Filter.FromDate <> '') Or (Filter.ToDate <> '')) Then
  Begin
    Result.Add('[Dates]:' + Tab + 'From: ' + Tab + Filter.FromDate + '  through  ' + Filter.ToDate);
  End;
  If (Filter.MonthRange <> 0) Then
  Begin
    If (Abs(Filter.MonthRange) > 1) Then
      Mthdesc := 'months.'
    Else
      Mthdesc := 'month.';
    Result.Add('[Dates]:' + Tab + 'for the last ' + Inttostr(Abs(Filter.MonthRange)) + '  ' + Mthdesc);
  End;
  If (Filter.MonthRange = 0) And (Filter.FromDate = '') And (Filter.ToDate = '') Then
    Result.Add('[Dates]:' + Tab + 'All Dates.');

  s := PackagesToString(Filter.Packages);
  If s = '' Then
    s := 'Any';

  Result.Add('[Packages]:' + Tab + s);
  Result.Add('');

  Result.Add('[Types]:');

  Stype := Filter.Types;
  s := '';
  If Stype = '' Then
    s := Tab + 'Any'
  Else
  Begin
    Ixl := Maglength(Stype, ',');
    For Ixi := 1 To Ixl Do
    Begin
      Ixien := MagPiece(Stype, ',', Ixi);
      If Ixien <> '' Then
      Begin
        s := Tab + XwbGetVarValue2('$P($G(^MAG(2005.83,' + Ixien + ',0)),U,1)');
        Result.Add(s);
      End;
    End;
  End;

  Result.Add('[Specialty/SubSpecialty]:');

  Sspec := Filter.SpecSubSpec;
  s := '';
  If Sspec = '' Then
    s := Tab + 'Any'
  Else
  Begin
    Ixl := Maglength(Sspec, ',');
    For Ixi := 1 To Ixl Do
    Begin
      Ixien := MagPiece(Sspec, ',', Ixi);
      If Ixien <> '' Then
      Begin
        s := Tab + XwbGetVarValue2('$P($G(^MAG(2005.84,' + Ixien + ',0)),U,1)');
        Result.Add(s);
      End;
    End;
  End;

  Result.Add('[Procedure/Event]:');

  Sproc := Filter.ProcEvent;
  s := '';
  If Sproc = '' Then
    s := Tab + 'Any'
  Else
  Begin
    Ixl := Maglength(Sproc, ',');
    For Ixi := 1 To Ixl Do
    Begin
      Ixien := MagPiece(Sproc, ',', Ixi);
      If Ixien <> '' Then
      Begin
        s := Tab + XwbGetVarValue2('$P($G(^MAG(2005.85,' + Ixien + ',0)),U,1)');
        Result.Add(s);
      End;
    End;
  End;

  Result.Add('');

  s := Filter.Status;
  If s = '' Then
    s := 'Any';
  Result.Add('[Status]:' + Tab + s);
  Ixien := Filter.ImageCapturedBy;
  If Ixien <> '' Then
    s := XwbGetVarValue2('$P($G(^VA(200,' + Ixien + ',0)),U,1)') + #13
  Else
    s := 'Any';

  //Result.Add('[Saved By]:' + Tab + s);
  {JK 1/16/2009}
  Result.Add('[Saved By]:' + Tab + StripLineFeed(s));

  s := Magbooltostr(Filter.UseCapDt);
  Result.Add('[Search on Capture Date]:' + Tab + s);
  s := Filter.ShortDescHas;
  If s = '' Then
    s := 'Any';

  Result.Add('[Short Description has]:' + Tab + s);
End;

{JK 1/13/2009}

Function StripLineFeed(s: String): String;
Var
  i: Integer;
Begin
  i := Pos(#13, s);
  If i > 0 Then
    Result := Copy(s, 1, i - 1)
  Else
    Result := s;
End;

Function XwbGetVarValue2(Value: String): String;
Begin
  idmodobj.GetMagDBBroker1.GetBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
  idmodobj.GetMagDBBroker1.GetBroker.PARAM[0].PTYPE := Reference;
  idmodobj.GetMagDBBroker1.GetBroker.PARAM[0].Value := Value;
  Result := idmodobj.GetMagDBBroker1.GetBroker.STRCALL;
End;

Function MakeNewsObject(Vcode, Vint: Integer; Vstr: String; VchangeObj, VInitiater: Tobject;
  VTopic: Integer): TMagNewsObject;

//MakeNewsObject(vcode, vint : integer;
//  vstr: string; vchangeObj, vinitiater: Tobject; vtopic : integer): TMagNewsObject;

Begin
  Result := TMagNewsObject.Create();
  Result.NewsChangeObj := VchangeObj;
  Result.Newscode := Vcode;
  Result.NewsInitiater := VInitiater;
  Result.NewsStrValue := Vstr;
  Result.NewsIntValue := Vint;
  Result.NewsTopic := VTopic;
End;

Function ImageJukeBoxOffLine(IObj: TImageData): Boolean;
Begin
  Result := False;
    { TODO -c3: Fulllocation was '', never got that error before, have to check M code. }
  If IObj.FullLocation <> '' Then
    If (Uppercase(IObj.FullLocation[1]) = 'O') Then
    Begin
      MagAppMsg('di', 'Image : ' + IObj.ImgDes + #13 +
        'Date  : ' + IObj.Date + '     Procedure : ' + IObj.Proc + #13 +
        #13 +
        'for Patient :    ' + IObj.PtName + #13 +
        'resides on a JUKEBOX that is OFFLINE.');
      MagAppMsg('s', '**JukeBox is OffLine.  ' + IObj.FFile);
      idmodobj.GetMagDBBroker1.RPMaggOffLineImageAccessed(IObj);
      Result := True
    End;
End;
procedure CurrentImageStatusChange(IObj: TImageData; value: integer; var rstat: Boolean; var rmsg: String);
var
  miscparams: Tstrings;
//  rmsg: string;  {/ P122 T15 - JK 7/25/2012 - made this a parameter value /}
  rlist: tStrings;
  fieldlist: tstrings;
  toStatus: string;
  resmsg, reason: string;
  ocurs: Tcursor;
begin
  reason := '';
  rstat := False;

  if IObj = nil then
  begin
    //maggmsgf.MagMsg('DI', 'You need to select an Image.');
    MagAppMsg('DI', 'You need to select an Image.'); {JK 10/5/2009 - Maggmsgu refactoring}
    exit;
  end;

  try
//    WinMsgClear;
    tostatus := magStatusDesc(value);
    //if messagedlg('Change Status of Image to : ' + tostatus, mtconfirmation, [mbok, mbcancel], 0) =
    //    mrcancel then
    //begin
    //    exit;
    //end;
    resmsg := '';

    if value <> mistVerified then
    begin
//      winmsg(0, '');
//      winmsg(1, 'Opening Status Reason selection...');
      reason := '';
      reason := frmReasonSelect.execute('S', idmodobj.GetMagDBBroker1,
        'Reason for Status Change:', 'Select Reason for change to: ' + tostatus,
        resmsg);
      if reason = '' then
        exit;
    end; // raise exception.Create(resmsg);
    CursorChange(ocurs, crHourGlass); //        screen.Cursor := crhourglass;
    rlist := Tstringlist.create;
    fieldlist := Tstringlist.create;
    case value of
      umagdefinitions.mistViewable: fieldlist.Add('ISTAT^^Viewable');
      umagdefinitions.mistVerified: fieldlist.Add('ISTAT^^QA Reviewed');
      umagdefinitions.mistNeedsReview: fieldlist.Add('ISTAT^^Needs Review');
    end;
    if reason <> '' then
      fieldlist.Add('ISTATRSN^^' + reason);

    {/ P122 T15 - JK 8/9/2012 - When a group is presented, the line below only updated the group IEN. Need to update the image IEN of
       a group when IsInAGroup is True /}
//    dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, FCurSelectedImageObj.Mag0, '');

    if IObj.IsInImageGroup then
      idmodobj.GetMagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, IObj.Mag0, '')
    else
//      dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, FCurSelectedImageObj.Mag0, ''); {/ P122 T15 JK 8/14/2012 - FCurSelectedImageObj = nil sometimes which causes an error - should use IObj instead. /}
      idmodobj.GetMagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, IObj.Mag0, '');


//    WinMsgClear;
//    winmsg(mmsglistwin, rmsg);
//    if rstat then
//    begin
//      maglistview1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
//      maglistview1.ImageStatusChange(FCurSelectedImageObj, value);
//      magTreeview1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
//      magTreeview1.ImageStatusChange(FCurSelectedImageObj, value);
//
//    end
//    else
//    begin
//      messagedlg('Change Status Failed : ' + rmsg, mtconfirmation, [mbok], 0);
//    end;

  finally
    cursorRestore(ocurs); //         screen.Cursor := crDefault;
  end;
end;

Procedure OpenXMLImage(Var Filename: String; IObj: TImageData);
begin
  // JMW P131 - explicitly calling IE because the default application for an
  // xml file may not be a web browser. Also IE allows using a stylesheet
  // from a local drive while other browsers may not.
  magexecuteFile('iexplore', Filename, '', SW_SHOW);
end;

End.
