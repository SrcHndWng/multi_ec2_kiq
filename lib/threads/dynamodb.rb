require "settings"
require "aws-sdk-core"
require "ostruct"

module MultiEc2Kiq
  class Dynamodb
    def initialize
      @STATUS = OpenStruct.new(started: "started", stopped: "stopped", to_stop: "to_stop")
    end

    def started(instance_id)
      put_item(instance_id, @STATUS.started)
      true
    end

    def wait_until_to_stop(instance_id)
      (0...Settings.wait_to_stop.max_attempts).each{|i|
        data = get_item(instance_id)
        raise_not_exist if !data.item
        return true if data.item["status"] == @STATUS.to_stop
        sleep(Settings.wait_to_stop.delay)
      }
      false
    end

    def stopped(instance_id)
      raise_not_exist if !get_item(instance_id).item
      put_item(instance_id, @STATUS.stopped)
      true
    end

    def create_status_table
      options = {
        table_name: Settings.aws.dynamodb.status_table_name,
        key_schema: [
          {
              attribute_name: "instance_id",
              key_type: "HASH"
          }
        ],
        attribute_definitions: [
          {
              attribute_name: "instance_id",
              attribute_type: "S"
          }
        ],
        provisioned_throughput: {
          read_capacity_units:  1,
          write_capacity_units:  1
        }
      }

      create_table(options, Settings.aws.dynamodb.status_table_name)

      true
    end

    private

    def create_table(options, table_name)
      dynamodb.create_table(options)

      dynamodb.wait_until(:table_exists, {table_name: table_name}) do |w|
        w.max_attempts = 5
        w.delay = 5
      end
    end

    def raise_not_exist
      raise "instance_id doesn't exist on status table."
    end

    def get_item(instance_id)
      dynamodb.get_item(
        table_name: Settings.aws.dynamodb.status_table_name,
        key: {instance_id: instance_id}
      )
    end

    def put_item(instance_id, status)
      dynamodb.put_item(
        table_name: Settings.aws.dynamodb.status_table_name,
        item: {instance_id: instance_id, status: status}
      )
    end

    def dynamodb
      @dynamodb ||= Aws::DynamoDB::Client.new(
        region: Settings.aws.dynamodb.region,
        profile: Settings.aws.profile
      )
    end
  end
end