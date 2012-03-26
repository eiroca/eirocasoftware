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
unit uAgents;

interface

uses
  Classes, Sysutils, typinfo;


type

  Agent = class;
  AgentClass = class of Agent;
  
  AgentStatus = (asCreated, asActive, asSuspended, asDestroyed);

  SimpleAction  = procedure(const target: Agent) of object;
  MessageAction  = procedure(const target: Agent; var Message) of object;
  
  ActionNotify = procedure(const target: Agent; const action: string) of object;

  EInvalidStaus = Exception;
  
  { Agent }

  Agent = class(TComponent)
   private
    FAgentStatus: AgentStatus;
    FAgentName: String;
    FCreateAction: SimpleAction;
    FSuspendAction: SimpleAction;
    FActivateAction: SimpleAction;
    FDestroyAction: SimpleAction;
    FActionNotify: ActionNotify;
    // Agent
    // Agent is a piece of software able to run in a dynamic environment
    // Agent life cycle is created, activated, suspended and destroyed
    //
    // Delphi implementation
    // Agent are mapped into TComponent
    published
     // Agent attribute
     // an attribute of a agent is a property that change the agent behaviour.
     // Before an attribute change a doAttributeChange action is invoked and
     //
     // Object Pascal Implementation
     // Attribute are mapped into data property with aXYZ name
     // Attribute can be maninupulate only throug the setAttribute/getAttribute methods, direct access ov
     property aAgentName: string read FAgentName;
     property aAgentStatus: AgentStatus read FAgentStatus;
    published
     // Agent action
     // an action is a reaction of the agent to a environment push
     //
     // Delphi Implementation
     // Action are mapped into:
     //   method property with a doXYZ name
     //   method iXYY that implement the action
     //   method xXYZ that implement a bit of invocation logic and ActionNotify
     // If Action is injected changing the doXYX property is injector responsability to invoke target.iXYZ()
     property  doCreate  : SimpleAction read FCreateAction   write FCreateAction;
     procedure iCreate(const target: Agent); virtual;
     procedure xCreate;

     property  doActivate: SimpleAction read FActivateAction write FActivateAction;
     procedure iActivate(const target: Agent); virtual;
     procedure xActivate;

     property  doSuspend : SimpleAction read FSuspendAction  write FSuspendAction;
     procedure iSuspend(const target: Agent); virtual;
     procedure xSuspend;

     property  doDestroy : SimpleAction read FDestroyAction  write FDestroyAction;
     procedure iDestroy(const target: Agent); virtual;
     procedure xDestroy;

    published
     // Agent notification
     // a notification is a event change that the environment can listen
     //
     // Delphi Implementation
     // Notify are mapped into:
     //   method property with a onXYZ name
     //   method iNotifyXYY that implement the action
     // If Notify is injected changing the onXYX property is injector responsability to invoke target.iNotifyXYZ()

     property onAction: ActionNotify read FActionNotify  write FActionNotify;
     procedure iNotifyAction(const target: Agent; const action: string); virtual;
    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy; override;
  end;

  AOS = class(Agent)
  end;

procedure AgentOn(target: Agent);
procedure AgentOff(target: Agent);

procedure AgentList(target: Agent; what: string);
procedure AgentAction(target: Agent);
procedure AgentNotify(target: Agent);

implementation

procedure Agent.iCreate(const Target: Agent);
begin
  if (aAgentStatus <> asDestroyed) then raise EInvalidStaus.Create('Agent must be destroyed');
  FAgentStatus:= asCreated;
end;

procedure Agent.xCreate;
begin
  if assigned(FCreateAction) then begin
    doCreate(self);
    if assigned(FActionNotify) then begin
      onAction(self, 'create');
    end;
  end
end;

procedure Agent.iActivate(const target: Agent);
begin
  if (aAgentStatus <> asCreated) then raise EInvalidStaus.Create('Agent must be created');
  FAgentStatus:= asActive;
end;

procedure Agent.xActivate;
begin
  if assigned(FActivateAction) then begin
    doActivate(self);
    if assigned(FActionNotify) then begin
      onAction(self, 'activate');
    end;
  end
end;

procedure Agent.iSuspend(const target: Agent);
begin
  if (aAgentStatus <> asActive) then raise EInvalidStaus.Create('Agent must be active');
  FAgentStatus:= asSuspended;
end;

procedure Agent.xSuspend;
begin
  if assigned(FSuspendAction) then begin
    doSuspend(self);
    if assigned(FActionNotify) then begin
      onAction(self, 'suspend');
    end;
  end
end;

procedure Agent.iDestroy(const target: Agent);
begin
  if (aAgentStatus <> asSuspended) then raise EInvalidStaus.Create('Agent must be suspended');
  FAgentStatus:= asDestroyed;
end;

procedure Agent.xDestroy;
begin
  if assigned(FDestroyAction) then begin
    doDestroy(self);
    if assigned(FActionNotify) then begin
      onAction(self, 'destroy');
    end;
  end
end;

procedure Agent.iNotifyAction(const Target: Agent; const action: string);
begin
end;

constructor Agent.Create(aOwner: Tcomponent);
begin
  inherited Create(aOwner);
  FAgentName:= 'Agent';
  FAgentStatus:= asDestroyed;
  doCreate:= iCreate;
  doActivate:= iActivate;
  doSuspend:= iSuspend;
  doDestroy:= iDestroy;
  onAction:= iNotifyAction;
end;

destructor Agent.Destroy;
begin
  if (aAgentStatus <> asDestroyed) then raise EInvalidStaus.Create('Agent is not destroyed correctly');
  inherited Destroy;
end;

procedure AgentOn(target: Agent);
begin
  target.xCreate;
  target.xActivate;
end;

procedure AgentOff(target: Agent);
begin
  target.xSuspend;
  target.xDestroy;
end;

procedure AgentList(target: Agent; what: string);
Var
  PT : PTypeData;
  PI : PTypeInfo;
  I,J : Longint;
  len: integer;
  PP : PPropList;
begin
  len:= length(what);
  PI:=target.ClassInfo;
  PT:=GetTypeData(PI);
  GetMem (PP,PT^.PropCount*SizeOf(Pointer));
  J:=GetPropList(PI, PP);
  for I:=0 to J-1 do begin
    with PP^[i]^ do begin
      if (length(name)>len) and (copy(name,1,len)=what) then begin
        Writeln(copy(name,len+1, length(name)-len),'  Type: ',propType^.name);
      end;
    end;
  end;
  FreeMem(PP);
end;

procedure AgentAction(target: Agent);
begin
  AgentList(target, 'do');
end;

procedure AgentNotify(target: Agent);
begin
  AgentList(target, 'on');
end;

end.

