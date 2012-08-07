# Helpers added to String

class String
  def parameterize(delimeter = '-')
    self.gsub(/[^a-z0-9\-_!?]+/i, delimeter).downcase
  end

  def encrypt
    BCrypt::Password.create(self)
  end

  def make_matchable
    BCrypt::Password.new(self)
  end

  def self.random(i=4)
    (0...i).map{65.+(rand(25)).chr}.join
  end
end
