module Events
  class EventsController < ::ApplicationController
    def index
      @today  = Date.today
      respond_to do |format|
        format.html do
          return redirect_to(monthly_schedule_path(:year => params[:year] || @today.year, :month => @today.month)) unless params[:year] && params[:month]
          @events = Event.by_params params
        end
        format.xml  { render :xml  => @events = Event.by_params(params) }
        format.json { render :json => @events = Event.by_params(params) }
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
      @event = Event.new params[:event]

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
        if @event.update_attributes params[:event]
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
        format.html { redirect_to events_events_url }
        format.xml  { head :ok }
        format.json { head :ok }
      end
    end
  end
end