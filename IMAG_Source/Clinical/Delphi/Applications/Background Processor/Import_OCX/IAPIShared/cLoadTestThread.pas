Unit cLoadTestThread;
{
  Package: EKG Display
  Date Created: 07/15/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  Description: A thread to load MUSE tests asynchronously
}
Interface

Uses
  Classes,
  cMuseTest,
  Syncobjs
  ;

//Uses Vetted 20090929:Sysutils, dMuseConnection, contnrs,

Type
  TLoadTestThread = Class(TThread)
  Private
    EvtLoaded: TEvent;
    LoadList: TThreadList;
    CurrentTest: TMuseTest;

    Procedure HandleLoadEvent();
//    procedure ReOrderList();

  Protected
    Procedure Execute(); Override;
  Public
    Constructor Create(CreateSuspended: Boolean);
    Destructor Destroy(); Override;
    Procedure Load(Test: TMuseTest);
    Procedure Clear();
  End;

Implementation

{ TLoadTestThread }

Constructor TLoadTestThread.Create(CreateSuspended: Boolean);
// initialization
Begin
  Inherited Create(CreateSuspended);
//  AssignFile(ThreadingLogFile, 'thread.log');
//  Rewrite(ThreadingLogFile);
  EvtLoaded := TEvent.Create(Nil, False, False, 'TestLoadedEvent');
  LoadList := TThreadList.Create();
  LoadList.Duplicates := DupIgnore;
End;

Destructor TLoadTestThread.Destroy();
Begin
//  CloseFile(ThreadingLogFile);
  Inherited;
End;

Procedure TLoadTestThread.Execute();
// loop while not terminated and load tests
Var
  List: Tlist;
  Count: Integer;
Begin
  While Not Terminated Do
  Begin
    EvtLoaded.ResetEvent();
    //Writeln(ThreadingLogFile, 'LoadTestThread: Locking List');

    List := LoadList.LockList();
    //Writeln(ThreadingLogFile, 'LoadTestThread: ListLocked');

    Count := List.Count;
    If Count = 0 Then
    Begin
      // suspend if there is nothing to load
      CurrentTest := Nil;
      LoadList.UnlockList;
      //Writeln(ThreadingLogFile, 'LoadTestThread: List Unlocked');

      EvtLoaded.SetEvent();
      //Writeln(ThreadingLogFile, 'LoadTestThread: Suspending');

      Suspend();
    End
    Else
    Begin
      CurrentTest := TMuseTest(List[0]);
      LoadList.Remove(CurrentTest);
      LoadList.UnlockList();
      CurrentTest.Load();
      // call the OnLoad event if it has been assigned
      If Assigned(CurrentTest.OnLoad) Then
        Synchronize(HandleLoadEvent);
      CurrentTest := Nil;
      EvtLoaded.SetEvent();
    End;
  End;
  EvtLoaded.SetEvent();
End;

Procedure TLoadTestThread.Load(Test: TMuseTest);
// other objects call this to put tests in the queue for loading
Begin
  If (Not Test.Loaded) Then
  Begin
    //Writeln(ThreadingLogFile, 'Main Thread: Adding Test');

    LoadList.Add(Test);
    //ReOrderList();
  End;
  // if the thread is sleeping, wake it up
  //Writeln(ThreadingLogFile, 'Main Thread: Resuming LoadTestThread');
  Resume();
End;
{
procedure TLoadTestThread.ReOrderList();
// reorder the list so the visible ones load first
var
  List, TempList: TList;
  i: integer;
  Test: TMuseTest;
begin
  List := LoadList.LockList();
  TempList := TList.Create();
  // first remove all the deselected ones
  // skip the first one because it might be currently loading
  for i := List.Count - 1 downto 1 do
  begin
    Test := TMuseTest(List[i]);
    if (Test.Parent = nil) then
    begin
      List.Remove(Test);
      TempList.Add(Test);
    end;
  end;
  // Now add them back in at the end
  for i := TempList.Count - 1 downto 1 do
  begin
    Test := TMuseTest(TempList[i]);
    TempList.Remove(Test);
    List.Add(Test);
  end;
  LoadList.UnlockList();
  TempList.Free();
end;
}

Procedure TLoadTestThread.HandleLoadEvent();
Begin
  //Writeln(ThreadingLogFile, 'Synchronized: Handling Load Event');
  CurrentTest.OnLoad(CurrentTest);
  //Writeln(ThreadingLogFile, 'Synchronized: Load Event Conpleted');
End;

Procedure TLoadTestThread.Clear();
Var
  List: Tlist;
Begin
  List := LoadList.LockList();
  List.Clear();
  // if one is currently being loaded, wait for it to finish before returning
  If (CurrentTest <> Nil) Then
  Begin

    If Not Terminated Then Resume(); // JMW 6/15/2005 p45t3 fixes bug
    LoadList.UnlockList();
//    evtLoaded.WaitFor(10000); // JMW p45t3 6/15/2005 REMOVED
  End
  Else
    LoadList.UnlockList();
End;

End.
