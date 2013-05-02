module ApplicationHelper

  def published_doc_url(doc)
    port = Rails.env.development? ? ':3000' : ''
    request.protocol + doc.subdomain + '.' + request.domain + port
  end

end
