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
unit FPatOrdEdit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, DBTables, Grids, ExtCtrls,
  Dialogs, Buttons, RgNav, RgNavDB, JvComponentBase, JvBDEFilter;

type
  TfmPatOEdit = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    dsPatOLst: TDataSource;
    Panel2: TPanel;
    Panel3: TPanel;
    tbPatOLst: TTable;
    tbPatOMov: TTable;
    dsPatOMov: TDataSource;
    tbPatOMovDesc: TStringField;
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaDESC: TStringField;
    tbPatOMovCodS: TStringField;
    tbTabaCODS: TStringField;
    btCompleta: TSpeedButton;
    btPack: TSpeedButton;
    tbTabaATTV: TBooleanField;
    tbTabaQTAC: TSmallintField;
    ftPatOLst: TJvDBFilter;
    cbDaRice: TCheckBox;
    tbPatName: TTable;
    tbPatNameCODP: TIntegerField;
    tbPatNameNOME: TStringField;
    tbPatOLstPPCO: TIntegerField;
    tbPatOLstCODP: TIntegerField;
    tbPatOLstDATA: TDateField;
    tbPatOLstDATAORDI: TDateField;
    tbPatOLstDATAPREZ: TDateField;
    tbPatOLstKGC: TFloatField;
    tbPatOLstVAL: TCurrencyField;
    tbPatOMovPPCO: TIntegerField;
    tbPatOMovCODI: TSmallintField;
    tbPatOMovCONS: TIntegerField;
    tbPatOLstPatName: TStringField;
    navPatO: TRGNavigator;
    tbPatOMovConsKG: TFloatField;
    procedure AbortOperation(DataSet: TDataset);
    procedure tbPatOMovCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCompletaClick(Sender: TObject);
    procedure btPackClick(Sender: TObject);
    procedure tbPatOLstBeforeDelete(DataSet: TDataset);
    procedure tbPatOMovBeforeDelete(DataSet: TDataset);
    procedure FormCreate(Sender: TObject);
    procedure cbDaRiceClick(Sender: TObject);
    procedure tbPatOLstCalcFields(DataSet: TDataset);
    procedure navPatOClick(Sender: TObject; Button: TAllNavBtn);
    procedure DBGrid2Enter(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
  private
    { private declarations }
    ConfDelete: boolean;
    DaRice: boolean;
  public
    { public declarations }
  end;

procedure PatOEdit(DaRice: boolean);

implementation

{$R *.DFM}

uses
  eLibDB, eLibCore, DTabaC, FStampaPatOrdLs;

procedure TfmPatOEdit.AbortOperation(DataSet: TDataset);
begin
  Abort;
end;

procedure TfmPatOEdit.tbPatOMovCalcFields(DataSet: TDataset);
begin
  if tbTaba.FindKey([tbPatOMovCodI.Value]) then begin
    tbPatOMovDesc.Value:= tbTabaDesc.Value;
    tbPatOMovCodS.Value:= tbTabaCodS.Value;
    tbPatOMovConsKG.Value:= tbPatOMovCons.Value / tbTabaQtaC.Value
  end
  else begin
    tbPatOMovDesc.Value:= '<<sconosciuto>>';
    tbPatOMovCodS.Value:= '';
  end;
end;

procedure TfmPatOEdit.FormShow(Sender: TObject);
begin
  tbTaba.Open;
  tbPatName.Open;
  tbPatOMov.Open;
  tbPatOLst.Open;
  ftPatOLst.Active:= DaRice;
  cbDaRice.Checked:= DaRice;
  tbPatOLst.Last;
  ConfDelete:= true;
end;

procedure TfmPatOEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not(DBUtil.CheckAbort(dsPatOLst)=mrOk) or not(DBUtil.CheckAbort(dsPatOMov)=mrOk) then Abort;
  ftPatOLst.Active:= false;
  tbPatOLst.Close;
  tbPatOMov.Close;
  tbPatName.Close;
  tbTaba.Close;
end;

procedure TfmPatOEdit.btCompletaClick(Sender: TObject);
var
  CodI: integer;
  PPCo: longint;
  OldEvent1,OldEvent2: TDataSetNotifyEvent;
begin
  OldEvent1:= tbPatOMov.OnCalcFields;
  OldEvent2:= tbPatOMov.BeforeInsert;
  try
    Screen.Cursor:= crHourGlass;
    PPCo:= tbPatOLstPPCo.Value;
    tbPatOMov.DisableControls;
    tbPatOMov.OnCalcFields:= nil;
    tbPatOMov.BeforeInsert:= nil;
    tbTaba.First;
    while not tbTaba.EOF do begin
      if tbTabaAttv.Value then begin
        CodI:= tbTabaCodI.Value;
        if not tbPatOMov.FindKey([PPCo, CodI]) then begin
          tbPatOMov.Append;
          tbPatOMovPPCo.Value:= PPCo;
          tbPatOMovCodI.Value:= CodI;
          tbPatOMovCons.Value:= 0;
          tbPatOMov.Post;
        end;
      end;
      tbTaba.Next;
    end;
  finally
    tbPatOMov.OnCalcFields:= OldEvent1;
    tbPatOMov.BeforeInsert:= OldEvent2;
    Screen.Cursor:= crDefault;
    tbPatOMov.EnableControls;
    tbPatOMov.First;
    tbPatOMov.Refresh;
  end;
end;

procedure TfmPatOEdit.btPackClick(Sender: TObject);
var
  OldEvent: TDataSetNotifyEvent;
  Mode: boolean;
  KgC, Val: double;
  D: TDateTime;
begin
  Mode:= MessageDlg('Mantengo i dati dei tabacchi ora inattivi?', mtConfirmation, [mbNo, mbYes], 0) = mrNo;
  ConfDelete:= false;
  OldEvent:= tbPatOMov.OnCalcFields;
  KgC:= 0;
  Val:= 0;
  D:= dmTaba.DataPRezzi;
  if not tbPatOLstDataPrez.IsNull then begin
    dmTaba.DataPrezzi:= tbPatOLstDataPrez.Value;
  end;
  try
    Screen.Cursor:= crHourGlass;
    tbPatOMov.DisableControls;
    tbPatOMov.OnCalcFields:= nil;
    tbPatOMov.First;
    while not tbPatOMov.EOF do begin
      if tbPatOMovCons.Value = 0 then begin
        tbPatOMov.Delete;
        continue;
      end
      else begin
        if Mode then begin
          if tbTaba.FindKey([tbPatOMovCodI.Value]) then begin
            if not tbTabaAttv.Value then begin
              tbPatOMov.Delete;
              continue;
            end;
          end;
        end;
        if tbTaba.FindKey([tbPatOMovCodI.Value]) then begin
          KgC:= KgC + tbPatOMovCons.Value / tbTabaQtaC.Value;
          Val:= Val + tbPatOMovCons.Value * dmTaba.Prezzo[tbPatOMovCodI.Value];
        end;
      end;
      tbPatOMov.Next;
    end;
  finally
    tbPatOMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbPatOMov.EnableControls;
    tbPatOMov.First;
    tbPatOMov.Refresh;   
  end;
  tbPatOLst.Edit;
  tbPatOLstKgC.Value:= KgC;
  tbPatOLstVal.Value:= Val;
  if tbPatOLstDATAORDI.IsNull then begin
    tbPatOLstDATAORDI.Value:= tbPatOLstDATA.Value-7;
  end;
  if tbPatOLstDATAprez.IsNull then begin
    tbPatOLstDATAPREZ.Value:= dmTaba.DataPrezzi;
  end;
  tbPatOLst.Post;
  dmTaba.DataPrezzi:= D;
  ConfDelete:= true;
end;

procedure TfmPatOEdit.tbPatOLstBeforeDelete(DataSet: TDataset);
var
  OldEvent: TDataSetNotifyEvent;
  procedure Chiude;
  begin
    tbPatOMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbPatOMov.EnableControls;
  end;
begin
  if (MessageDlg('La cancellazione comporterà la distruzione di tutti i dati datati '+
      tbPatOLstData.AsString+'. Proseguo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) and
     (MessageDlg('Ripensamenti?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
    ConfDelete:= false;
    try
      Screen.Cursor:= crHourGlass;
      tbPatOMov.DisableControls;
      OldEvent:= tbPatOMov.OnCalcFields;
      tbPatOMov.OnCalcFields:= nil;
      tbPatOMov.First;
      while not tbPatOMov.EOF do begin
        tbPatOMov.Delete;
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

procedure TfmPatOEdit.tbPatOMovBeforeDelete(DataSet: TDataset);
begin
  if ConfDelete and
    (MessageDlg('Cancello il dato?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then Abort;
end;

procedure TfmPatOEdit.FormCreate(Sender: TObject);
begin
  DaRice:= true;
end;

procedure TfmPatOEdit.cbDaRiceClick(Sender: TObject);
begin
  ftPatOLst.Active:= cbDaRice.Checked;
end;

procedure PatOEdit(DaRice: boolean);
var
  fmPatOEdit: TfmPatOEdit;
begin
  fmPatOEdit:= nil;
  try
    fmPatOEdit:= TfmPatOEdit.Create(nil);
    fmPatOEdit.DaRice:= DaRice;
    fmPatOEdit.ShowModal;
  finally
    fmPatOEdit.Free;
  end;
end;

procedure TfmPatOEdit.tbPatOLstCalcFields(DataSet: TDataset);
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


procedure TfmPatOEdit.navPatOClick(Sender: TObject; Button: TAllNavBtn);
begin
  if Button = nbPrint then begin
    StampaRichiestaPatentino(tbPatOLstPPCO.Value);
  end;
end;

procedure TfmPatOEdit.DBGrid2Enter(Sender: TObject);
begin
   if dsPatOLst.State in [dsInsert, dsEdit] then begin
     dsPatOLst.DataSet.Post;
   end;
   navPatO.DataSource:= dsPatOMov;
end;

procedure TfmPatOEdit.DBGrid2Exit(Sender: TObject);
begin
   navPatO.DataSource:= dsPatOLst;
end;

end.

