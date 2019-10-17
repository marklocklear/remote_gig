class UserJobsController < ApplicationController
  before_action :set_user_job, only: [:show, :edit, :update, :destroy, :archive_job, :un_archive_job]
  before_action :authenticate_user!

  # GET /user_jobs
  # GET /user_jobs.json
  def index
    @user_jobs = current_user.user_jobs.where(archived: false)
  end

  # GET /user_jobs/1
  # GET /user_jobs/1.json
  def show
  end

  # GET /user_jobs/new
  def new
    @user_job = UserJob.new
  end

  # GET /user_jobs/1/edit
  def edit
  end

  # POST /user_jobs
  # POST /user_jobs.json
  def create
    if params[:job_id] && params[:user_id] #if user "favorites a job from the index page"
      job = Job.find(params[:job_id])
      user = User.find(params[:user_id])
      @user_job = UserJob.new(title: job.title, company: job.company, url: job.url,
                            description: job.description , user_id: user.id)
    else #if user manually creates a jobs from /user_jobs/new
      @user_job = UserJob.new(user_job_params)
    end
    

    respond_to do |format|
      if @user_job.save
        format.html { redirect_to @user_job, notice: 'Job Successfully Saved' }
        format.json { render :show, status: :created, location: @user_job }
      else
        format.html { render :new }
        format.json { render json: @user_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_jobs/1
  # PATCH/PUT /user_jobs/1.json
  def update
    respond_to do |format|
      if @user_job.update(user_job_params)
        format.html { redirect_to @user_job, notice: 'User job was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_job }
      else
        format.html { render :edit }
        format.json { render json: @user_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_jobs/1
  # DELETE /user_jobs/1.json
  def destroy
    @user_job.destroy
    respond_to do |format|
      format.html { redirect_to user_jobs_url, notice: 'The job ' + @user_job.title + ' was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def archive_job
    @user_job.update_attribute(:archived, true)
    redirect_to user_jobs_url, notice: 'Job was successfully archived.'
  end

  def un_archive_job
    @user_job.update_attribute(:archived, false)
    redirect_to user_jobs_url, notice: 'Job was successfully un-archived.'
  end

  def get_archived_jobs
    @user_jobs = current_user.user_jobs.where(archived: true)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_job
      @user_job = UserJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_job_params
      params.require(:user_job).permit(:title, :company, :url, :description, :user_id, :notes, :applied, :applied_on, :archived)
    end
end
