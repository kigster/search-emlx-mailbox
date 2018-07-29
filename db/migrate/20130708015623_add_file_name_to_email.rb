class AddFileNameToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :file_name, :string
    add_index :emails, :file_name
  end
end
