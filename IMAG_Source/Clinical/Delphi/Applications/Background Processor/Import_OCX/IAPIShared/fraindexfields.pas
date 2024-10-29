Unit Fraindexfields;
 {
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   Nov 10, 2008
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==   unit fraIndexfields;
Description: Imaging Index Edit FRAME.
      The Imaging Index Frame is designed as a component that could be dropped on
      any form.  Although that was the design, The Frame is highly coupled with the
      Image Index Edit Form (TForm). See Description in Image Index Edit form.

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
  cMagDBBroker,
  ExtCtrls,
  Forms,
  Stdctrls,
  UMagClasses,
  Controls
  ;

//Uses Vetted 20090929:cMagDBMVista, Buttons, Menus, Dialogs, Controls, Graphics, Messages, umagdefinitions, umagutils, trpcb, SysUtils, Windows

Type

   {TMagViewerClickEvent  is for OnViewerClick}
(*
  TIndexSaveEvent = procedure(sender: TObject; vIval :TImageIndexValues) of object;
*)
  TframeIndexFields = Class(TFrame)
    cmbType: TComboBox;
    cmbSpecSubSpec: TComboBox;
    cmbProcEvent: TComboBox;
    cmbOrigin: TComboBox;
    Edtshortdesc: TEdit;
    LbClass: Tlabel;
    RbClin: TRadioButton;
    RbAdmin: TRadioButton;
    LboldType: Tlabel;
    LboldSpec: Tlabel;
    LboldProc: Tlabel;
    LboldShortDesc: Tlabel;
    LboldOrigin: Tlabel;
    LboldClass: Tlabel;
    cbType: TCheckBox;
    cbSpecSubSpec: TCheckBox;
    cbProcEvent: TCheckBox;
    cbShortDesc: TCheckBox;
    cbOrigin: TCheckBox;
    LbPackage: Tlabel;
    cmbSensitive: TComboBox;
    cmbStatus: TComboBox;
    cmbStatusReason: TComboBox;
    EdtImageCreationDate: TEdit;
    LbOldSensitive: Tlabel;
    LbOldStatus: Tlabel;
    LbOldStatusReason: Tlabel;
    LbOldImageCreationDate: Tlabel;
    cbSensitive: TCheckBox;
    cbStatus: TCheckBox;
    cbStatusReason: TCheckBox;
    cbImageCreationDate: TCheckBox;
    LbImageDescription: Tlabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Procedure RbClinClick(Sender: Tobject);
    Procedure RbAdminClick(Sender: Tobject);
    Procedure cmbSpecSubSpecSelect(Sender: Tobject);
    Procedure cmbProcEventChange(Sender: Tobject);
    Procedure cmbTypeKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure cmbProcEventKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure EdtshortdescKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure cmbOriginKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure cmbSpecSubSpecKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);

(*
    procedure btnOKClick(Sender: TObject);
*)
    Procedure cmbSpecSubSpecChange(Sender: Tobject);
    Procedure cbTypeClick(Sender: Tobject);
    Procedure cbSpecSubSpecClick(Sender: Tobject);
    Procedure cbProcEventClick(Sender: Tobject);
    Procedure cbShortDescClick(Sender: Tobject);
    Procedure cbOriginClick(Sender: Tobject);
    Procedure cbSensitiveClick(Sender: Tobject);
    Procedure cbStatusClick(Sender: Tobject);
    Procedure cbStatusReasonClick(Sender: Tobject);
    Procedure cbImageCreationDateClick(Sender: Tobject);
    Procedure LbOriginClick(Sender: Tobject);
    Procedure LboldOriginClick(Sender: Tobject);
    Procedure LboldTypeClick(Sender: Tobject);
    Procedure LboldSpecClick(Sender: Tobject);
    Procedure LboldProcClick(Sender: Tobject);
    Procedure LboldShortDescClick(Sender: Tobject);
    Procedure LbOldSensitiveClick(Sender: Tobject);
    Procedure LbOldStatusClick(Sender: Tobject);
    Procedure LbOldStatusReasonClick(Sender: Tobject);
    Procedure LbOldImageCreationDateClick(Sender: Tobject);
  Private

