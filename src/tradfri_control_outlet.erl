%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(tradfri_control_outlet).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"TRADFRI control outlet").
-define(Type,"lights").
%% --------------------------------------------------------------------
%   {"TRADFRI control outlet",
%     "2",
%         #{<<"alert">> => <<"none">>,
%           <<"on">> => false,
%           <<"reachable">> => false}},




%% External exports
-export([
	 is_on/1,
	 set/2,
	 reachable/1
	 
	]). 


%% ====================================================================
%% External functions
%% ====================================================================

%% zigbee_server:is_on("switch_prototype")
%  zigbee_server:is_reachable("switch_prototype")
%  Switch=rd:rpc_call(hw_conbee,hw_conbee,get,["switch_prototype"],2000),
% Switch {{ok,[{"switch_prototype","5","TRADFRI control outlet","lights",
%              #{<<"alert">> => <<"none">>,<<"on">> => true,
%                <<"reachable">> => true}}]},
%% zigbee_server:set("switch_prototype","off")
%%  Switch=rd:rpc_call(hw_conbee,hw_conbee,set,["switch_prototype","off"],2000),


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
set(Name,State)->
    {ok,[{_Name,NumId,_ModelId,_StateMap}]}=lib_conbee:device(?Type,Name),
    {ok,ConbeeAddr}=application:get_env(conbee_rel,addr),
    {ok,ConbeePort}=application:get_env(conbee_rel,port),
    {ok,Crypto}=application:get_env(conbee_rel,key),

    Cmd="/api/"++Crypto++"/"++?Type++"/"++NumId++"/state",
    Body=case State of
	     "on"->
		 jsx:encode(#{<<"on">> => true});		   
	     "off"->
		 jsx:encode(#{<<"on">> => false})
	 end,
    {ok, ConnPid} = gun:open(ConbeeAddr,ConbeePort),
    StreamRef = gun:put(ConnPid, Cmd, 
			[{<<"content-type">>, "application/json"}],Body),
    Result=lib_conbee:get_reply(ConnPid,StreamRef),
    ok=gun:close(ConnPid),
    Result.



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on(Name)->
    {ok,[{_Name,_NumId,_ModelId,StateMap}]}=lib_conbee:device(?Type,Name),
    maps:get(<<"on">>,StateMap).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
reachable(Name)->
    {ok,[{_Name,_NumId,_ModelId,StateMap}]}=lib_conbee:device(?Type,Name),
     maps:get(<<"reachable">>,StateMap).
