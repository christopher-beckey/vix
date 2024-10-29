Unit Umagkeymgr;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   2002
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit uMagKeyMgr;
   In the ReFactoring of the whole application we are moving all procedures and
   functions from the Main form.  Form will just be a visual representation of
   underlying properties of objects.
   For now, we are still dependent on the Main Form (TfrmMain) and coupled to
   it tightly.
   Description:  Handle all Security Key methods and data here.
       If user can view image, disabling buttons and menus when application
       is in certain states.
       Not finished.
       Work in progress.  convert this to an Object, get dependency of Main Window
       out of the methods.
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
  Classes,
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  UMagClasses
  ;

//Uses Vetted 20090929:forms, MagTIUwinu, dmsingle, maggmsgu, dialogs

        {       Checks the Class of the Image (from Iobj.MagClass) against
                the security keys 'MAGDISP CLIN' and 'MAGDISP ADMIN' }
Function CanUserViewImage(IObj: TImageData; Var Xmsg: String): Boolean;
  (*    Move Next procedures to uMagDisplayMgr.pas
         {       Buttons and menu's are disabled until a patient is selected.
                - Refresh Patient Images, Rad Exam listing, Abstract window etc.
                Enabled only when a Patient has been selected. }
procedure EnablePatientButtonsAndMenus(status: boolean);*)
 (*       {       After a User connects to the DataBase the RPC  RPMaggUser2
                is called.  One item of information that is returned, is if
                CP is installed on the VistA Server.
                If Clinical Procedures (CP) is installed on the Server, we
                enable the listing, and Viewing of a patients CP Notes.}
procedure EnableCPFunctions;*)
(*        {       After Security keys have been retrieved from DB, we
                enable certain menu items, buttons.
                i.e. MAG SYSTEM key holders have more menu items available.}
procedure InitializeKeyDependentObjects;*)
(*        {       Enables/Disabels Patient lookup options on the Main Window.
                Disabled when Application is opened from CPRS.  Because of the
                way we communicate with CPRS , (we listen they talk) we have
                to Disable the ability to open a patient.}
procedure EnablePatientLookupLogin(setting: boolean);  *)
        {       key : is the key in question. Result is TRUE if User Has Key}
Function Userhaskey(Key: String): Boolean;
        {       Gets users keys from DB and calls InitializeKeyDependentObjects }
Procedure GetUsersSecurityKeys;
        {       Add or Delete a Security Key from the list of user keys.}
Procedure AddDelKey(Magkey: String; Value: Boolean);
        {       Tree if a user has either Imaging Display Key MAGDISP ADMIN, MAGDISP CLIN.}
Function HasImagingKeys(): Boolean;
        {       Show a message about needing Imaging Security Keys and abort}
Procedure NoKeyAbortMessage;
//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring - removed old method}

Var
  SecurityKeys: Tstringlist;

Implementation
Uses
  Dialogs,
  DmSingle,
  Maggmsgu
  ;

//Uses Vetted 20090929:fMagImageList

{JK 10/5/2009 - Maggmsgu refactoring - removed old method}
//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  dmod.MagLogManager.LogEvent(nil, MsgType, Msg, Priority);
//end;

Function HasImagingKeys(): Boolean;
Begin
  Result := Userhaskey('MAGDISP CLIN') Or Userhaskey('MAGDISP ADMIN');
End;

Procedure NoKeyAbortMessage;
Begin
  Messagedlg('  ***   ***   INSUFFICIENT PRIVILEGES   ***  ***'
    + #13 + '   '
    + #13 + '   You need VistA Imaging Display Keys to view '
    + #13 + '   Patient Images.             '
    + #13 + '   '
    + #13 + '   Contact your Imaging Site Manager to have Keys'
    + #13 + '   assigned to you.                                    '
    + #13 + '                                       '
    + #13 + '   ***   ***   ***   ***   ***   ***   ***   ***   ***   '
    + #13 + '                                       '
    + #13 + '                    APPLICATION WILL ABORT   '
    + #13 + '                                       '
    + #13 + '   ***   ***   ***   ***   ***   ***   ***   ***   ***   '
    , MtWarning, [Mbabort], 0);
End;

Procedure GetUsersSecurityKeys;
Begin
  SecurityKeys.Clear;
  //maggmsgf.MagMsg('s', 'Retrieving user''s security keys: ',frmmain.pmsg);
  //LogMsg('s', 'Retrieving user''s security keys: ');  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  MagLogger.LogMsg('s', 'Retrieving user''s security keys: '); {JK 10/5/2009 - Maggmsgu refactoring}
  Dmod.MagDBBroker1.RPMaggUserKeys(SecurityKeys);
  //InitializeKeyDependentObjects;

  {JK 10/6/2009 - Set the MagLogger privilege level based on the Mag System key}
  If Userhaskey('MAG SYSTEM') Then
    MagLogger.SetPrivLevel(plAdmin)
  Else
    MagLogger.SetPrivLevel(plUser);
End;

Function CanUserViewImage(IObj: TImageData; Var Xmsg: String): Boolean;
Begin
  Result := ((IObj.MagClass = '') Or
    ((Pos('CLIN', IObj.MagClass) > 0) And (SecurityKeys.Indexof('MAGDISP CLIN') > -1)) Or
    ((Pos('ADMIN', IObj.MagClass) > 0) And (SecurityKeys.Indexof('MAGDISP ADMIN') > -1)));
  If Result Then
    Xmsg := 'User has the required Security Key to view image.'
  Else
  Begin
    Xmsg := 'A Security Key is required to view ';
    If IObj.MagClass = 'ADMIN' Then Xmsg := Xmsg + 'Administrative Documents.';
    If IObj.MagClass = 'CLIN' Then Xmsg := Xmsg + 'Clinical Images.';
    Xmsg := Xmsg + #13 + 'Contact your Imaging site manager.';

  End;
//if Iobj

End;

Procedure AddDelKey(Magkey: String; Value: Boolean);
Var
  Haskey: Boolean;
Begin
  Haskey := (SecurityKeys.Indexof(Magkey) > -1);

  If (Value And (Not Haskey)) Then SecurityKeys.Add(Magkey);
  If ((Not Value) And Haskey) Then SecurityKeys.Delete(SecurityKeys.Indexof(Magkey));
End;

Function Userhaskey(Key: String): Boolean;
Begin
  If SecurityKeys = Nil Then
  Begin
    Result := False;
      //maggmsgf.magmsg('de','Security Keys are not initialized in Key Manager.');
    MagLogger.MagMsg('de', 'Security Keys are not initialized in Key Manager.'); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
  Result := (SecurityKeys.Indexof(Key) > -1);
End;

End.