(*
    FIndexSaveEvent:  TIndexSaveEvent;
*)

    FClass: String;
    FDBBroker: TMagDBBroker;
    FIval: TImageIndexValues;
    Procedure ShowAdmin;
    Procedure ShowClin;
    Procedure RefreshType;
    Procedure RefreshProc;
    Procedure RefreshSpec;

    Procedure RefreshStatus;
    Procedure RefreshStatusReason;
    Procedure RefreshSensitive;
    Procedure RefreshOrigin;

    Procedure ClearSpec;
    Procedure ClearProc;
    Procedure ClearType;
    Procedure GenerateIndexValues;
    Procedure MarkForNoChange(cbox: TComboBox);

(*
    procedure SaveAndClose;
*)
    { Private declarations }
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure GetIndexValues(Var IVal: TImageIndexValues);
    Procedure SetDBBroker(XDBBroker: TMagDBBroker);
    Procedure SetInitialValues(IVal: TImageIndexValues); { Public declarations }
    Procedure InitializeValues;
    Procedure Refresh;
    Procedure ClearFields;
    Procedure IncludeAllFields(Value: Boolean);

  Published
(*
     property OnSaveValues: TIndexSaveEvent read FIndexSaveEvent write FIndexSaveEvent;
*)
  End;
Const
  FNC: String = '<no change>';

Implementation
Uses
  SysUtils,
  Trpcb,
  UMagDefinitions,
  Umagutils8,
  Windows
  ;

{$R *.dfm}

Constructor TframeIndexFields.Create(AOwner: TComponent);
Begin
  Inherited;
  FClass := 'CLIN,CLIN/ADMIN';
  Name := '';
  FIval := TImageIndexValues.Create;
 //FIval := nil;
End;

Procedure TframeIndexFields.SetInitialValues(IVal: TImageIndexValues);
Begin
  Refresh;
  FIval.Assign(IVal);
  LbImageDescription.caption := IVal.ImageDescription;
  LbImageDescription.Hint := IVal.ImageDescription;
  LboldClass.caption := IVal.ClassIndex.Ext;
  LboldClass.Hint := IVal.ClassIndex.Ext;
  LboldType.caption := IVal.TypeIndex.Ext;
  LboldType.Hint := IVal.TypeIndex.Ext;
  LboldSpec.caption := IVal.SpecSubSpecIndex.Ext;
  LboldSpec.Hint := IVal.SpecSubSpecIndex.Ext;
  LboldProc.caption := IVal.ProcEventIndex.Ext;
  LboldProc.Hint := IVal.ProcEventIndex.Ext;
  LboldOrigin.caption := IVal.OriginIndex.Ext;
  LboldOrigin.Hint := IVal.OriginIndex.Ext;
  LboldShortDesc.caption := IVal.ShortDesc.Ext;
  LboldShortDesc.Hint := IVal.ShortDesc.Ext;

 {Controlled Status StatusReason ImageCreationDate}
  LbOldSensitive.caption := IVal.Controlled.Ext;
  LbOldSensitive.Hint := IVal.Controlled.Ext;
  LbOldStatus.caption := IVal.Status.Ext;
  LbOldStatus.Hint := IVal.Status.Ext;
  LbOldStatusReason.caption := IVal.StatusReason.Ext;
  LbOldStatusReason.Hint := IVal.StatusReason.Ext;
  LbOldImageCreationDate.caption := IVal.ImageCreationDate.Ext;
  LbOldImageCreationDate.Hint := IVal.ImageCreationDate.Ext;

  InitializeValues();
End;

Procedure TframeIndexFields.GetIndexValues(Var IVal: TImageIndexValues);
Begin
  IVal.ClassIndex.Ext := '<class>';
  IVal.TypeIndex.Ext := cmbType.Text;
  IVal.SpecSubSpecIndex.Ext := cmbSpecSubSpec.Text;
  IVal.ProcEventIndex.Ext := cmbProcEvent.Text;
  IVal.OriginIndex.Ext := cmbOrigin.Text;
  IVal.ShortDesc.Ext := Edtshortdesc.Text;

 {Controlled Status StatusReason ImageCreationDate}
  IVal.Controlled.Ext := cmbSensitive.Text;
  IVal.Status.Ext := cmbStatus.Text;
  IVal.StatusReason.Ext := cmbStatusReason.Text;
  IVal.ImageCreationDate.Ext := EdtImageCreationDate.Text;

