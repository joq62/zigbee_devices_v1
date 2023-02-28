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
-module(connect_cluster).      
 
-export([start/1]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ClusterSpec,"prototype_c201").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start([InfraNode,Cookie])->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok=setup(InfraNode,Cookie),
    ok=start_cluster_test(),
        
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
  %  init:stop(),
  %  timer:sleep(2000),
    ok.

%%-----------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start_cluster_test()->
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
-define(LocalTypes,[pod_app]).
-define(TargetTypes,[hw_conbee,nodelog]).
setup(InfraNodeStr,Cookie)->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    erlang:set_cookie(node(),list_to_atom(Cookie)),
    InfraNode=list_to_atom(InfraNodeStr),
    Nodes=[InfraNode|rpc:call(InfraNode,erlang,nodes,[],5000)],
    io:format("Nodes ~p~n",[{Nodes,?MODULE,?FUNCTION_NAME}]),
    Ping=[{Node,net_adm:ping(Node)}||Node<-Nodes],
    io:format("Ping ~p~n",[{Ping,?MODULE,?FUNCTION_NAME}]),

    [ok]=[rd:add_local_resource(LocalType,node())||LocalType<-?LocalTypes],
    [ok,ok]=[rd:add_target_resource_type(TargetType)||TargetType<-?TargetTypes],
    ok=rd:trade_resources(),
    
    timer:sleep(4000),
    
    GetState=[{Node,rpc:call(Node,rd,get_state,[],3000)}||Node<-Nodes],

    io:format("GetState ~p~n",[{GetState,?MODULE,?FUNCTION_NAME}]),
    
    ok.
