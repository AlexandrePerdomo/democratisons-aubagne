class InvitationsController < ApplicationController
  append_before_action :assert_invitation_token_passed, only: :edit

  def new
  	@user = User.new
    @invitation_token = params[:invitation_token]
  end

  def create
    uri = "#{default_url}/users/invitation"
    datas = { user: user_datas_from(params) }
    response = requete_api(uri, datas, "patch")
    retour_api = JSON.parse(response, :symbolize_names => true)
    if retour_api[:succes]
      flash[:notice] = "Votre compte a bien été crée. Vous pouvez désormais vous connecter"
      redirect_to root_path
    elsif retour_api[:errors]
      @user = User.new(
        first_name: params[:user][:first_name],
        last_name: params[:user][:last_name]
      )
      @invitation_token = retour_api[:invitation_token]
      retour_api[:errors].each do |error|
        @user.errors[:"#{error.first}"] << error.last[0]
      end
      render :new
    end
  end

  protected

    def assert_invitation_token_passed
      redirect_to "/connexion" if params[:invitation_token].blank?
    end

    def set_minimum_password_length
      @minimum_password_length = 6
    end

    def user_datas_from(params)
      param_user = params[:user]
      {
        "first_name": param_user[:first_name],
        "last_name": param_user[:last_name],
        "password": param_user[:password],
        "accepted_condition": param_user[:accepted_condition] || false,
        "invitation_token": param_user[:invitation_token],
      }
    end

end
