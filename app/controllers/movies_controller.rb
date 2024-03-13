class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    # Convert to array if it's nil or just use the keys if it's present
    @ratings_to_show = params[:ratings] &.keys || @all_ratings
   

    # Persist the ratings to the sesion to remember the user's choices
    session[:ratings] = params[:ratings] if params[:ratings].present?

    # Sorting
    @sort_column = params[:sort] || session[:sort]
    session[:sort] = @sort_column
    @movies = Movie.with_ratings(@ratings_to_show).order(@sort_column)

    # Set the CSS class for the header
    @title_header_class = 'hilite bg warning' if @sort_column == 'title'
    @release_date_class = 'hilite bg warning' if @sort_column == 'release_date'
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
