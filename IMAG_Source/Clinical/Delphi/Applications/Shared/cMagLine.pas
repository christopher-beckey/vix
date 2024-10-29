unit cMagLine;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: April 2013
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: Line used for drawing scout lines on images
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface

uses Windows, Classes, Controls, Graphics, StdCtrls, Math;

type
  TMagLine = class(TGraphicControl)
  private
    FAlignment: TAlignment;
    FAngle: Integer;
    FAutoAngle: Boolean;
    FLayout: TTextLayout;
    FPen: TPen;
    function DiagonalAngle: Integer;
    function GetBackwards: Boolean;
    function GetExtends(LimitWidth, LimitHeight: Integer): TRect;
    procedure PenChanged(Sender: TObject);
    procedure SetAlignment(Value: TAlignment);
    procedure SetAngle(Value: Integer);
    procedure SetAutoAngle(Value: Boolean);
    procedure SetBackwards(Value: Boolean);
    procedure SetLayout(Value: TTextLayout);
    procedure SetPen(Value: TPen);
  protected
    procedure AdjustSize; override;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taCenter;
    property Anchors;
    property Angle: Integer read FAngle write SetAngle;
    property AutoAngle: Boolean read FAutoAngle write SetAutoAngle
      default True;
    property AutoSize;
    property Backwards: Boolean read GetBackwards write SetBackwards
      stored False;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Layout: TTextLayout read FLayout write SetLayout default tlCenter;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property ParentShowHint;
    property Pen: TPen read FPen write SetPen;
    property ShowHint;
    property Visible;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Imaging', [TMagLine]);
end;

{ TMagLine }

procedure TMagLine.AdjustSize;
begin
  if AutoSize then
    FAutoAngle := False;
  inherited AdjustSize;
end;

function TMagLine.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  with GetExtends(NewWidth, NewHeight) do
  begin
    NewWidth := Right;
    NewHeight := Bottom;
  end;
  Result := True;
end;

constructor TMagLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 65;
  Height := 65;
  FPen := TPen.Create;
  FPen.OnChange := PenChanged;
  FAlignment := taCenter;
  FLayout := tlCenter;
  FAutoAngle := True;
end;

destructor TMagLine.Destroy;
begin
  FPen.Free;
  inherited Destroy;
end;

function TMagLine.DiagonalAngle: Integer;
begin
  if Width = FPen.Width then
    Result := 90
  else if Height = FPen.Width then
    Result := 0
  else
    if Backwards then
      Result := 180 - Round(RadToDeg(ArcTan(Height / Width)))
    else
      Result := Round(RadToDeg(ArcTan(Height / Width)));
end;

function TMagLine.GetBackwards: Boolean;
begin
  Result := FAngle > 90;
end;

function TMagLine.GetExtends(LimitWidth, LimitHeight: Integer): TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  if FAngle = 0 then
  begin
    Result.Right := LimitWidth;
    Result.Bottom := FPen.Width;
  end
  else if FAngle = 90 then
  begin
    Result.Right := FPen.Width;
    Result.Bottom := LimitHeight;
  end
  else
  begin
    Result.Right := Min(LimitWidth,
      Round(LimitHeight / Abs(Tan(DegToRad(FAngle)))));
    Result.Bottom := Min(LimitHeight,
      Round(LimitWidth * Abs(Tan(DegToRad(FAngle)))));
  end;
end;

procedure TMagLine.Paint;
var
  R: TRect;
begin
  Canvas.Pen.Assign(FPen);
  Canvas.Brush.Style := bsClear;
  R := GetExtends(Width, Height);
  case FAlignment of
    taCenter:
      OffsetRect(R, (Width - R.Right) div 2, 0);
    taRightJustify:
      OffsetRect(R, Width - R.Right, 0);
  end;
  case FLayout of
    tlCenter:
      OffsetRect(R, 0, (Height - R.Bottom) div 2);
    tlBottom:
      OffsetRect(R, 0, Height - R.Bottom);
  end;
  if FAngle = 0 then
  begin
    Canvas.MoveTo(R.Left, R.Top + FPen.Width div 2);
    Canvas.LineTo(R.Right, R.Top + FPen.Width div 2);
  end
  else if FAngle = 90 then
  begin
    Canvas.MoveTo(R.Left + FPen.Width div 2, R.Top);
    Canvas.LineTo(R.Left + FPen.Width div 2, R.Bottom);
  end
  else if FAngle < 90 then
  begin
    Canvas.MoveTo(R.Left, R.Bottom);
    Canvas.LineTo(R.Right, R.Top);
  end
  else
  begin
    Canvas.MoveTo(R.Left, R.Top);
    Canvas.LineTo(R.Right, R.Bottom);
  end;
end;

procedure TMagLine.PenChanged(Sender: TObject);
begin
  AdjustSize;
  Invalidate;
end;

procedure TMagLine.Resize;
begin
  if FAutoAngle then
    Angle := DiagonalAngle;
  inherited Resize;
end;

procedure TMagLine.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TMagLine.SetAngle(Value: Integer);
begin
  while Value < 0 do
    Inc(Value, 180);
  while Value >= 180 do
    Dec(Value, 180);
  if FAngle <> Value then
  begin
    FAngle := Value;
    if FAngle <> DiagonalAngle then
      FAutoAngle := False;
    if AutoSize then
      AdjustSize;
    Invalidate;
  end;
end;

procedure TMagLine.SetAutoAngle(Value: Boolean);
begin
  if FAutoAngle <> Value then
  begin
    FAutoAngle := Value;
    if FAutoAngle then
    begin
      AutoSize := False;
      Angle := DiagonalAngle;
    end;
  end;
end;

procedure TMagLine.SetBackwards(Value: Boolean);
begin
  if Backwards <> Value then
    Angle := 180 - FAngle;
end;

procedure TMagLine.SetLayout(Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TMagLine.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

end.
