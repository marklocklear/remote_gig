class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :url
      t.string :title
      t.string :description
      t.string :company
      t.timestamps
    end
  end
end
