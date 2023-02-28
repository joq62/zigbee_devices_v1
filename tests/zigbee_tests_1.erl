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
-module(zigbee_tests_1).       
 
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
%    ok=test_1(),
 %   ok=test_2(),
 %   ok=test_switch(),
 %   ok=test_weather(),
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
    false=zigbee_devices:call(DeviceName1,is_on,[]),
    {200,_,_}=zigbee_devices:call(DeviceName1,set,["on"]),
    true=zigbee_devices:call(DeviceName1,is_on,[]),
    timer:sleep(2000),
    {200,_,_}=zigbee_devices:call(DeviceName1,set,["off"]),
    false=zigbee_devices:call(DeviceName1,is_on,[]),

    DeviceName2="temp_prototype",
    Temp=zigbee_devices:call(DeviceName2,temp,[]),
    io:format("Temp ~p~n",[{Temp,?MODULE,?FUNCTION_NAME}]),
    Humidity=zigbee_devices:call(DeviceName2,humidity,[]),
    io:format("Humidity ~p~n",[{Humidity,?MODULE,?FUNCTION_NAME}]),
    Pressure=zigbee_devices:call(DeviceName2,pressure,[]),
    io:format("Pressure ~p~n",[{Pressure,?MODULE,?FUNCTION_NAME}]),
ok.
    
    
    

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_weather()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    % "temp_prototype"
    DeviceName="temp_prototype",
    {ok,[DeviceInfo|_]}=sd:call(hw_conbee_app,hw_conbee,device_info,[DeviceName],5000),
    ModelId=maps:get(device_model,DeviceInfo),
    [Module]=[maps:get(module,Map)||Map<-?DeviceInfo,
				    ModelId==maps:get(model_id,Map)],
    DeviceName=maps:get(device_name,DeviceInfo),
    
  
    
    Temp=rpc:call(node(),Module,temp,[DeviceName],2000),
    io:format("Temp ~p~n",[{Temp,?MODULE,?FUNCTION_NAME}]),
    Humidity=rpc:call(node(),Module,humidity,[DeviceName],2000),
    io:format("Humidity ~p~n",[{Humidity,?MODULE,?FUNCTION_NAME}]),
    Pressure=rpc:call(node(),Module,pressure,[DeviceName],2000),
    io:format("Pressure ~p~n",[{Pressure,?MODULE,?FUNCTION_NAME}]),


  %  [#{device_model=>"lumi.weather",
   %    device_name=>"temp_prototype",
  %     device_num_id=>"6",
   %    device_status=>#{<<"lastupdated">>=><<"2022-12-19T20:07:07.444">>,
%			<<"pressure">>=>1024},
 %      device_type=>"sensors"},
  %   #{device_model=>"lumi.weather",
   %    device_name=>"temp_prototype",
   %    device_num_id=>"5",
   %    device_status=>#{<<"lastupdated">>=><<"2022-12-19T20:07:07.383">>,
%			<<"temperature">>=>2167},
 %      device_type=>"sensors"},
 %    #{device_model=>"lumi.weather",
 %      device_name=>"temp_prototype",
%       device_num_id=>"4",device_status=>#{<<"humidity">>=>3400,
%					   <<"lastupdated">>=><<"2022-12-19T20:07:07.411">>},
 %      device_type=>"sensors"}],[]}}
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_switch()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    % "switch_prototype"
    DeviceName="switch_prototype",
    {ok,[DeviceInfo1]}=sd:call(hw_conbee_app,hw_conbee,device_info,[DeviceName],5000),
    ModelId=maps:get(device_model,DeviceInfo1),
    [Module]=[maps:get(module,Map)||Map<-?DeviceInfo,
				    ModelId==maps:get(model_id,Map)],
    DeviceName=maps:get(device_name,DeviceInfo1),
    
    {200,_,_}=rpc:call(node(),Module,set,[DeviceName,"off"],2000),
    false=rpc:call(node(),Module,is_on,[DeviceName],2000),
    true=rpc:call(node(),Module,reachable,[DeviceName],2000),
    {200,_,_}=rpc:call(node(),Module,set,[DeviceName,"on"],2000),
    true=rpc:call(node(),Module,is_on,[DeviceName],2000),
    timer:sleep(2000),
    {200,_,_}=rpc:call(node(),Module,set,[DeviceName,"off"],2000),

    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_2()-> %  check the prototype
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    % "switch_prototype"

    {ok,[DeviceInfo1]}=sd:call(hw_conbee_app,hw_conbee,device_info,["switch_prototype"],5000),
    
   % io:format("DeviceInfo1 ~p~n",[{DeviceInfo1,?MODULE,?FUNCTION_NAME}]),
    
    "switch_prototype"=maps:get(device_name,DeviceInfo1),
    "5"=maps:get(device_num_id,DeviceInfo1),
    "TRADFRI control outlet"=maps:get(device_model,DeviceInfo1),
    "lights"=maps:get(device_type,DeviceInfo1),
    Status=maps:get(device_status,DeviceInfo1),
    %false=maps:get(<<"on">>,Status),
    <<"none">>=maps:get(<<"alert">>,Status),
    true=maps:get(<<"reachable">>,Status),
   
   
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_1()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    AllSensors=sd:call(hw_conbee_app,hw_conbee,get_all_device_info,["sensors"],5000),
    io:format("AllSensors ~p~n",[{AllSensors,?MODULE,?FUNCTION_NAME}]),
    AllLights=sd:call(hw_conbee_app,hw_conbee,get_all_device_info,["lights"],5000),
    io:format("AllLights ~p~n",[{AllLights,?MODULE,?FUNCTION_NAME}]),
    ModelsModules=[{maps:get(model_id,Map),maps:get(module,Map)}||Map<-?DeviceInfo],
    io:format("ModelsModules  ~p~n",[{ModelsModules,?MODULE,?FUNCTION_NAME}]),
    
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
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
     
    ok.
