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
-module(all).      
    
 
-export([
	 start/1
	]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(CookieStr,"cookie_conbee").
-define(ParentNode,'conbee_parent@c201').
                  

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

start([Arg1,Arg2])->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    io:format("Cookie , ParentNode ~p~n",[{list_to_atom(Arg1),list_to_atom(Arg2),?MODULE,?FUNCTION_NAME}]),
    
    ok=setup(?CookieStr,?ParentNode),
    ok=zigbee_tests_1:start(),
    
      
   
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
 %   timer:sleep(2000),
 %  init:stop(),
    ok.



%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
setup(CookieStr,ParentNode)->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),


    true=erlang:set_cookie(node(),list_to_atom(CookieStr)),
    pong=net_adm:ping(ParentNode),
    PingR=[{net_adm:ping(Node),Node}||Node<-rpc:call(ParentNode,erlang,nodes,[],5000)],
    io:format("PingR ~p~n",[{PingR,?MODULE,?FUNCTION_NAME}]),
    ok=application:start(common),
    ok=application:start(sd),
   
        
    ok=application:start(zigbee_devices),
    pong=zigbee_devices:ping(),
    
    
    
    ok.
