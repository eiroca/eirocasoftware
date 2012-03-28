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
unit FFindArt;

interface

uses
  SysUtils, WinProcs, WinTypes, Messages, Classes, Graphics, Forms, Dialogs, 
  DArtik,  
  Controls, Grids, DBGrids, Mask, DBTables, DB,
  StdCtrls, Buttons, JvComponentBase, JvBDEFilter, JvExMask, JvToolEdit;

type
  TfmFindArti = class(TForm)
    DBGrid1: TDBGrid;
    iSearch: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    tbArtic: TTable;
    dsTaba: TDataSource;
    rxFilter: TJvDBFilter;
    tbArticCodAlf: TStringField;
    tbArticCodNum: TSmallintField;
    tbArticDesc: TStringField;
    tbArticAttv: TBooleanField;
    lbSet: TLabel;
    tbArticPrzLis: TCurrencyField;
    tbArticPrzNor: TCurrencyField;
    tbArticPrzSpe: TCurrencyField;
    BitBtn1: TBitBtn;
    qrArtic: TQuery;
    qrArticCodAlf: TStringField;
    qrArticCodNum: TSmallintField;
    qrArticDesc: TStringField;
    iSet: TJvComboEdit;
    procedure iSearchKeyPress(Sender: TObject; var Key: Char);
    procedure iSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function rxFilterFiltering(Sender: TObject;
      DataSet: TDataset): Boolean;
    procedure BitBtn1Click(Sender: TObject);
    procedure iSetChange(Sender: TObject);
    procedure iSetKeyPress(Sender: TObject; var Key: Char);
    procedure iSetButtonClick(Sender: TObject);
  private
    SrchFld: TField;
    FSet: string;
    FCodNum: integer;
    FCodAlf: string;
  public
    property CodNum: integer read FCodNum write FCodNum;
    property CodAlf: string  read FCodAlf write FCodAlf;
  end;

function FindArticolo(var CodAlf: string; var CodNum: integer): boolean;

implementation

{$R *.DFM}

uses
  FSelSetMerc;

var
  fmFindArti: TfmFindArti;

function FindArticolo(var CodAlf: string; var CodNum: integer): boolean;
begin
  if fmFindArti = nil then begin
    fmFindArti:= TfmFindArti.Create(Application);
  end;
  fmFindArti.CodNum:= CodNum;
  fmFindArti.CodAlf:= CodAlf;
  Result:= fmFindArti.ShowModal=mrOk;
  if Result then begin
    CodNum:= fmFindArti.CodNum;
    CodAlf:= fmFindArti.CodAlf;
  end;
end;

procedure TfmFindArti.iSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(SrchFld) and (Key > ' ') and not (SrchFld.IsValidChar(Key)) then begin
    MessageBeep(0);
    Key:= #0;
  end;
end;

procedure TfmFindArti.iSearchChange(Sender: TObject);
begin
  if iSearch.Text <> '' then begin
    tbArtic.Locate('DESC', iSearch.Text, [loPartialKey]);
  end;
end;

procedure TfmFindArti.FormShow(Sender: TObject);
begin
  FSet:= '';
  iSet.Text:= '';
  tbArtic.Active:= true;
  rxFilter.Active:= true;
  tbArtic.IndexName:= '';
  tbArtic.FindKey([CodAlf, CodNum]);
  SrchFld:= tbArticDesc;
  ActiveControl:= iSearch;
end;

procedure TfmFindArti.DBGrid1DblClick(Sender: TObject);
begin
  btOk.Click;
end;

procedure TfmFindArti.btOkClick(Sender: TObject);
begin
  CodAlf:= tbArticCodAlf.Value;
  CodNum:= tbArticCodNum.Value;
end;

procedure TfmFindArti.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  rxFilter.Active:= false;
  tbArtic.Active:= false;
end;

function TfmFindArti.rxFilterFiltering(Sender: TObject;
  DataSet: TDataset): Boolean;
var
  tmp: string;
begin
  Result:= DataSet.FieldByName('ATTV').AsBoolean;
  if Result and (FSet<>'')then begin
    tmp:= Copy(DataSet.FieldByName('CodAlf').AsString,1,length(FSet));
    Result:= tmp=FSet;
  end;
end;

procedure TfmFindArti.BitBtn1Click(Sender: TObject);
begin
  try
    qrArtic.Params.ParamByName('ADesc').AsString:= '%'+iSearch.Text+'%';
    qrArtic.Open;
    if not qrArtic.EOF then begin
      tbArtic.FindKey([qrArticCodAlf.Value, qrArticCodNum.Value]);
    end;
  finally
    qrArtic.Active:= false;
  end;
end;

procedure TfmFindArti.iSetChange(Sender: TObject);
begin
  FSet:= UpperCase(iSet.Text);
  lbSet.Caption:= ISettoriMerc.Desc(FSet);
  if tbArtic.Active then tbArtic.Refresh;
end;

procedure TfmFindArti.iSetKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= UpCase(Key);
end;

procedure TfmFindArti.iSetButtonClick(Sender: TObject);
var
  CodAlf: string;
begin
  CodAlf:= iSet.Text;
  if SelectSetMer(CodAlf, true) then begin
    iSet.Text:=CodAlf;
    iSetChange(nil);
  end;
end;

initialization
  fmFindArti:= nil;
end.

