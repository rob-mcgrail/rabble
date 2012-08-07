# DeathClock module manages the expiry of the main rabble key.
#
# Is a mixin for main Rabble class.

module ::DeathClock
  # Set the default key expiry.
  def self.start(slug)
    $r.expire "rab:site:#{slug}", 10800
  end


  # Add arbitrary seconds to the key expiry.
  def extend_life(seconds)
    ttl = $r.ttl "rab:site:#{@slug}"
    $r.expire "rab:site:#{@slug}", ttl + seconds
  end


  # Return the rabble's ttl.
  def death
    $r.ttl "rab:site:#{@slug}"
  end
end