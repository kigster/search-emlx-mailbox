class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.text :header
      t.text :from
      t.text :to
      t.text :cc
      t.text :subject
      t.text :body
      t.text :file_name
      t.datetime :received

      t.timestamp
    end
  end
end
