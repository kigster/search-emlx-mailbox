class AddIndexesToEmail < ActiveRecord::Migration[5.2]
  def up
    add_index :emails, [ :from, :received ]
    add_index :emails, [ :received ]
  end
  def down
    remove_index :emails, [ :from, :received ]
    remove_index :emails, [ :received ]
  end
end
