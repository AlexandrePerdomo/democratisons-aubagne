Rails.application.routes.draw do
  root "pages#home"
  get '/election-municipale-2020', to: "pages#election"
  get '/election-municipale-2020/:name', to: "pages#list"
  get '/doléances', to: "pages#doleances"
  get '/mentions-légales', to: "pages#cgu"
end
