# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development? or Rails.env.test?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'
end
