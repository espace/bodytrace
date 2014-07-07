describe "BodyTrace Measurements" do 

  describe "Manage bodyTrace measurements" do

    it "create new bodyTrace measurement by a device registered with a user" do

      credentials = ActionController::HttpAuthentication::Basic.encode_credentials("body_trace","m345ur3m3n757r4c3b0dy")
      @env ||= {}
      @env['HTTP_AUTHORIZATION'] = credentials

      FactoryGirl.create(:device, imei_device_serial: "013227003125444")

      post bodytrace_measurements_path , {deviceId: "1322700312544", ts: "1380562575798" ,batteryVoltage: "5522", rssi: "91",
        values:{unit: 1, weight: 69800}}, @env

      response.status.should be(200) 
    end


    it "create new bodyTrace measurement by a device not registered with a user" do

      credentials = ActionController::HttpAuthentication::Basic.encode_credentials("body_trace","m345ur3m3n757r4c3b0dy")
      @env ||= {}
      @env['HTTP_AUTHORIZATION'] = credentials

      post bodytrace_measurements_path , {deviceId: "1234567890123", ts: "1380562575798" ,batteryVoltage: "5522", rssi: "91",
        values:{unit: 1, weight: 69800}}, @env

      response.status.should be(404) #response should be "NOT FOUND"
    end
  end
end