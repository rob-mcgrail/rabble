module Session
  def register_session(i)
    $r.sadd(@k + ':sessions', i)
  end


  def valid_session?(i)
    $r.sismember(@k + ':sessions', i)
  end


  def remove_session(i)
    $r.srem(@k + ':sessions', i)
  end
end