require 'spec_helper'
require "settings"
require "threads/EC2"

include MultiEc2Kiq

describe Ec2 do
  let(:dynamodb) { double("Dynamodb") }

  before(:all) do
    Settings.source(File.expand_path("../../../lib/settings.yml", __FILE__))
    instance = Settings.instances[0]
    @ec2 = Ec2.new(instance["id"], instance["region"])
  end

  it 'should ec2 start.' do
    expect(@ec2).to receive(:start_instance)
    result = @ec2.start
    expect(result).to eq(true)
  end

  describe 'start_wait_until_stop' do
    it 'get to_stop status' do
      expect(@ec2).to receive(:dynamodb).and_return(dynamodb).at_least(:once)
      expect(@ec2).to receive(:start)
      expect(dynamodb).to receive(:started).with(anything)
      expect(dynamodb).to receive(:wait_until_to_stop).with(anything).and_return(true)
      expect(@ec2).to receive(:stop_instance)
      expect(dynamodb).to receive(:stopped).with(anything)

      result = @ec2.start_wait_until_stop
      expect(result).to eq(true)
    end

    it 'to_stop does not exist.' do
      expect(@ec2).to receive(:dynamodb).and_return(dynamodb).at_least(:once)
      expect(@ec2).to receive(:start)
      expect(dynamodb).to receive(:started).with(anything)
      expect(dynamodb).to receive(:wait_until_to_stop).with(anything).and_return(false)

      result = @ec2.start_wait_until_stop
      expect(result).to eq(true)
    end
  end
end
