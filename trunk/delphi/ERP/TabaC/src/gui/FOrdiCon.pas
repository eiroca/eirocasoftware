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
unit FOrdiCon;

interface

uses                            
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Db, DBTables, Grids, DBGrids, StdCtrls, Mask,
  Buttons, ExtCtrls, JvComponentBase, JvBDEFilter, JvExMask, JvToolEdit;

type
  TfmOrdiCons = class(TForm)
    dgOrdi: TDBGrid;
    Panel1: TPanel;
    dsOrdiLst: TDataSource;
    Panel2: TPanel;
    tbOrdiLst: TTable;
    tbOrdiLstPCAR: TIntegerField;
    tbOrdiLstDATA: TDateField;
    tbOrdiLstDATAORDI: TDateField;
    tbOrdiLstDATAPREZ: TDateField;
    tbOrdiLstKGC: TFloatField;
    tbOrdiLstVAL: TCurrencyField;
    ftOrdiLst: TJvDBFilter;
    btConsegna: TBitBtn;
    iDataCons: TJvDateEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dgOrdiDblClick(Sender: TObject);
    procedure btConsegnaClick(Sender: TObject);
    procedure AbortOperation(DataSet: TDataset);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure OrdiCons;

implementation

{$R *.DFM}

uses
  eLibDB, eLibCore, DTabaC;

procedure TfmOrdiCons.FormShow(Sender: TObject);
begin
  iDataCons.Date:= Date;
  tbOrdiLst.Open;
  ftOrdiLst.Active:= true;
  tbOrdiLst.Last;
end;

procedure TfmOrdiCons.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ftOrdiLst.Active:= false;
  tbOrdiLst.Close;
end;

procedure OrdiCons;
var
  fmOrdiCons: TfmOrdiCons;
begin
  fmOrdiCons:= nil;
  try
    fmOrdiCons:= TfmOrdiCons.Create(nil);
    fmOrdiCons.ShowModal;
  finally
    fmOrdiCons.Free;
  end;
end;

procedure TfmOrdiCons.dgOrdiDblClick(Sender: TObject);
begin
  btConsegna.Click;
end;

procedure TfmOrdiCons.btConsegnaClick(Sender: TObject);
begin
  try
    tbOrdiLst.Edit;
    tbOrdiLstData.Value:= iDataCons.Date;
    tbOrdiLst.Post;
    if tbOrdiLst.EOF then Close;
  except
    if tbOrdiLst.State = dsEdit then tbOrdiLst.Cancel;
  end;
end;

procedure TfmOrdiCons.AbortOperation(DataSet: TDataset);
begin
  Abort;
end;

end.

