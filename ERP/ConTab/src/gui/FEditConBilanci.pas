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
unit FEditConBilanci;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, Grids, Mask, ExtCtrls, RgNav,
  RgNavDB;

type
  TfmEditConBilanci = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditCodSch: TDBEdit;
    Label2: TLabel;
    EditAlias: TDBEdit;
    Label3: TLabel;
    EditDesc: TDBEdit;
    Label4: TLabel;
    MemoNote: TDBMemo;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    navSchema: TRGNavigator;
    DBCheckBox1: TDBCheckBox;
    Splitter1: TSplitter;
    Label5: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function EditBilanci: TModalResult;

implementation

{$R *.DFM}

uses
  DEditConBilanci;

function EditBilanci: TModalResult;
var
  fmEditConBilanci: TfmEditConBilanci;
begin
  fmEditConBilanci:= nil;
  try
    fmEditConBilanci:= TfmEditConBilanci.Create(nil);
    Result:= fmEditConBilanci.ShowModal;
  finally
    fmEditConBilanci.Free;
  end;
end;

procedure TfmEditConBilanci.DBGrid1Enter(Sender: TObject);
begin
   with dmEditConBilanci do begin
     if dsConBilanci.State in [dsInsert, dsEdit] then begin
       dsConBilanci.DataSet.Post;
     end;
     navSchema.DataSource:= dsConBilanciDett;
   end;
end;

procedure TfmEditConBilanci.DBGrid1Exit(Sender: TObject);
begin
   navSchema.DataSource:= dmEditConBilanci.dsConBilanci;
end;



end.

