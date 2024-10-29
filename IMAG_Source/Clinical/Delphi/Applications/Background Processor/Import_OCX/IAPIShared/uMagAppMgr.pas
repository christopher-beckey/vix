Unit UMagAppMgr;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   2002
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==       unit uMagAppMgr;
   Description:   Common Utilites for Imaging Applications to use.
      (Display and Capture for now)
      ==]

   Note:
   }
(*
        ;; +------------------------------------------------------------------+
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
        ;; +------------------------------------------------------------------+

*)
Interface
Uses
  Forms,
  Classes,
  SysUtils,
  Dialogs,
  WinTypes,
  cMagDBBroker,
  DmSingle,
  {maggmsgu,} Umagutils8,
  UMagClasses,
  Magfileversion,
  cMag4Vgear
  , {maggut4,}
  FMagImageInfo,
  //cMagLogManager ,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  UMagDefinitions;
        {       VistA code checks Delphi Version against allowed Client Versions.
                Client can be told
                        Okay to Continue.
                        Display warning and Continue
                        Abort.  Client has to Terminate.}
Procedure CheckImagingVersion(Client: TMagApplicationTypes; MagDBBroker: TMagDBBroker);

        {       Opens frmMagImageInfo.dfm and displays VistA information about
                the Image.}
Procedure ShowImageInformation(IObj: TImageData; VGear: TMag4VGear = Nil);

        {       Makes the OS call to get the Network Computer Name}
Function GetMagComputerName: String; //Patch 59
//var  UseAutoRealign : boolean;
{ The forms with a TMag4Viewer and the TMag4Viewer
                                   will autorealign the images when window is
                                   resized, or viewer is scrolled.}

//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring - remove old method}

Function GetSecurityToken(): String;

Implementation

(*  Brokers Applicatoin Exception handler.  Exceptions are displayed in
     in this way, unless we create our own. *)
(*
class procedure TfrmErrMsg.RPCBShowException(Sender: TObject; E: Exception);
begin
  frmErrMsg := TfrmErrMsg.Create(Application);
  frmErrMsg.mmoErrorMessage.Lines.Add(E.Message);
  frmErrMsg.ShowModal;
  frmErrMsg.Free;
end;   *)

Procedure ShowImageInformation(IObj: TImageData; VGear: TMag4VGear = Nil);
Begin
  If Not Doesformexist('frmMagImageInfo') Then FrmMagImageInfo := TfrmMagImageInfo.Create(Application.MainForm);
  FrmMagImageInfo.ShowInfo(IObj, VGear);
  FrmMagImageInfo.BringToFront;
End;

