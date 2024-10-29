Unit umagutils8B;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 2.0
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit uMagUtils8B;
   Description: Image utilities
          Utilities that need need to make RPC Calls.
          Some functions and methods are used by many Forms (windows) and components of
          the application.  Utility units are designed to be a repository of such
          utility functions used throughout the application.

          This utility methods for
          -  Display application.
          - Getting things out of main form
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
*)
Interface
Uses
  SysUtils,
  Classes,
  Trpcb,
  cMagDBBroker,
    //Imaging
  UMagClasses,
  UMagDefinitions,
  ImagInterfaces,
  Umagutils8;

Function GetFilterDesc(Filter: TImageFilter; MagDBBroker: TMagDBBroker; ForMsgDlgDisplay: Boolean = False): TStrings;
Function utilIsThisImageLocaltoDB(imageobj: TImageData; MagDBBroker: TMagDBBroker; Var Rmsg: String): Boolean;
Function utilImageDelete(IObj: TImageData; MagDBBroker: TMagDBBroker; Var Xmsg: String): Boolean;
Procedure utilLogActions(Win, act, Ien: String; MagDBBroker: TMagDBBroker);

Implementation
Uses
  FmagDeleteImage
  ,
  Umagkeymgr
  ;

Function utilIsThisImageLocaltoDB(imageobj: TImageData; MagDBBroker: TMagDBBroker; Var Rmsg: String): Boolean;
Begin
  Try
    If Not MagDBBroker.IsConnected Then
      Raise Exception.Create('You need to Login to VistA.');
    If imageObj = Nil Then
      Raise Exception.Create('You need to select an Image.');
    If imageObj.Mag0 = '' Then
      Raise Exception.Create('Image IEN is invalid');
    If ((imageObj.ServerName <> MagDBBroker.GetServer)
      Or (imageObj.ServerPort <> MagDBBroker.GetListenerPort)) Then
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

Function utilImageDelete(IObj: TImageData; MagDBBroker: TMagDBBroker; Var Xmsg: String): Boolean;
Var
  i: Integer;
  Rstat: Boolean;
  Rlist: TStrings;
  Reason: String;
  Sl: String;
  AllowGrpDel: Boolean;
Begin
  Result := False;
  AllowGrpDel := (Userhaskey('MAG DELETE')); //AND UserHasKey('MAG SYSTEM'));
  If Not AllowGrpDel Then AllowGrpDel := (IObj.GroupCount = 1);
  Sl := '';
  Rlist := Tstringlist.Create;
  Try
    If Not FrmDeleteImage.ConfirmDeletion(Xmsg, Rlist, IObj, Reason) Then
    Begin
      Sl := 'Deletion Canceled : ' + #13 + Xmsg + #13 + 'Image ID#: ' + IObj.Mag0;
        //LogMsg('',sl);
      ImsgObj.LogMsg('', Sl);
      Exit;
    End;

    //LogMsg('', 'Deleting Image ID# ' + Iobj.Mag0 + '...');
    ImsgObj.LogMsg('', 'Deleting Image ID# ' + IObj.Mag0 + '...');

    MagDBBroker.RPMaggImageDelete(Rstat, Xmsg, Rlist, IObj.Mag0, '', Reason, AllowGrpDel);
    If Not Rstat Then
    Begin
      For i := 0 To Rlist.Count - 1 Do
        Sl := Sl + MagPiece(Rlist[i], '^', 2) + #13;

        //LogMsg('de', sl);
      ImsgObj.LogMsg('de', Sl);
      For i := 0 To Rlist.Count - 1 Do
          //LogMsg('s', rlist[i]);
        ImsgObj.LogMsg('s', Rlist[i]); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;
    Result := True;
    //LogMsg('d', xmsg);
    ImsgObj.LogMsg('d', Xmsg); {JK 10/6/2009 - Maggmsgu refactoring}
    {TODO: here we can notify anyone who wants to know that an Image has
           been deleted Have to use observer pattern.    }
    For i := 0 To Rlist.Count - 1 Do
      Deletedimages.Add(Rlist[i]);
  Finally
    Rlist.Free;
  End;
End;

Procedure utilLogActions(Win, act, Ien: String; MagDBBroker: TMagDBBroker);
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

{JK 12/30/2008.  Modified DetailedDescGen to add tabbed columns for cleaner display.
 Also added a ForMsgDlgDisplay param option for making any MessageDlg popups display
 a two column list a bit nicer and without displaying non-printing characters as
 a hollow box.}

Function GetFilterDesc(Filter: TImageFilter; MagDBBroker: TMagDBBroker; ForMsgDlgDisplay: Boolean = False): TStrings;
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
        s := Tab + MagDBBroker.RPXWBGetVariableValue('$P($G(^MAG(2005.83,' + Ixien + ',0)),U,1)');
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
        s := Tab + MagDBBroker.RPXWBGetVariableValue('$P($G(^MAG(2005.84,' + Ixien + ',0)),U,1)');
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
        s := Tab + MagDBBroker.RPXWBGetVariableValue('$P($G(^MAG(2005.85,' + Ixien + ',0)),U,1)');
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
    s := MagDBBroker.RPXWBGetVariableValue('$P($G(^VA(200,' + Ixien + ',0)),U,1)') + #13
  Else
    s := 'Any';

  //Result.Add('[Saved By]:' + Tab + s);
  {JK 1/16/2009}
  Result.Add('[Saved By]:' + Tab + StripCrLf(s));

  s := Magbooltostr(Filter.UseCapDt);
  Result.Add('[Search on Capture Date]:' + Tab + s);
  s := Filter.ShortDescHas;
  If s = '' Then
    s := 'Any';

  Result.Add('[Short Description has]:' + Tab + s);
End;

End.
