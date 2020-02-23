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
    route = url + "/lists/#{ERB::Util.url_encode(params[:name])}"
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
    ENV['API_URL'].presence || "localhost:3000/api/v1"
  end
end
