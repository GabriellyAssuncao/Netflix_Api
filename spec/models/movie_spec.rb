require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      movie = described_class.new(
        show_id: "s001",
        genre: "TV Show",
        title: "House of the Dragon",
        director: "Miguel Sapochnik",
        cast: "Emma D'Arcy, Olivia Cooke, Matt Smith",
        country: "United Kingdom",
        date_added: "Fri, 16 Aug 2024",
        release_year: 2021,
        rating: "TV-MA",
        duration: "2 Seasons",
        listed_in: "Action, Sci-Fi",
        description: "Set 200 years before the events of Game of Thrones, this epic series tells the story of House Targaryen."
      )
      expect(movie).to be_valid
    end

    it "is not valid without a show_id" do
      movie = described_class.new(show_id: nil)
      expect(movie).not_to be_valid
      expect(movie.errors[:show_id]).to include("can't be blank")
    end

    it "is not valid with a duplicate show_id" do
      described_class.create!(show_id: "s002", title: "House of the Dragon")
      duplicate_movie = described_class.create(show_id: "s002", title: "How I Met Your Mother")

      expect(duplicate_movie).not_to be_valid
      expect(duplicate_movie.errors[:show_id]).to include("has already been taken")
    end
  end

  describe 'filterable_params' do
    it 'returns the expected filterable parameters' do
      expect(described_class.filterable_params).to match_array(%w[title country genre year published_at description])
    end
  end

  describe 'field_mapping' do
    it 'returns the correct field mapping' do
      expect(described_class.field_mapping).to include(
        "title" => "title",
        "country" => "country",
        "genre" => "genre",
        "year" => "release_year",
        "published_at" => "date_added",
        "description" => "description"
      )
    end
  end

  describe 'queries' do
    let!(:movie1) { create(:movie, title: 'House of the Dragon', country: 'United Kingdom', release_year: 2021, description: 'westeros') }
    let!(:movie2) { create(:movie, title: 'How I Met Your Mother', country: 'United States', release_year: 2005, description: 'yellow umbrella') }
    let!(:movie3) { create(:movie, title: 'Stranger Things', country: 'United Kingdom', release_year: 2016, description: 'dungeons and dragons') }

    context 'when no filters are applied' do
      it 'returns all movies sorted by release year' do
        expect(described_class.query).to eq([movie2, movie3, movie1])
      end
    end

    context 'when filtering by title' do
      it 'returns movies that match the title' do
        result = described_class.query({ 'title' => 'How I Met Your Mother' })
        expect(result).to contain_exactly(movie2)
      end
    end

    context 'when filtering by description' do
      it 'returns movies with descriptions matching the query' do
        result = described_class.query({ 'description' => 'dragons' })
        expect(result).to contain_exactly(movie3)
      end
    end

    context 'when filtering by release year' do
      it 'returns movies from the specified year' do
        result = described_class.query({ 'year' => 2005 })
        expect(result).to contain_exactly(movie2)
      end
    end

    context 'when filtering by multiple params' do
      it 'returns movies that match all params' do
        result = described_class.query({ 'title' => 'House of the Dragon', 'country' => 'United Kingdom' })
        expect(result).to contain_exactly(movie1)
      end
    end
  end
end
