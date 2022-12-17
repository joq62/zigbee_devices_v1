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
-module(hw_conbee_tests).      
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

     ok=setup(),
    ok=start_cluster_test(),
    ok=hw_conbee_app_test(),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
hw_conbee_app_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ApplSpec="hw_conbee",
    HostSpec="c201",
    oam:new_appl(ApplSpec,HostSpec,60*1000),
    AllApps=oam:all_apps(),
    io:format("AllApps ~p~n",[{AllApps,?MODULE,?FUNCTION_NAME}]),
    
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
%%-----------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start_cluster_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    
    ok=oam:new_db_info(),
    oam:new_connect_nodes(),
    {ok,[{pong,'prototype_c201_connect@c201'}]}=oam:ping_connect_nodes(),
     
    {PresentControllers,MissingControllers}=oam:new_controllers(),
    ['1_prototype_c201_controller@c201']= lists:sort(PresentControllers),
    []=MissingControllers,
   
    {PresentWorkers,MissingWorkers}=oam:new_workers(),
    [
     '1_prototype_c201_worker@c201','2_prototype_c201_worker@c201'
    
    ]=lists:sort(PresentWorkers),
    []=MissingWorkers,
    
  
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
    
    ok=application:set_env([{oam,[{cluster_spec,?ClusterSpec}]}]),
    
    
    {ok,_}=db_etcd_server:start(),
    db_etcd:install(),
    ok=db_appl_instance:create_table(),
    ok=db_cluster_instance:create_table(),
    
    {ok,ClusterDir}=db_cluster_spec:read(dir,?ClusterSpec),
    os:cmd("rm -rf "++ClusterDir),
    ok=file:make_dir(ClusterDir),
    {ok,_}=nodelog_server:start(),
    {ok,_}=resource_discovery_server:start(),
    {ok,_}=connect_server:start(),
    {ok,_}=appl_server:start(),
    {ok,_}=pod_server:start(),
    ok=application:start(oam),
    timer:sleep(3000),
    ok.
