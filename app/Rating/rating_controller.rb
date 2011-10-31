require 'rho/rhocontroller'
require 'helpers/browser_helper'

class RatingController < Rho::RhoController
  include BrowserHelper

  #GET /Rating
  def index
    @ratings = Rating.find(:all)
    render :back => '/app'
  end

  # GET /Rating/{1}
  def show
    @rating = Rating.find(@params['id'])
    if @rating
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Rating/new
  def new
    @rating = Rating.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Rating/{1}/edit
  def edit
    @rating = Rating.find(@params['id'])
    if @rating
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Rating/create
  def create
    @rating = Rating.create(@params['rating'])
    redirect :action => :index
  end

  # POST /Rating/{1}/update
  def update
    @rating = Rating.find(@params['id'])
    @rating.update_attributes(@params['rating']) if @rating
    redirect :action => :index
  end

  # POST /Rating/{1}/delete
  def delete
    @rating = Rating.find(@params['id'])
    @rating.destroy if @rating
    redirect :action => :index  end
end
