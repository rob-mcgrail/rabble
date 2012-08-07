# Homepage route.
get '/?' do
  erb :'home/main'
end


# Create a new Rabble.
post '/p/new' do
  name = params[:name]

  # Check name is valid.
  if Rabble.valid_name? name

    rabble = Rabble.create(name)

    # Set cookie flag for user creating the rabble.
    # This is used to show the one time welcome dialogue.
    session['admin'] = true

    redirect "/#{rabble.slug}"
  else
    flash[:error] = 'Sorry, that one already existed.'
    redirect '/'
  end
end


# Ajax helper for validation of name from homepage.
post '/a/validate_name' do
  message = 'That name is in use...'

  if Rabble.valid_name? params[:name]
    message = 'Available :D'
    # Unlock value used to change color and submit button state.
    unlock = true
  end

  content_type :json
  { :msg => message, :unlock => unlock }.to_json
end