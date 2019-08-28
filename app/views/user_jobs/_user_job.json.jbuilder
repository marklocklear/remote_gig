json.extract! user_job, :id, :tite, :company, :url, :description, :user_id, :notes, :applied, :applied_on, :created_at, :updated_at
json.url user_job_url(user_job, format: :json)
