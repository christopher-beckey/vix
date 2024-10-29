Unit MagPrevInstance;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utility. Check for Previous instance of Imaging.
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
//Uses Vetted 20090929:StdCtrls, Dialogs, Forms, Controls, Graphics, Classes, Messages, SysUtils, Windows
{function DoIExistxxx(WndTitle : String) : Boolean;  }
Function DoIExist(Semaphore: String): Boolean;
Function IsAppRunning(AppTitle: String; SetAppForeground: Boolean = False): Boolean;
Implementation
Uses
  Windows,
  SysUtils
  ;

Function IsAppRunning(AppTitle: String; SetAppForeground: Boolean = False): Boolean;
Var
  Hwnd: THandle;
  app: Array[0..256] Of Char; //pchar;
Begin
  Strpcopy(app, AppTitle);
  Result := False;
  Hwnd := FindWindow(Nil, app);
  If Hwnd <> 0 Then
  Begin
    If SetAppForeground Then SetForegroundWindow(Hwnd);
    Result := True;
  End;
End;

{
 This is a different twist on finding a previous instance of an application
 in a 32-bit environment. It uses a semaphore (although you could also use a mutex object)
 nstead of performing an EnumWindows to find a previous instance, like you would have done
  in a 16-bit environment. This is more in line with multi-threaded app design.

}

Function DoIExist(Semaphore: String): Boolean;
Var
  HSem: THandle;
Begin
  HSem := OpenSemaphore(1, False, PChar(Semaphore));
  If HSem = 0 Then
  Begin
    Result := False;
    CreateSemaphore(Nil, 0, 1, PChar(Semaphore));
  End
  Else
    Result := True;
End;

(* Example : copied from somewhere

function DoIExistxxx(WndTitle : String) : Boolean;
var
  hSem    : THandle;
  hWndMe  : HWnd;
  semNm,
  wTtl    : Array[0..256] of Char;
begin

  Result := False;

  //Initialize arrays
  StrPCopy(semNm, 'SemaphoreName');
  StrPCopy(wTtl, WndTitle);

  //Create a Semaphore in memory - If this is the first instance, then
  //it should be 0.
  hSem := CreateSemaphore(nil, 0, 1, semNm);

  //Now, check to see if the semaphore exists
  if ((hSem <> 0) AND (GetLastError() = ERROR_ALREADY_EXISTS)) then begin
    CloseHandle(hSem);

    //We'll first get the currently executing window's handle then change its title
    //so we can look for the other instance
  hWndMe := FindWindow(nil, wTtl);
    SetWindowText(hWndMe, 'zzzzzzz');

    //What we want to do now is search for the other instance of this window
    //then bring it to the top of the Z-order stack.
    hWndMe := FindWindow(nil, wTtl);
    if (hWndMe <> 0) then begin
      if IsIconic(hWndMe) then
        ShowWindow(hWndMe, SW_SHOWNORMAL)
      else
        SetForegroundWindow(hWndMe);
    end;

    Result := True;

    //Could put the Halt here, instead of in the FormCreate method,

    //unless you want to do some extra processing.

    //Halt;
  end;
end;
*)

End.
