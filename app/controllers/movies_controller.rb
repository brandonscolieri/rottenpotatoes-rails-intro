class MoviesController < ApplicationController

  # @all_ratings = getUniqueRatingCategories()

  def getUniqueRatingCategories() # eg. should return ratings column unique values like so ['PG-13', 'G', 'PG', 'R']
    return Movie.distinct.pluck(:rating)
  end

  def sortColumnAscending?(columnName = params[:sortASC])
    if params[:sortASC]
      @movies = Movie.order(params[:sortASC])
    else
      @movies = filterByRatings() #Movie.all
    end
  end

  # def sortColumnAscending?(columnName = params[:sortASC])
  #   filteredMovies = filterByRatings()
  #   if params[:sortASC]
  #     @movies = filteredMovies.order(params[:sortASC])
  #   end
  # end

  # def sortColumnAscending(columnName = params[:sortASC])
  #   filterByRatings()
    # @movies = @movies.where(rating: @selectedRatings).order("title")
    # @movies = @movies[3]
    # if params[:sortASC]
    #   filterByRatings()
    #   @movies = @movies.order(columnName)
    # end
  # end

  def initializeFilters()
    isSelected = 1
    @all_ratings = getUniqueRatingCategories()
    @selectedRatings = @all_ratings
    if params[:ratings]
      @selectedRatings = params[:ratings].keys
    end
    @selectedRatings.each do |rating|
      params[rating] = isSelected
    end
  end

  def filterByRatings
    initializeFilters()
    @movies = Movie.where(rating: @selectedRatings)
    if params[:sortASC]
      @movies = @movies.order(params[:sortASC])
    end
    return @movies
  end


  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @all_ratings = getUniqueRatingCategories()
    # sortColumnAscending()
    filterByRatings() 
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






end
