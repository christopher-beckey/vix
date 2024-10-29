Unit FMagImageInfoSys;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:  ~ 2000
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
Description: Displays raw M Global data for System Manager to querry.
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
     ;; a Class II medical device.  As such, it may not be changed
     ;; in any way.  Modifications to this software may result in an
     ;; adulterated medical device under 21CFR820, the use of which
     ;; is considered to be a violation of US Federal Statutes.
     ;; +---------------------------------------------------------------------------------------------------+

*)

Interface

Uses
  Buttons,
  Classes,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  ToolWin,
  //imaging
  UMagClasses,
  MagImageManager
  ;

//Uses Vetted 20090929:cMagDBBroker, maggut1, trpcb, ToolWin, Graphics, Messages, magpositions, umagutils, umagdefinitions, u magdisplaymgr, dmSingle, SysUtils, Windows

Type
  TfrmMagImageInfoSys = Class(TForm)
    Panel1: Tpanel;
    Memo1: TMemo;
    Fd1: TFontDialog;
    cd1: TColorDialog;
    PopupMenu1: TPopupMenu;
    Font1: TMenuItem;
    c: TMenuItem;
    StayOnTop1: TMenuItem;
    WordWrap1: TMenuItem;
    N1: TMenuItem;
    Clear1: TMenuItem;
    RunNetConnectforAbsandFull1: TMenuItem;
    Panel2: Tpanel;
    Help1: TMenuItem;
    N2: TMenuItem;
    Memo2: TMemo;
    Panel4: Tpanel;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    N3: TMenuItem;
    MnuImageTXTFile: TMenuItem;
    ImageDataObject1: TMenuItem;
    NextIEN1: TMenuItem;
    PreviousIEN1: TMenuItem;
    GroupIENofCurrentIEN1: TMenuItem;
    N4: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    EMagNode: TEdit;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Label1: Tlabel;
    EFlags: TEdit;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure Font1Click(Sender: Tobject);
    Procedure CClick(Sender: Tobject);
    Procedure StayOnTop1Click(Sender: Tobject);
    Procedure WordWrap1Click(Sender: Tobject);
    Procedure Clear1Click(Sender: Tobject);
    Procedure RunNetConnectforAbsandFull1Click(Sender: Tobject);
    Procedure Help1Click(Sender: Tobject);
    Procedure SpeedButton1Click(Sender: Tobject);
    Procedure MnuImageTXTFileClick(Sender: Tobject);
    Procedure ImageDataObject1Click(Sender: Tobject);
    Procedure eMagNodeKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure eFlagsDblClick(Sender: Tobject);
    Procedure eMagNodeDblClick(Sender: Tobject);
    Procedure GroupIENofCurrentIEN1Click(Sender: Tobject);
    Procedure PreviousIEN1Click(Sender: Tobject);
    Procedure NextIEN1Click(Sender: Tobject);
    Procedure eMagNodeMouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure Memo1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ToolButton1Click(Sender: Tobject);
    Procedure ToolButton6Click(Sender: Tobject);
    Procedure ToolButton7Click(Sender: Tobject);
    Procedure ToolButton8Click(Sender: Tobject);
    Procedure ToolButton9Click(Sender: Tobject);
    Procedure ToolButton10Click(Sender: Tobject);
    Procedure ToolButton4Click(Sender: Tobject);
    Procedure ToolButton11Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
  Private
    CurImageRecord: TImageData; //117
    CurrentServer: String; //45
    CurrentPort: Integer; //45
    CurrentImageJBPath : string;  //117
    Procedure ShowSecurityMsgs;
    Procedure OpenTextFile;
    Procedure DisplayTimageData;
        {   procedure atm  ..  Add To Memo}
    Procedure atm(s: String; S2: String = ''); Overload;
    Procedure atm(s: String; t: TStrings); Overload;
    Procedure DisplayGlobalNode;
    Procedure IncIEN;
    Procedure DecIEN;
    Procedure GetLastIEN;
    Procedure GetGroupIEN;
    Procedure GetFieldValues;
    Procedure GetTimageData;
    Procedure DisplayCurrentIENInfo;
    Procedure DisplayImageInfo();
    procedure InitImage(vObj: TimageData);

  Public
    Function Execute(IObj: TImageData): Boolean;

  End;

