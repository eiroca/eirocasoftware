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
unit FEleTele;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, Grids, DBGrids, 
  ExtCtrls, Menus, DBLookup, JvFormPlacement, JvBDEQBE, JvComponentBase,
  JvBDEFilter, JvExControls, JvDBLookup, JvExExtCtrls, JvExtComponent,
  JvSpeedbar, JvExDBGrids, JvDBGrid;

type
  TfmEleTelef = class(TForm)
    dgTelef: TJvDBGrid;
    dsTelef: TDataSource;
    flTelef: TJvDBFilter;
    MainMenu1: TMainMenu;
    Operazioni1: TMenuItem;
    SpeedBar1: TJvSpeedBar;
    miExit: TMenuItem;
    cbTipoTel: TComboBox;           
    cbFiltCont: TCheckBox;
    lcContatti: TJvDBLookupCombo;
    cbFiltTipo: TCheckBox;
    tbContat: TTable;
    dsContat: TDataSource;
    miEleTelScrn: TMenuItem;
    miEleTelPrnt: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    miIntPref: TMenuItem;
    miSelfPref: TMenuItem;
    qbeEleTel1: TJvQBEQuery;
    qbeEleTel1Nome_Tit: TStringField;
    qbeEleTel1Nome_Pre1: TStringField;
    qbeEleTel1Nome_Pre2: TStringField;
    qbeEleTel1Nome_Main: TStringField;
    qbeEleTel1Nome_Suf: TStringField;
    qbeEleTel1Classe: TStringField;
    qbeEleTel1Settore: TStringField;
    qbeEleTel1TipoCont: TIntegerField;
    qbeEleTel1Tipo: TIntegerField;
    qbeEleTel1Tel_Pre1: TStringField;
    qbeEleTel1Tel_Pre2: TStringField;
    qbeEleTel1Telefono: TStringField;
    qbeEleTel1Note: TStringField;
    qbeEleTel1CodCon: TIntegerField;
    qbeEleTel1Contat: TStringField;
    qbeEleTel1TelefTipo: TStringField;
    qbeEleTel1Tel: TStringField;
    fpEleTel: TJVFormStorage;
    qbeEleTel2: TJvQBEQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    IntegerField3: TIntegerField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    miEleTelFile: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function flTelefFiltering(Sender: TObject; DataSet: TDataset): Boolean;
    procedure miExitClick(Sender: TObject);
    procedure SpeedBar1ApplyAlign(Sender: TObject; Align: TAlign;
      var Apply: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbFiltTipoClick(Sender: TObject);
    procedure cbFiltContClick(Sender: TObject);
    procedure lcContattiChange(Sender: TObject);
    procedure cbTipoTelChange(Sender: TObject);
    procedure dgTelefCheckButton(Sender: TObject; ACol: Longint;
      Field: TField; var Enabled: Boolean);
    procedure miSelfPrefClick(Sender: TObject);
    procedure qbeEleTelCalcFields(DataSet: TDataset);
    procedure dgTelefTitleBtnClick(Sender: TObject; ACol: Longint;
      Field: TField);
    procedure miEleTelClick(Sender: TObject);
    procedure dgTelefGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
  private
    { Private declarations }
    qry: TJvQBEQuery;
    CurSortFld: integer;
    procedure SelectQuery(Num: integer);
    procedure SetupDataSource(qbe: TJvQBEQuery);
    procedure ShowAll;
    procedure ShowSome(ACodCon: integer);
  public
    { Public declarations }
    CodCon : integer;
    TipoTel: integer;
  end;

function ElencoTelefonico(CodCon: integer): boolean;

implementation

{$R *.DFM}

uses
  uOpzioni, eLibCore, DContat, ContComm;

function ElencoTelefonico(CodCon: integer): boolean;
var
  fmEleTelef: TfmEleTelef;
begin
  Result:= true;
  fmEleTelef:= nil; 
  try
    try
      fmEleTelef:= TfmEleTelef.Create(nil);
      fmEleTelef.CodCon:= CodCon;
      fmEleTelef.ShowModal;
    except
      Result:= false;
    end;
  finally
    fmEleTelef.Free;
  end;
end;

procedure TfmEleTelef.SelectQuery(Num: integer);
var
  QBE: TJvQBEQuery;
begin
  case Num of
    0: begin
      QBE:= qbeEleTel1;
      CurSortFld:= qbeEleTel1.FieldByName('Contat').Index;
    end;
    1: begin
      QBE:= qbeEleTel2;
      CurSortFld:= qbeEleTel2.FieldByName('Tel').Index;
    end;
    else QBE:= nil;
  end;
  if Qry <> QBE then SetupDataSource(QBE)
  else begin
    Qry.FieldByName('Contat').Visible:= (CodCon=0);
    Qry.Refresh;
  end;
end;

procedure TfmEleTelef.SetupDataSource(qbe: TJvQBEQuery);
begin
  if Qry <> nil then begin
    flTelef.Active:= false;
  end;
  Qry:= QBE;
  if Qry <> nil then begin
    Qry.FieldByName('Contat').Visible:= (CodCon=0);
    if dsTelef.DataSet <> Qry then dsTelef.DataSet:= Qry;
    flTelef.Active:= true;
    Qry.Refresh;
  end;
end;

procedure TfmEleTelef.FormShow(Sender: TObject);
begin
  qbeEleTel1.Open;
  qbeEleTel2.Open;
  miIntPref.Checked:= Opzioni.IntPref;
  miSelfPref.Checked:= Opzioni.SelfPref;
  SelectQuery(dgTelef.Tag);
  tbContat.Open;
  TipoTel:= ctTelUltimo+1;
  cbTipoTel.ItemIndex:= 0;
  cbFiltTipo.Checked:= false;
  cbFiltTipo.OnClick(nil);
  lcContatti.Value  := IntToStr(CodCon);
  cbFiltCont.Checked:= (CodCon<>0);
  cbFiltCont.OnClick(nil);
end;

procedure TfmEleTelef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qbeEleTel1.Close;
  qbeEleTel2.Close;
  flTelef.Active:= false;
  tbContat.Close;
end;

function TfmEleTelef.flTelefFiltering(Sender: TObject;
  DataSet: TDataset): Boolean;
var
  Cond1, Cond2: boolean;
begin
  Cond1:= (CodCon=0)  or (DataSet.FieldByName('CodCon').AsInteger=CodCon);
  Cond2:= (TipoTel=(ctTelUltimo+1)) or (DataSet.FieldByName('Tipo').AsInteger=TipoTel);
  Result:= Cond1 and Cond2;
end;

procedure TfmEleTelef.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmEleTelef.SpeedBar1ApplyAlign(Sender: TObject; Align: TAlign;
  var Apply: Boolean);
begin
  Apply:= (Align=alTop) or (Align=alBottom) or (Align=alNone);
end;

procedure TfmEleTelef.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Qry:= nil;
  cbTipoTel.Clear;
  for i:= ctTelPrimo to ctTelUltimo do begin
    cbTipoTel.Items.AddObject(TeleDesc[i], pointer(i));
  end;
end;

procedure TfmEleTelef.cbFiltTipoClick(Sender: TObject);
begin
  cbTipoTel.Enabled:= cbFiltTipo.Checked;
  if cbFiltTipo.Checked then begin
    cbTipoTelChange(nil);
  end
  else begin
    TipoTel:= (ctTelUltimo+1);
    qry.Refresh;
  end;
end;

procedure TfmEleTelef.cbFiltContClick(Sender: TObject);
begin
  lcContatti.Enabled   := cbFiltCont.Checked;
  if cbFiltCont.Checked then begin
    lcContattiChange(nil);
  end
  else begin
    ShowAll;
  end;
end;

procedure TfmEleTelef.ShowAll;
begin
  CodCon:= 0;
  Caption:= 'Elenco telefonico';
  SelectQuery(dgTelef.Tag);
end;

procedure TfmEleTelef.ShowSome(ACodCon: integer);
begin
  CodCon:= ACodCon;
  Caption:= 'Telefoni di '+dmContatti.GetCodConName(CodCon);
  SelectQuery(1);
end;

procedure TfmEleTelef.lcContattiChange(Sender: TObject);
var
  tmp: integer;
begin
  tmp:= Parser.IVal(lcContatti.Value);
  if tmp = 0 then ShowAll
  else begin
    ShowSome(tmp);
  end;
end;

procedure TfmEleTelef.cbTipoTelChange(Sender: TObject);
var
  tmp: integer;
begin
  tmp:= cbTipoTel.ItemIndex;
  if tmp <> -1 then tmp:= integer(cbTipoTel.Items.Objects[tmp])
  else tmp:= ctTelUltimo+1;
  TipoTel:= tmp;
  qry.Refresh;
end;

procedure TfmEleTelef.dgTelefCheckButton(Sender: TObject; ACol: Longint;
  Field: TField; var Enabled: Boolean);
begin
  Enabled:= ((ACol=0) or (ACol=1)) and (CodCon=0);
end;

procedure TfmEleTelef.miSelfPrefClick(Sender: TObject);
var
  MI: TMenuItem;
begin
  MI:= (Sender as TMenuItem);
  MI.Checked:= not MI.Checked;
  qry.Refresh;
end;

procedure TfmEleTelef.qbeEleTelCalcFields(DataSet: TDataset);
var
  Tipo: integer;
begin
  DataSet.FieldByName('Tel').AsString:=
    DecodeTelefono(DataSet, miIntPref.Checked, miSelfPref.Checked, Opzioni.DefPrefix1, Opzioni.DefPrefix2);
  Tipo:= DataSet.FieldByName('Tipo').AsInteger;
  if (Tipo>=ctTelPrimo) and (Tipo<=ctTelUltimo) then begin
    DataSet.FieldByName('TelefTipo').AsString:= TeleDesc[Tipo];
  end
  else begin
    DataSet.FieldByName('TelefTipo').AsString:= '';
  end;
  DataSet.FieldByName('Contat').AsString:= _DecodeNome(DataSet);
end;

procedure TfmEleTelef.dgTelefTitleBtnClick(Sender: TObject; ACol: Longint;
  Field: TField);
begin
  dgTelef.Tag:= ACol;
  SelectQuery(dgTelef.Tag);
end;

procedure TfmEleTelef.miEleTelClick(Sender: TObject);
var
  Device: string;
begin
       if Sender = miEleTelFile then Device:= 'TextFile'
  else if Sender = miEleTelPrnt then Device:= 'Printer'
  else Device:= 'Preview';
//  ReportElencoTelefono('IdxNome', Device);
end;

procedure TfmEleTelef.dgTelefGetBtnParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
  IsDown: Boolean);
begin
  if (CodCon=0) and (Field.Index = CurSortFld) then begin
    AFont.Color:= clHighlight;
  end
  else begin
    AFont.Color:= clBtnText;
  end;
end;

end.

