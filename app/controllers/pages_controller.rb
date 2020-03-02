class PagesController < ApplicationController

  def home
    if params[:flash]
      redirect_to root_path, notice: params[:flash]
    end
  end

  def doleances; end

  def cgu; end
end