Var
  FrmMagImageInfoSys: TfrmMagImageInfoSys;

Implementation
Uses
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  Magpositions,
  SysUtils,
  UMagDefinitions,
 // u magdisplaymgr,
  Umagutils8,
  Windows
  ;

{$R *.DFM}

Procedure TfrmMagImageInfoSys.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  SaveFormPosition(Self As TForm);
  action := caFree;
End;

Procedure TfrmMagImageInfoSys.BitBtn1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmMagImageInfoSys.ShowSecurityMsgs;
Var
  i: Integer;
Begin
  For i := 0 To idmodobj.GetMagFileSecurity.Msglist.Count - 1 Do
    Memo1.Lines.Add(idmodobj.GetMagFileSecurity.Msglist[i]);
End;

Procedure TfrmMagImageInfoSys.Font1Click(Sender: Tobject);
Begin
  Fd1.Font := Memo1.Font;
  If Fd1.Execute Then
    Memo1.Font := Fd1.Font;
End;

Procedure TfrmMagImageInfoSys.CClick(Sender: Tobject);
Begin
  If cd1.Execute Then
    Memo1.Color := cd1.Color;
End;

Procedure TfrmMagImageInfoSys.StayOnTop1Click(Sender: Tobject);
Begin
  StayOnTop1.Checked := Not StayOnTop1.Checked;
  If StayOnTop1.Checked Then
    Formstyle := Fsstayontop
  Else
    Formstyle := FsNormal;
End;

Procedure TfrmMagImageInfoSys.WordWrap1Click(Sender: Tobject);
Begin
  WordWrap1.Checked := Not WordWrap1.Checked;
  Memo1.Wordwrap := WordWrap1.Checked;

End;

Procedure TfrmMagImageInfoSys.Clear1Click(Sender: Tobject);
Begin
  Memo1.Lines.Clear;
End;

Procedure TfrmMagImageInfoSys.GetFieldValues;
Var
  t: Tstringlist;
  i: Integer;
Begin
    { TODO -cdemo : Make the Image Information advanced window, Disabled for the Demo. }
  t := Tstringlist.Create;
  Try
    idmodobj.GetMagDBSysUtils1.RPMaggDevFldValues(EMagNode.Text, EFlags.Text, CurrentServer, CurrentPort, t);
        //45
    (*
      xBrokerx.re moteprocedure := 'MAGG DEV FIELD VALUES';
      xBrokerx.param[0].value := eMagNode.text;
      xBrokerx.param[0].ptype := literal;
      xBrokerx.param[1].value := UPPERCASE(eFlags.text);
      xBrokerx.param[1].ptype := literal;
      xBrokerx.lstCall(t);
    *)
    For i := 0 To t.Count - 1 Do
      Memo1.Lines.Add(t[i]);
    Memo1.Lines.Add('{--------------------}');

  Finally
    t.Free;
  End;

End;

Procedure TfrmMagImageInfoSys.RunNetConnectforAbsandFull1Click(Sender: Tobject);
Var
  Xmsg: String;
Begin
  idmodobj.GetMagFileSecurity.MagOpenSecurePath(CurImageRecord.AFile, Xmsg);
  ShowSecurityMsgs;
  Memo1.Lines.Add('{--------------------}');
  idmodobj.GetMagFileSecurity.MagOpenSecurePath(CurImageRecord.FFile, Xmsg);
  ShowSecurityMsgs;
  Memo1.Lines.Add('{--------------------}');
End;

Procedure TfrmMagImageInfoSys.Help1Click(Sender: Tobject);
Begin
  Panel2.Visible := True;
End;

Procedure TfrmMagImageInfoSys.SpeedButton1Click(Sender: Tobject);
Begin
  Panel2.Visible := False;
End;

Procedure TfrmMagImageInfoSys.MnuImageTXTFileClick(Sender: Tobject);
Begin
  OpenTextFile;
End;

Procedure TfrmMagImageInfoSys.OpenTextFile;
Var
  t: TStrings;
  Xmsg: String;
