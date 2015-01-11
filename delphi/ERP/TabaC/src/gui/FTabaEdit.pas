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
 * Ultima modifica: 24 ott 1999
 *)
unit FTabaEdit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, Dialogs, DB, DBTables, DBLookup, DBCtrls, Mask, 
  Buttons, ExtCtrls, RgNav, RgNavDB, JvExControls, JvSpin;

type
  TfmTabaEdit = class(TForm)
    ScrollBox: TScrollBox;
    lbCodI: TLabel;
    Label2: TLabel;
    iCodS: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    iDesc: TDBEdit;
    Label8: TLabel;
    iMulI: TDBEdit;
    Label9: TLabel;
    iQTAS: TDBEdit;
    Label10: TLabel;
    iQTAC: TDBEdit;
    Label11: TLabel;
    iQTAM: TDBEdit;
    Label12: TLabel;
    iDIFR: TDBEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    tbTaba: TTable;
    iCodI: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    dsTabaTipo: TDataSource;
    DBLookupCombo1: TDBLookupCombo;
    DBLookupCombo2: TDBLookupCombo;
    dsTabaProd: TDataSource;
    DBLookupCombo3: TDBLookupCombo;
    tbTabaCrit: TTable;
    dsTabaCrit: TDataSource;
    cbOrder: TComboBox;
    tbTabaTipo: TTable;
    tbTabaProd: TTable;
    dsTaba: TDataSource;
    sbQtaS: TJvSpinButton;
    sbQtaC: TJvSpinButton;
    sbDifr: TJvSpinButton;
    sbQtaM: TJvSpinButton;
    sbMulI: TJvSpinButton;
    lbPrezzo: TLabel;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaTIPO2: TSmallintField;
    tbTabaPROD2: TSmallintField;
    tbTabaCRIT2: TSmallintField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    tbTabaMULI: TSmallintField;
    tbTabaQTAS: TSmallintField;
    tbTabaQTAC: TSmallintField;
    tbTabaQTAM: TSmallintField;
    tbTabaDIFR: TSmallintField;
    navTaba: TRGNavigator;
    Label1: TLabel;
    lbDataPrezzi: TLabel;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbOrderChange(Sender: TObject);
    procedure sbQtaSBottomClick(Sender: TObject);
    procedure sbQtaSTopClick(Sender: TObject);
    procedure sbQtaCBottomClick(Sender: TObject);
    procedure sbQtaCTopClick(Sender: TObject);
    procedure sbDifrBottomClick(Sender: TObject);
    procedure sbDifrTopClick(Sender: TObject);
    procedure sbQtaMBottomClick(Sender: TObject);
    procedure sbQtaMTopClick(Sender: TObject);
    procedure sbMulIBottomClick(Sender: TObject);
    procedure sbMulITopClick(Sender: TObject);
    procedure tbKTabaValidate(Sender: TField);
    procedure dsTabaDataChange(Sender: TObject; Field: TField);
    procedure navTabaClick(Sender: TObject; Button: TAllNavBtn);
    procedure BitBtn1Click(Sender: TObject);
    procedure tbTabaAfterPost(DataSet: TDataSet);
  private
    { private declarations }
    procedure Processa(Spin: TJvSpinButton; const F: TField; sgn: integer; min: integer);
  public
    { public declarations }
  end;

procedure TabaEdit;

implementation

{$R *.DFM}

uses
  eLibCore, eLibVCL, eLibDB,
  FTabaFind, DTabaC, FStampaTabacchi;

procedure TfmTabaEdit.FormShow(Sender: TObject);
begin
  tbTabaTipo.Open;
  tbTabaProd.Open;
  tbTabaCrit.Open;
  tbTaba.Open;
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
  lbDataPrezzi.Caption:= 'Prezzi del '+DateUtil.myDateToStr(dmTaba.DataPrezzi);
end;

procedure TfmTabaEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DBUtil.CheckAbort(dsTaba) = mrCancel then Abort;
  tbTaba.Close;
  tbTabaTipo.Close;
  tbTabaProd.Close;
  tbTabaCrit.Close;
  dmTaba.UpdateTaba;
end;

