%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_weather).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.weather").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%   {"TRADFRI control outlet",
%     "2",
%         #{<<"alert">> => <<"none">>,
%           <<"on">> => false,
%           <<"reachable">> => false}},




%% External exports
-export([
	 temp/1,
	 humidity/1,
	 pressure/1
	]). 


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

temp(DeviceName)->
    Result=case rd:rpc_call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	       {error,Reason}->
		   {error,Reason};
	       {ok,Maps}-> 
		   [WantedMap]=[Map||Map<-Maps,
				    lists:member(<<"temperature">>, maps:keys(maps:get(device_status,Map)))],
		   StateMap=maps:get(device_status,WantedMap),
		   TempRaw=maps:get(<<"temperature">>,StateMap),
		   {ok,float_to_list(TempRaw/100,[{decimals,1}])}
	   end,
    Result.
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
humidity(DeviceName)->
    Result=case rd:rpc_call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	       {error,Reason}->
		   {error,Reason};
	       {ok,Maps}-> 
		   [WantedMap]=[Map||Map<-Maps,
				    lists:member(<<"humidity">>, maps:keys(maps:get(device_status,Map)))],
		   StateMap=maps:get(device_status,WantedMap),
		   HumidityRaw=maps:get(<<"humidity">>,StateMap),
		   {ok,float_to_list(HumidityRaw/100,[{decimals,1}])++"%"}
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
%<<"pressure">>
pressure(DeviceName)->
    Result=case rd:rpc_call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	       {error,Reason}->
		   {error,Reason};
	       {ok,Maps}-> 
		   [WantedMap]=[Map||Map<-Maps,
				    lists:member(<<"pressure">>, maps:keys(maps:get(device_status,Map)))],
		   StateMap=maps:get(device_status,WantedMap),
		   PressureRaw=maps:get(<<"pressure">>,StateMap),
		   {ok, integer_to_list(PressureRaw)}
	   end,
    Result.
