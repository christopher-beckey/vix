unit uMagUtils;
  {
  	Package: MAG - VistA Imaging
	WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
	Date Created:       2002
	Site Name: Silver Spring, OIFO
	Developers: Garrett Kirin
	Description: Image utilities
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
interface

uses StdCtrls, SysUtils, Controls,
  WinTypes, WinProcs, Messages, Classes, Graphics,
  Forms, Dialogs, Grids, Menus, ExtCtrls, shellapi;

 type
  TMagScreenArea = class
  left : integer;
  top : integer;
  right : integer;
  bottom : integer;
  width : integer;
  height : integer;
  end;

Function GetScreenArea : TmagScreenArea;

function magStripspaces(str: string): string;
function MAGLENGTH(STR, DEL: string): INTEGER;
function MAGPIECE(STR, DEL: string; PIECE: INTEGER): string;
procedure FormToNormalSize(xForm: Tform);


implementation


Function GetScreenArea : TmagScreenArea;
var wrkbar : APPBARDATA;
wrkspos : TMagScreenArea;
begin
wrkspos := TmagscreenArea.create;
wrkbar.cbSize := 36;
SHAppBarMessage(ABM_GETTASKBARPOS, wrkBar);

// get the left and right positions of the workstation area.
if (wrkBar.rc.Left <= 0) and (wrkbar.rc.right >= screen.width)
   then
   // taskbar is at top or bottom
     begin
      wrkspos.left := 0 ;
      wrkspos.right := screen.width;
      end
   else if (wrkBar.rc.left <=0) then
     //taskbar is at left
     begin
       wrkspos.left := wrkBar.rc.Right;
       wrkspos.right := screen.width;
     end
     else if (wrkbar.rc.right >=screen.width) then
     // taskbar is at right
       begin
         wrkspos.left := 0;
         wrkspos.right := wrkbar.rc.Left;
       end;


if (wrkBar.rc.top <= 0) and (wrkbar.rc.bottom >= screen.height)
   then
   // taskbar is at top or bottom
     begin
      wrkspos.top := 0 ;
      wrkspos.bottom := screen.height;
      end
   else if (wrkBar.rc.top <=0) then
     //taskbar is at top
     begin
       wrkspos.top := wrkBar.rc.bottom;
       wrkspos.bottom := screen.height;
     end
     else if (wrkbar.rc.bottom >=screen.height) then
     // taskbar is at bottom
       begin
         wrkspos.top := 0;
         wrkspos.bottom := wrkbar.rc.top;
       end;
 wrkspos.width := wrkspos.right - wrkspos.left;
 wrkspos.height := wrkspos.bottom - wrkspos.top;

result := wrkspos;
end;


procedure FormToNormalSize(xForm: Tform);
begin
  if (xForm.WindowState = wsminimized) then xForm.windowstate := wsnormal;
  xform.update;
  if xform.Visible = false then xForm.visible := true;
  xform.bringtofront;
  xform.update;
  application.processmessages;
end;


function MagPiece(str, del: string; Piece: Integer): string;
var I, K: INTEGER;
  s: string;
begin
  I := Pos(del, str);
  if (I = 0) and (PIECE = 1) then begin MAGPIECE := STR; EXIT; end;
  for K := 1 to PIECE do
  begin
    I := POS(DEL, STR);
    if (I = 0) then I := LENGTH(STR) + 1;
    S := COPY(STR, 1, I - 1);
    STR := COPY(STR, I + 1, LENGTH(STR));
  end;
  MAGPIECE := S;
end;

function MAGLENGTH(STR, DEL: string): INTEGER;
var I, J: INTEGER;
  ESTR: BOOLEAN;
begin
  ESTR := FALSE;
  I := 0;
  while not ESTR do
  begin
    I := I + 1;
    if (POS(DEL, STR) = 0) then ESTR := TRUE;
    J := POS(DEL, STR); STR := COPY(STR, J + 1, LENGTH(STR));
  end;
  MAGLENGTH := I;
end;



function magStripspaces(str: string): string;
var done: boolean;
var s: string;
begin
  if STR = '' then begin magstripspaces := ''; exit; end; {fix for hang}
  done := false;
  repeat
    s := str[1];
    if (s = ' ') then str := copy(str, 2, length(str));
    if not (str[1] = ' ') then done := true;
    if str = '' then done := true; {fix for hang}
  until done;
  done := false;
  repeat
    s := str[length(str)]; if (s = ' ') then str := copy(str, 1, length(str) - 1);
    if not (str[length(str)] = ' ') then done := true;
    if str = '' then done := true; {fix for hang}
  until done;
  magStripspaces := str;
end;



end.
