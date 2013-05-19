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
unit eIP;

interface

uses
  SysUtils, Classes, WinProcs, WinTypes, WinSock;

var
  tcpip_ready: boolean;

const
  INVALID_IP_ADDRESS = -1;  (* only invalid as a host ip, maybe OK for broadcast *)

type
  ta_8u = packed array [0..65530] of byte;
  t_encoding = (uuencode, base64, mime);

function TimeZoneBias: longint;     { in minutes ! }
function InternetDate(date: TDateTime): string;

function DecodeLine(mode: t_encoding; const inp: string): string;
function EncodeLine(mode: t_encoding; const buf; size: integer): string;
function EncodeBase64(data: TStream): TStringList;

function GetMyHostName: string;
function GetMyIPAddress: longint;
function LockupHostName(const HostName: string): longint;
function ResolveHostName(ip: longint): string;

function IPToString(IPAddress: longint): string;
function SplitURL(URL: string; var Service, Server, Path: string): string;

implementation

const
  weekdays: array[1..7] of string[3] =
    ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');

  months: array[1..12] of string[3] =
    ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

function TimeZoneBias:longint;
(*@/// 16 bit way: try a 32bit API call via thunking layer, if that fails try the TZ *)
(*$ifdef ver80 *)
  function GetEnvVar(const s:string):string;
  var
    L: Word;
    P: PChar;
  begin
    L:= length(s);
    P:= GetDosEnvironment;
    while P^ <> #0 do begin
      if (StrLIComp(P, @s[1], L) = 0) and (P[L] = '=') then begin
        GetEnvVar:= StrPas(P + L + 1);
        exit;
      end;
      Inc(P, StrLen(P) + 1);
    end;
    GetEnvVar:= '';
  end;
  function day_in_month(month,year,weekday: word; count: integer):TDateTime;
  var
    h: integer;
  begin
    if count>0 then begin
      h:= dayofweek(encodedate(year,month,1));
      h:= ((weekday-h+7) mod 7) +1 + (count-1)*7;
      result:= encodedate(year,month,h);
    end
    else begin
      h:= dayofweek(encodedate(year,month,1));
      h:= ((weekday-h+7) mod 7) +1 + 6*7;
      while count<0 do begin
        h:= h-7;
        try
          result:= encodedate(year,month,h);
          inc(count);
          if count=0 then exit;
        except
        end;
      end;
    end;
  end;
  function DayLight_Start:TDateTime;
  var
    y,m,d: word;
  begin
    DecodeDate(now,y,m,d);
    result:= day_in_month(4,y,1,1);
    (* for european one: day_in_month(3,y,1,-1) *)
  end;
  function DayLight_End:TDateTime;
  var
    y,m,d: word;
  begin
    DecodeDate(now,y,m,d);
    result:= day_in_month(10,y,1,-1);
  end;
type
  PSystemTime = ^TSystemTime;
  TSystemTime = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;
  TTimeZoneInformation = record
    Bias: Longint;
    StandardName: array[0..31] of word;  (* wchar *)
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of word;  (* wchar *)
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
  end;
var
  tz_info: TTimeZoneInformation;
  LL32: function (LibFileName: PChar; handle: longint; special: longint):Longint;
  FL32: function (hDll: Longint):boolean;
  GA32: function (hDll: Longint; functionname: PChar):longint;
  CP32: function (buffer:TTimeZoneInformation; prochandle,adressconvert,dwParams:Longint):longint;
  hdll32, dummy, farproc: longint;
  hdll: THandle;
  sign: integer;
  s: string;
begin
  hDll:= GetModuleHandle('kernel');                  { get the 16bit handle of kernel }
  @LL32:= GetProcAddress(hdll,'LoadLibraryEx32W');   { get the thunking layer functions }
  @FL32:= GetProcAddress(hdll,'FreeLibrary32W');
  @GA32:= GetProcAddress(hdll,'GetProcAddress32W');
  @CP32:= GetProcAddress(hdll,'CallProc32W');
  (*@///   if possible then   call GetTimeZoneInformation via Thunking *)
  if (@LL32<>nil) and
     (@FL32<>nil) and
     (@GA32<>nil) and
     (@CP32<>nil) then begin
    hDll32:= LL32('kernel32.dll',dummy,1);            { get the 32bit handle of kernel32 }
    farproc:= GA32(hDll32,'GetTimeZoneInformation');  { get the 32bit adress of the function }
    case CP32(tz_info,farproc,1,1) of                { and call it }
      1: result:= tz_info.StandardBias+tz_info.Bias;
      2: result:= tz_info.DaylightBias+tz_info.Bias;
      else result:= 0;
    end;
    FL32(hDll32);                                    { and free the 32bit dll }
  end
  else begin
    s:= GetEnvVar('TZ');
    while (length(s)>0) and (not(s[1] in ['+','-','0'..'9'])) do s:= copy(s,2,length(s));
    case s[1] of
      '+': begin
        sign:= 1;
        s:= copy(s,2,length(s));
      end;
      '-': begin
        sign:= -1;
        s:= copy(s,2,length(s));
      end;
      else sign:= 1;
    end;
    try
      result:= strtoint(copy(s,1,2))*60;
      s:= copy(s,3,length(s));
    except
      try
        result:= strtoint(s[1])*60;
        s:= copy(s,2,length(s));
      except
        result:= 0;
      end;
    end;
    if s[1]=':' then begin
      try
        result:= result+strtoint(copy(s,2,2));
        s:= copy(s,4,length(s));
      except
        try
          result:= result+strtoint(s[2]);
          s:=  copy(s,3,length(s));
        except
        end;
      end;
    end;
    if s[1]=':' then begin
      try
        strtoint(copy(s,2,2));
        s:= copy(s,4,length(s));
      except
        try
          strtoint(s[2]);
          s:= copy(s,3,length(s));
        except
        end;
      end;
    end;
    result:= result*sign;
    if length(s)>0 then begin
      (* forget about the few hours on the start/end day *)
      if (now>daylight_start) and (now<DayLight_End+1) then result:= result-60;
    end;
  end;
end;
(*@/// 32 bit way: API call GetTimeZoneInformation *)
(*$else *)
var
  tz_info: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(tz_info) of
    1: result:= tz_info.StandardBias+tz_info.Bias;
    2: result:= tz_info.DaylightBias+tz_info.Bias;
    else result:= 0;
  end;
end;
(*$endif *)

function InternetDate(date: TDateTime):string;
  function MyIntToStr(value: integer; len: byte): string;
  begin
    Result:= IntToStr(value);
    while length(result)<len do result:= '0'+result;
  end;
  function TimeZone: string;
  var
    bias: longint;
  begin
    bias:= TimeZoneBias;
    if bias=0 then TimeZone:= 'GMT'
    else if bias< 0 then
      TimeZone:= '+' + MyIntToStr(abs(bias) div 60,2) + MyIntToStr(abs(bias) mod 60,2)
    else if bias>0 then
      TimeZone:= '-' + MyIntToStr(bias div 60,2) + MyIntToStr(bias mod 60,2);
  end;
var
  d,m,y,w,h,mm,s,ms: word;
begin
  decodedate(date,y,m,d);
  decodetime(date,h,mm,s,ms);
  w:= dayofweek(date);
  Result:= weekdays[w]+', '+inttostr(d)+' '+months[m]+' '+inttostr(y)+' '+
     MyIntToStr(h,2)+':'+MyIntToStr(mm,2)+':'+MyIntToStr(s,2)+' '+timezone;
end;

const
  bin2uue:string='`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
  bin2b64:string='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  uue2bin:string=' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';
  b642bin:string='~~~~~~~~~~~^~~~_TUVWXYZ[\]~~~|~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';
  linesize = 45;

function DecodeLine(mode: t_encoding; const inp: string): string;
var
  count, pos1, pos2: integer;
  offset: shortint;
  s: string;
  out: string;
begin
  s:= inp;
{$ifdef ver80}
  out[0]:= chr(length(s)*3 div 4 +3);
{$else}
  SetLength(out,length(s)*3 div 4 +3);
{$endif}
  fillchar(out[1],length(s)*3 div 4 +3,#0);   (* worst case *)
  if (mode=uuencode) and not (s[1] in [' '..'M','`']) then
    count:= 0   (* ignored line *)
  else begin
    count:= 0; pos1:= 0;  (* Delphi 2 Shut up! *)
    case mode of  (* !!! No check for invalid data yet *)
      uuencode: begin
        count:= (ord(s[1]) - $20) and $3f;
        for pos1:= 2 to length(s)-1 do
          s[pos1]:= char(ord(uue2bin[ord(s[pos1])-$20+1])-$20);
        pos1:= 2;
      end;
      base64,mime: begin
        count:= length(s)*3 div 4;
        for pos1:= 1 to length(s) do
          s[pos1]:= char(ord(b642bin[ord(s[pos1])-$20+1])-$20);
        pos1:= 1;
      end;
    end;
    pos2:= 1;
    offset:= 2;
    while pos2<=count do begin
      if (pos1>length(s)) or ((mode<>uuencode) and (s[pos1]='\'))  then begin
        if offset<>2 then inc(pos2);
        count:= pos2-1;
      end
      else if ((mode<>uuencode) and (s[pos1]='^')) then   (* illegal char in source *)
        inc(pos1)  (* skip char, prevent endless loop jane :*)
      else if offset>0 then begin
        out[pos2]:= char(ord(out[pos2]) or (ord(s[pos1]) shl offset));
        inc(pos1);
        offset:= offset-6;
      end
      else if offset<0 then begin
        offset:= abs(offset);
        out[pos2]:= char(ord(out[pos2]) or (ord(s[pos1]) shr offset));
        inc(pos2);
        offset:= 8-offset;
      end
      else begin
        out[pos2]:= char(ord(out[pos2]) or ord(s[pos1]));
        inc(pos1);
        inc(pos2);
        offset:= 2;
      end;
    end;
  end;
  Result:= copy(out,1,count);
end;

function EncodeLine(mode: t_encoding; const buf; size: integer): string;
var
  buff: ta_8u absolute buf;
  offset: shortint;
  pos1,pos2: byte;
  i: byte;
  out: string;
begin
{$ifdef ver80}
  out[0]:= chr(size*4 div 3 +2);
{$else}
  SetLength(out,size*4 div 3 +2);
{$endif}
  fillchar(out[1],size*4 div 3 +2,#0);   (* worst case *)
  if mode=uuencode then begin
    out[1]:= char(((size-1) and $3f)+$21);
    size:= ((size+2) div 3)*3;
  end;
  offset:= 2;
  pos1:= 0;
  pos2:= 0;   (* Delphi 2 Shut up! *)
  case mode of
    uuencode:     pos2:= 2;
    base64, mime: pos2:= 1;
  end;
  out[pos2]:= #0;
  while pos1<size do begin
    if offset > 0 then begin
      out[pos2]:= char(ord(out[pos2]) or ((buff[pos1] and ($3f shl offset)) shr offset));
      offset:= offset-6;
      inc(pos2);
      out[pos2]:= #0;
    end
    else if offset < 0 then begin
      offset:= abs(offset);
      out[pos2]:= char(ord(out[pos2]) or ((buff[pos1] and ($3f shr offset)) shl offset));
      offset:= 8-offset;
      inc(pos1);
    end
    else begin
      out[pos2]:= char(ord(out[pos2]) or ((buff[pos1] and $3f)));
      inc(pos2);
      inc(pos1);
      out[pos2]:= #0;
      offset:= 2;
    end;
  end;
  case mode of
    uuencode: begin
      dec(pos2);
      for i:= 2 to pos2 do
        out[i]:= bin2uue[ord(out[i])+1];
    end;
    base64, mime: begin
      dec(pos2);
      for i:= 1 to pos2 do
        out[i]:= bin2b64[ord(out[i])+1];
      while (pos2 and 4)<>4  do begin
        inc(pos2);
        out[pos2]:= '=';
      end;
    end;
  end;
  Result:= copy(out,1,pos2);
end;

function EncodeBase64(data: TStream): TStringList;
var
  buf: pointer;
  size: integer;
begin
  buf:= nil;
  try
    result:= TStringList.Create;
    GetMem(buf,linesize);
    data.seek(0,0);
    size:= linesize;
    while size>0 do begin
      size:= data.read(buf^,linesize);
      if size>0 then
        result.add(EncodeLine(base64,buf^,size));
    end;
  finally
    if buf<>nil then
      FreeMem(buf,linesize);
  end;
end;

function GetMyHostName: string;
const
  bufsize= 255;
var
  buf: pointer;
  RemoteHost: PHostEnt; (* No, don't free it! *)
begin
  buf:= nil;
  Result:= '';
  try
    GetMem(buf,bufsize);
    WinSock.GetHostName(buf, bufsize);   (* this one maybe without domain *)
    RemoteHost:= WinSock.GetHostByName(buf);
    (*$ifdef ver80 *)
      Result:= StrPas(PChar(RemoteHost^.h_name));
    (*$else *)
      Result:= PChar(RemoteHost^.h_name);
    (*$endif *)
  finally
    if buf<>nil then FreeMem(buf,bufsize);
  end;
end;

function GetMyIPAddress: longint;
const
  bufsize=255;
var
  buf: pointer;
  RemoteHost: PHostEnt; (* No, don't free it! *)
begin
  buf:= nil;
  try
    GetMem(buf, bufsize);
    WinSock.GetHostName(buf, bufsize);   (* this one maybe without domain *)
    RemoteHost:= WinSock.GetHostByName(buf);
    if RemoteHost=nil then
      Result:= INVALID_IP_ADDRESS
    else
      Result:= longint(pointer(RemoteHost^.h_addr_list^)^);
  finally
    if buf<>nil then FreeMem(buf,bufsize);
  end;
end;

function LockupHostName(const HostName: string): longint;
var
  RemoteHost : PHostEnt;  (* no, don't free it! *)
  IPAddress: longint;
(*$ifdef ver80 *)
  s: string;
(*$endif *)
begin
  IPAddress:= INVALID_IP_ADDRESS;
  try
    if HostName='' then begin  (* no host given! *)
      Result:= IPAddress;
      exit;
    end
    else begin
    (*$ifdef ver80 *)
      s:= HostName+#0;
      IPAddress:= WinSock.Inet_Addr(@s[1]);  (* try a xxx.xxx.xxx.xx first *)
    (*$else *)
      IPAddress:= WinSock.Inet_Addr(PAnsiChar(HostName));  (* try a xxx.xxx.xxx.xx first *)
    (*$endif *)
    if IPAddress=SOCKET_ERROR then begin
      (*$ifdef ver80 *)
        RemoteHost:= WinSock.GetHostByName(@s[1]);
      (*$else *)
        RemoteHost:= WinSock.GetHostByName(PAnsiChar(HostName));
      (*$endif *)
      if (RemoteHost=nil) or (RemoteHost^.h_length<=0) then begin
        Result:= IPAddress;
        exit;
      end
      else
        IPAddress:= longint(pointer(RemoteHost^.h_addr_list^)^);
        (* use the first address given *)
      end;
    end;
  except
    IPAddress:= INVALID_IP_ADDRESS;
  end;
  Result:= IPAddress;
end;

function ResolveHostName(ip: longint): string;
var
  RemoteHost: PHostEnt; (* No, don't free it! *)
  IPAddress : longint;
begin
  IPAddress := ip;
  RemoteHost:= WinSock.GetHostByAddr(@IPAddress,4,pf_inet);
  if RemoteHost<>nil then
    (*$ifdef ver80 *)
      ResolveHostName:= StrPas(PChar(RemoteHost^.h_name))
    (*$else *)
      ResolveHostName:= PChar(RemoteHost^.h_name)
    (*$endif *)
  else
    ResolveHostName:= IPToString(IPAddress);
end;

function IPToString(IPAddress: longint): string;
begin
  IPAddress:= WinSock.ntohl(IPAddress);
  Result:= inttostr( IPAddress shr 24)+'.'+
           inttostr((IPAddress shr 16) and $ff)+'.'+
           inttostr((IPAddress shr 8) and $ff)+'.'+
           inttostr( IPAddress and $ff);
end;

function SplitURL(URL: string; var Service, Server, Path: string): string;
var
  ps: integer;
begin
  ps:= pos(':', URL);
  if ps <> 0 then begin
    Service:= Copy(URL, 1, ps-1);
    URL:= Copy(URL, ps+1, length(URL)-ps+1);
  end;
  if Copy(URL,1,2) = '//' then begin
    (* rimuovi nome server *);
    ps:= 3;
    while (ps<length(URL)) and (URL[ps]<>'/') do inc(ps);
    Server:= Copy(URL, 1, ps-1);
  end
  else begin
    if Pos('/', URL) = 0 then begin
      Server:= URL;
      Path:= '';
    end
    else begin
      ps:= 1;
    end;
  end;
(*
  if (URL <> '') and (URL[length(URL)]='/') then delete(URL, length(URL), 1);
*)
  Path:= Copy(URL, ps, length(URL)-ps+1);
end;

procedure init;
var
  point: TWSAData;
begin
  tcpip_ready:= false;
  case WinSock.WSAStartup($0101,point) of
    WSAEINVAL, WSASYSNOTREADY, WSAVERNOTSUPPORTED: ;
    else tcpip_ready:= true;
  end;
end;

procedure shutdown; far;
begin
  WinSock.WSACancelBlockingCall;
  WinSock.WSACleanup;
end;

begin
  Init;
  AddExitProc(Shutdown);
end.
