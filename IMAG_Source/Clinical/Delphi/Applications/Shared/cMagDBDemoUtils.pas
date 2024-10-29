Unit cMagDBDemoUtils;
{
 Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==   unit cMagDBDemoUtils;
 Description:   Imaging Demo Utilities.
   Imaging Demo Utilities. Used by TmagDBDemo Class.  To make the
   old demo files work with the new Abstract DB design ( TMagDBBroker is an
    Abstract Class, TMagDBMVista and TMagDBDemo redeclare and implement the
    abstracts class members) some Demo Specific coding is needed. This Util
    unit is specific to and only called from cMagDBDemo.
   (see cMagDBBroker description )
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
  Classes,
  UMagDefinitions
  ;

//Uses Vetted 20090929:umagutils, forms, sysutils

Type
  TMagDemoUtils = Class
  Private
    Procedure ResolveIndexIENs(Var Values: String; Rlist: TStrings);
    Procedure FilterOnProp(Values: String; Var Rlist: TStrings; Itempiece: Integer; Inclusive: Boolean = True);
    Procedure FilterOnDate(FrDt, ToDt: String; Var Flist: TStrings);
  Public
    Procedure FilterTheList(Filter: TImageFilter; Var Flist: TStrings);
  End;
Implementation
Uses
  Forms,
  SysUtils,
  Umagutils8
  ;

Procedure TMagDemoUtils.FilterTheList(Filter: TImageFilter; Var Flist: TStrings);
Var
  Cls, Pkg, Types, Spec, Event: String;
  FrDt: String;
  ToDt: String;
  MthRange: Integer;
  Origin: String;
  Demodir: String;
  Indexlist: TStrings;
  Templist: TStrings;
Begin
  Indexlist := Tstringlist.Create;
  Templist := Tstringlist.Create;
  Try
    Demodir := ExtractFilePath(Application.ExeName) + 'image\';
(*
'2^09/10/2003^CLIN^1^CONSENT^NONE^CLIN^CONSENT^ALLERGY & IMMUNOLOGY^DISCHARGE SUMMARY^|
*)
    Cls := '';
    Pkg := '';
    Types := '';
    Spec := '';
    Event := '';
    FrDt := '';
    ToDt := '';
 // MthRange := 0;
    Origin := '';
    If Filter <> Nil Then
    Begin
      Cls := ClassesToString(Filter.Classes);
      Pkg := PackagesToString(Filter.Packages);
      Types := Filter.Types;
      Spec := Filter.SpecSubSpec;
      Event := Filter.ProcEvent;
      FrDt := Filter.FromDate;
      ToDt := Filter.ToDate;
      MthRange := Filter.MonthRange;
      If MthRange < 0 Then
      Begin
        FrDt := Formatdatetime('mm/dd/yyyy', IncMonth(Date, MthRange));
        ToDt := '';
      End;
      Origin := Filter.Origin;
    End;

//for Filters to work in Demo.
(* we have a complete image list for demo patients. MagDemoImageList (in each patients demo dir)
   and we load it above (Flist)
loop through all properties of filter. if not null
see if appropriate '^' piece of Image entry is contained in property.
i.e. pkg = 'MED,RAD'   substr := $p(6)  if ((substr <> '') and (pos(substr,pkg)> 0))
                                            then okay
                                            else delete this item.

*)
    Indexlist.Clear;
    Indexlist.LoadFromFile(Demodir + 'MagDemoIndexSpec.txt');
    ResolveIndexIENs(Spec, Indexlist);
    Indexlist.Clear;
    Indexlist.LoadFromFile(Demodir + 'MagDemoIndexEvent.txt');
    ResolveIndexIENs(Event, Indexlist);
    Indexlist.Clear;
    Indexlist.LoadFromFile(Demodir + 'MagDemoIndexTypeADMIN.txt');
    Templist.LoadFromFile(Demodir + 'MagDemoIndexTypeCLIN.txt');
    Indexlist.AddStrings(Templist);
    ResolveIndexIENs(Types, Indexlist);
{  cls := '';
  pkg := '';
  types := '';
  spec := '';
  event := '';
  FrDt := '';
  ToDt := '';
  MthRange := 0;
  origin := '';}
    If Cls <> '' Then FilterOnProp(Cls, Flist, 7);
    If Pkg <> '' Then FilterOnProp(Pkg, Flist, 6);
    If Types <> '' Then FilterOnProp(Types, Flist, 8);
    If Spec <> '' Then FilterOnProp(Spec, Flist, 9, False);
    If Event <> '' Then FilterOnProp(Event, Flist, 10, False);
    If Origin <> '' Then FilterOnProp(Origin, Flist, 11);
    If ((FrDt <> '') Or (ToDt <> '')) Then FilterOnDate(FrDt, ToDt, Flist);

  Finally
    Indexlist.Free;
    Templist.Free;
  End;
End;

Procedure TMagDemoUtils.ResolveIndexIENs(Var Values: String; Rlist: TStrings);
Var
  i: Integer;
  Newvalues: String;
  Substr: String;
Begin
  Newvalues := '';
  Values := ',' + Values + ',';
  For i := 0 To Rlist.Count - 1 Do
  Begin
    If (MagPiece(Rlist[i], '|', 2) = '') Then Continue;
    Substr := ',' + MagPiece(Rlist[i], '|', 2) + ',';
    If (Pos(Substr, Values) > 0) Then Newvalues := Newvalues + MagPiece(Rlist[i], '^', 1) + ',';
  End;
  If Newvalues <> '' Then Newvalues := Copy(Newvalues, 1, Length(Newvalues) - 1);
  Values := Newvalues;
End;

Procedure TMagDemoUtils.FilterOnProp(Values: String; Var Rlist: TStrings; Itempiece: Integer; Inclusive: Boolean = True);
Var
  i: Integer;
  Substr: String;
Begin
  Values := ',' + Values + ',';
  For i := Rlist.Count - 1 Downto 1 Do
  Begin
    If ((MagPiece(Rlist[i], '^', Itempiece) = '') And Inclusive) Then Continue;
    Substr := ',' + MagPiece(Rlist[i], '^', Itempiece) + ',';
    If (Pos(Substr, Values) = 0) Then Rlist.Delete(i);
  End;
End;

Procedure TMagDemoUtils.FilterOnDate(FrDt, ToDt: String; Var Flist: TStrings);
Var
  i: Integer;
  cmpDt: String;
Begin
  If FrDt <> '' Then
  Try
    FrDt := Formatdatetime('yyyymmddhhmmnn', Strtodatetime(FrDt));
  Except
    FrDt := '';
  End;
  If ToDt <> '' Then
  Try
    ToDt := Formatdatetime('yyyymmddhhmmnn', Strtodatetime(ToDt + ' 11:59:59'));
  Except
    ToDt := '';
  End;

  For i := Flist.Count - 1 Downto 1 Do
  Begin
{formatdatetime('yyyymmddhhmmnn', strtodatetime(lic)}

{ a := formatdatetime('yyyymmddhhmmnn', strtodatetime(edit1.text));
  b := formatdatetime('yyyymmddhhmmnn', strtodatetime(edit2.text));
  x := CompareText(a,b);
  edit3.text := inttostr(x);}
    Try
      cmpDt := MagPiece(Flist[i], '^', 2);
      cmpDt := Formatdatetime('yyyymmddhhmmnn', Strtodatetime(cmpDt));
    Except
      cmpDt := '';
    End;
    If cmpDt = '' Then Continue;
  // see if Image Date is > FromDate
    If FrDt <> '' Then
      If CompareText(FrDt, cmpDt) > 0 Then
      Begin
        Flist.Delete(i);
        Continue;
      End;
  // see if Image Data < ToDate
    If ToDt <> '' Then
      If CompareText(cmpDt, ToDt) > 0 Then
      Begin
        Flist.Delete(i);
        Continue;
      End;

  End;
End;

End.
