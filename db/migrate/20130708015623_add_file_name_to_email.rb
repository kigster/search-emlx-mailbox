class AddFileNameToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :file_name, :string
    add_index :emails, :file_name
  end
end
