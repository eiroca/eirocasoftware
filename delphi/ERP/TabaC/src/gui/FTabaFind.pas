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
 * Ultima modifica: 24 ott 1999
 *)
unit FTabaFind;

interface

uses                                              
  SysUtils, WinProcs, WinTypes, Messages, Classes, Graphics, 
  Forms, Dialogs, DTabaC, DB, DBTables, StdCtrls, Buttons,
  Controls, Grids, DBGrids, JvComponentBase, JvBDEFilter;
  
type
  TfmTabaFind = class(TForm)
    DBGrid1: TDBGrid;
    iSearch: TEdit;
    cbOrder: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    tbTaba: TTable;
    dsTaba: TDataSource;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaDESC: TStringField;
    tbTabaPREZ: TCurrencyField;
    rxFilter: TJvDBFilter;
    tbTabaATTV: TBooleanField;
    procedure cbOrderChange(Sender: TObject);
    procedure iSearchKeyPress(Sender: TObject; var Key: Char);
    procedure iSearchChange(Sender: TObject);
    procedure tbTabaCalcFields(DataSet: TDataset);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function rxFilterFiltering(Sender: TObject;
      DataSet: TDataset): Boolean;
  private
    SrchFld: TField;
    FCodI  : integer;
  public
    property CodI: integer read FCodI write FCodI;
  end;

function FindTaba(var CodI: integer): TModalResult;

implementation

{$R *.DFM}

uses
  eLibCore;

var
  fmTabaFind: TfmTabaFind;

procedure TfmTabaFind.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
  case cbOrder.ItemIndex of
    1: SrchFld:= tbTabaCodS;
    2: SrchFld:= tbTabaCodI;
    else SrchFld:= tbTabaDesc;
  end;
  iSearch.Text := '';
end;

procedure TfmTabaFind.iSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(SrchFld) and (Key > ' ') and not (SrchFld.IsValidChar(Key)) then begin
    MessageBeep(0);
    Key:= #0;
  end;
end;

procedure TfmTabaFind.iSearchChange(Sender: TObject);
begin
  if iSearch.Text <> '' then
    tbTaba.FindNearest([iSearch.Text]);
end;

procedure TfmTabaFind.tbTabaCalcFields(DataSet: TDataset);
begin
  tbTabaPREZ.Value:= dmTaba.Prezzo[DataSet.FieldByName('CodI').AsInteger];
end;

procedure TfmTabaFind.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
  SrchFld:= nil;
end;

procedure TfmTabaFind.FormShow(Sender: TObject);
begin
  tbTaba.Active:= true;
  rxFilter.Active:= true;
  tbTaba.IndexName:= '';
  tbTaba.FindKey([CodI]);
  cbOrder.ItemIndex := 0;
  cbOrderChange(nil);
  Caption:= 'Seleziona un tabacco';
  ActiveControl:= iSearch;
end;

procedure TfmTabaFind.DBGrid1DblClick(Sender: TObject);
begin
  btOk.Click;
end;

procedure TfmTabaFind.btOkClick(Sender: TObject);
begin
  CodI:= tbTabaCodI.Value;
end;

procedure TfmTabaFind.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  rxFilter.Active:= false;
  tbTaba.Active:= false;
end;

function TfmTabaFind.rxFilterFiltering(Sender: TObject;
  DataSet: TDataset): Boolean;
begin
  Result:= DataSet.FieldByName('ATTV').AsBoolean;
end;

function FindTaba(var CodI: integer): TModalResult;
begin
  if fmTabaFind = nil then begin
    fmTabaFind:= TfmTabaFind.Create(Application);
  end;
  fmTabaFind.CodI:= CodI;
  Result:= fmTabaFind.ShowModal;
  if Result = mrOk then CodI:= fmTabaFind.CodI;
end;

initialization
  fmTabaFind:= nil;
end.

