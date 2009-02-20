unit dbugintf;

interface

Uses
  Windows,
  SysUtils,
  Messages,
  Forms,
  Registry,
  Dialogs;


procedure SendDebugEx(const Msg: String; MType:TMsgDlgType);
procedure SendDebug(const Msg: String);
procedure ClearDebug;
function StartDebugWin:hWnd;

implementation

function StartDebugWin:hWnd;
var RegIni:TRegIniFile;
Count:Integer;
Filename: String;
Begin
  Result:=0;
  Count:=0;
  RegIni:=TRegIniFile.Create('\Software\GExperts');
  Try
    Filename:=RegIni.ReadString('Debug','FilePath','');
  finally
    RegIni.Free;
  End;
  if FileName<>'' then
    Begin
    if WinExec(PChar(Filename),SW_SHOW)>31 then
      While (Result=0) and (Count<1000) do
        begin
        Application.ProcessMessages;
        Result:=FindWindow('TfmDebug', nil);
        inc(Count);
        End;
    End;
End;

procedure ClearDebug;
var CDS:TCopyDataStruct;
DebugWin:hWnd;
PMsg:PChar;
Begin
  DebugWin:=FindWindow('TfmDebug', nil);
  if DebugWin=0 then
    DebugWin:=StartDebugWin;
  if DebugWin<>0 then
    Begin
    CDS.cbData:=7;
    PMsg:=StrNew(' Clear');
    PMsg[0]:=#3;
    Try
    CDS.lpData:=PMsg;
    SendMessage(DebugWin, WM_COPYDATA, 0, LParam(@CDS));
    Finally
    StrDispose(PMsg);
    end;
    end;
End;

procedure SendDebugEx(const Msg: String; MType:TMsgDlgType);
var CDS:TCopyDataStruct;
DebugWin:hWnd;
PMsg:PChar;

  procedure CopyMessage;
  var i: Integer;
  Begin
    PMsg[0]:=#1;
    PMsg[1]:=Char(ord(MType)+1); {Add 1 to avoid 0}
    for i:=1 to length(Msg) do begin
      PMsg[1+i]:=Msg[i];
    end;
    PMsg[length(Msg)+i]:=#0; {Terminate string}
  End;

begin
  DebugWin:=FindWindow('TfmDebug', nil);
  if DebugWin=0 then
    DebugWin:=StartDebugWin;
  if DebugWin<>0 then
    Begin
    CDS.cbData:=Length(Msg)+3;
    PMsg:=StrAlloc(Length(Msg)+3);
    Try
    CopyMessage;
    CDS.lpData:=PMsg;
    SendMessage(DebugWin, WM_COPYDATA, 0, LParam(@CDS));
    Finally
    StrDispose(PMsg);
    end;
    end;
end;

procedure SendDebug(const Msg: String);
Begin
  SendDebugEx(Msg,mtInformation);
End;

end.
