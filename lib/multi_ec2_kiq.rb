require "multi_ec2_kiq/version"
require "settings"
require "threads/ec2"

module MultiEc2Kiq
  attr_accessor :config_path

  def start
    Settings.source(config_path)
    instances = Settings.instances
    threads = []

    instances.each {|instance| settings_check(instance)}
    instances.each {|instance|
      threads << Thread.new do
        ec2_start(instance)
      end
    }

    threads.each { |t| t.join }

    true
  end

  def start_wait_until_stop
    Settings.source(config_path)
    instances = Settings.instances
    threads = []

    instances.each {|instance| settings_check(instance)}
    instances.each {|instance|
      threads << Thread.new do
        ec2_start_wait_until_stop(instance)
      end
    }

    threads.each { |t| t.join }

    true
  end

  private

  def settings_check(e)
    raise "instance_configs requires id." if !e.has_key?("id")
    raise "instance_configs requires region." if !e.has_key?("region")
  end

  def ec2_start(instance)
    Ec2.new(instance["id"], instance["region"]).start
  end

  def ec2_start_wait_until_stop(instance)
    Ec2.new(instance["id"], instance["region"]).start_wait_until_stop
  end
end
