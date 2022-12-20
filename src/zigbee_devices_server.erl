%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(zigbee_devices_server).
 
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("device.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([

	]).


-export([

	 start/0,
	 stop/0
	]).


%% gen_server callbacks



-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%-------------------------------------------------------------------

-record(state,{
	      }).


%% ====================================================================
%% External functions
%% ====================================================================

	    
%% call
start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).




%% cast

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    rd:rpc_call(nodelog,nodelog,log,[notice,?MODULE_STRING,?LINE,["Server started"]]),
    {ok, #state{}}.   
 

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({call,DeviceName,Function,Args},_From, State) ->
    Reply=case rd:rpc_call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	      {error,Reason}->
		  {error,Reason};
	      {ok,[DeviceInfo|_]}->
		  ModelId=maps:get(device_model,DeviceInfo),
		  [Module]=[maps:get(module,Map)||Map<-?DeviceInfo,
						  ModelId==maps:get(model_id,Map)],
		  AllArgs=[DeviceName|Args],
		  rpc:call(node(),Module,Function,AllArgs,2000);
	      UnMatchedSignal->
		  {error,UnMatchedSignal}
	  end,
    {reply, Reply, State};

handle_call({set,DeviceName,Function,Args},_From, State) ->
    Reply=case rd:rpc_call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	      {error,Reason}->
		  {error,Reason};
	      {ok,[DeviceInfo|_]}->
		  ModelId=maps:get(device_model,DeviceInfo),
		  [Module]=[maps:get(module,Map)||Map<-?DeviceInfo,
						  ModelId==maps:get(model_id,Map)],
		  AllArgs=[DeviceName|Args],
		  rpc:call(node(),Module,Function,AllArgs,2000);
	      UnMatchedSignal->
		  {error,UnMatchedSignal}
	  end,
    {reply, Reply, State};

handle_call({get,DeviceName,Function,Args},_From, State) ->
    Reply=case rd:rpc_call(hw_conbee,hw_conbee,device_info,[DeviceName],1000) of
	      {error,Reason}->
		  {error,Reason};
	      {ok,[DeviceInfo|_]}->
		  ModelId=maps:get(device_model,DeviceInfo),
		  [Module]=[maps:get(module,Map)||Map<-?DeviceInfo,
						  ModelId==maps:get(model_id,Map)],
		  AllArgs=[DeviceName|Args],
		  rpc:call(node(),Module,Function,AllArgs,2000);
	      UnMatchedSignal->
		  {error,UnMatchedSignal}
	  end,
    {reply, Reply, State};


handle_call({status,DeviceName},_From, State) ->
    Reply=State,
    {reply, Reply, State};

handle_call({ping},_From, State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{Msg,?MODULE,?LINE}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info(timeout, State) -> 
    io:format("timeout ~p~n",[{?MODULE,?LINE}]), 
    
    {noreply, State};

handle_info(Info, State) ->
    io:format("unmatched match~p~n",[{Info,?MODULE,?LINE}]), 
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
