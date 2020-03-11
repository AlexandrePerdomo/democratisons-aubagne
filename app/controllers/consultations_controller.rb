class ConsultationsController < ApplicationController
  before_action :check_user_signed_in, only: [:vote]

  def index
    uri = default_url + "/api/v1/consultations"
    begin
      response = RestClient.get(uri, headers={})
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
    uri = default_url + "/api/v1/consultations/#{ERB::Util.url_encode(params[:id])}"
    response = requete_api(uri)
    @consultation = JSON.parse(response, :symbolize_names => true)
    @votes = []
    @consultation[:propositions].each do |proposition|
      @votes << Vote.new(proposition_id: proposition[:id])
    end
  end

  def submit_vote
    if errors_in_params_vote?
      uri = default_url + "/api/v1/consultations/#{ERB::Util.url_encode(params[:id])}/vote"
      response = requete_api(uri)
      @consultation = JSON.parse(response, :symbolize_names => true)
      @votes = []
      params[:vote][:votes].each do |k,v|
        @votes << Vote.new(v.to_unsafe_h)
      end
      flash.now[:notice] = "Merci de sélectionner une mention pour chaque proposition."
      render :vote
    else
      uri = default_url + "/api/v1/consultations/#{ERB::Util.url_encode(params[:id])}/vote"
      datas = {votes: sanitize_params_vote}
      response = requete_api(uri, datas, 'post')
      retour_api = JSON.parse(response, :symbolize_names => true)
      if retour_api[:success]
        redirect_to "/consultations/#{ERB::Util.url_encode(params[:id])}", notice: "Votre vote a bien été pris en compte"
      else 
        response = requete_api(uri)
        @consultation = JSON.parse(response, :symbolize_names => true)
        @votes = []
        params[:vote][:votes].each do |k,v|
          @votes << Vote.new(v.to_unsafe_h)
        end
        render :vote, notice: "Une erreur est survenue lors de votre vote"
      end
    end
  end

  def errors_in_params_vote?
    errors = false
    params[:vote][:votes].each do |k,v|
      next if Vote::CHOICES.include? v[:choice]
      errors = true
    end
    errors
  end

  def sanitize_params_vote
    sanitized_params = []
    params[:vote][:votes].each do |k,v|
      sanitized_params << v.to_unsafe_h
    end
    sanitized_params
  end
end
