class Rabble
  include DeathClock
  include Session

  def self.exists?(slug)
    $r.sismember 'rab:meta:rabbles', slug
  end


  def self.valid_name?(name)
    name = Sanitize.clean(name, SanitizeRabbleName)
    slug = name.to_slug.normalize.to_s

    case
    when slug.length == 0
      failed = true
    when slug =~ /^[epac]$/i
      puts '!!!'
      failed = true
    when slug.length > 35
      failed = true
    when name.length > 35
      failed = true
    when Rabble.exists?(slug)
      failed = true
    end

    failed ? false : slug
  end


  def self.get(slug)
    name = $r.hget('rab::' + slug, 'name')

    name ? Rabble.new(name) : nil
  end


  attr_reader :name, :slug, :k, :created_at


  def initialize(name)
    @name = name
    @slug = @name.to_slug.normalize.to_s
    @k = 'rab::' + @slug

    if $r.sadd('rab:meta:rabbles', @slug)
      $r.hset @k, 'name', @name
      $r.hset @k, 'slug', @slug

      t = Time.now.to_i
      $r.hset @k, 'created_at', t
      start_deathclock(t)
    else
      @created_at = $r.hget(@k, 'created_at')
    end
  end


  private

end