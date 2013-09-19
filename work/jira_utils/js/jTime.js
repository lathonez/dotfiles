/*
 * Javascript for jTime
 */

$(document).ready(function() {

	// sort out the datepicker
	$('#date').Zebra_DatePicker({
		direction: false,
		format: 'd/m/Y'
	});

	// set the date to yesterday
	$('#date').val(yesterday());
	
 });


/*
 * Returns yesterday in dd/mm/yyyy
 */
function yesterday() {

	var date = new Date(),
	    d, m, y;

	date.setDate(date.getDate() - 1)

	d = ("00" + date.getDate()).slice (-2);
	m = ("00" + date.getMonth()).slice (-2);
	y = date.getFullYear();

	return d + '/' + m + '/' + y;
};
