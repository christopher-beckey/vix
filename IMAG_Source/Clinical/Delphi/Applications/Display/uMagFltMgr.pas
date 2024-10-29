Unit UMagFltMgr;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:      2002
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==   unit uMagFltMgr;
   Description:   Utilities for the User Filters.
      Utility unit for Filters used by the TfrmImageList Form.  These calls fill
      the lists in the TfrmImageList form from the Filters defined in the DataBase.
      -TfrmImageList form displays the list in Dynamic menu and Tabs.

      -  For now this unit is specific to TfrmImageList form.  later it'll be uncoupled
      from the form, made a method of the TmagFilter Class and available to any object.

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
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
//RCA  Maggmsgu,
  imaginterfaces,
  UMagDefinitions
  ;

//Uses Vetted 20090929:maggut1, cmagutils, Dialogs, sysutils, MagFileVersion, umagclasses, forms, fmagListfilter, uMagKeyMgr, umagutils, dmsingle, fmagImageList

{TODO: For now this unit is specific to TfrmImageList form.  later it'll be uncoupled
      from the form, made a method of the TmagFilter Class and available to any object.}
        {       Get just public filters}
Procedure GetPublicFilters;
        {       Get Private Filters for user : DUZ}
Procedure GetPrivateFilters(Duz: String);
        {       Get All Filters, }
Procedure GetAllFilters(Duz: String);
        {       Get the current filter.}
Function GetCurrentFilter(): TImageFilter;

//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}

Implementation
Uses
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  FMagImageList,
  Umagutils8
  ;

        {       These are all specific to the Image List Window. }

Function GetCurrentFilter(): TImageFilter;
Begin
  Result := FrmImageList.MagImageList1.ImageFilter;
  If Result = Nil Then Result := FrmImageList.FCurrentFilter;
End;

{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  dmod.MagLogManager.LogEvent(nil, MsgType, Msg, Priority);
//end;

Procedure GetPublicFilters;
Var
  i: Integer;
  Rstat: Boolean;
  Rmsg: String;
  Rlist: TStrings;
Begin
  ;
  Rlist := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPFilterListGet(Rstat, Rmsg, Rlist);
    If Not Rstat Then
      //LogMsg('', rmsg)//maggmsgf.MagMsg('', rmsg)
      MagAppMsg('', Rmsg) //maggmsgf.MagMsg('', rmsg) {JK 10/6/2009 - Maggmsgu refactoring}
    Else
    Begin
      Upref.ImageListDefautFilter := MagPiece(Rlist[0], '^', 1);
      Rlist.Delete(0);
      FrmImageList.ShowFilters(Rlist);
    End;
  Finally
    Rlist.Free;
  End;
End;

Procedure GetPrivateFilters(Duz: String);
Var
  i: Integer;
  Rstat: Boolean;
  Rmsg: String;
  Rlist: TStrings;
Begin
  ;
  Rlist := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPFilterListGet(Rstat, Rmsg, Rlist, Duz);
    If Not Rstat Then
        //LogMsg('', rmsg)//maggmsgf.MagMsg('', rmsg)
      MagAppMsg('', Rmsg) //maggmsgf.MagMsg('', rmsg) {JK 10/6/2009 - Maggmsgu refactoring}
    Else
    Begin
      Upref.ImageListDefautFilter := MagPiece(Rlist[0], '^', 1);
      Rlist.Delete(0);
      FrmImageList.ShowFilters(Rlist, Duz);
     // set default Filter if there isn't one.
    End;
  Finally
    Rlist.Free;
  End;
End;

Procedure GetAllFilters(Duz: String);
Var
  i: Integer;
  Rstat: Boolean;
  Rmsg: String;
  Rlist: TStrings;
Begin
  ;
  Rlist := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPFilterListGet(Rstat, Rmsg, Rlist, Duz, True);
    If Not Rstat Then
        //LogMsg('', rmsg)//maggmsgf.MagMsg('', rmsg)
      MagAppMsg('', Rmsg) //maggmsgf.MagMsg('', rmsg) {JK 10/6/2009 - Maggmsgu refactoring}
    Else
      {         rlist[0] := 7      <<< the 7 is the IEN of the Filter, it's listed somewhere
                                        in rlist[?]  in this example it's in rlist[10]
                rlist[1] := 1^Rad All^
                rlist[2] := 2^Clin All^
                ...
                rlist[10] := 7^All^1216'
                }
    Begin
      Upref.ImageListDefautFilter := MagPiece(Rlist[0], '^', 1);
      Rlist.Delete(0);
      FrmImageList.ShowAllFilters(Rlist, Duz);
    End;
  Finally
    Rlist.Free;
  End;
End;

End.
