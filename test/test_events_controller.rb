require 'helper'

class Schedular::EventsControllerTest < ActionController::TestCase
  should_route :get,  '/events',               :controller => 'schedular/events', :action => :index
  should_route :post, '/events',               :controller => 'schedular/events', :action => :create
  should_route :put,  '/events/1',             :controller => 'schedular/events', :action => :update, :id   => '1'
  should_route :get,  '/events/1/edit',        :controller => 'schedular/events', :action => :edit,   :id   => '1'
  should_route :get,  '/events/1',             :controller => 'schedular/events', :action => :show,   :id   => '1'
  should_route :get,  '/events/2009/1/29',     :controller => 'schedular/events', :action => :index,  :year => '2009', :month => '1', :day => '29'
  should_route :get,  '/events/2009/1/29.xml', :controller => 'schedular/events', :action => :index,  :year => '2009', :month => '1', :day => '29', :format => 'xml'
  should_route :get,  '/events/2009/1',        :controller => 'schedular/events', :action => :index,  :year => '2009', :month => '1'
  should_route :get,  '/events/2009/1.xml',    :controller => 'schedular/events', :action => :index,  :year => '2009', :month => '1', :format => 'xml'

  context 'controller actions' do
    setup do
      Schedular::Event.destroy_all
      Schedular::Time.destroy_all
      @today  = Date.today
      @event1 = Schedular::Event.create! :dates => 'enero',        :name => 'evento 1'
      @event2 = Schedular::Event.create! :dates => '1 de febrero', :name => 'evento 2'
      @event3 = Schedular::Event.create! :dates => '2 de febrero', :name => 'evento 2'
    end

    context 'GET index' do
      context 'redirection' do
        context 'with no options' do
          setup { get :index }
          should_redirect_to('current month'){ monthly_schedule_path :year => @today.year, :month => @today.month }
        end

        context 'with just year' do
          setup { get :index, :year => '2009' }
          should_redirect_to('current month'){ monthly_schedule_path :year => '2009', :month => @today.month }
        end
      end

      def self.with_format format
        context "with format #{format}" do
          setup do 
            @params = {:year => @today.year, :month => '1'}
            @params.merge!(:format => format) if format
            @day    = Date.civil(@today.year)
          end

          context 'with month' do
            setup { get :index, @params }
            should_respond_with :success
            should_assign_to(:events){ [@event1] }
            should_assign_to(:month_events){ [@event1] }
            should 'set session[:current_month]' do
              assert_equal Date.civil(@today.year, 1), @request.session[:current_month]
            end
            yield if block_given?
          end

          context 'with month and day' do
            setup do 
              @day = Date.civil(@params[:year], 2, 1)
              get :index, @params.merge(:month => @day.month, :day => @day.day)
            end
            should_respond_with :success
            should_assign_to(:events){ [@event2] }
            should_assign_to(:month_events){ [@event2, @event3] }
            should 'set session[:current_month]' do
              assert_equal Date.civil(@day.year, @day.month), @request.session[:current_month]
            end
            yield if block_given?
          end
        end
      end

      with_format nil do
        # should_render_template :index
        should_respond_with_content_type 'text/html'
        # should 'render with template' do
        #   assert_equal "layouts/application", @controller.active_layout._unmemoized_path_without_format_and_extension
        # end
      end
      
      with_format 'xml' do
        should_respond_with_content_type 'application/xml'
      end
      
      with_format 'json' do
        should_respond_with_content_type 'application/json'
      end
    end

    context 'GET show' do
      def self.with_format format
        context "with format #{format}" do
          setup do 
            @params = {:id => @event1.id}
            @params.merge!(:format => format) if format
            get :show, @params
          end
          should_respond_with :success
          should_assign_to(:event){ @event1 }
          yield
        end
      end

      with_format nil do
        # should_render_template :index
        should_respond_with_content_type 'text/html'
      end
      with_format 'xml' do
        should_respond_with_content_type 'application/xml'
      end
      with_format 'json' do
        should_respond_with_content_type 'application/json'
      end
    end

    context 'GET new' do
      def self.with_format format
        context "with format #{format}" do
          setup do 
            @params = {}
            @params.merge!(:format => format) if format
            get :new, @params
          end
          should_respond_with :success
          should_assign_to(:event)
          should('be a new record') { assert assigns(:event).new_record? }
          yield
        end
      end

      with_format nil do
        should_respond_with_content_type 'text/html'
      end
      with_format 'xml' do
        should_respond_with_content_type 'application/xml'
      end
      with_format 'json' do
        should_respond_with_content_type 'application/json'
      end
    end

    context 'GET edit' do
      setup do 
        get :edit, :id => @event1.id
      end
      should_respond_with :success
      should_assign_to(:event){ @event1 }
      # should_render_template :edit
    end

    context 'POST create' do
      def self.with_format format
        context "with format #{format}" do
          setup do 
            @params = { :schedular_event => {:dates => 'enero', :name => 'Evento 1'}}
            @params.merge!(:format => format) if format
          end

          context "with valid attributes" do
            setup { post :create, @params }
            should_assign_to(:event)
            should('set dates'){ assert_equal 'enero', assigns(:event).dates }
            should('not be new record') { assert_equal false, assigns(:event).new_record? }
            yield
            if format
              should_respond_with :created
            else
              should('redirect to created event'){ assert_redirected_to assigns(:event) } 
            end
          end

          context "with invalid attributes" do
            setup do
              @params[:schedular_event].merge!(:name => nil)
              post :create, @params
            end
            should_assign_to(:event)
            should('set dates'){ assert_equal 'enero', assigns(:event).dates }
            should('be new record') { assert assigns(:event).new_record? }
            yield
            if format
              should_respond_with :unprocessable_entity
            else
              # should('render new'){ assert_template :new }
            end
          end
        end
      end

      with_format nil do
        should_respond_with_content_type 'text/html'
      end
      with_format 'xml' do
        should_respond_with_content_type 'application/xml'
        
      end
      with_format 'json' do
        should_respond_with_content_type 'application/json'
      end
    end

    context 'PUT update' do
      def self.with_format format
        context "with format #{format}" do
          setup do 
            @params = { :schedular_event => {:dates => 'febrero', :name => 'Evento 1'}, :id => @event1.id }
            @params.merge!(:format => format) if format
          end

          context "with valid attributes" do
            setup { put :update, @params }
            should_assign_to(:event)
            should('set dates'){ assert_equal 'febrero', assigns(:event).dates }
            yield
            if format
              should_respond_with :ok
            else
              should('redirect to created event'){ assert_redirected_to assigns(:event) } 
            end
          end

          context "with invalid attributes" do
            setup do
              @params[:schedular_event].merge!(:name => nil)
              put :update, @params
            end
            should_assign_to(:event)
            should('set dates'){ assert_equal 'febrero', assigns(:event).dates }
            yield
            if format
              should_respond_with :unprocessable_entity
            else
              # should('render new'){ assert_template :edit }
            end
          end
        end
      end

      with_format nil do
        should_respond_with_content_type 'text/html'
      end
      with_format 'xml' do
        should_respond_with_content_type 'application/xml'
        
      end
      with_format 'json' do
        should_respond_with_content_type 'application/json'
      end
    end
    
    context 'DELETE destroy' do
      def self.with_format format
        context "with format #{format}" do
          setup do 
            @params = {:id => @event1.id}
            @params.merge!(:format => format) if format
            assert_difference('Schedular::Event.count', -1) do
              delete :destroy, @params
            end
          end

          should_assign_to(:event){ @event1 }
          yield
        end
      end

      with_format nil do
        should_respond_with_content_type 'text/html'
        should_redirect_to('events'){ schedular_events_path }
      end
      with_format 'xml' do
        should_respond_with_content_type 'application/xml'
        should_respond_with :ok
      end
      with_format 'json' do
        should_respond_with_content_type 'application/json'
        should_respond_with :ok
      end
    end
  end
end