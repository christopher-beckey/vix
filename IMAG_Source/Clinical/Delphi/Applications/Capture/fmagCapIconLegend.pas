Unit FmagCapIconLegend;

Interface

Uses
  Buttons,
  ComCtrls,
  ExtCtrls,
  Forms,
  Stdctrls,
  ValEdit,
  Controls,
  Grids,
  Graphics,
  Classes

,   ImagDMinterface  //RCA
  ;

//Uses Vetted 20090929:Grids, Dialogs, Controls, Graphics, Variants, SysUtils, Messages, Windows, Classes

Type
  TfrmCapIconLegend = Class(TForm)
    PageControl1: TPageControl;
    TbshImport: TTabSheet;
    TbshNoteList: TTabSheet;
    ImgNoteNoText: TImage;
    ImgBPlate2: TImage;
    ImgNoteText: TImage;
    ImgComplete: TImage;
    ImgUnSigned: TImage;
    ImgAddendum: TImage;
    ImgNewNote: TImage;
    LbNoteNoText: Tlabel;
    LbBPlate: Tlabel;
    LbNoteText: Tlabel;
    LbComplete: Tlabel;
    LbUnSigned: Tlabel;
    LbNewNote: Tlabel;
    LbAddendum: Tlabel;
    ImgGreenArrow: TImage;
    Imgwarn: TImage;
    ImgSkip: TImage;
    LbGreenArrow: Tlabel;
    LbWarn: Tlabel;
    LbSkip: Tlabel;
    ImgBPlate: TImage;
    btnOK: TBitBtn;
    TbshGeneral: TTabSheet;
    ImgImagingCamera: TImage;
    ImgImage: TImage;
    LbImagingCamera: Tlabel;
    LbImage: Tlabel;
    ImgHoldValue: TImage;
    LbHoldValue: Tlabel;
    ImgMessageHistory: TImage;
    LbMessageHistory: Tlabel;
    LbAsterisk: Tlabel;
    ImgAsterisk: Tlabel;
    ImgDirectory: TImage;
    ImgdblDown: TImage;
    LbDirectory: Tlabel;
    Lbdblarrow: Tlabel;
    ImgdblUpLDesc: TImage;
    ImgdbldownLDesc: TImage;
    LbLDesc: Tlabel;
    ImgdblUp: TImage;
    ImgRemoveDblUp: TImage;
    ImgRemoveUp: TImage;
    ImgMoveDown: TImage;
    ImgMoveDblDown: TImage;
    LbRemove: Tlabel;
    LbMove: Tlabel;
    ImgEfile: TImage;
    LbEfile: Tlabel;
    TbshShortCutKeys: TTabSheet;
    ValueListEditor1: TValueListEditor;
    btnPrint: TBitBtn;
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure btnPrintClick(Sender: Tobject);
    Procedure PageControl1Change(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FrmCapIconLegend: TfrmCapIconLegend;

Implementation

(*   RCA dmsingle OUT

Uses
  //DmSingle
  ;
*)

{$R *.dfm}

Procedure TfrmCapIconLegend.btnOKClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmCapIconLegend.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  action := caFree;
End;

Procedure TfrmCapIconLegend.btnPrintClick(Sender: Tobject);
Var
  t: TStrings;
  i: Integer;
Begin
  Try
 { DONE : check this.... we shouldn't be creating T,  if we use it to refernece an existing Tstrings. }
   // t := Tstringlist.Create;     //129t17 out
    t := ValueListEditor1.Strings;
    For i := 0 To t.Count - 1 Do
    Begin
      If Copy(t[i], 1, 2) = ' =' Then
        t[i] := '                    ' + Copy(t[i], 3, 99);
    End;
    // RCA  dmod  out,    idmodObj  in
    iDModObj.GetMagUtilsDB1.ImageTextFilePrint(Nil, t, 'VI Display ShortCut Keys');
  Finally
  //t.free;  Causing AccessViolations ?
  End;
End;

Procedure TfrmCapIconLegend.PageControl1Change(Sender: Tobject);
Begin
  btnPrint.Enabled := (PageControl1.ActivePage = TbshShortCutKeys);
End;

End.
