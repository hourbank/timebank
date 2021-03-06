class ServiceRequestsController < ApplicationController
  before_action :logged_in?
  before_action :set_service_request, only: [:show, :edit, :update, :destroy]

  # GET /service_requests
  # GET /service_requests.json
  def index
    @service_requests = ServiceRequest.all.order(created_at: :desc)
    @service_request = ServiceRequest.new
    @current_user = current_user
  end

  # GET /service_requests/1
  # GET /service_requests/1.json
  def show
    @current_user = current_user
  end

  # GET /service_requests/new
  def new
    @service_request = ServiceRequest.new
  end

  # GET /service_requests/1/edit
  def edit
  end

  # POST /service_requests
  # POST /service_requests.json
  def create
    # Insert current user ID into params for new service request
    new_sr = service_request_params
    new_sr[:requested_by_id] = current_user.id
    @service_request = ServiceRequest.new(new_sr)

    respond_to do |format|
      if @service_request.save
        format.html { redirect_to '/service_requests', notice: 'Service request was successfully created.' }
        format.json { render :show, status: :created, location: @service_request }
        # adding this and leaving it blank to render out the template for a new view file:
        format.js
      else
        format.html { render :new }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_requests/1
  # PATCH/PUT /service_requests/1.json
  def update
    respond_to do |format|
      if @service_request.update(service_request_params)
        format.html { redirect_to @service_request, notice: 'Service request was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_request }
      else
        format.html { render :edit }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_requests/1
  # DELETE /service_requests/1.json
  def destroy
    @service_request.destroy
    respond_to do |format|
      format.html { redirect_to service_requests_url, notice: 'Service request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def logged_in?
    if !user_signed_in?
      flash[:error] = "Please sign in first!"
      redirect_to "/users/sign_in"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_request
      @service_request = ServiceRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_request_params
      params.require(:service_request).permit(:title, :description, :estimated_hours, :location, :timing, :requested_by_id)
    end
end
