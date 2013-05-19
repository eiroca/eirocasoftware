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
unit FOrdiEdit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, DBTables, Grids, ExtCtrls,
  Dialogs, Buttons, RgNav, RgNavDB, JvComponentBase, JvBDEFilter, JvExExtCtrls,
  JvSplitter;

type
  TfmOrdiEdit = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    pnOrdi: TPanel;
    dsOrdiLst: TDataSource;
    pnOrdiList: TPanel;
    pnOrdiMovi: TPanel;
    tbOrdiLst: TTable;
    tbOrdiMov: TTable;
    dsOrdiMov: TDataSource;
    tbOrdiMovCODI: TSmallintField;
    tbOrdiMovDesc: TStringField;
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaDESC: TStringField;
    tbOrdiMovCodS: TStringField;
    tbTabaCODS: TStringField;
    btCompleta: TSpeedButton;
    btPack: TSpeedButton;
    tbTabaATTV: TBooleanField;
    tbTabaQTAC: TSmallintField;
    tbOrdiLstPCAR: TIntegerField;
    tbOrdiLstDATA: TDateField;
    tbOrdiLstDATAORDI: TDateField;
    tbOrdiLstDATAPREZ: TDateField;
    tbOrdiLstKGC: TFloatField;
    tbOrdiLstVAL: TCurrencyField;
    tbOrdiMovPCAR: TIntegerField;
    tbOrdiMovCARI: TIntegerField;
    ftOrdiLst: TJvDBFilter;
    cbDaRice: TCheckBox;
    tbOrdiMovCariKG: TFloatField;
    navOrdi: TRGNavigator;
    RxSplitter1: TJvSplitter;
    procedure AbortOperation(DataSet: TDataset);
    procedure tbOrdiMovCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCompletaClick(Sender: TObject);
    procedure btPackClick(Sender: TObject);
    procedure tbOrdiLstBeforeDelete(DataSet: TDataset);
    procedure tbOrdiMovBeforeDelete(DataSet: TDataset);
    procedure FormCreate(Sender: TObject);
    procedure cbDaRiceClick(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
    procedure navOrdiClick(Sender: TObject; Button: TAllNavBtn);
  private
    { private declarations }
    ConfDelete: boolean;
    DaRice: boolean;
  public
    { public declarations }
  end;

procedure OrdiEdit(DaRice: boolean);

implementation

{$R *.DFM}

uses
  eLibDB, eLibCore, DTabaC, FStampaOrdList;

procedure OrdiEdit(DaRice: boolean);
var
  fmOrdiEdit: TfmOrdiEdit;
begin
  fmOrdiEdit:= nil;
  try
    fmOrdiEdit:= TfmOrdiEdit.Create(nil);
    fmOrdiEdit.DaRice:= DaRice;
    fmOrdiEdit.ShowModal;
  finally
    fmOrdiEdit.Free;
  end;
end;

procedure TfmOrdiEdit.AbortOperation(DataSet: TDataset);
begin
  Abort;
end;

procedure TfmOrdiEdit.tbOrdiMovCalcFields(DataSet: TDataset);
begin
  if tbTaba.FindKey([tbOrdiMovCodI.Value]) then begin
    tbOrdiMovDesc.Value:= tbTabaDesc.Value;
    tbOrdiMovCodS.Value:= tbTabaCodS.Value;
    tbOrdiMovCariKG.Value:= tbOrdiMovCari.Value / tbTabaQtaC.Value
  end
  else begin
    tbOrdiMovDesc.Value:= '<<sconosciuto>>';
    tbOrdiMovCodS.Value:= '';
  end;
end;

procedure TfmOrdiEdit.FormShow(Sender: TObject);
begin
  tbTaba.Open;
  tbOrdiMov.Open;
  tbOrdiLst.Open;
  ftOrdiLst.Active:= DaRice;
  cbDaRice.Checked:= DaRice;
  tbOrdiLst.Last;
  ConfDelete:= true;
end;

procedure TfmOrdiEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not(DBUtil.CheckAbort(dsOrdiLst)=mrOk) or not(DBUtil.CheckAbort(dsOrdiMov)=mrOk) then Abort;
  ftOrdiLst.Active:= false;
  tbOrdiLst.Close;
  tbOrdiMov.Close;
  tbTaba.Close;
end;

procedure TfmOrdiEdit.btCompletaClick(Sender: TObject);
var
  CodI: integer;
  PCar: longint;
  OldEvent1,OldEvent2: TDataSetNotifyEvent;
begin
  OldEvent1:= tbOrdiMov.OnCalcFields;
  OldEvent2:= tbOrdiMov.BeforeInsert;
  try
    Screen.Cursor:= crHourGlass;
    PCar:= tbOrdiLstPCar.Value;
    tbOrdiMov.DisableControls;
    tbOrdiMov.OnCalcFields:= nil;
    tbOrdiMov.BeforeInsert:= nil;
    tbTaba.First;
    while not tbTaba.EOF do begin
      if tbTabaAttv.Value then begin
        CodI:= tbTabaCodI.Value;
        if not tbOrdiMov.FindKey([PCar, CodI]) then begin
          tbOrdiMov.Append;
          tbOrdiMovPCar.Value:= PCar;
          tbOrdiMovCodI.Value:= CodI;
          tbOrdiMovCari.Value:= 0;
          tbOrdiMov.Post;
        end;
      end;
      tbTaba.Next;
    end;
  finally
    tbOrdiMov.OnCalcFields:= OldEvent1;
    tbOrdiMov.BeforeInsert:= OldEvent2;
    Screen.Cursor:= crDefault;
    tbOrdiMov.EnableControls;
    tbOrdiMov.First;
    tbOrdiMov.Refresh;
  end;
end;

procedure TfmOrdiEdit.btPackClick(Sender: TObject);
var
  OldEvent: TDataSetNotifyEvent;
  Mode: boolean;
  KgC, Val: double;
  D: TDateTime;
begin
  Mode:= MessageDlg('Mantengo i dati dei tabacchi ora inattivi?', mtConfirmation, [mbNo, mbYes], 0) = mrNo;
  ConfDelete:= false;
  OldEvent:= tbOrdiMov.OnCalcFields;
  KgC:= 0;
  Val:= 0;
  D:= dmTaba.DataPRezzi;
  if not tbOrdiLstDataPrez.IsNull then begin
    dmTaba.DataPrezzi:= tbOrdiLstDataPrez.Value;
  end;
  try
    Screen.Cursor:= crHourGlass;
    tbOrdiMov.DisableControls;
    tbOrdiMov.OnCalcFields:= nil;
    tbOrdiMov.First;
    while not tbOrdiMov.EOF do begin
      if tbOrdiMovCari.Value = 0 then begin
        tbOrdiMov.Delete;
      end
      else begin
        if Mode and (tbTaba.FindKey([tbOrdiMovCodI.Value])) and (not tbTabaAttv.Value) then begin
          tbOrdiMov.Delete;
        end
        else begin
          if tbTaba.FindKey([tbOrdiMovCodI.Value]) then begin
            KgC:= KgC + tbOrdiMovCari.Value / tbTabaQtaC.Value;
            Val:= Val + tbOrdiMovCari.Value * dmTaba.Prezzo[tbOrdiMovCodI.Value];
          end
          else begin
            ShowMessage('Non trovato '+tbOrdiMovCodI.AsString);
          end;
          tbOrdiMov.Next;
        end;
      end;
    end;
  finally
    tbOrdiMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbOrdiMov.EnableControls;
    tbOrdiMov.First;
    tbOrdiMov.Refresh;   
  end;
  tbOrdiLst.Edit;
  tbOrdiLstKgC.Value:= KgC;
  tbOrdiLstVal.Value:= Val;
  if tbOrdiLstDATAORDI.IsNull then begin
    tbOrdiLstDATAORDI.Value:= tbOrdiLstDATA.Value-7;
  end;
  if tbOrdiLstDATAprez.IsNull then begin
    tbOrdiLstDATAPREZ.Value:= dmTaba.DataPrezzi;
  end;
  tbOrdiLst.Post;
  dmTaba.DataPrezzi:= D;
  ConfDelete:= true;
end;

procedure TfmOrdiEdit.tbOrdiLstBeforeDelete(DataSet: TDataset);
var
  OldEvent: TDataSetNotifyEvent;
  procedure Chiude;
  begin
    tbOrdiMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbOrdiMov.EnableControls;
  end;
begin
  if (MessageDlg('La cancellazione comporterà la distruzione di tutti i dati datati '+
      tbOrdiLstData.AsString+'. Proseguo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) and
     (MessageDlg('Ripensamenti?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
    ConfDelete:= false;
    try
      Screen.Cursor:= crHourGlass;
      tbOrdiMov.DisableControls;
      OldEvent:= tbOrdiMov.OnCalcFields;
      tbOrdiMov.OnCalcFields:= nil;
      tbOrdiMov.First;
      while not tbOrdiMov.EOF do begin
        tbOrdiMov.Delete;
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

procedure TfmOrdiEdit.tbOrdiMovBeforeDelete(DataSet: TDataset);
begin
  if ConfDelete and
    (MessageDlg('Cancello il dato?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then Abort;
end;

procedure TfmOrdiEdit.FormCreate(Sender: TObject);
begin
  DaRice:= true;
end;

procedure TfmOrdiEdit.cbDaRiceClick(Sender: TObject);
begin
  ftOrdiLst.Active:= cbDaRice.Checked;
end;

procedure TfmOrdiEdit.DBGrid2Enter(Sender: TObject);
begin
   if dsOrdiLst.State in [dsInsert, dsEdit] then begin
     dsOrdiLst.DataSet.Post;
   end;
   navOrdi.DataSource:= dsOrdiMov;
end;

procedure TfmOrdiEdit.DBGrid2Exit(Sender: TObject);
begin
   navOrdi.DataSource:= dsOrdiLst;
end;

procedure TfmOrdiEdit.navOrdiClick(Sender: TObject; Button: TAllNavBtn);
var
  Data: TDateTime;
begin
  if Button = nbPrint then begin
    Data:= tbOrdiLstDATAORDI.Value;
    StampaOrdine(Data);
  end;
end;

end.

