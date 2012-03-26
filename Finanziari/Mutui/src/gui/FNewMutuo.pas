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
unit FNewMutuo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  uMortgage,
  Forms, Dialogs, StdCtrls, Buttons, JvSpin, Mask, JvToolEdit,
  JvExMask, JvExStdCtrls, JvEdit, JvValidateEdit;

type
  TfmNewMutuo = class(TForm)
    Label1: TLabel;
    iPrincipal: TJvValidateEdit;
    Label2: TLabel;
    iInterest: TJvSpinEdit;
    Label3: TLabel;
    iPeriods: TJVSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    iPerInYear: TJvSpinEdit;
    Label5: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function NewMutuo: TMortgage;

implementation

{$R *.DFM}

function NewMutuo: TMortgage;
var
  fmNewMutuo: TfmNewMutuo;
begin
  fmNewMutuo:= nil;
  Result:= nil;
  try
    fmNewMutuo:= TfmNewMutuo.Create(nil);
    if fmNewMutuo.ShowModal = mrOk then begin
      with fmNewMutuo do begin
        Result:= TMortgage.Create(iPrincipal.Value, iInterest.Value * 0.01, trunc(iPeriods.Value), trunc(iPerInYear.Value));
      end;
    end;
  finally
    fmNewMutuo.Free;
  end;
end;

end.
