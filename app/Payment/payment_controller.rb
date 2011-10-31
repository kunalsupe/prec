require 'rho/rhocontroller'
require 'helpers/browser_helper'

class PaymentController < Rho::RhoController
  include BrowserHelper

  #GET /Payment
  def index
    @payments = Payment.find(:all)
    render :back => '/app'
  end

  # GET /Payment/{1}
  def show
    @payment = Payment.find(@params['id'])
    if @payment
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Payment/new
  def new
    @payment = Payment.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Payment/{1}/edit
  def edit
    @payment = Payment.find(@params['id'])
    if @payment
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Payment/create
  def create
    @payment = Payment.create(@params['payment'])
    redirect :action => :index
  end

  # POST /Payment/{1}/update
  def update
    @payment = Payment.find(@params['id'])
    @payment.update_attributes(@params['payment']) if @payment
    redirect :action => :index
  end

  # POST /Payment/{1}/delete
  def delete
    @payment = Payment.find(@params['id'])
    @payment.destroy if @payment
    redirect :action => :index  end
end
