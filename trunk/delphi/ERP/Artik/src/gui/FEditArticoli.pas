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
unit FEditArticoli;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  DBCtrls, DB, DBTables, Mask, ExtCtrls, JvExMask, JvToolEdit, JvDBControls,
  Vcl.StdCtrls, JvExControls, JvDBLookup, RgNav, RgNavDB;

type
  TfmEditArticoli = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    EditCodNum: TDBEdit;
    Label3: TLabel;
    iDesc: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditQta: TDBEdit;
    Label7: TLabel;
    EditQtaInv: TDBEdit;
    Label8: TLabel;
    EditQtaDelta: TDBEdit;
    Label9: TLabel;
    EditQtaAcq: TDBEdit;
    Label10: TLabel;
    EditQtaOrd: TDBEdit;
    Label11: TLabel;
    EditQtaVen: TDBEdit;
    Label12: TLabel;
    EditQtaPre: TDBEdit;
    Label13: TLabel;
    EditQtaSco: TDBEdit;
    Label14: TLabel;
    EditPrzLis: TDBEdit;
    Label15: TLabel;
    EditPrzNor: TDBEdit;
    Label16: TLabel;
    EditPrzSpe: TDBEdit;
    Label17: TLabel;
    EditRicNor: TDBEdit;
    Label18: TLabel;
    EditRicSpe: TDBEdit;
    Label19: TLabel;
    EditPrePriAcq: TDBEdit;
    Label20: TLabel;
    EditPreUltAcq: TDBEdit;
    Label21: TLabel;
    EditDatPriAcq: TDBEdit;
    Label22: TLabel;
    EditDatUltAcq: TDBEdit;
    Label23: TLabel;
    EditCumuloAcq: TDBEdit;
    Label24: TLabel;
    EditCumuloOrd: TDBEdit;
    Panel1: TPanel;
    dsArticoli: TDataSource;
    Panel2: TPanel;
    tbArticoli: TTable;
    tbCodIVA: TTable;
    tbCodMis: TTable;
    RxDBLookupCombo1: TJvDBLookupCombo;
    dsCodIVA: TDataSource;
    dsCodMis: TDataSource;
    RxDBLookupCombo2: TJvDBLookupCombo;
    tbCodIVACodIVA: TSmallintField;
    tbCodIVAAlq: TFloatField;
    tbCodIVADesc: TStringField;
    tbArticoliCodAlf: TStringField;
    tbArticoliCodNum: TSmallintField;
    tbArticoliDesc: TStringField;
    tbArticoliCodIVA: TSmallintField;
    tbArticoliCodMis: TSmallintField;
    tbArticoliQta: TFloatField;
    tbArticoliQtaInv: TFloatField;
    tbArticoliQtaDelta: TFloatField;
    tbArticoliQtaAcq: TFloatField;
    tbArticoliQtaOrd: TFloatField;
    tbArticoliQtaVen: TFloatField;
    tbArticoliQtaPre: TFloatField;
    tbArticoliQtaSco: TFloatField;
    tbArticoliPrzLis: TCurrencyField;
    tbArticoliPrzNor: TCurrencyField;
    tbArticoliPrzSpe: TCurrencyField;
    tbArticoliRicNor: TSmallintField;
    tbArticoliRicSpe: TSmallintField;
    tbArticoliPrePriAcq: TCurrencyField;
    tbArticoliPreUltAcq: TCurrencyField;
    tbArticoliDatPriAcq: TDateField;
    tbArticoliDatUltAcq: TDateField;
    tbArticoliCumuloAcq: TFloatField;
    tbArticoliCumuloOrd: TFloatField;
    tbArticoliSetMer: TStringField;
    DBCheckBox1: TDBCheckBox;
    tbArticoliAttv: TBooleanField;
    RGNavigator1: TRGNavigator;
    iCodAlf: TJvDBComboEdit;
    DBText1: TDBText;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbArticoliCalcFields(DataSet: TDataset);
    procedure RGNavigator1Click(Sender: TObject; Button: TAllNavBtn);
    procedure iCodAlfButtonClick(Sender: TObject);
    procedure iCodAlfChange(Sender: TObject);
    procedure iCodAlfKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure EditArticoli;

implementation

{$R *.DFM}

uses
  DArtik, FSelSetMerc, FFindArt;

procedure EditArticoli;
var
  fmEditArticoli: TfmEditArticoli;
begin
  fmEditArticoli:= TfmEditArticoli.Create(Application);
  fmEditArticoli.Show;
end;

procedure TfmEditArticoli.FormShow(Sender: TObject);
begin
  tbCodMis.Active:= true;
  tbCodIVA.Active:= true;
  tbArticoli.Active:= true;
end;

procedure TfmEditArticoli.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbArticoli.Active:= false;
  tbCodMis.Active:= false;
  tbCodIVA.Active:= false;
  Action:= caFree;
end;

procedure TfmEditArticoli.tbArticoliCalcFields(DataSet: TDataset);
begin
  DataSet.FieldByName('SetMer').AsString:= ISettoriMerc.Desc(Dataset.FieldByName('CodAlf').AsString);
end;

procedure TfmEditArticoli.RGNavigator1Click(Sender: TObject;
  Button: TAllNavBtn);
var
  CodAlf: string;
  CodNum: integer;
begin
  if Button = nbSearch then begin
    CodAlf:= '';
    CodNum:= 0;
    if FindArticolo(CodAlf, CodNum) then begin
      tbArticoli.FindKey([CodAlf, CodNum]);
    end;
  end;
end;

procedure TfmEditArticoli.iCodAlfButtonClick(Sender: TObject);
var
  CodAlf: string;
begin
  CodAlf:= iCodAlf.Text;
  if SelectSetMer(CodAlf, true) then begin
    iCodAlf.Text:= CodAlf;
  end;
end;

procedure TfmEditArticoli.iCodAlfChange(Sender: TObject);
var
  CodAlf: string;
  SetMer: TSettoreMerc;
begin
  if tbArticoliDesc.Value = '' then begin
    CodAlf:= tbArticoliCodAlf.Value;
    if ISettoriMerc.Valid(CodAlf) then begin
      SetMer:= ISettoriMerc.Get(CodAlf);
      if SetMer.IsLeaf then tbArticoliDesc.Value:= SetMer.PreDes;
      SetMer.Free;
    end;
  end;
end;

procedure TfmEditArticoli.iCodAlfKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= UpCase(Key);
end;

procedure TfmEditArticoli.FormActivate(Sender: TObject);
begin
  tbCodMis.Refresh;
  tbCodIVA.Refresh;
  tbArticoli.Refresh;
end;

end.

