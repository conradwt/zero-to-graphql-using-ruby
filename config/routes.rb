# frozen_string_literal: true

Rails.application.routes.draw do
  get "/healthz" => "rails/health#show", as: :rails_health_check

  if Rails.env.development? or Rails.env.test?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'
end
