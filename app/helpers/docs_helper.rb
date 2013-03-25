module DocsHelper

  def collaborator_emails(user, doc)
    collaborators = doc.other_collaborators(user)
    if collaborators.empty?
      ''
    else
      collaborators.collect { |user| user.email }.join(', ')
    end
  end

end
