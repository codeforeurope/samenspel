require 'csv'
class AdminController < ApplicationController
  before_filter :set_page_title
  before_filter :check_admin

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |f|
      flash[:error] = t('common.not_allowed')
      f.any(:html, :m) { redirect_to root_path }
      handle_api_error(f, @organization)
    end
  end


  def index
  end

  def users
    @users = User.all

    respond_to do |format|
      format.html
      format.csv { send_data serialize_users(@users), :type => 'text/csv',
                             :filename => "samenspel_users.csv" }
    end
  end

  def projects
    @projects = Project.all

    respond_to do |format|
      format.html
      format.csv { send_data serialize_projects(@projects), :type => 'text/csv',
                             :filename => "samenspel_projects.csv"}
    end
  end

  def teams
    @organizations = Organization.all

    respond_to do |format|
      format.html
      format.csv { send_data serialize_organizations(@organizations), :type => 'text/csv',
                             :filename => "samenspel_organizations.csv" }
    end
  end

  def dashboard
    #Comments in the last 30 days mapped by day
    @comments = Comment.where('created_at >= ?', 30.days.ago).map{ |c| c.created_at.to_date}
    #Tasks in the last 30 days mapped by day
    @tasks = Task.where('created_at >= ?', 30.days.ago).map{ |c| c.created_at.to_date}
    #Active users
    @users = User.all
    #Users ordered by __number of posts___
    @users_by_activeness = @users.sort { |a,b| a.count_of_comments <=> b.count_of_comments }
    #first 5 users
    @most_active = @users_by_activeness.slice(0,5)
    #last 5 users
    @less_active = @users_by_activeness.slice(@users_by_activeness.length - 5, @users_by_activeness.length)
    #Active (non-deleted) Teams
    @teams = Organization.where(:deleted == nil)
    #Number of Projects per team
    Organization.where("deleted = false").sort { |a,b| a.projects.count <=> b.projects.count }
    #Active Projects (non-archived and non-deleted) ordered by number of comments
    Project.where("deleted = false AND archived = false").sort { |a,b| a.comments.count <=> b.comments.count }
    # number of pending (unaccepted) invitations
    #

    # http://chartkick.com/




    # posts in the last 30 days
    # count of current users
    # users ordered by numer of posts ->
    # -> users with most posts in total
    # -> users with less posts in total
    # number of pending (unaccepted) invitations
    #
    # Number of teams
    # Number of projects per team
    # Number of posts per team


    #What else should we consider ? Tasks ?


  end

  private

  def check_admin
    authorize! :supervise, :all
  end

  def serialize_users(users)
    csv_string = CSV.generate do |csv|
      csv << ["Name", "Login", "Email", "Created At"]
      users.each do |user|
        csv << [user.name,
                user.login,
                user.email,
                user.created_at.to_s(:csv_time)
                ]
      end
    end
    csv_string
  end

  def serialize_projects(items)
    csv_string = CSV.generate do |csv|
      csv << ["Name", "Goal", "Created At", "Status"]
      items.each do |item|
        csv << [item.name,
                item.goal,
                item.created_at.to_s(:csv_time),
                item.archived ? "Archived" : "In Progress"
        ]
      end
    end
    csv_string
  end

  def serialize_organizations(items)
    csv_string = CSV.generate do |csv|
      csv << ["Name", "Permalink", "Created At"]
      items.each do |item|
        csv << [item.name,
                item.permalink,
                item.created_at.to_s(:csv_time)
        ]
      end
    end
    csv_string
  end

end
