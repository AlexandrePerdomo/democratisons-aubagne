class StructuresController < ApplicationController
  before_action :check_user_signed_in

  def index
    uri = default_url + "/api/v1/structures"
    begin
      response = RestClient.get(uri, headers={})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    if response
      @structures = JSON.parse response
    else 
      @structures = nil
    end
  end

  def show
    uri = default_url + "/api/v1/structures/#{ERB::Util.url_encode(params[:id])}"
    response = requete_api(uri)
    @structure = JSON.parse(response, :symbolize_names => true)
    @user = User.new
  end

  def invitation
    uri = default_url + "/users/invitation"
    datas = {user: {email: params[:user][:email], structure_id: params[:user][:structure_id]}}
    response = requete_api(uri, datas, 'post')
    retour_api = JSON.parse(response, :symbolize_names => true)
    if retour_api[:succes]
      redirect_to "/structures/#{ERB::Util.url_encode(params[:id])}", notice: "Votre invitation à #{params[:user][:email]} a bien été envoyée"
    else
      @user = User.new(params[:email])
      retour_api[:errors].each do |error|
        @user.errors[error.first.to_sym] << error.last[0]
      end
      uri = default_url + "/api/v1/structures/#{ERB::Util.url_encode(params[:id])}"
      response = requete_api(uri)
      @structure = JSON.parse(response, :symbolize_names => true)
      render :show
    end
  end

end
