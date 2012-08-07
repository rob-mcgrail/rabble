helpers do
  def title(arg = nil)
    @title = arg ? 'Sitename | ' + arg : @title = 'Sitename'
  end
end