End;

Procedure TframeIndexFields.InitializeValues;
Var
  Oldproc, Oldtype, OldSpec: String;
Begin
  Refresh;
  Oldproc := '';
  Oldtype := '';
  OldSpec := '';
  {Here we populate the DropDown Lists and editable Fields
                       with values of the TvalObj object.}

(*  Ival.ClassIndex       := lbClass.caption;
  Ival.TypeIndex        := lbType.caption ;
  Ival.SpecSubSpecIndex := lbSpec.Caption ;
  Ival.ProcEventIndex   := lbProc.Caption ;
  Ival.OriginIndex      := lbOrigin.Caption;
  Ival.ShortDesc        := edtshortdesc.Text;
  *)

  If FIval.OriginIndex.Ext = '' Then FIval.OriginIndex.Ext := 'VA';

  If cbOrigin.Checked Then
    cmbOrigin.ItemIndex := cmbOrigin.Items.Indexof(FIval.OriginIndex.Ext)
  Else
    cmbOrigin.ItemIndex := cmbOrigin.Items.Indexof('<no change>');

  If cbType.Checked Then
    cmbType.ItemIndex := cmbType.Items.Indexof(FIval.TypeIndex.Ext)
  Else
    cmbType.ItemIndex := cmbType.Items.Indexof('<no change>');

  If cbSpecSubSpec.Checked Then
    cmbSpecSubSpec.ItemIndex := cmbSpecSubSpec.Items.Indexof(FIval.SpecSubSpecIndex.Ext)
  Else
    cmbSpecSubSpec.ItemIndex := cmbSpecSubSpec.Items.Indexof('<no change>');
//  OldProc := cmbProcEvent.Items[cmbProcEvent.itemindex];

  RefreshProc;
  If cbProcEvent.Checked Then
    cmbProcEvent.ItemIndex := cmbProcEvent.Items.Indexof(FIval.ProcEventIndex.Ext)
  Else
    cmbProcEvent.ItemIndex := cmbProcEvent.Items.Indexof('<no change>');

  RefreshSpec;

  If cbSpecSubSpec.Checked Then
    cmbSpecSubSpec.ItemIndex := cmbSpecSubSpec.Items.Indexof(FIval.SpecSubSpecIndex.Ext)
  Else
    cmbSpecSubSpec.ItemIndex := cmbSpecSubSpec.Items.Indexof('<no change>');

  If cbShortDesc.Checked Then
    Edtshortdesc.Text := FIval.ShortDesc.Ext
  Else
    Edtshortdesc.Text := '<no change>';

  {Controlled Status StatusReason ImageCreationDate}
  If cbSensitive.Checked Then
    cmbSensitive.ItemIndex := cmbSensitive.Items.Indexof(FIval.Controlled.Ext)
  Else
    cmbSensitive.ItemIndex := cmbSensitive.Items.Indexof('<no change>');

  If cbStatus.Checked Then
    cmbStatus.ItemIndex := cmbStatus.Items.Indexof(FIval.Status.Ext)
  Else
    cmbStatus.ItemIndex := cmbStatus.Items.Indexof('<no change>');

  If cbStatusReason.Checked Then
    cmbStatusReason.ItemIndex := cmbStatusReason.Items.Indexof(FIval.StatusReason.Ext)
  Else
    cmbStatusReason.ItemIndex := cmbStatusReason.Items.Indexof('<no change>');

  If cbImageCreationDate.Checked Then
    EdtImageCreationDate.Text := FIval.ImageCreationDate.Ext
  Else
    EdtImageCreationDate.Text := '<no change>';

End;

Procedure TframeIndexFields.Refresh;
Var
  t: TStrings;
