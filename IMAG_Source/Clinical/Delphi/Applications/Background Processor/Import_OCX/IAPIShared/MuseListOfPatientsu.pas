Unit MuseListOfPatientsu;
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
        ;; +---------------------------------------------------------------------------------------------------+
 
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
  Buttons,
  ExtCtrls,
  Maggut1,
  Inifiles,
  Maggmsgu,
  Magpositions,
  MuseDeclarations;

Type
  TMuseListofPatients = Class(TForm)
    Edit1: TEdit;
    Panel1: Tpanel;
    Panel2: Tpanel;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bNext20: TBitBtn;
    ListBox1: TListBox;
    SelPatName: Tlabel;
    SelPatID: Tlabel;
    Panel3: Tpanel;
    EPatName: TEdit;
    ESSN: TEdit;
    Label1: Tlabel;
    LbSSN: Tlabel;
    Pmsg: Tpanel;
    Label2: Tlabel;
    Procedure bbOKClick(Sender: Tobject);
    Procedure ListBox1DblClick(Sender: Tobject);
    Procedure bNext20Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure EPatNameKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ESSNKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ListBox1Click(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure bbOKKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ListBox1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormDestroy(Sender: Tobject);
  Private
    { Private declarations }
    Procedure ClearPatientListing;
    Procedure MorePatients; { Private declarations }
//    function outformat(i:integer):string;
  Public

    Function PatientSearch(Var PatientName, PatientID: String): Boolean;
  End;

Var
  MuseListofPatients: TMuseListofPatients;
  Actual: Integer;
  Lastscreen: String;
  Patientlisting: Tlist;
  Mei_PatientIDFromName: Tmei_PatientIDFromName;

Implementation

Uses Musetstu;

Var
  Patientlistingptr: MUSE_DEMOGRAPHIC_PTR;

{$R *.DFM}
{THIS FORM SHOULD BE CALLED MODALLY, (SHOWMODAL),
COMES BACK WHEN WINDOW QUICKS, SET MODALRESULT, THEN
CHECK LISTENTRY THAT WAS SELECTED.  TO SEND MROK YOU MUST
HAVE SOMETHING SELECTED.  SHOULDN'T CLOSE THIS
WINDOW UNLESS A PATIENT HAS BEEN SELECTED.  THEN WINDOWS
DON'T NEED TO CLOSE OTHER WINDOWS}

Procedure TMuseListofPatients.bbOKClick(Sender: Tobject);
Var
  TPatientID: String;
  TPatientName: String;
Begin
{SEE NOTE AT TOP, THIS CODE BELONGS IN THE EKGWin AFTER
SHOWMODAL RETURNS}
  If ListBox1.ItemIndex = -1 Then
  Begin
    If ((ListBox1.Items.Count = 0) And (EPatName.Text <> '')) Then
    Begin
      ESSN.Clear;
      TPatientName := EPatName.Text;
      TPatientID := '';
      PatientSearch(TPatientName, TPatientID);
      Exit;
    End;
    Maggmsgf.MagMsg('d', 'Select a Patient from the list', Pmsg);
    Exit;
  End;

  Patientlistingptr := Patientlisting[ListBox1.ItemIndex];
  SelPatID.caption := Patientlistingptr^.Patient.ID;
  SelPatName.caption := Patientlistingptr^.Name.Last + ',' + Patientlistingptr^.Name.First;
  Messagedlg('By selecting a patient from the MUSE Database, you might be viewing images for 2 different patients.', Mtconfirmation, [Mbok], 0);
  MuseListofPatients.ModalResult := MrOK;

End;

Procedure TMuseListofPatients.ListBox1DblClick(Sender: Tobject);

Begin
  bbOK.Click;
End;

Procedure TMuseListofPatients.bNext20Click(Sender: Tobject);
Begin
  MorePatients;
End;

Function TMuseListofPatients.PatientSearch(Var PatientName, PatientID: String): Boolean;
Var
  i, j, Status, Numentries: Smallint;
  Ltemp, Ftemp, X1temp, Xtemp, Temp, Ts, Tssn: String;
Const
  Tspace: String = '                              ';
Begin
  Result := False;
  If Not EKGWin.Museconnect Then Exit;

  Strpcopy(@MuseName.Last, MagPiece(PatientName, ',', 1));
  Strpcopy(@MuseName.First, MagPiece(PatientName, ',', 2));
  Numentries := 20; (* This is where we define the amount of patients *)
                     (* This is the size we made demoBuffer *)

  EKGWin.Showmsgwin('Searching for "' + PatientName + '"...');
  Try
    Status := Mei_PatientIDFromName(HMUSE, @MuseName, @DemoBuffer, @Numentries, @MusePID);
    If ((Status <> MUSE_SUCCESS) Or (Numentries = 0)) Then
    Begin
      Maggmsgf.MagMsg('de', 'PIDFromName Error: status=' + Inttostr(Status), Pmsg);
      Screen.Cursor := crDefault;

      Exit; {gek   quit if error }
    End;

    StrCopy(@MusePID.ID, @DemoBuffer[1].Patient.ID);
{ShowMessage('The patient id is '+(musePID.id));}

    MuseListofPatients.ListBox1.Clear;
    ClearPatientListing;
(* Lists all the patients with the same last name *)

    For i := 1 To Numentries Do
    Begin
      Ltemp := String(DemoBuffer[i].Name.Last);
      For j := 1 To Length(Ltemp) Do
        If (Ord(Ltemp[j]) = 0) Then Break;
      Xtemp := Copy(Ltemp, 1, j - 1);
      Ftemp := String(DemoBuffer[i].Name.First);
      For j := 1 To Length(Ftemp) Do
        If (Ord(Ftemp[j]) = 0) Then Break;
      X1temp := Copy(Ftemp, 1, j - 1);
      Temp := Xtemp + ',' + X1temp;

  //temp := demobuffer[i].name.last + ','+demobuffer[i].name.first;
      If (Length(Temp) < 30) Then
        Ts := Copy(Tspace, 1, 30 - Length(Temp))
      Else
        Ts := '   ';
      Tssn := Copy(DemoBuffer[i].Patient.ID, 1, 3) + '-' + Copy(DemoBuffer[i].Patient.ID, 4, 2) +
        '-' + Copy(DemoBuffer[i].Patient.ID, 6, 4);
      MuseListofPatients.ListBox1.Items.Add(Temp + Ts + Tssn);

   (* +'  age: '+inttostr(demobuffer[i].age)
   +' sex: '+inttostr(demobuffer[i].gender)
   +' dob: '+outformat(demobuffer[i].dob.month)+'/'+outformat(demobuffer[i].dob.day)+'/'
   + outformat(demobuffer[i].dob.year));  *)
   (* gek 9/97 tried this, but database is very incomplete, many entries had -1 age, and -1/-1/-1 dob *)

      New(Patientlistingptr);
      Patientlistingptr^ := DemoBuffer[i];
      Patientlisting.Add(Patientlistingptr);
    End;
{sHOWMESSAGE('ABOUT TO SHOW ListofPatients IN EDIT1.KEYDOWN');}
    ListBox1.SetFocus;
    ListBox1.Update;

{ListofPatients.showmodal;}

  Finally
    EKGWin.Hidemsgwin;
    Screen.Cursor := crDefault;
    EKGWin.Musedisconnect;
  End;

    {  }
End;

Procedure TMuseListofPatients.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
// these were commented out, we'll leave them out, because we aren't sure
// why they are commented out, and we "Can't afford the time"
//ClearPatientListing;
//listbox1.clear;

End;

Procedure TMuseListofPatients.FormCreate(Sender: Tobject);
Begin

// added the following for Dynamic DLL loading   SAF 1/24/2000
  @Mei_PatientIDFromName := GetProcAddress(LibHandle, 'mei_PatientIDFromName');
  If @Mei_PatientIDFromName = Nil Then
    RaiseLastWin32Error;
// end of DLL stuff

  GetFormPosition(Self As TForm);
  SelPatName.caption := '';
  SelPatID.caption := '';

  Patientlisting := Tlist.Create;
  New(Patientlistingptr);

End;

Procedure TMuseListofPatients.ClearPatientListing;
Var
  i: Integer;
Begin
  For i := Patientlisting.Count - 1 Downto 0 Do
  Begin
    Patientlistingptr := Patientlisting[i];
    Dispose(Patientlistingptr);
  End;
  Patientlisting.Clear;
End;

Procedure TMuseListofPatients.MorePatients;
Var
  Status, Numentries: Smallint;
  Top, i: Integer;
  Temp, Ts, Tssn: String;
Const
  Tspace: String = '                              ';
Begin
  Patientlistingptr := Patientlisting[Patientlisting.Count - 1];

  Strpcopy(@MuseName.Last, Patientlistingptr^.Name.Last);
  Strpcopy(@MuseName.First, Patientlistingptr^.Name.First);
  Strpcopy(@MusePID, Patientlistingptr^.Patient.ID);
  Numentries := 20; (* This is where we define the amount of patients *)
  If Not EKGWin.Museconnect Then Exit;
  Try (* This is the size we made demoBuffer *)
    Screen.Cursor := crHourGlass;
    Status := Mei_PatientIDFromName(HMUSE, @MuseName, @DemoBuffer, @Numentries, @MusePID);

    If Status <> MUSE_SUCCESS Then
    Begin
      Maggmsgf.MagMsg('de', 'PIDFromName Error: status=' + Inttostr(Status), Pmsg);
      Screen.Cursor := crDefault;
      Exit; {gek   quit if error }
    End;

    If Numentries = 0 Then
    Begin
      Maggmsgf.MagMsg('d', 'No more patients to add to the list', Pmsg);
      Exit;
    End;
    Top := ListBox1.Items.Count;
    For i := 2 To Numentries Do
    Begin
      Temp := Trim(DemoBuffer[i].Name.Last) + ',' + Trim(DemoBuffer[i].Name.First);
      If (Length(Temp) < 30) Then
        Ts := Copy(Tspace, 1, 30 - Length(Temp))
      Else
        Ts := '   ';
      Tssn := Copy(DemoBuffer[i].Patient.ID, 1, 3) + '-' + Copy(DemoBuffer[i].Patient.ID, 4, 2) +
        '-' + Copy(DemoBuffer[i].Patient.ID, 6, 4);
      MuseListofPatients.ListBox1.Items.Add(Temp + Ts + Tssn);
        (* +'  age: '+inttostr(demobuffer[i].age)
         +' sex: '+inttostr(demobuffer[i].gender)
         +' dob: '+outformat(demobuffer[i].dob.month)+'/'+outformat(demobuffer[i].dob.day)+'/'
         + outformat(demobuffer[i].dob.year));  *)
        (* gek 9/97 tried this, but database is very incomplete, many entries had -1 age, and -1/-1/-1 dob *)

      New(Patientlistingptr);
      Patientlistingptr^ := DemoBuffer[i];
      Patientlisting.Add(Patientlistingptr);
    End;
      {sHOWMESSAGE('ABOUT TO SHOW ListofPatients IN EDIT1.KEYDOWN');}
    ListBox1.Topindex := Top;
    MuseListofPatients.ListBox1.Update;
  Finally
    Screen.Cursor := crDefault;
    EKGWin.Musedisconnect;
  End;

