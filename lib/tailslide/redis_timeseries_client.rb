require 'redistimeseries'
using Redistimeseries::RedisRefinement

class RedisTimeSeriesClient
  attr_reader :host, :port
  attr_accessor :redis_client

  def initialize(host, port)
    @host = host || 'localhost'
    @port = port || 6379
  end

  def init
    self.redis_client = Redis.new(host: host, port: port)
  end

  def emit_signal(flag_id, app_id, status)
    redis_client.ts_add(key: "#{flag_id}:#{status}", timestamp: '*', value: 1,
                        labels: ['status', status, 'appId', app_id, 'flagId', flag_id])
  end
end

