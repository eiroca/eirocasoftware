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
unit FPatOrdIns;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC, eLibMath,
  Forms, Dialogs, DBTables, DB, Grids, StdCtrls,
  Buttons, Mask, ExtCtrls, JvExControls, JvDBLookup, JvExMask, JvToolEdit,
  JvExGrids, JvGrids;

type
  TRichiesta = class
    Qta : longint;
    Mul : longint;
    QtaC: longint;
  end;

  TRichieste = class(TTabaList)
    private
      function  GetRichiesta(CodI: longint): TRichiesta;
      procedure SetRichiesta(CodI: longint; vl: TRichiesta);
    public
     property Richiesta[CodI: longint]: TRichiesta
       read  GetRichiesta
       write SetRichiesta; default;
  end;

  TfmPatOInsert = class(TForm)
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    dgCons: TJvDrawGrid;
    tbTabaTIPO: TSmallintField;
    tbTabaPROD: TSmallintField;
    tbTabaCRIT: TSmallintField;
    tbTabaMULI: TSmallintField;
    tbTabaQTAS: TSmallintField;
    tbTabaQTAC: TSmallintField;
    tbTabaQTAM: TSmallintField;
    tbTabaDIFR: TSmallintField;
    tbMovs: TTable;
    tbList: TTable;
    Panel1: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbTot: TLabel;
    cbOrder: TComboBox;
    cbAttivi: TCheckBox;
    iDataPatO: TJvDateEdit;
    btAdd: TBitBtn;
    btCancel: TBitBtn;
    cbQta: TComboBox;
    Label3: TLabel;
    cbCodPat: TJvDBLookupCombo;
    tbPate: TTable;
    tbPateCODP: TAutoIncField;
    tbPateNOME: TStringField;
    tbListPPCO: TAutoIncField;
    tbListCODP: TIntegerField;
    tbListDATA: TDateField;
    tbListDATAORDI: TDateField;
    tbListDATAPREZ: TDateField;
    tbListKGC: TFloatField;
    tbListVAL: TCurrencyField;
    tbMovsPPCO: TIntegerField;
    tbMovsCODI: TSmallintField;
    tbMovsCONS: TIntegerField;
    dsPate: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dgConsDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure btAddClick(Sender: TObject);
    procedure dgConsSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoSetupIndex(Sender: TObject);
    procedure dgConsSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure cbQtaChange(Sender: TObject);
    procedure iDataPatOAcceptDate(Sender: TObject; var ADate: TDateTime;
      var Action: Boolean);
    procedure dgConsGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure dgConsGetEditAlign(Sender: TObject; ACol, ARow: Integer;
      var Alignment: TAlignment);
    procedure btCancelClick(Sender: TObject);
    procedure dgConsEnter(Sender: TObject);
    procedure dgConsExit(Sender: TObject);
  private
    { Private declarations }
    Showing: boolean;
    fmtQta: string;
    Indx: TIVector;
    Dati: TRichieste;
    KgC: double;
    Val: double;
    DataGiac: TDateTime;
    Changed: boolean;
    function  GetData: TDateTime;
    procedure SetData(vl: TDateTime);
    procedure SetUpIndex;
    procedure BuildData;
    procedure CalcTotale;
  public
    { Public declarations }
    property Data: TDateTime
      read  GetData
      write SetData;
  end;

procedure PatOInsert(Data: TDateTime);

implementation

{$R *.DFM}

uses
  UOpzioni, Costanti, eLibCore;

procedure PatOInsert(Data: TDateTime);
var
  fmPatOInsert: TfmPatOInsert;
begin
  if (dmTaba.NumTabAttv > 0) then begin
    fmPatOInsert:= TfmPatOInsert.Create(nil);
    try
      fmPatOInsert.Data:= Data;
      fmPatOInsert.ShowModal;
    finally
      fmPatOInsert.Free;
    end;
  end
  else begin
    ShowMessage('Non ci sono tabacchi attivi!');
  end
end;

function  TRichieste.GetRichiesta(CodI: longint): TRichiesta;
begin
  Result:= TRichiesta(Taba[CodI]);
end;

procedure TRichieste.SetRichiesta(CodI: longint; vl: TRichiesta);
begin
  Taba[CodI]:= vl;
end;