Begin

  If cbShortDesc.Checked Then Edtshortdesc.Text := '';
  Edtshortdesc.Update;
  If cbOrigin.Checked Then cmbOrigin.ItemIndex := -1;
  cmbOrigin.Update;

   {Controlled Status StatusReason ImageCreationDate}

  If cbImageCreationDate.Checked Then EdtImageCreationDate.Text := '';
  EdtImageCreationDate.Update;

  If cbSensitive.Checked Then cmbSensitive.ItemIndex := -1;
  cmbSensitive.Update;

  If cbStatus.Checked Then cmbStatus.ItemIndex := -1;
  cmbStatus.Update;

  If cbStatusReason.Checked Then cmbStatusReason.ItemIndex := -1;
  cmbStatusReason.Update;

  If cbType.Checked Then cmbType.Clear;
  cmbType.Update;
  If cbSpecSubSpec.Checked Then cmbSpecSubSpec.Clear;
  cmbSpecSubSpec.Update;
  If cbProcEvent.Checked Then cmbProcEvent.Clear;
  cmbProcEvent.Update;
  t := Tstringlist.Create;
  Try

    If Not FDBBroker.IsConnected Then Exit; //FirstConnect;
    If LbClass.caption = '' Then LbClass.caption := FClass;

    RefreshType;
    RefreshProc;
    RefreshSpec;
  // SyncOthLists(0);
    RefreshStatus;
    RefreshStatusReason;
    RefreshSensitive;
    RefreshOrigin;
  Finally
    t.Free;
  End;
End;

Procedure TframeIndexFields.SetDBBroker(XDBBroker: TMagDBBroker);
Begin
  FDBBroker := XDBBroker;
End;

Procedure TframeIndexFields.ShowAdmin;
Begin
  FClass := 'ADMIN,ADMIN/CLIN';
  ClearType;
  ClearSpec;
  ClearProc;
  RefreshType;
//lbProcEvent.Enabled := false;
//lbSpecSubSpec.Enabled := false;
  cmbProcEvent.Enabled := False;
  cmbSpecSubSpec.Enabled := False;
End;

Procedure TframeIndexFields.ShowClin;
Begin
//lbProcEvent.Enabled := true;
//lbSpecSubSpec.Enabled := true;
  cmbProcEvent.Enabled := True;
  cmbSpecSubSpec.Enabled := True;

  FClass := 'CLIN,CLIN/ADMIN';
  ClearType;
  ClearSpec;
  ClearProc;
  RefreshType;
  RefreshProc;
  RefreshSpec;
End;

Procedure TframeIndexFields.ClearType;
Begin
  cmbType.Clear;
  cmbType.Update;
End;

Procedure TframeIndexFields.ClearSpec;
Begin
  cmbSpecSubSpec.Clear;
  cmbSpecSubSpec.Update;
End;

Procedure TframeIndexFields.ClearProc;
Begin
  cmbProcEvent.Clear;
  cmbProcEvent.Update;
End;

Procedure TframeIndexFields.RefreshType();
Var
  t: TStrings;
  i: Integer;
  Idx: Integer;
Begin
  cmbType.Clear;
  cmbType.Update;
//cmbTypeOth.Clear;
//cmbTypeOth.Update;
  If Uppercase(Copy(FIval.ClassIndex.Ext, 1, 4)) = 'CLIN' Then
    FClass := MagcapclsClin //'CLIN,CLIN/ADMIN'
  Else
    FClass := MagcapclsAdmin; //'ADMIN,ADMIN/CLIN';

// WHEN using below, the ADMIN/CLIN class would only return ADMIN/CLIN types.   we
     //  want all ADMIN in that Case.
//FClass := FIval.ClassIndex.Ext;  //93t12  So List of Types is according to Class of original Type

  t := Tstringlist.Create;
  Try
    FDBBroker.RPIndexGetType(t, FClass);
    If t.Count > 1 Then t.Delete(0);
    For i := 0 To t.Count - 1 Do
      t[i] := MagPiece(t[i], '^', 1);

    cmbType.Items := t;
    cmbType.Items.Add('<no change>');
    {  We can't let users change an Image Type to Advanced Directive.  So we
       take out the choice.  These are Imaging Index Types, so we know exactly }
    Idx := cmbType.Items.Indexof('ADVANCE DIRECTIVE');
    If Idx <> -1 Then cmbType.Items.Delete(Idx);

    t.Clear;
    If Not cbType.Checked Then cmbType.ItemIndex := cmbType.Items.Indexof('<no change>');
  // SyncOthLists(4);
  Finally
    t.Free;
  End;

