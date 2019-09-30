class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all.includes(:tags)
    if params[:search_term]
      @search_term = params[:search_term].downcase
      @jobs = Job.search_results(@search_term)
    end

    if params[:tag]
      @search_term = params[:tag]
      @jobs = Job.tagged_with(@search_term)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @jobs, :except => :id }
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def email_signup
    email_address = params[:email_address]
    
    response = RestClient.post("https://api:#{ENV['MAILGUN_API_KEY']}" \
                  "@api.mailgun.net/v3/lists/#{ENV['MAILGUN_MAILING_LIST']}/members",
                  :subscribed => true,
                  :address => email_address)
    #send admin@remotegig.io an email when someone signs up
    UserMailer.mail_list_signup_notification(email_address).deliver

    redirect_to jobs_url, success: "Thanks for Signing Up!"

    rescue RestClient::BadRequest => e
      redirect_to jobs_url, error: e
 end

  def vetswhocode_json_feed
    @jobs = Job.where("title ilike ?", "%junior%")
    respond_to do |format|
      format.json { render :json => @jobs, :except => :id }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:url, :title, :company, :description, :tag_list)
    end
end
