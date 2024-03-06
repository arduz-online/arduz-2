(function($) { 

var vInt=0; // this variable controls the loop
var refresh=1; // refresh when a time finish
var interval=1000; // the loop interval

	$.extend($, {
		jtabber: function(params){
				
				// parameters
				var navDiv = params.mainLinkTag;
				var selectedClass = params.activeLinkClass;
				var hiddenContentDiv = params.hiddenContentClass;
				var showDefaultTab = params.showDefaultTab;
				var showErrors = params.showErrors;
				var effect = params.effect;
				var effectSpeed = params.effectSpeed;
				
				// If error checking is enabled
				if(showErrors){
					if(!$(navDiv).attr('title')){
						alert("ERROR: The elements in your mainLinkTag paramater need a 'title' attribute.\n ("+navDiv+")");	
						return false;
					}
					else if(!$("."+hiddenContentDiv).attr('id')){
						alert("ERROR: The elements in your hiddenContentClass paramater need to have an id.\n (."+hiddenContentDiv+")");	
						return false;
					}
				}
				
				// If we want to show the first block of content when the page loads
				if(!isNaN(showDefaultTab)){
					showDefaultTab--;
					$("."+hiddenContentDiv+":eq("+showDefaultTab+")").css('display','block');
					$(navDiv+":eq("+showDefaultTab+")").addClass(selectedClass);	
				}
				
				// each anchor
				$(navDiv).each(function(){
										
					$(this).click(function(){
						// once clicked, remove all classes
						$(navDiv).each(function(){
							$(this).removeClass();
						})
						// hide all content
						$("."+hiddenContentDiv).css('display','none');
						
						// now lets show the desired information
						$(this).addClass(selectedClass);
						var contentDivId = $(this).attr('title');
						
						if(effect != null){
							
							switch(effect){
								
								case 'slide':
								$("#"+contentDivId).slideDown(effectSpeed);
								break;
								case 'fade':
								$("#"+contentDivId).fadeIn(effectSpeed);
								break;
								
							}
								
						}
						else {
							$("#"+contentDivId).css('display','block');
						}
						return false;
					})
				})
				/*$("a#saltartab").each(function(){
					$(this).click(function(){
						$("."+hiddenContentDiv).css('display','none');
						var contentDivId = $(this).attr('title');
						if(effect != null){
							switch(effect){
								case 'slide':
								$("#"+contentDivId).slideDown(effectSpeed);
								break;
								case 'fade':
								$("#"+contentDivId).fadeIn(effectSpeed);
								break;
							}
						}
						else {
							$("#"+contentDivId).css('display','block');
						}
						return false;
					})
				})*/

			}
	})

// this function autostarts the infinite loop, every second, triggers the countdown fn
jQuery.autocountdown = function () {
	$('.countdown').countdown(); // trigger the fn
	vInt=setInterval("$('.countdown').countdown();", interval); // set the loop
}

// countdown function, update second-by-second the time to finish
jQuery.fn.countdown = function (options) {
	var defaults = {  // set up default options
		refresh:     1,		 // refresh when a time finish
		interval:    1000, // the loop interval
		cdClass:     'countdown', // the class to apply this plugin
		granularity: 5,
		
		label:    ['s ', 'd ', 'h', ':', ''],
		units:    [604800, 86400, 3600, 60, 1]
	};
	if (options && options.label) {
		$.extend(defaults.label, options.label);
		delete options.label;
	}
    if (options && options.units) {
      $.extend(defaults.units, options.units);
      delete options.units;
    }
	$.extend(defaults, options);

	// pad fn, add left zeros to the string
	var pad = function (value, length) {
		value = String(value);
		length = parseInt(length) || 2;
		while (value.length < length)
			value = "0" + value;
		if (value<1) value = "00";
		return value;
	};

	var format_interval = function (timestamp) {
		var label = defaults.label;
		var units = defaults.units;
		var granularity = defaults.granularity;

		output = '';
		for (i=1; i<=units.length; i++) {
			value=units[i];
			if (timestamp >= value) {	      				
				var val=pad(Math.floor(timestamp / value), 2);
				val = val>0 ? val : '00';
				output += val + label[i];
				timestamp %= value;
				granularity--;
			} 
			else if (value==1) output += '00'; // we need the final seconds to allways show 00, i.e., 03:00

			if (granularity == 0)
				break; 
		}
		
		if (output.length<3) output = '00:'+output;
		return output ? output : '00:00';
	}
	
	// the countdown core
	return this.each(function() {
		secs=$(this).attr('secs');
		$(this).html(format_interval(secs));
		secs--;
		
		if (secs<1) {
			$(this).attr('secs', '...');
			clearInterval(vInt);
			if (refresh)
				window.location.href = window.location.href;
		} else
			$(this).attr('secs', secs);
		
	});

}
	this.tooltip = function(){
		xOffset = 10;
		yOffset = 20;
		$(".tooltip").hover(function(e){
			this.t = this.title;this.title = "";
			$("body").append("<p id='tooltip'>"+ this.t +"</p>");
			$("#tooltip").css("top",(e.pageY - xOffset) + "px");
			$("#tooltip").css("left",(e.pageX + yOffset) + "px");
			$("#tooltip").show();
		},function(){
			this.title = this.t;$("#tooltip").remove();
		});
		$("a.tooltip").mousemove(function(e){
			$("#tooltip").css("top",(e.pageY - xOffset) + "px");
			$("#tooltip").css("left",(e.pageX + yOffset) + "px");
		});
	};
})(jQuery);
$(document).ready(function(){
	tooltip();
	$.jtabber({mainLinkTag: "#nav a",activeLinkClass: "selected",hiddenContentClass: "hiddencontent",showDefaultTab: 1,showErrors: false,effect: 'slide',effectSpeed: 'medium'});
	$.autocountdown();
	$('.menuz').mouseover(function(){$(this).animate({opacity:1},'fast');});
	$('.menuz').mouseout(function(){$(this).animate({opacity:0},'normal');});
});
function resizeFlashTextDiv(flashtextdivid,flashwidth,flashheight) {
	document.getElementById(flashtextdivid).style.width = flashwidth + 'px';
	document.getElementById(flashtextdivid).style.height = flashheight + 'px';
}