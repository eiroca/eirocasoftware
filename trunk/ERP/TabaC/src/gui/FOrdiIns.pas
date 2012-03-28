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
unit FOrdiIns;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC, eLibMath,
  Forms, Dialogs, DBTables, DB, Grids, StdCtrls,
  Buttons, Mask, ExtCtrls, JvComponentBase, JvFormPlacement, JvSpin, JvExMask,
  JvToolEdit, JvExGrids, JvGrids;

const
  LowMed = 0.8;
  HigMed = 1.2;

type
  TRigaOrdine = class
    Qta : longint;
    Mul : double;
    QtaC: longint;
    QtaM: longint;
    QtaS: longint;
    Gia : longint;
    Ord : longint;
    Dif : longint;
    Ric1: longint;
    Ric2: longint;
    Ric3: longint;
    Pre1: longint;
    Pre2: longint;
    Pre3: longint;
  end;

  TOrdine = class(TTabaList)
    private
      function  GetRigaOrdine(CodI: longint): TRigaOrdine;
      procedure SetRigaOrdine(CodI: longint; vl: TRigaOrdine);
    public
     property Giacenza[CodI: longint]: TRigaOrdine
       read  GetRigaOrdine
       write SetRigaOrdine; default;
  end;

  TfmOrdiInsert = class(TForm)
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    dgOrdi: TJvDrawGrid;
    tbTabaTIPO: TSmallintField;
    tbTabaPROD: TSmallintField;
    tbTabaCRIT: TSmallintField;
    tbTabaMULI: TSmallintField;
    tbTabaQTAS: TSmallintField;
    tbTabaQTAC: TSmallintField;
    tbTabaQTAM: TSmallintField;
    tbTabaDIFR: TSmallintField;
    tbOrdiMov: TTable;
    tbOrdiLst: TTable;
    tbMTaba: TTable;
    tbMTabaCODI: TSmallintField;
    tbMTabaMEDA: TFloatField;
    tbMTabaMAXA: TFloatField;
    tbMTabaMED5: TFloatField;
    tbMTabaMAX5: TFloatField;
    tbMTabaMED0: TFloatField;
    tbMTabaMAX0: TFloatField;
    tbOrdiLstPCAR: TIntegerField;
    tbOrdiLstDATA: TDateField;
    tbOrdiLstDATAORDI: TDateField;
    tbOrdiLstDATAPREZ: TDateField;
    tbOrdiLstKGC: TFloatField;
    tbOrdiLstVAL: TCurrencyField;
    tbOrdiMovPCAR: TIntegerField;
    tbOrdiMovCODI: TSmallintField;
    tbOrdiMovCARI: TIntegerField;
    Panel1: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbTot: TLabel;
    Label7: TLabel;
    cbOrder: TComboBox;
    cbAttivi: TCheckBox;
    iDataOrdi: TJvDateEdit;
    btAdd: TBitBtn;
    btCancel: TBitBtn;
    cbQta: TComboBox;
    iScorta1: TJvSpinEdit;
    iScorta2: TJvSpinEdit;
    iScorta3: TJvSpinEdit;
    fsForm: TJvFormStorage;
    lbDataPrezzi: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dgOrdiDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure btAddClick(Sender: TObject);
    procedure dgOrdiSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoSetupIndex(Sender: TObject);
    procedure dgOrdiSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure dgOrdiEnter(Sender: TObject);
    procedure dgOrdiExit(Sender: TObject);
    procedure cbQtaChange(Sender: TObject);
    procedure iDataOrdiAcceptDate(Sender: TObject; var ADate: TDateTime;
      var Action: Boolean);
    procedure iScortaChange(Sender: TObject);
    procedure dgOrdiGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure btCancelClick(Sender: TObject);
    procedure dgOrdiGetEditAlign(Sender: TObject; ACol, ARow: Integer;
      var Alignment: TAlignment);
  private
    { Private declarations }
    Showing: boolean;
    fmtQta: string;
    Indx: TIVector;
    Dati: TOrdine;
    KgC: double;
    Val: double;
    DataGiac: TDateTime;
    Changed: boolean;
    function  GetData: TDateTime;
    procedure SetData(vl: TDateTime);
    procedure SetUpIndex;
    procedure BuildData;
    procedure CalcTotale;
    procedure ChangeMul(Kind: integer);
    procedure ChangePred(Peri1, Peri2, Peri3: double);
    function  QtaMin(x: double; QtaS, QtaM, QtaC: longint): longint;
  public
    { Public declarations }
    property Data: TDateTime
      read  GetData
      write SetData;
  end;

