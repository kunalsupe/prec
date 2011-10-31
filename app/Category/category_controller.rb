require 'rho/rhocontroller'
require 'helpers/browser_helper'

class CategoryController < Rho::RhoController
  include BrowserHelper

  #GET /Category
  def index
    @categories = Category.find(:all)
    render :back => '/app'
  end

  # GET /Category/{1}
  def show
    @category = Category.find(@params['id'])
    if @category
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Category/new
  def new
    @category = Category.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Category/{1}/edit
  def edit
    @category = Category.find(@params['id'])
    if @category
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Category/create
  def create
    @category = Category.create(@params['category'])
    redirect :action => :index
  end

  # POST /Category/{1}/update
  def update
    @category = Category.find(@params['id'])
    @category.update_attributes(@params['category']) if @category
    redirect :action => :index
  end

  # POST /Category/{1}/delete
  def delete
    @category = Category.find(@params['id'])
    @category.destroy if @category
    redirect :action => :index  end
end
