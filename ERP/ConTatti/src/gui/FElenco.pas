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
unit FElenco;

interface                         

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, DBTables, Menus, eDB, JvExDBGrids,
  JvDBGrid;

type
  TfmElenco = class(TForm)
    tbContatti: TTable;
    tbContattiCodCon: TIntegerField;
    tbContattiClasse: TStringField;
    tbContattiNome: TStringField;
    tbContattiNome_Tit: TStringField;
    tbContattiNome_Pre1: TStringField;
    tbContattiNome_Pre2: TStringField;
    tbContattiNome_Main: TStringField;
    tbContattiNome_Suf: TStringField;
    tbContattiSettore: TStringField;
    tbContattiNote: TMemoField;
    tbContattiTipo: TIntegerField;
    dsContatti: TDataSource;
    dgContat: TJvDBGrid;
    pmAction: TPopupMenu;
    mpContEdit: TMenuItem;
    mpContTel: TMenuItem;
    mpContInd: TMenuItem;
    DBConnection: TDBConnectionLink;
    DBMessage: TDBMessageLink;
    procedure dgContatTitleBtnClick(Sender: TObject; ACol: Longint; Field: TField);
    procedure dgContatCheckButton(Sender: TObject; ACol: Longint; Field: TField; var Enabled: Boolean);
    procedure dgContatDblClick(Sender: TObject);
    procedure dgContatKeyPress(Sender: TObject; var Key: Char);
    procedure mpContEditClick(Sender: TObject);
    procedure mpContTelClick(Sender: TObject);
    procedure mpContIndClick(Sender: TObject);
    procedure tbContattiCalcFields(DataSet: TDataset);
    procedure dsContattiDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBConnectionEvent(Sender: TeDataBase; Connect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBMessageMessage(Sender: TObject; Cmd: Integer;
      Data: TObject);
    procedure dgContatGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
  private
    { Private declarations }
    SortField: TField;
    Find: string;
    procedure ProcessKey(Sender: TObject; var Key: Char);
    procedure SelectIndex(Num: integer);
    procedure Refresh;
  public
    { Public declarations }
  end;

var
  fmElenco: TfmElenco;

implementation

{$R *.DFM}

uses
  eLibCore, ContComm,
  DContat, uOpzioni,
  FContat, FEleTele, FEleIndi;

procedure TfmElenco.ProcessKey(Sender: TObject; var Key: Char);
var
  Found: boolean;
begin
  if not (Key in [#0..#31]) then begin
    Found:= tbContatti.Locate('Nome_Main', Find+Key, []);
    if Found then Find:= Find + key
    else begin
      Found:= tbContatti.Locate('Nome_Main', Key, []);
      if Found then begin
        Find:= Key;
      end
      else Find:= '';
    end;
  end
  else if Key = #13 then dgContatDblClick(Sender);
end;

procedure TfmElenco.SelectIndex(Num: integer);
begin
  case Num of
    0: begin
      tbContatti.IndexName:= 'IdxClasse';
      SortField:= tbContattiClasse;
    end;
    1: begin
      tbContatti.IndexName:= 'IdxNome';
      SortField:= tbContattiNome;
    end;
    2: begin
      tbContatti.IndexName:= 'IdxSettore';
      SortField:= tbContattiSettore;
    end;
  end;
  Opzioni.SortCol:= Num;
end;

procedure TfmElenco.dgContatCheckButton(Sender: TObject; ACol: Longint;
  Field: TField; var Enabled: Boolean);
begin
  Enabled:= true;
end;

procedure TfmElenco.dgContatDblClick(Sender: TObject);
begin
  mpContEdit.Click;
end;

procedure TfmElenco.dgContatKeyPress(Sender: TObject; var Key: Char);
begin
  ProcessKey(Sender, Key);
end;

procedure TfmElenco.dgContatTitleBtnClick(Sender: TObject; ACol: Longint;
  Field: TField);
begin
  SelectIndex(ACol);
end;

procedure TfmElenco.mpContEditClick(Sender: TObject);
begin
  ShowContatto(tbContattiCodCon.Value);
end;

procedure TfmElenco.mpContTelClick(Sender: TObject);
begin
  ElencoTelefonico(tbContattiCodCon.Value);
end;

procedure TfmElenco.mpContIndClick(Sender: TObject);
begin
  ElencoIndirizzi(tbContattiCodCon.Value);
end;

procedure TfmElenco.tbContattiCalcFields(DataSet: TDataset);
begin
  tbContattiNome.Value:= _DecodeNome(DataSet);
end;

procedure TfmElenco.dsContattiDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then begin
    dmContatti.Notify(Self, CC_SELECTCON, TObject(tbContattiCodCon.Value));
  end;
end;

procedure TfmElenco.FormCreate(Sender: TObject);
begin
  Caption:= '';
  dgContat.Align:= alClient;
  Find:= '';
  WindowState:= wsMaximized;
  DBConnection.DataBase:= dmContatti.DB;
  DBMessage.DataBase:= dmContatti.DB;
  DBConnection.Active:= true;
  DBMessage.Active:= true;
end;

procedure TfmElenco.FormActivate(Sender: TObject);
begin
  Refresh;
end;

procedure TfmElenco.Refresh;
begin
  if tbContatti.Active then tbContatti.Refresh;
end;

procedure TfmElenco.DBConnectionEvent(Sender: TeDataBase;
  Connect: Boolean);
begin
  if Connect then begin
    tbContatti.Active:= true;
    SelectIndex(Opzioni.SortCol);
  end
  else begin
    tbContatti.Active:= false;
  end;
end;

procedure TfmElenco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DBConnection.Active:= false;
  DBMessage.Active:= false;
end;

procedure TfmElenco.DBMessageMessage(Sender: TObject; Cmd: Integer;
  Data: TObject);
begin
  case Cmd of
    CC_REFRESH: Refresh;
    CC_SELECTCON: if Sender <> Self then begin
      tbContatti.Locate('CodCon', integer(Data), []);
    end;
  end;
end;

procedure TfmElenco.dgContatGetBtnParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
  IsDown: Boolean);
begin
  if Field = SortField then begin
    AFont.Color:= clHighlight;
  end
  else begin
    AFont.Color:= clBtnText;
  end;
end;

end.

