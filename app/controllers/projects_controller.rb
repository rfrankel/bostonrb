class ProjectsController < ApplicationController

  def index
    @projects = Project.all
    @left_projects, @right_projects = @projects.halve
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find params[:id]
  end

  def show
    @project = Project.find params[:id]
  end

  def create
    @project = Project.new params[:project]

    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def update
    @project = Project.find params[:id]

    if @project.update_attributes(params[:project])
      flash[:notice] = 'Project was successfully updated.'
      redirect_to project_path(@project)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    flash[:notice] = 'Project deleted.'
    redirect_to root_path
  end

  protected

  def load_feed_entries
    YAML.load(File.read(Project.feed_entries_path))
  end

end
