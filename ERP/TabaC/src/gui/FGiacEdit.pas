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
unit FGiacEdit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, Grids, ExtCtrls, Dialogs, Buttons, Db, DBTables, DBGrids,
  RgNav, RgNavDB, JvExExtCtrls, JvSplitter;

type
  TfmGiacEdit = class(TForm)                   
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    dsGiacLst: TDataSource;
    pnList: TPanel;
    pnMovs: TPanel;
    tbGiacLst: TTable;
    tbGiacMov: TTable;
    dsGiacMov: TDataSource;
    tbGiacMovCODI: TSmallintField;
    tbGiacMovDesc: TStringField;
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaDESC: TStringField;
    tbGiacMovCodS: TStringField;
    tbTabaCODS: TStringField;
    btCompleta: TSpeedButton;
    btPack: TSpeedButton;
    tbTabaATTV: TBooleanField;
    tbGiacLstPGIA: TIntegerField;
    tbGiacLstDATA: TDateField;
    tbGiacLstDATAPREZ: TDateField;
    tbGiacLstKGC: TFloatField;
    tbGiacLstVAL: TCurrencyField;
    tbGiacMovPGIA: TIntegerField;
    tbGiacMovGIAC: TIntegerField;
    tbTabaQTAC: TSmallintField;
    navGiac: TRGNavigator;
    tbGiacMovGiacKG: TFloatField;
    RxSplitter1: TJvSplitter;
    procedure AbortOperation(DataSet: TDataset);
    procedure tbGiacMovCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCompletaClick(Sender: TObject);
    procedure btPackClick(Sender: TObject);
    procedure tbGiacLstBeforeDelete(DataSet: TDataset);
    procedure tbGiacMovBeforeDelete(DataSet: TDataset);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
    procedure navGiacClick(Sender: TObject; Button: TAllNavBtn);
  private
    { private declarations }
    ConfDelete: boolean;
  public
    { public declarations }
  end;

procedure GiacEdit;

implementation

{$R *.DFM}

uses
  eLibDB, eLibCore, DTabaC, FStampaGiacenze;

procedure GiacEdit;
var
  fmGiacEdit: TfmGiacEdit;
begin
  fmGiacEdit:= nil;
  try
    fmGiacEdit:= TfmGiacEdit.Create(nil);
    fmGiacEdit.ShowModal;
  finally
    fmGiacEdit.Free;
  end;
end;

procedure TfmGiacEdit.AbortOperation(DataSet: TDataset);
begin
  Abort;
end;

procedure TfmGiacEdit.tbGiacMovCalcFields(DataSet: TDataset);
begin
  if tbTaba.FindKey([tbGiacMovCodI.Value]) then begin
    tbGiacMovDesc.Value:= tbTabaDesc.Value;
    tbGiacMovCodS.Value:= tbTabaCodS.Value;
    tbGiacMovGiacKG.Value:= tbGiacMovGiac.Value / tbTabaQtaC.Value
  end
  else begin
    tbGiacMovDesc.Value:= '<<sconosciuto>>';
    tbGiacMovCodS.Value:= '';
  end;
end;

procedure TfmGiacEdit.FormShow(Sender: TObject);
begin
  tbTaba.Open;
  tbGiacMov.Open;
  tbGiacLst.Open;
  tbGiacLst.Last;
  ConfDelete:= true;
end;

procedure TfmGiacEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not(DBUtil.CheckAbort(dsGiacLst)=mrOk) or not(DBUtil.CheckAbort(dsGiacMov)=mrOk) then Abort;
  tbGiacLst.Close;
  tbGiacMov.Close;
  tbTaba.Close;
end;

procedure TfmGiacEdit.btCompletaClick(Sender: TObject);
var
  CodI: integer;
  PGia: longint;
  OldEvent1,OldEvent2: TDataSetNotifyEvent;
begin
  OldEvent1:= tbGiacMov.OnCalcFields;
  OldEvent2:= tbGiacMov.BeforeInsert;
  try
    Screen.Cursor:= crHourGlass;
    PGia:= tbGiacLstPGia.Value;
    tbGiacMov.DisableControls;
    tbGiacMov.OnCalcFields:= nil;
    tbGiacMov.BeforeInsert:= nil;
    tbTaba.First;
    while not tbTaba.EOF do begin
      if tbTabaAttv.Value then begin
        CodI:= tbTabaCodI.Value;
        if not tbGiacMov.FindKey([PGia, CodI]) then begin
          tbGiacMov.Append;
          tbGiacMovPGia.Value:= PGia;
          tbGiacMovCodI.Value:= CodI;
          tbGiacMovGiac.Value:= 0;
          tbGiacMov.Post;
        end;
      end;
      tbTaba.Next;
    end;
  finally
    tbGiacMov.OnCalcFields:= OldEvent1;
    tbGiacMov.BeforeInsert:= OldEvent2;
    Screen.Cursor:= crDefault;
    tbGiacMov.EnableControls;
    tbGiacMov.First;
    tbGiacMov.Refresh;
  end;