Begin
  Memo1.Lines.Add('{--------------------}');
  t := Tstringlist.Create;
  Try
    MagImageManager1.GetImageTxtFileText(CurImageRecord, t, Xmsg);
    If t = Nil Then
    Begin
      Memo1.Lines.Add(Xmsg);
      Exit;
    End;
    Memo1.Lines.AddStrings(t);
  Finally
    t.Free;
  End;
  Memo1.Lines.Add('{--------------------}');
End;

Procedure TfrmMagImageInfoSys.ImageDataObject1Click(Sender: Tobject);
Begin
  GetTImageData;
End;

Procedure TfrmMagImageInfoSys.GetTimageData;
Var
  TempIobj: TImageData;
  Ien: String;
  Rstat: Boolean;
  Rmsg: String;
Begin
  Ien := EMagNode.Text;
  If Ien <> CurImageRecord.Mag0 Then
  Begin
    {p94t2  gek  11-19-09  decouple from u magdisplaymgr}
    //        TempIobj := IENtoTImageData(ien, rstat, rmsg);
    TempIobj := idmodobj.GetMagDBMVista1.IENtoTImageData(Ien, Rstat, Rmsg);
    self.InitImage(TempIobj);  //117
    (*If TempIobj = Nil Then
      begin
      self.CurImageRecord := nil;
      exit;
      end;

    CurImageRecord := TempIobj;
    *)
  End;

  DisplayTimageData;
End;

Procedure TfrmMagImageInfoSys.atm(s: String; S2: String = '');
Var
  Str: String;
