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
unit FFindFor;

interface

uses
  SysUtils, WinProcs, WinTypes, Messages, Classes, Graphics,
  Forms, Dialogs, DArtik, DB, DBTables, StdCtrls, Buttons,
  Controls, Grids, DBGrids, Mask, JvComponentBase, JvBDEFilter;

type
  TfmFindFor = class(TForm)
    DBGrid1: TDBGrid;
    iSearch: TEdit;
    Label2: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    tbFornitori: TTable;
    dsFornitori: TDataSource;
    rxFilter: TJvDBFilter;
    BitBtn1: TBitBtn;
    qrArtic: TQuery;
    cbPotenziali: TCheckBox;
    tbFornitoriCodFor: TIntegerField;
    tbFornitoriNome: TStringField;
    tbFornitoriPotenziale: TBooleanField;
    qrArticCodFor: TIntegerField;
    qrArticNome: TStringField;
    procedure iSearchKeyPress(Sender: TObject; var Key: Char);
    procedure iSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function rxFilterFiltering(Sender: TObject;
      DataSet: TDataset): Boolean;
    procedure BitBtn1Click(Sender: TObject);
    procedure cbPotenzialiClick(Sender: TObject);
  private
    SrchFld: TField;
    FCodFor: longint;
  public
    property CodFor: longint read FCodFor write FCodFor;
  end;

function FindFornitore(var CodFor: longint): boolean;

implementation

{$R *.DFM}

uses
 FSelSetMerc;

var
  fmFindFor: TfmFindFor;

function FindFornitore(var CodFor: longint): boolean;
begin
  if fmFindFor = nil then begin
    fmFindFor:= TfmFindFor.Create(Application);
  end;
  fmFindFor.CodFor:= CodFor;
  Result:= fmFindFor.ShowModal=mrOk;
  if Result then CodFor:= fmFindFor.CodFor;
end;

procedure TfmFindFor.iSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(SrchFld) and (Key > ' ') and not (SrchFld.IsValidChar(Key)) then begin
    MessageBeep(0);
    Key:= #0;
  end;
end;

procedure TfmFindFor.iSearchChange(Sender: TObject);
begin
  if iSearch.Text <> '' then begin
    tbFornitori.Locate('NOME', iSearch.Text, [loPartialKey]);
  end;
end;

procedure TfmFindFor.FormShow(Sender: TObject);
begin
  tbFornitori.Active:= true;
  rxFilter.Active:= true;
  tbFornitori.IndexName:= '';
  tbFornitori.FindKey([CodFor]);
  SrchFld:= tbFornitoriNome;
  ActiveControl:= iSearch;
end;

procedure TfmFindFor.DBGrid1DblClick(Sender: TObject);
begin
  btOk.Click;
end;

procedure TfmFindFor.btOkClick(Sender: TObject);
begin
  CodFor:= tbFornitoriCodFor.Value;
end;

procedure TfmFindFor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  rxFilter.Active:= false;
  tbFornitori.Active:= false;
end;

function TfmFindFor.rxFilterFiltering(Sender: TObject;
  DataSet: TDataset): Boolean;
begin
  Result:= cbPotenziali.Checked or (not DataSet.FieldByName('POTENZIALE').AsBoolean);
end;

procedure TfmFindFor.BitBtn1Click(Sender: TObject);
begin
  try
    qrArtic.Params.ParamByName('ADesc').AsString:= '%'+iSearch.Text+'%';
    qrArtic.Open;
    if not qrArtic.EOF then begin
      tbFornitori.FindKey([qrArticCodFor.Value]);
    end;
  finally
    qrArtic.Active:= false;
  end;
end;

procedure TfmFindFor.cbPotenzialiClick(Sender: TObject);
begin
  tbFornitori.Refresh;
end;

initialization
  fmFindFor:= nil;
end.

