# Zero to GraphQL Using Ruby

The purpose of this example is to provide details as to how one would go about using GraphQL with the Ruby Language. Thus, I have created three major sections which should be self explanatory: Quick Installation, Docker Installation, and Tutorial Installation.

## Getting Started

## Software requirements

- Docker Desktop 4.30.0 or newer

- PostgreSQL 16.4 or newer

- Rails 7.1.3.4 or newer

- Ruby 3.4.3 or newer

Note: This tutorial was updated on macOS 15.4. Docker Desktop is ony needed if you're following the `Docker Installation`.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql). (Tag 'graphql')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Quick Installation

1.  clone this repository

    ```zsh
    git clone git@github.com:conradwt/zero-to-graphql-using-ruby.git
    ```

2.  change directory location

    ```zsh
    cd zero-to-graphql-using-ruby
    ```

3.  install dependencies

    ```zsh
    bundle install
    ```

4.  create, migrate, and seed the database

    ```zsh
    rails db:setup
    ```

5.  start the server

    ```zsh
    rails s
    ```

6.  navigate to our application within the browser

    ```zsh
    open http://localhost:3000/graphiql
    ```

7.  enter the below GraphQL query on the left side of the browser window

    ```graphql
    {
      person(id: "1") {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
    ```

8.  run the GraphQL query

    ```text
    Control + Enter
    ```

    Note: The GraphQL query is responding with same shape as our GraphQL document.

## Docker Installation

1.  clone this repository

    ```zsh
    git clone git@github.com:conradwt/zero-to-graphql-using-ruby.git
    ```

2.  change directory location

    ```zsh
    cd zero-to-graphql-using-ruby
    ```

3.  start all services

    ```zsh
    docker compose up -d
    ```

4.  create, migrate, and seed database

    ```zsh
    docker compose exec app bin/rails db:setup
    ```

5.  navigate to our application within the browser

    ```zsh
    open http://localhost:3000/graphiql
    ```

6.  enter the below GraphQL query on the left side of the browser window

    ```graphql
    {
      person(id: "1") {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
    ```

7.  run the GraphQL query

    ```text
    Control + Enter
    ```

    Note: The GraphQL query is responding with same shape as our GraphQL document.

8.  cleanup

    ```zsh
    docker compose down
    docker system prune -a --volumes
    ```

## Tutorial Installation

1.  create the project

    ```zsh
    rails new zero-ruby -d postgresql --skip-active-storage --skip-javascript -T --no-rc
    ```

2.  rename the project directory

    ```zsh
    mv zero-ruby zero-to-graphql-using-ruby
    ```

3.  switch to the project directory

    ```zsh
    cd zero-to-graphql-using-ruby
    ```

4.  update Ruby gem dependencies

    ```zsh
    bundle add rack-cors
    ```

5.  add CORS initializer by adding the following text within the `config/initializers/cors.rb` file:

    ```ruby
    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*',
                headers: :any,
                methods: %i[get post put patch delete options head]
      end
    end
    ```

6.  Add the following after the `pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>` setting within `database.yml`:

    ```text
    host: <%= ENV.fetch("POSTGRES_HOST") { 'localhost' } %>
    username: <%= ENV.fetch("POSTGRES_USER") { 'postgres' } %>
    password: <%= ENV.fetch("POSTGRES_PASSWORD") { 'password' } %>
    ```

7.  create the database

    ```zsh
    rails db:create
    ```

8.  generate `Person` model

    ```zsh
    rails g model person first_name last_name username email
    ```

9.  migrate the database

    ```zsh
    rails db:migrate
    ```

10. replace the generated `Person` model with the following:

    ```ruby
    class Person < ApplicationRecord
      has_many :friendships, dependent: :destroy
      has_many :friends, through: :friendships
    end
    ```

11. generate a `Friendship` model which representing our join model:

    ```zsh
    rails g model friendship person:references friend:references
    ```

12. replace `t.references :friend, foreign_key: true`, within migration file,
    `<some-timestamp>_create_friendships.rb` file with the following:

    ```ruby
    t.references :friend, index: true
    ```

13. migrate the database

    ```zsh
    rails db:migrate
    ```

14. replace the generated `Friendship` model with the following:

    `app/models/friendship.rb`:

    ```ruby
    class Friendship < ApplicationRecord
      belongs_to :person
      belongs_to :friend, class_name: 'Person'
    end
    ```

    Note: We want `friend_id` to reference the `people` table because our `friend_id` really represents a `Person` model.