Begin
  If S2 <> '' Then
    s := s + '    ' + S2;
  Memo1.Lines.Add(s + #13);
  If (Memo1.Lines.Count > 2000) Then
    While (Memo1.Lines.Count > 1700) Do
      Memo1.Lines.Delete(0);
End;

Procedure TfrmMagImageInfoSys.atm(s: String; t: TStrings);
Var
  Str: String;
  i: Integer;
Begin
  Memo1.Lines.Add(s + #13);

  For i := 0 To t.Count - 1 Do
  Begin
    Memo1.Lines.Add(' - ' + t[i] + #13);
  End;
  If (Memo1.Lines.Count > 2000) Then
    While (Memo1.Lines.Count > 1700) Do
      Memo1.Lines.Delete(0);
End;

Function TfrmMagImageInfoSys.Execute(IObj: TImageData): Boolean;
//var rmsg : string;
Begin
//    if not u magdisplaymgr.IsThisImageLocal(Iobj,dmod.MagDBBroker1,rmsg) then
//      begin
//      messagedlg('Information Advanced utility is not designed to '
//                  + #13 + 'handle remote Image Data.  Operation canceled.',mtconfirmation,[mbok],0);
//      exit;
//      end;
  Result := True;
  If Not Doesformexist('frmMagImageInfoSys') Then
  Begin
    Application.CreateForm(TfrmMagImageInfoSys, FrmMagImageInfoSys);
    FormToNormalSize(FrmMagImageInfoSys);
        // := TfrmMagImageInfoSys.create(self);
    If (FrmMagImageInfoSys.Left < 0) Then
      FrmMagImageInfoSys.Left := 0;
    If (FrmMagImageInfoSys.Top < 0) Then
      FrmMagImageInfoSys.Top := 0;
  End;
  FrmMagImageInfoSys.InitImage(Iobj);
  FrmMagImageInfoSys.DisplayImageInfo();
  FrmMagImageInfoSys.Show;
End;


procedure TfrmMagImageInfoSys.InitImage(vObj : TimageData);
var rstat : boolean;
    rmsg : string;
begin
  {/p117 gek  DisplayImageInfo is only called from the Execute Method when info for a new image is being
         displayed, so we can Initialize here.  }
  CurrentImageJBPath := '';
  if vobj <> nil  then
    begin
     {HERE we make the RPC Call to get JB Path if a Deleted Image.}
    if vObj.IsImageDeleted then
       BEGIN
       // TESTING   currentImageJBPath := vObj.Mag0 + ' JB JB JB JB JB JB JB ';
        idmodobj.GetMagDBBroker1.RPMagJukeBoxPath(rstat,rmsg,vObj.mag0);
        currentImageJBPath := rmsg;
       end;
    end;

  CurImageRecord := vObj;
end;

Procedure TfrmMagImageInfoSys.DisplayImageInfo();
Begin
  DisplayCurrentIENInfo;
End;

Procedure TfrmMagImageInfoSys.DisplayCurrentIENInfo;
Begin

  EMagNode.Text := CurImageRecord.Mag0;
  Memo1.Lines.Add('IEN         :  ' + CurImageRecord.Mag0 + #13);
  Memo1.Lines.Add('Abstract    : ' + CurImageRecord.AFile + #13);
  Memo1.Lines.Add('Full Res    : ' + CurImageRecord.FFile + #13);
  If (CurImageRecord.QAMsg <> '') Then
    Memo1.Lines.Add('QA Message  : ' + CurImageRecord.QAMsg + #13); //Patch 5
    //if (curImageRecord.BigFile <> '') then
  Memo1.Lines.Add('Big File    : ' + CurImageRecord.BigFile + #13); //Patch 5
  if self.CurrentImageJBPath <> ''  then
    Memo1.Lines.Add('JB Path     : ' + CurrentImageJBPath);  //p117
  

  Memo1.Lines.Add('Short Desc  : ' + CurImageRecord.ImgDes + #13);
  Memo1.Lines.Add('Image Type  : ' + Inttostr(CurImageRecord.ImgType) + #13);
  Memo1.Lines.Add('Patient     : ' + CurImageRecord.PtName + #13);
  Memo1.Lines.Add('Proc Date   : ' + CurImageRecord.Date + #13);
  Memo1.Lines.Add('Procedure   : ' + CurImageRecord.Proc + #13);
  Memo1.Lines.Add('Abs Location: ' + CurImageRecord.AbsLocation + #13);
  Memo1.Lines.Add('Full Image Accessable/Offline  : ' + CurImageRecord.FullLocation + #13);
    // JMW 2/23/2005 p45
  Memo1.Lines.Add('Server Name  : ' + CurImageRecord.ServerName + #13);
  Memo1.Lines.Add('Server Port  : ' + Inttostr(CurImageRecord.ServerPort) + #13);
  CurrentServer := CurImageRecord.ServerName;
  CurrentPort := CurImageRecord.ServerPort;
    //45
  Memo1.Lines.Add('{--------------------}');
  If (Memo1.Lines.Count > 2000) Then
    While (Memo1.Lines.Count > 1700) Do
      Memo1.Lines.Delete(0);
End;

Procedure TfrmMagImageInfoSys.DisplayTimageData;
Var
  IObj: TImageData;
  t: TStrings;
  Rmsg: String;
Begin
  Try
    t := Tstringlist.Create;
    IObj := CurImageRecord;
    EMagNode.Text := IObj.Mag0;
        {  Now we bring the Patient Name in the string from vista
            Result.PtName := PatName;  see below}
    ATM(' ');
    ATM(' * * * *  * * * * START TImageData for IEN : ' + IObj.Mag0 + '  * * * *  * * * * ');
 //       ATM('Is This Image Local :     ', magbooltostr(IsThisImageLocal(iobj, dmod.MagDBBroker1, rmsg)));
	ATM('Is This Image Local to Site:     ', Magbooltostr(MagImageManager1.IsThisImageLocaltoSite(IObj)));
    If Rmsg <> '' Then
      ATM('return message: ' + Rmsg);
    ATM(' ');
    ATM('2 Mag0   ', IObj.Mag0);
    ATM('3 FFile   ', IObj.FFile);
    ATM('4 AFile   ', IObj.AFile);
    ATM('5 ImgDes    ', IObj.ImgDes);
        // PI^.FMProcDate :=magpiece(t[i],'^',6);
    ATM('7 ImgType   ', Inttostr(IObj.ImgType));
    ATM('8 Proc   ', IObj.Proc);
    ATM('9 Date   ', IObj.Date);
        //the PARENT DATA FILE image pointer is in $p(10)
        //PI^.DemoRpt :=  magpiece(t[i],'^',10);
    ATM('11 AbsLocation   ', IObj.AbsLocation);
    ATM('12 FullLocation   ', IObj.FullLocation);
    ATM('13 DicomSequenceNumber   ', IObj.DicomSequenceNumber);
    ATM('14 DicomImageNumber   ', IObj.DicomImageNumber);

    ATM('15 GroupCount   ', Inttostr(IObj.GroupCount));
        { $p(15^16 )(16^17 here) are SiteIEN and SiteCode Consolidation - DBI}
    ATM('16 PlaceIEN   ', IObj.PlaceIEN);
    ATM('17 PlaceCode    ', IObj.PlaceCode);
    ATM('18 QAmsg    ', IObj.QAMsg);
    ATM('19 BigFile    ', IObj.BigFile);
    ATM('20 DFN    ', IObj.DFN);
    ATM('21 PtName   ', IObj.PtName);
    ATM('22 MagClass    ', IObj.MagClass);
    ATM('23 CaptureDate    ', IObj.CaptureDate);
    ATM('24 DocumentDate    ', IObj.DocumentDate);

    ATM('25 IGroupIEN   ', Inttostr(IObj.IGroupIEN));
    ATM('26:1 ICh1IEN     ', Inttostr(IObj.ICh1IEN));
    ATM('26:2 ICh1Type    ', Inttostr(IObj.ICh1Type));

    ATM('27 ServerName   ', IObj.ServerName);
    ATM('28 ServerPort   ', Inttostr(IObj.ServerPort));

    ATM('29 MagSensitive    ', Magbooltostr(IObj.MagSensitive));
    ATM('30 MagViewStatus    ', Inttostr(IObj.MagViewStatus));
    ATM('31 MagStatus    ', Inttostr(IObj.MagStatus));

    {/ P122 - JK 7/29/2011 - adding in new pieces /}
    ATM('32 Annotated    ', Magbooltostr(IObj.Annotated));
    ATM('33 IsNoteComplete    ', IObj.Resulted);
    ATM('34 Annotation Status    ', IntToStr(IObj.AnnotationStatus));
    ATM('35 Annotation Status Desc    ', IObj.AnnotationStatusDesc);
    ATM('36 Package    ', IObj.Package);

    ATM(' ');
    ATM('Functions: ');
//        ATM('IsThisImageLocal :  ', magbooltostr(IsThisImageLocal(iobj, dmod.MagDBBroker1, rmsg)));
    ATM('IsThisImageLocaltoSite :  ', Magbooltostr(MagImageManager1.IsThisImageLocaltoSite(IObj)));
    ATM('IsOnOffLineJB   :  ', Magbooltostr(IObj.IsOnOffLineJB));
    ATM('IsInImageGroup  :  ', Magbooltostr(IObj.IsInImageGroup));
    ATM('IsImageGroup    :  ', Magbooltostr(IObj.IsImageGroup));
    ATM('IsRadImage        :  ', Magbooltostr(IObj.IsRadImage));
    ATM('IsViewAble        :  ', Magbooltostr(IObj.IsViewAble));
      {/p117 gek 11/23/10  in 117 because of DelImagPlaceHolder gek}
    ATM('IsDeleted         :  ', MagBooltostr(Iobj.IsImageDeleted));
    ATM('GetViewStatusMsg   :  ', IObj.GetViewStatusMsg);
    ATM('GetStatusDesc      : ', IObj.GetStatusDesc);

    ATM(' ');
    ATM('Display functions: ');
    ATM('ExpandedDescription()      ', IObj.ExpandedDescription(False));
    t.Text := IObj.ExpandedDescription;
    ATM('ExpandedDescription(LF)    ', t);

    ATM('ExpandedIDDescription()      ', IObj.ExpandedIDDescription(False));
    t.Text := IObj.ExpandedIDDescription;
    ATM('ExpandedIDDescription(LF)    ', t);

    ATM('ExpandedIdDateDescription()      ', IObj.ExpandedIdDateDescription(False));
    t.Text := IObj.ExpandedIdDateDescription;
    ATM('ExpandedIdDateDescription(LF)    ', t);

    ATM('ExpandedDescDtID()      ', IObj.ExpandedDescDtID(False));
    t.Text := IObj.ExpandedDescDtID;
    ATM('ExpandedDescDtID(LF)    ', t);

    t.Text := IObj.ExpandedMLDescription;
    ATM('ExpandedMLDescription(LF)   ', t);
    ATM(' ');
    ATM(' * * * * End TImageData for IEN : ' + IObj.Mag0 + ' * * * * ');
    ATM('{--------------------}');
    ATM(' ');
  Finally
    t.Free;
  End;
End;
(*
 {  Now we bring the Patient Name in the string from vista
     Result.PtName := PatName;  see below}
 Result.Mag0 := magPiece(str, '^', 2);
 Result.FFile := magPiece(str, '^', 3);
 Result.AFile := magPiece(str, '^', 4);
 Result.ImgDes := magPiece(str, '^', 5);
 // PI^.FMProcDate :=magpiece(t[i],'^',6);
 Result.ImgType := magStrToInt(magPiece(str, '^', 7));
 Result.Proc := magPiece(str, '^', 8);
 Result.Date := magPiece(str, '^', 9);
 //the PARENT DATA FILE image pointer is in $p(10)
 //PI^.DemoRpt :=  magpiece(t[i],'^',10);
 Result.AbsLocation := magPiece(str, '^', 11);
 Result.FullLocation := magPiece(str, '^', 12);
 Result.DicomSequenceNumber := magPiece(str, '^', 13);
 Result.DicomImageNumber := magPiece(str, '^', 14);

 Result.GroupCount := magStrToInt(magPiece(str, '^', 15));
 { $p(15^16 )(16^17 here) are SiteIEN and SiteCode Consolidation - DBI}
 Result.PlaceIEN := magPiece(str, '^', 16);
 Result.PlaceCode := magPiece(str, '^', 17);
 Result.QAmsg := magPiece(str, '^', 18);
 Result.BigFile := magPiece(str, '^', 19);
 Result.DFN := magPiece(str, '^', 20);
 Result.PtName := magPiece(str, '^', 21);
 Result.MagClass := magPiece(str, '^', 22);
 Result.CaptureDate := MagPiece(str, '^', 23);
 Result.DocumentDate := MagPiece(str, '^', 24);

 Result.IGroupIEN := magStrToInt(magpiece(str, '^',25));
 Result.ICh1IEN := magStrToInt(magpiece(magpiece(str,'^',26),':',1)); //26 is Ch1:Ch1Type
 Result.ICh1Type := magStrToInt(magpiece(magpiece(str,'^',26),':',2)); //26 is Ch1:Ch1Type

   Result.ServerName := magPiece(str, '^', 27);
   Result.ServerPort := magstrtoint(magPiece(str, '^', 28));

 Result.MagSensitive := magstrtobool(magPiece(str, '^', 29));
 Result.MagViewStatus := magstrtoint(magPiece(str, '^', 30));
 Result.MagStatus := magstrtoint(magPiece(str, '^', 31));
*)

Procedure TfrmMagImageInfoSys.eMagNodeKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin

  If Key = 37 Then
    DecIEN; {Left Arrow}
  If Key = 38 Then
    IncIEN; {Up Arrow}
  If Key = 39 Then
    IncIEN; {Right Arrow}
  If Key = 40 Then
    DecIEN; {Down Arrow}
  If Key = VK_Return Then
    DisplayGlobalNode;
  If Key = VK_F5 Then { key = 116}
    GetGroupIEN;
End;

Procedure TfrmMagImageInfoSys.GetGroupIEN;
Var
  i: Integer;
  s, mcode: String;
  oien: String;
Begin
  If EMagNode.Text = '' Then
  Begin
    DisplayGlobalNode;
    Exit;
  End;
  oien := EMagNode.Text;
    //  $p(^MAG(2005,19538,0),"^",10)
  mcode := '$P($G(^MAG(2005,' + EMagNode.Text + ',0)),"^",10)';
  s := idmodobj.GetMagDBBroker1.RPXWBGetVariableValue(mcode);
  EMagNode.Text := s;
  If EMagNode.Text = '' Then
  Begin
    atm('Group IEN for ' + oien + '  is NULL');
    EMagNode.Text := oien;
    Exit;
  End;
  atm('Group IEN for ' + oien + ' = ' + s);
  DisplayGlobalNode;
End;

Procedure TfrmMagImageInfoSys.IncIEN;
Var
  i: Integer;
  s: String;
Begin
  If EMagNode.Text = '' Then
    EMagNode.Text := '0';

  Try
    i := Strtoint(EMagNode.Text);
    i := i + 1;
    EMagNode.Text := Inttostr(i);
    displayGlobalNode;

  Except
    atm('Error converting strint to integer');
  End;
End;

Procedure TfrmMagImageInfoSys.DecIEN;
Var
  i: Integer;
  s: String;
Begin
  Try
    If EMagNode.Text = '' Then
    Begin
      DisplayGlobalNode;
      Exit;
    End;
    i := Strtoint(EMagNode.Text);
    i := i - 1;
    EMagNode.Text := Inttostr(i);
    displayGlobalNode;

  Except
    atm('Error converting string to integer');
  End;

End;

Procedure TfrmMagImageInfoSys.DisplayGlobalNode;
Var
  t: TStrings;
  i: Integer;
Begin
  If EMagNode.Text = '' Then
    GetLastIEN;
    { TODO -cdemo : Make the Image Information advanced window, Disabled for the Demo. }
  t := Tstringlist.Create;
  Try
    idmodobj.GetMagDBSysUtils1.RPMaggSysGlbNode(EMagNode.Text, CurrentServer, CurrentPort, t); //45
    For i := 0 To t.Count - 1 Do
      Memo1.Lines.Add(t[i]);
    Memo1.Lines.Add('{--------------------}');

  Finally
    t.Free;
  End;

End;

Procedure TfrmMagImageInfoSys.GetLastIEN;
Var
  s, mcode: String;
Begin
  mcode := '$O(^MAG(2005," "),-1)';
  s := idmodobj.GetMagDBBroker1.RPXWBGetVariableValue(mcode);
  EMagNode.Text := s;

  atm('Last Node of Image File = ' + s);

End;

Procedure TfrmMagImageInfoSys.eFlagsDblClick(Sender: Tobject);
Var
  s, mcode: String;
Begin
    //mcode := '$O(^MAG(2005,""))';
  mcode := EFlags.Text;
  s := idmodobj.GetMagDBBroker1.RPXWBGetVariableValue(mcode);
  atm(s);

End;

Procedure TfrmMagImageInfoSys.eMagNodeDblClick(Sender: Tobject);
Begin
  DisplayGlobalNode;
End;

Procedure TfrmMagImageInfoSys.GroupIENofCurrentIEN1Click(Sender: Tobject);
Begin
  GetGroupIEN;
End;

Procedure TfrmMagImageInfoSys.PreviousIEN1Click(Sender: Tobject);
Begin
  DecIEN;
End;

Procedure TfrmMagImageInfoSys.NextIEN1Click(Sender: Tobject);
Begin
  IncIEN;
End;

Procedure TfrmMagImageInfoSys.eMagNodeMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x,
  y: Integer);
Begin
  If Button = MbMiddle Then
  Begin
    incien;
  End;
End;

Procedure TfrmMagImageInfoSys.Memo1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = 37 Then
    DecIEN; {Left Arrow}
  If Key = 38 Then
    IncIEN; {Up Arrow}
  If Key = 39 Then
    IncIEN; {Right Arrow}
  If Key = 40 Then
    DecIEN; {Down Arrow}
  If Key = VK_Return Then
    DisplayGlobalNode;
  If Key = VK_F5 Then { key = 116}
    GetGroupIEN;
End;

Procedure TfrmMagImageInfoSys.ToolButton1Click(Sender: Tobject);
Begin
  If EMagNode.Text = '' Then
    GetLastIEN;
  DisplayGlobalNode;
End;

Procedure TfrmMagImageInfoSys.ToolButton6Click(Sender: Tobject);
Begin
  IncIEN;
End;

Procedure TfrmMagImageInfoSys.ToolButton7Click(Sender: Tobject);
Begin
  DEcIEN;
End;

Procedure TfrmMagImageInfoSys.ToolButton8Click(Sender: Tobject);
Begin
  Self.GetGroupIEN;
End;

Procedure TfrmMagImageInfoSys.ToolButton9Click(Sender: Tobject);
Begin
  GetTImageData;
End;

Procedure TfrmMagImageInfoSys.ToolButton10Click(Sender: Tobject);
Begin
  DisplayCurrentIENInfo;
End;

Procedure TfrmMagImageInfoSys.ToolButton4Click(Sender: Tobject);
Begin
  Self.GetFieldValues;
End;

Procedure TfrmMagImageInfoSys.ToolButton11Click(Sender: Tobject);
Begin
  OpenTextFile;
End;

Procedure TfrmMagImageInfoSys.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
End;

End.
