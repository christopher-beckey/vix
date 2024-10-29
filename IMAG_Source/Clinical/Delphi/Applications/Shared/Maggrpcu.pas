Unit Maggrpcu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Version 2.5
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==    unit Maggrpcu;
   Description: Imaging Report window.  Displays reports from associated procedures.
      exams, Notes etc.
    -  created by other classes when a Report window is needed.
    -  Has method to Print the report.
    -  Has option to open another report window.  user can compare reports.

    All forms of Type : Tmaggrpcf are added to the Dynamic report menu on
    the main window.   User can open multiple and easily switch between them.
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
  Dialogs,
  ExtCtrls,
  Forms,
  Menus,
  Messages,
  Stdctrls,
  Classes,
  Controls
  ;

//Uses Vetted 20090929:Buttons, Controls, Graphics, Classes, WinProcs, WinTypes, umagutils, magpositions, Printers, SysUtils

Type
  TMaggrpcf = Class(TForm)
    PDesc: Tpanel;
    Memo1: TMemo;
    FontDialog1: TFontDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    New1: TMenuItem;
    N4: TMenuItem;
    Help1: TMenuItem;
    ImageReports1: TMenuItem;
    ActiveForms1: TMenuItem;
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure SpeedButton1Click(Sender: Tobject);
    Procedure N2Click(Sender: Tobject);
    Procedure Print1Click(Sender: Tobject);
    Procedure PrintSetup1Click(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure New1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure ImageReports1Click(Sender: Tobject);
    Procedure ActiveForms1Click(Sender: Tobject);
  Private
    {  maintain minimum and Maximum values for window size}
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  Public
    {  open a new report window.  User can compare reports, open multiple }
    Procedure NewReportWindow;
  End;

Var
  Maggrpcf: TMaggrpcf;
  PrintText: Text;
Implementation
Uses
  Magpositions,
  Printers,
  SysUtils,
//  u MagDisplayMgr,
  umagutils8A,
  Umagutils8
  ;

{$R *.DFM}

Procedure TMaggrpcf.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  If (Uppercase(Name) = 'MAGGRPCF') Then
    action := caHide
  Else
    action := caFree;
End;

Procedure TMaggrpcf.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(100 * (Pixelsperinch / 96));
  Wx := Trunc(200 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TMaggrpcf.SpeedButton1Click(Sender: Tobject);
Begin
  If FontDialog1.Execute Then Memo1.Font := FontDialog1.Font;
End;

Procedure TMaggrpcf.N2Click(Sender: Tobject);
Begin
  FontDialog1.Font := Memo1.Font;
  If FontDialog1.Execute Then Memo1.Font := FontDialog1.Font;
End;

Procedure TMaggrpcf.Print1Click(Sender: Tobject);
Var
  Line: Integer; {declare an integer variable for the number of lines of text}
Begin
  If PrintDialog1.Execute Then
  Begin
    AssignPrn(PrintText); {assign the global variable PrintText to the printer}
    Rewrite(PrintText); {create and open the output file}
    {   assign the current Font setting to the Printer object's canvas}
    Printer.Canvas.Font := Memo1.Font;
    {   write the contents of the Memo field to the   printer object}
    For Line := 0 To Memo1.Lines.Count - 1 Do
      Writeln(PrintText, Memo1.Lines[Line]);
    System.Close(PrintText);
  End;
End;

Procedure TMaggrpcf.PrintSetup1Click(Sender: Tobject);
Begin
  PrinterSetupDialog1.Execute;
End;

Procedure TMaggrpcf.Exit1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TMaggrpcf.New1Click(Sender: Tobject);
Begin
  NewReportWindow;
End;

Procedure TMaggrpcf.NewReportWindow;
Var
  Maggrpcf1: TMaggrpcf;
Begin
  If Memo1.Lines.Count = 0 Then Exit;
  Application.CreateForm(TMaggrpcf, Maggrpcf1);

  Maggrpcf1.Memo1.Lines.Assign(Maggrpcf.Memo1.Lines);
  Maggrpcf1.New1.Visible := False;
  Maggrpcf1.PDesc.caption := Maggrpcf.PDesc.caption;
  Maggrpcf1.caption := Maggrpcf.caption;
  Maggrpcf1.Memo1.Font := Maggrpcf.Memo1.Font;
  Maggrpcf.Memo1.Lines.Clear;
  Maggrpcf.PDesc.caption := '';
  Maggrpcf.caption := 'Report : ';
  Maggrpcf1.SetBounds(Left, Top, Width, Height);
  FormToNormalSize(Maggrpcf1);
  Maggrpcf.SetBounds(Left + 30, Top + 30, Width, Height);
  Maggrpcf.BringToFront;
End;

Procedure TMaggrpcf.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
End;

Procedure TMaggrpcf.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TMaggrpcf.ImageReports1Click(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure TMaggrpcf.ActiveForms1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

End.
