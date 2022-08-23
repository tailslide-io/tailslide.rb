require_relative 'nats_client'
require_relative 'redis_timeseries_client'
require_relative 'toggler'

class FlagManager

  def initialize(nats_server: '', stream: '', app_id: '', sdk_key: '', user_context: '', redis_host: '', redis_port: '')
    @nats_client = NatsClient.new(server_url: nats_server, stream: stream, subject: app_id, callback: method(:set_flags),
                                  token: sdk_key)
    @redis_ts_client = RedisTimeSeriesClient.new(redis_host, redis_port)
    @user_context = user_context
    @flags = []
  end

  def initialize_flags
    @nats_client.initialize_flags
    @redis_ts_client.init
  end

  def set_flags(flags)
    @flags = flags
  end

  def get_flags
    @flags
  end
  
  def set_user_context(new_user_context)
    @user_context = new_user_context
  end
  
  def get_user_context
    @user_context
  end

  def disconnect
    @nats_client.disconnect
    @redis_ts_client.disconnect
  end

  def new_toggler(config)
    Toggler.new(**config, get_flags: method(:get_flags), user_context: get_user_context,
                          emit_redis_signal: @redis_ts_client.method(:emit_signal))
  end
end

