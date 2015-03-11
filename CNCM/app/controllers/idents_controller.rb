
#load 'timeslot_allocation.rb'

class IdentsController < ApplicationController
    respond_to :html, :js
    #include TimeslotAllocation

  def index
    @idents = Ident.all
  end

  def show
	@projects = Project.all
	@idents = Ident.all
	@idents_new = Ident.where(:status => 'new').order(project_id: :desc, production_line_text: :desc)
	@log = Array.new
	5.times do |n|
		filter_calendar
	end
	#@log.to_a.push "Start"
  end

  def new
    @ident = Ident.new
  end

  def create
    @idents = Ident.all
    @ident = Ident.create(Ident_params)
  end

  def edit
    @ident = Ident.find(params[:id])
  end

  def update
    @idents = Ident.all
    @ident = Ident.find(params[:id])
    @ident.update_attributes(Ident_params)
  end

  def delete
    @ident = Ident.find(params[:Ident_id])
  end

  def destroy
    @idents = Ident.all
    @ident = Ident.find(params[:id])
    @ident.destroy
  end
	@@perecntage_complete = 0
	@@total_done = 0
	@@progress_bar_ident_count = 0
  def filter_calendar
	#js sends selected ident (from combobox) as a text of the field.
	#to figure out how to get value=x of option
	ident_id = 2791 #params[:selected_ident_tmp]
	schedule_options = params[:schedule_options]
	min_start_date = params[:min_start_date_tmp]
	@log = Array.new

	@@perecntage_complete = 0
	@@total_done = 0

	ident = Ident.find(ident_id)


	#Update ident with user change
	ident.priority = 5
	ident.save

	min_start_date = 0.business_hours.after(Time.parse((DateTime.now.end_of_hour + 1.minute).to_s))

	#Clear idents parts
	Ident.where('id != part_of').delete_all

	#update_ident_add_to_schedule(ident_id, schedule_options, min_start_date, "pending")
	pending_idents = Ident.order(priority: :desc, start_expected: :asc)
	@@progress_bar_ident_count = pending_idents.count
	#threads = []
	#threads << Thread.new { 
			if pending_idents.count > 0
				pending_idents.each do |ident|
					update_ident_add_to_schedule(ident.id, schedule_options, min_start_date, "locked")

					logger.info " "
					logger.info "PERCENTAGE COMPLETE " + @@total_done.to_s + " : " +  @@progress_bar_ident_count.to_s + " : " +  @@perecntage_complete.to_s
				end
			end
			reposition_category("Rezkanje")
	#}
	#threads.each(&:join)
	#reset_session
	#global_variables.each { |e| eval("#{e} = nil") }
	#GC.start
	#logger.info " !!!!!!!!!!! " + previous_non_working(DateTime.now).to_s

	respond_to do |format|
		format.js { 
		render 'filter_calendar.js.erb' 
		}
		format.html {} 
	end
  end

def previous_non_working(previous_ident_finish)
	
		found_previous_non_working_day = false
		counter = 1
		number_of_days_previous = 300

		while found_previous_non_working_day == false

			timeslot_start = Date.parse((previous_ident_finish - counter.days).to_s) 
			timeslot_finish = Date.parse(DateTime.now.to_s)
			logger.info "timeslot_start: " + timeslot_start.to_s + " timeslot_finish: " + timeslot_finish.to_s
			#Check when it stops incrementing
			number_of_days = timeslot_start.business_days_until(timeslot_finish)
			if number_of_days == number_of_days_previous

				@previous_ident_finish = Date.parse((previous_ident_finish - (counter - 1).days).to_s)

				found_previous_non_working_day = true
				return @previous_ident_finish
			end
			number_of_days_previous = number_of_days
			#safety
			if counter > 6
				found_previous_non_working_day = true
				return "ERROR"
				log.to_a.push "CRITICAL ERROR: Get business_time till next non-working day. reached a 100 failed loops."
			end
			counter += 1

		end
	end

