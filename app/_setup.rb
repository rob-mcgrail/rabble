# Ajax helper for returning form for setting agenda.
post '/a/get_agenda_form' do
  agenda_type = params[:type]

  case agenda_type
  when 'text'
    agenda_form = erb :'setup/agenda_forms/_text', :layout => false
  else
    agenda_form = 'huh?'
  end

  content_type :json
  { :form_html => agenda_form }.to_json
end