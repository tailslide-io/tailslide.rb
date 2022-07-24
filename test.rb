require "async"
# require "./lib/tailslide/nats_client.rb"
require_relative "lib/tailslide/flag_manager.rb"
require_relative 'lib/tailslide/toggler'

# def logMessage(message)
#   p message
# end

# config = {server_url: "localhost:4222", callback: :p, token: 'myToken', stream:"flags", subject:'1'}
app_id = "1"
flag_name = 'Flag in app 1 number 1'

config = {nats_server:'localhost:4222', stream:'flags', app_id:app_id, sdk_key:'myToken', user_context:'375d39e6-9c3f-4f58-80bd-e5960b710295'}


Async do |task|
  manager = FlagManger.new(**config) 
  manager.initialize_flags
  flag_config = {"flag_name": flag_name}
  
  flag_toggler = manager.new_toggler(flag_config)
  
  p "hello"
  while true 
    if flag_toggler.is_flag_active
      p "Flag in #{app_id} with name \"#{flag_name}\" is active!"
      # flag_toggler.emit_success()
    else
      p "Flag in #{app_id} with name \"#{flag_name}\" is not active!"
      # flag_toggler.emit_failure()
    end
    sleep 4
  end
end


# require "nats/client"
# require "async"
# TimeoutError = NATS::IO::Timeout
# require 'json'

# token = "myToken"

# nats_client = NATS.connect("nats://#{token}@127.0.0.1:4222")
# jet_stream = nats_client.jetstream

# # get last message
# latest_msg = jet_stream.get_last_msg("flags", "test")
# json_data = JSON.parse latest_msg.data
# p json_data


# # pull subscribe for new onging messages (workaround until Nats.rb make new update)
# subscribed_stream = jet_stream.pull_subscribe("test", 'mydurable', config: { deliver_policy: 'new' })
# Async do |task|
#   task.async do 
#       begin
#       messages = subscribed_stream.fetch(1)
#       messages.each do |message|
#         message.ack
#         json_data = JSON.parse message.data
#         p json_data
#       end
#     rescue NATS::Timeout => e
#       p e
#     end until nats_client.closed?
#   end
#   p "hello past async"
# end



# push subscribe for new ongoing messages
# setting deliver_policy still results in delivering all messages in "test" subject
# push_sub = jetStream.subscribe("test", {manual_ack: true, deliver_policy:"new"} ) do |msg|
#   msg.ack
#   puts msg.data
# end

# Get ongoing messages
# Push subscribe
# consumer_req = {
#   stream_name: "test",
#   config: {
#     durable_name: "sample",
#     deliver_policy: "new",
#     ack_policy: "explicit",
#     max_deliver: -1,
#     replay_policy: "instant"
#   }
# }

# config = NATS::JetStream::API::ConsumerConfig.new({ deliver_policy: "new" })
  # Create inbox for push consumer.
# deliver = natsClient.new_inbox
# config.deliver_subject = deliver

# push_sub = jetStream.subscribe("test", {manual_ack: true, deliver_policy:"new"} ) do |msg|
#   puts msg.data
# end

# cinfo = push_sub.consumer_info["config"]
# puts cinfo
# msg = push_sub.next_msg(timeout: 10000000000)
# msg.ack
# puts msg.data
# push_sub.consumer_info["config"]["deliver_policy"] = "new"
# puts cinfo

# loop do
#   msgs = push_sub.next_msg()
#   puts msgs.data
# rescue TimeoutError => e
#   puts e
#   sleep 1
# end

# js.publish("9", "Hello JetStream! 1")
# js.publish("9", "Hello JetStream! 2")
# js.publish("9", "Hello JetStream! 3")
# js.publish("9", "Hello JetStream! 4")
# js.publish("9", "Hello JetStream! Latest")
