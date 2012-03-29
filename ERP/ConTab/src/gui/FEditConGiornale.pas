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
unit FEditConGiornale;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, Grids, Mask, ExtCtrls, RgNav,
  RgNavDB, JvDBControls, JvExMask, JvToolEdit;

type
  TfmEditConGiornale = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditCodSch: TDBEdit;
    Label3: TLabel;
    EditDesc: TDBEdit;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    navSchema: TRGNavigator;
    DBCheckBox1: TDBCheckBox;
    Splitter1: TSplitter;
    DBDateEdit1: TJvDBDateEdit;
    DBDateEdit2: TJvDBDateEdit;
    Label2: TLabel;
    Label4: TLabel;
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function EditGiornale: TModalResult;

implementation

{$R *.DFM}

uses
  DEditConGiornale;

function EditGiornale: TModalResult;
var
  fmEditConGiornale: TfmEditConGiornale;
begin
  fmEditConGiornale:= nil;
  try
    fmEditConGiornale:= TfmEditConGiornale.Create(nil);
    Result:= fmEditConGiornale.ShowModal;
  finally
    fmEditConGiornale.Free;
  end;
end;

procedure TfmEditConGiornale.DBGrid1Enter(Sender: TObject);
begin
   with dmEditConGiornale do begin
     if dsConGiornale.State in [dsInsert, dsEdit] then begin
       dsConGiornale.DataSet.Post;
     end;
     navSchema.DataSource:= dsConGiornaleDett;
   end;
end;

procedure TfmEditConGiornale.DBGrid1Exit(Sender: TObject);
begin
   navSchema.DataSource:= dmEditConGiornale.dsConGiornale;
end;





end.

