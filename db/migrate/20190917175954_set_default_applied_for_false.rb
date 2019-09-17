class SetDefaultAppliedForFalse < ActiveRecord::Migration[5.1]
  def change
  	change_column :user_jobs, :applied, :boolean, default: false
  end
end
