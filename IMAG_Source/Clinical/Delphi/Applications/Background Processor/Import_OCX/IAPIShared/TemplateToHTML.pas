Unit TemplateToHTML;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Ver 3 Patch 8  7/1/2002 ( not used in Patch 8)
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description:  Used FormTemplate, to propagate the same look and
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
  Controls,
  FormTemplate,
  Menus,
  OleCtrls,
  SHDocVw
  ;

//Uses Vetted 20090929:ExtCtrls, ToolWin, Dialogs, Forms, Graphics, Classes, SysUtils, Messages, Windows,

Type
  TtemplateHTML = Class(TformTemplate1)
    WebBrowser1: TWebBrowser;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    MStop: TMenuItem;
    N2: TMenuItem;
    Procedure FormCreate(Sender: Tobject);
    Procedure ToolButton3Click(Sender: Tobject);
    Procedure ToolButton4Click(Sender: Tobject);
    Procedure MStopClick(Sender: Tobject);
    Procedure Font1Click(Sender: Tobject);
  Private
   //hints and warnings: moved to public
   //procedure opentheimage(fn : string); override;
  Public
    Procedure Opentheimage(Fn: String); Override;
    { Public declarations }
  End;

Var
  TemplateHTML: TtemplateHTML;

Implementation

{$R *.DFM}

{ Tformtemplate3 }

Procedure TtemplateHTML.Opentheimage(Fn: String);
Begin
  Show;
  BringToFront;
  WebBrowser1.Navigate(Fn);
End;

Procedure TtemplateHTML.FormCreate(Sender: Tobject);
Begin
  Inherited;
  WebBrowser1.Align := alClient;
End;

Procedure TtemplateHTML.ToolButton3Click(Sender: Tobject);
Begin
  Inherited;
  Try
    WebBrowser1.GoBack;
  Except
  //
  End;
End;

Procedure TtemplateHTML.ToolButton4Click(Sender: Tobject);
Begin
  Inherited;
  Try
    WebBrowser1.GoForward;
  Except
  //
  End;

End;

Procedure TtemplateHTML.MStopClick(Sender: Tobject);
Begin
  Inherited;
  WebBrowser1.Stop;
End;

Procedure TtemplateHTML.Font1Click(Sender: Tobject);
Begin
  Inherited;
  WebBrowser1.ShowBrowserBar(EmptyParam);
End;

End.
