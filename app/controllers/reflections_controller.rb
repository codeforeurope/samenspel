class ReflectionsController < ApplicationController
  before_filter :load_reflection, :except => [:index, :new, :create]
  before_filter :set_page_title

  rescue_from CanCan::AccessDenied do |exception|
    handle_cancan_error(exception)
  end

  def new
    authorize! :reflect, @current_project
    @reflection = @current_project.reflections.new

    respond_to do |f|
      f.any(:html, :m) { }
    end
  end

  def create
    authorize! :reflect, @current_project
    @reflection = @current_project.reflections.new_by_user(current_user, params[:reflection])

    if @reflection.save
      respond_to do |f|
        f.any(:html, :m) {
          if request.xhr? or iframe?
            render :partial => 'activities/thread', :locals => {:thread => @reflection }
          else
            redirect_to current_reflection
          end
        }
        handle_api_success(f, @reflection, true)
      end
    else
      respond_to do |f|
        f.any(:html, :m) {
          if request.xhr? or iframe?
            output_errors_json(@reflection )
          else
            # TODO: display inline instead of flash
            flash.now[:error] = @reflection.errors.to_a.first
            render :action => :new
          end
        }
        handle_api_error(f, @reflection )
      end
    end
  end

  def index
    @reflections = @current_project.reflections

    respond_to do |f|
      f.any(:html, :m)
      f.rss   { render :layout => false }
      f.xml   { render :xml     => @reflections.to_xml }
      f.json  { render :as_json => @reflections.to_xml }
      f.yaml  { render :as_yaml => @reflections.to_xml }
    end
  end

  def show
    @reflections = @current_project.reflections

    respond_to do |f|
      f.any(:html, :m)
      f.xml   { render :xml     => @reflection.to_xml(:include => :comments) }
      f.json  { render :as_json => @reflection.to_xml(:include => :comments) }
      f.yaml  { render :as_yaml => @reflection.to_xml(:include => :comments) }
    end
  end

  def update
    authorize! :update, @reflection
    success = @reflection.update_attributes(params[:reflection])

    respond_to do |f|
      f.js   { head :ok }
      f.any(:html, :m) { redirect_to current_reflection }

      if success
        handle_api_success(f, @reflection)
      else
        handle_api_error(f, @reflection)
      end
    end
  end

  def destroy
    authorize! :destroy, @reflection
    @reflection.destroy

    respond_to do |f|
      f.any(:html, :m) do
        flash[:success] = t('deleted.reflection', :name => @reflection.to_s)
        redirect_to project_reflections_path(@current_project)
      end
      f.js { head :ok }
      handle_api_success(f, @reflection)
    end
  end

  def watch
    authorize! :watch, @reflection
    @reflection.add_watcher(current_user)

    respond_to do |f|
      f.js { render :layout => false }
      f.any(:html, :m) { redirect_to current_reflection }
    end
  end

  def unwatch
    @reflection.remove_watcher(current_user)

    respond_to do |f|
      f.js { render :layout => false }
      f.any(:html, :m) { redirect_to current_reflection }
    end
  end

  protected

  def load_reflection
    @reflection = @current_project.reflections.find params[:id]
  end

  def current_reflection
    [@current_project, @reflection]
  end
end
