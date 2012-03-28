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
unit FPrezziIns;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC, eLibMath,
  Forms, Dialogs, DBTables, DB, Grids, StdCtrls,
  Buttons, Mask, ExtCtrls, JvExMask, JvToolEdit, JvExGrids, JvGrids;

type
  TPrezzo = class
    Prezzo: longint;
  end;

  TPrezzi = class(TTabaList)
    private
      function  GetPrezzo(CodI: longint): longint;
      procedure SetPrezzo(CodI: longint; vl: longint); 
    public
     property Prezzo[CodI: longint]: longint
       read  GetPrezzo
       write SetPrezzo; default;
  end;

  TfmPrezziInsert = class(TForm)
    tbPrezLst: TTable;
    tbTaba: TTable;
    tbPrezMov: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    tbPrezLstPPRE: TIntegerField;
    tbPrezLstDATA: TDateField;
    tbPrezLstDESC: TStringField;
    tbPrezMovPPRE: TIntegerField;
    tbPrezMovCODI: TSmallintField;
    tbPrezMovPREZ: TCurrencyField;
    Panel1: TPanel;
    dgPrez: TJvDrawGrid;
    Panel2: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    cbOrder: TComboBox;
    cbAttivi: TCheckBox;
    iDate: TJvDateEdit;
    btAdd: TBitBtn;
    btCancel: TBitBtn;
    iNota: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dgPrezDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);           
    procedure btAddClick(Sender: TObject);
    function dgPrezAcceptEditKey(Sender: TObject; var Key: Char): Boolean;
    procedure dgPrezSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoSetupIndex(Sender: TObject);
    procedure dgPrezSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure iDateChange(Sender: TObject);
    procedure dgPrezEnter(Sender: TObject);
    procedure dgPrezExit(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure dgPrezGetEditText(Sender: TObject; ACol, ARow: Longint;
      var Value: string);
  private
    { Private declarations }
    Showing: boolean;
    Changed: boolean;
    Indx: TIVector;
    Dati: TPrezzi;
    procedure SetUpIndex;
  public
    { Public declarations }
  end;

procedure PrezziInsert;

implementation

{$R *.DFM}

uses
  Costanti, eLibCore;

procedure PrezziInsert;
var
  fmPrezziInsert: TfmPrezziInsert;
begin
  if (dmTaba.NumTabAttv > 0) then begin
    fmPrezziInsert:= TfmPrezziInsert.Create(nil);
    try
      fmPrezziInsert.ShowModal;
    finally
      fmPrezziInsert.Free;
    end;
  end
  else begin
    ShowMessage('Non ci sono tabacchi attivi!');
  end
end;

function  TPrezzi.GetPrezzo(CodI: longint): longint;
var
  P: TObject;
begin
  P:= Taba[CodI];
  if P <> nil then Result:= TPrezzo(P).Prezzo
  else Result:= 0;
end;

procedure TPrezzi.SetPrezzo(CodI: longint; vl: longint);
var
  P: TPrezzo;
begin
  if IndexOf(CodI) <> -1 then begin
    TPrezzo(Taba[CodI]).Prezzo:= vl;
  end
  else begin
    P:= TPrezzo.Create;
    P.Prezzo:= vl;
    Taba[CodI]:= P;
  end;
end;

procedure TfmPrezziInsert.SetUpIndex;
var
  i, N: integer;
  attv: boolean;
begin
  attv:= cbAttivi.Checked;
  case cbOrder.ItemIndex of
    1:   Indx:= dmTaba.Index[imCodS, attv];
    2:   Indx:= dmTaba.Index[imCodI, attv];
    else Indx:= dmTaba.Index[imDesc, attv];
  end;
  N:= dmTaba.NumTab;
  Dati:= TPrezzi.Create(true);
  for i:= 1 to N do begin
    Dati[dmTaba.Index[imCodI, false][i]]:= 0;
  end;
  if attv then N:= dmTaba.NumTabAttv;
  dgPrez.Col:= 3;
  dgPrez.Row:= 1;
  dgPrez.RowCount:= N;
  dgPrez.Invalidate;
end;

procedure TfmPrezziInsert.FormShow(Sender: TObject);
begin
  Showing:= false;
  tbTaba.Open;
  cbOrder.ItemIndex:= 2;
  SetupIndex;
  iDate.Date:= Date;
  dmTaba.DataPrezzi:= iDate.Date;
  iDateChange(nil);;
  iNota.Text:= '';
  dgPrez.Row:= 1;
  dgPrez.Col:= 3;
  Showing:= true;
  Changed:= false;
end;

procedure TfmPrezziInsert.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
  tbPrezMov.IndexFieldNames:= 'PPRE;CODI';
  tbPrezLst.IndexFieldNames:= 'DATA';
end;

procedure TfmPrezziInsert.dgPrezDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  d: double;
begin
  if Row = 0 then begin
    case col of
      0: dgPrez.DrawStr(Rect, 'Cod.', taCenter);
      1: dgPrez.DrawStr(Rect, 'Cod. Sig.', taCenter);
      2: dgPrez.DrawStr(Rect, 'Nome tabacco', taCenter);
      3: dgPrez.DrawStr(Rect, 'Prezzo', taCenter);
    end;
  end
  else begin
    if not tbTaba.FindKey([Indx[Row]]) then exit;
    case Col of
      0: dgPrez.DrawStr(Rect, tbTabaCodI.AsString, taRightJustify);
      1: dgPrez.DrawStr(Rect, tbTabaCodS.AsString, taRightJustify);
      2: dgPrez.DrawStr(Rect, tbTabaDesc.AsString, taLeftJustify);
      3: begin
        d:= Dati[Indx[Row]];
        dgPrez.DrawStr(Rect, Format(fmtSoldi, [d]), taRightJustify);
      end;
    end;
  end;
end;

procedure TfmPrezziInsert.btAddClick(Sender: TObject);
  function SetupLst: integer;
  begin
    tbPrezLst.Open;
    if tbPrezLst.FindKey([iDate.Date]) then tbPrezLst.Edit
    else tbPrezLst.Append;
    tbPrezLstData.Value:= iDate.Date;
    tbPrezLstDesc.Value:= iNota.Text;
    tbPrezLst.Post;
    Result:= tbPrezLstPPRE.Value;
  end;
var
  i, N: integer;
  CodI: integer;
  PPre: integer;
begin
  if cbAttivi.Checked then N:= dmTaba.NumTabAttv
  else N:= dmTaba.NumTab;
  PPre:= SetupLst;
  tbPrezMov.Open;
  for i:= 1 to N do begin
    CodI:= Indx[i];
    if CodI <> 0 then begin
      if tbPrezMov.FindKey([PPre, CodI]) then tbPrezMov.Edit
      else begin
        tbPrezMov.Append;
        tbPrezMovPPre.Value:= PPre;
        tbPrezMovCodI.Value:= CodI;
      end;
      tbPrezMovPrez.Value:= Dati[CodI];
      tbPrezMov.Post;
    end;
  end;
  tbPrezMov.Close;
  dmTaba.UpdatePrezzi;
  Close;
end;

function TfmPrezziInsert.dgPrezAcceptEditKey(Sender: TObject;
  var Key: Char): Boolean;
begin
  Result:= tbPrezMovPrez.IsValidChar(Key);
  if not Result then MessageBeep(0);
end;

procedure TfmPrezziInsert.dgPrezSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  CanSelect:= (Col=3) and (Row<>0);
end;

procedure TfmPrezziInsert.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbTaba.Close;
end;

procedure TfmPrezziInsert.DoSetupIndex(Sender: TObject);
var
  em: boolean;
begin
  em:= dgPrez.EditorMode;
  dgPrez.EditorMode:= false;
  SetupIndex;
  dgPrez.EditorMode:= em;
end;

procedure TfmPrezziInsert.dgPrezSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  vl: longint;
begin
  if (ARow >0) and (ACol=3) then begin
    vl:= Parser.IVal(Trim(Value));
    if Dati[Indx[ARow]] <> vl then begin
      Changed:= true;
      Dati[Indx[ARow]]:= vl;
    end;
  end;
end;

procedure TfmPrezziInsert.iDateChange(Sender: TObject);
var
  Data: TDateTime;
  i, N, ps: integer;
begin
  if cbAttivi.Checked then N:= dmTaba.NumTabAttv
  else N:= dmTaba.NumTab;
  Data:= int(iDate.Date);
  ps:= dmTaba.FindData(dtPrez, Data);
  if (ps>=0) and Showing then begin
    if MessageDlg('Sono gia'' presenti dei prezzi con questa data, continuo?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    dmTaba.DataPrezzi:= iDate.Date;
    for i:= 1 to N do Dati[Indx[i]]:= dmTaba.Prezzo[Indx[i]];
    iNota.Text:= dmTaba.DateList[dtPrez][ps];
    Changed:= false;
    dgPrez.Invalidate;
  end;
end;

procedure TfmPrezziInsert.dgPrezEnter(Sender: TObject);
begin
  dgPrez.EditorMode:= true;
end;

procedure TfmPrezziInsert.dgPrezExit(Sender: TObject);
begin
  dgPrez.EditorMode:= false;
end;

procedure TfmPrezziInsert.btCancelClick(Sender: TObject);
begin
  if (not Changed) or
     (MessageDlg('Sei sicuro di voler abbandonare i dati?', mtInformation, [mbYes, mbNo], 0) = mrYes) then begin
    ModalResult:= mrCancel;
  end;
end;

procedure TfmPrezziInsert.dgPrezGetEditText(Sender: TObject; ACol,
  ARow: Longint; var Value: string);
begin
  with Indx do begin
    if (ACol=3) and (ARow>=RowMin) and (ARow<(RowCnt+RowMin)) then begin
      Value:= IntToStr(Dati[Indx[ARow]]);
    end;
  end;
end;

end.

