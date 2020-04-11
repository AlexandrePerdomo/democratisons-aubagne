class ConsultationsController < ApplicationController
  before_action :check_user_signed_in, only: [:vote]

  def index
    uri = default_url + "/api/v1/consultations"
    begin
      response = requete_api(uri)
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
    generate_data_results
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

  def generate_data_results
    @data_group = [
      {
        name: "Très bien", 
        data: @consultation[:results].map { |result| [result[:title], (result[:very_good].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Bien", 
        data: @consultation[:results].map { |result| [result[:title], (result[:good].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Assez bien", 
        data: @consultation[:results].map { |result| [result[:title], (result[:pretty_good].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Passable", 
        data: @consultation[:results].map { |result| [result[:title], (result[:passable].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Insuffisant", 
        data: @consultation[:results].map { |result| [result[:title], (result[:insufficient].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "A rejeter", 
        data: @consultation[:results].map { |result| [result[:title], (result[:reject].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
    ]
    @data_first = [
      {
        name: "Très bien", 
        data: @consultation[:results][0,1].map { |result| [result[:title], (result[:very_good].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Bien", 
        data: @consultation[:results][0,1].map { |result| [result[:title], (result[:good].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Assez bien", 
        data: @consultation[:results][0,1].map { |result| [result[:title], (result[:pretty_good].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Passable", 
        data: @consultation[:results][0,1].map { |result| [result[:title], (result[:passable].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "Insuffisant", 
        data: @consultation[:results][0,1].map { |result| [result[:title], (result[:insufficient].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
      {
        name: "A rejeter", 
        data: @consultation[:results][0,1].map { |result| [result[:title], (result[:reject].to_f / result[:vote_count].to_f * 100).round(2)]}
      },
    ]
  end

end
