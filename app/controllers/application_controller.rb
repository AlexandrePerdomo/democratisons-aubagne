class ApplicationController < ActionController::Base
  prepend_view_path Rails.root.join("frontend")

  def check_user_signed_in
    if session[:token].nil?
      session[:previous_path] = request.fullpath
      redirect_to "/connexion", notice: "Vous devez vous connecter pour effectuer cette action."
    end
  end

  def requete_api(url, datas = {}, methode = "get")
    rest_resource = RestClient::Resource.new(url)
    token = "Authorization: #{session[:token]}"
    website_origin = ENV['WEBSITE_AUTHENTICATION_TOKEN']
    if methode == "get"
      rest_resource.get(
        authorization: token,
        website_origin: website_origin
      )
    elsif methode == "post"
      rest_resource.post datas, authorization: token, website_origin: website_origin
    elsif methode == "patch"
      rest_resource.patch datas, authorization: token, website_origin: website_origin
    end
  end

  def default_url
    ENV['API_URL'].presence || "localhost:3000"
  end
end
