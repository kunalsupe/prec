require 'rho/rhocontroller'
require 'helpers/browser_helper'

class EnquiryController < Rho::RhoController
  include BrowserHelper

  #GET /Enquiry
  def index
    @enquiries = Enquiry.find(:all)
    render :back => '/app'
  end   
  


  # GET /Enquiry/{1}
  def show
    @enquiry = Enquiry.find(@params['id'])
    if @enquiry
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Enquiry/new
  def new         
    @property = Property.find(@params['id']) 
    @enquiry = Enquiry.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Enquiry/{1}/edit
  def edit
    @enquiry = Enquiry.find(@params['id'])
    if @enquiry
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Enquiry/create
  def create
    @enquiry = Enquiry.create(@params['enquiry'])
    redirect :action => :index
  end

  # POST /Enquiry/{1}/update
  def update
    @enquiry = Enquiry.find(@params['id'])
    @enquiry.update_attributes(@params['enquiry']) if @enquiry
    redirect :action => :index
  end

  # POST /Enquiry/{1}/delete
  def delete
    @enquiry = Enquiry.find(@params['id'])
    @enquiry.destroy if @enquiry
    redirect :action => :index  end
end
