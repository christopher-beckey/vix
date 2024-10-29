Unit Fmagindexedit;
 {
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   Nov 10, 2008
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==   unit fmagindexedit;
      The Imaging Index Edit form is designed as a dialog window that could be called from
      any form.  The form uses the Image Index Frame.  The initial design of the Frame was
       as a component that could be dropped on any form. But as it developed, and as the
       RPC Broker calls changed from the old RPMag4FieldValueSet( to Sergeys new
       RPMaggImageSetProperties, the design warped to a Frame that is highly coupled with the
      Image Index Edit Form (TForm).
      The purpose is the same, which is to have a call that is
      available by any form, as an easy Dialog Window access to edit Image Index Values.

      It's main funtions are the ability for a user to edit certain fields in the Image File.
      We have hardcoded the fields that are editable.  Changing/Adding a new field isn't simple.
      The old utilities that created a form on the Fly, with information from the Data Dictionary
      would be a good step two to the Image File Field Edit utilities.
      Current fields that are editable in Patch 93 are :
                                Field #
      - Origin                      45
      - Type                        42
      - Spec/SubSpec                44
      - Procedure/Event             43
      - Short Desc                  10
      - Controlled Image            112
      - Status                      113
      - Status Reason               113.3
      - Creation Date               110

      The frame needs a connection to the database so it can list the Spec/SubSpec and Proc/Event
      and change the list based on the value of the other.
      The connection is made by frmMagIndexEdit when it calls FraImageIndex.SetDBBroker(FDBBroker)
      with the current Kernel Broker component that has a connection to the DataBase where the Image is stored.

      Menu options and toolbar buttons enable the user to ____
       Initial values - Get the initial values for the Fields.
       Clear values - clear all values from the edit boxes.
       Include All Fields - Enable all fields to be modified.
       Exclude All Fields - Disable all fields and clear all modified edit boxes.

       Each field is represented by a Check Box, that must be 'checkec' for the field to be editable.
       and either an Edit Box, or a Drop Down Box for the user to enter/select a new value for the field.

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
  Buttons,
  Classes,
  cMagDBBroker,
  Controls,
  ExtCtrls,
  Forms,
  Fraindexfields,
  Menus,
  Stdctrls,
  //maggut9,
  UMagClasses
  ;

//Uses Vetted 20090929:ComCtrls, Graphics, Messages, umagdisplaymgr, maggut9, uMagdefinitions, magpositions, umagutils, Dialogs, SysUtils, Windows

Type

  TfrmIndexEdit = Class(TForm)
    MainMenu1: TMainMenu;
    MnuFile: TMenuItem;
    MnuSave: TMenuItem;
    MnuExit: TMenuItem;
    MnuOptions: TMenuItem;
    MnuInitialize: TMenuItem;
    MnuClear: TMenuItem;
    MnuHelp: TMenuItem;
    MnuIndexEdithelp: TMenuItem;
    GenerateIndexValues1: TMenuItem;
    MnuIncludeAll: TMenuItem;
    MnuExcludeAll: TMenuItem;
    PnlBottom: Tpanel;
    LbCtMsg: Tlabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    N2: TMenuItem;
    LbImageIENDesc: Tlabel;
    LbImageIEN: Tlabel;
    Label1: Tlabel;
    LbPatDesc: Tlabel;
    LbPat: Tlabel;
    Procedure FormCreate(Sender: Tobject);
    Procedure MnuInitializeClick(Sender: Tobject);
    Procedure MnuClearClick(Sender: Tobject);
    Procedure MnuExitClick(Sender: Tobject);
        (*
            procedure SaveIndexValues(sender : Tobject; Ival : TImageIndexValues);
        *)
    Procedure MnuSaveClick(Sender: Tobject);
    Procedure MnuExcludeAllClick(Sender: Tobject);
    Procedure MnuIncludeAllClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure mnuIndexEdithelpClick(Sender: Tobject);
  Private
    Procedure ListToIvalObj(t: TStrings; Var IIndexObj: TImageIndexValues);
        //    procedure ViewAbs(Iobj : TImageData; FDBBroker : TMagDBBroker);

  Public
    FraImageIndex: TframeIndexFields; { Public declarations }
    FIvalObj: TImageIndexValues;
    Function Execute(FDBBroker: TMagDBBroker; IObj: TImageData; Var Resmsg: String): Boolean;
    Function ExecuteOLD(Var IVal: TImageIndexValues; FDBBroker: TMagDBBroker; ctMsg: String; IObj:
      TImageData): Boolean;
    Procedure ConvertCodeToFldNumber(Var t: TStrings); Overload;
    Function ConvertCodeToFldNumber(Val: String): String; Overload;
    Procedure UserPrefsApply(Upref: Tuserpreferences);
  End;

Var
  FrmIndexEdit: TfrmIndexEdit;

Implementation
Uses
  Dialogs,

  Magpositions,
  SysUtils,
  UMagDefinitions,
  //umagdisplaymgr,
  Umagutils8,
  umagutils8A,
  Windows
  ;

{$R *.dfm}

Function TfrmIndexEdit.ExecuteOLD(Var IVal: TImageIndexValues; FDBBroker: TMagDBBroker; ctMsg: String; IObj:
  TImageData): Boolean;
Begin

  Result := False;
  If Not Doesformexist('frmIndexEdit') Then
  Begin
    Application.CreateForm(TfrmIndexEdit, FrmIndexEdit);
        //formtonormalsize(frmIndexEdit);
  End;
  FrmIndexEdit.UserPrefsApply(Upref);
  With FrmIndexEdit Do
  Begin
    LbImageIEN.caption := IObj.ExpandedIDDescription(True); //IndVal.ImageIEN; ival.ImageIEN;
    LbPat.caption := IVal.Patient;
    LbCtMsg.caption := ' ' + ctMsg;
    FraImageIndex.SetDBBroker(FDBBroker);
        //////////ViewAbs(Iobj, FDBBroker) ;
    FraImageIndex.IncludeAllFields(False);
    FraImageIndex.SetInitialValues(IVal);
    Showmodal;
    If ModalResult = MrOK Then
    Begin
      Result := True;
      FraImageIndex.GetIndexValues(IVal);
    End;
  End;
End;

Function TfrmIndexEdit.Execute(FDBBroker: TMagDBBroker; IObj: TImageData; Var Resmsg: String): Boolean;
Var
  ctMsg, chmsg: String;
  Rstat: Boolean;
  Rmsg: String;
  Rlist, t: TStrings;
  IndVal: TImageIndexValues;
  chngct: Integer;
Begin

  Result := False;
  If Not Doesformexist('frmIndexEdit') Then
  Begin
    Application.CreateForm(TfrmIndexEdit, FrmIndexEdit);
        //formtonormalsize(frmIndexEdit);
  End;
  FrmIndexEdit.UserPrefsApply(Upref);
  chngct := 0;
  Rlist := Tstringlist.Create;
  t := Tstringlist.Create;
  IndVal := TImageIndexValues.Create;

  FDBBroker.RPMaggImageGetProperties(Rstat, Rmsg, Rlist, IObj.Mag0, '*');
  Rlist.Delete(0); //  do we need to test for   '0^...' }
  ListToIvalObj(Rlist, IndVal);
  IndVal.ImageDescription := IObj.ExpandedIdDateDescription(False);
  IndVal.ImageIEN := IObj.Mag0;
  IndVal.Patient := IObj.PtName;
  Rstat := False;
  Rmsg := '';
  Rlist.Clear;

    //if magienlist.count > 1 then
    //    ctmsg := inttostr(magienlist.count) + ' Selected Images.'
    //else
    //    ctmsg := ' Selected Image.';
  ctMsg := ' Selected Image.';
    { Both of the next two lines do same thing.  DBBroker is generic.}
    (*  if frmIndexEdit.execute(IIndexObj,dmod.MagDBMVista1,ctmsg) then  *)
  chmsg := #13 + #13;

    //                if frmIndexEdit.Execute(IIndexObj, dmod.MagDBBroker1, ctmsg, Iobj) then

  With FrmIndexEdit Do
  Begin
    LbImageIEN.caption := IObj.ExpandedIDDescription(True); //IndVal.ImageIEN;
    LbPat.caption := IndVal.Patient;
    LbCtMsg.caption := ' ' + ctMsg;
    FraImageIndex.SetDBBroker(FDBBroker);
        //////////ViewAbs(Iobj, FDBBroker) ;
    FraImageIndex.IncludeAllFields(False);
    FraImageIndex.SetInitialValues(IndVal);
    Showmodal;
    If ModalResult = MrOK Then
    Begin

      FraImageIndex.GetIndexValues(IndVal);

            { TODO -ogarrett -cindex edit : add new fields for index edit }
      If (IndVal.TypeIndex.Ext <> '<no change>') And
        (IndVal.TypeIndex.Ext <> '') Then
      Begin
        Inc(chngct);
        t.Add('IXTYPE^^' + IndVal.TypeIndex.Ext);
        chmsg := chmsg + #13 + 'Type:                 ' +
          IndVal.TypeIndex.Ext;
      End;
            {  Only Spec and Proc properties can be deleted.}
      If (IndVal.ProcEventIndex.Ext <> '<no change>') Then
      Begin
        Inc(chngct);
        If IndVal.ProcEventIndex.Ext = '<delete>' Then
        Begin
          IndVal.ProcEventIndex.Ext := '@';
          t.Add('IXPROC^^' + IndVal.ProcEventIndex.Ext);
          chmsg := chmsg + #13 + 'Proc/Event:     Delete.';
        End
        Else
        Begin
          t.Add('IXPROC^^' + IndVal.ProcEventIndex.Ext);
          chmsg := chmsg + #13 + 'Proc/Event:       ' +
            IndVal.ProcEventIndex.Ext;
        End;
      End;
      If (IndVal.SpecSubSpecIndex.Ext <> '<no change>') Then
      Begin
        Inc(chngct);
        If IndVal.SpecSubSpecIndex.Ext = '<delete>' Then
        Begin
          IndVal.SpecSubSpecIndex.Ext := '@';
          t.Add('IXSPEC^^' + IndVal.SpecSubSpecIndex.Ext);
          chmsg := chmsg + #13 + 'Spec/SubSpec:     Delete.';
        End
        Else
        Begin
          t.Add('IXSPEC^^' + IndVal.SpecSubSpecIndex.Ext);
          chmsg := chmsg + #13 + 'Spec/SubSpec:  ' +
            IndVal.SpecSubSpecIndex.Ext;
        End;
      End;

      If (IndVal.OriginIndex.Ext <> '<no change>') And
        (IndVal.OriginIndex.Ext <> '') Then
      Begin
        Inc(chngct);
        t.Add('IXORIGIN^^' + IndVal.OriginIndex.Ext);
        chmsg := chmsg + #13 + 'Origin:                ' +
          IndVal.OriginIndex.Ext;
      End;
      If (IndVal.ShortDesc.Ext <> '<no change>') And
        (IndVal.ShortDesc.Ext <> '') Then
      Begin
        Inc(chngct);
        t.Add('GDESC^^' + IndVal.ShortDesc.Ext);
        chmsg := chmsg + #13 + 'Desc:                 ' +
          IndVal.ShortDesc.Ext;
      End;
      If (IndVal.Controlled.Ext <> '<no change>') And
        (IndVal.Controlled.Ext <> '') Then
                //93 new fields    {Controlled Status StatusReason ImageCreationDate}
      Begin
        Inc(chngct);
        t.Add('SENSIMG^^' + IndVal.Controlled.Ext);
        chmsg := chmsg + #13 + 'Controlled:           ' +
          IndVal.Controlled.Ext;
      End;
      If (IndVal.Status.Ext <> '<no change>') And
        (IndVal.Status.Ext <> '') Then
      Begin
        Inc(chngct);
        t.Add('ISTAT^^' + IndVal.Status.Ext);
        chmsg := chmsg + #13 + 'Status:               ' +
          IndVal.Status.Ext;
      End;
      If (IndVal.StatusReason.Ext <> '<no change>') And
        (IndVal.StatusReason.Ext <> '') Then
      Begin
        Inc(chngct);
        t.Add('ISTATRSN^^' + IndVal.StatusReason.Ext);
        chmsg := chmsg + #13 + 'Status Reason:  ' +
          IndVal.StatusReason.Ext;
      End;
      If (IndVal.ImageCreationDate.Ext <> '<no change>') And
        (IndVal.ImageCreationDate.Ext <> '') Then
      Begin
        Inc(chngct);
        t.Add('CRTNDT^^' + IndVal.ImageCreationDate.Ext);
        chmsg := chmsg + #13 + 'Image Date:      ' +
          IndVal.ImageCreationDate.Ext;
      End;

      If chngct = 0 Then
      Begin
        Messagedlg('No changes were made.', Mtconfirmation,
          [Mbok], 0);
        Exit;
      End;
            //IndVal, has the new index fields selected in the window.
            //    + #13 + 'For Image ID: ' + IndVal.ImageIEN    + #13
      If Messagedlg('The following changes will be made ' + #13 +
        'to the ' + ctMsg + chmsg, Mtconfirmation, MbOKCancel, 0) =
        MrCancel Then
        Exit;

            //out temporarily to get 93 to compile
            //     dmod.MagDBBroker1.RPMag4FieldValueSet(rstat,rmsg,rlist,t);
            //RPMaggImageSetProperties(var rstat: boolean;  var rmsg: string; var rlist: tstrings; fieldlist : Tstrings; ien, params: string);

      FDBBroker.RPMaggImageSetProperties(Rstat, Rmsg, Rlist, t, IObj.Mag0, '');
      Result := Rstat;
      If Rstat Then
      Begin
                //
      End
      Else
      Begin
                { TODO : Need to display all messages, need to modify to get a list of messages. }
             //   MAGGMSGF.MagMsg('D', rmsg);
      End;

    End {if frmIndexEdit.execute }
    Else
    Begin
            //  winmsg(1, 'Index changes were canceled.');
    End;

        ///////////

  End;
End;

{	Load the TImageIndexValues Object with values from the array 't'}

Procedure TfrmIndexEdit.ListToIvalObj(t: TStrings; Var IIndexObj:
  TImageIndexValues);
Var
  i: Integer;
  Fldreal: Real;
  Fld: Integer;
  s: String;
Begin
    { TODO -ogarrett -cindex edit : add new fields for index edit }
  IIndexObj.Clear;
  FrmIndexEdit.ConvertCodeToFldNumber(t);
  For i := 0 To t.Count - 1 Do
  Begin
    s := MagPiece(t[i], '^', 1);
    If s = '' Then
      Continue;
    Fldreal := Strtofloat(s);
    Fld := Trunc(Fldreal * 1000);
    Case Fld Of
      10000: IIndexObj.ShortDesc.SetVal(t[i]);
            // := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      40000: ; //IIndexObj.
      41000: IIndexObj.ClassIndex.SetVal(t[i]);
            //  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      42000: IIndexObj.TypeIndex.SetVal(t[i]);
            //  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      43000: IIndexObj.ProcEventIndex.SetVal(t[i]);
            //  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      44000: IIndexObj.SpecSubSpecIndex.SetVal(t[i]);
            //  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      45000: IIndexObj.OriginIndex.SetVal(t[i]);
            //  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      112000: IIndexObj.Controlled.SetVal(t[i]);
            {Controlled Status StatusReason ImageCreationDate}
      113000: IIndexObj.Status.SetVal(t[i]);
      113300: IIndexObj.StatusReason.SetVal(t[i]);
      110000: IIndexObj.ImageCreationDate.SetVal(t[i]);
    Else
      ; // {do nothing}
    End;
  End;

    (* OLD WAY, BEFORE SERGEY
    IIndexObj.clear;
      for i := 0 to t.count-1 do
     begin
     fld := strtoint(magpiece(t[i],'^',1));
     fld := fld*1000  ;
     case fld of
      10000 :   IIndexObj.ShortDesc.SetVal(t[i]);// := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      40000 :   ; //IIndexObj.
      41000 :   IIndexObj.ClassIndex.SetVal(t[i]);//  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      42000 :   IIndexObj.TypeIndex.SetVal(t[i]);//  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      43000 :   IIndexObj.ProcEventIndex.SetVal(t[i]);//  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      44000 :   IIndexObj.SpecSubSpecIndex.SetVal(t[i]);//  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
      45000 :   IIndexObj.OriginIndex.SetVal(t[i]);//  := magpiece(t[i],'^',2) + '^' + magpiece(t[i],'^',3);
     end;
    end;
     {
      Result.ClassIndex :=
      result.TypeIndex :=
      result.SpecSubSpecIndex :=
      result.ProcEventIndex :=
      result.OriginIndex :=
      result.ShortDesc :=
      *)
End;

Procedure TfrmIndexEdit.FormCreate(Sender: Tobject);
Begin
  Color := FSAppBackGroundColor;
  FraImageIndex := TframeIndexFields.Create(Self);
  FraImageIndex.Color := Self.Color;
  FraImageIndex.Parent := Self; //pnlIndex;
  FraImageIndex.Top := 0;
  FraImageIndex.Left := 0;
  FraImageIndex.Visible := True;
    // FraImageIndex.OnSaveValues := SaveIndexValues; //(sender : Tobject; Ival : TImageIndexValues);
  GetFormPosition(Self As TForm);
End;

Procedure TfrmIndexEdit.MnuInitializeClick(Sender: Tobject);
Begin
  FraImageIndex.InitializeValues;
End;

Procedure TfrmIndexEdit.MnuClearClick(Sender: Tobject);
Begin
  FraImageIndex.Refresh;
End;

Procedure TfrmIndexEdit.MnuExitClick(Sender: Tobject);
Begin
  FraImageIndex.ClearFields;
  Close;
End;

(*
procedure TfrmIndexEdit.SaveIndexValues(sender: Tobject;  Ival: TImageIndexValues);
begin
  showmessage(ival.ClassIndex
              + #13 + ival.ImageIEN
              + #13 + ival.TypeIndex
              + #13 + ival.SpecSubSpecIndex
              + #13 + ival.ProcEventIndex
              + #13 + ival.OriginIndex
              + #13 + ival.ShortDesc);

end;
*)

Procedure TfrmIndexEdit.MnuSaveClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmIndexEdit.MnuExcludeAllClick(Sender: Tobject);
Begin
  FraImageIndex.IncludeAllFields(False);
End;

Procedure TfrmIndexEdit.MnuIncludeAllClick(Sender: Tobject);
Begin
  FraImageIndex.IncludeAllFields(True);
End;

Procedure TfrmIndexEdit.ConvertCodeToFldNumber(Var t: TStrings);
Var
  i: Integer;
  s: String;
Begin
  For i := 0 To t.Count - 1 Do
  Begin
    s := ConvertCodeToFldNumber(MagPiece(t[i], '^', 1)) + '^' + MagPiece(t[i], '^', 3) + '^' +
      MagPiece(t[i], '^', 4) + '^' + MagPiece(t[i], '^', 5);
    t[i] := s;
  End;
End;
{Controlled Status StatusReason ImageCreationDate}

Function TfrmIndexEdit.ConvertCodeToFldNumber(Val: String): String;
Var
  i: Integer;
  s: String;
Begin
  Result := '';
  If Val = 'CRTNDT' Then
    Result := '110'
  Else
    If Val = 'DTSAVED' Then
      Result := '7' //Read only
    Else
      If Val = 'GDESC' Then
        Result := '10'
      Else
        If Val = 'IDFN' Then
          Result := '5' //Read Only

        Else
          If Val = 'ISTAT' Then
            Result := '113'
          Else
            If Val = 'ISTATBY' Then
              Result := '113.2' //Read only
            Else
              If Val = 'ISTATDT' Then
                Result := '113.1' //Read only
              Else
                If Val = 'ISTATRSN' Then
                  Result := '113.3'

                Else
                  If Val = 'IXCLASS' Then
                    Result := '41' //Read only
                  Else
                    If Val = 'IXORIGIN' Then
                      Result := '45'
                    Else
                      If Val = 'IXPKG' Then
                        Result := '40'
                      Else
                        If Val = 'IXPROC' Then
                          Result := '43'
                        Else
                          If Val = 'IXSPEC' Then
                            Result := '44'
                          Else
                            If Val = 'IXTYPE' Then
                              Result := '42'

                            Else
                              If Val = 'LDESCR' Then
                                Result := '11' //Read only
                              Else
                                If Val = 'OBJNAME' Then
                                  Result := '.01' //Read only
                                Else
                                  If Val = 'OBJTYPE' Then
                                    Result := '3' //Read only

                                  Else
                                    If Val = 'PARDF' Then
                                      Result := '16'
                                    Else
                                      If Val = 'PARGRD0' Then
                                        Result := '17'
                                      Else
                                        If Val = 'PARGRD1' Then
                                          Result := '63'
                                        Else
                                          If Val = 'PARIPTR' Then
                                            Result := '18'

                                          Else
                                            If Val = 'PROC' Then
                                              Result := '6'
                                            Else
                                              If Val = 'PROCDT' Then
                                                Result := '15'
                                              Else
                                                If Val = 'SAVEDBY' Then
                                                  Result := '8' //Read Only

                                                Else
                                                  If Val = 'SENSBY' Then
                                                    Result := '112.2' //Read Only
                                                  Else
                                                    If Val = 'SENSDT' Then
                                                      Result := '112.1' //Read Only
                                                    Else
                                                      If Val = 'SENSIMG' Then
                                                        Result := '112'

                                                      Else
                                                        Result := '';

End;

Procedure TfrmIndexEdit.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  FreeAndNil(FraImageIndex);//RLM Fixing MemoryLeak 6/18/2010
End;

Procedure TfrmIndexEdit.btnOKClick(Sender: Tobject);
Var
  Missing: String;
Begin
  Missing := '';
  With FraImageIndex Do
  Begin
    If cmbOrigin.Text = '' Then
      Missing := Missing + ', Origin';
    If cmbType.Text = '' Then
      Missing := Missing + ', Type';
    If cmbSpecSubSpec.Text = '' Then
      Missing := Missing + ', Spec/SubSpec';
    If cmbProcEvent.Text = '' Then
      Missing := Missing + ', Proc/Event';
    If Edtshortdesc.Text = '' Then
      Missing := Missing + ', Short Description';
    If cmbSensitive.Text = '' Then
      Missing := Missing + ', Controlled';
    If cmbStatus.Text = '' Then
      Missing := Missing + ', Status';
    If cmbStatusReason.Text = '' Then
      Missing := Missing + ', Status Reason';
    If EdtImageCreationDate.Text = '' Then
      Missing := Missing + ', Image Creation Date';

    If ((cmbStatus.Text <> '') And (cmbStatus.Text <> '<no change>')) Then
    Begin
      If cmbStatusReason.Text = '<no change>' Then
      Begin
       // Showmessage('You need to select a Status Reason:');
       {/p117 messagedlg instead of maglogger (dont want coupling) and not showmessage}
        Messagedlg('You need to select a Status Reason:', Mtconfirmation,
          [Mbok], 0);
        Exit;
      End;
    End;
  End;

  If Missing <> '' Then
  Begin
    Missing := Copy(Missing, 2, 999);
    // Showmessage('Values cannot be empty:' + Missing)
    {/p117 messagedlg instead of maglogger (dont want coupling) and not showmessage}
        Messagedlg('Values cannot be empty:', Mtconfirmation,
          [Mbok], 0);
  End
  Else
    ModalResult := MrOK;
End;

Procedure TfrmIndexEdit.UserPrefsApply(Upref: Tuserpreferences);
Begin
  Magsetbounds(FrmIndexEdit, Upref.EditPos);
End;

(*
procedure TfrmIndexEdit.ViewAbs(Iobj : TImageData; FDBBroker : TMagDBBroker);
var
  t: tstrings;
  xmsg, msghint, onefile: string;
  CacheFile: string;
  lvtopidx, i, scrollct: integer;
   lit: Tlistitem;
begin
  Mag4VGear1.ClearImage;
  scrollct := 0;
  msghint := '';
  if (Iobj = nil) then exit;
  Mag4VGear1.ImageDescription := Iobj.ExpandedIDDescription(false);
  Mag4VGear1.ImageDescriptionHint(Iobj.ExpandedIdDateDescription());

 t := tstringlist.create;
  try
    FDBBroker.RPMag4GetImageInfo(Iobj, t);
    lvinfo.Items.BeginUpdate;
    // if lvinfo.TopItem = nil then lvtopidx := 0
    //   else lvtopidx := lvinfo.TopItem.Index;
    lvinfo.Clear;
    for i := 0 to t.Count - 1 do
    begin
      lit := lvinfo.Items.Add;
      lit.Caption := magpiece(t[i], ':', 1) + ':';
      lit.SubItems.Add(trim(magpiece(t[i], ':', 2) + ':' + magpiece(t[i], ':', 3)));
    end;
    lvinfo.Items.EndUpdate;
    //while lvinfo.TopItem.Index <> lvtopidx do
    //    begin
    //    if lvinfo.topitem.Index > lvtopidx then break;
    //    lvinfo.Scroll(0,20);
    //    lvinfo.Update;
    //    inc(scrollct);
    //    if scrollct > 500 then break;
    //    end;
  finally
    t.free;
  end;
  onefile := MagImageManager1.getImageGuaranteed(iobj, MagImageTypeAbs, false);
  Mag4VGear1.LoadTheImage(onefile);
  Mag4VGear1.ImageHint(msghint);

end;
*)

Procedure TfrmIndexEdit.mnuIndexEdithelpClick(Sender: Tobject);
//begin

Var
  whatsnew: String;
Begin
  whatsnew := AppPath + '\MagWhats New in Patch 93.pdf';
    {      the file is named : 'MagWhats New in Patch 93.pdf'}
  If FileExists(whatsnew) Then
  Begin
    Magexecutefile(whatsnew, '', '', SW_SHOW);
  End
  Else
    Messagedlg('Help file for Patch 93 is missing.', Mtconfirmation, [Mbok], 0);

End;

End.
