require 'spec_helper'
require "settings"
require "threads/Dynamodb"

include MultiEc2Kiq

describe Dynamodb do
  before(:all) do
    Settings.source(File.expand_path("../../../lib/settings.yml", __FILE__))
    @dynamodb = Dynamodb.new
  end

  it 'should create statud table.' do
    expect(@dynamodb).to receive(:create_table).with(anything, anything)
    result = @dynamodb.create_status_table
    expect(result).to eq(true)
  end

  it 'should write started.' do
    expect(@dynamodb).to receive(:put_item).with(anything, anything)
    result = @dynamodb.started("instance_test")
    expect(result).to eq(true)
  end

  it 'should wait until to stop.' do
    StatusData = Struct.new("StatusData", :item)
    status_data = StatusData.new({"instance_id"=>"instance_test", "status"=>"to_stop"})
    expect(@dynamodb).to receive(:get_item).and_return(status_data)
    result = @dynamodb.wait_until_to_stop("instance_test")
    expect(result).to eq(true)
  end

  it 'should write stopped.' do
    status_data = StatusData.new({"instance_id"=>"instance_test", "status"=>"to_stop"})
    expect(@dynamodb).to receive(:get_item).and_return(status_data)
    expect(@dynamodb).to receive(:put_item).with(anything, anything)
    result = @dynamodb.stopped("instance_test")
    expect(result).to eq(true)
  end
end