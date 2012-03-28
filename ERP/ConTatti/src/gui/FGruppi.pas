(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit FGruppi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBTables, DB, Grids, Outline, Buttons,
  DBGrids, JvComponentBase, JvFormPlacement;

type
  TfmGruppi = class(TForm)
    olSchema: TOutline;
    tbInGruppo: TTable;
    dsInGruppo: TDataSource;
    tbGruppi: TTable;
    dsGruppi: TDataSource;
    tbContat: TTable;
    dsContat: TDataSource;
    tbContatCodCon: TIntegerField;
    tbContatTipo: TIntegerField;
    tbContatNome_Tit: TStringField;
    tbContatNome_Pre1: TStringField;
    tbContatNome_Pre2: TStringField;
    tbContatNome_Main: TStringField;
    tbContatNome_Suf: TStringField;
    tbContatClasse: TStringField;
    tbContatSettore: TStringField;
    tbContatNote: TMemoField;
    tbGruppiCodGrp: TIntegerField;
    tbGruppiDesc: TStringField;
    tbInGruppoProg: TIntegerField;
    tbInGruppoCodCon: TIntegerField;
    tbInGruppoCodGrp: TIntegerField;
    lbChoice: TListBox;
    Label1: TLabel;
    btContatti: TBitBtn;
    btGruppi: TBitBtn;
    btSave: TBitBtn;
    btClose: TBitBtn;
    lbWhat: TLabel;
    fpGruppi: TJvFormPlacement;
    procedure olSchemaDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbChoiceDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure olSchemaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure olSchemaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure olSchemaDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbChoiceDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btContattiClick(Sender: TObject);
    procedure btGruppiClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
  private
    { Private declarations }
    FChanged: boolean;
    IsByGrp : boolean;
    procedure SetChanged(vl: boolean);
    property Changed: boolean read FChanged write SetChanged;
    procedure PrepareContatti;
    procedure PrepareGruppi;
    function GetRootNode(Itm: longint): TOutlineNode;
    function GetParent(X,Y: longint): TOutlineNode;
    function Confirm: boolean;
  public
    { Public declarations }
  end;

procedure Gruppi;

implementation

{$R *.DFM}

uses
  uOpzioni, ContComm;

procedure Gruppi;
var
  fmGruppi: TfmGruppi;
begin
  fmGruppi:= nil;
  try
    fmGruppi:= TfmGruppi.Create(nil);
    fmGruppi.ShowModal;
  finally
    fmGruppi.Free;
  end;
end;

procedure TfmGruppi.SetChanged(vl: boolean);
begin
  FChanged:= vl;
  if FChanged <> btSave.Enabled then begin
    btSave.Enabled:= FChanged;
  end;
end;


procedure TfmGruppi.PrepareContatti;
  function GetGruppo(CodGrp: longint): string;
  begin
    if tbGruppi.FindKey([CodGrp]) then Result:= tbGruppiDesc.Value
    else Result:= '';
  end;
  procedure PrepareChoice;
  begin
    lbChoice.Items.BeginUpdate;
    lbChoice.Clear;
    tbGruppi.IndexName:= 'IdxDesc';
    tbGruppi.Open;
    tbGruppi.First;
    while not tbGruppi.EOF do begin
      lbChoice.Items.AddObject(tbGruppiDesc.Value, pointer(tbGruppiCodGrp.Value));
      tbGruppi.Next;
    end;
    lbChoice.Items.EndUpdate;
    tbGruppi.Close;
  end;
  procedure PrepareSchema;
  var
    ID: longint;
    CodGrp: longint;
  begin
    olSchema.Clear;
    tbInGruppo.Close;
    tbContat.IndexName:= 'IdxNome';
    tbGruppi.IndexName:= '';
    tbInGruppo.IndexName   := 'CodCon';
    tbInGruppo.MasterSource:= dsContat;
    tbInGruppo.MasterFields:= 'CodCon';
    tbContat.Open;
    tbGruppi.Open;
    tbInGruppo.Open;
    tbContat.First;
    while not tbContat.EOF do begin
      ID:= olSchema.AddObject(0, _DecodeNome(tbContat), pointer(tbContatCodCon.Value));
      olSchema.BeginUpdate;
      tbInGruppo.First;
      while not tbInGruppo.EOF do begin
        CodGrp:= tbInGruppoCodGrp.Value;
        olSchema.AddChildObject(ID, GetGruppo(CodGrp), pointer(CodGrp));
        tbInGruppo.Next;
      end;
      olSchema.EndUpdate;
      olSchema.Items[ID].Expand;
      tbContat.Next;
    end;
    tbInGruppo.Close;
    tbGruppi.Close;
    tbContat.Close;
  end;
begin
  IsByGrp:= false;
  PrepareChoice;
  PrepareSchema;
end;

procedure TfmGruppi.PrepareGruppi;
  function GetContatto(CodCon: longint): string;
  begin
    if tbContat.FindKey([CodCon]) then Result:= _DecodeNome(tbContat)
    else Result:= '';
  end;
  procedure PrepareChoice;
  begin
    lbChoice.Items.BeginUpdate;
    lbChoice.Clear;
    tbContat.IndexName:= 'IdxNome';
    tbContat.Open;
    tbContat.First;
    while not tbContat.EOF do begin
      lbChoice.Items.AddObject(_DecodeNome(tbContat), pointer(tbContatCodCon.Value));
      tbContat.Next;
    end;
    tbContat.Close;
    lbChoice.Items.EndUpdate;
  end;
  procedure PrepareSchema;
  var
    ID: longint;
    CodCon: longint;
  begin
    olSchema.Clear;
    tbContat.IndexName:= '';
    tbGruppi.IndexName:= 'IdxDesc';
    tbInGruppo.Close;
    tbInGruppo.IndexName   := 'CodGrp';
    tbInGruppo.MasterFields:= 'CodGrp';
    tbInGruppo.MasterSource:= dsGruppi;
    tbContat.Open;
    tbGruppi.Open;
    tbInGruppo.Open;
    tbGruppi.First;
    while not tbGruppi.EOF do begin
      ID:= olSchema.AddObject(0, tbGruppiDesc.Value, pointer(tbGruppiCodGrp.Value));
      olSchema.BeginUpdate;
      tbInGruppo.First;
      while not tbInGruppo.EOF do begin
        CodCon:= tbInGruppoCodCon.Value;
        olSchema.AddChildObject(ID, GetContatto(CodCon), pointer(CodCon));
        tbInGruppo.Next;
      end;
      olSchema.EndUpdate;
      olSchema.Items[ID].Expand;
      tbGruppi.Next;
    end;
    tbInGruppo.Close;
    tbGruppi.Close;
    tbContat.Close;
  end;
begin
  IsByGrp:= true;
  PrepareChoice;
  PrepareSchema;
end;

function ExistLink(OL: TOutline; Nodo: TOutlineNode; Cod: pointer): boolean;
var
  Cur: longint;
begin
  Cur:= Nodo.GetFirstChild;
  Result:= false;
  while (Cur <> -1) do begin
    if OL.Items[Cur].Data = Cod then begin
      Result:= true;
      Cur:= -1;
    end
    else Cur:= Nodo.GetNextChild(Cur);
  end;
end;

function TfmGruppi.GetRootNode(Itm: longint): TOutlineNode;
begin
  Result:= nil;
  if itm > 0 then begin
    Result:= olSchema.Items[itm];
    if Result.Level > 0 then begin
      while Result.Level <> 1 do Result:= Result.Parent;
    end;
  end;
end;

function TfmGruppi.GetParent(X,Y: longint): TOutlineNode;
var
  Itm: longint;
begin
  itm:= olSchema.GetItem(X, Y);
  Result:= GetRootNode(Itm);
end;

procedure TfmGruppi.olSchemaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ps: integer;
begin
  ps:= olSchema.SelectedItem;
  if (ps <> -1) and (olSchema.Items[ps].Level > 1) then begin
    olSchema.BeginDrag(true);
  end;
end;

procedure TfmGruppi.olSchemaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  olSchema.EndDrag(true);
end;

procedure TfmGruppi.olSchemaDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  Nodo: TOutlineNode;
begin
  if (Source=lbChoice) then begin
    Accept:= true;
    Nodo:= GetParent(X, Y);
    if Nodo <> nil then olSchema.SelectedItem:= Nodo.Index;
  end
  else if (Source=olSchema) then begin
    Nodo:= olSchema.Items[olSchema.GetItem(X, Y)];
    Accept:= (not Nodo.HasItems) and (Nodo.Parent.Index=GetRootNode(olSchema.SelectedItem).Index);
  end;
end;

procedure TfmGruppi.lbChoiceDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:= (Source=olSchema);
end;

procedure TfmGruppi.olSchemaDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Nodo: TOutlineNode;
  CodSrc: longint;
  NeedExpand: boolean;
begin
  if Source = lbChoice then begin
    Nodo:= GetParent(X, Y);
    if Nodo = nil then exit;
(*
    CodDst:= longint(Nodo.Data);
*)
    CodSrc:= longint(lbChoice.Items.Objects[lbChoice.ItemIndex]);
    if not ExistLink(olSchema, Nodo, pointer(CodSrc)) then begin
      NeedExpand:= not Nodo.HasItems;
      olSchema.SelectedItem:= olSchema.AddChildObject(Nodo.Index, lbChoice.Items[lbChoice.ItemIndex], pointer(CodSrc));
      if NeedExpand then Nodo.Expand;
    end;
  end
  else begin
    olSchema.Items[olSchema.SelectedItem].MoveTo(olSchema.GetItem(X, Y), oaInsert);
  end;
  Changed:= true;
end;

procedure TfmGruppi.lbChoiceDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  OL: TOutline;
begin
  OL:= (Source as TOutline);
  OL.Delete(OL.SelectedItem);
  Changed:= true;
end;

procedure TfmGruppi.btContattiClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  if not Confirm then exit;
  lbWhat.Caption:= 'Gruppi disponibili';
  OldCursor:= Screen.Cursor;
  Screen.Cursor:= crHourGlass;
  PrepareContatti;
  Changed:= false;
  Screen.Cursor:= OldCursor;
end;

procedure TfmGruppi.btGruppiClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  if not Confirm then exit;
  lbWhat.Caption:= 'Contatti disponibili';
  OldCursor:= Screen.Cursor;
  Screen.Cursor:= crHourGlass;
  PrepareGruppi;
  Changed:= false;
  Screen.Cursor:= OldCursor;
end;

procedure TfmGruppi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Confirm then Abort;
end;

function TfmGruppi.Confirm: boolean;
begin
  Result:= (not Changed)
    or (MessageDlg('Vuoi abbandonare le modifiche effettuate?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TfmGruppi.FormShow(Sender: TObject);
begin
  Changed:= false;
  btGruppi.Click;
end;

procedure TfmGruppi.btSaveClick(Sender: TObject);
var
  Cur: integer;
  CodNod: longint;
  CodLea: longint;
  FldNod, FldLea: string;
begin
  if not Changed then exit;
  if IsByGrp then begin
    FldNod:= 'CodGrp';
    FldLea:= 'CodCon';
  end
  else begin
    FldNod:= 'CodCon';
    FldLea:= 'CodGrp';
  end;
  CodNod:= 0;
  Cur:= 1;
  try
    tbInGruppo.EmptyTable;
  except
    MessageDlg('Impossibile cancellare le associazioni ai gruppi precedenti', mtInformation, [mbOk], 0);
    exit;
  end;
  tbInGruppo.Open;
  while Cur <= olSchema.ItemCount do begin
    if olSchema.Items[Cur].HasItems then begin
      CodNod:= longint(olSchema.Items[Cur].Data);
    end
    else begin
      CodLea:= longint(olSchema.Items[Cur].Data);
      tbInGruppo.Append;
      tbInGruppo.FieldByName(FldNod).AsInteger:= CodNod;
      tbInGruppo.FieldByName(FldLea).AsInteger:= CodLea;
      tbInGruppo.Post;
    end;
    inc(Cur);
  end;
  tbInGruppo.Close;
  Changed:= false;
end;

end.

