Unit cMagCapClinMgr;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==    unit cMagCapClinMgr;
 will handle the coupling between Clinical Classes :
    (TIU , MED, RAD. Etc ) with the  Main Capture Window.
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
  cMagDBBroker,
  cMagPat,
  UMagClasses,
  UMagDefinitions ,
  Imaginterfaces
  ;


Type
  TMagCapClinMgr = Class(Tobject)
  Private
    FDBBroker: TMagDBBroker;
    FMagpat: TMag4Pat;

    //FImageData: Timagedata;

  Protected
    { Protected declarations }
  Public
    FtestmessagesOn: Boolean;
    Constructor Create;
    Destructor Destroy; Override;
    Procedure SetBroker(Value: TMagDBBroker);
         { old GetNote }
//    function OpenNoteWindow(vMagPat: Tmag4Pat;  var vClinDataobj: TClinicalData; var vUprefCapTIU : TuprefCapTIU; vEFile : boolean = false): boolean;
    Function OpenNoteWindow(VMagPat: TMag4Pat; VClinDataobj: TClinicalData; VUprefCapTIU: TuprefCapTIU; VEFile: Boolean = False): Boolean;
    Procedure SetVLocDefault(VarFCapClinDataObj: TClinicalData;
      VUprefCapTIU: TuprefCapTIU; VMsetWrks: TMagSettingsWrks);
    Procedure SetVLocDefault2(VarFCapClinDataObj: TClinicalData;
      VUprefCapTIU: TuprefCapTIU; VMsetWrks: TMagSettingsWrks);

    Procedure TestMessage(s: String);

    Property MagPat: TMag4Pat Read FMagpat Write FMagpat; {==}

  End;
Var
  MSetWrks1: TMagSettingsWrks;

Implementation
Uses
  FmagCapTIU
  ;

{ TImageProxy }

Constructor TMagCapClinMgr.Create;
Begin
  Inherited;
  //
End;

Destructor TMagCapClinMgr.Destroy;
Begin
  Inherited;
//
End;
     { old GetNote }
(*function TMagCapClinMgr.OpenNoteWindow(vMagPat: Tmag4Pat;
           var vClinDataobj: TClinicalData; var vUprefCapTIU : TuprefCapTIU;
           vEFile : boolean = false): boolean;*)

Function TMagCapClinMgr.OpenNoteWindow(VMagPat: TMag4Pat;   VClinDataobj: TClinicalData;
                                       VUprefCapTIU: TuprefCapTIU;
                                       VEFile: Boolean = False): Boolean;
//var
//  s,r,rmsg: string;
//  i : integer;
Begin
  //if not doesformexist('frmCapTIU') then
  //   application.CreateForm(TfrmCapTIU,frmCapTIU);
  TestMessage(VClinDataobj.GetClinDataStrAll);
  SetVLocDefault(VClinDataobj, VUprefCapTIU, MSetWrks1);

  Result := FrmCapTIU.Execute(VMagPat, VClinDataobj, VUprefCapTIU, VEFile);
  If Result Then
    With VClinDataobj Do
    Begin
      If NewNote Then
      Begin
             {  Do we want to put in some default text here ?
                don't need to, we do it in other places.}
             (*if newtext.Count = 0 then
                begin
                  // for testing     showmessage('No Text in New Note');
                end;  *)
      End;
          //TestMessage(vClinDataObj.GetClinDataStrAll);
    End;
  TestMessage(VClinDataobj.GetClinDataStrAll);
End;

Procedure TMagCapClinMgr.TestMessage(s: String);
Begin
  If FtestmessagesOn Then
    MagAppMsg('', 'test --- ' + s);
End;

Procedure TMagCapClinMgr.SetBroker(Value: TMagDBBroker);
Begin
  FDBBroker := Value;
End;

Procedure TMagCapClinMgr.SetVLocDefault(VarFCapClinDataObj: TClinicalData; VUprefCapTIU: TuprefCapTIU; VMsetWrks: TMagSettingsWrks);
Begin
  If VarFCapClinDataObj.Pkg <> '8925' Then Exit;
        {       If not using defaults, we erase the VLoc}
  If VarFCapClinDataObj.NewLocation <> '' Then Exit;

  If Not VUprefCapTIU.UseDefaultLoc Then
  Begin
    VarFCapClinDataObj.NewLocation := '';
    VarFCapClinDataObj.NewLocationDA := '';
    Exit;
  End;
        {       We're using Defaults.  If null, then there wasn't any Location
                defined in the Configuration.  So 1st try User default then Wrks.}
  If VarFCapClinDataObj.NewLocation = '' Then
  Begin
    If VUprefCapTIU.DefaultLoc <> '' Then
    Begin
      VarFCapClinDataObj.NewLocation := VUprefCapTIU.DefaultLocName;
      VarFCapClinDataObj.NewLocationDA := VUprefCapTIU.DefaultLocDA;
    End
    Else { user's Default Location is '' try wrks default}
      If VMsetWrks.VLoc <> '' Then
      Begin
        VarFCapClinDataObj.NewLocation := VMsetWrks.VLocName;
        VarFCapClinDataObj.NewLocationDA := VMsetWrks.VLocDA;
      End;
  End;
End;

        {After a configuration has been applied. }

Procedure TMagCapClinMgr.SetVLocDefault2(VarFCapClinDataObj: TClinicalData; VUprefCapTIU: TuprefCapTIU; VMsetWrks: TMagSettingsWrks);
Begin
  If VarFCapClinDataObj.Pkg <> '8925' Then Exit;
        {       If not using defaults, we erase the VLoc}
  If Not VarFCapClinDataObj.NewNote Then Exit;
  If Not VUprefCapTIU.UseDefaultLoc Then
  Begin
    VarFCapClinDataObj.NewLocation := '';
    VarFCapClinDataObj.NewLocationDA := '';
    Exit;
  End;
        {       We're using Defaults.  If null, then there wasn't any Location
                defined in the Configuration.  So 1st try User default then Wrks.}
  If VarFCapClinDataObj.NewLocation = '' Then
  Begin
    If VUprefCapTIU.DefaultLoc <> '' Then
    Begin
      VarFCapClinDataObj.NewLocation := VUprefCapTIU.DefaultLocName;
      VarFCapClinDataObj.NewLocationDA := VUprefCapTIU.DefaultLocDA;
    End
    Else { user's Default Location is '' try wrks default}
      If VMsetWrks.VLoc <> '' Then
      Begin
        VarFCapClinDataObj.NewLocation := VMsetWrks.VLocName;
        VarFCapClinDataObj.NewLocationDA := VMsetWrks.VLocDA;
      End;

  End;
End;

End.
