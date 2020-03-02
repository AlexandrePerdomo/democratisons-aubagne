class PasswordsController < ApplicationController
  append_before_action :assert_reset_token_passed, only: :edit

  def new
  end

  def create
    uri = "#{ENV['API_BASE_URL']}/users/password"
    datas = {"user":{"email": params[:user][:email]}}
    response = requete_api(uri, datas, "post")
    retour_api = JSON.parse(response, :symbolize_names => true)
    @email = params[:user][:email]
    if retour_api[:succes]
      flash[:notice] = "Les instructions pour modifier votre mot de passe ont bien été envoyées."
      redirect_to new_session_path
    elsif retour_api[:errors]
      @user = User.new(email: params[:user][:email])
      retour_api[:errors].each do |error|
        @user.errors[:"#{error.first}"] << error.last[0]
      end
      render :new
    end
  end

  def edit
    set_minimum_password_length
    @user = User.new(reset_password_token: params[:reset_password_token])
  end

  def update
    uri = "#{ENV['API_BASE_URL']}/users/password"
    datas = {"user": {
      "reset_password_token": params[:user][:reset_password_token],
      "password": params[:user][:password],
      "password_confirmation": params[:user][:password_confirmation]
      }
    }
    response = requete_api(uri, datas, "patch")
    retour_api = JSON.parse(response, :symbolize_names => true)
    if retour_api[:authentication_token]
      session[:authentication_token] = retour_api[:authentication_token]
      flash[:notice] = "Le mot de passe a été modifié. Connecté(e) avec succès."
      redirect_to root_path
    elsif retour_api[:errors]
      set_minimum_password_length
      @user = User.new(reset_password_token: params[:user][:reset_password_token])
      retour_api[:errors].each do |error|
        @user.errors[:"#{error.first}"] << error.last[0]
      end
      render :edit
    end
  end

  protected

    def assert_reset_token_passed
      redirect_to new_session_path if params[:reset_password_token].blank?
    end

    def set_minimum_password_length
      @minimum_password_length = 6
    end
end
