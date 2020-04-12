class RegistrationsController < ApplicationController
  before_action :check_user_signed_in, only: [:show]

  def new
    @user = User.new
    validation_for_human_confirmation
  end

  def create
    datas = user_datas_from(params)
    if verify_human
      retour_api = perform_create_request(params, '', datas)
      @email = params[:user][:email]
      if retour_api[:succes]
        redirect_to root_path, notice: "Votre compte a été crée. Vérifiez votre boite mail pour confirmer celui-ci"
      else
        @user = User.new(datas)
        retour_api[:errors].each do |error|
          @user.errors[error.first.to_sym] << error.last[0]
        end
        validation_for_human_confirmation
        render :new
      end
    else
      @user = User.new(datas)
      validation_for_human_confirmation
      flash.now[:error] = "Merci d'effectuer le calcul pour prouver que vous n'êtes pas un robot."
      render :new
    end
  end

  def show
    uri = "#{default_url}/users/account"
    response = requete_api(uri)
    retour_api = JSON.parse(response, :symbolize_names => true)
    @user = User.new(
      first_name: retour_api[:first_name],
      last_name: retour_api[:last_name],
      email: retour_api[:email],
    )
    @city_id = retour_api[:city_id]
    @invited_user = User.new(email: "")
  end

  # def update
  #   uri = "#{default_url}/users"
  #   datas = user_datas_from(params)
  #   response = requete_api(uri, datas, 'patch')
  #   retour_api = JSON.parse(response, symbolize_names: true)
  #   @user = User.new(datas)
  #   if retour_api[:succes]
  #     redirect_to "/mon-compte", notice: "Votre compte est à jour"
  #   else
  #     retour_api[:errors].each do |error|
  #       @user.errors[:"#{error.first}"] << error.last[0]
  #     end
  #     render :edit
  #   end
  # end

  # def edit
  #   uri = "#{default_url}/users/account"
  #   response = requete_api(uri)
  #   retour_api = JSON.parse(response, :symbolize_names => true)
  #   @user = User.new(
  #     first_name: retour_api[:first_name],
  #     last_name: retour_api[:last_name],
  #     email: retour_api[:email],
  #   )
  # end

  def destroy
    retour_api = perform_create_request(params, 'delete_account', {})
    if retour_api[:error]
      flash[:notice] = "Une erreur est survenue lors de la suppression de votre compte. Merci de contacter un administrateur."
    else
      reset_session
      redirect_to root_path, notice: "Votre compte a bien été supprimé."
    end
  end

  private

  def verify_human
    params[:user][:number1].to_i + params[:user][:number2].to_i == params[:user][:total].to_i
  end

  def user_datas_from(params)
    param_user = params[:user]
    {
      "email": param_user[:email],
      "first_name": param_user[:first_name],
      "last_name": param_user[:last_name],
      "password": param_user[:password],
      "accepted_condition": param_user[:accepted_condition] || false,
    }
  end

  def perform_create_request(params, action, datas)
    uri = "#{default_url}/users/#{action}"
    response = requete_api(uri, datas, 'post')
    JSON.parse(response, symbolize_names: true)
  end

  def validation_for_human_confirmation
    @number1 = rand(10) + 1
    @number2 = rand(10) + 1
    @total = @number1 + @number2
  end
end
