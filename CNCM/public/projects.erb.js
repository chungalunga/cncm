
var ready;
ready = function() {

	$('#production_line').change(function(){
	
	alert('s');
		$.ajax({
			url: 'http://10.0.9.105:3000/idents/filter_calendar',
			data: {
				production_line: $("#production_line option:selected").text()
			},
			dataType: "script"
		});
	});
	
$('#calendar').fullCalendar({
			timezone: 'local',
			defaultView: 'month',
			allDaySlot: false,
			minTime: '05:00:00',
			maxTime: '23:00:00',
			axisFormat: 'HH:mm',
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			aspectRatio: 1.6,
			defaultDate: '2015-03-12',
			selectable: true,
			selectHelper: true,
			select: function(start, end) {
				var title = prompt('Event Title:');
				var eventData;
				if (title) {
					eventData = {
						title: title,
						start: start,
						end: end
					};
					$('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
				}
				$('#calendar').fullCalendar('unselect');
			},
			editable: true,
			eventLimit: true, // allow "more" link when too many events			
			events: 'http://10.0.9.105:3000/idents/render_json'
			
		});
};

$(document).ready(ready);
$(document).on('page:load', ready);