procedure OrdiInsert(Data: TDateTime);

implementation

{$R *.DFM}

uses
  uOpzioni, Costanti, eLibCore;

procedure OrdiInsert(Data: TDateTime);
var
  fmOrdiInsert: TfmOrdiInsert;
begin
  if (dmTaba.NumTabAttv > 0) then begin
    fmOrdiInsert:= TfmOrdiInsert.Create(nil);
    try
      fmOrdiInsert.Data:= Data;
      fmOrdiInsert.ShowModal;
    finally
      fmOrdiInsert.Free;
    end;
  end
  else begin
    ShowMessage('Non ci sono tabacchi attivi!');
  end;
end;

function  TOrdine.GetRigaOrdine(CodI: longint): TRigaOrdine;
begin
  Result:= TRigaOrdine(Taba[CodI]);
end;

procedure TOrdine.SetRigaOrdine(CodI: longint; vl: TRigaOrdine);
begin
  Taba[CodI]:= vl;
end;

procedure TfmOrdiInsert.BuildData;
var
  i, N: integer;
  CodI: longint;
  D: TRigaOrdine;
  DGia: TDateTime;
  GSR: TGiacSearchRec;
  OSR: TOrdiSearchRec;
begin
  DGia:= dmTaba.GetLastGiac;
  if DGia <> NoDate then begin
    GSR:= dmTaba.FindGiacenza(DGia, true);
    OSR:= dmTaba.FindOrdini(NoDate, NoDate, true);
  end
  else begin
    GSR:= nil;
    OSR:= nil;
  end;
  tbMTaba.Open;
  Dati:= TOrdine.Create(true);
  N:= dmTaba.NumTab;
  for i:= 1 to N do begin
    CodI:=dmTaba.Index[imCodI, false][i];
    if tbTaba.FindKey([CodI]) then begin
      D:= TRigaOrdine.Create;
      D.QtaM:= tbTabaQtaM.Value;
      D.QtaC:= tbTabaQtaC.Value;
      D.QtaS:= tbTabaQtaS.Value;
      D.Dif:= tbTabaDifr.Value;
      if D.QtaM<1 then D.QtaM:= 1;
      if D.QtaC<1 then D.QtaC:= 1;
      if D.QtaS<1 then D.QtaS:= 1;
      D.Gia:= dmTaba.GetGiacenza(GSR, CodI);
      D.Ord:= dmTaba.GetOrdinato(OSR, CodI);
      D.Mul:= 1;
      D.Qta:= 0;
      D.Pre1:= 0;
      D.Pre2:= 0;
      D.Pre3:= 0;
      D.Ric1:= 0;
      D.Ric2:= 0;
      D.Ric3:= 0;
      Dati[CodI]:= D;
    end;
  end;
  tbMTaba.Close;
end;

procedure TfmOrdiInsert.SetUpIndex;
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
  dgOrdi.Col:= 4;
  dgOrdi.Row:= 1;
  dgOrdi.RowCount:= N+1;
  dgOrdi.Invalidate;
end;

procedure TfmOrdiInsert.ChangeMul(Kind: integer);
var
  i, N: integer;
  CodI: longint;
  em: boolean;
begin
  em:= dgOrdi.EditorMode;
  dgOrdi.EditorMode:= false;
  case Kind of
    0: fmtQta:= '%9.1f';
    2: fmtQta:= '%9.0f';
    3: fmtQta:= '%8.2f';
    else fmtQta:= '%10.0f';
  end;
  N:= dmTaba.NumTab;
  for i:= 1 to N do begin
    CodI:=dmTaba.Index[imCodI, false][i];
    if tbTaba.FindKey([CodI]) then begin
      case Kind of
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
  dgOrdi.Invalidate;
  dgOrdi.EditorMode:= em;
end;

procedure TfmOrdiInsert.ChangePred(Peri1, Peri2, Peri3: double);
var
  i, N: integer;
  CodI: longint;
  em: boolean;
  D: TRigaOrdine;
  Pre: integer;
