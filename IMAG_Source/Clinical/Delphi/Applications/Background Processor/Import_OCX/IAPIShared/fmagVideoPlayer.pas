Unit FmagVideoPlayer;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Video (avi, mpeg) player window.
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
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  MPlayer,
  Stdctrls,
  UMagClasses,
  ImgList,
  ToolWin
  ;

//Uses Vetted 20090929:ImgList, OleCtrls, ToolWin, Dialogs, Graphics, Messages, WinProcs, magpositions, umagutils, WinTypes, SysUtils

Type
  TfrmVideoPlayer = Class(TForm)
    LbAlign: Tlabel;
    NoTrackPanel: Tpanel;
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    MShowProgress: TMenuItem;
    TrackPanel: Tpanel;
    ToolBar2: TToolBar;
    TbPlay: TToolButton;
    Tbpause: TToolButton;
    TbStop: TToolButton;
    ToolButton7: TToolButton;
    TbRewind: TToolButton;
    Label1: Tlabel;
    Label2: Tlabel;
    Label3: Tlabel;
    Panel2: Tpanel;
    Pimagedesc: Tpanel;
    Panel1: Tpanel;
    ImageList1: TImageList;
    MPrgSeconds: TMenuItem;
    MPrgFrames: TMenuItem;
    N1: TMenuItem;
    LbFormat: Tlabel;
    N2: TMenuItem;
    MLoop: TMenuItem;
    View1: TMenuItem;
    ZoomOut1: TMenuItem;
    ZoomIn1: TMenuItem;
    Default1: TMenuItem;
    TrackBar1: TTrackBar;
    Setstart1: TMenuItem;
    Setend1: TMenuItem;
    Resetstartend1: TMenuItem;
    N3: TMenuItem;
    Actions1: TMenuItem;
    MPlay: TMenuItem;
    MStop: TMenuItem;
    MRewind: TMenuItem;
    PopupMenu1: TPopupMenu;
    SetStartPoint1: TMenuItem;
    SetEndPoint1: TMenuItem;
    ClearStartEnd1: TMenuItem;
    N4: TMenuItem;
    MpopLoop: TMenuItem;
    MFile: TMenuItem;
    MExit: TMenuItem;
    MnuImageReport: TMenuItem;
    N5: TMenuItem;
    MReport: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    GotoMainWindow1: TMenuItem;
    MHelp: TMenuItem;
    VideoPlayerwindowhelp1: TMenuItem;
    N8: TMenuItem;
    MStayonTop: TMenuItem;
    ImageDesc: Tlabel;
    MnuSpeed1: TMenuItem;
    Slow1: TMenuItem;
    Medium1: TMenuItem;
    Fast1: TMenuItem;
    Procedure MediaPlayer1Click(Sender: Tobject; Button: TMPBtnType;
      Var DoDefault: Boolean);
    Procedure RewindClick(Sender: Tobject);
    Procedure StopVideoClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure MediaPlayer1Notify(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure Timer1Timer(Sender: Tobject);
    Procedure TbPlayClick(Sender: Tobject);
    Procedure TbpauseClick(Sender: Tobject);
    Procedure TbStopClick(Sender: Tobject);
    Procedure TbRewindClick(Sender: Tobject);
    Procedure MShowProgressClick(Sender: Tobject);
    Procedure MPrgFramesClick(Sender: Tobject);
    Procedure MPrgSecondsClick(Sender: Tobject);
    Procedure MLoopClick(Sender: Tobject);
    Procedure ZoomIn1Click(Sender: Tobject);
    Procedure Default1Click(Sender: Tobject);
    Procedure TrackBar1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure Setstart1Click(Sender: Tobject);
    Procedure Setend1Click(Sender: Tobject);
    Procedure Resetstartend1Click(Sender: Tobject);
    Procedure ZoomOut1Click(Sender: Tobject);
    Procedure MPlayClick(Sender: Tobject);
    Procedure MStopClick(Sender: Tobject);
    Procedure MRewindClick(Sender: Tobject);
    Procedure SetStartPoint1Click(Sender: Tobject);
    Procedure SetEndPoint1Click(Sender: Tobject);
    Procedure ClearStartEnd1Click(Sender: Tobject);
    Procedure PopupMenu1Popup(Sender: Tobject);
    Procedure MpopLoopClick(Sender: Tobject);
    Procedure TrackBar1Change(Sender: Tobject);
    Procedure MExitClick(Sender: Tobject);
    Procedure MnuImageReportClick(Sender: Tobject);
    Procedure MReportClick(Sender: Tobject);
    Procedure GoToMainWindow1Click(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure MStayonTopClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure Slow1Click(Sender: Tobject);
    Procedure Medium1Click(Sender: Tobject);
    Procedure Fast1Click(Sender: Tobject);
    Procedure MFileClick(Sender: Tobject);
  Private
    Procedure VideoImageReport;
    Procedure RePositionTheDisplay;
    Procedure UpdateProgresslabel;
    Procedure Initializescrollbar;
    Procedure Resetscrollbar;
    Procedure ButtonsStopped;
    Procedure ButtonsPlaying;
  Public
    ImageData: TImageData;
    Procedure InitFile(Videofile, Desc: String; Magien: String = '');
    Procedure StartPlay;

  End;

Var
  FrmVideoPlayer: TfrmVideoPlayer;
  Looping: Boolean; // = false;
  Stopit: Boolean;

Implementation

Uses
  DmSingle,
  Magpositions,
  SysUtils,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Procedure TfrmVideoPlayer.MediaPlayer1Click(Sender: Tobject; Button: TMPBtnType;
  Var DoDefault: Boolean);
Begin

End;

(*
procedure TVideoF.MediaPlayer1Click(Sender: TObject; Button: TMPBtnType;
  var DoDefault: Boolean);
begin
MediaPlayer1.FileName:=Edit1.Text;
MediaPlayer1.Open;
MediaPlayer1.Display:=Panel1;
MediaPlayer1.Play;
end;  *)

Procedure TfrmVideoPlayer.RewindClick(Sender: Tobject);
Begin
  MediaPlayer1.Rewind;
End;

Procedure TfrmVideoPlayer.StopVideoClick(Sender: Tobject);
Begin
  MediaPlayer1.Stop;
End;

Procedure TfrmVideoPlayer.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  ImageData := TImageData.Create;
End;

Procedure TfrmVideoPlayer.MediaPlayer1Notify(Sender: Tobject);
Begin
  With Sender As TMediaPlayer Do
  Begin
    // resetscrollbar;
     //Form1.Caption := ModeStr[Mode];
     { Note we must reset the Notify property to True }
     { so that we are notified the next time the }
     { mode changes }
    Notify := True;
  End;

End;

Procedure TfrmVideoPlayer.Initializescrollbar;
Var
  x: Longint;
Begin
  TrackBar1.Min := 0; {MediaPlayer1.Position;}
  TrackBar1.Max := MediaPlayer1.Length;
  TrackBar1.Position := MediaPlayer1.Position;
  x := MediaPlayer1.StartPos;
  If x = 0 Then
    Label1.caption := '0'
  Else
    If MediaPlayer1.TimeFormat = Tfmilliseconds Then
      Label1.caption := Floattostrf(x / 1000, Fffixed, 3, 2)
    Else
      Label1.caption := '0';

  x := MediaPlayer1.Position;
  If x = 0 Then
    Label2.caption := '0'
  Else
    If MediaPlayer1.TimeFormat = Tfmilliseconds Then
      Label2.caption := Floattostrf(x / 1000, Fffixed, 3, 2)
    Else
      Label2.caption := FloatTostr(x);

  x := MediaPlayer1.Length;
  If x = 0 Then
    Label3.caption := '0'
  Else
    If MediaPlayer1.TimeFormat = Tfmilliseconds Then
      Label3.caption := Floattostrf(x / 1000, Fffixed, 3, 2)
    Else
      Label3.caption := FloatTostr(x);

  TrackBar1.Update;
End;

Procedure TfrmVideoPlayer.Resetscrollbar;
Begin
  TrackBar1.Position := MediaPlayer1.Position;
  UpdateProgresslabel;
  TrackBar1.Update;
End;

Procedure TfrmVideoPlayer.UpdateProgresslabel;
Var
  x: Longint;
Begin
  x := MediaPlayer1.Position;
  If x = 0 Then
    Label2.caption := '0'
  Else
    If MediaPlayer1.TimeFormat = Tfmilliseconds Then
      Label2.caption := Floattostrf(x / 1000, Fffixed, 3, 2)
    Else
      Label2.caption := FloatTostr(x);
End;

Procedure TfrmVideoPlayer.StartPlay;
Begin
  BringToFront;
  Update;
  Application.Processmessages;
  With MediaPlayer1 Do
  Begin
    If MShowProgress.Checked Then
      TbPlayClick(Self)
    Else
      Play;
  End;
End;

Procedure TfrmVideoPlayer.InitFile(Videofile, Desc: String; Magien: String = '');
Begin
  With MediaPlayer1 Do
  Begin
    If ImageData = Nil Then ImageData := TImageData.Create;
    If Magien <> '' Then ImageData.Mag0 := Magien;
    Display := FrmVideoPlayer.Panel1;
    //autoopen:= true;

    Filename := Videofile;
    Open;
    RePositionTheDisplay;
    TimeFormat := Tfframes;
    Frames := 1;
  End;
  Initializescrollbar;
  Resetscrollbar;
  ImageDesc.caption := Desc;
End;

Procedure TfrmVideoPlayer.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  action := caFree;
  Try
    MediaPlayer1.Stop;
  Finally
    Timer1.Enabled := False;
  End;
End;

Procedure TfrmVideoPlayer.Timer1Timer(Sender: Tobject);
Begin
  Resetscrollbar;
  Application.Processmessages;

  If TrackBar1.Position >= TrackBar1.Max Then
  Begin
    If TrackBar1.SELSTART > 0 Then
      MediaPlayer1.Position := TrackBar1.SELSTART
    Else
      MediaPlayer1.Rewind;
    Resetscrollbar;
    If Not Looping Then
    Begin
      Timer1.Enabled := False;
      ButtonsStopped;
    End;
    Exit;
  End;

  ////////////////////
  If (TrackBar1.SELEND > 0) And (TrackBar1.Position > TrackBar1.SELEND) Then
  Begin
    If Looping Then MediaPlayer1.Position := TrackBar1.SELSTART;
    Resetscrollbar;
    If Not Looping Then
    Begin
      Timer1.Enabled := False;
      ButtonsStopped;
    End;
    Exit;
  End;

  MediaPlayer1.Step;

End;

Procedure TfrmVideoPlayer.TbPlayClick(Sender: Tobject);
Begin
  Timer1.Enabled := True;
  ButtonsPlaying;
  //mediaplayer1.play;
End;

Procedure TfrmVideoPlayer.ButtonsPlaying;
Begin
  If Tbpause.Down Then Tbpause.Down := False;
  Tbpause.Enabled := True;
  TbStop.Enabled := True;
  TbPlay.Enabled := False;
End;

Procedure TfrmVideoPlayer.TbpauseClick(Sender: Tobject);
Begin
  If Tbpause.Down Then
  Begin
    Timer1.Enabled := False;
    //mediaplayer1.stop;
  End
  Else
  Begin
    //mediaplayer1.play;
    Timer1.Enabled := True;
  End;
End;

Procedure TfrmVideoPlayer.TbStopClick(Sender: Tobject);
Begin
  Timer1.Enabled := False;
  //mediaplayer1.stop;
  ButtonsStopped;
End;

Procedure TfrmVideoPlayer.ButtonsStopped;
Begin
  TbStop.Enabled := False;
  If Tbpause.Down Then Tbpause.Down := False;
  Tbpause.Enabled := False;
  TbPlay.Enabled := True;
End;

Procedure TfrmVideoPlayer.TbRewindClick(Sender: Tobject);
Begin
  MediaPlayer1.Rewind;
  Resetscrollbar;
  ButtonsStopped;
End;

Procedure TfrmVideoPlayer.MShowProgressClick(Sender: Tobject);
Begin
  MediaPlayer1.Stop;
  MShowProgress.Checked := Not MShowProgress.Checked;
  If Not MShowProgress.Checked Then
  Begin
    TrackPanel.Visible := False;
    Timer1.Enabled := False;
    NoTrackPanel.Visible := True;
    MPrgFrames.Enabled := False;
    MPrgSeconds.Enabled := False;
    MLoop.Enabled := False;
    MnuSpeed1.Enabled := False;
  End
  Else
  Begin
    NoTrackPanel.Visible := False;
    TrackPanel.Visible := True;
    MPrgFrames.Enabled := True;
    MPrgSeconds.Enabled := True;
    MLoop.Enabled := True;
    MnuSpeed1.Enabled := True;
  End;
  RePositionTheDisplay;
End;

Procedure TfrmVideoPlayer.MPrgFramesClick(Sender: Tobject);
Begin
  MPrgFrames.Checked := True;
  LbFormat.caption := 'Frames';
  MediaPlayer1.TimeFormat := Tfframes;
  Initializescrollbar;
End;

Procedure TfrmVideoPlayer.MPrgSecondsClick(Sender: Tobject);
Begin
  MPrgSeconds.Checked := True;
  LbFormat.caption := 'Seconds';
  MediaPlayer1.TimeFormat := Tfmilliseconds;
  Initializescrollbar;
End;

Procedure TfrmVideoPlayer.MLoopClick(Sender: Tobject);
Begin
  MLoop.Checked := Not MLoop.Checked;
  Looping := MLoop.Checked;
End;

Procedure TfrmVideoPlayer.RePositionTheDisplay;
Var
  Tr: Trect;
Begin
  Tr := FrmVideoPlayer.MediaPlayer1.Displayrect;
  Tr.Top := 5;
  Tr.Left := 5;
  If Tr.Right > (TrackBar1.Left + TrackBar1.Width + 20) Then
    FrmVideoPlayer.Width := Tr.Right + 20
  Else
  Begin
    FrmVideoPlayer.Width := TrackBar1.Left + TrackBar1.Width + 20;
    Tr.Left := ((FrmVideoPlayer.Width - Tr.Right) Div 2)
  End;

  FrmVideoPlayer.ClientHeight := Panel2.Top + Panel1.Top + 5 + Tr.Bottom + 5;

  MediaPlayer1.Displayrect := Tr;
End;

Procedure TfrmVideoPlayer.ZoomIn1Click(Sender: Tobject);
Var
  Tr: Trect;
Begin
  Tr := FrmVideoPlayer.MediaPlayer1.Displayrect;

  Tr.Right := Trunc(Tr.Right * 1.5);
  Tr.Bottom := Trunc(Tr.Bottom * 1.5);
  FrmVideoPlayer.MediaPlayer1.Displayrect := Tr;
  RePositionTheDisplay;
End;

Procedure TfrmVideoPlayer.Default1Click(Sender: Tobject);
Var
  Tr: Trect;
Begin
  Tr := FrmVideoPlayer.MediaPlayer1.Displayrect;

  Tr.Right := 0;
  Tr.Bottom := 0;
  FrmVideoPlayer.MediaPlayer1.Displayrect := Tr;
  RePositionTheDisplay;
End;

Procedure TfrmVideoPlayer.TrackBar1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If ((Ssright In Shift) Or (Not (SsShift In Shift))) Then
  Begin
    TrackBar1.SELEND := 0;
    TrackBar1.SELSTART := 0;
    Exit;
  End;
  With TrackBar1 Do
  Begin
    If Key = 40 Then
    Begin
      If ((SELSTART = 0) And (SELEND = 0)) Then
      Begin
        SELSTART := Position;
        SELEND := Position;
        Exit;
      End;
      If SELSTART > Position Then
        SELSTART := Position
      Else
        SELEND := Position;
    End;
  End;
End;

Procedure TfrmVideoPlayer.Setstart1Click(Sender: Tobject);
Begin
  TrackBar1.SELSTART := TrackBar1.Position;
End;

Procedure TfrmVideoPlayer.Setend1Click(Sender: Tobject);
Begin
  TrackBar1.SELEND := TrackBar1.Position;
End;

Procedure TfrmVideoPlayer.Resetstartend1Click(Sender: Tobject);
Begin
  TrackBar1.SELEND := 0;
  TrackBar1.SELSTART := 0;

End;

Procedure TfrmVideoPlayer.ZoomOut1Click(Sender: Tobject);
Var
  Tr: Trect;
Begin
  Tr := FrmVideoPlayer.MediaPlayer1.Displayrect;

  Tr.Right := Trunc(Tr.Right / 1.5);
  Tr.Bottom := Trunc(Tr.Bottom / 1.5);
  FrmVideoPlayer.MediaPlayer1.Displayrect := Tr;
  RePositionTheDisplay;
End;

Procedure TfrmVideoPlayer.MPlayClick(Sender: Tobject);
Begin
  If MShowProgress.Checked Then
    TbPlayClick(Self)
  Else
    MediaPlayer1.Play;
End;

Procedure TfrmVideoPlayer.MStopClick(Sender: Tobject);
Begin
  If MShowProgress.Checked Then
    TbStopClick(Self)
  Else
    MediaPlayer1.Stop;
End;

Procedure TfrmVideoPlayer.MRewindClick(Sender: Tobject);
Begin
  If MShowProgress.Checked Then
    TbRewindClick(Self)
  Else
    MediaPlayer1.Rewind;
End;

Procedure TfrmVideoPlayer.SetStartPoint1Click(Sender: Tobject);
Begin
  TrackBar1.SELSTART := TrackBar1.Position;
  MediaPlayer1.StartPos := TrackBar1.Position;
End;

Procedure TfrmVideoPlayer.SetEndPoint1Click(Sender: Tobject);
Begin
  TrackBar1.SELEND := TrackBar1.Position;
  MediaPlayer1.EndPos := TrackBar1.Position;
End;

Procedure TfrmVideoPlayer.ClearStartEnd1Click(Sender: Tobject);
Begin
  TrackBar1.SELEND := 0;
  TrackBar1.SELSTART := 0;
End;

Procedure TfrmVideoPlayer.PopupMenu1Popup(Sender: Tobject);
Begin
  MpopLoop.Checked := MLoop.Checked;
End;

Procedure TfrmVideoPlayer.MpopLoopClick(Sender: Tobject);
Begin
  MLoopClick(Self);
End;

Procedure TfrmVideoPlayer.TrackBar1Change(Sender: Tobject);
Begin
  MediaPlayer1.Position := TrackBar1.Position;
  UpdateProgresslabel;
End;

Procedure TfrmVideoPlayer.MExitClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmVideoPlayer.MnuImageReportClick(Sender: Tobject);
Begin
  VideoImageReport;
End;

Procedure TfrmVideoPlayer.VideoImageReport;
Var
  Rmsg: String;
  Rstat: Boolean;
Begin
  If ImageData = Nil Then Exit;
  //p8t29 if magien.caption = '' then exit;
  //p8t29 buildreport(ImageData.Mag0, '', 'Image Report');
  Dmod.MagUtilsDB1.ImageReport(ImageData, Rstat, Rmsg);
End;

Procedure TfrmVideoPlayer.MReportClick(Sender: Tobject);
Begin
  VideoImageReport;
End;

Procedure TfrmVideoPlayer.GoToMainWindow1Click(Sender: Tobject);
Begin
  SetFocusToForm('frmMain');
End;

Procedure TfrmVideoPlayer.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Shift = [Ssctrl]) And (Key = VK_tab) Then
    PopupMenu1.Popup(Left + 20, Top + 50);
End;

Procedure TfrmVideoPlayer.MStayonTopClick(Sender: Tobject);
Begin
  MStayonTop.Checked := Not MStayonTop.Checked;
  If MStayonTop.Checked Then
    Formstyle := Fsstayontop
  Else
    Formstyle := FsNormal;
End;

Procedure TfrmVideoPlayer.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);

End;

Procedure TfrmVideoPlayer.Slow1Click(Sender: Tobject);
Begin
  Slow1.Checked := True;
  Timer1.Interval := 200;
End;

Procedure TfrmVideoPlayer.Medium1Click(Sender: Tobject);
Begin
  Medium1.Checked := True;
  Timer1.Interval := 100;
End;

Procedure TfrmVideoPlayer.Fast1Click(Sender: Tobject);
Begin
  Fast1.Checked := True;
  Timer1.Interval := 50;
End;

Procedure TfrmVideoPlayer.MFileClick(Sender: Tobject);
Begin
  If ImageData = Nil Then
    MnuImageReport.Enabled := False
  Else
    MnuImageReport.Enabled := Not (ImageData.Mag0 = '');

End;

End.