def reposition_category(category)

	category_idents = Ident.where('start_expected >= ?', DateTime.now.to_s).where('production_line_text = ?', category).where('status != ?', 'new').order(priority: :desc, start_expected: :asc)
	logger.info "Repositioning category: rezkanjve, with " + category_idents.count.to_s + " idents"

	#Tracks where we left previous ident, we continue after this date.
	current_position = Time.parse(DateTime.now.to_s)

	if category_idents.count > 0
		category_idents.each do |ident|
			@log.to_a.push "IDENT: " + ident.id.to_s

			perf_header = Time.now
			#@log.to_a.push "LOG COUNT: " + category_idents.count.to_s
			#**********************************
			#SET WORKINGHOURS AND CHECK IF THERE IS A MINIMUM START DATE
			#***********************************
			ident_workinghours_options = ident.schedule_options
			
			BusinessTime::Config.work_week = [:mon, :tue, :wed, :thu, :fri]
			BusinessTime::Config.beginning_of_workday = "6:00 am"
			BusinessTime::Config.end_of_workday = "10:00 pm"

			Holidays.between(Date.civil(2015, 1, 1), 2.years.from_now, :si, :observed).map do |holiday|
			  BusinessTime::Config.holidays << holiday[:date]
			  # Implement long weekends if they apply to the region, eg:
			  # BusinessTime::Config.holidays << holiday[:date].next_week if !holiday[:date].weekday?
			end

			#Set the starting point for our ident
			if ident.min_start_date.present? == true
				if ident.min_start_date > DateTime.now
					min_start_date = Time.parse(ident.min_start_date.to_s)
				else
					min_start_date = Time.parse((DateTime.now.end_of_hour + 1.minute).to_s)
				end
			else
				min_start_date = Time.parse((DateTime.now.end_of_hour + 1.minute).to_s)
			end

			if current_position > min_start_date
				min_start_date = current_position
			end

			min_start_date = 0.business_hours.after(Time.parse(min_start_date.to_s))

			#@log.to_a.push  "*****************************************************"
			#@log.to_a.push  "PROCESSING IDENT: " + ident.id.to_s
			#@log.to_a.push  "*****************************************************"
			@selected_ident = Ident.find(ident.id)
			@selected_ident_estimated_hours = @selected_ident.estimated_hours

			idents1 = Ident.where.not(:status => 'locked', :id => ident)
			starter = 0

			ident_split_part = 0
			tmp = 0
			#@log.to_a.push  "Estimated hours needed: " + @selected_ident_estimated_hours.to_s + " ident: " + @selected_ident.id.to_s
			#Holds the actual slot start (to be used at the end to check if we moved some idents in timeline)
			slot_start_actual = Time.parse(DateTime.now.to_s)

			@log.to_a.push "Header: " + ((Time.now - perf_header) * 1000).to_s

			perf_loop = Time.now
			while @selected_ident_estimated_hours >= 1

				

				ident_in_timeline = ""

				if starter == 0
					#Check if there is some slot already placed in our start time.
					#if it is, take this slots end as our starting point
					
					perf_query_ident = Time.now
					ident_start = idents1.where('finish_expected > ?', min_start_date).where('start_expected < ?', min_start_date).where('production_line_text = ?', @selected_ident.production_line_text).order(finish_expected: :asc).take(1)
						@log.to_a.push "Query ident starter: " + ((Time.now - perf_query_ident) * 1000).to_s
				
					if ident_start.count > 0

						#@log.to_a.push "Found ident (ID: " + ident_start[0].id.to_s + ") that is crossing our timeline starting pint. slot start set to this ident finish point: " + Time.parse(ident_start[0].finish_expected.to_s).to_s
						slot_start = Time.parse(ident_start[0].finish_expected.to_s)
					
					else
					
						#@log.to_a.push "First check: there is no ident crossing our start point. We start from DateTime.now / preselected date"
						
					end
						slot_start = min_start_date
					if current_position > slot_start
						slot_start = current_position
					end

					starter = 1
				end

				slot_finish = Time.parse(return_next_non_working(slot_start).to_s)
				#@log.to_a.push " "
				#@log.to_a.push @selected_ident.id.to_s + "Possible slot start: " + slot_start.to_s + " end: " + slot_finish.to_s 
				#@log.to_a.push " "
				perf_query = Time.now
				ident_start = idents1.where('start_expected >= ?', (slot_start + 1.hour).to_s).where('start_expected < ?', slot_finish).where('production_line_text = ?', @selected_ident.production_line_text).where('priority >= ?', @selected_ident.priority).where('status != ?', 'locked').order(start_expected: :asc).take(1)
				@log.to_a.push "Query idents: " + ((Time.now - perf_query) * 1000).to_s
				#Check if there are any idents in our timeslot
				#if an ident is found, check the timeslot betweeen our current start and ident start
				perf_header1 = Time.now
				if ident_start.count > 0

					perf_slot_finish = Time.now

					slot_finish = Time.parse(ident_start[0].start_expected.to_s)
					@log.to_a.push "slot finish: " + ((Time.now - perf_slot_finish) * 1000).to_s

					perf_ident_finish = Time.now
					ident_finish = (ident_start[0].estimated_hours).business_hours.after(slot_start)
					@log.to_a.push "ident finish: " + ((Time.now - perf_ident_finish) * 1000).to_s
					#@log.to_a.push "Found IDent that is in our timeslot. ID: " + ident_start[0].id.to_s + " start: " + ident_start[0].start_expected.to_s + " finish: " + ident_start[0].finish_expected.to_s
					perf_available = Time.now
					#Check available timeslot between current slot_start and ident start
					available_timeslot = ((slot_start).business_time_until(slot_finish) / 3600).round
					@log.to_a.push "timeslot: " + ((Time.now - perf_available) * 1000).to_s					
					#@log.to_a.push "Available business time in slot: " + slot_start.to_s + " : " + slot_finish.to_s + " available h: " + available_timeslot.to_s

				else
					perf_available = Time.now
					#@log.to_a.push "Complete timeslot is usabe. start: " + slot_start.to_s + " finish: " + slot_finish.to_s
					available_timeslot = ((slot_start).business_time_until(slot_finish) / 3600).round
					#@log.to_a.push "Available business time in slot: " + slot_start.to_s + " : " + slot_finish.to_s + " available h: " + available_timeslot.to_s
					@log.to_a.push "timeslot: " + ((Time.now - perf_available) * 1000).to_s	
				end

				@log.to_a.push "Slot search 1: " + ((Time.now - perf_header1) * 1000).to_s

				perf_slot_search = Time.now

				slot_start = 0.business_hours.after(slot_start)
				slot_finish = 0.business_hours.before(slot_finish)
				#Check if its more than 1h in size
				logger.info "available slot e: " + available_timeslot.to_s
				if available_timeslot > 0
						slot_start_actual = 0.business_hours.after(slot_start)	
					if (@selected_ident_estimated_hours - available_timeslot) > 0

						@selected_ident.name + " !" + (ident_split_part + 1).to_s
						@selected_ident.save

						ident_copy = @selected_ident.dup
						#Must be saved for .dup to be commited
						ident_copy.save
						ident_copy_id = ident_copy.id.to_s
						ident_copy_name = ident_copy.name + " !" + (ident_split_part + 1).to_s
						ident_copy.save	
						
						update_ident(ident_copy_id, @selected_ident.id, ident_copy_name, slot_start, slot_finish, "pending")
						#@log.to_a.push "!!!!!!!!!!!!!!!!!!!!Created a partial ident (ID: " + ident_copy.id.to_s + ") , start: " + slot_start.to_s + " finish: " + slot_finish.to_s

						slot_finish = slot_finish
		 				#Deduct allocated time from the needed hours to complete selected ident
		 				@selected_ident_estimated_hours -= available_timeslot
		 				ident_split_part += 1
		 				#sleep 1
					else

						if @selected_ident.name.include? "!"
							slot_finish = (@selected_ident_estimated_hours).business_hours.after(slot_start)
							@selected_ident.name = @selected_ident.name + " !" + ident_split_part.to_s
							update_ident(@selected_ident.id,@selected_ident.id, @selected_ident.name, slot_start, slot_finish, "pending")
							#@log.to_a.push "!!!!!!!!!!!!!!!!!! Created last ident of series (ID: " + @selected_ident.id.to_s + ") , start: " + slot_start.to_s + " finish: " + slot_finish.to_s
							#sleep 1
						else
							slot_finish = (@selected_ident_estimated_hours).business_hours.after(slot_start)
							#update_ident(@selected_ident.id,@selected_ident.id, @selected_ident.name, slot_start, slot_finish, "pending")
							Ident.where(:id => @selected_ident.id).update_all(:start_expected => Time.parse(slot_start.to_s), :finish_expected => Time.parse(slot_finish.to_s), :status => "pending")

							#@log.to_a.push " "
							#@log.to_a.push "Created one-part ident (ID: " + @selected_ident.id.to_s + ") , start: " + slot_start.to_s + " finish: " + slot_finish.to_s
							#@log.to_a.push " "

							logger.info " "
							logger.info "Created one-part ident (ID: " + @selected_ident.id.to_s + ") , start: " + slot_start.to_s + " finish: " + slot_finish.to_s
							logger.info " "
							#sleep 1
								
						end	
						@selected_ident_estimated_hours -= available_timeslot
					end
				end	

				@log.to_a.push "Slot search: " + ((Time.now - perf_slot_search) * 1000).to_s
				#When both start and finih are on the same time (when they are connected)
				#we pick the next start based on what is closer: ident_finish or nextnonbusinessday 
				perf_slot_search1 = Time.now

				if slot_start == slot_finish
					if ident_finish < return_next_non_working(slot_start)
						#@log.to_a.push "Ident finish smaller thant next non working"
						slot_start = 0.business_hours.after(ident_finish)
					else
						slot_start = 0.business_hours.after(return_next_non_working(slot_start))
					end
					#@log.to_a.push "****Equals Slot start (" + slot_start.to_s + ") updated with finish ("+ slot_finish.to_s + ")"
					#@log.to_a.push "Remaining hours " + @selected_ident_estimated_hours.to_s
				else
					#@log.to_a.push "Slot start (" + slot_start.to_s + ") updated with finish ("+ slot_finish.to_s + ")"
					#@log.to_a.push "Remaining hours " + @selected_ident_estimated_hours.to_s
					slot_start = 0.business_hours.after(slot_finish)
				end

				current_position = slot_finish

				if tmp == 50
					#@log.to_a.push "Forced exit"
					@selected_ident_estimated_hours = 0
				end

				tmp += 1

				@log.to_a.push "Remaining: " + ((Time.now - perf_slot_search1) * 1000).to_s
			end
			@log.to_a.push "Loop total: " + ((Time.now - perf_loop) * 1000).to_s
		@@perecntage_complete = ((@@total_done.to_f / @@progress_bar_ident_count) * 100).round
		@@total_done += 1
		
		end		
	end

	local_variables.each { |e| eval("#{e} = nil") }
	GC.start