begin
  em:= dgOrdi.EditorMode;
  dgOrdi.EditorMode:= false;
  N:= dmTaba.NumTab;
  for i:= 1 to N do begin
    CodI:= dmTaba.Index[imCodI, false][i];
    D:= Dati[CodI];
    D.Pre1:= round(dmTaba.PrediciVend(CodI, Peri1, pmBest));
    D.Pre2:= round(dmTaba.PrediciVend(CodI, Peri2, pmBest));
    D.Pre3:= round(dmTaba.PrediciVend(CodI, Peri3, pmBest));
    if tbTaba.FindKey([CodI]) and tbTabaAttv.Value then begin
      case tbTabaCrit.Value of
        1: Pre:= D.Pre1;
        2: Pre:= D.Pre2;
        3: Pre:= D.Pre3;
        else Pre:= D.Pre1;
      end;
      D.Qta := QtaMin(Pre-D.Ord-D.Gia+D.Dif, D.QtaS, D.QtaM, D.QtaC);
    end
    else begin
      D.Qta := 0;
    end;
    D.Ric1:= D.Pre1-D.Gia-D.Ord; if (D.Ric1<0) then D.Ric1:= 0;
    D.Ric2:= D.Pre2-D.Gia-D.Ord; if (D.Ric2<0) then D.Ric2:= 0;
    D.Ric3:= D.Pre3-D.Gia-D.Ord; if (D.Ric3<0) then D.Ric3:= 0;
    D.Pre2:= round(dmTaba.PrediciVend(CodI, Peri1, pmLong));
    D.Pre3:= round(dmTaba.PrediciVend(CodI, Peri1, pmShort));
  end;
  dgOrdi.Invalidate;
  dgOrdi.EditorMode:= em;
end;

function TfmOrdiInsert.QtaMin(x: double; QtaS, QtaM, QtaC: longint): longint;
begin
  if x<=0.005 then Result:= 0
  else begin
    Result:= round((int((x + (QtaS-1)) / QtaS)) * QtaS);
    if Result < QtaM then Result:= QtaM
    else if (QtaM>0) and (Result>QtaM) then begin
      Result:= round((int((x + (QtaC-1)) / QtaC)) * QtaC);
    end;
  end;
end;

procedure TfmOrdiInsert.FormShow(Sender: TObject);
begin
  Changed:= false;
  Showing:= false;
  tbTaba.Open;
  cbOrder.ItemIndex:= 2;
  SetupIndex;
  iDataOrdi.Date:= Date;
  cbQta.ItemIndex:= 3;
  cbQtaChange(nil);
  iScorta1.Value:= iScorta1.MinValue+0.5;
  iScorta2.Value:= iScorta1.Value*2;
  iScorta3.Value:= iScorta1.Value*3;
  iScortaChange(Self);
  dgOrdi.Row:= 1;
  dgOrdi.Col:= 4;
  CalcTotale;
  lbDataPrezzi.Caption:= 'Prezzi del'+#13+DateUtil.MyDateToStr(dmTaba.DataPrezzi);
  Showing:= true;
end;

procedure TfmOrdiInsert.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
  DataGiac:= NoDate;
  fmtQta:= '%g';
  tbOrdiLst.IndexFieldNames:= 'DATAORDI';
  tbOrdiMov.IndexFieldNames:= 'PCAR;CODI';
  lbTot.Caption:= '';
  dgOrdi.OnGetEditText:= dgOrdiGetEditText;
end;

procedure TfmOrdiInsert.dgOrdiDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  D: TRigaOrdine;
  tmp: string;
const
  eps = 0.1;
  function FormatQta(val: double): string;
  begin
    Result:= Trim(Format(fmtQta, [val / D.Mul]));
  end;
  function Analizza(D: TRigaOrdine): integer;
  var
    Ord1: longint;
    Ord2: longint;
  begin
    Ord1:= D.Pre1-D.Gia-D.Ord; if Ord1 < 0 then Ord1:= 0;
    Ord2:= D.Pre2-D.Gia-D.Ord; if Ord2 < 0 then Ord2:= 0;
    if (D.Qta>=(Ord1*LowMed)) and (D.Qta<=(Ord1*HigMed)) then Result:= 0
    else if D.Qta>Ord2 then Result:= 2
    else Result:= 1;
  end;