{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  dmod.MagLogManager.LogEvent(nil, MsgType, Msg, Priority);
//end;

Procedure CheckImagingVersion(Client: TMagApplicationTypes; MagDBBroker: TMagDBBroker);
Var
  t: TStrings;
  i, ResCode: Integer;
  Magver, s: String;
Begin
  t := Tstringlist.Create;
  Try
    Magver := MagGetFileVersionInfo(Application.ExeName);
    Case Client Of
      MagappCapture: Magver := Magver + '||CAPTURE|';
      MagappDisplay: Magver := Magver + '||DISPLAY|';
      MagappTeleReader: Magver := Magver + '||TELEREADER|';
    End;

  //MaggMsgf.magmsg('s', 'Version Check...');
    //LogMsg('s', 'Version Check...');
    MagLogger.LogMsg('s', 'Version Check...'); {JK 10/6/2009 - Maggmsgu refactoring}
    MagDBBroker.RPMagVersionCheck(t, Magver);
    Try
      ResCode := Strtoint(MagPiece(t[0], '^', 1));
    Except
      ResCode := 0;
    End;
    {  Prior to Version 3.0.8.21 the string '1^Version not Checked, continue'
           was always returned.
      We'll use that to tell us the Server is not Patch 8, and Terminate.}
    If t[0] = '1^Version not Checked, continue' Then
    Begin
      {          We'll put a message in t.}
      t[0] := ('2^The Version of Imaging on the Server is too old:');
      t.Add('   Server Version is Prior to Version 3.0.8');
      t.Add('   Client Version is ' + Magver);
      t.Add('  ');
      t.Add('   This application is not able to run.');
      t.Add('   Inform the Imaging System Manager.');
      t.Add('  ');
      ResCode := 2;
    End;
    s := MagPiece(t[0], '^', 2) + #13;
//    maggmsgf.magmsg('s','  -> Result : ' + t[0]); //NULLPANEL out
    //LogMsg('s','  -> Result : ' + t[0]); //NULLPANEL out
    MagLogger.LogMsg('s', '  -> Result : ' + t[0]); //NULLPANEL out{JK 10/6/2009 - Maggmsgu refactoring}

    If (t.Count > 1) Then
    Begin
      For i := 1 To t.Count - 1 Do
        s := s + t[i] + #13;
       // messagedlg(s, mtconfirmation, [mbok, mbcancel], 0)

      (* message from VistA, Sends a result code (rescode)
         we can use the rescode to let user continue or not.
        rescode := 2   // force exit;
        rescode := 1;  // allow to continue
        rescode := 0   // allow to continue
        -- in any case, if t.count > 1, we will display the message
        *)
      {  Future maybe:
          here we might take action depending on the modal result of the Dlg
          and set rescode = 2 to stop the application.}

    End;

    Case ResCode Of
      {         Warning : Display the warning and continue. {}
      0:
        Begin
//           MaggMsgf.magmsg('s', 'Result of Version check = 0');
           //LogMsg('s', 'Result of Version check = 0');
          MagLogger.LogMsg('s', 'Result of Version check = 0'); {JK 10/6/2009 - Maggmsgu refactoring}
          Messagedlg(s, MtWarning, [Mbok], 0)
        End;

      {         OK to continue {}
      1:
        Begin
//           MaggMsgf.magmsg('s', 'Result of Version check = 1');
           //LogMsg('s', 'Result of Version check = 1');
          MagLogger.LogMsg('s', 'Result of Version check = 1'); {JK 10/6/2009 - Maggmsgu refactoring}
        End;

      {         Must Terminate {}
      2:
        Begin
//           MaggMsgf.magmsg('s', 'Result of Version check = 2');
           //LogMsg('s', 'Result of Version check = 2');
          MagLogger.LogMsg('s', 'Result of Version check = 2'); {JK 10/6/2009 - Maggmsgu refactoring}
          s := s + #13 + 'APPLICATION WILL ABORT !.';
          Messagedlg(s, Mterror, [Mbabort], 0);
          Application.Terminate;
          Application.Processmessages;
        End;
      3:
        Begin
           //
        End;
    Else
      //LogMsg('s', 'Undocumented Result of Version Check : ' + inttostr(rescode) + ' continuing.');//MaggMsgf.magmsg('s', 'Undocumented Result of Version Check : ' + inttostr(rescode) + ' continuing.');
      MagLogger.LogMsg('s', 'Undocumented Result of Version Check : ' + Inttostr(ResCode) +
        ' continuing.'); //MaggMsgf.magmsg('s', 'Undocumented Result of Version Check : ' + inttostr(rescode) + ' continuing.'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  Finally
    t.Free;
  End;
End;

Function GetMagComputerName: String;
Var
  LpBuffer: PChar;
  NSize: DWORD;
Begin
  Result := '';
 (* lpBuffer := stralloc(100);  *)
  GetMem(LpBuffer, 100);
  NSize := 100;
  Try
    If GetComputerName(LpBuffer, NSize) Then
      Result := Strpas(LpBuffer);
  Except
    On Exception Do
    Begin
      Result := 'UnDefinedComputerName';
    End;
  End;
 (* StrDispose(lpBuffer); *)
  FreeMem(LpBuffer);
End;

{/ P94 JMW 10/5/2009 - return a broker security token (BSE) /}

Function GetSecurityToken(): String;
Begin
  Result := Dmod.MagDBBroker1.RPMagSecurityToken();
End;

End.
