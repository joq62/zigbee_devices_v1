all:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra* *.dir;
	rm -rf rebar.lock;
	rm -rf  application_specs cluster_specs host_specs;
	rm -rf  application_deployments cluster_deployments;	
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*;
	rm -rf *.dir;
	rm -rf _build;
	rm -rf prototype_c201;
	mkdir ebin;
	erlc -I include -o ebin src/*.erl;
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
	rm -rf tests_ebin;
	rm -rf ebin;
	git add *;
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
	rm -rf prototype_c201;
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
	rm -rf prototype_c201;
#	tests 
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
	cp tests/*.app tests_ebin;
#	application
	mkdir ebin;
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	erlc -I include -o ebin src/*.erl;
	erl -pa * -pa ebin -pa tests_ebin -sname zigbee_devices_test -run $(m) start -setcookie test_cookie 
