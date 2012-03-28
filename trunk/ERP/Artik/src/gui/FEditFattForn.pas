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
unit FEditFattForn;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBTables, DB, DBCtrls,
  Mask, ExtCtrls, RgNav, RgNavDB, Grids, DBGrids, TabNotBk, XStrGrds,
  ComCtrls, JvExDBGrids, JvDBGrid, JvDBControls, JvToolEdit, JvExMask,
  JvBaseEdits;

type
  TfmEditFatFor = class(TForm)
    tbFatForLs: TTable;
    tbFatForMv: TTable;
    dsArticoli: TDataSource;
    dsFatForMv: TDataSource;
    tbArticoli: TTable;
    dsFatForLs: TDataSource;
    tbFatForMvCodMov: TIntegerField;
    tbFatForMvCodAlf: TStringField;
    tbFatForMvCodNum: TIntegerField;
    tbFatForMvQta: TFloatField;
    tbArticoliCodAlf: TStringField;
    tbArticoliCodNum: TSmallintField;
    tbArticoliDesc: TStringField;
    tbArticoliAttv: TBooleanField;
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
    tbFornitori: TTable;
    tbFornitoriCodFor: TIntegerField;
    tbFornitoriNome: TStringField;
    tbFornitoriPotenziale: TBooleanField;
    dsFornitori: TDataSource;
    tbFatForLsNomeForn: TStringField;
    tbFatForMvDesc: TStringField;
    tbFatForMvUM: TStringField;
    tbFatForLsCodFatFor: TIntegerField;
    tbFatForLsCodFor: TIntegerField;
    tbFatForLsNumFatt: TStringField;
    tbFatForLsDataFatt: TDateField;
    tbFatForLsTotaleImp: TCurrencyField;
    tbFatForLsTotaleIVA: TCurrencyField;
    tbFatForMvCodFatFor: TIntegerField;
    tbFatForMvImp: TCurrencyField;
    tbFatForSp: TTable;
    dsFatForSp: TDataSource;
    tbFatForSpCodSpe: TIntegerField;
    tbFatForSpCodFatFor: TIntegerField;
    tbFatForSpImp: TCurrencyField;
    tbFatForSpIVA: TCurrencyField;
    tbFattura: TTabbedNotebook;
    DBGrid1: TDBGrid;
    dgDati: TJvDBGrid;
    Nav: TRGNavigator;
    tbFatForMvIVA: TCurrencyField;
    ScrollBox1: TScrollBox;
    sgTotali: TXStrGrid;
    RxDBCalcEdit2: TJvDBCalcEdit;
    DBDateEdit1: TJvDBDateEdit;
    DBEdit2: TDBEdit;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    RxDBComboEdit1: TJvDBComboEdit;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    RxDBCalcEdit3: TJvDBCalcEdit;
    DBCheckBox1: TDBCheckBox;
    tbFatForLsPreventivo: TBooleanField;
    DBText1: TDBText;
    tbFatForMvElab: TBooleanField;
    procedure tbFatForLsCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RxDBComboEdit1ButtonClick(Sender: TObject);
    procedure tbFatForMvCalcFields(DataSet: TDataset);
    procedure dgDatiKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure tbFatturaChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure sgTotaliGetAlignment(Sender: TObject; ARow, ACol: Longint;
      var AAlignment: TAlignment);
    procedure dgDatiColExit(Sender: TObject);
    procedure dsFatForLsDataChange(Sender: TObject; Field: TField);
    procedure NavClick(Sender: TObject; Button: TAllNavBtn);
    procedure tbFatForMvBeforePost(DataSet: TDataset);
    procedure tbFatForLsAfterPost(DataSet: TDataset);
  private
    { Private declarations }
    procedure CalcTotali;
    procedure Prepara(Tab: integer);
  public
    { Public declarations }
  end;

procedure EditFatFor;

implementation

{$R *.DFM}

uses
  eLibCore, FFindFor, FFindArt, eLibDB, DTabelle;

procedure EditFatFor;
var
  fmEditFatFor: TfmEditFatFor;
begin
  fmEditFatFor:= TfmEditFatFor.Create(Application);
  fmEditFatFor.Show;
end;

procedure TfmEditFatFor.tbFatForLsCalcFields(DataSet: TDataset);
var
 tmp: string;
begin
  tmp:= '';
  if tbFornitori.FindKey([DataSet.FieldByName('CodFor').AsInteger]) then begin
    tmp:= tbFornitoriNome.Value;
  end;
  DataSet.FieldByName('NomeForn').AsString:= tmp;
end;

procedure TfmEditFatFor.FormShow(Sender: TObject);
begin
  tbFornitori.Active:= true;
  tbArticoli.Active:= true;
  tbFatForMv.Active:= true;
  tbFatForSp.Active:= true;
  tbFatForLs.Active:= true;
  tbFattura.PageIndex:= 0;
  Prepara(0);
end;

procedure TfmEditFatFor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbFatForLs.Active:= false;
  tbFatForMv.Active:= false;
  tbFatForSp.Active:= false;
  tbArticoli.Active:= false;
  tbFornitori.Active:= false;
  Action:= caFree;
end;

procedure TfmEditFatFor.RxDBComboEdit1ButtonClick(Sender: TObject);
var
  CodFor: longint;
begin
  CodFor:= tbFatForLSCodFor.Value;
  if FindFornitore(CodFor) then begin
    tbFatForLSCodFor.Value:= CodFor;
  end;
end;

procedure TfmEditFatFor.tbFatForMvCalcFields(DataSet: TDataset);
var
  desc, um: string;
