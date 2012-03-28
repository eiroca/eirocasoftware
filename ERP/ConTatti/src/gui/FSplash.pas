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
(****************************************************************************)
unit FSplash;
(****************************************************************************
 Vers.: 1.1
 Desc.: Template di una splash form. Per usarla basta includerla in un
        progetto e toglierla dalle form in autocreate. La splash si apre
        alla partenza del programma e si chiude non appena viene
        visualizzata una form o si richiama la procedura CloseSplash. E'
        consigliabile che la FSplash sia tra le prime unit nella riga degli
        uses al fine di aprire la splash il prima possibile.
****************************************************************************)

interface

uses
  Forms, Classes, Controls, ExtCtrls, Graphics, JvExControls, JvLabel;

const
{$IFDEF WIN32}
  LoadingCursor = crAppStart;
{$ELSE}
  LoadingCursor = crHourGlass;
{$ENDIF}

type
  TfmSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    RxLabel2: TJvLabel;
    RxLabel1: TJvLabel;
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

procedure CloseSplash;

implementation

{$R *.DFM}

var
  fmSplash: TfmSplash;

procedure TfmSplash.FormDeactivate(Sender: TObject);
begin
  Release;
end;

procedure TfmSplash.FormDestroy(Sender: TObject);
begin
  Screen.Cursor:= crDefault;
  fmSplash:= nil;
end;

procedure CloseSplash;
begin
  fmSplash.Free;
end;

procedure OpenSplash;
begin
  Screen.Cursor:= LoadingCursor;
  fmSplash:= TfmSplash.Create(nil);
  fmSplash.Show;
  fmSplash.Update;
end;

initialization
  OpenSplash;
end.

