class CreateUserJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_jobs do |t|
      t.string :title
      t.string :company
      t.string :url
      t.text :description
      t.integer :user_id, null: false, foreign_key: true
      t.text :notes
      t.boolean :applied

      t.timestamps
    end
  end
end
