class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :doc_privileges
  has_many :docs, :through => :doc_privileges
  has_many :owned_docs,
           :source => :doc,
           :through => :doc_privileges,
           :conditions => ['privilege=?', 'o']

  has_many :editor_docs,
           :source => :doc,
           :through => :doc_privileges,
           :conditions => ['privilege=?', 'w']

end
