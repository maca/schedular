module Schedular
  class EventsController < ::ApplicationController
    helper_method :current_month
    
    def index
      today   = Date.today
      
      return redirect_to(monthly_schedule_path(:year => params[:year] || today.year, :month => today.month)) unless params[:year] && params[:month]
      @events                 = Event.by_params(params).include_times
      @month_events           = params[:day] ? Event.by_params(params.merge(:day => nil)) : @events
      session[:current_month] = Date.civil params[:year].to_i, params[:month].to_i
      
      respond_to do |format|
        format.html {}
        format.xml  { render :xml  => @events }
        format.json { render :json => @events }
      end
    end
    
    def show
      @event = Event.find params[:id]
      respond_to do |format|
        format.html {}
        format.xml  { render :xml  => @event }
        format.json { render :json => @event }
      end
    end
  
    def new
      @event = Event.new
      respond_to do |format|
        format.html {}
        format.xml  { render :xml  => @event }
        format.json { render :json => @event }
      end
    end
    
    def edit
      @event = Event.find params[:id]
    end
    
    def create
      @event = Event.new params[:schedular_event]

      respond_to do |format|
        if @event.save
          # flash[:notice] = 'Event was successfully created.'
          format.html { redirect_to @event }
          format.xml  { render :xml  => @event, :status => :created, :location => @event }
          format.json { render :json => @event, :status => :created, :location => @event }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml    => @event.errors, :status => :unprocessable_entity }
          format.json { render :json   => @event.errors, :status => :unprocessable_entity }
        end
      end
    end
    
    def update
      @event = Event.find params[:id]

      respond_to do |format|
        if @event.update_attributes params[:schedular_event]
          # flash[:notice] = 'Event was successfully created.'
          format.html { redirect_to @event }
          format.xml  { render :xml  => @event, :status => :ok, :location => @event }
          format.json { render :json => @event, :status => :ok, :location => @event }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml    => @event.errors, :status => :unprocessable_entity }
          format.json { render :json   => @event.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @event = Event.find params[:id]
      @event.destroy

      respond_to do |format|
        format.html { redirect_to schedular_events_url }
        format.xml  { head :ok }
        format.json { head :ok }
      end
    end
  
    private
    def current_month
      session[:current_month]
    end
  end
end