%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(pid_server). 
 
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports
-export([
	 on/0,
	 off/0,
	 calibrate/1,
	 temp/0,
	 loop_temp/1
	 
	]).


-export([
	 ping/0,
	 start/0,
	 stop/0
	]).


%% gen_server callbacks



-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%-------------------------------------------------------------------
-define(Kp,0,5).
-define(Ki,0,5).
-define(Kd,0,5).
-define(Dt,20*1000).
-define(PwmInterval,50*1000).
-define(TempSensor,"temp_prototype").
-define(Switch,"switch_prototype").


% Kp - proportional gain
% Ki - integral gain
% Kd - derivative gain
% dt - loop interval time
% previous_error := 0
% integral := 0
% loop:
%   error := setpoint − measured_value
%   proportional := error;
%   integral := integral + error × dt
%   derivative := (error − previous_error) / dt
%   output := Kp × proportional + Ki × integral + Kd × derivative
%   previous_error := error
%   wait(dt)
%   goto loop
%   pwm_interval = 50 seconds 
%   dt= 20 sec						%
%   0 <= pwm_value <= pwm_interval  
-record(state,{
	       pwm_interval,
	       pwm_value,
	       setpoint,
	       previous_error,
	       integral,
	       kp,
	       ki,
	       kd,
	       dt
	       
	       
	      }).


%% ====================================================================
%% External functions
%% ====================================================================

	    
%% call
start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).
ping()-> 
    gen_server:call(?MODULE, {ping},infinity).

temp()-> 
    gen_server:call(?MODULE, {temp},infinity).
%% cast(
calibrate(EndTemp)-> 
    gen_server:cast(?MODULE, {calibrate,EndTemp}).
loop_temp(Interval)-> 
    gen_server:cast(?MODULE, {loop_temp,Interval}).

on()-> 
    gen_server:cast(?MODULE, {on}).
off()-> 
    gen_server:cast(?MODULE, {off}).
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
handle_call({temp},_From, State) ->
    Reply=zigbee_devices_server:get(?TempSensor,temp,[]),
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
handle_cast({on}, State) ->
    zigbee_devices_server:get(?Switch,set,["on"]),
    {noreply, State};
handle_cast({off}, State) ->
    zigbee_devices_server:get(?Switch,set,["off"]),
    {noreply, State};
handle_cast({calibrate,EndTemp}, State) ->
    spawn(fun()->do_calibrate(EndTemp) end),
   
    {noreply, State};

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
do_calibrate(EndTemp)->
    StartTime=os:system_time(second),
    zigbee_devices_server:get(?Switch,set,["on"]),
    loop(StartTime,EndTemp).

loop(StartTime,EndTemp)->
    {ok,Temp}=zigbee_devices_server:get(?TempSensor,temp,[]),
    DiffTemp=EndTemp-list_to_float(Temp),
    Time=os:system_time(second)-StartTime,
    if 
	DiffTemp<0->
	    io:format("STOPPED: Time ,DiffTemp  ~p~n",[{Time,DiffTemp,?MODULE,?FUNCTION_NAME,?LINE}]),
	    zigbee_devices_server:get(?Switch,set,["off"]),
	    timer:sleep(10*1000),
	    loop(StartTime,EndTemp);
	 true->
	    io:format("Time ,DiffTemp  ~p~n",[{Time,DiffTemp,?MODULE,?FUNCTION_NAME,?LINE}]),
	    timer:sleep(15*1000),
	    loop(StartTime,EndTemp)
    end.