procedure TfmTabaEdit.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmTabaEdit.cbOrderChange(Sender: TObject);
begin
  if DBUtil.CheckAbort(dsTaba) = mrOk then begin
    tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
  end
  else begin
    cbOrder.ItemIndex:= dmTaba.EncodeOrder(tbTaba.IndexName);
  end;
end;

procedure TfmTabaEdit.Processa(Spin: TJVSpinButton; const F: TField; sgn: integer; min: integer);
var
  v: longint;
begin
  DBUtil.SetEdit(dsTaba);
  if F <> tbTabaMulI then begin
    v:= F.AsInteger + tbTabaMulI.AsInteger * sgn;
    if (v < min) then v:= min;
    if (Spin.Tag>0) and (v>Spin.Tag) then v:= Spin.Tag;
    F.AsInteger:= v;
  end
  else begin
    tbTabaMulI.Value:= tbTabaMulI.Value + sgn;
  end;
end;

procedure TfmTabaEdit.sbQtaSBottomClick(Sender: TObject);
begin
  Processa(sbQtaS, tbTabaQtaS, -1, 0);
end;

procedure TfmTabaEdit.sbQtaSTopClick(Sender: TObject);
begin
  Processa(sbQtaS, tbTabaQtaS,  1, 0);
end;

procedure TfmTabaEdit.sbQtaCBottomClick(Sender: TObject);
begin
  Processa(sbQtaC, tbTabaQtaC, -1, 0);
end;

procedure TfmTabaEdit.sbQtaCTopClick(Sender: TObject);
begin
  Processa(sbQtaC, tbTabaQtaC,  1, 0);
end;

procedure TfmTabaEdit.sbDifrBottomClick(Sender: TObject);
begin
  Processa(sbDifr, tbTabaDifr, -1, -tbTabaQtaC.Value);
end;

procedure TfmTabaEdit.sbDifrTopClick(Sender: TObject);
begin
  Processa(sbDifr, tbTabaDifr,  1, -tbTabaQtaC.Value);
end;

procedure TfmTabaEdit.sbQtaMBottomClick(Sender: TObject);
begin
  Processa(sbQtaM, tbTabaQtaM, -1, 0);
end;

procedure TfmTabaEdit.sbQtaMTopClick(Sender: TObject);
begin
  Processa(sbQtaM, tbTabaQtaM,  1, 0);
end;

procedure TfmTabaEdit.sbMulIBottomClick(Sender: TObject);
begin
  Processa(sbMulI, tbTabaMulI, -1, 0);
end;

procedure TfmTabaEdit.sbMulITopClick(Sender: TObject);
begin
  Processa(sbMulI, tbTabaMulI,  1, 0);
end;

procedure TfmTabaEdit.dsTabaDataChange(Sender: TObject; Field: TField);
begin
  if (Field = nil) or (Field = tbTabaCodI) then begin
    lbPrezzo.Caption:= Format('Prezzo corrente %m', [int(dmTaba.Prezzo[tbTabaCodI.Value])]);
  end;
end;

procedure TfmTabaEdit.tbKTabaValidate(Sender: TField);
var
  ok: boolean;
