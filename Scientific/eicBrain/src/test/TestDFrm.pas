unit TestDFrm;

interface

uses
  eLibMath, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AA: double;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  A: TDMatrix;
begin
  A:= TDMatrix.Create(nil);
  A.Setup(1,10,1,10);
  A[1,1]:= 10;
  A.Item[0,0]:= A[1,1]+1;
  AA:= A[1,1];
  A.Destroy;
end;

end.
 