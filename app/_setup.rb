# Ajax helper for returning form for setting agenda.
post '/a/get_agenda_form' do
  rabble = Rabble.get(params[:slug])

  return 403 if rabble.agenda

  @agenda_type = params[:type]

  @slug = rabble.slug

  case @agenda_type
  when 'text'
    agenda_form = erb :'setup/agenda_forms/_text', :layout => false
  else
    agenda_form = 'huh?'
  end

  content_type :json
  { :form_html => agenda_form }.to_json
end


# Post route for creating agenda.
post '/p/agenda' do
  rabble = Rabble.get(params[:slug])
  h = {}
  h[:type] = params[:type]
  h[:content] = params[:content]

  rabble.set_agenda(h)

  redirect "/#{rabble.slug}"
end