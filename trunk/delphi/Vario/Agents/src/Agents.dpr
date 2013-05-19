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
program Agents;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uAgents in 'lib\uAgents.pas';

type
  LogAspect = class
    procedure LogCreateCall(const target: Agent);
    procedure LogActionNotify(const target: Agent; const action: string);
  end;

procedure LogAspect.LogCreateCall(const target: Agent);
begin
  writeln('Action call logged on '+target.aAgentName);
  target.iCreate(target);
end;

procedure LogAspect.LogActionNotify(const target: Agent; const action: string);
begin
  writeln('Action notify logged on '+target.aAgentName+' was '+action);
  target.iNotifyAction(target, action);
end;

var
  os: AOS;
  log: LogAspect;
begin
  log:= LogAspect.Create;
  os:= AOS.Create(nil);

  writeln('Action');
  AgentAction(os);
  writeln('Notify');
  AgentNotify(os);


  os.onAction:= log.LogActionNotify;
  os.doCreate:= log.LogCreateCall;

(*
  os.doSuspend:= log.LogActionCall;
  os.doActivate:= log.LogActionCall;
  os.doDestroy:= Log.LogActionCall;
*)

  AgentOn(os);
  AgentOff(os);
  os.Free;
  log.Free;
  readln;
end.

