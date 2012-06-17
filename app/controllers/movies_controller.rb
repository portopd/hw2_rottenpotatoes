class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_col = "id"
    get_ratings
    @filter_ratings = @all_ratings

    @sort_col = params[:sort] unless params[:sort].nil? # retrieve sort column from additional params hash
    @filter_ratings = params[:ratings].keys unless params[:ratings].nil?
    @movies = Movie.all(:order => @sort_col, :conditions => {:rating => @filter_ratings})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def get_ratings
    @all_ratings = []
    movies_diff_ratings = Movie.all(:group => "rating")
    movies_diff_ratings.each do |movie|
      @all_ratings << movie.rating
    end
  end
end
