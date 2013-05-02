class AddSubdomainToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :subdomain, :string
  end
end
