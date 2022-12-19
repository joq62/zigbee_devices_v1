% [{model_id, },{device_type,"sensors"}].
% [{model_id, },{device_type,"lights"}].
-define(DeviceInfo,
	[#{model_id=>"lumi.sensor.motion.aq2",device_type=>"sensors",module=>lumi_sensor_motion_aq2},
	 #{model_id=>"lumi.weather",device_type=>"sensors",module=>lumi_weather},
	 #{model_id=>"TRADFRI on/off switch",device_type=>"sensors" ,module=>tradfri_on_off_switch},
	 #{model_id=>"TRADFRI motion sensor",device_type=>"sensors",module=>tradfri_motion },
	 #{model_id=>"TRADFRI control outlet",device_type=>"lights" ,module=>tradfri_control_outlet},
	 #{model_id=>"TRADFRIbulbE14WScandleopal470lm",device_type=>"lights",module=>tradfri_bulb_E14_ws_candleopal_470lm},
	 #{model_id=>"TRADFRI bulb E27 WW 806lm",device_type=>"lights",module=>tradfri_bulb_e27_cws_806lm}
	]).

