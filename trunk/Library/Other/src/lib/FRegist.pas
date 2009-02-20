(****************************************************************************)
unit FRegist;
(****************************************************************************)
(* This source code is copyrighted by Enrico Croce. This source code as a   *)
(* whole, or parts thereof, cannot be included or used in any kind of       *)
(* computer programs without the permission granted by the author.          *)
(* See LICENSE.TXT (or the other documentation) for the complete license    *)
(* agreement. All comments concerning the program may be sent to the author *)
(****************************************************************************)

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Dialogs, Buttons, ExtCtrls, IceLock;

type
  TfmRegistrazione = class(TForm)
    pnValidate: TPanel;
    btExit: TBitBtn;
    btOk: TBitBtn;
    Label1: TLabel;
    iRegName: TEdit;
    Label2: TLabel;
    pnLicenza: TPanel;
    Label3: TLabel;
    iChckCode: TEdit;
    procedure iRegNameChange(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    { Private declarations }
    IL: TIceLock;
    Magic: word;
    Trys: integer;
  public
    { Public declarations }
  end;

function Registrazione(aIL: TIceLock; aMagic: word; Sblocco: boolean): boolean;
function MakeLicenza(Name: string; const Magic: word): string;
function MakeCheckCode(const Key: string): string;
function MakePWDSbloc(aIL: TIceLock): string;
function CheckPWDSbloc(PWD: string): boolean;

const
  DefaultName = '*.*';

implementation

{$R *.DFM}

uses
  eLib, FAbout;

const
  MsgBadName: string = 'Inserire un nome valido';

function MakePWDSbloc(aIL: TIceLock): string;
var
  Name: string;
  tmp: string;
  ps, i: integer;
  CRC: longint;
  Consonanti: set of char;
begin
  Name:= 'TATTI';
  Consonanti:= ['A'..'Z']-['A','E','I','O','U'];
  if aIL <> nil then begin
    tmp:= UpperCase(aIL.GetName);
    ps:= 1;
    for i:= 1 to length(tmp) do begin
      if (tmp[i] in Consonanti) then begin
        Name[ps]:= tmp[i];
        inc(ps);
        if ps > length(Name) then break;
      end;
    end;
  end;
  CRC:= 0;
  for i:= 1 to length(Name) do CRC:= CRC + CRCTable[ord(Name[i])];
  CRC:= CRC and $FFFF;
  tmp:= Format('%x', [CRC]);
  while length(tmp) < 4 do tmp:= '0'+tmp;
  Result:=Name+'-'+tmp;
end;

function CheckPWDSbloc(PWD: string): boolean;
var
  CRC: longint;
  tmp: string;
  i: integer;
begin
  PWD:= UpperCase(Trim(PWD));
  Result:= length(PWD)=10;
  if Result then begin
    CRC:= 0;
    for i:= 1 to 5 do CRC:= CRC + CRCTable[ord(PWD[i])];
    CRC:= CRC and $FFFF;
    tmp:= Format('%x', [CRC]);
    while length(tmp) < 4 do tmp:= '0'+tmp;
    Result:= Copy(PWD, 7, 4) = tmp;
  end;
end;

function MakeLicenza(Name: string; const Magic: word): string;
var
  CRC: longint;
  Chk: integer;
  i: integer;
  b: byte;
  tmp1, tmp2, tmp3, tmp4: string;
begin
  Result:= '';
  Name:= lowercase(Name);
  for i:= length(Name) downto 1 do begin
    if not (Name[i] in ['!'..'~']) then Delete(Name, i, 1);
  end;
  if length(Name) < 4 then exit;
  try
    CRC:= -Magic;
    b:= Magic mod 100;
    for i:= 1 to length(Name) do begin
      b:= b xor ord(Name[i]);
      CRC:= CRC + CRCTable[ord(Name[i])];
    end;
    tmp1:= Copy(Format('%x', [CRC])+'00000000', 1, 8);
    tmp2:= Copy(Format('%x', [b])+'00', 1, 2);
    tmp3:= Copy(Format('%x', [Magic])+'0000', 1, 4);
    Result:= tmp1+tmp2+tmp3;
    Chk:= 0;
    for i:= 1 to length(Result) do Chk:= (Chk + ord(Result[i]) - ord('0')) and $3FFF;
    while Chk<0 do Chk:= Chk+256;
    tmp4:= Copy(Format('%x', [Chk and $FF])+'00', 1, 2);
    Result:=
      Copy(tmp1, 1, 3)+               Copy(tmp3,1,1)+' '+
      Copy(tmp1, 4, 3)+               Copy(tmp3,2,1)+' - '+
      Copy(tmp1, 7, 2)+Copy(tmp2,1,1)+Copy(tmp3,3,1)+' '+
      Copy(tmp2, 2, 1)+tmp4          +Copy(tmp3,4,1);
  except
    Result:= '';
  end;
end;

function MakeCheckCode(const Key: string): string;
var
  i: integer;
begin
  Result:= UpperCase(Key);
  for i:= length(Result) downto 1 do begin
    if not (Result[i] in ['0'..'9','A'..'F']) then Delete(Result, i, 1);
  end;
  Result:= '$'+Result;
end;

function Registrazione(aIL: TIceLock; aMagic: word; Sblocco: boolean): boolean;
var
  fmRegistrazione: TfmRegistrazione;
begin
  fmRegistrazione:= nil;
  try
    fmRegistrazione:= TfmRegistrazione.Create(nil);
    fmRegistrazione.IL:= aIL;
    fmRegistrazione.Magic:= aMagic;
    Result:= fmRegistrazione.ShowModal = mrOk;
    if Result and Sblocco then begin
      MessageDlg('Utilizzare la seguente password: '+MakePWDSbloc(aIL)+#13+
        'per sbloccare il programma dopo che qualcuno abbia tententato di accedervi illegalmente',
        mtInformation, [mbOk], 0);
    end;
  finally
    fmRegistrazione.Free;
  end;
end;

procedure TfmRegistrazione.iRegNameChange(Sender: TObject);
var
  Lic: string;
begin
  Lic:= MakeLicenza(iRegName.Text, Magic);
  if Lic = '' then Lic:= MsgBadName;
  pnLicenza.Caption:= Lic;
end;

procedure TfmRegistrazione.btOkClick(Sender: TObject);
var
  Lic: string;
  Chk: string;
begin
  Lic:= MakeLicenza(iRegName.Text, Magic);
  if Lic = '' then begin
    MessageDlg('Prima di potersi registrare occorre inserire un nome utente composto da almeno 4 caratteri alfanumerici.',
      mtInformation, [mbOk], 0);
    ActiveControl:= iRegName;
  end
  else begin
    Chk:= MakeCheckCode(iChckCode.Text);
    if IL.PutKey(Lic, Chk) = ieOkay then begin
      Lic:= Trim(iRegName.Text);
      IL.PutKey(Lic, IL.BuildUserKey(Lic, false));
      IL.SaveKeyFile;
      IL.LoadKeyFile;
      ModalResult:= mrOk;
    end
    else begin
      dec(Trys);
      if Trys = 0 then ModalResult:= mrCancel
      else MessageDlg('Inserire correttamente il codice di controllo', mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TfmRegistrazione.FormShow(Sender: TObject);
begin
  if IL = nil then Abort;
  Trys:= 3;
  iRegName.Text:= '';
  pnLicenza.Caption:= MsgBadName;
  iChckCode.Text:= '';
end;

procedure TfmRegistrazione.FormDblClick(Sender: TObject);
var
  Lic: string;
begin
  Lic:= MakeLicenza(iRegName.Text, Magic);
  iChckCode.Text:= IL.BuildUserKey(Lic, false);
end;

end.