begin
  if Row = 0 then begin
    case col of
      0: dgOrdi.DrawStr(Rect, 'Cod.', taCenter);
      1: dgOrdi.DrawStr(Rect, 'Cod. Sig.', taCenter);
      2: dgOrdi.DrawStr(Rect, 'Nome tabacco', taCenter);
      3: dgOrdi.DrawStr(Rect, 'Giac. (Ord.)', taCenter);
      4: dgOrdi.DrawStr(Rect, 'Ordine', taCenter);
      5: dgOrdi.DrawStr(Rect, 'Ord. Teorico', taCenter);
      6: dgOrdi.DrawStr(Rect, 'Tendenze', taCenter);
    end;
  end
  else begin
    if not tbTaba.FindKey([Indx[Row]]) then exit;
    case Col of
      0: dgOrdi.DrawStr(Rect, tbTabaCodI.AsString, taRightJustify);
      1: dgOrdi.DrawStr(Rect, tbTabaCodS.AsString, taRightJustify);
      2: dgOrdi.DrawStr(Rect, tbTabaDesc.AsString, taLeftJustify);
      3: begin
        D:= Dati[Indx[Row]];
        tmp:= FormatQta(D.Gia)+' ('+FormatQta(D.Ord)+')';
        dgOrdi.DrawStr(Rect, tmp, taRightJustify);
      end;
      4: begin
        D:= Dati[Indx[Row]];
        case Analizza(D) of
          0: Col:= clBtnText;
          1: Col:= clHighLight;
          else Col:= clRed;
        end;
        dgOrdi.Canvas.Font.Color:= Col;
        dgOrdi.DrawStr(Rect, FormatQta(D.Qta), taRightJustify);
      end;
      5: begin
        D:= Dati[Indx[Row]];
        tmp:= FormatQta(D.Ric1)+' - '+FormatQta(D.Ric2)+' - '+FormatQta(D.Ric3);
        dgOrdi.DrawStr(Rect, tmp, taRightJustify);
      end;
      6: begin
        D:= Dati[Indx[Row]];
        tmp:= FormatQta(D.Pre1)+ ' - ' + FormatQta(D.Pre2)+ ' - ' + FormatQta(D.Pre3);
        dgOrdi.DrawStr(Rect, tmp, taRightJustify);
      end;
    end;
  end;
end;

procedure TfmOrdiInsert.btAddClick(Sender: TObject);
  function SetupLst: integer;
  begin
    if tbOrdiLst.FindKey([iDataOrdi.Date]) then tbOrdiLst.Edit
    else tbOrdiLst.Append;
    tbOrdiLstDataOrdi.Value:= iDataOrdi.Date;
    tbOrdiLstDataPrez.Value:= dmTaba.DataPrezzi;
    tbOrdiLstKgC.Value:= KgC;
    tbOrdiLstVal.Value:= Val;
    tbOrdiLst.Post;
    if tbOrdiLst.FindKey([iDataOrdi.Date]) then Result:= tbOrdiLstPCAR.Value
    else begin
      Result:= 0;
      ShowMessage('Errore Interno');
    end;
  end;
var
  i, N: integer;
  CodI: integer;
  PCar: integer;
  Qta : integer;
  outF: TextFile;
