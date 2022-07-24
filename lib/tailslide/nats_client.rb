require 'async'
require "nats/client"
TimeoutError = NATS::IO::Timeout
require 'json'


class NatsClient
  attr_accessor :nats_connection, :jetstream, :subscribed_stream
  attr_reader :connection_string, :subject, :callback
  def initialize(server_url:'localhost:4222', subject:'', callback:nil, token:'')
    @subject = subject
    @connection_string = "nats://#{token}#{'@' if token}#{server_url}"
    @callback = method(callback)
  end
  
  def initialize_flags
    connect()
    fetch_latest_message()
    fetch_ongoing_event_messages()
  end
  
  private
  def connect
    self.nats_connection = NATS.connect(connection_string)
    self.jetstream = nats_connection.jetstream
  end
  
  def fetch_latest_message
    begin
      latest_msg = jetstream.get_last_msg("flags", subject)
      json_data = JSON.parse latest_msg.data
      p json_data
      p callback
      callback.call(json_data)
    rescue NATS::Timeout => e
      p e
    end
  end
  
  def fetch_ongoing_event_messages
    Async do |task|
     task.async do
      self.subscribed_stream = jetstream.pull_subscribe("test", 'mydurable', config: { deliver_policy: 'new' })
      begin
        messages = subscribed_stream.fetch(1)
        messages.each do |message|
          message.ack
          json_data = JSON.parse message.data
          callback.call(json_data)
        end
      rescue NATS::Timeout => e
      end until nats_connection.closed?
     end
    end
  end
  
  def disconnect
    nats_connection.close
  end
end