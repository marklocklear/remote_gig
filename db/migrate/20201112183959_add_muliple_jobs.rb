class AddMulipleJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :multiple_jobs, :boolean, default: false
  end
end
