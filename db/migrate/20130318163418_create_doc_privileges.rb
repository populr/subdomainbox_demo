class CreateDocPrivileges < ActiveRecord::Migration
  def change
    create_table :doc_privileges do |t|
      t.integer :doc_id
      t.integer :user_id
      t.string :privilege

      t.timestamps
    end
  end
end
