class ElectionsController < ApplicationController

  def index
    route = default_url + "/api/v1/lists"
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

  def show
    route = default_url + "/api/v1/lists/#{ERB::Util.url_encode(params[:name])}"
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
end
