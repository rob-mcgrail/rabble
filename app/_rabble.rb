
get %r(^\/([^epac]{1}$|[^\/\s]{2,}$)) do |slug|

  @rabble = Rabble.get(slug)

  @session = Time.now.to_i
  @rabble.register_session @session

  unless @rabble
    redirect '/e'
  end

  if @rabble.ttl < 1
    redirect '/e'
  end

  erb :'rabble/main'
end


post '/a/kill' do
  session = params['session']
  slug = params['rabble']

  penalty = 10

  rabble = Rabble.get(slug)

  if rabble.valid_session?(session)
    rabble.decrease(penalty)
    response = { 'failed' => false, 'penalty' => penalty }
  else
    response = {'failed' => true}
  end

  content_type :json
  response.to_json
end


post '/a/ttl' do
  slug = params['rabble']

  rabble = Rabble.get(slug)

  if rabble
    ttl = ChronicDuration.output(rabble.ttl, :format => :short)

    content_type :json
    { :ttl => ttl }.to_json
  else
    400
  end
end