End;

Procedure TframeIndexFields.RefreshProc;
Var
  t: TStrings;
  i: Integer;
  s, S1: String;
  Oldproc: String;
Begin
  Oldproc := cmbProcEvent.Items[cmbProcEvent.ItemIndex];

  cmbProcEvent.Clear;
  cmbProcEvent.Update;
//lbProcEventfromSpec.Caption := 'spec/subspec = ""';
//lbProcEventfromSpec.Update;
  s := '';
  S1 := '';
  S1 := FIval.SpecSubSpecIndex.Ext;
  t := Tstringlist.Create;
  If (cmbSpecSubSpec.ItemIndex <> -1) And (cbSpecSubSpec.Checked) Then
  Begin
    //s := magpiece(cmbSpecSubSpec.Items[cmbSpecSubSpec.ItemIndex],'|',2);
   // s1 := magpiece(cmbSpecSubSpec.Items[cmbSpecSubSpec.ItemIndex],'^',1);
    S1 := cmbSpecSubSpec.Items[cmbSpecSubSpec.ItemIndex];
    If S1 = '<no change>' Then S1 := FIval.SpecSubSpecIndex.Ext;
    If S1 = '<delete>' Then S1 := '';
  End;
  Try
    FDBBroker.RPIndexGetEvent(t, FClass, S1);
    If t.Count > 1 Then t.Delete(0);
    For i := 0 To t.Count - 1 Do
      t[i] := MagPiece(t[i], '^', 1);
    cmbProcEvent.Items := t;
    cmbProcEvent.Items.Add('<no change>');
    cmbProcEvent.Items.Add('<delete>');
    cmbProcEvent.ItemIndex := cmbProcEvent.Items.Indexof(Oldproc);

   // lbProcEventfromSpec.Caption := 'spec/subspec = '+ s1;
    t.Clear;
    //SyncOthLists(3);
  Finally
    t.Free;
  End;

End;

Procedure TframeIndexFields.RefreshSpec;
Var
  t: TStrings;
  i: Integer;
  s, S1: String;
  OldSpec: String;
Begin
  OldSpec := cmbSpecSubSpec.Items[cmbSpecSubSpec.ItemIndex];
  cmbSpecSubSpec.Clear;
  cmbSpecSubSpec.Update;
  //lbSpecSubSpecfromProc.Caption := 'proc/event = ""';
  //lbSpecSubSpecfromProc.Update;
  s := '';
  S1 := '';
  S1 := FIval.ProcEventIndex.Ext;
  t := Tstringlist.Create;
  If (cmbProcEvent.ItemIndex <> -1) And (cbProcEvent.Checked) Then
  Begin
      //s := magpiece(cmbProcEvent.Items[cmbProcEvent.ItemIndex],'|',2);
      //s1 := magpiece(cmbProcEvent.Items[cmbProcEvent.ItemIndex],'^',1);
    S1 := cmbProcEvent.Items[cmbProcEvent.ItemIndex];
    If S1 = '<no change>' Then S1 := FIval.ProcEventIndex.Ext;
    If S1 = '<delete>' Then S1 := '';
  End;
  Try
    FDBBroker.RPIndexGetSpecSubSpec(t, FClass, S1);
    If t.Count > 1 Then t.Delete(0);
    For i := 0 To t.Count - 1 Do
      t[i] := MagPiece(t[i], '^', 1);
    cmbSpecSubSpec.Items := t;
    cmbSpecSubSpec.Items.Add('<no change>');
    cmbSpecSubSpec.Items.Add('<delete>');
    cmbSpecSubSpec.ItemIndex := cmbSpecSubSpec.Items.Indexof(OldSpec);
      //lbSpecSubSpecFromProc.Caption := 'proc/event = '+s1;
    t.Clear;
      // SyncOthLists(2);
  Finally
    t.Free;
  End;
