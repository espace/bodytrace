BodyTrace
=========

BodyTrace is a Ruby gem enabling receiving and storing requests from [BodyTrace](http://bodytrace.com/medical/)'s digital scale:
![alt](http://bodytrace.com/img/scale.png)

###Installation
run:
```
    gem install bodytrace
```
or add to your Gemfile:
```
    gem 'bodytrace'
```

###Usage
this gem generate a platform to catch/store BodyTrace's digital scale POST requests in this format:
>{"deviceId":XXXXXXXXXXXXX,"ts":1380562575798,"batteryVoltage":5522,"rssi":91,"values
":{"unit":1,"weight":69800,"tare":0}}

Where:

* deviceId: [IMEI](http://en.wikipedia.org/wiki/International_Mobile_Station_Equipment_Identity) serial number (without leading zeros and the last digit)

* ts: timestamp when the measurement was taken represented in milliseconds since UNIX Epoch, UTC

* batteryVoltage: battery voltage (mV) - functional battery voltage range: 4.7-6.0 V (could 
go a little over 6.0 V)

* rssi: signal strength in (- dBm) - can be converted into "percentage" by this formula: 
min(0, max(1, (115 - rssi) / 52)) * 100

* values/unit: measurement unit the scale was in at the time of taking the measurement

* values/weight: weight value (in grams - regardless of unit)
* values/tare:  It shows the difference between the zero point setting before the weigh-in and after. If it is greater than + 0.1 kg, that means that the scale has a calibration error and the value sent as the weight value was offset by the amount indicated in the tare value. 

---

run:
```
    rails g body_trace:install user_name password BodytraceMeasurement Device User
```

where:
####user_name [Required]:
> http authentication user_name required to parse BodyTrace requests.

####password [Required]:
> http authentication password required to parse BodyTrace requests.

####BodytraceMeasurement [Optional & default: BodytraceMeasurement]
> Name of the model which will hold requests data comes from BodyTrace API.

####Device  [Optional & default: Device]:
> Name of the model which will hold information about "which user uses which scale device"

####User [Optional & default: User]:
> Name of already existing "user" model that will be used to link with a scale device.


this will generate:
```
    route  resources :bodytrace_measurements, only: [:create]
    create  app/models/bodytrace_measurement.rb
    create  app/models/device.rb
    create  app/controllers/bodytrace_measurements_controller.rb
    create  db/migrate/20140707135956_create_bodytrace_measurements.rb
    create  db/migrate/20140707135957_create_devices.rb

```


---

Then:

Provide [BodyTrace Team](http://www.bodytrace.com/contact.html) with a URL to [POST] Requests on it. In above example URL will be:
```
[POST] sitename.com/bodytrace_measurements
```
and provide them with user_name and password you generated for HTTP basic authentication.

---

###list of supported Requests / Responses :

 Request: # heartbeat message
  > {"deviceId":XXXXXXXXXXXXX,"ts":1391436314212,"batteryVoltage":5603,"rssi":80,"values":{}}
  
Response: 
  > 204 - No content

---

Request: # real error-free request
  > {"deviceId":XXXXXXXXXXXXX,"ts":1380562575798,"batteryVoltage":5522,"rssi":91,"values":{"unit":1,"weight":69800}}
  
Response: 
  > 200 - OK

---------------

Request: # receiving "deviceId" not registered with a user
  > {"deviceId":XXXXXXXXXXXXX,"ts":1380562575798,"batteryVoltage":5522,"rssi":91,"values":{"unit":1,"weight":69800}
  
Response: 
  > 404 - Not Found

---------------

Request: # missing parameter request, missing "deviceId"
  > {"ts":1380562575798,"batteryVoltage":5522,"rssi":91,"values":{"unit":1,"weight":69800}}

Response: 
  > 422 - unprocessable entity

---------------

Request: # missing parameter request, missing "values" paramter
  >{"deviceId":XXXXXXXXXXXXX,"ts":1380562575798,"batteryVoltage":5522,"rssi":91}}

Response: 
  > 422 - unprocessable entity

---------------

Request: # syntax-error in the request parameters, missing '}'
  > {"deviceId":XXXXXXXXXXXXX,"ts":1380562575798,"batteryVoltage":5522,"rssi":91,"values":{"unit":1,"weight":69800}

Response: 
  > 400 - Bad Request

---------------
