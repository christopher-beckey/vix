program Mag_App_MakePDFDoc;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   April 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   program Mag_App_MakePDFDoc
  Description: This is a Delphi console application that takes a list of VistA Imaging files
  and attempts to create a bookmarked PDF file from them.  If a file cannot be
  added to the bookmarked PDF file, it will notify the caller of an exception.
  The caller then decides what to do. In Patch 130, the caller will notice the exception and
  then copy the file that produced the exception to the disclosure folder so it
  can be handed over as part of the disclosure.

  The types of VistA Imaging files that are allowed into the bookmarked PDF are
  of type: PDF, TIF, BMP, or JPG.

  The InputSrcFileList should be a list of one or more documents (VistA Imaging
  files) that are structured as:  SourceFileNameFullyPathed^ArbitraryBookmarkName

  The caller will decide upon what to provide as the "Arbitrary Bookmark Name".

  This console application is called by a VISA web service to hide these details from
  the web service consumer.  This console application calls three entry points in
  the MAG_ROI_DLL.dll as follows:

  procedure Delphi_MakePDFDoc(JobID: String;
                             DebugFile: String;
                             ROI_Office_Name: String;
                             InputSrcFileList: String;
                             ManifestRoot: String;
                             ManifestPatDir: String;
                             PatientName: String;
                             PatientICN: String;
                             PatientSSN: String;
                             PatientDOB: String;
                             DisclosureDate: String;
                             DisclosureTime: String;
                             var RetCode: String); stdcall; external 'MAG_ROI_DLL.dll';


  procedure Delphi_PDFJobCompleted; stdcall; external 'MAG_ROI_DLL.dll';

  function Delphi_TestConnection: Boolean; stdcall; external 'MAG_ROI_DLL.dll';

  *** The console app and the DLL must be in the same folder.

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

{$APPTYPE CONSOLE}

uses
  SysUtils;

  procedure Delphi_MakePDFDoc(JobID: String;
                             DebugFile: String;
                             ROI_Office_Name: String;
                             InputSrcFileList: String;
                             ManifestRoot: String;
                             ManifestPatDir: String;
                             PatientName: String;
                             PatientICN: String;
                             PatientSSN: String;
                             PatientDOB: String;
                             DisclosureDate: String;
                             DisclosureTime: String;
                             var RetCode: String); stdcall; external 'Mag_ROI_DLL.dll';


  procedure Delphi_PDFJobCompleted; stdcall; external 'Mag_ROI_DLL.dll';

  function Delphi_TestConnection: Boolean; stdcall; external 'Mag_ROI_DLL.dll';

var
  DebugMode: String;
  DebugModeDelphi: Boolean;
  manifestRoot: String;
  PatientName: String;
  inputFileDir: String;
  manifestPatDir: String;
  JobID, PatName, PatICN, PatSSN, PatDOB: String;
  ROI_Office_Name: String;
  DisclDate, DisclTime: String;
  ReturnCode: String;
  i: Integer;
  S: String;
begin
  try
    JobID           := ParamStr(1);
    DebugMode       := Uppercase(ParamStr(2));
    ROI_Office_Name := ParamStr(3);
    inputFileDir    := ParamStr(4);
    manifestRoot    := ParamStr(5);
    manifestPatDir  := ParamStr(6);
    PatName         := ParamStr(7);
    PatICN          := ParamStr(8);
    PatSSN          := ParamStr(9);
    PatDOB          := ParamStr(10);
    DisclDate       := ParamStr(11);
    DisclTime       := ParamStr(12);

    {'TD' is True-Delphi. Delphi console debugging needs a Readln to keep the console from closing at the end of the job
     and losing the debug lines. Jave console debugging, for the purpose of running this on a server needs unattended
     operation.  Java server operation should not have Readln statements executed!}
    DebugModeDelphi := False;
    if (DebugMode <> 'T') and (DebugMode <> 'TD') then
      DebugMode := 'F'
    else
    if DebugMode = 'TD' then
    begin
      DebugMode := 'T';
      DebugModeDelphi := True;
    end;

    if DebugMode = 'T' then
      if Delphi_TestConnection then
        Writeln('Delphi_TestConnection is True')
      else
        Writeln('Delphi_TestConnection is False');

    for i := 1 to ParamCount do
      S := S + 'Param('+ IntToStr(i) + ') =  ' + ParamStr(i) + #13#10;

    if DebugMode = 'T' then
      Writeln(S);

    ReturnCode := '';

    {Call the ROI Disclosure DLL}
    Delphi_MakePDFDoc(
                      JobID,
                      DebugMode,
                      ROI_Office_Name,
                      inputFileDir + '\' + JobID + '.txt',
                      manifestRoot,
                      ManifestPatDir,
                      PatName,
                      PatICN,
                      PatSSN,
                      PatDOB,
                      DisclDate,
                      DisclTime,
                      ReturnCode);

    Delphi_PDFJobCompleted;

    if DebugMode = 'T' then
      Writeln('Job ' + JobID + ' is complete. Return Code = ' + ReturnCode);

    if DebugModeDelphi then
    begin
      Writeln('You are in debug mode (TD). Press enter to terminate this run.');
      Readln;
    end;

    if ReturnCode <> '0' then
      Halt(1)
    else
      Halt(0);

  except
    on E:Exception do
    begin
      Writeln(E.Classname, ': ', E.Message);
      Halt(2);
    end;
  end;
end.