End;

Procedure TframeIndexFields.cmbSpecSubSpecSelect(Sender: Tobject);
Begin
  RefreshProc;
End;

Procedure TframeIndexFields.cmbProcEventChange(Sender: Tobject);
Begin
  RefreshSpec;
End;

Procedure TframeIndexFields.RbClinClick(Sender: Tobject);
Begin
  ShowClin;
End;

Procedure TframeIndexFields.RbAdminClick(Sender: Tobject);
Begin
  ShowAdmin;
End;

Procedure TframeIndexFields.cmbTypeKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    cmbSpecSubSpec.SetFocus;
  End;
End;

Procedure TframeIndexFields.cmbProcEventKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    Edtshortdesc.SetFocus;
  End;
End;

Procedure TframeIndexFields.EdtshortdescKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    cmbOrigin.SetFocus;
  End;
End;

Procedure TframeIndexFields.cmbOriginKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    cmbType.SetFocus;
  End;
End;

Procedure TframeIndexFields.cmbSpecSubSpecKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    cmbProcEvent.SetFocus;
  End;
End;

Procedure TframeIndexFields.ClearFields;
Begin
  cmbType.ItemIndex := -1; // ClearSelection;
  cmbSpecSubSpec.ItemIndex := -1; //ClearSelection;
  cmbProcEvent.ItemIndex := -1; //ClearSelection;
  cmbOrigin.ItemIndex := -1; //ClearSelection;
  Edtshortdesc.Clear;

 {Controlled Status StatusReason ImageCreationDate}
  cmbSensitive.ItemIndex := -1;
  cmbStatus.ItemIndex := -1;
  cmbStatusReason.ItemIndex := -1;
  EdtImageCreationDate.Clear;

End;

Procedure TframeIndexFields.GenerateIndexValues;
Var
//genvalues : string;
  Rlist: TStrings;
Begin
{TODO:  this needs to be in TmagDBMVista.pas}
{ and .. later, it may need to accept a list of iens}
  Rlist := Tstringlist.Create;
  Try
    With FDBBroker.GetBroker Do
    Begin
      PARAM[0].Value := FIval.ImageIEN;
      PARAM[0].PTYPE := LITERAL;
     // remoteprocedure := 'MAG INDEX GENERATE VALUES';
      LstCALL(Rlist);
      If MagPiece(Rlist[0], '^', 1) = '0' Then Exit;
    End;
  Finally
    Rlist.Free;
  End;
End;

(*procedure TFrameIndexFields.btnOKClick(Sender: TObject);
begin
SaveAndClose;
end;*)

(*procedure TFrameIndexFields.SaveAndClose;
var rIval : TImageIndexValues;
begin
rIval := TImageIndexValues.Create;
  if assigned(OnSaveValues) then
    begin
      GetIndexValues(rIval);

      self.OnSaveValues(self,rIval );
    end;
end; *)

Procedure TframeIndexFields.cmbSpecSubSpecChange(Sender: Tobject);
Begin
  RefreshProc;
End;

Destructor TframeIndexFields.Destroy;
Begin
  FreeAndNil(FIval);//RLM Fixing MemoryLeak 6/18/2010
  Inherited;
End;

Procedure TframeIndexFields.cbTypeClick(Sender: Tobject);
Begin
  cmbType.Enabled := cbType.Checked;
  If cbType.Checked Then
    cmbType.ItemIndex := -1
  Else
    MarkForNoChange(cmbType);
End;

Procedure TframeIndexFields.cbSpecSubSpecClick(Sender: Tobject);
Begin
  cmbSpecSubSpec.Enabled := cbSpecSubSpec.Checked;
  If cbSpecSubSpec.Checked Then
    cmbSpecSubSpec.ItemIndex := -1
  Else
    MarkForNoChange(cmbSpecSubSpec);
End;

Procedure TframeIndexFields.cbProcEventClick(Sender: Tobject);
Begin
  cmbProcEvent.Enabled := cbProcEvent.Checked;
  If cbProcEvent.Checked Then
    cmbProcEvent.ItemIndex := -1
  Else
    MarkForNoChange(cmbProcEvent);
