class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.text :header
      t.string :from
      t.string :to
      t.string :cc
      t.string :subject
      t.text :body
      t.datetime :received
    end
  end
end
