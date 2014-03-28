require 'csv'
class AdminController < ApplicationController
  before_filter :set_page_title

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |f|
      flash[:error] = t('common.not_allowed')
      f.any(:html, :m) { redirect_to root_path }
      handle_api_error(f, @organization)
    end
  end


  def index
    authorize! :supervise, :all

  end

  def users
    authorize! :supervise, :all
    @users = User.all

    respond_to do |format|
      format.html
      format.csv { send_data serialize_users(@users), :type => 'text/csv',
                             :filename => "samenspel_users.csv" }
    end
  end

  def projects
    authorize! :supervise, :all
    @projects = Project.all

    respond_to do |format|
      format.html
      format.csv { send_data serialize_projects(@projects), :type => 'text/csv',
                             :filename => "samenspel_projects.csv"}
    end
  end

  def teams
    authorize! :supervise, :all
    @organizations = Organization.all

    respond_to do |format|
      format.html
      format.csv { send_data serialize_organizations(@organizations), :type => 'text/csv',
                             :filename => "samenspel_organizations.csv" }
    end
  end

  private

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
