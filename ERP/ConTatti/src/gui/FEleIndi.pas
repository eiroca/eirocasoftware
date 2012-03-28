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
unit FEleIndi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, Grids, DBGrids, 
  ExtCtrls, Menus, DBLookup, JvFormPlacement, JvBDEQBE, JvComponentBase,
  JvBDEFilter, JvExDBGrids, JvDBGrid, JvExControls, JvDBLookup, JvExExtCtrls,
  JvExtComponent, JvSpeedbar;

type
  TfmEleIndi = class(TForm)
    dsIndir: TDataSource;
    flIndir: TJvDBFilter;
    MainMenu1: TMainMenu;
    Operazioni1: TMenuItem;
    SpeedBar1: TJvSpeedBar;
    miClose: TMenuItem;
    cbTipoInd: TComboBox;
    cbFiltCont: TCheckBox;         
    lcContatti: TJvDBLookupCombo;
    cbFiltTipo: TCheckBox;
    tbContat: TTable;
    dsContat: TDataSource;
    qbeEleInd: TJvQBEQuery;
    qbeEleIndNote: TStringField;
    qbeEleIndContat: TStringField;
    fpEleTel: TJvFormStorage;
    qbeEleIndTipo: TIntegerField;
    qbeEleIndCodCon: TIntegerField;
    qbeEleIndTipoCont: TIntegerField;
    qbeEleIndNome_Tit: TStringField;
    qbeEleIndNome_Pre1: TStringField;
    qbeEleIndNome_Pre2: TStringField;
    qbeEleIndNome_Main: TStringField;
    qbeEleIndNome_Suf: TStringField;
    qbeEleIndClasse: TStringField;
    qbeEleIndSettore: TStringField;
    qbeEleIndInd: TStringField;
    tbIndir: TTable;
    qbeEleIndCodInd: TIntegerField;
    miConnect: TMenuItem;
    N1: TMenuItem;
    dgIndir: TJvDBGrid;
    N2: TMenuItem;
    miEleIndScrn: TMenuItem;
    miEleIndPrnt: TMenuItem;
    miEleIndFile: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function flIndirFiltering(Sender: TObject; DataSet: TDataset): Boolean;
    procedure miCloseClick(Sender: TObject);
    procedure SpeedBar1ApplyAlign(Sender: TObject; Align: TAlign;
      var Apply: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbFiltTipoClick(Sender: TObject);
    procedure cbFiltContClick(Sender: TObject);
    procedure lcContattiChange(Sender: TObject);
    procedure cbTipoIndChange(Sender: TObject);
    procedure dgIndirCheckButton(Sender: TObject; ACol: Longint;
      Field: TField; var Enabled: Boolean);
    procedure qbeEleIndCalcFields(DataSet: TDataset);
    procedure dgIndirGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure dsIndirDataChange(Sender: TObject; Field: TField);
    procedure miConnectClick(Sender: TObject);
    procedure dgIndirDblClick(Sender: TObject);
    procedure miEleIndClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshQuery(Flt: boolean);
    procedure ShowAll;
    procedure ShowSome(ACodCon: integer);
  public
    { Public declarations }
    CodCon : integer;
    TipoInd: integer;
  end;

function ElencoIndirizzi(CodCon: integer): boolean;

implementation

{$R *.DFM}

uses
  uOpzioni, eLibCore, DContat, ContComm;

function ElencoIndirizzi(CodCon: integer): boolean;
var
  fmEleIndi: TfmEleIndi;
begin
  Result:= true;
  fmEleIndi:= nil; 
  try
    try
      fmEleIndi:= TfmEleIndi.Create(nil);
      fmEleIndi.CodCon:= CodCon;
      fmEleIndi.ShowModal;
    except
      Result:= false;
      raise;
    end;
  finally
    fmEleIndi.Free;
  end;
end;

procedure TfmEleIndi.RefreshQuery(Flt: boolean);
var
  flg: boolean;
begin
  flg:= (CodCon=0);
  if flg <> qbeEleInd.FieldByName('Contat').Visible then begin
    qbeEleInd.FieldByName('Contat').Visible:= flg;
  end;
  if Flt then begin
    flIndir.Active:= false;
    flIndir.Active:= true;
    qbeEleInd.Refresh;
  end;
end;

procedure TfmEleIndi.FormShow(Sender: TObject);
begin
  tbIndir.Open;
  tbContat.Open;
  qbeEleInd.Open;
  TipoInd:= ctIndUltimo+1;
  cbTipoInd.ItemIndex:= 0;
  cbFiltTipo.Checked:= false;
  cbFiltTipo.OnClick(nil);
  lcContatti.Value  := IntToStr(CodCon);
  cbFiltCont.Checked:= (CodCon<>0);
  cbFiltCont.OnClick(nil);
end;

procedure TfmEleIndi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qbeEleInd.Close;
  flIndir.Active:= false;
  tbContat.Close;
  tbIndir.Close;
end;

function TfmEleIndi.flIndirFiltering(Sender: TObject;
  DataSet: TDataset): Boolean;
var
  Cond1, Cond2: boolean;
begin
  Cond1:= (CodCon=0)  or (DataSet.FieldByName('CodCon').AsInteger=CodCon);
  Cond2:= (TipoInd=(ctIndUltimo+1)) or (DataSet.FieldByName('Tipo').AsInteger=TipoInd);
  Result:= Cond1 and Cond2;
end;

procedure TfmEleIndi.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmEleIndi.SpeedBar1ApplyAlign(Sender: TObject; Align: TAlign;
  var Apply: Boolean);
begin
  Apply:= (Align=alTop) or (Align=alBottom) or (Align=alNone);
end;

procedure TfmEleIndi.FormCreate(Sender: TObject);
var
  i: integer;
begin
  cbTipoInd.Clear;
  for i:= ctIndPrimo to ctIndUltimo do begin
    cbTipoInd.Items.AddObject(IndiDesc[i], pointer(i));
  end;
end;

procedure TfmEleIndi.cbFiltTipoClick(Sender: TObject);
begin
  cbTipoInd.Enabled:= cbFiltTipo.Checked;
  if cbFiltTipo.Checked then begin
    cbTipoIndChange(nil);
  end
  else begin
    TipoInd:= (ctIndUltimo+1);
    RefreshQuery(true);
  end;
end;

procedure TfmEleIndi.cbFiltContClick(Sender: TObject);
begin
  lcContatti.Enabled   := cbFiltCont.Checked;
  if cbFiltCont.Checked then begin
    lcContattiChange(nil);
  end
  else begin
    ShowAll;
  end;
end;

procedure TfmEleIndi.ShowAll;
begin
  CodCon:= 0;
  Caption:= 'Elenco indirizzi';
  RefreshQuery(true);
end;

procedure TfmEleIndi.ShowSome(ACodCon: integer);
begin
  CodCon:= ACodCon;
  Caption:= 'Recapiti di '+dmContatti.GetCodConName(CodCon);
  RefreshQuery(true);
end;

procedure TfmEleIndi.lcContattiChange(Sender: TObject);
var
  tmp: integer;
begin
  tmp:= Parser.IVal(lcContatti.Value);
  if tmp = 0 then ShowAll
  else begin
    ShowSome(tmp);
  end;
end;

procedure TfmEleIndi.cbTipoIndChange(Sender: TObject);
var
  tmp: integer;
begin
  tmp:= cbTipoInd.ItemIndex;
  if tmp <> -1 then tmp:= integer(cbTipoInd.Items.Objects[tmp])
  else tmp:= ctIndUltimo+1;
  TipoInd:= tmp;
  RefreshQuery(true);
end;

procedure TfmEleIndi.dgIndirCheckButton(Sender: TObject; ACol: Longint;
  Field: TField; var Enabled: Boolean);
begin
  Enabled:= false;
end;

procedure TfmEleIndi.qbeEleIndCalcFields(DataSet: TDataset);
begin
  tbIndir.FindKey([DataSet.FieldByName('CodInd').AsInteger]);
  DataSet.FieldByName('Ind').AsString:= _DecodeIndirizzo(tbIndir);
  DataSet.FieldByName('Contat').AsString:= _DecodeNome(DataSet);
end;

procedure TfmEleIndi.dgIndirGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if Field = qbeEleIndInd then begin
    if qbeEleIndTipo.Value = AK_ELETTRONICO then begin
      if not HighLight then AFont.Color:= clHighLight;
    end;
  end;
end;

procedure TfmEleIndi.dsIndirDataChange(Sender: TObject; Field: TField);
begin
  if qbeEleIndTipo.Value = AK_ELETTRONICO then begin
    miConnect.Enabled:= true;
  end
  else begin
    miConnect.Enabled:= false;
  end;
end;

procedure TfmEleIndi.miConnectClick(Sender: TObject);
begin
  dmContatti.OpenIndir(qbeEleIndCodCon.Value, qbeEleIndTipo.Value, qbeEleIndInd.Value);
end;

procedure TfmEleIndi.dgIndirDblClick(Sender: TObject);
begin
  dmContatti.OpenIndir(qbeEleIndCodCon.Value, qbeEleIndTipo.Value, qbeEleIndInd.Value);
end;

procedure TfmEleIndi.miEleIndClick(Sender: TObject);
var
  Device: string;
begin
       if Sender = miEleIndFile then Device:= 'TextFile'
  else if Sender = miEleIndPrnt then Device:= 'Printer'
  else Device:= 'Preview';
//  ReportElencoIndirizzi('IdxNome', Device);
end;

end.

