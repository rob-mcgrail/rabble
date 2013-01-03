module DeathClock
  EXPIRY = 3600

  def ttl
    time = Time.now.to_i
    life = $r.get(@k + ':life').to_i
    age = time - life
    EXPIRY - age
  end


  def extend(i)
    $r.incrby(@k + ':life', i)
  end


  def decrease(i)
    $r.decrby(@k + ':life', i)
  end

  private

  def start_deathclock(t)
    $r.set(@k + ':life', t)
  end
end