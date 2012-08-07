# Route for updating clock counters.
post '/a/clock_update' do
  rabble = Rabble.get(params[:slug])

  if rabble
    # Format the two dates.
    death = ChronicDuration.output(rabble.death, :format => :short)
    created = ChronicDuration.output(rabble.created, :format => :short)

    # Return both values as json.
    content_type :json
    { :death => death, :created => created }.to_json
  else
    200
  end
end