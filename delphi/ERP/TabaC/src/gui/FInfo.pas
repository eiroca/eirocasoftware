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
 * Ultima modifica: 06 nov 1999
 *)
unit FInfo;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons, SysUtils, StdCtrls,
  ExtCtrls;

type
  TfmInfo = class(TForm)
    btOk: TBitBtn;
    pnInfo: TPanel;
    Label1: TLabel;
    lbDataPrezzi: TLabel;
    Label2: TLabel;
    lbDataCarico: TLabel;
    lbDataGiacen: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    lbDataStati: TLabel;
    Label5: TLabel;
    lbDataPatC: TLabel;
    Label7: TLabel;
    lbDataPatO: TLabel;
    Label9: TLabel;
    lbDataOrdini: TLabel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure UpdatePanel;
  public
    { Public declarations }
  end;

procedure ShowInfo;

implementation

{$R *.DFM}

uses
  eLibCore, DTabaC;

procedure ShowInfo;
var
  fmInfo: TfmInfo;
begin
  fmInfo:= nil;
  try
    fmInfo:= TfmInfo.Create(nil);
    fmInfo.ShowModal;
  finally
    fmInfo.Free;
  end;
end;

procedure TfmInfo.FormShow(Sender: TObject);
begin
  UpdatePanel;
end;

procedure TfmInfo.UpdatePanel;
begin
  with dmTaba do begin
    lbDataPrezzi.Caption:= DateUtil.myDateToStr(DataPrezzi);
    lbDataCarico.Caption:= LastData(DateList[dtCari]);
    lbDataGiacen.Caption:= LastData(DateList[dtGiac]);
    lbDataOrdini.Caption:= LastData(DateList[dtOrdi]);
    lbDataPatC.Caption  := LastData(DateList[dtPatC]);
    lbDataPatO.Caption  := LastData(DateList[dtPatO]);
    lbDataStati.Caption := DateUtil.myDateToStr(GetStatDate);
  end;
end;

end.

