require 'rails_helper'

RSpec.describe "Movies routing", type: :routing do
  it "routes to #index" do
    expect(get: "/movies").to route_to("movies#index", format: :json)
  end

  it "routes to #create" do
    expect(post: "/movies").to route_to("movies#create", format: :json)
  end

  it "routes to #load_movies" do
    expect(get: "/load_movies").to route_to("movies#load_movies")
  end
end