begin
  desc:= '';
  um:= '';
  if tbArticoli.FindKey([DataSet.FieldByName('CodAlf').AsString, DataSet.FieldByName('CodNum').AsInteger]) then begin
    desc:= tbArticoliDesc.Value;
    try
      um  := ITabUM.Desc(tbArticoliCodMis.Value);
    except
      on ETabUM  do um := '';
    end;
  end;
  DataSet.FieldByName('Desc').AsString:= desc;
  try
    DataSet.FieldByName('IVA').AsFloat:= ITabIVA.CalcIVA(DataSet.FieldByName('Imp').AsFloat, tbArticoliCodIVA.Value);
  except
    on ETabIVA do DataSet.FieldByName('IVA').AsString:= '';
  end;
  DataSet.FieldByName('UM').AsString:= um;
end;

procedure TfmEditFatFor.dgDatiKeyPress(Sender: TObject; var Key: Char);
begin
  if dgDati.SelectedField = tbFatForMvCodAlf then Key:= UpCase(Key);
end;

procedure TfmEditFatFor.CalcTotali;
var
  SpeImp, SpeIVA: double;
  VocImp, VocIVA: double;
begin
  SpeImp:= 0; SpeIVA:= 0;
  tbFatForSp.First;
  while not tbFatForSp.EOF do begin
    SpeImp:= SpeImp + tbFAtForSpImp.Value;
    SpeIVA:= SpeIVA + tbFAtForSpIVA.Value;
    tbFatForSp.Next;
  end;
  sgTotali.Cells[1,1]:= Format('%m', [SpeImp]);
  sgTotali.Cells[2,1]:= Format('%m', [SpeIVA]);

  VocImp:= 0; VocIVA:= 0;
  tbFatForMv.First;
  while not tbFatForMv.EOF do begin
    VocImp:= VocImp + tbFAtForMvImp.Value;
    VocIVA:= VocIVA + tbFAtForMVIVA.Value;
    tbFatForMv.Next;
  end;
  sgTotali.Cells[1,2]:= Format('%m', [VocImp]);
  sgTotali.Cells[2,2]:= Format('%m', [VocIVA]);

  sgTotali.Cells[1,3]:= Format('%m', [tbFatForLsTotaleImp.Value - (SpeImp + VocImp)]);
  sgTotali.Cells[2,3]:= Format('%m', [tbFatForLsTotaleIVA.Value - (SpeIVA + VocIVA)]);

end;

procedure TfmEditFatFor.FormActivate(Sender: TObject);
begin
  tbFornitori.Refresh;
  tbArticoli.Refresh;
  tbFatForMv.Refresh;
  tbFatForSp.Refresh;
  tbFatForLs.Refresh;
end;

procedure TfmEditFatFor.tbFatturaChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  try
    case tbFattura.PageIndex of
      0: if (tbFatForLs.State in [dsEdit, dsInsert]) then tbFatForLs.Post;
      1: if (tbFatForSp.State in [dsEdit, dsInsert]) then tbFatForSp.Post;
      2: if (tbFatForMv.State in [dsEdit, dsInsert]) then tbFatForMv.Post;
    end;
  except
    AllowChange:= false;
    raise;
  end;
  if AllowChange then Prepara(NewTab);
end;

procedure TfmEditFatFor.Prepara(Tab: integer);
begin
  case Tab of
    0: begin
      Nav.DataSource:= dsFatForLs;
      Nav.VisibleButtons:= Nav.VisibleButtons - [nbSearch];
    end;
    1: begin
      Nav.DataSource:= dsFatForSp;
      Nav.VisibleButtons:= Nav.VisibleButtons - [nbSearch];
    end;
    2: begin
      Nav.DataSource:= dsFatForMv;
      Nav.VisibleButtons:= Nav.VisibleButtons + [nbSearch];
    end;
  end;
  Nav.DataSource.DataSet.Refresh;
end;

procedure TfmEditFatFor.sgTotaliGetAlignment(Sender: TObject; ARow,
  ACol: Longint; var AAlignment: TAlignment);
begin
  if ARow=0 then AAlignment:= taCenter
  else if ACol<> 0 then AAlignment:= taRightJustify;
end;

procedure TfmEditFatFor.dgDatiColExit(Sender: TObject);
begin
  tbFatForMv.Refresh;
end;

procedure TfmEditFatFor.dsFatForLsDataChange(Sender: TObject;
  Field: TField);
begin
  if (Field=nil) or (Field=tbFatForLsTotaleIVA) or (Field=tbFatForLsTotaleIMP) then begin
    CalcTotali;
  end;
end;

procedure TfmEditFatFor.NavClick(Sender: TObject; Button: TAllNavBtn);
var
  CodAlf: string;
  CodNum: integer;
begin
  if (Button=nbSearch) then begin
    if tbFattura.PageIndex=2 then begin
      CodAlf:= tbFatForMvCodAlf.Value;
      CodNum:= tbFatForMvCodNum.Value;
      if FindArticolo(CodAlf, CodNum) then begin
        DBUtil.SetEdit(dsFatForMv);
        tbFatForMvCodAlf.Value:= CodAlf;
        tbFatForMvCodNum.Value:= CodNum;
      end;
    end;
  end;
end;

procedure TfmEditFatFor.tbFatForMvBeforePost(DataSet: TDataset);
begin
  DataSet.FieldByName('Elab').AsBoolean:= false;
end;

procedure TfmEditFatFor.tbFatForLsAfterPost(DataSet: TDataset);
begin
  tbFatForMv.First;
  while not tbFatForMv.EOF do begin
    tbFatForMv.Edit;
    tbFatForMvElab.Value:= false;
    tbFatForMv.Post;
    tbFatForMv.Next;
  end;
end;

end.

