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
unit FPatOrdCon;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, Dialogs, Db, DBTables, Grids, DBGrids,
  Buttons, Mask, ExtCtrls, JvComponentBase, JvBDEFilter, JvExMask, JvToolEdit;

type
  TfmPatOCons = class(TForm)
    dgPatO: TDBGrid;
    Panel1: TPanel;
    dsPatOLst: TDataSource;
    Panel2: TPanel;
    tbPatOLst: TTable;
    ftPatOLst: TJvDBFilter;
    iDataCons: TJVDateEdit;
    tbPatOLstPPCO: TIntegerField;
    tbPatOLstCODP: TIntegerField;
    tbPatOLstDATA: TDateField;
    tbPatOLstDATAORDI: TDateField;
    tbPatOLstDATAPREZ: TDateField;
    tbPatOLstKGC: TFloatField;
    tbPatOLstVAL: TCurrencyField;
    tbPatName: TTable;
    tbPatNameCODP: TIntegerField;
    tbPatNameNOME: TStringField;
    tbPatOLstPatName: TStringField;
    btConsegna: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dgPatODblClick(Sender: TObject);
    procedure btConsegnaClick(Sender: TObject);
    procedure AbortOperation(DataSet: TDataset);
    procedure tbPatOLstCalcFields(DataSet: TDataset);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure PatOCons;

implementation

{$R *.DFM}

uses
  eLibDB, eLibCore, DTabaC;

procedure TfmPatOCons.FormShow(Sender: TObject);
begin
  iDataCons.Date:= Date;
  tbPatName.Open;
  tbPatOLst.Open;
  ftPatOLst.Active:= true;
  tbPatOLst.Last;
end;

procedure TfmPatOCons.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ftPatOLst.Active:= false;
  tbPatOLst.Close;
  tbPatName.Close;
end;

procedure PatOCons;
var
  fmPatOCons: TfmPatOCons;
begin
  fmPatOCons:= nil;
  try
    fmPatOCons:= TfmPatOCons.Create(nil);
    fmPatOCons.ShowModal;
  finally
    fmPatOCons.Free;
  end;
end;

procedure TfmPatOCons.dgPatODblClick(Sender: TObject);
begin
  btConsegna.Click;
end;

procedure TfmPatOCons.btConsegnaClick(Sender: TObject);
begin
  try
    tbPatOLst.Edit;
    tbPatOLstData.Value:= iDataCons.Date;
    tbPatOLst.Post;
    if tbPatOLst.EOF then Close;
  except
    if tbPatOLst.State = dsEdit then tbPatOLst.Cancel;
  end;
end;

procedure TfmPatOCons.AbortOperation(DataSet: TDataset);
begin
  Abort;
end;              

procedure TfmPatOCons.tbPatOLstCalcFields(DataSet: TDataset);
var
  tmp: string;
begin
  if tbPatName.FindKey([DataSet.FieldByName('CODP').AsInteger]) then begin
    tmp:= tbPatNameNome.Value;
  end
  else begin
    tmp:= '';
  end;
  DataSet.FieldByName('PatName').AsString:= tmp;
end;

end.

