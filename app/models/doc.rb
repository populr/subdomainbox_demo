class Doc < ActiveRecord::Base
  attr_accessible :body, :title
  attr_accessor :privilege

  has_many :doc_privileges
  has_many :users, :through => :doc_privileges
  has_many :owners,
           :source => :user,
           :through => :doc_privileges,
           :conditions => ['privilege=?', 'o']

  has_many :editors,
           :source => :user,
           :through => :doc_privileges,
           :conditions => ['privilege=? OR privilege=?', 'o', 'w']

  before_create :assign_default_title

  def as_json(options={})
    hash = super(options)
    hash['privilege'] = privilege unless privilege.nil?
    hash
  end

  def add_owner!(user)
    privilege = doc_privileges.new
    privilege.user = user
    privilege.privilege = 'o'
    privilege.save!
  end

  def add_editor!(user)
    privilege = doc_privileges.new
    privilege.user = user
    privilege.privilege = 'w'
    privilege.save!
  end


  def owner?(user)
    owners.find(user.id)
  rescue ActiveRecord::RecordNotFound
  end

  def editor?(user)
    editors.find(user.id)
  rescue ActiveRecord::RecordNotFound
  end

  def other_collaborators(user)
    users.where('user_id != ?', user.id)
  end

  private

  def assign_default_title
    self.title = 'Untitled' if title.blank?
  end

end
