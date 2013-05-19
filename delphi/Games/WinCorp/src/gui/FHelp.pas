(* GPL > 3.0
Copyright (C) 1997-2008 eIrOcA Enrico Croce & Simona Burzio

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
unit FHelp;

interface

uses
  Windows, WidgetGame, Classes, SysUtils, Graphics, Forms, Controls, Buttons,
  StdCtrls, ComCtrls;

type
  TfmHelp = class(TForm)
    btOk: TBitBtn;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WG: TWidgetGame;
  end;

var
  fmHelp: TfmHelp;

implementation

{$R *.DFM}
uses
  MessageStr;

procedure TfmHelp.FormCreate(Sender: TObject);
begin
  btOk.Caption:= IDS_OK;
  Caption     := IDS_FHELP;
end;

end.

