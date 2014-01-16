class ContactsController < ApplicationController

  skip_before_filter :load_project
  before_filter :load_organization, :only => :index
  before_filter :load_organization_by_name, :except=> :index

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |f|
      flash[:error] = t('common.not_allowed')
      f.any(:html, :m) { redirect_to root_path }
      handle_api_error(f, @organization)
    end
  end

  # GET /contacts
  # GET /contacts.xml
  def index
    @contacts = @organization.contacts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = @organization.contacts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = @organization.contacts.new
    @contact.organization = @organization

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = @organization.contacts.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = @organization.contacts.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@contact, :notice => 'Contact was successfully created.') }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to([@organization, @contact], :notice => 'Contact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def assign_to_project
    if params[:project_id]
      @project = Project.find params[:project_id]
    else
      @project = Project.find_by_id_or_permalink params[:project_id]
    end
    @contact = @organization.contacts.find(params[:id])
    @contact.projects << @project


    @contact.save! do |success, failure|
      success.html {
          redirect_to :back
      }
      failure.html {
        redirect_to :back
      }
    end
  end

  def remove_from_project
    @project = Project.find params[:project_id]
  else
    @project = Project.find_by_id_or_permalink params[:project_id]
  end
  @contact = @organization.contacts.find(params[:id])
  @contact.projects.delete(@project)

  @contact.save! do |success, failure|
    success.html {
      redirect_to :back
    }
    failure.html {
      redirect_to :back
    }
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = @organization.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def load_organization
    unless @organization = current_user.organizations.find_by_permalink(params[:id])
      flash[:error] = "Invalid organization"
      redirect_to root_path
    end
  end

  def load_organization_by_name
    unless @organization = current_user.organizations.find_by_permalink(params[:organization_id])
      flash[:error] = "Invalid organization"
      redirect_to root_path
    end
  end

end