begin
  tbOrdiLst.Active:= true;
  CalcTotale;
  if cbAttivi.Checked then N:= dmTaba.NumTabAttv
  else N:= dmTaba.NumTab;
  if tbOrdiLst.FindKey([iDataOrdi.Date])
     and (MessageDlg('Ordine già presente, lo sovrascrivo?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
      exit;
  end;
  PCar:= SetupLst;
  tbOrdiMov.Open;
  for i:= 1 to N do begin
    CodI:= Indx[i];
    if CodI <> 0 then begin
      if tbOrdiMov.FindKey([PCar, CodI]) then tbOrdiMov.Delete;
      Qta:= Dati[CodI].Qta;
      if Qta>0 then begin
        tbOrdiMov.Append;
        tbOrdiMovPCAR.Value:= PCar;
        tbOrdiMovCODI.Value:= CodI;
        tbOrdiMovCARI.Value:= Qta;
        tbOrdiMov.Post;
      end;
    end;
  end;
  tbOrdiMov.Close;
  // Memorizzazione ordine in file storici
  AssignFile(outF, Opzioni.BasePath+Opzioni.RelPathStorico+'\Ordine_'+FormatDateTime('yyyymmdd', iDataOrdi.Date)+'.txt');
  Rewrite(outF);
  writeln(outF, Format('; Ordine del %s con prezzi del %s', [DateToStr(iDataOrdi.Date), DateToStr(dmTaba.DataPrezzi)]));
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

procedure TfmOrdiInsert.dgOrdiSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  CanSelect:= (Col=4) and (Row<>0);
end;

procedure TfmOrdiInsert.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbTaba.Close;
  DataGiac:= NoDate;
end;

procedure TfmOrdiInsert.DoSetupIndex(Sender: TObject);
var
  em: boolean;
begin
  em:= dgOrdi.EditorMode;
  dgOrdi.EditorMode:= false;
  SetupIndex;
  dgOrdi.EditorMode:= em;
end;

procedure TfmOrdiInsert.dgOrdiSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  D: TRigaOrdine;
  OldQ: longint;
begin
  if (ARow>0) and (ACol=4) then begin
    D:= Dati[Indx[ARow]];
    OldQ:= D.Qta;
    D.Qta:= QtaMin(Parser.DVal(Trim(Value))*D.Mul, D.QtaS, 0, 0);
    Changed:= Changed or (D.Qta<>OldQ);
  end;
  CalcTotale;
end;

procedure TfmOrdiInsert.dgOrdiEnter(Sender: TObject);
begin
  dgOrdi.EditorMode:= true;
end;

procedure TfmOrdiInsert.dgOrdiExit(Sender: TObject);
begin
  dgOrdi.EditorMode:= false;
end;

procedure TfmOrdiInsert.CalcTotale;
var
  i: integer;
  CodI: longint;
  D: TObject;
begin
  KgC:= 0;
  Val:= 0;
  for i:= 0 to Dati.Count-1 do begin
    if Dati.GetObjects(i, CodI, D) then begin
      KgC:= KgC + TRigaOrdine(D).Qta / TRigaOrdine(D).QtaC;
      Val:= Val + TRigaOrdine(D).Qta * dmTaba.Prezzo[CodI];
    end;
  end;
  lbTot.Caption:= Format('%6.2f KgC (%m)', [KgC, Val]);
end;

procedure TfmOrdiInsert.cbQtaChange(Sender: TObject);
begin
  ChangeMul(cbQta.ItemIndex);
end;

function  TfmOrdiInsert.GetData: TDateTime;
begin
  Result:= iDataOrdi.Date;
end;

procedure TfmOrdiInsert.SetData(vl: TDateTime);
begin
  iDataOrdi.Date:= vl;
end;

procedure TfmOrdiInsert.iDataOrdiAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
  Action:= false;
  Data:= ADate;
end;

procedure TfmOrdiInsert.iScortaChange(Sender: TObject);
begin
  if iScorta2.Value < iScorta1.Value then begin
    iScorta2.Value:= iScorta1.Value;
  end;
  if iScorta3.Value < iScorta2.Value then begin
    iScorta3.Value:= iScorta2.Value;
  end;
  ChangePred(iScorta1.Value, iScorta2.Value, iScorta3.Value);
end;

procedure TfmOrdiInsert.dgOrdiGetEditText(Sender: TObject; ACol, ARow: Longint; var Value: string);
var
  D: TRigaOrdine;
begin
  if (ARow>0) and (ACol=4) then begin
    D:= Dati[Indx[ARow]];
    Value:= Trim(Format(fmtQta, [D.Qta / D.Mul]));
  end;
end;

procedure TfmOrdiInsert.btCancelClick(Sender: TObject);
begin
  if not Changed or
     (MessageDlg('Esco senza salvare le modifiche?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
    ModalResult:= mrCancel;
  end;
end;

procedure TfmOrdiInsert.dgOrdiGetEditAlign(Sender: TObject; ACol,
  ARow: Integer; var Alignment: TAlignment);
begin
  Alignment:= taRightJustify;
end;

end.

