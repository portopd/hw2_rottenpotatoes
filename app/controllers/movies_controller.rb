class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # order checking
    default_flag = false
    restful = true
    if session[:sort].nil?
      if !params.include?(:sort) 
        @sort_col = "id"
        default_flag = true
      else
        @sort_col = params[:sort]
      end
    else
      if !params.include?(:sort)
        @sort_col = session[:sort]
        restful = false
      else
        @sort_col = params[:sort]
      end
    end
    if !default_flag
      session[:sort] = @sort_col 
    end
    
    # filter checking
    get_ratings
    default_flag = false
    if session[:ratings].nil?
      if !params.include?(:ratings)
        @filter_ratings = @all_ratings
        default_flag = true
      else
        @form_ratings = params[:ratings]
      end
    else
      if !params.include?(:ratings)
        @form_ratings = session[:ratings]
        restful = false
      else
        @form_ratings = params[:ratings]
      end
    end
    if !default_flag
      @filter_ratings = @form_ratings.keys
      session[:ratings] = @form_ratings
    end

    if !restful
      flash.keep
      redirect_to movies_path(:sort => @sort_col, :ratings => @form_ratings)
    end
    p session
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
    movies_diff_ratings = Movie.find(:all, :select => "rating", :group => "rating")
    movies_diff_ratings.each do |movie|
      @all_ratings << movie.rating
    end
  end
end
