
var ready;
ready = function() {
	noty({text: 'noty - a jquery notification library!</br><b>ktjtkjdkjdksjksdjdks</b>',
    layout: 'bottomLeft',
    theme: 'relax', // or 'relax'
    type: 'error',
    dismissQueue: true, // If you want to use queue feature set this true
    template: '<div class="noty_message"><span class="noty_text"></span><div class="noty_close"></div></div>'
});

	$('#datetimepicker2').datetimepicker({
		lang:'sl',
	});
	
	$('.fc-month-button.fc-button.fc-state-default.fc-corner-left.fc-state-active').click(function(){
		alert('dodd');
	});

	$('#btn_check').click(function(){
	    var schedule_options = '';
		$("input:checkbox").each(function() {
			schedule_options += ';' + String($(this).is(":checked"));
		});
		document.getElementById("result_div").innerHTML = schedule_options;
		
		var select = document.getElementById("ident");
		var selected_ident = select.options[select.selectedIndex].text;
		var min_start_date = document.getElementById('datetimepicker2').value


		$.ajax({
			url: 'http://10.0.9.105:3000/idents/filter_calendar',
			data: {
				selected_ident_tmp: selected_ident,
				min_start_date_tmp: min_start_date,
				schedule_options: schedule_options
			},
			dataType: "script"
		});
		
		progressJs().start();
		
		(function worker() {
		  $.ajax({
		    url: 'http://10.0.9.105:3000/idents/task_percentage_complete', 
		    success: function(data) {

		      progressJs().set(data);
		      if(data < 90){
		      	progressJs(100).end();
				//setTimeout(worker, 500);
		      }
		      else
		      {
		      	progressJs(100).end();
		      }

		    }
		  });
		})();
	});

	$('#btn_dismiss').click(function(){

		var select = document.getElementById("ident");
		var selected_ident = select.options[select.selectedIndex].text;
		
		$.ajax({
			url: 'http://10.0.9.105:3000/idents/reject_proposed_time_slot',
			data: {
				selected_ident_tmp: selected_ident
			},
			dataType: "script"
		});

	});

	$('#calendar').fullCalendar({
		slotMinutes: 15,
		fixedWeekCount: false,
		firstDay: 1,
		timezone: 'local',
		defaultView: 'month',
		allDaySlot: false,
		minTime: '06:00:00',
		maxTime: '23:00:00',
		timeFormat: 'H:mm',
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		aspectRatio: 1.2,
		defaultDate: '2015-03-12',
		selectable: false,
		selectHelper: true,
		select: function(start, end) {
			var title = prompt('Event Title:');
			var eventData;
			if (title) {
				eventData = {
					title: title,
					start: start,
					description: description,
					ident_id: ident_id,
					end: end
				};
				$('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
			}
			$('#calendar').fullCalendar('unselect');
		},
		editable: true,
		eventLimit: true, // allow "more" link when too many events			
		events: 'http://10.0.9.105:3000/idents/render_json',
		eventClick: function(event) {
			$.ajax({
				url: 'http://10.0.9.105:3000/idents/show_ident_card',
				data: {
					ident_id: event.ident_id
				},
				dataType: "script"
			});
	        //Were just showing the card div...
	        if (event.url) {
	            return false;
	        }
    	}		
	});
	
	//successes();

	function errors(){
		$.notify("Projekt Projekt1 v zamudi 3 dni.", "error");
		$.notify("Material št. 3992882 (matice) 0 kosov!", "error");
	};

	function warrnings(){
		$.notify("Projekt Projekt1 2 dni do izteka roka. 0 dni rezerve.", "warrning");
		window.setTimeout(errors, 6000);
	};
   
	function successes(){
   		$.notify("Projekt Projekt1 uspešno zaključen 2 dni pred rokom.", "success");
   		window.setTimeout(informations, 6000);
	};

	function informations(){
		$.notify("Pričetek projekta Projekt2 čez 2 dni", "info");
    	$.notify("Pričetek projekta Projekt3 jutri", "info");
    	window.setTimeout(warrnings, 6000);
	};
};
	function toggleprojectEdit(){
		$('#projectEdit').modal('toggle');
	};


	function saveForm(){
		var id = document.getElementsByName('id[]'); // Removed [0], that gets the **1st** node, not the NodeList.
		var description = document.getElementsByName('description[]'); 
		var priority = document.getElementsByName('priority[]'); 
		var size = document.getElementsByName('size[]'); 
		var rezkanje = document.getElementsByName('rezkanje[]'); 
		var struzenje = document.getElementsByName('struzenje[]'); 

		for (var i = 0, j = id.length; i < j; i++) {

		    alert(id[i].value + " " + description[i].value);

			$.ajax({
				url: 'http://10.0.9.105:3000/idents/update_ident_priority',
				data: {
					ident_id: selected_ident,
					name: selected_priority
				},
			});
		}



		$('#projectEdit').modal('toggle');
	}

	var counter = 1;
	var limit = 3;
	function addInput(){
	     if (counter == limit)  {
	          alert("You have reached the limit of adding " + counter + " inputs");
	     }
	     else {

	     	//var div = document.getElementById('form_dynmic_fields')//.getElementsByClassName('bar');
			//div.innerHTML = div.innerHTML + 

	        var newdiv = document.createElement('div');
	        newdiv.innerHTML = ' <div class="pure-u-1 pure-u-md-1-8"> <input id="form_ident_id" class="pure-u-23-24" name="id[]" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-4"> <input id="form_ident_description" name="description[]" class="pure-u-23-24" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_priority" class="pure-u-23-24" name ="priority[]" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_size" class="pure-u-23-24" name="size[]" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_rezkanje" class="pure-u-23-24" name="rezkanje[]" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_struzenje" class="pure-u-23-24" name="struzenje[]" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_rezkanje" class="pure-u-23-24" name="rezkanje[]" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_struzenje" class="pure-u-23-24" type="text" style="font-size: 0.8em"> </div> <div class="pure-u-1 pure-u-md-1-12"> <input id="form_ident_struzenje" class="pure-u-23-24" type="text" style="font-size: 0.8em"> </div>';
	        document.getElementById("form_dynmic_fields").appendChild(newdiv);
	        
	     }
	}

	function update_ident()
	{
		var select = document.getElementById("card_priority");
		var selected_priority = select.options[select.selectedIndex].text;

		var selected_ident = document.getElementById("save_changes").name;

		$.ajax({
			url: 'http://10.0.9.105:3000/idents/update_ident_priority',
			data: {
				ident_id: selected_ident,
				priority: selected_priority
			},
			dataType: "script"
		});
	}

	function filter_calendar() {

		var select = document.getElementById("filter_category");
		var selected_ident = select.options[select.selectedIndex].text;

		$('#calendar').fullCalendar('removeEvents')
        var start_source1 = {
			url: 'http://10.0.9.105:3000/idents/render_json',
			data: {
				selected_category: selected_ident
			}
        };
        $('#calendar').fullCalendar('addEventSource', start_source1);
        start_source1.data.selected_category = selected_ident;
	}

$(document).ready(ready);
$(document).on('page:load', ready);