# MultiEc2Kiq

This gem starts multi ec2 instances, and stops them if you command.

## Description
This has two methods, "start" and "start_wait_until_stop".
Below are the methods.

* start  
"start" allows you to start ec2 instances that defined in yml file that as settings.

* start_wait_until_stop  
"start_wait_until_stop" allows you to start ec2 instances, then it waits until you command to stop then stop them.  
After ec2 instances start, it registers ec2 "started" status in Dynamodb table.  
If you want to command ec2 stop, you have to update above status to "to_stop", then it stops the ec2.  
After ec2 stopped, it registers ec2 "stopped" status.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_ec2_kiq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_ec2_kiq

## Usage

You have to set aws profile in your ~/.aws/credentials.  
  
Write configuration yml file, use "lib/settings.yml" as a reference.  
  
To create ec2-status-table on DynamoDB, you have to call Dynamodb::create_status_table method from rails console, ruby source, e.t.c.
```ruby
    dynamodb = Dynamodb.new
    dynamodb.create_status_table
```
  
Then, call methods.
```ruby
    require "multi_ec2_kiq"

    include MultiEc2Kiq

    MultiEc2Kiq.config_path = File.expand_path("your configuration file path", __FILE__)
    MultiEc2Kiq.start
```
  
```ruby
    require "multi_ec2_kiq"

    include MultiEc2Kiq

    MultiEc2Kiq.config_path = File.expand_path("your configuration file path", __FILE__)
    MultiEc2Kiq.start_wait_until_stop
```