unit uMagRMakeAbsError;

interface

Procedure WriteErrorFile(ErrFile: string; Errmsg: string);
Procedure ErrorException(ErrorText, ErrFileName: string);

implementation
uses
FmxUtils, sysutils, forms;
Procedure WriteErrorFile(ErrFile: string; Errmsg: string);
var
  LoadFile, F2: TextFile;
  Ch: Char;
begin
try
  AssignFile(LoadFile, ErrFile);
  Rewrite(LoadFile);
  Writeln(LoadFile, Errmsg);
  FileMode := 2;
  CloseFile(LoadFile);
  application.processmessages;
  exit;
  except
  WriteErrorFile('c:\magabserror.txt', '1^Illegal error file name');
  application.processmessages;
  exit;
  end;
end;

Procedure ErrorException(ErrorText, ErrFileName: string);
begin
//ViewerRec.MakeAbsError := ErrorText;
WriteErrorFile(ErrFileName, ErrorText); {RED 02/05/04}
end;
end.
