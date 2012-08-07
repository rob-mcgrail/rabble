# Main route for a rabble.
#
# Matches strings longer than 3 characters, without a second /
get %r(^\/([^\/+]{3,})) do |slug|
  # Get rabble
  @rabble = Rabble.get(slug)

  # 404 if no rabble was returned.
  raise Sinatra::NotFound unless @rabble

  # Check cookie for first visit user.
  if session['admin'] or true
    # Set the flag for displaying first-visit dialogue.
    @first_visit = true

    # Get url string for welcome message.
    @url = 'http://' + request.host_with_port + '/' + @rabble.slug

    # Clear the cookie flag.
    session['admin'] = nil
  end

  erb :'rabble/main'
end