procedure TfmPatOInsert.BuildData;
var
  i, N: integer;
  CodI: longint;
  G: TRichiesta;
begin
  Dati:= TRichieste.Create(true);
  N:= dmTaba.NumTab;
  for i:= 1 to N do begin
    CodI:=dmTaba.Index[imCodI, false][i];
    if tbTaba.FindKey([CodI]) then begin
      G:= TRichiesta.Create;
      G.Qta:= 0;
      G.Mul:= tbTabaQtaC.Value;
      G.QtaC:= tbTabaQtaC.Value;
      if G.Mul<1 then G.Mul:= 1;
      Dati[CodI]:= G;
    end;
  end;
end;

procedure TfmPatOInsert.SetUpIndex;
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
  dgCons.Col:= 3;
  dgCons.Row:= 1;
  dgCons.RowCount:= N+1;
  dgCons.Invalidate;
end;

procedure TfmPatOInsert.FormShow(Sender: TObject);
begin
  Showing:= false;
  Changed:= false;
  tbTaba.Open;
  tbPate.Open;
  cbOrder.ItemIndex:= 2;
  SetupIndex;
  iDataPatO.Date:= Date;
  cbQta.ItemIndex:= 3;
  cbQtaChange(nil);
  ActiveControl:= iDataPatO;
  CalcTotale;
  Showing:= true;
end;

procedure TfmPatOInsert.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
  DataGiac:= NoDate;
  fmtQta:= '%g';
  tbList.IndexFieldNames:= 'DATA';
  tbMovs.IndexFieldNames:= 'PPCO;CODI';
  lbTot.Caption:= '';
end;

procedure TfmPatOInsert.dgConsDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  d: double;
  G: TRichiesta;
begin
  if Row = 0 then begin
    case col of
      0: dgCons.DrawStr(Rect, 'Cod.', taCenter);
      1: dgCons.DrawStr(Rect, 'Cod. Sig.', taCenter);
      2: dgCons.DrawStr(Rect, 'Nome tabacco', taCenter);
      3: dgCons.DrawStr(Rect, 'Quantità', taCenter);
    end;
  end
  else begin
    if not tbTaba.FindKey([Indx[Row]]) then exit;
    case Col of
      0: dgCons.DrawStr(Rect, tbTabaCodI.AsString, taRightJustify);
      1: dgCons.DrawStr(Rect, tbTabaCodS.AsString, taRightJustify);
      2: dgCons.DrawStr(Rect, tbTabaDesc.AsString, taLeftJustify);
      3: begin
        G:= Dati[Indx[Row]];
        d:= G.Qta / G.Mul;
        dgCons.DrawStr(Rect, Format(fmtQta, [d]), taRightJustify);
      end;
    end;
  end;
end;

procedure TfmPatOInsert.btAddClick(Sender: TObject);
  function SetupLst: integer;
  begin
    tbList.Append;
    tbListCODP.Value:= cbCodPat.KeyValue;
    tbListDataOrdi.Value:= iDataPatO.Date;
    tbListDataPrez.Value:= dmTaba.DataPrezzi;
    tbListKgC.Value:= KgC;
    tbListVal.Value:= Val;
    tbList.Post;
    Result:= tbListPPCO.Value;
  end;
var
  i, N: integer;
  CodI: integer;
  PPCO: integer;
  outF: TextFile;
  Qta: longint;
