(* GPL > 3.0
Copyright (C) 1986-2009 eIrOcA Elio & Enrico Croce, Simona Burzio

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
(* TabaC - Gestione Tabacchi
 * Ultima modifica: 06 nov 1999
 *)
unit FGiacIns;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC, eLibMath,
  Forms, Dialogs, DBTables, DB, Grids, StdCtrls,
  Buttons, Mask, ExtCtrls, JvComponentBase, JvFormPlacement, JvExMask,
  JvToolEdit, JvExGrids, JvGrids;

type
  TGiacenza = class
    Qta : longint;
    QtaC: longint;
    Med : longint;
    Min1: longint;
    Min2: longint;
    Max1: longint;
    Max2: longint;
    Mul : double;
  end;

  TGiacenze = class(TTabaList)
    private
      function  GetGiacenza(CodI: longint): TGiacenza;
      procedure SetGiacenza(CodI: longint; vl: TGiacenza);
    public
     property Giacenza[CodI: longint]: TGiacenza
       read  GetGiacenza
       write SetGiacenza; default;
  end;

  TfmGiacInsert = class(TForm)
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    dgGiac: TJvDrawGrid;
    tbTabaTIPO: TSmallintField;
    tbTabaPROD: TSmallintField;
    tbTabaCRIT: TSmallintField;
    tbTabaMULI: TSmallintField;
    tbTabaQTAS: TSmallintField;
    tbTabaQTAC: TSmallintField;
    tbTabaQTAM: TSmallintField;
    tbTabaDIFR: TSmallintField;
    tbGiacMov: TTable;
    tbGiacLst: TTable;
    tbGiacLstPGIA: TIntegerField;
    tbGiacLstDATA: TDateField;
    tbGiacLstKGC: TFloatField;
    tbGiacLstVAL: TCurrencyField;
    tbGiacMovPGIA: TIntegerField;
    tbGiacMovCODI: TSmallintField;
    tbGiacMovGIAC: TIntegerField;
    tbMTaba: TTable;
    tbMTabaCODI: TSmallintField;
    tbMTabaMEDA: TFloatField;
    tbMTabaMAXA: TFloatField;
    tbMTabaMED5: TFloatField;
    tbMTabaMAX5: TFloatField;
    tbMTabaMED0: TFloatField;
    tbMTabaMAX0: TFloatField;
    tbGiacLstDATAPREZ: TDateField;
    Panel1: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbTot: TLabel;
    cbOrder: TComboBox;
    cbAttivi: TCheckBox;
    iDataGiac: TJvDateEdit;
    btAdd: TBitBtn;
    btCancel: TBitBtn;
    cbQta: TComboBox;
    fsForm: TJvFormStorage;
    lbDataPrezzi: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dgGiacDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure btAddClick(Sender: TObject);
    procedure dgGiacSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoSetupIndex(Sender: TObject);
    procedure dgGiacSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure dgGiacEnter(Sender: TObject);
    procedure dgGiacExit(Sender: TObject);
    procedure cbQtaChange(Sender: TObject);
    procedure iDataGiacAcceptDate(Sender: TObject; var ADate: TDateTime;
      var Action: Boolean);
    procedure dgGiacGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure dgGiacGetEditAlign(Sender: TObject; ACol, ARow: Integer;
      var Alignment: TAlignment);
    procedure btCancelClick(Sender: TObject);
  private
    { Private declarations }
    Showing: boolean;
    fmtQta: string;
    Indx: TIVector;
    Dati: TGiacenze;
    KgC: double;
    Val: double;
    DataGiac: TDateTime;
    Changed: boolean;
    function  GetData: TDateTime;
    procedure SetData(vl: TDateTime);
    procedure SetUpIndex;
    procedure BuildData;
    procedure CalcTotale;
    function  checkGiacenza(G: TGiacenza): integer;
  public
    { Public declarations }
    property Data: TDateTime
      read  GetData
      write SetData;
  end;

procedure GiacInsert(Data: TDateTime);

implementation

{$R *.DFM}

uses
  UOpzioni, Costanti, eLibCore;

procedure GiacInsert(Data: TDateTime);
var
  fmGiacInsert: TfmGiacInsert;
begin
  if (dmTaba.NumTabAttv > 0) then begin
    fmGiacInsert:= TfmGiacInsert.Create(nil);
    try
      fmGiacInsert.Data:= Data;
      fmGiacInsert.ShowModal;
    finally
      fmGiacInsert.Free;
    end;
  end
  else begin
    ShowMessage('Non ci sono tabacchi attivi!');
  end;
end;

function  TGiacenze.GetGiacenza(CodI: longint): TGiacenza;
begin
  Result:= TGiacenza(Taba[CodI]);
end;

procedure TGiacenze.SetGiacenza(CodI: longint; vl: TGiacenza);
begin
  Taba[CodI]:= vl;
end;

procedure TfmGiacInsert.BuildData;
var
  i, N: integer;
  Car, Gia: longint;
  CodI: longint;
  G: TGiacenza;
  D: TDateTime;
  GSR: TGiacSearchRec;
  CSR: TCariSearchRec;
begin
  D:= dmTaba.GetLastGiac;
  if D <> NoDate then begin
    GSR:= dmTaba.FindGiacenza(D, true);
    CSR:= dmTaba.FindCarichi(D, D+7);
  end
  else begin
    GSR:= nil;
    CSR:= nil;
  end;
  tbMTaba.Open;
  Dati:= TGiacenze.Create(true);
  N:= dmTaba.NumTab;
  for i:= 1 to N do begin
    CodI:=dmTaba.Index[imCodI, false][i];
    if tbTaba.FindKey([CodI]) then begin
      G:= TGiacenza.Create;
      Gia:= dmTaba.GetGiacenza(GSR, CodI);
      Car:= dmTaba.GetCarichi (CSR, CodI);
      G.Max2:= Gia+Car;
      if tbMTaba.FindKey([CodI]) then begin
        G.Med := G.Max2 - round(tbMTabaMedA.Value);
        G.Min1:= G.Max2 - round(tbMTabaMaxA.Value);
        G.Min2:= G.Med  - round(tbMTabaMaxA.Value);
        G.Max1:= G.Max2 - round(tbMTabaMedA.Value / 2);
      end
      else begin
        G.Med := G.Max2;
        G.Min1:= 0;
        G.Min2:= 0;
      end;
      if G.Med  < 0 then G.Med := 0;
      if G.Max1 < 0 then G.Max1:= 0;
      if G.Max2 < 0 then G.Max2:= 0;
      if G.Min1 < 0 then G.Min1:= 0;
      if G.Min2 < 0 then G.Min2:= 0;
      G.Qta:= G.Med;
      G.QtaC:= tbTabaQtaC.Value;
      if G.QtaC<1 then G.QtaC:= 1;
      G.Mul:= 1;
      Dati[CodI]:= G;
    end;
  end;
  tbMTaba.Close;
end;

procedure TfmGiacInsert.SetUpIndex;
var
  N: integer;
  attv: boolean;
begin
  attv:= cbAttivi.Checked;
  case cbOrder.ItemIndex of
    1:   Indx:= dmTaba.Index[imCodS, attv];
    2:   Indx:= dmTaba.Index[imCodI, attv];
    else Indx:= dmTaba.Index[imDesc, attv];
  end;
  BuildData;
  if attv then N:= dmTaba.NumTabAttv
  else N:= dmTaba.NumTab;
  dgGiac.Col:= 3;
  dgGiac.Row:= 1;
  dgGiac.RowCount:= N+1;
  dgGiac.Invalidate;
end;

procedure TfmGiacInsert.FormShow(Sender: TObject);
begin
  Showing:= false;
  Changed:= false;
  tbTaba.Open;
  cbOrder.ItemIndex:= 2;
  SetupIndex;
  iDataGiac.Date:= Date;
  cbQta.ItemIndex:= 0;
  cbQtaChange(nil);
  dgGiac.Row:= 1;
  dgGiac.Col:= 4;
  ActiveControl:= iDataGiac;
  CalcTotale;
  lbDataPrezzi.Caption:= 'Prezzi del'+#13+DateUtil.MyDateToStr(dmTaba.DataPrezzi);
  Showing:= true;
end;

procedure TfmGiacInsert.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
  DataGiac:= NoDate;
  fmtQta:= '%g';
  tbGiacLst.IndexFieldNames:= 'DATA';
  tbGiacMov.IndexFieldNames:= 'PGIA;CODI';
  lbTot.Caption:= '';
end;

function TfmGiacInsert.checkGiacenza(G: TGiacenza): integer;
begin
  if (G.Qta>G.Max2) then Result:= 1
  else if (G.Qta>G.Max1) then Result:= 4
  else if (G.Qta<G.Min2) then Result:= 2
  else if (G.Qta<G.Min1) then Result:= 3
  else Result:= 0;
end;

procedure TfmGiacInsert.dgGiacDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  G: TGiacenza;
const
  eps = 0.1;
  function FormatQta(val: double): string;
  begin
    Result:= Trim(Format(fmtQta, [val / G.Mul]));
  end;

begin
  if Row = 0 then begin
    case col of
      0: dgGiac.DrawStr(Rect, 'Cod.', taCenter);
      1: dgGiac.DrawStr(Rect, 'Cod. Sig.', taCenter);
      2: dgGiac.DrawStr(Rect, 'Nome tabacco', taCenter);
      3: dgGiac.DrawStr(Rect, 'Quantità', taCenter);
      4: dgGiac.DrawStr(Rect, '', taCenter);
      5: dgGiac.DrawStr(Rect, 'Qtà Min.', taCenter);
      6: dgGiac.DrawStr(Rect, 'Qtà Med.', taCenter);
      7: dgGiac.DrawStr(Rect, 'Qtà Max.', taCenter);
    end;
  end
  else begin
    if not tbTaba.FindKey([Indx[Row]]) then exit;
    case Col of
      0: dgGiac.DrawStr(Rect, tbTabaCodI.AsString, taRightJustify);
      1: dgGiac.DrawStr(Rect, tbTabaCodS.AsString, taRightJustify);
      2: dgGiac.DrawStr(Rect, tbTabaDesc.AsString, taLeftJustify);
      3: begin
        G:= Dati[Indx[Row]];
        dgGiac.DrawStr(Rect, FormatQta(G.Qta), taRightJustify);
      end;
      4: begin
        G:= Dati[Indx[Row]];
        case checkGiacenza(G) of
          1: Col:= clRed;
          2: Col:= clGreen;
          3: Col:= clLime;
          4: Col:= clFuchsia;
          else begin
            Col:= dgGiac.Color;
          end;
        end;
        dgGiac.Canvas.Brush.Color:= Col;
        dgGiac.Canvas.Brush.Style:= bsSolid;
        dgGiac.Canvas.FillRect(Rect);
      end;
      5: begin
        G:= Dati[Indx[Row]];
        if checkGiacenza(G) = 2 then Col:= clRed
        else Col:= clBtnText;
        dgGiac.Canvas.Font.Color:= Col;
        dgGiac.DrawStr(Rect, FormatQta(G.Min1), taRightJustify);
      end;
      6: begin
        G:= Dati[Indx[Row]];
        dgGiac.DrawStr(Rect, FormatQta(G.Med), taRightJustify);
      end;
      7: begin
        G:= Dati[Indx[Row]];
        if checkGiacenza(G) = 1 then Col:= clRed
        else Col:= clBtnText;
        dgGiac.Canvas.Font.Color:= Col;
        dgGiac.DrawStr(Rect, FormatQta(G.Max2), taRightJustify);
      end;
    end;
  end;
end;

procedure TfmGiacInsert.btAddClick(Sender: TObject);
  function SetupLst: integer;
  begin
    if tbGiacLst.FindKey([iDataGiac.Date]) then tbGiacLst.Edit
    else tbGiacLst.Append;
    tbGiacLstData.Value:= iDataGiac.Date;
    tbGiacLstDataPrez.Value:= dmTaba.DataPrezzi;
    tbGiacLstKgC.Value:= KgC;
    tbGiacLstVal.Value:= Val;
    tbGiacLst.Post;
    Result:= tbGiacLstPGIA.Value;
  end;
var
  i, N: integer;
  CodI: integer;
  PGia: integer;
begin
  tbGiacLst.Active:= true;
  CalcTotale;
  if cbAttivi.Checked then N:= dmTaba.NumTabAttv
  else N:= dmTaba.NumTab;
  if tbGiacLst.FindKey([iDataGiac.Date])
     and (MessageDlg('Giacenza già presente, la sovrascrivo?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
      exit;
  end;
  PGia:= SetupLst;
  tbGiacMov.Open;
  for i:= 1 to N do begin
    CodI:= Indx[i];
    if CodI <> 0 then begin
      if tbGiacMov.FindKey([PGia, CodI]) then tbGiacMov.Delete;
      if Dati[CodI].Qta>0 then begin
        tbGiacMov.Append;
        tbGiacMovPGia.Value:= PGia;
        tbGiacMovCodI.Value:= CodI;
        tbGiacMovGiac.Value:= Dati[CodI].Qta;
        tbGiacMov.Post;
      end;
    end;
  end;
  tbGiacMov.Close;
  ModalResult:= mrOk;
end;

procedure TfmGiacInsert.dgGiacSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  CanSelect:= (Col=3) and (Row<>0);
end;

procedure TfmGiacInsert.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbTaba.Close;
  DataGiac:= NoDate;
end;

procedure TfmGiacInsert.DoSetupIndex(Sender: TObject);
var
  em: boolean;
begin
  em:= dgGiac.EditorMode;
  dgGiac.EditorMode:= false;
  SetupIndex;
  dgGiac.EditorMode:= em;
end;

procedure TfmGiacInsert.dgGiacSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  G: TGiacenza;
  OldQ: longint;
begin
  if (ARow>0) and (ACol=3) then begin
    G:= Dati[Indx[ARow]];
    OldQ:= G.Qta;
    G.Qta:= round(Parser.DVal(Trim(Value)) * G.Mul);
    Changed:= Changed or (G.Qta<>OldQ);
    dgGiac.InvalidateRow(ARow);
  end;
  CalcTotale;
end;

procedure TfmGiacInsert.dgGiacEnter(Sender: TObject);
begin
  dgGiac.EditorMode:= true;
end;

procedure TfmGiacInsert.dgGiacExit(Sender: TObject);
begin
  dgGiac.EditorMode:= false;
end;

procedure TfmGiacInsert.CalcTotale;
var
  i: integer;
  CodI: longint;
  D: TObject;
begin
  KgC:= 0;
  Val:= 0;
  for i:= 0 to Dati.Count-1 do begin
    if Dati.GetObjects(i, CodI, D) then begin
      KgC:= KgC + TGiacenza(D).Qta / TGiacenza(D).QtaC;
      Val:= Val + TGiacenza(D).Qta * dmTaba.Prezzo[CodI];
    end;
  end;
  lbTot.Caption:= Format('%6.2f KgC (%m)', [KgC, Val]);
end;

procedure TfmGiacInsert.cbQtaChange(Sender: TObject);
var
  i, N: integer;
  CodI: longint;
  em: boolean;
begin
  em:= dgGiac.EditorMode;
  dgGiac.EditorMode:= false;
  case cbQta.ItemIndex of
    0: fmtQta:= '%9.1f';
    2: fmtQta:= '%9.1f';
    3: fmtQta:= '%8.2f';
    else fmtQta:= '%10.0f';
  end;
  N:= dmTaba.NumTab;
  for i:= 1 to N do begin
    CodI:=dmTaba.Index[imCodI, false][i];
    if tbTaba.FindKey([CodI]) then begin
      case cbQta.ItemIndex of
        0: Dati[CodI].Mul:= tbTabaMulI.Value;
        2: Dati[CodI].Mul:= tbTabaQtaS.Value;
        3: Dati[CodI].Mul:= tbTabaQtaC.Value;
        else Dati[CodI].Mul:= 1;
      end;
    end
    else begin
      Dati[CodI].Mul:= 1;
    end;
  end;
  dgGiac.Invalidate;
  dgGiac.EditorMode:= em;
end;

function  TfmGiacInsert.GetData: TDateTime;
begin
  Result:= iDataGiac.Date;
end;

procedure TfmGiacInsert.SetData(vl: TDateTime);
begin
  iDataGiac.Date:= vl;
end;

procedure TfmGiacInsert.iDataGiacAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
  Action:= false;
  Data:= ADate;
end;

procedure TfmGiacInsert.dgGiacGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
var
  G: TGiacenza;
begin
  if (ARow>0) and (ACol=3) then begin
    G:= Dati[Indx[ARow]];
    Value:= Trim(Format(fmtQta, [G.Qta / G.Mul]));
  end;
end;

procedure TfmGiacInsert.dgGiacGetEditAlign(Sender: TObject; ACol,
  ARow: Integer; var Alignment: TAlignment);
begin
  Alignment:= taRightJustify;
end;

procedure TfmGiacInsert.btCancelClick(Sender: TObject);
begin
  if not Changed or
     (MessageDlg('Esco senza salvare le modifiche?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
    ModalResult:= mrCancel;
  end;
end;

end.

