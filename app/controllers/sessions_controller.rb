class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    uri = "#{default_url}/users/sign_in"
    datas = {
      "email": params[:user][:email],
      "password": params[:user][:password]
    }
    response = requete_api(uri, datas, "post")
    retour_api = JSON.parse(response, :symbolize_names => true)
    if retour_api[:token]
      session[:token] = retour_api[:token]
      flash[:notice] = "Connecté(e) avec succès."
      redirect_to root_path
    else
      @user = User.new({ "email": params[:user][:email] })
      flash[:alert] = retour_api[:error]
      render :new
    end
  end

  def destroy
    uri = "#{default_url}/users/sign_out"
    datas = {token: session[:token]}
    response = requete_api(uri, datas, "post")
    retour_api = JSON.parse(response, :symbolize_names => true)
    if retour_api[:succes]
      reset_session
      flash[:notice] = "Déconnecté(e) avec succès."
      redirect_to root_path
    else
      flash[:notice] = "Erreur lors de la déconnexion"
      redirect_to root_path
    end
  end

  private

  def verify_signed_out_user; end

  def default_url
    ENV['API_URL'].presence || "localhost:3000"
  end

end
