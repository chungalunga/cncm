class ProjectsController < ApplicationController

  
  def index
    @projects = Project.all
	@idents = Ident.all
  end

  def show
    @ident = Ident.find(params[:id])
    @idents = Ident.find(:all, :conditions => { :production_line_id => ident.production_line_id})#@projects.idents
	@biz_hours = Array.new

	
	@idents.each do |ident|
		@previous_end_time = 
		friday = Time.parse(ident.start_expected.to_s)
		monday = Time.parse(ident.finish_expected.to_s)
		@biz_hours.to_a.push friday.business_time_until(monday)
	end
  end

  def new
    @project = Project.new
  end

  def create
    @projects = Project.all
    @project = Project.create(Project_params)
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @projects = Project.all
    @project = Project.find(params[:id])
    @project.update_attributes(Project_params)
  end

  def delete
    @project = Project.find(params[:Project_id])
  end

  def destroy
    @projects = Project.all
    @project = Project.find(params[:id])
    @project.destroy
  end

  def filter_calendar
	@city_text = params[:production_line]
	
    respond_to do |format|
      format.js { 
        render 'filter_calendar.js.erb' 
       }
      format.html {} 
    end
  end
  
  #not used
  def update
	if @post.update(post_params)
	  flash[:notice] = "Your post was edited."
	else
	  flash[:notice] = "Uncheck"
	end
  end
  

  
private
  def Project_params
    params.require(:Project).permit(:name, :price)
  end  
end
