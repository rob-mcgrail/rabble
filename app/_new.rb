# Homepage route.
get '/?' do
  erb :'home/main'
end


# Create a new Rabble.
post '/p/new' do
  name = params[:name]

  # Check name is valid.
  unless Rabble.invalid_name? name

    rabble = Rabble.create(name)

    # Set cookie flag for user creating the rabble.
    # This is used to show the one time welcome dialogue.
    session['first_visit'] = true

    redirect "/#{rabble.slug}"
  else
    flash[:error] = "There's something wrong with that rabble name."
    redirect '/'
  end
end


# Ajax helper for validation of name from homepage.
post '/a/validate_name' do
  unlock = false

  invalid = Rabble.invalid_name? params[:name]

  if invalid == nil
    message = 'Available :D'
    # Unlock value used to change color and submit button state.
    unlock = true
  elsif invalid == :short
    message = 'Too short'
  elsif invalid == :used
    message = "That's in use"
  else
    message = "Invalid"
  end

  content_type :json
  { :msg => message, :unlock => unlock }.to_json
end