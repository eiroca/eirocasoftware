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
unit FNickIRC;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, RgNav, RgNavDB, DBCtrls, DB,
  DBTables, Mask, Grids, DBGrids, eDB;

type
  TfmNick4IRC = class(TForm)
    tbIndir: TTable;
    tbIndirCodInd: TIntegerField;
    tbIndirCodCon: TIntegerField;
    tbIndirTipo: TIntegerField;
    tbIndirIndirizzo: TMemoField;
    tbIndirNote: TStringField;
    tbIndirIndir: TStringField;
    tbTelef: TTable;
    tbTelefCodTel: TIntegerField;
    tbTelefCodCon: TIntegerField;
    tbTelefTel_Pre1: TStringField;
    tbTelefTel_Pre2: TStringField;
    tbTelefTelefono: TStringField;
    tbTelefTelef: TStringField;
    tbTelefTelefTipo: TStringField;
    tbTelefNote: TStringField;
    tbContat: TTable;
    tbContatCodCon: TIntegerField;
    tbContatTipo: TIntegerField;
    tbContatNome_Tit: TStringField;
    tbContatNome_Pre1: TStringField;
    tbContatNome_Pre2: TStringField;
    tbContatNome_Main: TStringField;
    tbContatNome_Suf: TStringField;
    tbContatClasse: TStringField;
    tbContatSettore: TStringField;
    tbContatNote: TMemoField;
    tbContatNome: TStringField;
    DBMessage: TDBMessageLink;
    DBConnection: TDBConnectionLink;
    dsContat: TDataSource;
    dsIndir: TDataSource;
    dsNickName: TDataSource;
    dsTelef: TDataSource;
    tbIndir2: TTable;
    tbIndir2CodInd: TIntegerField;
    tbIndir2CodCon: TIntegerField;
    tbIndir2Tipo: TIntegerField;
    tbIndir2Indirizzo: TMemoField;
    tbIndir2Note: TStringField;
    qryNickName: TQuery;
    Panel1: TPanel;
    Label1: TLabel;
    iNickName: TEdit;
    DBGrid1: TDBGrid;
    cbFilter: TCheckBox;
    Panel2: TPanel;
    RGNavigator1: TRGNavigator;
    RGNavigator2: TRGNavigator;
    RGNavigator3: TRGNavigator;
    meIndir: TDBMemo;
    iNome: TDBEdit;
    iTelef: TDBEdit;
    lTelef: TLabel;
    lNome: TLabel;
    lIndir: TLabel;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    DBText1: TDBText;
    tbTelefTipo: TIntegerField;
    BitBtn2: TBitBtn;
    btConnect: TBitBtn;
    qryNickNameCodCon: TIntegerField;
    qryNickNameNickName: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure tbContatCalcFields(DataSet: TDataset);
    procedure tbIndirCalcFields(DataSet: TDataset);
    procedure tbTelefCalcFields(DataSet: TDataset);
    procedure iNickNameChange(Sender: TObject);
    procedure dsNickNameDataChange(Sender: TObject; Field: TField);
    procedure DBConnectionConnect(Sender: TeDataBase; Connect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ProcessKey(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure cbFilterClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure dsIndirDataChange(Sender: TObject; Field: TField);
    procedure dsContatDataChange(Sender: TObject; Field: TField);
    procedure dsTelefDataChange(Sender: TObject; Field: TField);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    Find: string;
    function Select(CodCon: longint): boolean;
    procedure OpenTables;
    procedure CloseTables;
  public
    { Public declarations }
  end;

procedure ShowNick4IRC(CodCon: longint);

implementation

{$R *.DFM}

uses
  eLibCore, eLibDB, ContComm,
  DContat;

var
  fmNick4IRC: TfmNick4IRC;

procedure ShowNick4IRC(CodCon: longint);
begin
  if fmNick4IRC = nil then begin
    Application.CreateForm(TfmNick4IRC, fmNick4IRC);
  end;
  fmNick4IRC.Show;
  if CodCon > 0 then begin
    fmNick4IRC.Select(CodCon);
  end;
end;

procedure TfmNick4IRC.FormCreate(Sender: TObject);
begin
  DBConnection.DataBase:= dmContatti.DB;
  DBMessage.DataBase:= dmContatti.DB;
  qryNickName.SQL.Clear;
  qryNickName.SQL.Add('select CodCon, NickName from NickName where LOWER(NickName) like :aNickName');
  qryNickName.ParamByName('aNickName').DataType:= ftString;
end;

function TfmNick4IRC.Select(CodCon: longint): boolean;
begin
  if tbContat.Active then begin
    Result:= tbContat.FindKey([CodCon]);
  end
  else Result:= false;
end;

procedure TfmNick4IRC.tbContatCalcFields(DataSet: TDataset);
begin
  tbContatNome.Value:= _DecodeNome(DataSet);
end;

procedure TfmNick4IRC.tbIndirCalcFields(DataSet: TDataset);
begin
  if tbIndir2.FindKey([DataSet.FieldByName('CodInd').AsInteger]) then begin
    tbIndirIndir.Value:= _DecodeIndirizzo(tbIndir2);
  end;
end;

procedure TfmNick4IRC.tbTelefCalcFields(DataSet: TDataset);
var
  Tipo: integer;
begin
  tbTelefTelef.Value:= _DecodeTelefono(DataSet);
  Tipo:= DataSet.FieldByName('Tipo').AsInteger;
  if (Tipo>=ctTelPrimo) and (Tipo<=ctTelUltimo) then begin
    tbTelefTelefTipo.Value:= TeleDesc[Tipo];
  end
  else begin
    tbTelefTelefTipo.Value:= '';
  end;
end;

procedure TfmNick4IRC.iNickNameChange(Sender: TObject);
begin
  if cbFilter.Checked then begin
    qryNickName.ParamByName('aNickName').AsString:= '%'+Trim(LowerCase(iNickName.Text))+'%';
    qryNickName.Close;
    qryNickName.Open;
  end;
end;

procedure TfmNick4IRC.dsNickNameDataChange(Sender: TObject; Field: TField);
begin
  Select(qryNickNameCodCon.Value);
end;

procedure TfmNick4IRC.OpenTables;
begin
  tbIndir2.Active:= true;
  tbIndir.Active:= true;
  tbTelef.Active:= true;
  tbContat.Active:= true;
  qryNickName.Active:= true;
  cbFilterClick(nil);
end;

procedure TfmNick4IRC.CloseTables;
begin
  tbIndir2.Active:= false;
  tbIndir.Active:= false;
  tbTelef.Active:= false;
  tbContat.Active:= false;
  qryNickName.Active:= false;
end;

procedure TfmNick4IRC.DBConnectionConnect(Sender: TeDataBase; Connect: Boolean);
begin
  if Connect then begin
    OpenTables;
  end
  else begin
    CloseTables;
  end;
end;

procedure TfmNick4IRC.FormShow(Sender: TObject);
begin
  btConnect.Enabled:= false;
  cbFilter.Checked:= false;
  iNickName.Text:= '';
  Find:= '';
  OpenTables;
  DBConnection.Active:= true;
  DBMessage.Active:= true;
  iNickName.Text:= '';
end;

procedure TfmNick4IRC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DBConnection.Active:= false;
  DBMessage.Active:= false;
  CloseTables;
  {$IFDEF FREEONCLOSE}
  Action:= caFree;
  {$ENDIF}
end;

procedure TfmNick4IRC.ProcessKey(Sender: TObject; var Key: Char);
var
  Found: boolean;
begin
  if not (Key in [#0..#31]) then begin
    Found:= qryNickName.Locate('NickName', Find+Key, []);
    if Found then Find:= Find + key
    else begin
      Found:= qryNickName.Locate('NickName', Key, []);
      if Found then begin
        Find:= Key;
      end
      else Find:= '';
    end;
  end;
end;

procedure TfmNick4IRC.FormDestroy(Sender: TObject);
begin
  {$IFDEF FREEONCLOSE}
  fmContatti:= nil;
  {$ENDIF}
end;

procedure TfmNick4IRC.cbFilterClick(Sender: TObject);
begin
  if cbFilter.Checked then iNickNameChange(nil)
  else begin
    qryNickName.ParamByName('aNickName').AsString:= '%';
    qryNickName.Close;
    qryNickName.Open;
  end;
end;

procedure TfmNick4IRC.btConnectClick(Sender: TObject);
begin
  dmContatti.OpenIndir(tbIndirCodCon.Value, tbIndirTipo.Value, tbIndirIndir.Value);
end;

procedure TfmNick4IRC.dsIndirDataChange(Sender: TObject; Field: TField);
var
  Nota: string;
begin
  Nota:= tbIndirNote.Value;
  if Nota = '' then Nota:= 'nessuna nota';
  lIndir.Hint:= Nota;
  meIndir.Hint:= Nota;
  case tbIndirTipo.Value of
    ctIndTradiz: begin
      btConnect.Enabled:= false;
      meIndir.Font.Color:= clBtnText;
    end;
    else begin (* elettronico *)
      btConnect.Enabled:= true;
      meIndir.Font.Color:= clHighLight;
    end;
  end;
end;

procedure TfmNick4IRC.dsContatDataChange(Sender: TObject; Field: TField);
var
  S: TStrings;
  tmp, nota: string;
  i: integer;
begin
  S:= nil;
  Nota:= '';
  try
    S:= TStringList.Create;
    S.Assign(tbContatNote);
    for i:= 0 to S.Count-1 do begin
      tmp:= Trim(S.Strings[i]);
      if length(tmp)+length(Nota) > 250 then break;
      if Nota <> '' then Nota:= Nota + #13 + tmp
      else Nota:= tmp;
    end;
  finally
    S.Free;
    if Nota = '' then Nota:= 'nessuna nota';
    iNome.Hint:= Nota;
    lNome.Hint:= Nota;
  end
end;

procedure TfmNick4IRC.dsTelefDataChange(Sender: TObject; Field: TField);
var
  Nota: string;
begin
  Nota:= tbTelefNote.Value;
  if Nota = '' then Nota:= 'nessuna nota';
  lTelef.Hint:= Nota;
  iTelef.Hint:= Nota;
end;

procedure TfmNick4IRC.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

initialization
  fmNick4IRC:= nil;
end.

