# Zero to GraphQL Using Rails

The purpose of this example is to provide details as to how one would go about using GraphQL with the Rails Web Framework. Thus, I have created three major sections which should be self explanatory: Quick Installation, Docker Installation, and Tutorial Installation.

## Getting Started

## Software requirements

- Docker Desktop 3.5.1.7 or newer

- Node 14.17.2 or newer

- PostgreSQL 13.3 or newer

- Rails 6.1.4 or newer

- Ruby 3.0.2 or newer

Note: This tutorial was updated on macOS 11.4. Docker Desktop is ony needed if you're following the `Docker Installation`.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql). (Tag 'graphql')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Quick Installation

1.  clone this repository

    ```bash
    git clone git@github.com:conradwt/zero-to-graphql-using-rails.git
    ```

2.  change directory location

    ```bash
    cd /path/to/zero-to-graphql-using-rails
    ```

3.  install dependencies

    ```bash
    bundle install
    ```

4.  create, migrate, and seed the database

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

5.  start the server

    ```bash
    rails s
    ```

6.  navigate to our application within the browser

    ```bash
    open http://localhost:3000/graphiql
    ```

7.  enter and run GraphQL query

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

    ```bash
    git clone git@github.com:conradwt/zero-to-graphql-using-rails.git
    ```

2.  change directory location

    ```bash
    cd zero-to-graphql-using-rails
    ```

3.  change the host name in `database.yml` on line `23`:

    replace:

    ```text
    host: localhost
    ```

    with:

    ```text
    host: db
    ```

4.  start all services

    ```zsh
    docker-compose up -d
    ```

5.  create, migrate, and seed database

    ```zsh
    docker-compose exec web rails db:setup
    ```

6.  navigate to our application within the browser

    ```bash
    open http://localhost:3000/graphiql
    ```

7.  enter and run GraphQL query

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

9.  cleanup

    ```zsh
    docker-compose down
    docker volume prune
    docker network prune
    ```

## Tutorial Installation

1.  create the project

    ```bash
    rails new zero-rails -d postgresql --skip-active-storage --skip-webpack-install --skip-javascript -T --no-rc
    ```

2.  rename the project directory

    ```bash
    mv zero-rails zero-to-graphql-using-rails
    ```

3.  switch to the project directory

    ```bash
    cd zero-to-graphql-using-rails
    ```

4.  update Ruby gem dependencies

    ```bash
    bundle add rack-cors
    ```

5.  config CORS by adding the following text after `config.generators.system_tests = nil`
    within the `config/application.rb`:

    ```ruby
    # Config CORS.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post delete put patch options head]
      end
    end
    ```

6.  update the `host`, `username`, or `password` settings as necessary which
    appear at the top of the following file(s):

    ```text
    config/database.yaml
    ```

7.  create the database

    ```bash
    rails db:create
    ```

8.  generate `Person` model

    ```bash
    rails g model person first_name last_name username email
    ```

9.  migrate the database

    ```bash
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

    ```bash
    rails g model friendship person:references friend:references
    ```

12. replace `t.references :friend, foreign_key: true`, within migration file,
    `<some-timestamp>_create_friendships.rb` file with the following:

    ```ruby
    t.references :friend, index: true
    ```

13. migrate the database

    ```bash
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
    bundle add graphql
    ```

18. configure the graphql dependencies for our application

    ```zsh
    rails generate graphql:install
    ```

19. add the GraphQL schema which represents our entry point into our GraphQL structure:

    `app/graphql/zero_rails_schema.rb`:

    ```ruby
    # frozen_string_literal: true

    class ZeroRailsSchema < GraphQL::Schema
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

23. start the server

    ```zsh
    rails s
    ```

24. navigate to our application within the browser

    ```bash
    open http://localhost:3000/graphiql
    ```

25. enter and run GraphQL query

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

26. run the GraphQL query

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

## Support

Bug reports and feature requests can be filed with the rest for the Phoenix project here:

- [File Bug Reports and Features](https://github.com/conradwt/zero-to-graphql-using-rails/issues)

## License

Zero to GraphQL Using Rails is released under the [MIT license](./LICENSE.md).

## Copyright

copyright:: (c) Copyright 2019 - 2020 Conrad Taylor. All Rights Reserved.

Notes:

## Docker

1. start all services

   ```zsh
   docker-compose up
   ```

2. create, migrate, and seed database

   ```zsh
   docker exec web rails db:setup
   ```

   Note: The docker-compose `db` service should be used as the host within the `database.yml`.

3. stop all services

   ```zsh
   docker-compose down
   ```

4. remove the volume

   ```zsh
   docker volume rm zero-to-graphql-using-rails_db-data
   ```
