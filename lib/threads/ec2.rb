require "settings"
require "aws-sdk-core"
require "threads/Dynamodb"

module MultiEc2Kiq
  class Ec2
    def initialize(id, region)
      @id = id
      @region = region
    end

    def start
      start_instance
      puts_started_message
      true
    end

    def start_wait_until_stop
      start
      dynamodb.started(@id)

      if dynamodb.wait_until_to_stop(@id)
        stop_instance
        dynamodb.stopped(@id)
      end
      
      true
    end

    private

    def puts_started_message
      puts Time.now.to_s + " EC2 started. id = " + @id + ", region = " + @region + "."
    end

    def stop_instance
      ec2.stop_instances(instance_ids: [@id])
      ec2.wait_until(:instance_stopped,  instance_ids:[@id])
    end

    def start_instance
      ec2.start_instances(instance_ids: [@id])
      ec2.wait_until(:instance_running,  instance_ids:[@id])
    end

    def ec2
      @ec2 ||= Aws::EC2::Client.new(
        region: @region,
        profile: Settings.aws.profile
      )
    end

    def dynamodb
      @dynamodb ||= Dynamodb.new
    end
  end
end
