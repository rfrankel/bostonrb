require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context 'GET to index' do
    setup do
      @user = Factory.build(:user)
      @users = [@user]
      User.stubs(:ordered).returns(@users)

      @recurring_events = [Factory.build(:recurring_event, :id => 1)]
      Event.stub_chain(:next, :recurring).returns(@recurring_events)

      @special_events = [Factory.build(:special_event, :id => 2)]
      Event.stub_chain(:next, :special).returns(@special_events)

      @recent_jobs = [Factory.build(:job, :id => 3)]
      Job.stub_chain(:ordered, :limited).returns(@recent_jobs)

      @featured_project = Factory.build(:project)
      Project.stubs(:featured).returns(@featured_project)

      @recent_projects = [Factory.build(:project)]
      Project.stub_chain(:ordered, :limited).returns(@recent_projects)

      @recent_companies = [Factory.build(:company)]
      Company.stub_chain(:ordered, :limited).returns(@recent_companies)

      get :index
    end

    should_respond_with :success
    should_render_template :index

    should "fetch users" do
      assert_received(User, :ordered) {|expect| expect.with("updated_at desc") }
    end

    should "fetch 4 recurring events" do
      assert_received(Event, :next) {|expect| expect.with(4) }
      assert_received(Event, :recurring)
    end

    should "fetch 5 special events" do
      assert_received(Event, :next) {|expect| expect.with(5) }
      assert_received(Event, :special)
    end

    should "fetch 5 recent jobs" do
      assert_received(Job, :limited) {|expect| expect.with(5) }
      assert_received(Job, :ordered)
    end

    should "fetch featured project" do
      assert_received(Project, :featured)
    end

    should "fetch 5 recent projects" do
      assert_received(Project, :limited) {|expect| expect.with(5) }
      assert_received(Project, :ordered)
    end

    should "fetch 5 recent companies" do
      assert_received(Company, :limited) {|expect| expect.with(5) }
      assert_received(Company, :ordered)
    end

    should_assign_to(:users) { @users }
    should_assign_to(:recurring_events) { @recurring_events }
    should_assign_to(:special_events)   { @special_events }
    should_assign_to(:recent_jobs)      { @recent_jobs }
    should_assign_to(:featured_project) { @featured_project }
    should_assign_to(:recent_projects)  { @recent_projects }
    should_assign_to(:recent_companies) { @recent_companies }
  end

  context "given a future recurring event on GET to index" do
    setup do
      @event = Factory(:recurring_event, :date => 2.days.from_now)
      get :index
    end

    should "link to event" do
      assert_select "a[href=?]", event_path(@event), :text => @event.title
    end
  end

  context "given a future special event on GET to index" do
    setup do
      @event = Factory(:special_event, :date => 2.days.from_now)
      get :index
    end

    should "link to event" do
      assert_select "#other_events .center" do
        assert_select "a[href=?]", event_path(@event), :text => @event.title
      end
    end
  end
end

