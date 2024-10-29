unit cmagCopyThread;

interface

uses
  Classes, SysUtils;

Const
  KB1 = 1024;
  MB1 = 1024*KB1;
  GB1 = 1024*MB1;

type
  TThreadCopyFile = class(TThread)
  public
    Block : integer;
    Percent    : Integer;
    blockSize     : integer;
    Done,ToDo  : Int64;
    Start      : TDateTime;
    {  The OnTerminate Event isn't used.  There is issue of Thread Syncronizing
       when Thread is run in an Active X control.
     The thread Execute function will set these variables after execution of the Copy.

     And the App will Querry the ThState From the Main Thread.
      i.e. ThCopyMessage and the ThCopyStatus to determine if the copy was succesfull }
    ThFileAndSize : string;
    ThMessage : string;
    ThStatus  : integer;  {this is 0 for success  it sometimes is the GetLastError value,  sometimes not}
    ThState       : integer;  // 2 = Starting,  1 = running , 0  = finished
    constructor Create(Src, Dest: String; blockType : integer = 0);
    function FormatByteSize(const bytes: Longint): string;
  private
    { Private declarations }
    srcFile,destFile : String;

    function GetFileSize(fileName: wideString): Int64;
  protected
    procedure Execute; override;
  end;

 type
  TThreadDelete = class(TThread)
  public
    Start      : TDateTime;
    LastDeleteStatus : integer;
    LastDeleteMessage : string;
    constructor Create(DelFile: String);
  private
    { Private declarations }
    FileToDelete : String;
  protected
    procedure Execute; override;
  end;

implementation

{ TCopyFile }
constructor TThreadCopyFile.Create(Src, Dest: String ; blockType : integer = 0);
begin
  srcFile := Src;
  destFile := Dest;

  Percent := 0;
  Start := Now;
  Block := 0;
  BlockSize := blockType;
  Done := 0;

  ThState := 2;
  { was True,  but now that we are checking the ThState variable,  we will Free when
    we read the ThState of 0=finished}
  FreeOnTerminate := False ;
  inherited Create(True);
end;

procedure TThreadCopyFile.Execute;
var
  fsSrc,fsDest : TFileStream;
  fsize,did    : int64;
  cnt,max      : Int64;
Begin
 try

{ LastCopyStatus is sometimes set to value of  GetLastError }
{we set to -99 for error, and message if other situations occur}
 ThState := 1;
 ThStatus := -99 ;
 ThMessage := 'File: ' + srcFile + ' copy in progress...'  ;
 ThFileAndSize := srcfile ;

           {$define zzPreCopyChecks}
           // These three checks are done by App calling threadcopy.  .. but leave here for later.
           {$ifdef PreCopyChecks}
           if NOT FileExists(srcFile)
             then
               begin
               LastCopyMessage := 'Error - Source File: ' + srcFile + ' Does Not Exist.';
               exit;
               end;
            fsize := GetFileSize(srcFile);
            LastCopyFileAndSize := srcfile + '  Size: ' + FormatByteSize(fsize) ;
            if fsize = 0  then
               begin
               LastCopyMessage := 'Error - Source File: ' + srcFile + '  Size 0 bytes';
               exit;
               end;
            if FileExists(destFile)
             then
               begin
               LastCopyMessage := 'Error - Destination File: ' + destFile + ' Already Exists.';
               exit;
               end;
           {$endif}
 try
     (*  web search .. fmShareDenyNone  to allow TFileStream to read 'Open Files' .   *)
     //   fsSrc := TFileStream.Create( srcFile, fmOpenRead );
     fsSrc := TFileStream.Create( srcFile, fmShareDenyNone);
     try
       //fsDest := TFileStream.Create( destFile, fmOpenWrite or fmCreate );
       fsDest := TFileStream.Create( destFile, fmCreate );

       try


      cnt:= fsDest.Position;
      fsSrc.Position := cnt;
      max := fsSrc.Size;
      Done := 0;

      { start copying }
      Repeat
       if blockSize = 0
          then  block := MB1
          else  block := max ;              // Block size
       if (cnt + block) > max then block := max-cnt;
       {$I-}
       //////  fsDest.CopyFrom(fsSrc, fsSrc.Size ) ;
       if block > 0 then did := fsDest.CopyFrom(fsSrc, block);
       {$I+}
        cnt := cnt + did;
        if (cnt > 0)
           then Percent := Round(Cnt/Max*100);
        Done := Done+did;
        ToDo := Max - done;
        until (ToDo = 0) or (Terminated);

        ThStatus := GetLastError;
         ThMessage := SysErrorMessage(ThStatus);


       finally
         fsDest.Free;
       end;
     finally
       fsSrc.Free;
     end;
    if (ThStatus <> 0)
       then exit;

    // this is one way.   copy all at once.
    {with the vast majority of our files being small..  a block copy of 1Mb
       would only take 1 block... .but we have Block copy as an Option.
        may use in Capture}

     {LastCopyStatus was set to GetLastError after the CopyFrom call.
      if it wasn't 0 (success)  we won't get here.}
     if NOT FileExists(destFile) then
       begin
         ThStatus := -99;
         ThMessage := 'Error - File: ' + srcFile + ' not copied';
         exit;
       end;
     if GetFileSize(destFile) = 0 then
       begin
         ThStatus := -99;
         ThMessage := 'Error - Destination File: ' + destFile + '  Size 0 bytes';
         exit;
       end;
 except
  on e:exception do
    begin
    {Google info states that not all TFileStream procedures SetLastError... so GetLastError may be
      0 (success) when we get an Exception.   So check for that.}
    ThStatus := GetLastError;
    if ThStatus = 0  then ThStatus := -99;
    ThMessage := e.Message;
    end;
 end;
 finally
 thState := 0;
 end;
End;


function TThreadCopyFile.GetFileSize(fileName : wideString) : Int64;
 var   sr : TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr ) = 0
  then  result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else      result := -1;
  FindClose(sr) ;
end;


function TThreadCopyFile.FormatByteSize(const bytes: Longint): string;
 const
 B = 1;//byte
 KB = 1024 * B; //kilobyte
 MB = 1024 * KB; //megabyte
 GB = 1024 * MB; //gigabyte
 begin   if bytes > GB
   then result := FormatFloat('#.## GB', bytes / GB)
   else  if bytes > MB
     then  result := FormatFloat('#.## MB', bytes / MB)
     else  if bytes > KB
        then  result := FormatFloat('#.## KB', bytes / KB)
        else  result := FormatFloat('#.## bytes', bytes) ;
     end;

  { ======================================= ===================== ===========}

{ TThreadDelete }

constructor TThreadDelete.Create(DelFile: String);
begin
  Start := Now;
  FileToDelete := Delfile;
  FreeOnTerminate := False;      //debug// was True;
  inherited Create(True);
end;

procedure TThreadDelete.Execute;
 var res : boolean;
begin
try
   res := DeleteFile(FileToDelete);
    if not res then
      begin
        LastDeletestatus := getlasterror;
        lastdeletemessage := syserrormessage(lastdeletestatus);
      end
    else
      begin
      lastdeletestatus := 0;
      lastdeletemessage := 'Deleted';
      end;
except
 on e:exception do
   begin
     lastDeleteStatus := -99;
     lastDeletemessage := e.Message;
   end;
end;


end;

end.
