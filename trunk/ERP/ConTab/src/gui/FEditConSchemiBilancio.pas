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
unit FEditConSchemiBilancio;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, Grids, Mask, ExtCtrls, RgNav,
  RgNavDB;

type
  TfmEditConSchemiBilancio = class(TForm)
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
    Splitter1: TSplitter;
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function EditBilanciSchema: TModalResult;

implementation

{$R *.DFM}

uses
  DEditConSchemiBilancio;

function EditBilanciSchema: TModalResult;
var
  fmEditConSchemiBilancio: TfmEditConSchemiBilancio;
begin
  fmEditConSchemiBilancio:= nil;
  try
    fmEditConSchemiBilancio:= TfmEditConSchemiBilancio.Create(nil);
    Result:= fmEditConSchemiBilancio.ShowModal;
  finally
    fmEditConSchemiBilancio.Free;
  end;
end;

procedure TfmEditConSchemiBilancio.DBGrid1Enter(Sender: TObject);
begin
   with dmEditConSchemiBilancio do begin
     if dsConSchemiBilancio.State in [dsInsert, dsEdit] then begin
       dsConSchemiBilancio.DataSet.Post;
     end;
     navSchema.DataSource:= dsConSchemiBilancioDett;
   end;
end;

procedure TfmEditConSchemiBilancio.DBGrid1Exit(Sender: TObject);
begin
   navSchema.DataSource:= dmEditConSchemiBilancio.dsConSchemiBilancio;
end;

end.

