(* GPL > 3.0
Copyright (C) 1996-2009 eIrOcA Enrico Croce & Simona Burzio

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
unit uBioritmi;

interface

type
  TBioritmo = class
    private
     FDataNascita : TDateTime;
     FDataBioritmo: TDateTime;
    private
     function calcCiclo(v: integer): double;
    protected
     function getCicloFisico: double;
     function getCicloEmotivo: double;
     function getCicloIntellettivo: double;
    public
     constructor Create;
     destructor Destroy; override;
     function calcAffinita(data: TDateTime): double;
    public
     property DataNascita : TDateTime read FDataNascita  write FDataNascita;
     property DataBioritmo: TDateTime read FDataBioritmo write FDataBioritmo;
     property Fisico: double read getCicloFisico;
     property Emotivo: double read getCicloEmotivo;
     property Intellettivo: double read getCicloIntellettivo;
  end;

implementation

constructor TBioritmo.Create;
begin
end;

function TBioritmo.calcCiclo(v: integer): double;
begin
  Result:= sin((abs(DataBioritmo-DataNascita) / V) * 2 * PI);
end;

function TBioritmo.getCicloFisico: double;
begin
  Result:= calcCiclo(23);
end;

function TBioritmo.getCicloIntellettivo: double;
begin
  Result:= calcCiclo(33);
end;

function TBioritmo.getCicloEmotivo: double;
begin
  Result:= calcCiclo(28);
end;

function TBioritmo.calcAffinita(data: TDateTime): double;
  function affinita(c3: double; v: integer): double;
  begin
    Result:= 2 * abs(frac(C3 / V) - 0.5);
  end;
var
  c3: double;
begin
  c3:= abs(data - DataNascita);
  Result:= (affinita(c3, 23) + affinita(c3, 28) + affinita(c3, 33)) / 3;
end;

destructor TBioritmo.Destroy;
begin
  inherited;
end;

end.

