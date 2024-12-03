FactoryBot.define do
  factory :movie do
    sequence(:show_id) { |n| "s#{n}" }
    sequence(:title) { |n| "Movie #{n}" }
    genre { "TV Show" }
    director { "Sample Director" }
    cast { "Actor 1, Actor 2" }
    country { "United Satates" }
    date_added { "2024-08-01" }
    release_year { 2021 }
    rating { "PG-13" }
    duration { "2h" }
    listed_in { "Comedies" }
    description { "Sample description" }
  end
end
