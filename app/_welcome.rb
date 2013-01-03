get '/?' do
  erb :'welcome/main'
end


post '/p/go' do
  name = params['name']

  unless Rabble.valid_name?(name)
    redirect '/e'
  end

  @rabble = Rabble.new(name)

  redirect '/' + @rabble.slug
end


post '/a/valid' do
  name = params['name']

  lock = true

  valid_slug = Rabble.valid_name?(name)

  message = 'No dice.'

  if valid_slug
    lock = false
    message = 'Available.'
  end

  content_type :json
  { :msg => message, :unlock => !lock }.to_json
end

