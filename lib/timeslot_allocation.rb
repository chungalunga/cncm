module TimeslotAllocation

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
		local_variables.each { |e| eval("#{e} = nil") }
		GC.start

	end



end