end;

procedure TfmGiacEdit.btPackClick(Sender: TObject);
var
  OldEvent: TDataSetNotifyEvent;
  Mode: boolean;
  KgC, Val: double;
  D: TDateTime;
begin
  Mode:= MessageDlg('Mantengo i dati dei tabacchi ora inattivi?', mtConfirmation, [mbNo, mbYes], 0) = mrNo;
  ConfDelete:= false;
  OldEvent:= tbGiacMov.OnCalcFields;
  KgC:= 0;
  Val:= 0;
  D:= dmTaba.DataPRezzi;
  if not tbGiacLstDataPrez.IsNull then begin
    dmTaba.DataPrezzi:= tbGiacLstDataPrez.Value;
  end;
  try
    Screen.Cursor:= crHourGlass;
    tbGiacMov.DisableControls;
    tbGiacMov.OnCalcFields:= nil;
    tbGiacMov.First;
    while not tbGiacMov.EOF do begin
      if tbGiacMovGiac.Value = 0 then begin
        tbGiacMov.Delete;
        continue;
      end
      else begin
        if Mode then begin
          if tbTaba.FindKey([tbGiacMovCodI.Value]) then begin
            if not tbTabaAttv.Value then begin
              tbGiacMov.Delete;
              continue;
            end;
          end;
        end;
        if tbTaba.FindKey([tbGiacMovCodI.Value]) then begin
          KgC:= KgC + tbGiacMovGiac.Value / tbTabaQtaC.Value;
          Val:= Val + tbGiacMovGiac.Value * dmTaba.Prezzo[tbGiacMovCodI.Value];
        end;
      end;
      tbGiacMov.Next;
    end;
  finally
    tbGiacMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbGiacMov.EnableControls;
    tbGiacMov.First;
    tbGiacMov.Refresh;
  end;
  tbGiacLst.Edit;
  tbGiacLstKgC.Value:= KgC;
  tbGiacLstVal.Value:= Val;
  if tbGiacLstDataPrez.IsNull then begin
    tbGiacLstDataPrez.Value:= dmTaba.DataPrezzi;
  end;
  tbGiacLst.Post;
  dmTaba.DataPrezzi:= D;
  ConfDelete:= true;
end;

procedure TfmGiacEdit.tbGiacLstBeforeDelete(DataSet: TDataset);
var
  OldEvent: TDataSetNotifyEvent;
  procedure Chiude;
  begin
    tbGiacMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbGiacMov.EnableControls;
  end;
begin
  if (MessageDlg('La cancellazione comporterà la distruzione di tutti i dati datati '+
      tbGiacLstData.AsString+'. Proseguo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) and
     (MessageDlg('Ripensamenti?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
    ConfDelete:= false;
    try
      Screen.Cursor:= crHourGlass;
      tbGiacMov.DisableControls;
      OldEvent:= tbGiacMov.OnCalcFields;
      tbGiacMov.OnCalcFields:= nil;
      tbGiacMov.First;
      while not tbGiacMov.EOF do begin
        tbGiacMov.Delete;
      end;
    except
      ConfDelete:= true;
      Chiude;
      Abort;
      exit;
    end;
    ConfDelete:= true;
    Chiude;
  end
  else Abort;
end;

procedure TfmGiacEdit.tbGiacMovBeforeDelete(DataSet: TDataset);
begin
  if ConfDelete and
    (MessageDlg('Cancello il dato?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then Abort;
end;

procedure TfmGiacEdit.FormCreate(Sender: TObject);
begin
  tbGiacMov.IndexFieldNames:= 'PGIA;CODI';
end;

procedure TfmGiacEdit.DBGrid2Enter(Sender: TObject);
begin
   if dsGiacLst.State in [dsInsert, dsEdit] then begin
     dsGiacLst.DataSet.Post;
   end;
   navGiac.DataSource:= dsGiacMov;
end;

procedure TfmGiacEdit.DBGrid2Exit(Sender: TObject);
begin
   navGiac.DataSource:= dsGiacLst;
end;

procedure TfmGiacEdit.navGiacClick(Sender: TObject; Button: TAllNavBtn);
var
  Data: TDateTime;
begin
  if Button = nbPrint then begin
    Data:= tbGiacLstDATA.Value;
    StampaGiacenza(Data);
  end;
end;

end.