End;

(*function TMuseListofPatients.outformat(i:integer):string;
begin
{turn a 1 digit number into a 2 character string with '0' as first;}
result := inttostr(i);
if length(inttostr(i))=1 then result := '0'+inttostr(i);
end;
*)

Procedure TMuseListofPatients.EPatNameKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Var
  TPatientID: String;
  TPatientName: String;
Begin
  ESSN.Clear;
  If Key <> VK_Return Then Exit; {GEK  QUIT IF NOT ENTER KEY}
  If EPatName.Text = '' Then Exit;
  TPatientName := EPatName.Text;
  TPatientID := '';
  Try
    Screen.Cursor := crHourGlass;
    PatientSearch(TPatientName, TPatientID)
  Finally
    Screen.Cursor := crDefault;
  End;
End;

Procedure TMuseListofPatients.ESSNKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Var
  PatientID, PatientName: String;

Begin
  EPatName.Clear;
  If Key <> VK_Return Then Exit;
  If ESSN.Text = '' Then Exit;

  Screen.Cursor := crHourGlass; {GEK,  SHOW IT'S SEARCHING}
  If Not EKGWin.Museconnect Then Exit;
  Try
    PatientID := ESSN.Text;
    While (Pos('-', PatientID) <> 0) Do
      Delete(PatientID, Pos('-', PatientID), 1);

    If Not EKGWin.GetNameFromSSN(PatientID, PatientName) Then Exit;
    EPatName.Text := PatientName;
    SelPatID.caption := PatientID;
    SelPatName.caption := PatientName;

  Finally
    EKGWin.Musedisconnect;
    Screen.Cursor := crDefault;
  End;
  MuseListofPatients.ModalResult := MrOK;

End;

Procedure TMuseListofPatients.ListBox1Click(Sender: Tobject);
Begin
  If ListBox1.ItemIndex = -1 Then
  Begin
    Maggmsgf.MagMsg('d', 'Select a Patient from the list', Pmsg);
    Exit;
  End;

  Patientlistingptr := Patientlisting[ListBox1.ItemIndex];
  ESSN.Text := Patientlistingptr^.Patient.ID;
  EPatName.Text := Patientlistingptr^.Name.Last + ',' + Patientlistingptr^.Name.First;

End;

Procedure TMuseListofPatients.FormShow(Sender: Tobject);
Begin
  If ListBox1.Items.Count > 0 Then
    ListBox1.SetFocus
  Else
    EPatName.SetFocus;
End;

Procedure TMuseListofPatients.bbOKKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  bbOK.Click;
End;

Procedure TMuseListofPatients.ListBox1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then bbOK.Click;
End;

Procedure TMuseListofPatients.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

End.
