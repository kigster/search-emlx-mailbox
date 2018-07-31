class AddIndexesToEmail < ActiveRecord::Migration[5.2]
  def up
    add_index :emails, [ :received, :from, :to, :subject ], where: '"received" is not null'
    add_index :emails, [ :from, :received ], where: '"from" is not null'
    add_index :emails, [ :to, :received ], where: '"to" is not null'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
