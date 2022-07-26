require 'digest'

class Toggler
  attr_reader :flag_name, :get_flags, :emit_redis_signal, :user_context
  attr_accessor :app_id, :flag_id

  def initialize(flag_name: '', get_flags: nil, emit_redis_signal: nil, user_context: '')
    @flag_name = flag_name
    @get_flags = get_flags
    @flag_id = nil
    @app_id = nil
    set_flag_id_and_app_id(flag_name)
    @emit_redis_signal = emit_redis_signal
    @user_context = user_context
  end

  def is_flag_active
    flag = get_matching_flag
    flag['is_active'] && (is_user_white_listed(flag) || validate_user_rollout(flag))
  end

  def emit_success
    return unless flag_id

    p 'emiting success'
    emit_redis_signal.call(flag_id, app_id, 'success')
  end

  def emit_failure
    return unless flag_id

    emit_redis_signal.call(flag_id, app_id, 'failure')
  end

  private

  def get_matching_flag
    flag = get_flags.call.find { |flag| flag['title'] == flag_name }
    raise Exception, "Cannot find flag with flag name of: #{flag_name}" unless flag

    flag
  end

  def set_flag_id_and_app_id(_flag_name)
    matching_flag = get_matching_flag
    self.flag_id = matching_flag['id']
    self.app_id = matching_flag['app_id']
  end

  def is_user_white_listed(flag)
    flag['white_listed_users'].split(',').include?(user_context)
  end

  def validate_user_rollout(flag)
    rollout = flag['rollout_percentage'] / 100.0
    rollout *= (flag['circuit_recovery_percentage'] / 100.0) if is_circuit_in_recovery(flag)
    is_user_in_rollout(rollout)
  end

  def is_circuit_in_recovery(flag)
    flag['is_recoverable'] && flag['circuit_status'] == 'recovery'
  end

  def is_user_in_rollout(rollout)
    puts "User context hash #{hash_user_context}"
    puts "Rollout: #{rollout}"
    hash_user_context <= rollout
  end

  def hash_user_context
    (Digest::MD5.hexdigest(user_context).to_i(base = 16) % 100) / 100.0
  end
end