end



def reject_proposed_time_slot

 		@ident_id = params[:selected_ident_tmp]
		@selected_ident = Ident.find(@ident_id)
		@selected_ident.status = "new"
		@selected_ident.save

	    respond_to do |format|
	      format.js { 
	        render 'reject_proposed_time_slot.js.erb' 
	       }
	      format.html {} 
	    end
end

def filter_calendar_category
    
    filter_category = params[:selected_category]
    logger.info "!!!!!!!!!!!!!!!!!!! " + filter_category.to_s
    if filter_category.to_s == "all"
		@idents = Ident.where.not(:status => "new")
	else
		@idents = Ident.where(:production_line_text => filter_category)
		@idents = @idents.where.not(:status => "new")
    end
	render :json => @idents.map { |ident|
    { :id => ident.ident_id,
      :title => ident.id.to_s + " " + ident.name + " (" + ident.production_line_text + ")",
      :start => ident.start_expected.strftime("%FT%R"),
	  :end => ident.finish_expected.strftime("%FT%R"),
	  :url => "/idents/" + ident.id.to_s,
	  :color => ident.color
	  }
  }  
  end

  def update_ident_priority()
	@log = Array.new 	

  	ident_id = params[:ident_id]
  	priority = params[:priority]

  	ident = Ident.find(ident_id)
	
	#Update ident with user change
	ident.priority = priority
	ident.save

	#update also all partials of ident

	#Ident.where(:part_of => ident_id).update_all(:priority => priority)
	#sleep 0.5

	pending_idents = Ident.where('production_line_text = ?', ident.production_line_text).order(priority: :desc, start_expected: :asc)

	#Update start and finish initial values to todays date (first theoretical point of start)
	if pending_idents.count > 0
		pending_idents.each do |ident|
			update_ident_reset_timeslot(ident.id, 0.business_hours.after(Time.parse((DateTime.now.end_of_hour + 1.minute).to_s)), "pending")
			#@log.to_a.push "!!!!!!!!! UPDATE IDENT " + ident.id.to_s
		end
	end
	
	#Reposition entire category
	reposition_category(ident.production_line_text.to_s)

	logger.info " ID " + ident_id.to_s + " priority: " + priority.to_s
 	respond_to do |format|
	    format.js { 
	  	  render 'update_ident_priority.js.erb' 
	    }
		format.html {} 
	end

  end

  def show_ident_card

  	ident_id = params[:ident_id]
  	@ident_id = ident_id.to_s

	respond_to do |format|
	    format.js { 
	  	  render 'show_ident_card.js.erb' 
	    }
		format.html {} 
	end

  end
	@@perecntage_complete = 0
  def task_percentage_complete

  	render :json => @@perecntage_complete

  end

  def render_json
    
    filter_category = params[:selected_category]

    if filter_category.to_s == "all" || filter_category.to_s == ""
		@idents = Ident.where.not(:status => "new")
	else

		@idents = Ident.where(:production_line_text => filter_category)
		@idents = @idents.where.not(:status => "new")
		
    end
	render :json => @idents.map { |ident|
    { :ident_id => ident.id,
      :title => ident.id.to_s + " prio: " + ident.priority.to_s + " " + ident.name.to_s + " (" + ident.estimated_hours.to_s + ")",
      :start => ident.start_expected.strftime("%FT%R"),
	  :end => ident.finish_expected.strftime("%FT%R"),
	  :url => ident.id.to_s,
	  :color => ident.color,
	  :description => "<p>" + ident.id.to_s + " " + ident.name.to_s + " (" + ident.production_line_text.to_s + ")" + "</p><p>Estimated hours: " + ident.estimated_hours.to_s + "</p><p>" + ident.priority.to_s + "</p><p> start: " + ident.start_expected.strftime("%FT%R").to_s + " finish: " + ident.finish_expected.strftime("%FT%R").to_s + "</p>"
	  }
  }  
  end

	def update_ident(id, part_of, name, start_expected,finish_expected, status, duplicate = false)
		Ident.where(:id => id).limit(1).update_all(:name => name, :part_of => part_of, :start_expected => start_expected, :finish_expected => finish_expected, :status => status)
	end

	def update_ident_add_to_schedule(id, schedule_options, min_start_date, status)
		Ident.where(:id => id).limit(1).update_all(:part_of => id, :schedule_options => schedule_options, :start_expected => min_start_date, :finish_expected => min_start_date, :status => status)
	end

	def update_ident_reset_timeslot(id, min_start_date, status)
		Ident.where(:id => id).limit(1).update_all(:part_of => id, :start_expected => min_start_date, :finish_expected => min_start_date, :status => status)
	end

	def return_next_non_working(previous_ident_finish)
		found_non_working_day = false
		non_working_day = DateTime.now
		counter = 0
		reported_value = 10000
		#Get business_time till next non-working day. 
		#the .business_days_until returns an int (how many working days in the range)
		#When this value repeates itself (stops incrementing) we know we have hit a non working day
		while found_non_working_day == false

			get_non_working_day_start = Date.parse(previous_ident_finish.to_s)
			get_non_working_day_finish = Date.parse((previous_ident_finish + counter.day).to_s)
													
			temp = Date.parse(DateTime.now.to_s)
			temp1 = Date.parse((DateTime.now + 1.days).to_s)
			temp.business_days_until(temp1)
			result_tmp = get_non_working_day_start.business_days_until(get_non_working_day_finish)
			if reported_value == result_tmp
				found_non_working_day = true
				next_non_business = Time.parse((get_non_working_day_finish - 1.days).to_s)
				return next_non_business
				@log.to_a.push "FOUND next non working: " + next_non_business.to_s
			else
				reported_value = get_non_working_day_start.business_days_until(get_non_working_day_finish)
			end

			#safety
			if counter > 100
				found_non_working_day = true
				return "ERROR"
				log.to_a.push "CRITICAL ERROR: Get business_time till next non-working day. reached a 100 failed loops."
			end
			counter += 1
		end
		local_variables.each { |e| eval("#{e} = nil") }
		GC.start
	end

	def previous_non_working(previous_ident_finish)
	
		found_previous_non_working_day = false
		counter = 1
		number_of_days_previous = 300

		while found_previous_non_working_day == false

			timeslot_start = Date.parse((previous_ident_finish - counter.days).to_s) 
			timeslot_finish = Date.parse(DateTime.now.to_s)

			#Check when it stops incrementing
			number_of_days = timeslot_start.business_days_until(timeslot_finish)
			if number_of_days == number_of_days_previous
				if timeslot_start < DateTime.now
					
					@previous_ident_finish
				
				else
				
				@previous_ident_finish = Date.parse((previous_ident_finish - (counter - 1).days).to_s)
				
				end
				found_previous_non_working_day = true
			end

			counter += 1
			#safety
			if counter > 100
				found_previous_non_working_day = true
				return "ERROR"
				log.to_a.push "CRITICAL ERROR: Get business_time till next non-working day. reached a 100 failed loops."
			end
			counter += 1

		end

	end
end
