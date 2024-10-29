unit MagPositions;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Form Utilities 
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


interface
uses forms, inifiles, SysUtils, controls, graphics, grids, umagutils,
magguini; // maggut1;

procedure SaveFormPosition(Form: Tform; xDirectory : string = '');
procedure GetFormPosition(Form: Tform; xDirectory : string = '');
//procedure GetStringGridFont(name: string; xstringgrid: TStringGrid);
procedure SaveControlFont(Name: string; ctrlfont: Tfont);
//   GetFormPosition(self as Tform);  SaveFormPosition(Self as Tform);
implementation

(*procedure GetStringGridFont(Name: string; xstringgrid: Tstringgrid);
var
  stFont: string;
  xFont: Tfont;
begin
  xFont := TFont.create;
  try

    stFont := GetINIEntry('SYS_Fonts', name);
    if (stFont = '') then exit;
// xFont in the format FontName^Size^[B|U|I]
    xfont.name := magpiece(stFont, '^', 1);
    xfont.size := strtoint(magpiece(stFont, '^', 2));
    if (pos('B', magpiece(stfont, '^', 3)) > 0) then xfont.style := [fsBold];
    if (pos('I', magpiece(stfont, '^', 3)) > 0) then xfont.style := xfont.style + [fsitalic];
    xstringgrid.font := xfont;
  finally;
    xfont.Free;
  end;
end; *)

procedure SaveControlFont(Name: string; ctrlfont: Tfont);
var stFont: string;
begin
with tinifile.create(GetConfigFileName) do
begin
  try
    stFont := ctrlfont.name + '^' + inttostr(ctrlfont.size) + '^';
    if fsBold in ctrlfont.style then stFont := stFont + 'B';
    if fsItalic in ctrlfont.style then stFont := stFont + 'I';
    WriteString('SYS_Fonts', name, stFont);
  finally
    free;
  end;
end;
end;

procedure saveformposition(Form: Tform; xDirectory : string = '');
begin
  if form.windowstate <> wsnormal then exit;
  with tinifile.create(GetConfigFileName(xDirectory)) do
    begin
  try
    writestring('SYS_LastPositions', form.name, inttostr(form.left) + ',' + inttostr(form.top) + ',' +
      inttostr(form.width) + ',' + inttostr(form.height));
  finally
    free;
  end;
  end;
end;

procedure getformposition(Form: Tform; xDirectory : string = '');
var
  FORMpos: string;
  wrksarea : TMagScreenArea;
begin
  with tinifile.create(GetConfigFileName(xDirectory)) do
   begin
  try
    FORMpos := readstring('SYS_LastPositions', form.name, 'NONE');
  finally
    free;
  end;
  end;
  if FORMpos <> 'NONE' then
  begin
    if ((form.BorderStyle = bsSizeToolWin) or (form.borderstyle = bssizeable))
      then FORM.setbounds(strtoint(magpiece(formpos, ',', 1)), strtoint(magpiece(formpos, ',', 2)),
        strtoint(magpiece(formpos, ',', 3)), strtoint(magpiece(formpos, ',', 4)))
    else begin
      FORM.LEFT := strtoint(magpiece(formpos, ',', 1));
      FORM.TOP := strtoint(magpiece(formpos, ',', 2));
    end;
  end;
  wrksarea := GetScreenArea;
  try
  if (form.Left + form.Width) > wrksarea.right then form.left := wrksarea.right - form.Width;
  if (form.top + form.height) > wrksarea.bottom then form.top := wrksarea.bottom - form.height;
  if (form.top < wrksarea.top) then form.top := wrksarea.top;
  if (form.left < wrksarea.left) then form.left := wrksarea.left;

finally
wrksarea.free;
end;
end;
end.
