Unit cMagSecurity;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[==       unit cMagSecurity;
 Description:    VistA Imaging Network Server Security Component.
        For security reasons, Imaging workstations are not connected to the Image Servers
        The application uses this component to connect and disconnect as needed to
        the Image Servers. This is OS Specific, for Win32 calls.
        In a different OS, this component could be replaced by OS Specific code,
        and the Application could function with minimial changes needed.
        Any function that opens image files, will need this component.
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

p158 p161
This version of cMagSecurity has the changes from Import API OCX, 158 Merged into the Imaging\Shared 
version of cMagSecurity.   The Changes here, do not change the functionality of any 
procedures or functions.
*)

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
  Stdctrls,
  Umagutils8,
  FileCtrl,
  Hash { , MagImageManager } {JMW 4/25/2005 p45}; //45

Type
  TMag4Security = Class(TComponent)
  Private
    FSecurityOn: Boolean;
    FDemoModeOn: Boolean;
    FUsername: String;
    FPassword: String;
    FConnectErrors: TStrings;
    FDisconnectErrors: TStrings;
    Fwriteaccesslist: TStrings;
    FShareList: TStrings;
    FGoodList: TStrings;
    FBadList: TStrings;
    FAccessPaths: TStrings;
    FMsgList: TStrings;  {this is the internal list maintained by the function}
    FTestFile: TStrings;
    Procedure SetMsgList(Value: TStrings);
    Procedure SetShareList(Value: TStrings);
    Procedure SetAccessPaths(Value: TStrings);
    Procedure LoadConnectErrors;
    Procedure LoadDisConnectErrors;
    Function ErrorText(Code: Char; i: Integer): String;
    Procedure MsgToList(s: String);