15. update the contents of the seeds file to the following:

    `db/seeds.rb`:

    ```ruby
    # reset the datastore
    Person.destroy_all

    # insert people
    me = Person.create!(first_name: 'Conrad',
                        last_name: 'Taylor',
                        email: 'conradwt@gmail.com',
                        username: 'conradwt')
    dhh = Person.create!(first_name: 'David',
                         last_name: 'Heinemeier Hansson',
                         email: 'dhh@37signals.com',
                         username: 'dhh')
    ezra = Person.create!(first_name: 'Ezra',
                          last_name: 'Zygmuntowicz',
                          email: 'ezra@merbivore.com',
                          username: 'ezra')
    matz = Person.create!(first_name: 'Yukihiro',
                          last_name: 'Matsumoto',
                          email: 'matz@heroku.com',
                          username: 'matz')

    me.friendships.create!(friend_id: matz.id)

    dhh.friendships.create!(friend_id: ezra.id)
    dhh.friendships.create!(friend_id: matz.id)

    ezra.friendships.create!(friend_id: dhh.id)
    ezra.friendships.create!(friend_id: matz.id)

    matz.friendships.create!(friend_id: me.id)
    matz.friendships.create!(friend_id: ezra.id)
    matz.friendships.create!(friend_id: dhh.id)
    ```

16. seed the database

    ```zsh
    rails db:seed
    ```

17. add `graphql` Ruby gem to your `Gemfile` dependencies as follows:

    ```zsh
    bundle add graphql --version '~> 2.3'
    ```

18. configure the graphql dependencies for our application

    ```zsh
    rails generate graphql:install
    ```

19. add the GraphQL schema which represents our entry point into our GraphQL structure:

    `app/graphql/zero_ruby_schema.rb`:

    ```ruby
    # frozen_string_literal: true

    class ZeroRubySchema < GraphQL::Schema
      mutation(Types::MutationType)
      query(Types::QueryType)
    end
    ```

20. add our PersonType:

    `app/graphql/types/person_type.rb`:

    ```ruby
    # frozen_string_literal: true

    module Types
      class PersonType < Types::BaseObject
        field :id, ID,
              null: false,
              description: 'unique identifier for the person'

        field :first_name, String,
              null: false,
              description: 'first name of a person'

        field :last_name, String,
              null: false,
              description: 'last name of a person'

        field :username, String,
              null: false,
              description: 'username of a person'

        field :email, String,
              null: false,
              description: 'email of a person'

        field :friends, [PersonType],
              null: false,
              description: 'a list of friends for our person'

        def friends
          object.friends
        end
      end
    end
    ```

21. update our QueryType to look like the following:

    `app/graphql/types/person_type.rb`:

    ```ruby
    # frozen_string_literal: true

    module Types
      class QueryType < Types::BaseObject
        field :person, PersonType, null: true do
          description 'Find a person by ID'
          argument :id, ID, required: true
        end

        def person(id:)
          Person.find(id)
        end
      end
    end
    ```

22. add the following two lines to the bottom of our manifest file:

    `app/assets/config/manifest.js`:

    ```javascript
    //= link graphiql/rails/application.css
    //= link graphiql/rails/application.js
    ```

23. add routes for our GraphQL API and GraphiQL browser endpoints:

    `./config/routes.rb`:

    replace the contents with the following:

    ```ruby
    # frozen_string_literal: true

    Rails.application.routes.draw do
      if Rails.env.development? or Rails.env.test?
        mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
      end

      post '/graphql', to: 'graphql#execute'
    end
    ```

24. start the server

    ```zsh
    rails s
    ```

25. navigate to our application within the browser

    ```zsh
    open http://localhost:3000/graphiql
    ```

26. enter the below GraphQL query on the left side of the browser window

    ```graphql
    {
      person(id: "1") {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
    ```

27. run the GraphQL query

    ```text
    Control + Enter
    ```

    Note: The GraphQL query is responding with same shape as our GraphQL document.

## Production Setup

Ready to run in production? Please [check our deployment guides](https://guides.rubyonrails.org/configuring.html).

## Rails References

- Official website: https://rubyonrails.org
- Guides: https://guides.rubyonrails.org
- Docs: https://api.rubyonrails.org
- Mailing list: https://groups.google.com/forum/#!forum/rubyonrails-talk
- Source: https://github.com/rails/rails

## GraphQL References

- Official Website: http://graphql.org
- GraphQL Ruby: https://graphql-ruby.org

## Docker and Docker Compose References

- Docker Docs - https://docs.docker.com/reference
- Docker Compose - https://docs.docker.com/samples/rails
- How to setup Rails 6 on Docker - https://www.youtube.com/watch?app=desktop&v=XIjGbfcMAYM

## Support

Bug reports and feature requests can be filed with the rest for the Phoenix project here:

- [File Bug Reports and Features](https://github.com/conradwt/zero-to-graphql-using-ruby/issues)

## License

Zero to GraphQL Using Ruby is released under the [MIT license](./LICENSE.md).

## Copyright

copyright:: (c) Copyright 2019 - 2024 Conrad Taylor. All Rights Reserved.
