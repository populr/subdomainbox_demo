ActionView::Base.field_error_proc = proc do |html, instance|
  errors = instance.object.errors[instance.method_name.to_sym]
  ptag = '<span class="help-inline">'
  if html =~ /^<label/
    html
  elsif html =~ /class=("|')/
    output = html.sub('class="', 'class="field_with_errors ').sub('class=\'', 'class=\'field_with_errors')
    (output + ptag + errors.join('</span>' + ptag) + '</span>').html_safe
  else
    output = html.sub(' />', ' class="field_with_errors" />')
    (output + ptag + errors.join('</span>' + ptag) + '</span>').html_safe
  end
end
