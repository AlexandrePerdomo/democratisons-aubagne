Rails.application.routes.draw do
  root "pages#home"
  get 'election-municipale-2020', to: "pages#election"
  get 'doléances', to: "pages#doleances"
end
