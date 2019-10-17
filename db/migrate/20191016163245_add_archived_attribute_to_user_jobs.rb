class AddArchivedAttributeToUserJobs < ActiveRecord::Migration[6.0]
  def change
  	add_column :user_jobs, :archived, :boolean, default: false
  end
end
