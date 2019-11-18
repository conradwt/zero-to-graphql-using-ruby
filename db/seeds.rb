# frozen_string_literal: true

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

me.friendships.create!(person_id: me.id, friend_id: matz.id)

dhh.friendships.create!(person_id: dhh.id, friend_id: ezra.id)
dhh.friendships.create!(person_id: dhh.id, friend_id: matz.id)

ezra.friendships.create!(person_id: ezra.id, friend_id: dhh.id)
ezra.friendships.create!(person_id: ezra.id, friend_id: matz.id)

matz.friendships.create!(person_id: matz.id, friend_id: me.id)
matz.friendships.create!(person_id: matz.id, friend_id: ezra.id)
matz.friendships.create!(person_id: matz.id, friend_id: dhh.id)
