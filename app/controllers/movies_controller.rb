class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    get_ratings
    if !params.include?(:sort) && !params.include?(:ratings)
      @sort_col = "id"
      @filter_ratings = @all_ratings
    else
      @sort_col = params[:sort] unless params[:sort].nil? # retrieve sort column from additional params hash
      @form_ratings = params[:ratings] unless params[:ratings].nil?
      @filter_ratings = @form_ratings.keys unless @form_ratings.nil?
    end
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
