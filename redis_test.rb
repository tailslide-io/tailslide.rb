require 'redistimeseries'
using Redistimeseries::RedisRefinement

app_id = 1
flag_id = 1
status = 'success'
redis_client = Redis.new(host:'localhost', port: 6379)
redis_client.ts_add(key: "#{flag_id}:#{status}", timestamp:"*", value:1, labels:["status", status, "appId", app_id, "flagId", flag_id])