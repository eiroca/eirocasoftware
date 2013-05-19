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
unit FPrezziEdit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, DBTables, Grids, ExtCtrls,
  Dialogs, Buttons, RgNav, RgNavDB, JvExExtCtrls, JvSplitter;

type
  TfmPrezziEdit = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    dsPrezLst: TDataSource;
    pnList: TPanel;
    pnMovs: TPanel;
    tbPrezLst: TTable;
    tbPrezMov: TTable;
    dsPrezMov: TDataSource;
    tbPrezMovPPRE: TIntegerField;
    tbPrezMovCODI: TSmallintField;
    tbPrezMovDesc: TStringField;
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaDESC: TStringField;
    tbPrezMovCodS: TStringField;
    tbTabaCODS: TStringField;
    btCompleta: TSpeedButton;
    btPack: TSpeedButton;
    tbTabaATTV: TBooleanField;
    tbPrezLstPPRE: TIntegerField;
    tbPrezLstDATA: TDateField;
    tbPrezLstDESC: TStringField;
    tbPrezMovPREZ: TCurrencyField;
    navPrez: TRGNavigator;
    RxSplitter1: TJvSplitter;
    procedure AbortOperation(DataSet: TDataset);
    procedure tbPrezMovCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCompletaClick(Sender: TObject);
    procedure btPackClick(Sender: TObject);
    procedure tbPrezLstBeforeDelete(DataSet: TDataset);
    procedure tbPrezMovBeforeDelete(DataSet: TDataset);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
    procedure navPrezClick(Sender: TObject; Button: TAllNavBtn);
  private
    { private declarations }
    ConfDelete: boolean;
  public
    { public declarations }
  end;

procedure PrezziEdit;

implementation

{$R *.DFM}

uses
  eLibDB, eLibCore, DTabaC, FStampaPrezzi;

procedure PrezziEdit;
var
  fmPrezziEdit: TfmPrezziEdit;
begin
  fmPrezziEdit:= nil;
  try
    fmPrezziEdit:= TfmPrezziEdit.Create(nil);
    fmPrezziEdit.ShowModal;
  finally
    fmPrezziEdit.Free;
  end;
end;

procedure TfmPrezziEdit.AbortOperation(DataSet: TDataset);
begin
  Abort;
end;

procedure TfmPrezziEdit.tbPrezMovCalcFields(DataSet: TDataset);
begin
  if tbTaba.FindKey([tbPrezMovCodI.Value]) then begin
    tbPrezMovDesc.Value:= tbTabaDesc.Value;
    tbPrezMovCodS.Value:= tbTabaCodS.Value;
  end
  else begin
    tbPrezMovDesc.Value:= '<<sconosciuto>>';
    tbPrezMovCodS.Value:= '';
  end;
end;

procedure TfmPrezziEdit.FormShow(Sender: TObject);
begin
  tbTaba.Open;
  tbPrezMov.Open;
  tbPrezLst.Open;
  tbPrezLst.Last;
  ConfDelete:= true;
end;

procedure TfmPrezziEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not(DBUtil.CheckAbort(dsPrezLst)=mrOk) or not(DBUtil.CheckAbort(dsPrezMov)=mrOk) then Abort;
  tbPrezLst.Close;
  tbPrezMov.Close;
  tbTaba.Close;
  dmTaba.LoadPrezzi;
end;

procedure TfmPrezziEdit.btCompletaClick(Sender: TObject);
var
  CodI: integer;
  PPre: longint;
  OldEvent1,OldEvent2: TDataSetNotifyEvent;
