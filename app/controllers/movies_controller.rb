require 'csv'

class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.query(params)
    @movies = @movies.distinct
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
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

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def load_movies
    file_path = Rails.root.join("db/netflix_titles.csv")
  
    unless File.exist?(file_path)
      return render json: { error: 'Arquivo CSV não encontrado' }, status: :not_found
    end
  
    file_content = File.read(file_path)
    headers = nil
  
    Movie.transaction do
      CSV.parse(file_content, headers: true) do |row|
        headers ||= row.headers
  
        movie_data = row.to_h.slice(*Movie.attribute_names)
  
        next unless movie_data['show_id'].present?
  
        existing_movie = Movie.find_by(show_id: movie_data['show_id'])
  
        next if existing_movie
  
        movie = Movie.new(movie_data)
        movie.save! if movie.valid?
        
      end
    end
    render json: { message: 'Importação do CSV concluída com sucesso!' }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def movie_params
    params.require(:movie).permit(:type, :title, :director, :cast, :country, :date_added, 
                                  :release_year, :rating, :duration, :listed_in, :description)
  end
end
