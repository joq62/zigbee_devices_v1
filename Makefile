#	Service Makefile
all:  
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra* *.dir;
	rm -rf rebar.lock;	
	rm -rf tests_ebin;
	rm -rf ebin;
	rm -rf Mnesia.*;
	rm -rf *.dir;
	rm -rf _build;
	rm -rf rebar.config;
	cp tests/rebar.config_release rebar.config;
	mkdir ebin;
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build;
	rm -rf ebin;
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
	rm -rf tests_ebin;
	git add  *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
clean:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra* *.dir;
	rm -rf rebar.lock;
	rm -rf  application_specs cluster_specs host_specs;
	rm -rf  application_deployments cluster_deployments;	
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*;
	rm -rf _build;	
	rm -rf *.dir

eunit:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra*;
	rm -rf rebar.lock;
	rm -rf _build;
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*;
	rm -rf *.dir;
	rm -rf rebar.config;
	cp tests/rebar.config_tests rebar.config;
#	tests 
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
#	application
	mkdir ebin;
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;	
	erl -pa * -pa ebin -pa tests_ebin -sname do_test -run $(m) start -setcookie test_cookie

target:
	erl -pa * -pa ebin -pa tests_ebin -sname do_test -run $(m) start -setcookie test_cookie
