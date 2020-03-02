class ConsultationsController < ApplicationController
  before_action :check_user_signed_in, only: [:vote]

  def index
    route = default_url + "/consultations"
    begin
      response = RestClient.get(route, headers={})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    if response
      @consultations = JSON.parse response
    else 
      @consultations = nil
    end
  end

  def show
    route = default_url + "/consultations/#{ERB::Util.url_encode(params[:id])}"
    begin
      response = RestClient.get(route, headers={})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    if response
      @consultation = JSON.parse response
    else 
      @consultation = nil
    end
  end

  def vote
  	route = default_url + "/consultations/#{ERB::Util.url_encode(params[:id])}/vote"
  	begin
  	  response = RestClient.get(route, headers={})
  	rescue RestClient::ExceptionWithResponse => e
  	  e.response
  	end
  	if response
  	  @consultation = JSON.parse response
  	else 
  	  @consultation = nil
  	end
  end
end