begin
  ok:= true;
  if Sender = tbTabaDesc then begin
    if tbTabaDesc.Text = '' then begin
      Ok:= false;
      ActiveControl:= iDesc;
      MessageDlg('Deve essere presente una descrizione', mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaCodS then begin
    if tbTabaCodS.Text = '' then begin
      Ok:= false;
      ActiveControl:= iCodS;
      MessageDlg('Deve essere presente un codice sigaretta', mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaCodI then begin
    if (tbTabaCodI.Value <= 0) or (tbTabaCodI.Value > 32767) then begin
      Ok:= false;
      ActiveControl:= iCodI;
      MessageDlg('Il codice interno deve essere un numero compreso tra 1 e 32767', mtError, [mbOk], 0);
    end
    else if dmTaba.ValidCodI(tbTabaCodI.Value) then begin
      Ok:= false;
      ActiveControl:= iCodI;
      MessageDlg('Esiste già un tabacco con il medesimo codice interno', mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaQtaS then begin
    if (tbTabaQtaS.Value <= 0) or (tbTabaQtaS.Value > sbQtaS.Tag) then begin
      Ok:= false;
      ActiveControl:= iQtaS;
      MessageDlg('La scorta deve essere un numero compreso tra 1 e '+IntToStr(sbQtaS.Tag), mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaQtaC then begin
    if (tbTabaQtaC.Value <= 0) or (tbTabaQtaC.Value > sbQtaC.Tag) then begin
      Ok:= false;
      ActiveControl:= iQtaC;
      MessageDlg('La quantità di pacchetti in un kg convenzionale deve essere un numero compreso tra 1 e '+
        IntToStr(sbQtaC.Tag), mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaQtaM then begin
    if (tbTabaQtaM.Value <= 0) or (tbTabaQtaM.Value > sbQtaM.Tag) then begin
      Ok:= false;
      ActiveControl:= iQtaM;
      MessageDlg('La quantità minima ordinabile deve essere un numero compreso tra 1 e '+
        IntToStr(sbQtaM.Tag), mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaMulI then begin
    if (tbTabaMulI.Value <= 0) or (tbTabaMulI.Value > sbMulI.Tag) then begin
      Ok:= false;
      ActiveControl:= iMulI;
      MessageDlg('La quantità di pacchetti in una stecca deve essere un numero compreso tra 1 e '+
        IntToStr(sbMulI.Tag), mtError, [mbOk], 0);
    end;
  end
  else if Sender = tbTabaDifr then begin
    if (tbTabaDifr.Value <= 0) or (tbTabaDifr.Value > sbDifr.Tag) then begin
      Ok:= false;
      ActiveControl:= iDifr;
      MessageDlg('La quantità di pacchetti in una stecca deve essere un numero compreso tra 1 e '+
        IntToStr(sbDifr.Tag), mtError, [mbOk], 0);
    end;
  end;
  if not Ok then Abort;
end;

procedure TfmTabaEdit.navTabaClick(Sender: TObject; Button: TAllNavBtn);
var
  CodI: integer;
begin
  if Button = nbSearch then begin
    CodI:= 1;
    if FindTaba(CodI) = mrOk then begin
      tbTaba.Locate('CODI', CodI, []);
    end;
  end
  else if Button = nbInsert then begin
    ActiveControl:= iCodI;
  end
  else if Button = nbPrint then begin
    StampaTabacchi;
  end;
end;

procedure TabaEdit;
var
  fmTabaEdit: TfmTabaEdit;
begin
  fmTabaEdit:= nil; 
  try
    fmTabaEdit:= TfmTabaEdit.Create(nil);
    fmTabaEdit.ShowModal;
  finally
    fmTabaEdit.Free;
  end;
end;

procedure TfmTabaEdit.BitBtn1Click(Sender: TObject);
var
  num: integer;
  step: integer;
  Prog: TProgress;
begin
  if (MessageDlg('La rinumerazione comporterà il cambiamento di tutti i codici interni. Proseguo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) and
     (MessageDlg('Ripensamenti?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
    num:= tbTaba.RecordCount;
    Prog:= TProgress.Create(1, num*2+1);
    try
      step:= 2;
      if (num*step>32000) then step:= 1;
      try
        tbTaba.DisableControls;
        tbTaba.First;
        num := 0;
        while not tbTaba.EOF do begin
          if (tbTabaCODI.Value<>num) then begin
            tbTaba.Edit;
            tbTabaCODI.Value:= num;
            tbTaba.Post;
          end;
          inc(num);
          tbTaba.Next;
          Prog.Step;
        end;
        num:= num*step;
        tbTaba.Last;
        while not tbTaba.BOF do begin
          if (tbTabaCODI.Value<>num) then begin
            tbTaba.Edit;
            tbTabaCODI.Value:= num;
            tbTaba.Post;
          end;
          dec(num, step);
          tbTaba.Prior;
          Prog.Step;
        end;
      finally
        tbTaba.EnableControls;
      end;
      dmTaba.UpdateTaba;
    finally
      Prog.Free;
    end;
  end;
end;

procedure TfmTabaEdit.tbTabaAfterPost(DataSet: TDataSet);
begin
  dmTaba.UpdateTaba;
  tbTaba.Refresh;
end;

end.