begin
  OldEvent1:= tbPrezMov.OnCalcFields;
  OldEvent2:= tbPrezMov.BeforeInsert;
  try
    Screen.Cursor:= crHourGlass;
    PPre:= tbPrezLstPPre.Value;
    tbPrezMov.DisableControls;
    tbPrezMov.OnCalcFields:= nil;
    tbPrezMov.BeforeInsert:= nil;
    tbTaba.First;
    while not tbTaba.EOF do begin
      if tbTabaAttv.Value then begin
        CodI:= tbTabaCodI.Value;
        if not tbPrezMov.FindKey([PPre, CodI]) then begin
          tbPrezMov.Append;
          tbPrezMovPPre.Value:= PPRe;
          tbPrezMovCodI.Value:= CodI;
          tbPrezMovPrez.Value:= 0;
          tbPrezMov.Post;
        end;
      end;
      tbTaba.Next;
    end;
  finally
    tbPrezMov.OnCalcFields:= OldEvent1;
    tbPrezMov.BeforeInsert:= OldEvent2;
    Screen.Cursor:= crDefault;
    tbPrezMov.EnableControls;
    tbPrezMov.First;
    tbPrezMov.Refresh;
  end;
end;

procedure TfmPrezziEdit.btPackClick(Sender: TObject);
var
  OldEvent: TDataSetNotifyEvent;
  Mode: boolean;
begin
  Mode:= MessageDlg('Mantengo i prezzi dei tabacchi ora inattivi?', mtConfirmation, [mbNo, mbYes], 0) = mrNo;
  ConfDelete:= false;
  OldEvent:= tbPrezMov.OnCalcFields;
  try
    Screen.Cursor:= crHourGlass;
    tbPrezMov.DisableControls;
    tbPrezMov.OnCalcFields:= nil;
    tbPrezMov.First;
    while not tbPrezMov.EOF do begin
      if tbPrezMovPrez.Value = 0 then begin
        tbPrezMov.Delete;
        continue;
      end
      else begin
        if Mode then begin
          if tbTaba.FindKey([tbPrezMovCodI.Value]) then begin
            if not tbTabaAttv.Value then begin
              tbPrezMov.Delete;
              continue;
            end;
          end;
        end;
      end;
      tbPrezMov.Next;
    end;
  finally
    tbPrezMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbPrezMov.EnableControls;
    tbPrezMov.First;
    tbPrezMov.Refresh;
  end;
  ConfDelete:= true;
end;

procedure TfmPrezziEdit.tbPrezLstBeforeDelete(DataSet: TDataset);
var
  OldEvent: TDataSetNotifyEvent;
  procedure Chiude;
  begin
    tbPrezMov.OnCalcFields:= OldEvent;
    Screen.Cursor:= crDefault;
    tbPrezMov.EnableControls;
  end;
begin
  if (MessageDlg('La cancellazione comporterà la distruzione di tutti i prezzi datati '+
      tbPrezLstData.AsString+'. Proseguo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) and
     (MessageDlg('Ripensamenti?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
    ConfDelete:= false;
    try
      Screen.Cursor:= crHourGlass;
      tbPrezMov.DisableControls;
      OldEvent:= tbPrezMov.OnCalcFields;
      tbPrezMov.OnCalcFields:= nil;
      tbPrezMov.First;
      while not tbPrezMov.EOF do begin
        tbPrezMov.Delete;
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

procedure TfmPrezziEdit.tbPrezMovBeforeDelete(DataSet: TDataset);
begin
  if ConfDelete and
    (MessageDlg('Cancello il prezzo?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then Abort;
end;

procedure TfmPrezziEdit.FormCreate(Sender: TObject);
begin
  tbPrezMov.IndexFieldNames:= 'PPRE;CODI';
end;

procedure TfmPrezziEdit.DBGrid2Enter(Sender: TObject);
begin
   navPrez.DataSource:= dsPrezMov;
end;

procedure TfmPrezziEdit.DBGrid2Exit(Sender: TObject);
begin
   navPrez.DataSource:= dsPrezLst;
end;

procedure TfmPrezziEdit.navPrezClick(Sender: TObject; Button: TAllNavBtn);
var
  Data: TDateTime;
begin
  if Button = nbPrint then begin
    Data:= tbPrezLstDATA.Value;
    StampaListinoTabacchi(Data);
  end;
end;

end.

