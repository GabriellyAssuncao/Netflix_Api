require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:valid_attributes) do
    {
      show_id: "s001",
      genre: "TV Show",
      title: "Game of Thrones",
      director: "Alan Taylor",
      cast: "Emilia Clarke, Peter Dinklage, Kit Harington",
      country: "United Kingdom",
      date_added: "Fri, 16 Aug 2024",
      release_year: 2011,
      rating: "TV-MA",
      duration: "8 Seasons",
      listed_in: "Action, Sci-Fi",
      description: "A Song of Ice and Fire. It follows the power struggles among noble families vying for control of the Seven Kingdoms of Westeros."
    }
  end

  let(:invalid_attributes) do
    { show_id: nil }
  end

  let(:movie) { Movie.create!(valid_attributes) }

  describe "GET #index" do
    it "returns a success response" do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:movies)).to eq([movie])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: movie.id }, as: :json
      expect(response).to be_successful
      expect(assigns(:movie)).to eq(movie)
    end

    it "raises error when movie is not found" do
      expect { get :show, params: { id: 'fake_id' } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new Movie' do
        expect do
          post :create, params: { movie: valid_attributes }, as: :json
        end.to change(Movie, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: { movie: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new Movie' do
        expect do
          post :create, params: { movie: invalid_attributes }
        end.not_to change(Movie, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: { movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { show_id: "s002", title: "House of the Dragon" }
      end

      it "updates the requested movie" do
        put :update, params: { id: movie.id, movie: new_attributes }
        movie.reload
        expect(movie.title).to eq("House of the Dragon")
      end

      it "redirects to the movie" do
        put :update, params: { id: movie.id, movie: new_attributes }
        expect(response).to redirect_to(movie)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested movie' do
      movie = Movie.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: movie.id }
      end.to change(Movie, :count).by(-1)
    end

    it 'returns a no content response' do
      movie = Movie.create!(valid_attributes)
      delete :destroy, params: { id: movie.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET #load_movies" do
    let(:file_path) { Rails.root.join("db/netflix_titles.csv") }

    context "when CSV file exists" do
      it "successfully import" do
        allow(File).to receive(:exist?).with(file_path).and_return(true)
        allow_any_instance_of(described_class).to receive(:import_movies_from_csv).and_return(true)

        get :load_movies
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Importação do CSV concluída com sucesso!")
      end
    end

    context "when CSV file does not exist" do
      it "returns error 404" do
        allow(File).to receive(:exist?).with(file_path).and_return(false)

        get :load_movies
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Arquivo CSV não encontrado")
      end
    end
  end
end
