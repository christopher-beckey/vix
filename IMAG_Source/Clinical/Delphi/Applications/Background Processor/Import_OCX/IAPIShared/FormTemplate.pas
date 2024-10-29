Unit FormTemplate;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Ver 3 Patch 8  7/1/2002
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Template, used by other forms to propegate the same look and
       feel among the application.
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
  ComCtrls,
  ExtCtrls,
  Forms,
  Menus,
  UMagClasses,
  ToolWin,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:StdCtrls, ToolWin, OleCtrls, Dialogs, Controls, Graphics, Classes, SysUtils, Messages, Windows, umagutils

Type
  TformTemplate1 = Class(TForm)
    PnlTop: Tpanel;
    ImageDesc: Tpanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    MainMenu1: TMainMenu;
    MOptions: TMenuItem;
    MCopy: TMenuItem;
    MPrint: TMenuItem;
    MReport: TMenuItem;
    MHelp: TMenuItem;
    MHelp1: TMenuItem;
    ToolButton2: TToolButton;
    N1: TMenuItem;
    MExit: TMenuItem;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Procedure FormCreate(Sender: Tobject);
    Procedure MExitClick(Sender: Tobject);
    Procedure MReportClick(Sender: Tobject);
  Private

    Procedure OpenImageReport;
  Protected
    FWinCaption: String;
    FIObj: TImageData;
    Procedure Opentheimage(Fn: String); Virtual;
  Public
    Procedure LoadTheImage(Filename: String; IObj: TImageData);

  End;

Var
  FormTemplate1: TformTemplate1;

Implementation

Uses
  DmSingle,
  Umagutils8
  ;

Procedure TformTemplate1.LoadTheImage(Filename: String; IObj: TImageData);
Begin
  ImageDesc.caption := IObj.ExpandedDescription(False);
  ImageDesc.Hint := IObj.ExpandedIDDescription(False);
  FIObj := IObj;
  caption := FWinCaption + ' -- ' + IObj.PtName;
  FormToNormalSize(Self As TForm);
  Opentheimage(Filename);
End;

Procedure TformTemplate1.Opentheimage(Fn: String);
Begin

//PDF1.src := filename;

End;

{$R *.DFM}

Procedure TformTemplate1.FormCreate(Sender: Tobject);
Begin
  FWinCaption := caption;
//pdf1.align := alclient;
End;

Procedure TformTemplate1.MExitClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TformTemplate1.MReportClick(Sender: Tobject);
Begin
  OpenImageReport;
End;

Procedure TformTemplate1.OpenImageReport;
//var ien: string;
Var
  Rstat: Boolean;
  Rmsg: String;
Begin
//  if Edit1.text = '' then exit;
//  if eGroup.text <> '' then ien := eGroup.text
//  else ien := edit1.text;

//p8t29  buildreport(FIobj.Mag0 , '', 'Image Report');
  Dmod.MagUtilsDB1.ImageReport(FIObj, Rstat, Rmsg);
//  frmMain.logactions('FULL', 'REPORT', Full.Edit1.Text); {RED 10/31/96}
End;
End.