End;

Procedure TframeIndexFields.cbShortDescClick(Sender: Tobject);
Begin
  Edtshortdesc.Enabled := cbShortDesc.Checked;
  If cbShortDesc.Checked Then
    Edtshortdesc.Text := ''
  Else
    Edtshortdesc.Text := '<no change>';
End;
//HERE

Procedure TframeIndexFields.cbOriginClick(Sender: Tobject);
Begin
  cmbOrigin.Enabled := cbOrigin.Checked;
  If cbOrigin.Checked Then
    cmbOrigin.ItemIndex := -1
  Else
    MarkForNoChange(cmbOrigin);
End;

Procedure TframeIndexFields.MarkForNoChange(cbox: TComboBox);
Begin
  If cbox.Items.Indexof('<no change>') = -1 Then cbox.Items.Add('<no change>');
  cbox.ItemIndex := cbox.Items.Indexof('<no change>');
End;

Procedure TframeIndexFields.IncludeAllFields(Value: Boolean);
Begin
  cbType.Checked := Value;
  cbOrigin.Checked := Value;
  cbSpecSubSpec.Checked := Value;
  cbProcEvent.Checked := Value;
  cbShortDesc.Checked := Value;
 {Controlled Status StatusReason ImageCreationDate}
  cbSensitive.Checked := Value;
  cbStatus.Checked := Value;
  cbStatusReason.Checked := Value;
  cbImageCreationDate.Checked := Value;
End;

Procedure TframeIndexFields.cbSensitiveClick(Sender: Tobject);
Begin
  cmbSensitive.Enabled := cbSensitive.Checked;
  If cbSensitive.Checked Then
    cmbSensitive.ItemIndex := -1
  Else
    MarkForNoChange(cmbSensitive);
End;

Procedure TframeIndexFields.cbStatusClick(Sender: Tobject);
Begin
  cmbStatus.Enabled := cbStatus.Checked;
  If cbStatus.Checked Then
    cmbStatus.ItemIndex := -1
  Else
    MarkForNoChange(cmbStatus);
End;

Procedure TframeIndexFields.cbStatusReasonClick(Sender: Tobject);
Begin
  cmbStatusReason.Enabled := cbStatusReason.Checked;
  If cbStatusReason.Checked Then
    cmbStatusReason.ItemIndex := -1
  Else
    MarkForNoChange(cmbStatusReason);
End;

Procedure TframeIndexFields.cbImageCreationDateClick(Sender: Tobject);
Begin
  EdtImageCreationDate.Enabled := cbImageCreationDate.Checked;
  If cbImageCreationDate.Checked Then
    EdtImageCreationDate.Text := ''
  Else
    EdtImageCreationDate.Text := '<no change>';
End;

Procedure TframeIndexFields.RefreshOrigin;
Var
  i: Integer;
  s, ParamStr: String;
Begin
  cmbOrigin.Clear;
  cmbOrigin.Update;
  ParamStr := '$P($G(^DD(2005,45,0)),U,3)';
  s := FDBBroker.RPXWBGetVariableValue(ParamStr);
  If s = '' Then Exit;
  For i := 0 To Maglength(s, ';') Do
  Begin
    If MagPiece(s, ';', i) <> '' Then cmbOrigin.Items.Add(MagPiece(MagPiece(s, ';', i), ':', 2));
  End;
  cmbOrigin.Items.Add('<no change>');
  If Not cbOrigin.Checked Then cmbOrigin.ItemIndex := cmbOrigin.Items.Indexof('<no change>');
      // SyncOthLists(4);
End;

Procedure TframeIndexFields.RefreshSensitive;
Var
  i: Integer;
  s, ParamStr: String;
Begin
  cmbSensitive.Clear;
  cmbSensitive.Update;
  ParamStr := '$P($G(^DD(2005,112,0)),U,3)';
  s := FDBBroker.RPXWBGetVariableValue(ParamStr);
  If s = '' Then Exit;
  For i := 0 To Maglength(s, ';') Do
  Begin
    If MagPiece(s, ';', i) <> '' Then cmbSensitive.Items.Add(MagPiece(MagPiece(s, ';', i), ':', 2));
  End;
  cmbSensitive.Items.Add('<no change>');
  If Not cbSensitive.Checked Then cmbSensitive.ItemIndex := cmbSensitive.Items.Indexof('<no change>');
      // SyncOthLists(4);
