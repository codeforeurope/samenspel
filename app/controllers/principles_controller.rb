class PrinciplesController < ApplicationController

  skip_before_filter :load_project
  before_filter :load_organization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |f|
      flash[:error] = t('common.not_allowed')
      f.any(:html, :m) { redirect_to root_path }
      handle_api_error(f, @organization)
    end
  end

  # GET /principles
  # GET /principles.xml
  def index
    @principles = @organization.principles.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @principles }
    end
  end

  # GET /principles/1
  # GET /principles/1.xml
  def show
    @principle = @organization.principles.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @principle }
    end
  end

  # GET /principles/new
  # GET /principles/new.xml
  def new
    @principle = @organization.principles.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @principle }
    end
  end

  # GET /principles/1/edit
  def edit
    @principle = @organization.principles.find(params[:id])
  end

  # POST /principles
  # POST /principles.xml
  def create
    @principle = @organization.principles.new(params[:principle])

    respond_to do |format|
      if @principle.save
        format.html { redirect_to(organization_principles_path(@organization), :notice => 'Principle was successfully created.') }
        format.xml  { render :xml => @principle, :status => :created, :location => @principle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @principle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /principles/1
  # PUT /principles/1.xml
  def update
    @principle = Principle.find(params[:id])

    respond_to do |format|
      if @principle.update_attributes(params[:principle])
        format.html { redirect_to(organization_principles_path(@organization), :notice => 'Principle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @principle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /principles/1
  # DELETE /principles/1.xml
  def destroy
    @principle = Principle.find(params[:id])
    @principle.destroy

    respond_to do |format|
      format.html { redirect_to(organization_principles_path(@organization)) }
      format.xml  { head :ok }
    end
  end

  protected

  def load_organization
    unless @organization = current_user.organizations.find_by_permalink(params[:organization_id])
      flash[:error] = "Invalid organization"
      redirect_to root_path
    end
  end

end
