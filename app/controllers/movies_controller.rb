require 'csv'

class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.query(params)
    @movies = @movies.distinct
  end

  # GET /movies/1 or /movies/1.json
  def show; end

  # GET /movies/new
  def new; end

  # GET /movies/1/edit
  def edit; end

  # POST /movies or /movies.json

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      render :show, status: :created
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy
  end

  def load_movies
    file_path = Rails.root.join("db/netflix_titles.csv")
    
    return render json: { error: 'Arquivo CSV não encontrado' }, status: :not_found unless File.exist?(file_path)
  
    import_movies_from_csv(file_path)
    render json: { message: 'Importação do CSV concluída com sucesso!' }, status: :ok
  end

  private

  def import_movies_from_csv(file_path)
    file_content = File.read(file_path)
  
    Movie.transaction do
      CSV.parse(file_content, headers: true) do |row|
        movie_data = row.to_h.slice(*Movie.attribute_names)
        next if movie_data['show_id'].blank?
  
        unless Movie.exists?(show_id: movie_data['show_id'])
          movie = Movie.new(movie_data)
          movie.save! if movie.valid?
        end
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def movie_params
    params.require(:movie).permit(:show_id, :genre, :title, :director, :cast, :country, :date_added, 
                                  :release_year, :rating, :duration, :listed_in, :description)
  end
end
