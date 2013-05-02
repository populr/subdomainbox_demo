class Star < ActiveRecord::Base

  belongs_to :user
  belongs_to :doc
  validates_uniqueness_of :doc_id, :scope => :user_id

end
