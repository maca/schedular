require 'helper'

class PartialsTest < ActionView::TestCase
  include CalendarHelper

  def setup
    @event = Schedular::Event.new :dates => '10 enero 2010', :name => 'evento 1'
  end

  context 'rendering month partial' do
    should 'render day numbers with empty events' do
      html = <<-HTML
        <table id="events-calendar">
          <thead>
            <tr><th>dom</th><th>lun</th><th>mar</th><th>mie</th><th>jue</th><th>vie</th><th>sab</th></tr>
          </thead>
          <tbody>
            <tr><td class="notmonth weekend"><span class="day-number">27</span></td><td class="notmonth"><span class="day-number">28</span></td><td class="notmonth"><span class="day-number">29</span></td><td class="notmonth"><span class="day-number">30</span></td><td class="notmonth"><span class="day-number">31</span></td><td><span class="day-number">1</span></td><td class="weekend"><span class="day-number">2</span></td></tr>
            <tr><td class="weekend"><span class="day-number">3</span></td><td><span class="day-number">4</span></td><td><span class="day-number">5</span></td><td><span class="day-number">6</span></td><td><span class="day-number">7</span></td><td><span class="day-number">8</span></td><td class="weekend"><span class="day-number">9</span></td></tr>
            <tr><td class="weekend"><span class="day-number">10</span></td><td><span class="day-number">11</span></td><td><span class="day-number">12</span></td><td><span class="day-number">13</span></td><td><span class="day-number">14</span></td><td><span class="day-number">15</span></td><td class="weekend"><span class="day-number">16</span></td></tr>
            <tr><td class="weekend"><span class="day-number">17</span></td><td><span class="day-number">18</span></td><td><span class="day-number">19</span></td><td><span class="day-number">20</span></td><td><span class="day-number">21</span></td><td><span class="day-number">22</span></td><td class="weekend"><span class="day-number">23</span></td></tr>
            <tr><td class="weekend"><span class="day-number">24</span></td><td><span class="day-number">25</span></td><td><span class="day-number">26</span></td><td><span class="day-number">27</span></td><td><span class="day-number">28</span></td><td><span class="day-number">29</span></td><td class="weekend"><span class="day-number">30</span></td></tr>
            <tr><td class="weekend"><span class="day-number">31</span></td><td class="notmonth"><span class="day-number">1</span></td><td class="notmonth"><span class="day-number">2</span></td><td class="notmonth"><span class="day-number">3</span></td><td class="notmonth"><span class="day-number">4</span></td><td class="notmonth"><span class="day-number">5</span></td><td class="notmonth weekend"><span class="day-number">6</span></td></tr>
          </tbody>
        </table>
      HTML

      assert_dom_equal html, render('schedular/events/month', :events => [], :year => 2010, :month => 1)
    end
    
    should 'render day numbers with events' do
      html = <<-HTML
        <table id="events-calendar">
          <thead>
            <tr><th>dom</th><th>lun</th><th>mar</th><th>mie</th><th>jue</th><th>vie</th><th>sab</th></tr>
          </thead>
          <tbody>
            <tr><td class="notmonth weekend"><span class="day-number">27</span></td><td class="notmonth"><span class="day-number">28</span></td><td class="notmonth"><span class="day-number">29</span></td><td class="notmonth"><span class="day-number">30</span></td><td class="notmonth"><span class="day-number">31</span></td><td><span class="day-number">1</span></td><td class="weekend"><span class="day-number">2</span></td></tr>
            <tr><td class="weekend"><span class="day-number">3</span></td><td><span class="day-number">4</span></td><td><span class="day-number">5</span></td><td><span class="day-number">6</span></td><td><span class="day-number">7</span></td><td><span class="day-number">8</span></td><td class="weekend"><span class="day-number">9</span></td></tr>
            <tr><td class="weekend"><a href="/events/2010/1/10" class="day-number">10</a></td><td><span class="day-number">11</span></td><td><span class="day-number">12</span></td><td><span class="day-number">13</span></td><td><span class="day-number">14</span></td><td><span class="day-number">15</span></td><td class="weekend"><span class="day-number">16</span></td></tr>
            <tr><td class="weekend"><span class="day-number">17</span></td><td><span class="day-number">18</span></td><td><span class="day-number">19</span></td><td><span class="day-number">20</span></td><td><span class="day-number">21</span></td><td><span class="day-number">22</span></td><td class="weekend"><span class="day-number">23</span></td></tr>
            <tr><td class="weekend"><span class="day-number">24</span></td><td><span class="day-number">25</span></td><td><span class="day-number">26</span></td><td><span class="day-number">27</span></td><td><span class="day-number">28</span></td><td><span class="day-number">29</span></td><td class="weekend"><span class="day-number">30</span></td></tr>
            <tr><td class="weekend"><span class="day-number">31</span></td><td class="notmonth"><span class="day-number">1</span></td><td class="notmonth"><span class="day-number">2</span></td><td class="notmonth"><span class="day-number">3</span></td><td class="notmonth"><span class="day-number">4</span></td><td class="notmonth"><span class="day-number">5</span></td><td class="notmonth weekend"><span class="day-number">6</span></td></tr>
          </tbody>
        </table>
      HTML

      assert_dom_equal html, render('schedular/events/month', :events => [@event], :year => 2010, :month => 1)
    end
  end
  
end