End;

Procedure TframeIndexFields.RefreshStatus;
Var
  i: Integer;
  s, ParamStr: String;
Begin
  cmbStatus.Clear;
  cmbStatus.Update;
  ParamStr := '$P($G(^DD(2005,113,0)),U,3)';
  s := FDBBroker.RPXWBGetVariableValue(ParamStr);
  If s = '' Then Exit;
  For i := 0 To Maglength(s, ';') Do
  Begin
    If MagPiece(s, ';', i) <> '' Then cmbStatus.Items.Add(MagPiece(MagPiece(s, ';', i), ':', 2));
  End;
  cmbStatus.Items.Add('<no change>');
  i := cmbStatus.Items.Indexof('Deleted');
  If i <> -1 Then cmbStatus.Items.Delete(i);
  i := cmbStatus.Items.Indexof('In Progress');
  If i <> -1 Then cmbStatus.Items.Delete(i);

  If Not cbStatus.Checked Then cmbStatus.ItemIndex := cmbStatus.Items.Indexof('<no change>');
      // SyncOthLists(4);
End;

Procedure TframeIndexFields.RefreshStatusReason;
Var
  t: TStrings;
  i: Integer;
  Rstat: Boolean;
  Rmsg: String;
Begin
  cmbStatusReason.Clear;
  cmbStatusReason.Update;
//cmbType.Clear;
//cmbType.Update;
  t := Tstringlist.Create;
  Try
    FDBBroker.RPMaggReasonList(Rstat, Rmsg, t, 'S');
   //FDBBroker.RPIndexGetType(t,FClass);
    If t.Count > 1 Then t.Delete(0);
     //for i := 0 to t.count-1 do t[i] := magpiece(t[i],'^',1);
    For i := 0 To t.Count - 1 Do
      t[i] := MagPiece(t[i], '^', 2);

    cmbStatusReason.Items := t;
    cmbStatusReason.Items.Add('<no change>');
    t.Clear;
    If Not cbStatusReason.Checked Then cmbStatusReason.ItemIndex := cmbStatusReason.Items.Indexof('<no change>');
  //maybe ?  SyncOthLists(4);
  Finally
    t.Free;
  End;

End;

Procedure TframeIndexFields.LbOriginClick(Sender: Tobject);
Begin
  cbOrigin.Checked := Not cbOrigin.Checked;
End;

Procedure TframeIndexFields.LboldOriginClick(Sender: Tobject);
Begin
  cbOrigin.Checked := Not cbOrigin.Checked;
End;

Procedure TframeIndexFields.LboldTypeClick(Sender: Tobject);
Begin
  cbType.Checked := Not cbType.Checked;
End;

Procedure TframeIndexFields.LboldSpecClick(Sender: Tobject);
Begin
  cbSpecSubSpec.Checked := Not cbSpecSubSpec.Checked;
End;

Procedure TframeIndexFields.LboldProcClick(Sender: Tobject);
Begin
  cbProcEvent.Checked := Not cbProcEvent.Checked;
End;

Procedure TframeIndexFields.LboldShortDescClick(Sender: Tobject);
Begin
  cbShortDesc.Checked := Not cbShortDesc.Checked;
End;

Procedure TframeIndexFields.LbOldSensitiveClick(Sender: Tobject);
Begin
  cbSensitive.Checked := Not cbSensitive.Checked;
End;

Procedure TframeIndexFields.LbOldStatusClick(Sender: Tobject);
Begin
  cbStatus.Checked := Not cbStatus.Checked;
End;

Procedure TframeIndexFields.LbOldStatusReasonClick(Sender: Tobject);
Begin
  cbStatusReason.Checked := Not cbStatusReason.Checked;
End;

Procedure TframeIndexFields.LbOldImageCreationDateClick(Sender: Tobject);
Begin
  cbImageCreationDate.Checked := Not cbImageCreationDate.Checked;
End;

End.
