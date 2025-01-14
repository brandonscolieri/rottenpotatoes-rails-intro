class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    initializeState()
    if isStateSynced() == false
      flash.keep
      redirect_to(movies_path(:sortASC => @sortASC, :ratings => @ratings))
    end
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


  def getUniqueRatingCategories() # eg. should return ratings column unique values like so ['PG-13', 'G', 'PG', 'R']
    return Movie.distinct.pluck(:rating)
  end


  def initializeRatingFilters()
    isSelected = 1
    @selectedRatingsHash = {}
    @all_ratings = getUniqueRatingCategories() #Rating Categories

    @all_ratings.each do |rating| 
      @selectedRatingsHash[rating] = isSelected
    end
    return @selectedRatingsHash
  end


  def initializeState()
    initializeRatingFilters()
    @ratings = params[:ratings] || session[:ratings] || @selectedRatingsHash
    @sortASC = params[:sortASC] || session[:sortASC] || nil
    session[:sortASC] = @sortASC
    session[:ratings] = @ratings
    @movies = Movie.where(:rating => @ratings.keys).order(@sortASC)
  end


  def isStateSynced
    if params[:sortASC] == session[:sortASC] and params[:ratings] == session[:ratings]
      return true
    else
      return false
    end
  end

end
