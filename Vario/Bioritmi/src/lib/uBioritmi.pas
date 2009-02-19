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

