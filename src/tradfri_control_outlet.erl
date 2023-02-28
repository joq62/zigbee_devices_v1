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
    sd:call(hw_conbee_app,hw_conbee,set,[Name,State],5000).



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on(DeviceName)->
    Result=case sd:call(hw_conbee_app,hw_conbee,device_info,[DeviceName],5000) of
	       {ok,[DeviceInfo]}-> 
		   Status=maps:get(device_status,DeviceInfo),
		   maps:get(<<"on">>,Status);
	       Reason ->
		    {error,[Reason,?MODULE,?LINE]}
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
reachable(DeviceName)->
   Result=case sd:call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	      {ok,[DeviceInfo]}->
		  Status=maps:get(device_status,DeviceInfo),
		  maps:get(<<"reachable">>,Status);
	      Reason ->
		  {error,[Reason,?MODULE,?LINE]} 
	   end,
    Result.
