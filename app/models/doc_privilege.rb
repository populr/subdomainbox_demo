class DocPrivilege < ActiveRecord::Base
  attr_accessible :privilege, :collaborator_email
  attr_accessor :collaborator_email

  belongs_to :doc
  belongs_to :user

  validate :validate_collaborator_email, :on => :create

  private

  def validate_collaborator_email
    if collaborator_email
      self.user = User.where(:email => collaborator_email).first
      errors.add(:collaborator_email, 'No such user') unless user
    end
  end

end
