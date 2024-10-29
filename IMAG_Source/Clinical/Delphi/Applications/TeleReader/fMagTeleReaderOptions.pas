Unit fMagTeleReaderOptions;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: December 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Robert Graves, Julian Werfel
  Description: This is the options form that shows the specialties
    available to the user.
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
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  Classes,
  cMagUserSpecialty,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Stdctrls,
  Windows,
  ImgList
  ;

//Uses Vetted 20090930:ImgList, maggut1, cMagEventScrollBox, Dialogs, Variants, Messages, SysUtils

Type
  TfrmMagTeleReaderOptions = Class(TForm)
    treSpecialties: TTreeView;
    PnlTop: Tpanel;
    pnlTopSite: Tpanel;
    pnlTopSpecialty: Tpanel;
    pnlTopProcedure: Tpanel;
    PnlBottom: Tpanel;
    ImageList1: TImageList;
    pnlButtons: Tpanel;
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    lblNoSpecialties: Tlabel;
    btnOK: TBitBtn;
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure treSpecialtiesClick(Sender: Tobject);
    Procedure treSpecialtiesCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Var DefaultDraw: Boolean);
    Procedure treSpecialtiesKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure treSpecialtiesCollapsing(Sender: Tobject; Node: TTreeNode;
      Var AllowCollapse: Boolean);
    Procedure treSpecialtiesExpanding(Sender: Tobject; Node: TTreeNode;
      Var AllowExpansion: Boolean);
    Procedure btnOKClick(Sender: Tobject);
  Private
    { Private declarations }

    FSaveSettings: Boolean;

    Procedure ToggleCheckBox(Node: TTreeNode);
    Procedure SetChildCheckBoxes(Node: TTreeNode; Newstate: Integer);
    Procedure SetParentCheckBoxes(Node: TTreeNode; Newstate: Integer);
    Function checkSiblingsSameState(Node: TTreeNode; curState: Integer): Boolean;
    Procedure AddSpecialty(Specialty: TMagUserSpecialty);
    Procedure ChangeCheckBox(Node: TTreeNode; newCheckState: Integer);

    Function addSiteNode(Specialty: TMagUserSpecialty): TTreeNode;
    Function addSpecialtyNode(SiteNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;
    Function addProcedureNode(SpecialtyNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;

    Function getSiteNode(Specialty: TMagUserSpecialty): TTreeNode;
    Function getSpecialtyNode(SiteNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;
    Function getProcedureNode(SpecialtyNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;

    Function getLowestLevelNode(Specialty: TMagUserSpecialty): TTreeNode;

    Procedure getSelectedForSite(SiteNode: TTreeNode; ResultList: Pointer);
    Function getSelectedProceduresForSpecialty(SpecialtyNode: TTreeNode): String;

  Public
    Procedure SetSpecialtyList(specialties: TStrings);
    Function getSelectedSpecialties(): Tlist;
    Procedure ClearLastUpdated();
    Procedure ClearSpecialties();

    Property SaveSettings: Boolean Read FSaveSettings Write FSaveSettings;
  End;
        {
type
  TMagNodeData = class
  private

  public
     NodeType : short;
     NodeData : Pointer;
  end;
         }

Function StateChecked(State: short): Boolean;

Const
//ImageList.StateIndex=0 has some bugs, so we add one dummy image to position 0
  cStateUnChecked = 1;
  cStateChecked = 2;
  cStateHalfChecked = 3;

  cNodeTypeSite = 0;
  cNodeTypeSpecialty = 1;
  cNodeTypeProcedure = 2;

Var
  frmMagTeleReaderOptions: TfrmMagTeleReaderOptions;

Implementation
Uses
  SysUtils
  ;

{$R *.dfm}

Function StateChecked(State: short): Boolean;
Begin
  Result := False;
  If State = cStateChecked Then Result := True;
End;

Procedure TfrmMagTeleReaderOptions.SetSpecialtyList(Specialties: TStrings);
Var
  Pos, i: Integer;
  Specialty: TMagUserSpecialty;
Begin
//  TreeView1.Items.Clear();
  For i := 1 To Specialties.Count - 1 Do
  Begin
    Specialty := TMagUserSpecialty.Create(Specialties[i]);
    AddSpecialty(Specialty);
  End;
  treSpecialties.FullExpand();
  // JMW 6/14/2006 p46t17 set the selected node to the first (so the scroll bar
  // is at the top
  treSpecialties.Selected := treSpecialties.Items.GetFirstNode;
  FSaveSettings := False;

  If treSpecialties.Items.Count = 0 Then
  Begin
    treSpecialties.Visible := False;
    lblNoSpecialties.Visible := True;
    PnlTop.Visible := False;
    btnSave.Visible := False;
    btnClose.Visible := False;
    btnOK.Visible := True;
    Self.caption := 'Attention';
  End
  Else
  Begin
    treSpecialties.Visible := True;
    lblNoSpecialties.Visible := False;
    PnlTop.Visible := True;
    btnSave.Visible := True;
    btnClose.Visible := True;
    btnOK.Visible := False;
    Self.caption := 'Specialties';
  End;
End;

Procedure TfrmMagTeleReaderOptions.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  ClearLastUpdated();
End;

{------------------------------------------------------------------------------}

Procedure TfrmMagTeleReaderOptions.ClearLastUpdated();
Var
  i: Integer;
  Specialty: TMagUserSpecialty;
Begin
  For i := 0 To treSpecialties.Items.Count - 1 Do
  Begin
    Specialty := TMagUserSpecialty(treSpecialties.Items[i].Data);
    Specialty.LastUpdate := '';
    Specialty.ProcedureStrings := '';
  End;
End;

Procedure TfrmMagTeleReaderOptions.ChangeCheckBox(Node: TTreeNode; newCheckState: Integer);
Begin
  If Assigned(Node) Then
  Begin
    Node.StateIndex := newCheckState;
    If Node.StateIndex = cStateUnChecked Then
    Begin
      SetChildCheckBoxes(Node, Node.StateIndex);
      If checkSiblingsSameState(Node, cStateUnChecked) Then
        SetParentCheckBoxes(Node, Node.StateIndex)
      Else
        SetParentCheckBoxes(Node, cStateHalfChecked);
    End
    Else
    Begin
      SetChildCheckBoxes(Node, Node.StateIndex);
      If checkSiblingsSameState(Node, Node.StateIndex) Then
      Begin
        SetParentCheckBoxes(Node, Node.StateIndex);
      End
      Else
      Begin
        SetParentCheckBoxes(Node, cStateHalfChecked);
      End;
    End;
  End;
End;

Procedure TfrmMagTeleReaderOptions.ToggleCheckBox(Node: TTreeNode);
Begin
  If Assigned(Node) Then
  Begin
    If Node.StateIndex = cStateChecked Then
    Begin
      ChangeCheckBox(Node, cStateUnchecked);
    End
    Else
    Begin
      ChangecheckBox(Node, cStateChecked);
    End;
  End;
End;

Procedure TfrmMagTeleReaderOptions.AddSpecialty(Specialty: TMagUserSpecialty);
Var
  ParentNode, Node, newNode: TTreeNode;
Begin

  Node := getLowestLevelNode(Specialty);
  If Node = Nil Then
  Begin
    newNode := addSiteNode(Specialty);
    newNode := addSpecialtyNode(newNode, Specialty);
    addProcedureNode(newNode, Specialty);
  End
  Else
  Begin
    If Node.Level = cNodeTypeSite Then
    Begin
      newNode := addSpecialtyNode(Node, Specialty);
      addProcedureNode(newNode, Specialty);
    End
    Else
      If Node.Level = cNodeTypeSpecialty Then
      Begin
        addProcedureNode(Node, Specialty);
      End
      Else
        If Node.Level = cNodeTypeProcedure Then
        Begin
          If (Not Specialty.Active) Then
          Begin
            ParentNode := Node.Parent;
            treSpecialties.Items.Delete(Node);
            If ParentNode.Count = 0 Then
            Begin
              Node := ParentNode;
              ParentNode := Node.Parent;
              treSpecialties.Items.Delete(Node);
            End;
            If ParentNode.Count = 0 Then
            Begin
              Node := ParentNode;
              treSpecialties.Items.Delete(Node);
            End;
            Exit;
          End;
//      Node.Data := Specialty;
      // already exists, do nothing
        End;
  End;
End;

Function TfrmMagTeleReaderOptions.addSiteNode(Specialty: TMagUserSpecialty): TTreeNode;
Var
  Node: TTreeNode;
Begin
  Result := Nil;
  If (Not Specialty.Active) Then Exit;
  Node := treSpecialties.Items.AddChildFirst(Nil, Specialty.SiteName);

  Node.Data := Specialty; // curNodeData;
  Node.StateIndex := cStateUnChecked;
  Result := Node;
End;

Function TfrmMagTeleReaderOptions.addSpecialtyNode(SiteNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;
Var
  Node: TTreeNode;
Begin
  Result := Nil;
  If SiteNode = Nil Then Exit;
  If (Not Specialty.Active) Then Exit;
  Node := treSpecialties.Items.AddChild(SiteNode, Specialty.SpecialtyName);
  Node.Data := Specialty; // curNodeData;
  Node.StateIndex := cStateUnChecked;
  Result := Node;
End;

Function TfrmMagTeleReaderOptions.addProcedureNode(SpecialtyNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;
Var
  Node: TTreeNode;
Begin
  Result := Nil;
  If SpecialtyNode = Nil Then Exit;
  If (Not Specialty.Active) Then Exit;
  Node := treSpecialties.Items.AddChild(SpecialtyNode, Specialty.ProcedureName);
  Node.Data := Specialty; //curNodeData;
  If Specialty.UserWants Then
  Begin
    Node.StateIndex := cStateChecked;
  End
  Else
  Begin
    Node.StateIndex := cStateUnChecked;
  End;
  ChangeCheckBox(Node, Node.StateIndex);
  Result := Node;
End;

Function TfrmMagTeleReaderOptions.getSiteNode(Specialty: TMagUserSpecialty): TTreeNode;
Var
  Node, sNode: TTreeNode;
  curSpecialty: TMagUserSpecialty;
Begin
  Result := Nil;
  Node := treSpecialties.Items.GetFirstNode();
  If Node = Nil Then Exit;

//  nNodeData := Node.Data;
  curSpecialty := Node.Data; // nNodeData.NodeData;

  If curSpecialty.SiteStationNumber = Specialty.SiteStationNumber Then  {/ P127T1 NST 04/06/2012 Refactor variable name to reflect the meaning /}
  Begin
    Result := Node;
    Exit;
  End;

  sNode := Node.getNextSibling();
  While sNode <> Nil Do
  Begin
//    nNodeData := sNode.Data;
    curSpecialty := sNode.Data; // nNodeData.NodeData;
    If curSpecialty.SiteStationNumber = Specialty.SiteStationNumber Then   {/ P127T1 NST 04/06/2012 Refactor variable name to reflect the meaning /}
    Begin
      Result := sNode;
      Exit;
    End;
    sNode := sNode.getNextSibling();
  End;
  sNode := Node.getPrevSibling();
  While sNode <> Nil Do
  Begin
//    nNodeData := sNode.Data;
    curSpecialty := sNode.Data; // nNodeData.NodeData;
    If curSpecialty.SiteStationNumber = Specialty.SiteStationNumber Then   {/ P127T1 NST 04/06/2012 Refactor variable name to reflect the meaning /}
    Begin
      Result := sNode;
      Exit;
    End;
    sNode := sNode.getPrevSibling();
  End;
  // if we get here, the site node doesn't exist;

End;

Function TfrmMagTeleReaderOptions.getSpecialtyNode(SiteNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;
Var
  curSpecialty: TMagUserSpecialty;
  i: Integer;
Begin
  Result := Nil;
  If SiteNode = Nil Then Exit;
  For i := 0 To SiteNode.Count - 1 Do
  Begin
//    curNodeData := SiteNode.item[i].Data;
    curSpecialty := SiteNode.Item[i].Data; //curNodeData.NodeData;
    If curSpecialty.SpecialtyCode = Specialty.SpecialtyCode Then
    Begin
      Result := SiteNode.Item[i];
      Exit;
    End;
  End;
End;

Function TfrmMagTeleReaderOptions.getProcedureNode(SpecialtyNode: TTreeNode; Specialty: TMagUserSpecialty): TTreeNode;
Var
  curSpecialty: TMagUserSpecialty;
  i: Integer;
Begin
  Result := Nil;
  If SpecialtyNode = Nil Then Exit;
  For i := 0 To SpecialtyNode.Count - 1 Do
  Begin
//    curNodeData := SpecialtyNode.item[i].Data;
    curSpecialty := SpecialtyNode.Item[i].Data; // curNodeData.NodeData;
    If curSpecialty.ProcedureCode = Specialty.ProcedureCode Then
    Begin
      Result := SpecialtyNode.Item[i];
      Exit;
    End;
  End;
End;

Function TfrmMagTeleReaderOptions.getLowestLevelNode(Specialty: TMagUserSpecialty): TTreeNode;
Var
  Node: TTreeNode;
Begin
  Result := Nil;
  Node := getSiteNode(Specialty);
  If Node = Nil Then Exit;
  Result := Node;
  Node := getSpecialtyNode(Result, Specialty);
  If Node = Nil Then Exit;
  Result := Node;
  Node := getProcedureNode(Result, Specialty);
  If Node = Nil Then Exit;
  Result := Node;
End;

Procedure TfrmMagTeleReaderOptions.SetParentCheckBoxes(Node: TTreeNode; Newstate: Integer);
Begin
  If Assigned(Node) Then
  Begin
    If Node.Parent = Nil Then Exit;

    Node.Parent.StateIndex := Newstate;

    If (checkSiblingsSameState(Node.Parent, Newstate)) Then
    Begin
      SetParentCheckBoxes(Node.Parent, Newstate);
    End
    Else
      If (Newstate = cStateChecked) Or (Newstate = cStateHalfChecked) Then
      Begin
        SetParentCheckBoxes(Node.Parent, cStateHalfChecked);
      End;

       {
    if (checkSiblingsSameState(node.parent, newState)) or (newState = cStateUnChecked) then
      SetParentCheckBoxes(Node.Parent, newState);
        }
  End;
End;

Procedure TfrmMagTeleReaderOptions.SetChildCheckBoxes(Node: TTreeNode; Newstate: Integer);
Var
  i: Integer;
Begin
  If Assigned(Node) Then
  Begin
    If Not Node.HasChildren Then Exit;
    For i := 0 To Node.Count - 1 Do
    Begin

      Node.Item[i].StateIndex := Newstate;
      SetChildCheckBoxes(Node.Item[i], Newstate);

    End;
  End;
End;

Function TfrmMagTeleReaderOptions.checkSiblingsSameState(Node: TTreeNode; curState: Integer): Boolean;
Var
  sNode: TTreeNode;
Begin
  Result := False;
  If Assigned(Node) Then
  Begin

    sNode := Node.getNextSibling();
    While sNode <> Nil Do
    Begin
      If sNode.StateIndex <> curState Then Exit;
      sNode := sNode.getNextSibling();
    End;
    sNode := Node.getPrevSibling();
    While sNode <> Nil Do
    Begin
      If sNode.StateIndex <> curState Then Exit;
      sNode := sNode.getPrevSibling();
    End;
  End;
  Result := True;
End;

Procedure TfrmMagTeleReaderOptions.treSpecialtiesClick(Sender: Tobject);
Var
  p: TPoint;
Begin
  GetCursorPos(p);
  p := treSpecialties.ScreenToClient(p);

  If (htOnStateIcon In treSpecialties.GetHitTestInfoAt(p.x, p.y)) Then
    ToggleCheckBox(treSpecialties.Selected);
End;

Procedure TfrmMagTeleReaderOptions.getSelectedForSite(SiteNode: TTreeNode; ResultList: Pointer);
Var
//  ResultList : TList;
  Reslist: Tlist;
  i: Integer;
  curSpecialty: TMagUserSpecialty;
  ProcedureList: String;
Begin
//  ResultList := TList.Create();
//  result := ResultList;
  Reslist := ResultList;

  If SiteNode = Nil Then Exit;
  // iterate through each specialty for the site
  For i := 0 To SiteNode.Count - 1 Do
  Begin
//    nNodeData := SiteNode.item[i].Data;
    If (SiteNode.Item[i].StateIndex In [cStateChecked, cStateHalfChecked]) Then
    Begin
      curSpecialty := SiteNode.Item[i].Data;
      ProcedureList := getSelectedProceduresForSpecialty(SiteNode.Item[i]);
      {
      Specialty := TMagSelectedSpecialty.Create();
      Specialty.SpecialtyName := curSpecialty.SpecialtyName;
      Specialty.SpecialtyCode := inttostr(curSpecialty.SpecialtyCode);
      Specialty.ProcedureCodes := ProcedureList;
      Specialty.SiteCode := curSpecialty.SiteCode;
      Specialty.SiteName := curSpecialty.SiteName;
       }
      curSpecialty.ProcedureStrings := ProcedureList;
      Reslist.Add(curSpecialty);

    End;
  End;
//  result := ResultList;
End;

Function TfrmMagTeleReaderOptions.getSelectedProceduresForSpecialty(SpecialtyNode: TTreeNode): String;
Var
  i: Integer;
  curSpecialty: TMagUserSpecialty;
  ProcedureList: String;
Begin
  ProcedureList := '';
  Result := '';
  If SpecialtyNode = Nil Then Exit;
  For i := 0 To SpecialtyNode.Count - 1 Do
  Begin
//    nNodeData := SpecialtyNode.item[i].Data;
    If SpecialtyNode.Item[i].StateIndex = cStateChecked Then
    Begin
      curSpecialty := SpecialtyNode.Item[i].Data; // nNodeData.NodeData;
      If ProcedureList = '' Then
        ProcedureList := Inttostr(curSpecialty.ProcedureCode)
      Else
        ProcedureList := ProcedureList + ',' + Inttostr(curSpecialty.ProcedureCode);
    End;
  End;
  Result := ProcedureList;

End;

Function TfrmMagTeleReaderOptions.getSelectedSpecialties(): Tlist;
Var
  Node, sNode: TTreeNode;
  ResultList: Tlist;
Begin
  ResultList := Tlist.Create();
  Result := ResultList;

  Node := treSpecialties.Items.GetFirstNode();
  If Node = Nil Then Exit;
//  nNodeData := Node.Data;
  If (Node.StateIndex In [cStateChecked, cStateHalfChecked]) Then
  Begin
    getSelectedForSite(Node, ResultList);
  End;

  sNode := Node.getNextSibling();
  While sNode <> Nil Do
  Begin
//    nNodeData := sNode.Data;
    If (sNode.StateIndex In [cStateChecked, cStateHalfChecked]) Then
    Begin
      getSelectedForSite(sNode, ResultList);
    End;
    sNode := sNode.getNextSibling();
  End;
  sNode := Node.getPrevSibling();
  While sNode <> Nil Do
  Begin
//    nNodeData := sNode.Data;
    If (sNode.StateIndex In [cStateChecked, cStateHalfChecked]) Then
    Begin
      getSelectedForSite(sNode, ResultList);
    End;
    sNode := sNode.getPrevSibling();
  End;

End;

Procedure TfrmMagTeleReaderOptions.FormCreate(Sender: Tobject);
Begin
  treSpecialties.StateImages := ImageList1;
  treSpecialties.ShowRoot := False;
  //TreeView1.Indent := 111;
  treSpecialties.Indent := 165;
//  self.Caption :=  inttostr(self.ClientWidth);
//  TreeView1.Indent := trunc(TreeView1.ClientWidth / 3);
  treSpecialties.ShowLines := False;
  treSpecialties.RowSelect := False;
  treSpecialties.FullExpand();
  FSaveSettings := False;

  lblNoSpecialties.Align := alClient;
  lblNoSpecialties.caption := 'You must be authorized and properly ' +
    'configured to use the VistA Imaging TeleReader Application.' + #13 +
    'If you believe you should have access to ' +
    'the TeleReader Application, please contact your local IRM staff.';
    {
  lblNoSpecialties.Caption := 'You do not have any specialties assigned for ' +
    'reading. You must be authorized and properly configured to use the VistA ' +
    'Imaging TeleReader' + #13 + 'If you believe you should have access to ' +
    'the TeleReader Application, please contact your local IRM staff.';
    }
End;

Procedure TfrmMagTeleReaderOptions.treSpecialtiesCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Var DefaultDraw: Boolean);
Begin
  If Assigned(Node) Then
  Begin

    If (Node.StateIndex = cStateChecked) {or (Node.StateIndex = cStateHalfChecked)} Then
    Begin
      Sender.Canvas.Font.Style := [Fsbold];
    End
    Else
    Begin
      Sender.Canvas.Font.Style := [];
    End;
  End;
End;

Procedure TfrmMagTeleReaderOptions.treSpecialtiesKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If (Key = VK_SPACE) And
    Assigned(treSpecialties.Selected) Then
    ToggleCheckBox(treSpecialties.Selected);
End;

Procedure TfrmMagTeleReaderOptions.btnSaveClick(Sender: Tobject);
Begin
  FSaveSettings := True;
  ModalResult := MrOK;
End;

Procedure TfrmMagTeleReaderOptions.btnCloseClick(Sender: Tobject);
Begin
  FSaveSettings := False;
  ModalResult := MrOK;
End;

Procedure TfrmMagTeleReaderOptions.treSpecialtiesCollapsing(
  Sender: Tobject; Node: TTreeNode; Var AllowCollapse: Boolean);
Var
  p: TPoint;
Begin
  GetCursorPos(p);
  p := treSpecialties.ScreenToClient(p);

  If (htOnStateIcon In treSpecialties.GetHitTestInfoAt(p.x, p.y)) Then
    AllowCollapse := False;
End;

Procedure TfrmMagTeleReaderOptions.treSpecialtiesExpanding(Sender: Tobject;
  Node: TTreeNode; Var AllowExpansion: Boolean);
Var
  p: TPoint;
Begin
  GetCursorPos(p);
  p := treSpecialties.ScreenToClient(p);

  If (htOnStateIcon In treSpecialties.GetHitTestInfoAt(p.x, p.y)) Then
    AllowExpansion := False;

End;

Procedure TfrmMagTeleReaderOptions.ClearSpecialties();
Var
  i: Integer;
  UserSpecialty: TMagUserSpecialty;
Begin
{TODO: might want to delete each specialty pointer object before clearing tree items?}
{
  try

  for i := 0 to treSpecialties.Items.Count - 1 do
  begin
    UserSpecialty := treSpecialties.Items[i].Data;
    if UserSpecialty <> nil then UserSpecialty.Free();
  end;

  finally
  }
  treSpecialties.Items.Clear();
 // end;

End;

Procedure TfrmMagTeleReaderOptions.btnOKClick(Sender: Tobject);
Begin
  FSaveSettings := False;
  ModalResult := MrOK;
End;

End.
