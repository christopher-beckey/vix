Unit MagFloatConfigu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utility Dialog window to display one setting from
      the configuration.
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
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls, Classes
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Classes, SysUtils, Messages, Windows,

Type
  TMagFloatConfig = Class(TForm)
    Panel1: Tpanel;
    POK: Tpanel;
    bbOK: TBitBtn;
    cbQuickClose: TCheckBox;
    Procedure cbQuickCloseClick(Sender: Tobject);
    Procedure FormDeactivate(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
  Private

    Fpar: TWinControl;
    Fparleft, Fpartop: Integer;
    { Private declarations }
  Public
    CurObject: TWinControl;
    Procedure Init(InfObj, Parwin: TWinControl; Parleft, Partop: Integer); { Public declarations }
  End;

Var
  MagFloatConfig: TMagFloatConfig;

Implementation

{$R *.DFM}
Uses
  FmagCapMain
  ;

Procedure TMagFloatConfig.cbQuickCloseClick(Sender: Tobject);
Begin
  Frmcapmain.FCloseQuickSetting := cbQuickClose.Checked;
End;

Procedure TMagFloatConfig.FormDeactivate(Sender: Tobject);
Begin
  CurObject.Parent := Fpar;
  CurObject.Left := Fparleft;
  CurObject.Top := Fpartop;
  Frmcapmain.ToolbuttonsUp;

  Hide;
End;

Procedure TMagFloatConfig.Init(InfObj, Parwin: TWinControl; Parleft, Partop: Integer);
Begin

  CurObject := InfObj;
  Fpar := Parwin;
  Fparleft := Parleft;
  Fpartop := Partop;
End;

Procedure TMagFloatConfig.bbOKClick(Sender: Tobject);
Begin
  Self.Deactivate;
  Close;
End;

End.
