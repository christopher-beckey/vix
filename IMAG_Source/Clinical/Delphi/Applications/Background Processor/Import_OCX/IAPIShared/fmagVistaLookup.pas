Unit FmagVistALookup;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utility lookup window.  Search the .01 (Name) field  in
   any FM File.
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
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:trpcb, cMagDBBroker, Dialogs, Graphics, Messages, magpositions, umagutils, SysUtils, Windows

Type
  TMagLookup = Class(TForm)
    Lbprompthelp: Tlabel;
    Panel1: Tpanel;
    LbPrompt: Tlabel;
    Einput: TEdit;
    Panel2: Tpanel;
    Searchlist: TListBox;
    Panel3: Tpanel;
    btnOK: TBitBtn;
    bbCancel: TBitBtn;
    StatusBar1: TStatusBar;
    SpeedButton1: TSpeedButton;
    Procedure SearchlistClick(Sender: Tobject);
    Procedure EinputKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure SearchlistDblClick(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure EinputEnter(Sender: Tobject);
    Procedure EinputExit(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure SpeedButton1Click(Sender: Tobject);
  Private
    FIENlist: Tstringlist;
    Procedure Selectentry;
    Procedure WinMsg(s: String);
    { Private declarations }
  Public
    FStartSearchText: String;
    FFileNumber: String;
    Fname: String;
    FIEN: String;
    Procedure LookupText(Input: String);

  End;

Var
  MagLookup: TMagLookup;

Function SearchVistAFile(Filenum, Prompt, Prompthelp, Title, Input: String; Quiton1: Boolean; Var Return: String): Boolean;

Implementation

Uses
  DmSingle,
  Magpositions,
  SysUtils,
  Umagutils8,
  Windows
  ;

{$R *.DFM}

Function SearchVistAFile(Filenum, Prompt, Prompthelp, Title, Input: String; Quiton1: Boolean; Var Return: String): Boolean;
Begin
  MagLookup := TMagLookup.Create(Nil);
  Try
    With MagLookup Do
    Begin
      FFileNumber := Filenum;
      caption := Title;
      LbPrompt.caption := Prompt;
      If (Prompthelp <> '') Then Lbprompthelp.caption := Prompthelp;
      Einput.Text := Input;
      (*if (INPUT <> '') then
      begin
        Lookuptext(input);
        if searchlist.items.count = 0 then
        begin
          result := false;
          return := 'NO Match found on : ' + input;
          exit;
        end;
        if (searchlist.items.count = 1) and quiton1 then
        begin
          result := true;
          return := fien + '^' + fname;
          exit;
        end;
      end; *)
      If (Input <> '') Then FStartSearchText := Input;
      Showmodal;
      If ModalResult = MrOK Then
      Begin
        Result := True;
        Return := FIEN + '^' + Fname;
        Exit;
      End
      Else
      Begin
        Result := False;
        Return := 'Search Canceled by User.';
      End;
    End;
  Finally;
    MagLookup.Release;
  End;

End;

Procedure TMagLookup.LookupText(Input: String);
Var
  Str: String;

  i: Integer;
  Rstat: Boolean;
  Rmsg: String;
  Tlist: Tstringlist;
Begin
  Searchlist.Items.Clear;
  Str := FFileNumber + '^50^' + Uppercase(Input);
  //if dhcpfile.caption = '2'
  //   then str := str+'^.1;'
  //   else str := str+'^' ;
  //if not (screen.caption = '') then str := str +'^'+screen.caption;
 { TODO -cdemo :
This is called from TIU window.
But plan is to make that function in TIU window, searching for author,
disabled in demo }
  Tlist := Tstringlist.Create;
  Try
    Dmod.MagDBBroker1.RPMag3LookupAny(Rstat, Rmsg, Tlist, Str);

(*    xBrokerx.PARAM[0].VALUE := STR;
    xBrokerx.PARAM[0].PTYPE := LITERAL;
    xBrokerx.REM OTEPROCEDURE := 'MAG3 LOOKUP ANY';
    xBrokerx.LSTCALL(t);

    if t.count = 0 then
    begin
      msg('ERROR: searching for : ' + input);
      exit;
    end;
*)
    If Not Rstat Then
    Begin
      WinMsg(Rmsg);
      Exit;
    End;
    If Tlist.Count = 1 Then
    Begin
      WinMsg(Tlist[0]);
      Exit;
    End;

    WinMsg(MagPiece(Tlist[0], '^', 2));
    Tlist.Delete(0);
    Tlist.Sorted := False;
    FIENlist.Sorted := False;
    FIENlist.Clear;
    For i := 0 To Tlist.Count - 1 Do
    Begin
      FIENlist.Add('');
      FIENlist[i] := MagPiece(Tlist[i], '^', 2);
      Tlist[i] := MagPiece(Tlist[i], '^', 1);
    End;
    Searchlist.Items.Assign(Tlist);
    Searchlist.ItemIndex := 0;
    Searchlist.SetFocus;
    Selectentry;

  Finally
    Tlist.Free;
  End;
End;

Procedure TMagLookup.SearchlistClick(Sender: Tobject);
Begin
  Selectentry;
End;

Procedure TMagLookup.Selectentry;
Begin
  Fname := Magstripspaces(Searchlist.Items[Searchlist.ItemIndex]);
  FIEN := Magstripspaces(FIENlist[Searchlist.ItemIndex]);
  btnOK.Enabled := True;
End;

Procedure TMagLookup.EinputKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key <> VK_Return Then
  Begin
    btnOK.Enabled := False;
    If Searchlist.Items.Count > 0 Then Searchlist.Items.Clear;
    Exit;
  End;
  LookupText(Einput.Text);
  btnOK.Enabled := (Searchlist.ItemIndex <> -1);
End;

Procedure TMagLookup.SearchlistDblClick(Sender: Tobject);
Begin
  MagLookup.ModalResult := MrOK;
End;

Procedure TMagLookup.btnOKClick(Sender: Tobject);
Begin
  If Searchlist.ItemIndex = -1 Then
  Begin
    WinMsg('You must select a list entry ! ');
    Exit;
  End;
End;

Procedure TMagLookup.WinMsg(s: String);
Begin
  StatusBar1.Panels[0].Text := s;
End;

Procedure TMagLookup.EinputEnter(Sender: Tobject);
Begin
  btnOK.Default := False;

End;

Procedure TMagLookup.EinputExit(Sender: Tobject);
Begin
  btnOK.Default := True;

End;

Procedure TMagLookup.FormShow(Sender: Tobject);
Begin
  If (Searchlist.Items.Count > 0) Then
    Searchlist.SetFocus
  Else
    Einput.SetFocus;
  If FStartSearchText <> '' Then
  Begin
    LookupText(FStartSearchText);
    FStartSearchText := '';

  End;
End;

Procedure TMagLookup.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  FIENlist := Tstringlist.Create;
End;

Procedure TMagLookup.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  FIENlist.Free;
End;

Procedure TMagLookup.SpeedButton1Click(Sender: Tobject);
Begin
  If Einput.Text = '' Then
  Begin
    Einput.SetFocus;
    StatusBar1.Panels[0].Text := Lbprompthelp.caption;
    Messagebeep(2);
  End
  Else
  Begin
    LookupText(Einput.Text);
    btnOK.Enabled := (Searchlist.ItemIndex <> -1);
  End;
End;

End.
