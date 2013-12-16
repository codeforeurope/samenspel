class TimelineController < ApplicationController
  before_filter :load_organizations, only: [:index]
  before_filter :load_organization, only: [:for_organization]

  def index
    #authorize! :view_all_timelines, current_user
  end

  def for_organization
    #authorize! :view_timeline, @organization
    @current_date = Time.current
    @year = @current_date.year

  end

  private

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

end
