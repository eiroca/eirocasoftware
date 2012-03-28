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
unit FEdtGrp;

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Dialogs, Buttons, ExtCtrls, DBTables, DB, Grids, DBGrids, DBCtrls,
  JvComponentBase, JvFormPlacement, JvExDBGrids, JvDBGrid;

type
  TfmEditGruppi = class(TForm)
    fpEdtGrp: TJvFormPlacement;
    tbGruppi: TTable;
    dsGruppi: TDataSource;
    RxDBGrid1: TJvDBGrid;
    tbGruppiCodGrp: TIntegerField;             
    tbGruppiDesc: TStringField;
    tbGruppiCanc: TStringField;
    tbInGruppo: TTable;
    btOk: TBitBtn;
    DBNavigator1: TDBNavigator;
    procedure tbGruppiCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbGruppiBeforeDelete(DataSet: TDataset);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure EditGruppi;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

procedure EditGruppi;
var
  fmEditGruppi: TfmEditGruppi;
begin
  fmEditGruppi:= nil;
  try
    fmEditGruppi:= TfmEditGruppi.Create(nil);
    fmEditGruppi.ShowModal;
  finally
    fmEditGruppi.Free;
  end;
end;

procedure TfmEditGruppi.tbGruppiCalcFields(DataSet: TDataset);
begin
  if tbInGruppo.FindKey([tbGruppiCodGrp.Value]) then begin
    tbGruppiCanc.Value:= '';
  end
  else begin
    tbGruppiCanc.Value:= 'X';
  end;
end;

procedure TfmEditGruppi.FormShow(Sender: TObject);
begin
  tbInGruppo.Open;
  tbGruppi.Open;
end;

procedure TfmEditGruppi.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbInGruppo.Close;
  tbGruppi.Close;
end;

procedure TfmEditGruppi.tbGruppiBeforeDelete(DataSet: TDataset);
begin
  if DataSet.FieldByName('Canc').AsString = '' then begin
    if MessageDlg('La cancellazione del gruppo comporterà anche la cancellazione delle associazioni dei Contatti '+
      'con il gruppo specificato. Proseguo?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Abort;
  end;
  while tbInGruppo.FindKey([tbGruppiCodGrp.Value]) do begin
    tbInGruppo.Delete;
  end;
end;

end.

