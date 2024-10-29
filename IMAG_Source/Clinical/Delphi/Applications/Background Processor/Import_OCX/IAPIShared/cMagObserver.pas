unit cMagObserver;

interface

uses
  SysUtils, Classes, Dialogs,
  {Imaging}
   ImagInterfaces
   ;

type
  TMagObserver = class;
          {       The Update event}
  TObserverUpdateEvent = procedure(sender: TMagObserver; state : string) of Object;
  TMagObserver = class(TComponent, ImagObserver)
  private
    FSubject : ImagSubject;
 //   FMySubjectNames : Tstrings;
    FObserverUpdate : TObserverUpdateEvent;
   // procedure SetSubjectNames(Value: TStrings);

    procedure SetSubject(const Value: ImagSubject);
  protected
    { Protected declarations }
  public
    procedure Detach;

     procedure Update_(SubjectState: string;  sender : TObject);   //newstate : string; sender : TObject

    {   At Runtime the Application can attach this observer to any subject.
        Then the App writes an OnUpdateEvent Handler.}
    procedure AttachToSubject(Subj: IMagSubject);

    constructor create(AOwner: Tcomponent); override;
    destructor destroy; override;

  published
   property OnObserverUpdate: TObserverUpdateEvent read FObserverUpdate write FObserverUpdate;
   property Subject : ImagSubject read FSubject write SetSubject;
 //  property SubjectNames : TStrings Read FMySubjectNames write SetSubjectNames;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Imaging', [TMagObserver]);
end;

{ TMagObserver }

procedure TMagObserver.AttachToSubject(Subj: IMagSubject);
begin
  if FSubject <> nil then  FSubject.Detach_(self);
  FSubject := Subj;
  if Subj <> nil then FSubject.Attach_(self);
end;

constructor TMagObserver.create(AOwner: Tcomponent);
begin
  inherited;
//from custommemo  FLines := TMemoStrings.Create;


  //
end;

destructor TMagObserver.destroy;
begin
  if assigned(Fsubject) and (Fsubject <> nil) then
    begin
    FSubject.Detach_(self);
    FSubject := nil;
    end;
  inherited destroy;
end;

procedure TMagObserver.Detach;
begin
  if assigned(Fsubject) and (Fsubject <> nil) then
    begin
    FSubject.Detach_(self);
    FSubject := nil;
    end;
end;

procedure TMagObserver.SetSubject(const Value: ImagSubject);
begin
  FSubject := Value;
  AttachToSubject(FSubject);
end;

(*procedure TMagObserver.SetSubjectNames(Value: TStrings);
begin
  FMySubjectNames.Assign(Value);
end;
 *)
procedure TMagObserver.Update_(SubjectState: string;  sender : TObject);
   {    subjectState can be '', '-1'  or  '1' }
begin
  try
   if ( SubjectState <> '') then
        {       if Subject is being destroyed. Clear Pointer.}
        if (SubjectState = '-1') then FSubject := nil

        {       Subject has value, fire the event.}
   else if assigned(OnObserverUpdate) then OnObserverUpdate(self,SubjectState);
   if assigned(FObserverUpdate) then  OnObserverUpdate(self,SubjectState);
//   if FObserverUpdate <> nil then OnObserverUpdate(self,SubjectState);
  except
    on e: exception do
      showmessage('Exception in IMagObserver Update_' + e.message);
  end;
end;

end.