begin
  if (cbCodPat.Value = '') then begin
    MessageDlg('Inserire nome patentino', mtWarning, [mbOk], 0);
    ActiveControl:= cbCodPat;
    exit;
  end;
  tbList.Active:= true;
  CalcTotale;
  if cbAttivi.Checked then N:= dmTaba.NumTabAttv
  else N:= dmTaba.NumTab;
  PPCO:= SetupLst;
  tbMovs.Open;
  for i:= 1 to N do begin
    CodI:= Indx[i];
    if CodI <> 0 then begin
      if tbMovs.FindKey([PPCO, CodI]) then tbMovs.Delete;
      if Dati[CodI].Qta>0 then begin
        tbMovs.Append;
        tbMovsPPCO.Value:= PPCO;
        tbMovsCodI.Value:= CodI;
        tbMovsCONS.Value:= Dati[CodI].Qta;
        tbMovs.Post;
      end;
    end;
  end;
  tbMovs.Close;
  // Memorizzazione Richiesta Patentino in file storici
  AssignFile(outF, Opzioni.BasePath+Opzioni.RelPathStorico+'\Richiesta_'+FormatDateTime('yyyymmdd', iDataPatO.Date)+'_'+cbCodPat.KeyValue+'.txt');
  Rewrite(outF);
  writeln(outF, Format('; Richiesta del %s di %s con prezzi del %s', [DateToStr(iDataPatO.Date), cbCodPat.Value, DateToStr(dmTaba.DataPrezzi)]));
  for i:= 1 to N do begin
    CodI:= Indx[i];
    if CodI <> 0 then begin
      Qta:= Dati[CodI].Qta;
      if Qta>0 then begin
        if tbTaba.FindKey([CodI]) then begin
          writeln(outF, Format('%d,"%s",%d', [tbTabaCodS.asInteger, tbTabaDesc.asString, Qta]));
        end;
      end;
    end;
  end;
  writeln(outF, Format('; Totale %f KgC per un valore di %m', [KgC, Val]));
  CloseFile(outF);

  ModalResult:= mrOk;
end;

procedure TfmPatOInsert.dgConsSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  CanSelect:= (Col=3) and (Row<>0);
end;

procedure TfmPatOInsert.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbTaba.Close;
  tbPate.Close;
  DataGiac:= NoDate;
end;

procedure TfmPatOInsert.DoSetupIndex(Sender: TObject);
var
  em: boolean;
begin
  em:= dgCons.EditorMode;
  dgCons.EditorMode:= false;
  SetupIndex;
  dgCons.EditorMode:= em;
end;

procedure TfmPatOInsert.dgConsSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  G: TRichiesta;
  OldQ: longint;
begin
  if (ARow>0) and (ACol=3) then begin
    G:= Dati[Indx[ARow]];
    OldQ:= G.Qta;
    G.Qta:= round(Parser.DVal(Trim(Value)) * G.Mul);
    Changed:= Changed or (G.Qta<>OldQ);
  end;
  CalcTotale;
end;

procedure TfmPatOInsert.CalcTotale;
var
  i: integer;
  CodI: longint;
  D: TObject;
begin
  KgC:= 0;
  Val:= 0;
  for i:= 0 to Dati.Count-1 do begin
    if Dati.GetObjects(i, CodI, D) then begin
      KgC:= KgC + TRichiesta(D).Qta / TRichiesta(D).QtaC;
      Val:= Val + TRichiesta(D).Qta * dmTaba.Prezzo[CodI];
    end;
  end;
  lbTot.Caption:= Format('%6.2f KgC (%m)', [KgC, Val]);
end;

procedure TfmPatOInsert.cbQtaChange(Sender: TObject);
var
  i, N: integer;
  CodI: longint;
  em: boolean;
begin
  em:= dgCons.EditorMode;
  dgCons.EditorMode:= false;
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
  dgCons.Invalidate;
  dgCons.EditorMode:= em;
  CalcTotale;
end;

function  TfmPatOInsert.GetData: TDateTime;
begin
  Result:= iDataPatO.Date;
end;

procedure TfmPatOInsert.SetData(vl: TDateTime);
begin
  iDataPatO.Date:= vl;
end;

procedure TfmPatOInsert.iDataPatOAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
  Action:= false;
  Data:= ADate;
end;

procedure TfmPatOInsert.dgConsGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
var
  G: TRichiesta;
begin
  if (ARow>0) and (ACol=3) then begin
    G:= Dati[Indx[ARow]];
    Value:= Trim(Format(fmtQta, [G.Qta / G.Mul]));
  end;
end;

procedure TfmPatOInsert.dgConsGetEditAlign(Sender: TObject; ACol,
  ARow: Integer; var Alignment: TAlignment);
begin
  Alignment:= taRightJustify;
end;

procedure TfmPatOInsert.btCancelClick(Sender: TObject);
begin
  if not Changed or
     (MessageDlg('Esco senza salvare le modifiche?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
    ModalResult:= mrCancel;
  end;
end;

procedure TfmPatOInsert.dgConsEnter(Sender: TObject);
begin
  dgCons.EditorMode:= true;
end;

procedure TfmPatOInsert.dgConsExit(Sender: TObject);
begin
  dgCons.EditorMode:= false;
end;

end.

