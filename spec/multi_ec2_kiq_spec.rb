require 'spec_helper'
require "threads/Dynamodb"
require "settings"

include MultiEc2Kiq

describe MultiEc2Kiq do
  let(:multi_ec2_kiq) { Class.new{include MultiEc2Kiq} }
  let(:dynamodb) { double("Dynamodb") }

  before(:all) do
    Settings.source(File.expand_path("../../lib/settings.yml", __FILE__))
  end

  it 'has a version number' do
    expect(MultiEc2Kiq::VERSION).not_to be nil
  end

  it 'start should success' do
    Settings.instances.each{|instance|
      expect(multi_ec2_kiq).to receive(:ec2_start)
    }
    multi_ec2_kiq.config_path = File.expand_path("../../lib/settings.yml", __FILE__)
    result = multi_ec2_kiq.start
    expect(result).to eq(true)
  end

  it 'start_wait_until_stop should success' do
    Settings.instances.each{|instance|
      expect(multi_ec2_kiq).to receive(:ec2_start_wait_until_stop)
    }
    multi_ec2_kiq.config_path = File.expand_path("../../lib/settings.yml", __FILE__)
    result = multi_ec2_kiq.start_wait_until_stop
    expect(result).to eq(true)
  end
end
