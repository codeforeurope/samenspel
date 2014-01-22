# -*- encoding : utf-8 -*-
class OrganizationsController < ApplicationController
  skip_before_filter :load_project
  before_filter :load_organization, :only => [:show, :edit, :appearance, :update, :projects, :contacts, :delete, :destroy, :timeline]
  before_filter :load_page_title, :only => [:show, :members, :projects, :edit, :appearance, :update, :delete]
  before_filter :redirect_community, :only => [:index, :new, :create]

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |f|
      flash[:error] = t('common.not_allowed')
      f.any(:html, :m) { redirect_to root_path }
      handle_api_error(f, @organization)
    end
  end

  def index
    @page_title = t('organizations.index.title')
    @organizations = current_user.organizations
  end

  def show
    redirect_to edit_organization_path(@organization)
  end

  def projects
    @people = current_user.people
    @roles = {  Person::ROLES[:observer] =>    t('roles.observer'),
                Person::ROLES[:commenter] =>   t('roles.commenter'),
                Person::ROLES[:participant] => t('roles.participant'),
                Person::ROLES[:admin] =>       t('roles.admin') }
  end

  def new
    authorize! :create_organization, current_user
    @organization = current_user.organizations.build
  end

  def create
    @organization = Organization.new(params[:organization])
    authorize! :create_organization, current_user

    if @organization.save
      membership = @organization.memberships.build(:role => Membership::ROLES[:admin])
      membership.user_id = current_user.id
      membership.save!
      flash[:notice] = t('organizations.new.created')
      redirect_to organization_path(@organization)
    else
      flash.now[:error] = t('organizations.new.invalid_organization')
      render :new
    end

  end

  def edit
  end

  def appearance
  end

  def update
    if @organization.update_attributes(params[:organization])
      flash[:success] = t('organizations.edit.saved')
    end

    redirect_path = if request.referer =~ /appearance/
                      appearance_organization_path(@organization)
                    else
                      edit_organization_path(@organization)
                    end

    redirect_to redirect_path
  end

  def external_view
    @organization = Organization.find_by_permalink(params[:id])
  end

  def delete
    if !can?(:admin, @organization)
      flash[:error] = t('organizations.delete.need_to_be_admin')
      redirect_to @organization
    end
  end

  def destroy
    if !can?(:admin, @organization)
      flash[:error] = t('organizations.delete.need_to_be_admin')
      redirect_to @organization
    elsif @organization.projects.any?
      flash[:error] = t('organizations.delete.not_with_projects')
      redirect_to @organization
    else
      @organization.destroy
      flash[:notice] = t('organizations.delete.deleted')
      redirect_to organizations_path
    end
  end

  def timeline
    authorize! :view_timeline, @organization
    if params[:year].nil?
      @year = Time.current.year
    else
      @year = Time.current.year
    end

    @projects = @organization.projects
    @source = []
    @projects.each do |project|
      p_date_start = project.date_start.nil? ? project.created_at.to_date : project.date_start.to_date
      p_date_end = project.date_end.nil? ? Date.today.to_date : project.date_end.to_date
      s = { name: project.name,
            desc: '',
            url:  project_path(project),
            values: [{ from: p_date_start,
                      to: p_date_end,
                      label: project.name,
                      customclass: '',
                      #dataObj: project_path(project)
                    }]
          }
      @source << s
    #sample = { name: "test", desc: "test", values: { from: "" }}
    end


  end

  protected

    def load_organization
      unless @organization = current_user.organizations.find_by_permalink(params[:id])
        if organization = Organization.find_by_permalink(params[:id])
          redirect_to external_view_organization_path(@organization)
        else
          flash[:error] = t('organizations.edit.invalid')
          redirect_to root_path
        end
      end
    end

    def load_page_title
      @page_title = h(@organization)
    end

    def redirect_community
      if Teambox.config.community
        flash[:error] = t('organizations.not_in_community')
        redirect_to root_path
      end
    end

end
