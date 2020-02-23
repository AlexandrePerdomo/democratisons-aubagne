class PagesController < ApplicationController

  def home; end

  def election;
    url = default_url
    route = url + "/lists"
    begin
      response = RestClient.get(route, headers={})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    if response
      @lists = JSON.parse response
    else 
      @lists = nil
    end
  end

  def list
    url = default_url
    route = url + "/lists/#{params[:name]}"
    begin
      response = RestClient.get(route, headers={})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    if response
      @list = JSON.parse response
    else 
      @list = nil
    end
  end

  def doleances; end

  def cgu; end

  private

  def default_url
  	return "localhost:3000/api/v1" if Rails.env == "development"

  	"https://democracy-api-staging.herokuapp.com/api/v1"
  end
end
