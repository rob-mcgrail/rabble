# Identifies conversations with expired rab:site keys and removes them.

class Harvester
  # Find slugs in the rab:sites set that have expired
  # main keys.
  #
  # Returns an array of the expired rabble's slugs.
  def self.identify
    a = []
    $r.smembers('rab:sites').each do |slug|
      unless $r.exists "rab:site:#{slug}"
        a << slug
      end
    end
    a
  end


  # The complete deletion of the rabble.
  #
  # Need to add any new rabble keys here as they are added.
  def self.harvest(slug)
    $r.srem 'rab:sites', slug
    $r.del "rab:sites:#{slug}:pw"
  end
end