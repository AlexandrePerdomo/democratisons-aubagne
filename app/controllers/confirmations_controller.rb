class ConfirmationsController < ApplicationController
  skip_before_action :need_authentication?

  def new
  end

  def create
    uri = "#{ENV['API_BASE_URL']}/users/confirmation"
    datas = {"user":{"email": params[:user][:email]}}
    response = requete_api(uri, datas, "post")
    retour_api = JSON.parse(response, :symbolize_names => true)
    @email = params[:user][:email]
    if retour_api[:succes]
      flash[:notice] = "Les instructions de confirmation ont bien été envoyées."
      redirect_to new_session_path
    elsif retour_api[:errors]
      @user = User.new()
      retour_api[:errors].each do |error|
        @user.errors[:"#{error.first}"] << error.last[0]
      end
      render :new
    end
  end
end