//    function StrtoPchar(FromValue: string): Pchar;
    //45function ParseServerShare(filename: string): string;
    Function SecurityNeeded(Var Xmsg: String; Filename: String): Boolean;
    Function ConfirmUserNamePassword(Var Xmsg, SUserID, SPW: String; TmpUser, TmpPass, Servershare: String): Boolean;
    Function OSConnectToServer(Var Xmsg: String; SPW, SUserID, Servershare, Filename: String): Boolean;
    Procedure SetSecurityOn(Const Value: Boolean);

  Protected

  Public
    Constructor Create(AOwner: TComponent); Override; { Public declarations }
    Destructor Destroy; Override;

            {  Main call to open a secure connection to the server.}
            {      filename         : is the full path to the Image.
                   xmsg             : is returned
                   tmpUser, tmpPass : override the Published Propertys UserName and Password
                   createdir        : to allow/disallow creating new directories.}
    Function MagOpenSecurePath(Filename: String; Var Xmsg: String; TmpUser: String = ''; TmpPass: String = ''; CreateDir: Boolean = False): Boolean;

            {   Close all Open Connections to any Image Server}
    Function MagCloseSecurity(Var vmsgs: String; AddToList: Boolean = False): Boolean;

    Function ParseServerShare(Filename: String): String; // JMW 6/20/2005 p45 needed to use elsewhere

    Function SetNetUsernamePassword(Userpass: String; Var Xmsg: String): Boolean;
    //procedure GetGoodList(var t: Tstringlist);
    //procedure GetBadList(var t: Tstringlist);

  Published

            {  Retrieved from M.  Needed to make the connection to the Server}
    Property Password: String Read FPassword Write FPassword;
    Property Username: String Read FUsername Write FUsername;

            {  We don't check security when running in Demo Mode.}
    Property DemoModeOn: Boolean Read FDemoModeOn Write FDemoModeOn;

            {  We can turn off Network Security.  Mainly for use by System manager. Debugging}
    Property SecurityOn: Boolean Read FSecurityOn Write SetSecurityOn;
            {}
    Property ShareList: TStrings Read FShareList Write SetShareList;
    Property AccessPaths: TStrings Read FAccessPaths Write SetAccessPaths;

           {  List of messages compiled during current MagOpenSecurePath function call.
              Cleared after each call.}
    Property Msglist: TStrings Read FMsgList Write SetMsgList;

  End;

Procedure Register;

Implementation

//uses MagImageManager ;
{function netconnect2( lpnetresource: TNetResourceA; lpszPassword: LPSTR;
             lpszUsername: LPSTR; dwFlags: DWORD ):DWORD; external 'sconn32.dll' index 1;

function Netdisconnect2(lpzname: LPSTR; fwdConnection: DWORD;
             fForce: Boolean):DWORD; external 'sconn32.dll' index 2;
}

Constructor TMag4Security.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FShareList := Tstringlist.Create;
  FGoodList := Tstringlist.Create;
  FBadList := Tstringlist.Create;
  Fwriteaccesslist := Tstringlist.Create;
  FAccessPaths := Tstringlist.Create;
  FConnectErrors := Tstringlist.Create;
  FDisconnectErrors := Tstringlist.Create;
  FMsgList := Tstringlist.Create;
  FSecurityOn := True;
  LoadConnectErrors;
  LoadDisConnectErrors;
  FTestFile := Tstringlist.Create;
  FTestFile.Add('  ** Start ** ');
  FTestFile.Add('Test file to prove ability to write to a directory');
  FTestFile.Add('  ** End ** ');
End;
{-------------------------------------------------------}

Destructor TMag4Security.Destroy;
Begin
  Fwriteaccesslist.Free;
  FShareList.Free;
  FGoodList.Free;
  FBadList.Free;
  FAccessPaths.Free;
  FConnectErrors.Free;
  FDisconnectErrors.Free;
  FMsgList.Free;
  FTestFile.Free;
  Inherited;
End;

{-------------------------------------------------------}
(*
function TMag4Security.StrtoPchar(FromValue: string): Pchar;
var size: integer;

begin
  size := length(FromValue);
  Result := stralloc(size + 1);
  StrPCopy(Result, FromValue);
end;   *)

{-------------------------------------------------------}

Function TMag4Security.MagOpenSecurePath(Filename: String; Var Xmsg: String; TmpUser: String = ''; TmpPass: String = ''; CreateDir: Boolean = False): Boolean;
Var
  Servershare: String;
  PW, UserID: String;
  Ymsg: String;
  Xcursor: TCursor;
  OSError : integer;
Begin
(*   WNetGetUniversalName()
     GetDriveType()  *)
  Xcursor := Screen.Cursor;
  Try
    Screen.Cursor := crHourGlass;
  // Each attempt to connect creates a message list.
    FMsgList.Clear;
    MsgToList('Image Security for Filename: ' + Filename);
    Result := False;

  { Quit if Demo Mode, Security is OFF, or Image file is on Local/Mapped drive}
    If Not SecurityNeeded(Xmsg, Filename) Then
    Begin
      Result := True;
      Exit;
    End;
  { Get just the \\Server\share from the filename}
    Servershare := ParseServerShare(Filename);
  { Use Kernel utilities to Decrypt the UserName and Password.
    and return the Username and Password to use in this instance.}
    If Not ConfirmUserNamePassword(Xmsg, UserID, PW, TmpUser, TmpPass, Servershare) Then Exit;

    If (FBadList.Indexof(Servershare) > -1) Then
    Begin
      {       Note:  IAPI only attempts connection Once.  if it fails, the \\Server\Share
              is put into a 'Bad List' and connection is not attempted again.  This was made for Capture
              workstation in very early version of Capture.
              These two functions clear the BadList, so the connection is attempted again next import
              :  Function MagCloseSecurity,
              :  Function SetSecurityON(boolean)
             This is used for Abstract windows.  So we Don't attempt to connect to an inaccessible
             network share 24 times.}
      //Xmsg := 'ERROR: ' + Servershare + ' is Not Accessible.';
      Xmsg := 'Connection CANCELED.  Server\Share has been Flagged as Not Accessible.';
      MsgToList(Xmsg);
      Exit;
    End;

  { Connect to the server/share using the OS Calls.{}

   {the OSConnectToServer and other functions have been enhanced to check GetLastError
       and insert any Error codes and messages into MsgList.
       The OSConnectToServer function makes use of MsgToList, to return details of the
       Success or Failure of the connection attempt}
    If Not OSConnectToServer(Xmsg, PW, UserID, Servershare, Filename) Then
    Begin
      Exit;
    End;


  { Keep a GoodList of successful connections.  When MagCloseSecurity
     is called.  We'll disconnect from all in this list. }
    If (FGoodList.Indexof(Servershare) = -1) Then FGoodList.Add(Servershare);

  {If we are copying to an Image Server, we might have to create a new
     directory.  (The caller must have sent the 'createdir' parameter =TRUE
     for us to create a directory. }
    try
    If (CreateDir And (Not Directoryexists(ExtractFileDir(Filename)))) Then
    Begin
     {$I-} // silence OS Error raising
      Forcedirectories(ExtractFileDir(Filename));
      {$I+}
     {we check GetLastError, but we don't believe the Error Returned, we also continue to 
       check If DirectoryExist( )   this give us a True Status of the Attempt.}
     OSError := GetLastError;
      if (OSError <> 0) then
         begin
         MsgToList('ForceDirectories Error: ');
         MsgToList('GetLastError: ' + inttostr(osError) + ' - '+ syserrormessage(osError));
         end;
      If Not Directoryexists(ExtractFileDir(Filename)) Then
      Begin
        Xmsg := 'FATAL: Cannot create directory: ' + ExtractFileDir(Filename);
        MsgToList(Xmsg);
        MagCloseSecurity(Ymsg, True);
        MsgToList(Ymsg);
        Exit;
      End
      Else
        MsgToList('Directory created : ' + ExtractFileDir(Filename));
    End;
    except
      on e:exception do
        begin
        Xmsg := 'EXCEPTION: Creating Directory.';
        MsgToList(Xmsg + ' ' + ExtractFilePath(Filename));
        MsgToList('OS exception: ' + e.Message);
        MagCloseSecurity(Ymsg, True);
        MsgToList(Ymsg);
        Exit;
        end;

    end;
    Try
    { This is in case we can connect, but don't have access, this will
      force an Access is Denied Error. This usually happens when the
             user is already connected to the Network. We'll get a
             'Credential Conflict' error, we'll continue, but get access
              denied when trying to copy the image.
      Keep a list, so we only attempt writing to each directory once.  }
      If (CreateDir And (Fwriteaccesslist.Indexof(FUsername + '-' + ExtractFilePath(Filename)) = -1)) Then
      Begin
      {$I-} // silence OS Error raising
      FTestFile.SaveToFile(ExtractFilePath(Filename) + 'TestingWriteAccess.txt');
      {$I+}
      {135 added check of  getlasterror}
      osError := getLastError;
      if (osError <> 0) then
         begin
         xmsg := 'FATAL: SaveToFile.  Cannot write to Image Server.';
         msgToList(xmsg) ;
         MsgToList('Attempted write to: ' + ExtractFilePath(Filename));
         MsgToList('GetLastError: ' + inttostr(osError) + ' - '+ syserrormessage(osError));
         MagCloseSecurity(Ymsg, True);
         MsgToList(Ymsg);
         Exit;
         end;
      Application.Processmessages;
      MsgToList('Write Access tested OK to :' + ExtractFilePath(Filename));
      Fwriteaccesslist.Add(FUsername + '-' + ExtractFilePath(Filename));
      Application.Processmessages;

      {$I-} // silence OS Error raising
      DeleteFile(ExtractFilePath(Filename) + 'TestingWriteAccess.txt');
      {$I+}
      osError := getLastError;
      if (osError <> 0) then
         begin
         {135.  If we fail to delete the file. This is not fatal to IAPI.
                we will log it, but continue processing.  }

         msgToList('Warning. Failed to delete test file') ;
         msgToList('File: ' + ExtractFilePath(Filename) + 'TestingWriteAccess.txt');
         MsgToList('GetLastError: ' + inttostr(osError) + ' - '+ syserrormessage(osError));
         MagCloseSecurity(Ymsg, True);
         MsgToList(Ymsg);
         end;

      End;
    Except
      On e: Exception Do
      Begin
        Xmsg := 'EXCEPTION:  writing\deleting to Image Server.';
        MsgToList(Xmsg + ' ' + ExtractFilePath(Filename));
        MsgToList('OS exception: ' + e.Message);
        MagCloseSecurity(Ymsg, True);
        MsgToList(Ymsg);
        Exit;
      End;
    End;
    Result := True;
    Xmsg := 'Success: Image Directory is accessible.';
    MsgToList(Xmsg + ' ' + Servershare);
  Finally
    Screen.Cursor := Xcursor;
  End;
End;

Function TMag4Security.MagCloseSecurity(Var vmsgs: String; AddToList: Boolean = False): Boolean;
Var
  xx: Word;
  i, Size, goodct: Integer;
  Lpzname: LPSTR;
  FdwConnection: DWORD;
  FForce: Boolean;
Begin
  { Usually, clear the list, and create new one.
    But when called from inside TMagSecurity we won't clear it, just add to it.}

  // JMW 4/25/2005 p45, if the cachemanager is caching, then stop this
   { TODO -oGarrett -cRefactor :
This MAGIMAGEMANAGER Can't be here.  MagSecurity is only required to know about the
     Connecting and Disconnecting to the Network. }

 //     if MagImageManager1.isImageCurrentlyCaching() then exit;

  If Not AddToList Then FMsglist.Clear;
  FBadList.Clear;
  Result := True;
  If Not SecurityOn Then MsgToList('Security is OFF');
  If DemoModeOn Then MsgToList('Demo Mode. Security is OFF');
  try
  goodct := FGoodlist.count;
  For i := FGoodList.Count - 1 Downto 0 Do
  Begin
    Size := (Length(FGoodList[i]));
    Lpzname := Stralloc(Size + 1);
    Strpcopy(Lpzname, FGoodList[i]);
    FdwConnection := 0;
    FForce := True;
     {we don't specifically use getlasterror here.  we use the integer return of the call itself.
        this is same thing as getLastError.
        From Web Search : If the function succeeds, the return value is NO_ERROR.
        If the function fails, the return value is a system error code, }
    xx := WNetCancelConnection2(Lpzname, FdwConnection, FForce);
    { }
    StrDispose(Lpzname);
    If xx = NO_ERROR Then       // was 0
    Begin
      MsgToList('Disconnected : ' + FGoodList[i]);
      FGoodList.Delete(i)   ;
    End
    Else
    Begin
      MsgToList('Warning: Disconnect Failed: ' );
      msgtolist('   connected list item: ' + FgoodList[i]);
      MsgToList('   Error code:  ' + inttostr(xx) + ' - '+ syserrormessage(xx));
    End;
  End;
  except
     on e:exception do
       begin
        vmsgs := 'EXCEPTION:  Disconnecting from Image Share.';
        MsgToList(vmsgs);
        msgtolist('msg: ' + e.Message);
        MsgToList('Share List entry:  ' + ExtractFilePath(FGoodList[i]));
        {Not Exiting.  Even if exception we want to follow to Clear List next}
       end;

  end;

  If (FGoodList.Count > 0) Then
  Begin
    Result := False;
    vmsgs := 'Warning: '+ inttostr(goodct) + ' Shares. Failure to disconnect from '
                 + '(' + Inttostr(FGoodList.Count) + ')';
    MsgToList(vmsgs);
    For i := 0 To FGoodList.Count - 1 Do
      MsgToList('- ' + FGoodList[i]);
    FGoodList.Clear; (* We do this even for error.  Yes.  *)
  End
  Else
  Begin
    vmsgs := 'Successful Disconnect from ' + inttostr(goodct) + 'Shares.';
    MsgToList(vmsgs);
  End;
End;

Procedure TMag4Security.SetShareList(Value: TStrings);
Begin
  FShareList.Assign(Value);
End;

Procedure TMag4Security.SetAccessPaths(Value: TStrings);
Begin
  FAccessPaths.Assign(Value);
End;

Procedure TMag4Security.SetMsgList(Value: TStrings);
Begin
  FMsgList.Assign(Value);
End;

Procedure TMag4Security.MsgToList(s: String);
Begin
  FMsgList.Add('------   ' + s);
End;

Function TMag4Security.ErrorText(Code: Char; i: Integer): String;
Var
  j: Integer;
Begin
  Result := 'Unknown Error # : ' + Inttostr(i);
  If Code = 'c' Then
  Begin
    For j := 0 To FConnectErrors.Count - 1 Do
      If Copy(FConnectErrors[j], 1, Length(Inttostr(i))) = Inttostr(i) Then
      Begin
        Result := FConnectErrors[j];
        Break;
      End;
  End;
  If Code = 'd' Then
  Begin
    For j := 0 To FDisconnectErrors.Count - 1 Do
      If Copy(FDisconnectErrors[j], 1, Length(Inttostr(i))) = Inttostr(i) Then
      Begin
        Result := FDisconnectErrors[j];
        Break;
      End;
  End;

End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4Security]);
End;

(*procedure TMag4Security.GetBadList(var t: Tstringlist);
begin
  t.assign(FBadlist);
end; *)

(*procedure TMag4Security.GetGoodList(var t: Tstringlist);
begin
  t.assign(FGoodlist);
end; *)

Function TMag4Security.ParseServerShare(Filename: String): String;
Begin
try
result := ''   ;
// IS There a OS Call for This ? ?
// get the \\Server\Share so we can connect to it.
  If Maglength(Filename, '\') > 5 Then
    Result := MagPiece(Filename, '\', 1) + '\'
      + MagPiece(Filename, '\', 2) + '\'
      + MagPiece(Filename, '\', 3) + '\'
      + MagPiece(Filename, '\', 4)
  Else
    Result := ExtractFilePath(Filename);
  // Get out any trailing backslashes ('\')
  While Copy(Result, Length(Result), 1) = '\' Do
    Result := Copy(Result, 1, Length(Result) - 1);
  msgToList('ParseServerShare: Input= '  + filename);
  msgToList('     ExtractFilePath : ' + ExtractFilePath(filename));
  msgToList('     Result \\Server\Share: ' + Result);

  except
 on e:exception do
   begin
     MsgToList('EXCEPTION : Function ParseServerShare.');
     MsgToList('msg: ' + e.Message);
     MsgToList('Result= ' + result);
   end;

end;
End;

Function TMag4Security.SecurityNeeded(Var Xmsg: String; Filename: String): Boolean;
Var
  Msgoff: String;
  VApppath: String;
Begin
try
  VApppath := ExtractFilePath(Application.ExeName);
  Result := True;
  // Quit if Demo Mode, Security is OFF, or Image file is on Local/Mapped drive
  If Not FSecurityOn Then Msgoff := 'Image Security: OFF.  Attempt Canceled';
  If DemoModeOn Then Msgoff := 'Image Security CANCELED : Demo Mode is ON.';
  If (Uppercase(Copy(Filename, 2, 2)) = ':\') Then Msgoff := 'Image Security: NOT USED on Local/Mapped Drives';
  If (Uppercase(Copy(Filename, 1, 1)) = '.') Then Msgoff := 'Image Security: NOT USED on Local/Mapped Drives';
  If (Uppercase(Copy(Filename, 1, Length(VApppath))) = Uppercase(VApppath)) Then Msgoff := 'Image Security: NOT USED on Local/Mapped Drives';
  If (Msgoff <> '') Then
  Begin
    Xmsg := Msgoff;
    MsgToList(Xmsg);
    Result := False;
  End;
except
 on e:exception do
   begin
     Xmsg:= 'EXCEPTION : Function SecurityNeeded.';
     MsgToList(Xmsg);
     MsgToList('Message: ' + e.Message);
     result := false;
   end;

end;
End;

Function TMag4Security.ConfirmUserNamePassword(Var Xmsg, SUserID, SPW: String; TmpUser, TmpPass, Servershare: String): Boolean;
Var
  i: Integer;
//45
//j : integer;
// value : string;
  Found: Boolean;
// aFile : TextFile;
//45
Begin
  Xmsg := 'Confirming UserName and Password...';
  msgtolist(xmsg);
  Result := True;
  Found := False; //45
  Try
    {  Set the UserName Password to use. FUserName and FPassword are set
        from the Application by Setting the Published Properties: Password, Username.

        The caller could send different UserName,Password as Parameters.
        and UserNamePassword could be in NETWORK LOCATION file. we find this by searching the
          shares list.}
    If (TmpUser <> '') Then
      SUserID := TmpUser
    Else
      SUserID := FUsername;
    If (TmpPass <> '') Then
      SPW := TmpPass
    Else
      SPW := FPassword;
    {   Stuart. In the Futuer, each NETWORK LOCATION entry could have it's own
         username and password, and a flag to say use or not use.}
    For i := ShareList.Count - 1 Downto 0 Do
    Begin
      If (Servershare = MagPiece(ShareList[i], '^', 2)) And (MagPiece(ShareList[i], '^', 5) <> '') Then
      Begin
        Found := True; //45
        {p135, send more messages}
        MsgToList('\\Server\Share from List : ' + ShareList[i]);
        SUserID := MagPiece(ShareList[i], '^', 5);
        SPW := MagPiece(ShareList[i], '^', 6);
        If (SPW <> '') Then SPW := Decrypt(SPW);
        Break;
      End
    End;
  msgtolist('Username: ' + SUserID + '  Password ******* '); //+ '  Password ' + SPW);
  Except
    On Exception Do
    Begin
      Xmsg := 'EXCEPTION : Confirming UserName and/or Password.';
      MsgToList(Xmsg);
      msgtolist('Username: ' + SUserID + '  Password ******* '); // + SPW);
      Result := False;
      Exit;
    End;
  End;
        { //p45 this was commented out. looks like test code.
  if not found then
  begin
    assignfile(aFile, 'C:\output.txt');
    rewrite(aFile);
    writeln(afile, 'Looking for: ' + servershare);
    for i := 0 to sharelist.Count - 1 do
    begin
      writeln(afile, magpiece(sharelist[i], '^', 2) + ' - ' + magpiece(sharelist[i], '^', 5));
    end;
    closefile(afile);
  end;
  }
End;

Function TMag4Security.OSConnectToServer(Var Xmsg: String; SPW, SUserID, Servershare, Filename: String): Boolean;
Var
  Size: Integer;
  xx: Word;
  Lpnetresource: TNetResourceA;
  DwFlags: DWORD;
  XPw, XUserID: PChar;
  Ymsg: String;
Begin
  MsgToList('OSConnectToServer Start : ' + DateTimeToStr(Now));
  Result := False;
  Try
    Xmsg := '  Attempt Connection to: ' + Servershare + '...';

    //xPw := strtoPChar(spw);
    XPw := PChar(SPW);
    XUserID := PChar(SUserID);
    Lpnetresource.DwType := RESOURCETYPE_DISK;
    Lpnetresource.LpLocalName := Nil;
    Size := (Length(Servershare));
    Lpnetresource.LpRemoteName := Stralloc(Size + 1);
    Strpcopy(Lpnetresource.LpRemoteName, Servershare);
    Lpnetresource.LpProvider := Nil;
    DwFlags := 0;
  // Call the OS Function to connect to the ServerShare
    {we don't specifically use getlasterror here.  we use the integer return of the call itself.
      (see below.  this is same thing as getLastError.}
    xx := WNetAddConnection2(Lpnetresource, XPw, XUserID, DwFlags);
  // Check for certain result codes:
    If xx = 1219 Then { credentail conflict, try connetion again as self }
    Begin
      MsgToList('GetLastError: ' + inttostr(xx) + ' - '+ syserrormessage(xx));
      MsgToList('Credential conflict, continuing as current User...');
      XUserID := Nil;
      XPw := '';
      xx := WNetAddConnection2(Lpnetresource, XPw, XUserID, DwFlags);
    End;
    StrDispose(Lpnetresource.LpRemoteName);

(* called OpenSecureFile from RAd Window - CPU would  Spike to 100,
   if application.processmessages was here in code. Took out gek 12/16/96
  Application.processmessages; *)

    If Not (xx = 0) Then
    Begin
      MsgToList('OSConnectToServer FAILED.  Time :  ' + DateTimeToStr(Now));
      MsgToList('GetLastError: ' + inttostr(xx) + ' - '+ syserrormessage(xx));
      MsgToList('\\Server\Share: ' + servershare);
      MsgToList(' UserName: "' + SUserID + '"');
      Xmsg := 'FATAL: Failed to connect:  ' + syserrormessage(xx);
      MsgToList(Xmsg);

   {'ERROR: Opening Image Security to the Image Directory. #'+inttostr(xx);}
      FBadList.Add(Servershare);
      Exit;
    End;

    Result := True;
    MsgToList('OSConnectToServer Success: ' + DateTimeToStr(Now));
  Except
    On e: Exception Do
    Begin
        Xmsg := 'EXCEPTION: Connecting to Image Server.';
        MsgToList(Xmsg) ;
        MsgToList('Filename: ' +  Filename);
        MsgToList('\\Server\Share: ' + servershare);
        MsgToList(' UserName: "' + SUserID + '"');
        MsgToList(' OS Exception: ' + e.Message);
              // 03/11/02 IR Elsie : connection not being closed
        MagCloseSecurity(Ymsg, True);
        MsgToList(Ymsg);
    End;
  End;
End;

{----------------------------------------------------------}
{ TODO : This old list of error messages can be deleted after Testing }
Procedure TMag4Security.LoadConnectErrors;
Begin
{ this is a bad way to do things, it needs changed to use some kind of
  MSWindows function   }
  FConnectErrors.Add('999  Access to directory is Denied.');
  FConnectErrors.Add('0    NO_ERROR - success! ');
  FConnectErrors.Add('5    ERROR_ACCESS_DENIED { Access is denied. }');
  FConnectErrors.Add('85   ERROR_ALREADY_ASSIGNED { The local device name is already in use. }');
  FConnectErrors.Add('66   ERROR_BAD_DEV_TYPE { The network resource type is not correct. }');
  FConnectErrors.Add('1200 ERROR_BAD_DEVICE { The specified device name is invalid. }');
  FConnectErrors.Add('67   ERROR_BAD_NET_NAME { The network name cannot be found. }');
  FConnectErrors.Add('1206 ERROR_BAD_PROFILE { The network connection profile is corrupt. }');
  FConnectErrors.Add('1204 ERROR_BAD_PROVIDER { The specified network provider name is invalid. }');
  FConnectErrors.Add('170  ERROR_BUSY { The requested resource is in use. }');
  FConnectErrors.Add('1223 ERROR_CANCELLED');
  FConnectErrors.Add('1205 ERROR_CANNOT_OPEN_PROFILE { Unable to open the network connection profile. }');
  FConnectErrors.Add('1202 ERROR_DEVICE_ALREADY_REMEMBERED { An attempt was made to remember a device that had previously been remembered. }');
  FConnectErrors.Add('1208 ERROR_EXTENDED_ERROR { An extended error has occurred. }');
  FConnectErrors.Add('86   ERROR_INVALID_PASSWORD { The specified network password is not correct. }');
  FConnectErrors.Add('1203 ERROR_NO_NET_OR_BAD_PATH { No network provider accepted the given network path. }');
  FConnectErrors.Add('53 ERROR_NO_NET_OR_BAD_PATH { No network provider accepted the given network path. }');
  FConnectErrors.Add('1222 ERROR_NO_NETWORK { The network is not present or not started. }');
  FConnectErrors.Add('1219 ERROR_SESSION_CREDENTIAL_CONFLICT {The credentials supplied conflict with an existing set of credentials. }');
  FConnectErrors.Add('1326 ERROR_LOGON_FAILURE {The attempted logon in invalid.  This is due to either a bad user name or authentication information.}');
  FConnectErrors.Add('1784 ERROR_INVALID_USER_BUFFER {The supplied user buffer is invalid for the requested operation.}');
  FConnectErrors.Add('1785 ERROR_UNRECOGNIZED_MEDIA {The disk media is not recognized. It may not be formatted.}');
  FConnectErrors.Add('1786 ERROR_NO_TRUST_LSA_SECRET {The workstation does not have a trust secret.}');
  FConnectErrors.Add('1787 ERROR_NO_TRUST_SAM_ACCOUNT {The domain controller does not have an account for this workstation.}');
  FConnectErrors.Add('1788 ERROR_TRUSTED_DOMAIN_FAILURE {The trust relationship between the primary domain and the trusted domain failed.}');
  FConnectErrors.Add('1789 ERROR_TRUSTED_RELATIONSHIP_FAILURE {The trust relationship between this workstation and the primary domain failed.}');
  FConnectErrors.Add('1790 ERROR_TRUST_FAILURE {The network logon failed.}');
  FConnectErrors.Add('1792 ERROR_NETLOGON_NOT_STARTED {An attempt was made to logon, but the network logon service was not started.}');
  FConnectErrors.Add('1793 ERROR_ACCOUNT_EXPIRED {The user''s account has expired.}');
  FConnectErrors.Add('2202 The specified username is invalid.');
End;
   {----------------------------------------------------------}

Procedure TMag4Security.LoadDisConnectErrors;
Begin
  FDisconnectErrors.Add('0 NO_ERROR - success!');
  FDisconnectErrors.Add('1206  ERROR_BAD_PROFILE { The network connection profile is corrupt. }');
  FDisconnectErrors.Add('1205  ERROR_CANNOT_OPEN_PROFILE { Unable to open the network connection profile. }');
  FDisconnectErrors.Add('1204  ERROR_DEVICE_IN_USE { The device is in use by an active process and cannot be disconnected. }');
  FDisconnectErrors.Add('1208  ERROR_EXTENDED_ERROR { An extended error has occurred. }');
  FDisconnectErrors.Add('2250  ERROR_NOT_CONNECTED { This network connection does not exist. }');
  FDisconnectErrors.Add('2401  ERROR_OPEN_FILES { This network connection has files open or requests pending. }');
End;
{----------------------------------------------------------}

Procedure TMag4Security.SetSecurityOn(Const Value: Boolean);
Begin
  FBadList.Clear;
  FSecurityOn := Value;
End;

Function TMag4Security.SetNetUsernamePassword(Userpass: String; Var Xmsg: String): Boolean;
Var
  s: String;
Begin
  Try
    Xmsg := 'UserName^Password: ' + Userpass;
    If Userpass = '' Then
    Begin
      Result := True;
      Self.Username := '';
      Self.Password := '';
      Xmsg := 'UserName and Password are Null.';
      Exit;
    End;
    Self.Username := MagPiece(Userpass, '^', 1);
    s := MagPiece(Userpass, '^', 2);
    If (Self.Username = '') Or (s = '') Then
    Begin
      Xmsg := 'Invalid Imaging Network Username or Password' + #13 + 'Access to the Imaging Network Servers is disabled';
      Result := False;
    End
    Else
    Begin
      Self.Password := Decrypt(s);
      Result := True;
    End;
  Except
    On e: Exception Do
    Begin
      Xmsg := 'Error Setting UserName and Password: ' + e.Message;
      Result := False;
    End;
  End;
End;

(*
WNetAddConnection2 : Google Search :

Return Values
If the function succeeds, the return value is NO_ERROR.
If the function fails, the return value is an error code. Returning an error code provides compatibility with the behavior of the Windows 3.1 function WNetAddConnection. You can also call the GetLastError function to obtain the (same) error code. One of the following error codes may be returned when WNetAddConnection2 fails:
ERROR_ACCESS_DENIED
Access to the network resource was denied.
ERROR_ALREADY_ASSIGNED
The local device specified by lpLocalName is already connected to a network resource.
ERROR_BAD_DEV_TYPE
The type of local device and the type of network resource do not match.
ERROR_BAD_DEVICE
The value specified by lpLocalName is invalid.
ERROR_BAD_NET_NAME
The value specified by lpRemoteName is not acceptable to any network resource provider. The resource name is invalid, or the named resource cannot be located.
ERROR_BAD_PROFILE
The user profile is in an incorrect format.
ERROR_BAD_PROVIDER
The value specified by lpProvider does not match any provider.
ERROR_BUSY
The router or provider is busy, possibly initializing. The caller should retry.
ERROR_CANCELLED
The attempt to make the connection was cancelled by the user through a dialog box from one of the network resource providers, or by a called resource.
ERROR_CANNOT_OPEN_PROFILE
The system is unable to open the user profile to process persistent connections.
ERROR_DEVICE_ALREADY_REMEMBERED
An entry for the device specified in lpLocalName is already in the user profile.
ERROR_EXTENDED_ERROR
A network-specific error occured. Call the WNetGetLastError function to get a description of the error.
ERROR_INVALID_PASSWORD
The specified password is invalid.
ERROR_NO_NET_OR_BAD_PATH
A network component has not started, or the specified name could not be handled.
ERROR_NO_NETWORK
There is no network present.


Read more: http://www.answers.com/topic/wnetaddconnection2#ixzz2E6QTBoS7
*)


(*
DeleteFile
Return Values
If the function succeeds, the return value is ZERO .   (online text was Nonzero  - mistake)
If the function fails, the return value is NONZERO.   (online text was zero  - mistake)
 To get extended error information, call GetLastError.

Read more: http://www.answers.com/topic/deletefile-win-api#ixzz2E6RltCA1
*)

 (*
 WNetCancelConnection2

        From Web Search :
         If the function succeeds, the return value is NO_ERROR.
        If the function fails, the return value is a system error code, }
 *)


End.
