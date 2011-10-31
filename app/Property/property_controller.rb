require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/application_helper'  


class PropertyController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper
def map_it
 @property = Property.find(@params['id']) 
 
 map_params = {
                :settings => {:map_type => "ROADMAP",:region => [@property.latitude, @property.longitude, 0.2, 0.2],
                              :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => false,
                              :api_key => 'Google Maps API Key'},
                              
                 :annotations => [{
                                      :latitude => @property.latitude ,
                                      :longitude => @property.longitude,
                                      :title => "Current Location",
                                      :subtitle => "",
                                      :url => "/app/Property/{#{@property.object}}"
                 }]
                 
                  }
   MapView.create map_params
   
   redirect :action => :index

end

def map_all
  if !GeoLocation.known_position?
    GeoLocation.set_notification( url_for(:action => :geo_callback), "", 2)
    redirect :action => :wait
  else
  @properties = Property.find(:all)  
  annotations = []
  @properties.each do |property| 
    orglat = property.latitude
            100.times do 
              property.latitude = property.latitude.to_f + 0.01
              property.latitude = property.latitude.to_s
    annotations << {
      :latitude => property.latitude,
      :longitude => property.longitude,
      :title => "#{property.title}", 
      :subtitle => "",
      :url => "/app/Property/{#{@property.object}}"  
    }
 end 
  property.latitude = orglat  
 100.times do 
   property.longitude = property.longitude.to_f + 0.05
   property.longitude = property.longitude.to_s
annotations << {
:latitude => property.latitude,
:longitude => property.longitude,
:title => "#{property.title}", 
:subtitle => "",
:url => "/app/Property/{#{@property.object}}"  
}
end
end 
 map_params = {
                 :settings => {:map_type => "hybrid",:region => [Geolocation.latitude, Geolocation.longitude, 1, 1],
                               :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => false,
                               :api_key => 'Google Maps API Key'}, 
                 :annotations => annotations
               }
               
               MapView.create map_params

                redirect :action => :index                             
 
 end
  
end  

def geo_callback
  WebView.navigate url_for(:action => :map_all) if @params['known_position'].to_i != 0 && @params['status'] == 'ok'

end    

  #GET /Property
  def index
    @properties = Property.find(:all)
    render :back => '/app'
  end
   

     
   
def search 
  Property.search(:from => 'search',
:search_params => {
                   :address => @params['address'],
                   :type => @params['type']},
:callback => '/app/Property/search_callback', 
:callback_param => "") 

@response['headers']['Wait-Page'] = 'true' 
render :action => :searching 
end

def search_callback
   if @params['status'] == 'complete'
@property = Property.find(:all, 
                          :conditions => {    
                            { 
                            :func => 'LOWER',  
                            :name => 'address', 
                            :op => 'LIKE'
                            } => "#{@params['address']}".downcase,
                            {  
                              
                              :name => 'type', 
                              :op => 'LIKE'
                            } => @params['type']
                            },
                            :op => 'OR',
                            :select => ['title','address','city']) 

 render_transition :action => :search
else
WebView.navigate url_for :action => :index 
end
end   


        
  def saleprop
   @saleprop =  Property.find(:all, :conditions => {'cat_id' => '1' } ) 
  end
  
  def sold
   @sold =  Property.find(:all, :conditions => {'sold' => '1' } ) 
  end
  
  def featured
   @featured =  Property.find(:all, :conditions => {'featured' => '1' } ) 
  end
  
  def rentprop
     @rentprop =  Property.find(:all, :conditions => {'cat_id' => '2' } )  
  end


  # GET /Property/{1}
  def show
    @property = Property.find(@params['id'])     
     @gallery = Gallery.find(:all, :conditions => {'property_id' => @property.object }) 
      
     @gallery.each do |photo|
      @id = photo.object 
       @photo = photo.photo_file_name  
        
         @imgurl1 =  "http://s3.amazonaws.com/Khmobile/sample/Real-Estate.jpg"
               
         @imgurl = "http://s3.amazonaws.com/Khmobile/#{photo.object}/thumb/#{photo.photo_file_name}"   
         
     
     end
      
         


    if @property
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Property/new
  def new
    @property = Property.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Property/{1}/edit
  def edit
    @property = Property.find(@params['id'])
    if @property
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Property/create
  def create
    @property = Property.create(@params['property'])
    redirect :action => :index
  end

  # POST /Property/{1}/update
  def update
    @property = Property.find(@params['id'])
    @property.update_attributes(@params['property']) if @property
    redirect :action => :index
  end

  # POST /Property/{1}/delete
  def delete
    @property = Property.find(@params['id'])
    @property.destroy if @property
    redirect :action => :index  end
end
