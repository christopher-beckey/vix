unit cMagAnnotXMLControlsDisplay;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
  Date Created: June 2011
  Site Name: Silver Spring, OIFO
  Developers: Duc Nguyen
  [==    unit cMagAnnotXMLControlsDisplay   COPY OF cMagXMLControls;
  will handle XML processing for saving and loading annotation.
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
interface

uses
  Dialogs, XMLDoc, XMLIntf, XMLDom, SysUtils, Classes, uMagUtils8
  , imaginterfaces
  , Contnrs
  ;

type
  {/p122 dmmn 8/18/11 - new structure to store VistA RAD XML /}

  {/p122 dmmn - store each element of vista rad annotation /}
  TRADElement = class (TObject)
  private
    FElemType : string;
    FElemPoints : string;
    FElemText : string;

  public
    property RADElementType : string read FElemType write FElemType;
    property RADElementPoints : string read FElemPoints write FElemPoints;
    property RADElementText : string read FElemText write FElemText;
  end;

  TRADElementsList = class (TObjectList)
  private
    function GetRADElement(Idx: Integer): TRADElement;
    procedure SetRADElement(Idx: Integer; const Value: TRADElement);

  public
    function Add(radElem: TRADElement): Integer;
    function GetElementType(Idx: Integer) : string;
    function GetElementPoints(Idx : Integer) : string;
    function GetElementText(Idx : Integer) : string;

    property Items[Idx: Integer]: TRADElement read GetRADElement write SetRADElement; default;
  end;

  {/----/}
  TXMLCtl = class
    DocCurrentSession : IXMLDocument;
    DocHistoryView : IXMLDocument;
    
    DocRAD : IXMLDocument;
    RADelems : TRADElementsList;

    FAnnotationDir : string;
    FFileName : string;

    FCurrentPageNumber: Integer;
    FTotalPageCount: Integer;

    FService : string;
    FUsername : string;
    FImageIEN : string;
    FResulted : string;
    {/P122 DMMN 6/28/2011 - add extra field to be store in the xml /}
    FUserDUZ : string;
    FPrimeSiteStationNumber : string;

    FTotalMarksCount : integer; //p122 dmmn 6/29 - add total count per image for display
  private
    procedure SaveXMLToFile(fileName : String; XMLDoc : IXMLDocument);
 //Was for RCA decouple magmsg, not now.       procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
  public
    constructor Create(Dir : string);
    destructor Destroy;  override;

    Procedure InitSessionInfo(PageCount : Integer; iIEN, annotator, service, resulted,UserDUZ,PrimeSiteNum : string);
    Procedure UpdateSessionInfo(iIEN, annotator, service, resulted, userDUZ, PrimeSiteNum : string);

    Procedure CreateCurrentHistory(Reset: Boolean);
    Procedure ClearSession;

    Procedure LoadCurrentHistoryLayer(xmlLayer : string);
    Procedure LoadHistoryView(xmlLayer : string);

    procedure LoadCurrentHistoryToArtPage(pageNum: Integer);  overload;
    procedure LoadCurrentHistoryToArtPage(PN : string; pageNum: Integer);  overload; //p122t4 dmmn 9/29

    Procedure LoadHistoryToArtPage(pageNum : Integer);   overload;
    procedure LoadHistoryToArtPage(PN : string; pageNum : Integer); overload; //p122t4 dmmn 9/29
    
    Procedure LoadRADAnnotation(radXML : string);
    Procedure ClearRADAnnotation();
    
    Function GetRADAnnotationCount : integer; // return the number of rad annotation

    Function SaveCurrentHistoryToDB : string; overload;
    Function SaveCurrentHistoryToDB(var annotXMLPath : string): string; overload;

    Procedure SaveCurrentHistoryTemporary(filename: string); //p122 dmmn 7/25

    function SaveHistoryXML: String; overload;
    Procedure SaveHistoryXML(var annotXMLPath : string); overload;
    
    Procedure SaveArtPageToHistory(filename : string; pageNum : Integer; markCount : integer);

    Function ContainsRADEllipseAndFreeHand : Boolean;
    function SelectNode(xmlRoot: IXmlNode; const nodePath: WideString): IXmlNode;
    function  SelectNodes(xnRoot: IXmlNode; const nodePath: WideString): IXMLNodeList;

    procedure UpdateCapImageIEN(newMagIEN : string);

  published
    property AnnotDir : string read FAnnotationDir write FAnnotationDir;
    property CurrentPage : integer read FCurrentPageNumber write FCurrentPageNumber;
    property TotalPageCount : integer read FTotalPageCount write FTotalPageCount;
  end;
implementation

uses
  UMagDefinitions;  {/ P122 JK 8/29/2011 /}

{ TXMLCtl }


procedure TXMLCtl.ClearRADAnnotation;
begin
  {/p122t4 clear old annotation /}
  DocRAD := nil;
  DocRad := TXMLDocument.Create(nil);
end;

procedure TXMLCtl.ClearSession;
begin
  DocCurrentSession := nil;
  DocHistoryView := nil;
  DocRAD := nil;
  TotalPageCount := 0;
  CurrentPage := 0;

  DocCurrentSession := TXMLDocument.Create(nil);
  DocHistoryView := TXMLDocument.Create(nil);
  DocRAD := TXMLDocument.Create(nil);
end;

function TXMLCtl.ContainsRADEllipseAndFreeHand: Boolean;
var
  elements : IXMLNodeList;
  element : IXMLNode;
  I : integer;
begin
  {/P122 DMMN 6/21/2011 Check if the loaded annotation xml from VistaRAD contain
  marks that cannot be translated correctly /}

  Result := False;

  if DocRAD = nil then Exit;

  DocRad.Active := True;
  elements := SelectNodes(DocRad.DocumentElement,
                          '/PState/Elements/Element');

  // JK 9/26/2011 - Nil check
  if Elements = nil then
    Exit;

  for I:=0 to elements.Count-1 do
  begin
    element := elements[I];
    if (element.Attributes['type'] = '18') or      // Hounsfield Ellipse
       (element.Attributes['type'] = '20') or      // Hounsfield Freehand
       (element.Attributes['type'] = '29') or      // Ellipse
       (element.Attributes['type'] = '31') then    // Freehand
    begin
      Result := True;
      Exit;
    end;
  end;
end;

constructor TXMLCtl.Create(Dir : string);
begin
  {/P122 DMMN 6/21/2011 Create the controler for manipulating XML files /}
  FAnnotationDir := Dir;

  DocCurrentSession := TXMLDocument.Create(nil);
  DocHistoryView := TXMLDocument.Create(nil);

  DocRAD := TXMLDocument.Create(nil);
  RADelems := TRADElementsList.Create(True); {/p122 dmmn 8/17 - new structure that will hold the radiology xml /}
end;

procedure TXMLCtl.CreateCurrentHistory(Reset: Boolean);
var
  root : IXMLNode;
  page : IXMLNode;
  I: Integer;
begin
  FTotalMarksCount := 0;  // dmmn 6/29

  if Reset then
  begin
    DocCurrentSession.Active := False;
    DocCurrentSession := nil; //p122 dmmn 8/17 - reset the session for radiology viewer
    DocCurrentSession := TXMLDocument.Create(nil);
  end;
  DocCurrentSession.Active := True;
  root := DocCurrentSession.AddChild('History');
  root.Attributes['imageIEN'] := FImageIEN;
  root.Attributes['annotator'] := FUsername;
  {/P122 DMMN 6/28/2011 - added extra fields to be used to ID the annotation /}
  root.Attributes['userDUZ'] := FUserDUZ;
  root.Attributes['primesitenumber'] := FPrimeSiteStationNumber;
  root.Attributes['service'] := FService;
  root.Attributes['resulted'] := FResulted;
  root.Attributes['totalmarks'] := IntToStr(FTotalMarksCount); // 6/29
  root.Attributes['version'] := 'IG16.2.11';

  for I := 0 to TotalPageCount - 1 do
  begin
    page := root.AddChild('Page');
    page.Attributes['number'] := IntToStr(I);
    page.Attributes['marks'] := '0';
  end;

end;

destructor TXMLCtl.Destroy;
{/P122 Clean up }
begin
  DocCurrentSession := nil;
  DocHistoryView := nil;

  DocRAD := nil;
  
  FreeAndNil(RADelems);
end;

procedure TXMLCtl.InitSessionInfo(PageCount : Integer; iIEN, annotator, service, resulted, UserDUZ, PrimeSiteNum: string);
{/P122 This method will initialize the current information of the annotation session
to store in the history file }
begin
  TotalPageCount := PageCount;

  FImageIEN := iIEN;
  FUsername := annotator;
  FService := service;
  FResulted := resulted;
  {/P122 DMMN 6/28/2011 - new extra fields /}
  FUserDUZ := UserDUZ;
  FPrimeSiteStationNumber := PrimeSiteNum;
end;

procedure TXMLCtl.LoadCurrentHistoryLayer(xmlLayer: string);
begin
  DocCurrentSession.Active := True;
  DocCurrentSession.loadFromXML(xmlLayer);
end;

procedure TXMLCtl.LoadHistoryView(xmlLayer: string);
begin
  DocHistoryView.Active := True;
  DocHistoryView.LoadFromXML(xmlLayer);
end;

procedure TXMLCtl.LoadCurrentHistoryToArtPage(pageNum: Integer);
{/P122 This method will load a page in the history file to the corresponding artpage }
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
  fName : string;
begin
  tempXML := TXMLDocument.Create(nil);
  try
    // Grab the artpage XML in the history file
    Anode := SelectNode(DocCurrentSession.DocumentElement,
                        '/History/Page[@number=' + IntToStr(pageNum) + ']');

    if Anode.HasChildNodes then
    begin
      Anode := Anode.ChildNodes[0];
    end;

    tempXML.Active := True;
    tempXML.ChildNodes.Insert(0, ANode);

//    fName := AnnotDir + UrnFix(FImageIEN) + '^PXML.xml';
    fName := AnnotDir + GSess.MagUrlMap.MapUrn(FImageIEN) + '^PXML.xml';  {JK 8/24/2011}
    SaveXMLToFile(fName, tempXML);
  finally
    tempXML := nil;
  end;
end;

procedure TXMLCtl.LoadCurrentHistoryToArtPage(PN : string; pageNum: Integer);
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
begin
  {/p122t4 dmmn 9/29 - overloaded method load the xml page into predetermined file /}
  tempXML := TXMLDocument.Create(nil);
  try
    // Grab the artpage XML in the history file
    Anode := SelectNode(DocCurrentSession.DocumentElement,
                        '/History/Page[@number=' + IntToStr(pageNum) + ']');

    if Anode.HasChildNodes then
    begin
      Anode := Anode.ChildNodes[0];
    end;

    tempXML.Active := True;
    tempXML.ChildNodes.Insert(0, ANode);

    SaveXMLToFile(PN, tempXML);
  finally
    tempXML := nil;
  end;
end;

procedure TXMLCtl.LoadHistoryToArtPage(pageNum: Integer);
{/P122 This method will load a page in the history file to the corresponding artpage }
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
  fName : string;
begin
  tempXML := TXMLDocument.Create(nil);
  try
    // Grab the artpage XML in the history file
//    DocHistoryView.SaveToFile('c:\dochistview.xml');
    Anode := SelectNode(DocHistoryView.DocumentElement,
                        '/History/Page[@number="' + IntToStr(PageNum) + '"]');

    if Anode = nil then
      Exit;

    if Anode.HasChildNodes then
    begin
      Anode := Anode.ChildNodes[0];
    end;

    tempXML.Active := True;
    tempXML.ChildNodes.Insert(0, ANode);

//    fName := AnnotDir + UrnFix(FImageIEN) + '^PXML.xml';
    fName := AnnotDir + GSess.MagUrlMap.MapUrn(FImageIEN) + '^PXML.xml'; {JK 8/24/2011}
    SaveXMLToFile(fName, tempXML);
  finally
    tempXML := nil;
  end;
end;

procedure TXMLCtl.LoadHistoryToArtPage(PN : string; pageNum : Integer);
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
begin
  {/p122t4 dmmn 9/29 - overloaded method load the xml page into predetermined file /}
  tempXML := TXMLDocument.Create(nil);
  try
    // Grab the artpage XML in the history file
    Anode := SelectNode(DocHistoryView.DocumentElement,
                        '/History/Page[@number="' + IntToStr(PageNum) + '"]');

    if Anode = nil then
      Exit;

    if Anode.HasChildNodes then
    begin
      Anode := Anode.ChildNodes[0];
    end;

    tempXML.Active := True;
    tempXML.ChildNodes.Insert(0, ANode);

    SaveXMLToFile(PN, tempXML);
  finally
    tempXML := nil;
  end;
end;

function TXMLCtl.GetRADAnnotationCount: integer;
var
  elements : IXMLNodeList;
begin
  try
    //p122 dmmn 8/9 - return the count of rad annotation
    result := 0;

    if DocRAD = nil then Exit;

    DocRad.Active := True;
    elements := SelectNodes(DocRad.DocumentElement,
                            '/PState/Elements/Element');
    //p122t3 dmmn 8/26 - nil check
    if elements <> nil then
      Result := elements.Count;
  except
    on E : Exception do
    begin
      Result := 0;
      magAppMsg('s','TXMLCtl.LoadRADAnnotation(radXML: string)');
      magAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
    end;
  end;
end;

procedure TXMLCtl.LoadRADAnnotation(radXML: string);
var
  RADElementsList : IXMLNodeList;
  I: Integer;
  RADelem: TRADElement;
  textNode : IXMLNode;
  text : string;
  J: Integer;
  StartElementNode : IXMLNode;
  ANode : IXMLNode;
  textpartNode : IXMLNode;
begin
  try
    DocRad.LoadFromXML(radXML);

    if RADelems.Count > 0 then
    begin
      FreeAndNil(RADelems);
      RADelems := TRADElementsList.Create(True);
    end;
    
    {/p122 dmmn 8/18 - parse the xml and store the rad annotations /}
    DocRad.Active := True;

    if DocRad.DocumentElement.ChildNodes.FindNode('Elements') <> nil  then
    begin
      StartElementNode := DocRad.DocumentElement.ChildNodes.FindNode('Elements').ChildNodes.First;
      ANode := StartElementNode;

      repeat
        RADelem := TRADElement.Create;
        RADelem.RADElementType := string(ANode.AttributeNodes.First.Text);
        RADelem.RADElementPoints := string(ANode.ChildNodes.FindNode('data').Text);

        text := '';
        // don't need to check text for some type;
        if (RADelem.RADElementType <> '24') and (RADelem.RADElementType <> '27') and
           (RADelem.RADElementType <> '28') and (RADelem.RADElementType <> '29') and
           (RADelem.RADElementType <> '31') then
        begin
          // go over all the <textpart> in <text> and get all the text out
          textNode := ANode.ChildNodes.FindNode('text');
          if textNode.ChildNodes.Count = 1 then          // single line
          begin
            textPartNode := textNode.ChildNodes.First;
            text := string(textpartNode.Text);
          end
          else if textNode.ChildNodes.Count > 1 then     // multi line
          begin
            textPartNode := textNode.ChildNodes.First;
            text := string(textpartNode.Text);
            textPartNode := textPartNode.NextSibling;
            while textPartNode <> nil do
            begin
              text := text + slinebreak + string(textpartNode.Text);
              textPartNode := textPartNode.NextSibling;
            end;
          end
          else // error or 0
            text := '';
        end;
        RADelem.RADElementText := text;

        RADelems.Add(RADelem);

        ANode := ANode.NextSibling;
      until ANode = nil;
    end;
  except
    on E : Exception do
    begin
      magAppMsg('s','TXMLCtl.LoadRADAnnotation');
      magAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
    end;
  end;
end;

procedure TXMLCtl.SaveArtPageToHistory(filename: string; pageNum : integer; markCount : integer);
{/P122 Save a single artpage XML generated by IG to HistoryFile }
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
begin
  tempXML := TXMLDocument.Create(nil);
  try
    // load the PXML
    tempXML.LoadFromFile(AnnotDir + filename);    {/p129 gek Error early 129 testing Cap annot.}
    tempXML.Active := True;

    // grab the artpage XML and insert to page  in AnnotHist
    PNode := SelectNode(DocCurrentSession.DocumentElement,
                        '/History/Page[@number=' + IntToStr(pageNum) + ']');
    PNode.Attributes['marks'] := IntToStr(markCount);

    FTotalMarksCount := FTotalMarksCount + markCount; //p122 dmmn 6/29
    DocCurrentSession.DocumentElement.Attributes['totalmarks'] := IntToStr(FTotalMarksCount);

    ANode := tempXML.DocumentElement.CloneNode(True);   // insert ARTDocument node to annot hist
//    PNode.ChildNodes.Insert(0, ANode);
    if (PNode.ChildNodes.Count > 0) then  //p122t2 dmmn 9/2 - if there already something there so delete it
      PNode.ChildNodes.Clear;
    PNode.ChildNodes.Add(ANode);
    
  finally
    tempXML := nil;
  end;
end;

procedure TXMLCtl.SaveCurrentHistoryTemporary(filename: string);
begin
  DocCurrentSession.SaveToFile(filename);
end;

function TXMLCtl.SaveCurrentHistoryToDB(var annotXMLPath: string): string;
var
  CurHist : string;
begin
  {/P122 DMMN 6/24/2011 - overload method return the filepath to the saved xml
  together with the xml /}
  DocCurrentSession.SaveToXML(CurHist);
  SaveHistoryXML(annotXMLPath);
  Result := CurHist;
end;

function TXMLCtl.SaveCurrentHistoryToDB : string;
var
  CurHist : string;
begin
  {/P122 DMMN - Allow two possible way to retrieve the xml code for the annotation session.
  One is return everything as a string and the other is save the xml into a file in
  a safe folder /}
  DocCurrentSession.SaveToXML(CurHist);
  // P122 6/28/2011 If want save to file then use the other overload method
  //  SaveHistoryXML;  // save to file
  Result := CurHist;
end;

procedure TXMLCtl.SaveHistoryXML(var annotXMLPath: string);
begin
  {/P122 DMMN 6/24/2011 - oveload method to return the path to the saved document /}
  annotXMLPath := FImageIEN + '.xml';

  SaveXMLToFile(annotXMLPath, DocCurrentSession);
  annotXMLPath := AnnotDir + annotXMLPath;
end;

function TXMLCtl.SaveHistoryXML: String;
{ Generate an annotation history file to be sent to VistA }
begin
  {/ P112 - JK 7/15/2011 - strip of the urn portion of a remote image view IEN /}
//  Result := AnnotDir + UrnFix(FImageIEN) + '.xml';
  //p122t4 dmmn 9/29/ - same naming format
  if isUrn(FImageIEN) then
    Result := AnnotDir + GSess.MagUrlMap.MapUrn(FImageIEN) + '.xml'  {JK 8/24/2011}
  else
    Result := AnnotDir + FImageIEN + '.xml';

  SaveXMLToFile(Result, DocCurrentSession);
end;

procedure TXMLCtl.SaveXMLToFile(fileName : String; XMLDoc : IXMLDocument);
{ Save and XML Document with proper format to the directory for annotations }
var
  pList : TStringList;
begin
  pList := TStringList.Create;
  try
    pList.Assign(XMLDoc.XML);
    if Pos('<?xml version="1.0"?>', XMLDoc.XML[0]) = 0 then
      pList.Insert(0, '<?xml version="1.0"?>');
    // fileName must not contain the path, just the name of the file
    pList.SaveToFile(fileName);
  finally
    pList.Free;
  end;
end;

procedure TXMLCtl.UpdateCapImageIEN(newMagIEN: string);
var
  tempNode : IXMLNode;
begin
  FImageIEN := newMagIEN;
  tempNode := SelectNode(DocCurrentSession.DocumentElement,'/History');
  tempNode.Attributes['imageIEN'] := newMagIEN;
end;

procedure TXMLCtl.UpdateSessionInfo(iIEN, annotator, service, resulted, userDUZ, PrimeSiteNum: string);
var
  tempNode : IXMLNode;
begin
  {/p122t4 dmmn 10/3 - update the information for the history layer before saving into vista /}
  FImageIEN := iIEN;
  FUsername := annotator;
  FService := service;
  FResulted := resulted;
  FUserDUZ := UserDUZ;
  FPrimeSiteStationNumber := PrimeSiteNum;

  tempNode := SelectNode(DocCurrentSession.DocumentElement,'/History');
  if tempNode = nil then
    Exit;

  tempNode.Attributes['imageIEN'] := iIEN;
  tempNode.Attributes['annotator'] := annotator;
  tempNode.Attributes['service'] := service;
  tempNode.Attributes['resulted'] := resulted;
  tempNode.Attributes['userDUZ'] := userDUZ;
  tempNode.Attributes['primesitenumber'] := PrimeSiteNum;
end;



{$REGION 'Parsing XML using XPath'}
function TXMLCtl.SelectNode(xmlRoot: IXmlNode; const nodePath: WideString): IXmlNode;
var
  nodeSelect : IDomNodeSelect;
  nodeResult : IDomNode;
  docAccess : IXmlDocumentAccess;
  xmlDoc: TXmlDocument;
begin
  Result := nil;
  if not Assigned(xmlRoot) or not Supports(xmlRoot.DOMNode, IDomNodeSelect, nodeSelect) then
    Exit;
  nodeResult := nodeSelect.selectNode(nodePath);

  if Assigned(nodeResult) then
  begin
    if Supports(xmlRoot.OwnerDocument, IXmlDocumentAccess, docAccess) then
      xmlDoc := docAccess.DocumentObject
    else
      xmlDoc := nil;
    Result := TXmlNode.Create(nodeResult, nil, xmlDoc);
  end;
end;

function TXMLCtl.SelectNodes(xnRoot: IXmlNode; const nodePath: WideString): IXMLNodeList;
var
  nodeSelect : IDomNodeSelect;
  intfAccess : IXmlNodeAccess;
  docAccess : IXmlDocumentAccess;
  xmlDoc: TXmlDocument;
  nodeListResult  : IDomNodeList;
  i : Integer;
  dn : IDomNode;
begin
  Result := nil;
  if not Assigned(xnRoot)
    or not Supports(xnRoot, IXmlNodeAccess, intfAccess)
    or not Supports(xnRoot.DOMNode, IDomNodeSelect, nodeSelect) then
    Exit;

  nodeListResult := nodeSelect.selectNodes(nodePath);
  if Assigned(nodeListResult) then
  begin
    Result := TXmlNodeList.Create(intfAccess.GetNodeObject, '', nil);
    if Supports(xnRoot.OwnerDocument, IXmlDocumentAccess, docAccess) then
      xmlDoc := docAccess.DocumentObject
    else
      xmlDoc := nil;

    for i := 0 to nodeListResult.length - 1 do
    begin
      dn := nodeListResult.item[i];
      Result.Add(TXmlNode.Create(dn, nil, xmlDoc));
    end;
  end;
end;

{$ENDREGION}

{$REGION 'new rad structure'}
{ TRADElementsList }

function TRADElementsList.Add(radElem: TRADElement): Integer;
begin
  Result := inherited Add(radElem);
end;

function TRADElementsList.GetElementPoints(Idx: Integer): string;
begin
  Result := (Items[Idx] as TRADElement).RADElementPoints;
end;

function TRADElementsList.GetElementText(Idx: Integer): string;
begin
  Result := (Items[Idx] as TRADElement).RADElementText;
end;

function TRADElementsList.GetElementType(Idx: Integer): string;
begin
  Result := (Items[Idx] as TRADElement).RADElementType;
end;

function TRADElementsList.GetRADElement(Idx: Integer): TRADElement;
begin
  Result := inherited Items[Idx] as TRADElement;
end;

procedure TRADElementsList.SetRADElement(Idx: Integer; const Value: TRADElement);
begin
  inherited Items[Idx] := Value;
end;

{$ENDREGION}

end.
