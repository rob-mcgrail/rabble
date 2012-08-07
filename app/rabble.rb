# Main class for rabbles.
#
# Provides a number of class methods of creating and getting
# rabbles, and individual rabble behaviour.

class Rabble
  include DeathClock
  attr_reader :name, :slug, :created

  # Check that a name is valid.
  def self.valid_name?(name)
    # Normalize the name into a slug.
    slug = name.parameterize

    # Check is name is used, to is too short (for route matcher).
    if $r.sismember('rab:sites', slug) or slug.length < 3
      nil
    else
      true
    end
  end


  # Create a new rabble.
  #
  # Establishes all keys for the rabble.
  def self.create(name)
    # Normalize the name into a slug.
    slug = name.parameterize

    # Add slug to the master set.
    $r.sadd 'rab:sites', slug

    # Create a main hash for the rabble.
    $r.hset "rab:site:#{slug}", 'name', name
    $r.hset "rab:site:#{slug}", 'created', Time.now.to_i

    # Store password in its own key to avoid accidental access.
    $r.set "rab:site:#{slug}:pw", String.random

    # Start the deathclock.
    # Sets expiry key for the main rabble's hash key.
    DeathClock.start(slug)

    # Return the newly created rabble.
    self.get(slug)
  end


  # Returns rabble object, by slug.
  def self.get(slug)
    if $r.exists "rab:site:#{slug}"
      self.new(slug)
    else
      nil
    end
  end


  # Setup instance variables for new rabble object.
  def initialize(slug)
    @slug = slug

    # Get the main rabble hash.
    site = $r.hgetall "rab:site:#{@slug}"

    @name = site['name']
    # Get time since creation in seconds.
    @created = Time.now.to_i - site['created'].to_i
  end


  # Getter for rabble's password.
  def password
    $r.get "rab:site:#{@slug}:pw"
  end
end