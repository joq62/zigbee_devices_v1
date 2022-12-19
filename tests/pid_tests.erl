%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(pid_tests).       
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("device.hrl").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok=setup(),
    ok=zig_server_test(),
    
    
    
				
     
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
zig_server_test()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
  
    DeviceName1="switch_prototype",
    false=zigbee_devices_server:get(DeviceName1,is_on,[]),
    {200,_,_}=zigbee_devices_server:get(DeviceName1,set,["on"]),
    true=zigbee_devices_server:get(DeviceName1,is_on,[]),
    timer:sleep(2000),
    {200,_,_}=zigbee_devices_server:get(DeviceName1,set,["off"]),
    false=zigbee_devices_server:get(DeviceName1,is_on,[]),

    DeviceName2="temp_prototype",
    Temp=zigbee_devices_server:get(DeviceName2,temp,[]),
    io:format("Temp ~p~n",[{Temp,?MODULE,?FUNCTION_NAME}]),
    Humidity=zigbee_devices_server:get(DeviceName2,humidity,[]),
    io:format("Humidity ~p~n",[{Humidity,?MODULE,?FUNCTION_NAME}]),
    Pressure=zigbee_devices_server:get(DeviceName2,pressure,[]),
    io:format("Pressure ~p~n",[{Pressure,?MODULE,?FUNCTION_NAME}]),
ok.
    
    
    

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_weather()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_switch()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
 
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_2()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    % "switch_prototype"

    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_1()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
  
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
-define(ClusterSpec,"prototype_c201").
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    {ok,_}=pid_server:start(),
    pong=pid_server:ping(),
    ok.
