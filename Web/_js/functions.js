/*                 ____________________________________________
 *                /_____/  http://www.arduz.com.ar/      \_____\
 *               //            ____   ____   _    _ _____      \\
 *              //       /\   |  __ \|  __ \| |  | |___  /      \\
 *             //       /  \  | |__) | |  | | |  | |  / /        \\
 *            //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
 *           //       / ____ \| | \ \| |__| | |__| |/ /__          \\
 *          / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
 *          \________________________________________________________/  
 *
 *		@writer: 		Agustín Nicolás Méndez (aka Menduz)
 *		@contact: 		lord.yo.wo@gmail.com
 *		@modify: 		15-11-09
 *		
 */
var CookieResults;
var Browser = {
	a : navigator.userAgent.toLowerCase()
}

var item_elegido;
var item_elegido_inventario;
var ajax=null;
var last_item_id;
var tmp_result;
var cabeza=0;
var craza=1;
var cgenero=1;
var czs	= new Array();
czs[11] = {s:1,m:37};
czs[12] = {s:70,m:8};

czs[21] = {s:101,m:9};
czs[22] = {s:170,m:7};

czs[31] = {s:200,m:9};
czs[32] = {s:270,m:7};

czs[41] = {s:401,m:5};
czs[42] = {s:470,m:6};

czs[51] = {s:300,m:5};
czs[52] = {s:370,m:2};





Browser = {
	ie : /*@cc_on true || @*/ false,
	ie6 : Browser.a.indexOf('msie 6') != -1,
	ie7 : Browser.a.indexOf('msie 7') != -1,
	opera : !!window.opera,
	safari : Browser.a.indexOf('safari') != -1,
	safari3 : Browser.a.indexOf('applewebkit/5') != -1,
	mac : Browser.a.indexOf('mac') != -1
}

function nuevoAjax(){
	var xmlhttp=false;
 	try {
 		xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
 	} catch (e) {
 		try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
 		} catch (E) {
 			xmlhttp = false;
 		}
  	}

	if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
 		xmlhttp = new XMLHttpRequest();
	}
	return xmlhttp;
}

function create_tooltips(){
	xOffset = 10;
	yOffset = 20;
	$(".tooltip").hover(function(e){
		if(this.title != ''){
			this.t = this.title;
		}
		this.title = '';
		//$("body").append("<p id='tooltip'>"+ this.t +"</p>");
		document.getElementById('tooltip').innerHTML=this.t;
		$("#tooltip").css("top",(e.pageY - xOffset) + "px");
		$("#tooltip").css("left",(e.pageX + yOffset) + "px");
		$("#tooltip").show();
	},function(){
		this.title = this.t;
		//$("#tooltip").css("display","none");
		document.getElementById('tooltip').innerHTML='';
		//$("#tooltip").remove();
		$("#tooltip").hide();
	});
	$(".tooltip").mousemove(function(e){
		$("#tooltip").css("top",(e.pageY - xOffset) + "px");
		$("#tooltip").css("left",(e.pageX + yOffset) + "px");
	});
}

function post_inventario_action(){
	var tmp_clear;
	if(item_elegido>0 && item_elegido < 31){
		document.getElementById('boton_inv').innerHTML = '<img src="'+mediactx+'_images/_layout/ajax.gif" alt="Cargando"/>';
		ajax=nuevoAjax();
		if(item_elegido_inventario){
			ajax.open("POST", ajax_url+"_"+pjid+".php?depo=1&d="+(Math.round((Math.random()*1000000)+1)));
		} else {
			ajax.open("POST", ajax_url+"_"+pjid+".php?depo=0&d="+(Math.round((Math.random()*1000000)+1)));
		}
		ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		ajax.send("slot="+item_elegido);
		ajax.onreadystatechange=function() {
			if (ajax.readyState==4) {
				tmp_clear = ajax.responseText;
				if(tmp_clear>0){
					tmp_result = tmp_clear;
					if(item_elegido_inventario){
						document.getElementById('Bvd'+tmp_clear).innerHTML=document.getElementById(last_item_id).innerHTML;
					} else {
						document.getElementById('I'+tmp_clear).innerHTML=document.getElementById(last_item_id).innerHTML;
					}
					document.getElementById(last_item_id).innerHTML='';
					document.getElementById(last_item_id).setAttribute("class", "initem");
					last_item_id='';
					item_elegido='';
					create_tooltips();
				}else{
					if(tmp_clear=='-3'){
						document.getElementById('err').innerHTML='Tu personaje no puede usar este objeto todav&iacute;a.';
						show_errora();
					}
					if(tmp_clear=='-4'){
						document.getElementById('err').innerHTML='No pod&eacute;s depositar objetos de newbies.';
						show_errora();
					}
				}
				if(item_elegido_inventario){
					document.getElementById('boton_inv').innerHTML = txt_compra;
				} else {
					document.getElementById('boton_inv').innerHTML = txt_vender;
				}
			}
		}
	}
	return false;
}

function post_mercado_action(){
	var tmp_clear;
	if(item_elegido>0 && item_elegido < 31){
		document.getElementById('boton_inv').innerHTML = '<img src="'+mediactx+'_images/_layout/ajax.gif" alt="Cargando"/>';
		ajax=nuevoAjax();
		if(item_elegido_inventario){
			ajax.open("POST", ajax_url+"_"+pjid+".php?depo=1&hash="+mercader_hash+"&h="+(Math.round((Math.random()*1000000)+1)));
		} else {
			ajax.open("POST", ajax_url+"_"+pjid+".php?depo=0&hash="+mercader_hash+"&h="+(Math.round((Math.random()*1000000)+1)));
		}
		ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		ajax.send("slot="+item_elegido+"&IDA="+mercader_id);
		ajax.onreadystatechange=function() {
			if (ajax.readyState==4) {
				results = ajax.responseText.split("|<");
				tmp_clear = results[0];
				if(tmp_clear>0){
					tmp_result = tmp_clear;
					if(item_elegido_inventario){
						document.getElementById('Bvd'+tmp_clear).innerHTML=document.getElementById(last_item_id).innerHTML;
					} else {
						document.getElementById('I'+tmp_clear).innerHTML=document.getElementById(last_item_id).innerHTML;
					}
					document.getElementById(last_item_id).innerHTML='';
					document.getElementById(last_item_id).setAttribute("class", "initem");
					last_item_id='';
					item_elegido='';
					create_tooltips();
				}else{
					if(tmp_clear=='0'){
						document.getElementById('err').innerHTML='No ten&eacute;s espacio en el inventario!!.';
						show_errora();
					}else if(tmp_clear=='-1'){
						document.getElementById('err').innerHTML='No ten&eacute;s suficientes puntos para comprar este objeto.';
						show_errora();
					}else if(tmp_clear=='-2'){
						document.getElementById(last_item_id).innerHTML='';
						document.getElementById(last_item_id).setAttribute("class", "initem");
						last_item_id='';
						item_elegido='';
						create_tooltips();
					}else if(tmp_clear=='-3'){
						document.getElementById('err').innerHTML='Tu personaje no puede usar este objeto todav&iacute;a.';
						show_errora();
					}else if(tmp_clear=='-4'){
						window.location.href = window.location.href+"?"+(Math.round((Math.random()*1000000)+1));
					}
				}
				
				document.getElementById('oroo').innerHTML=results[1];
				
				if(item_elegido_inventario){
					document.getElementById('boton_inv').innerHTML = txt_compra;
				} else {
					document.getElementById('boton_inv').innerHTML = txt_vender;
				}
			}
		}
	}
	return false;
}

function show_errora(){
	$("#err").animate({"opacity": "show"}, "slow");
	setTimeout(function(){$("#err").animate({"opacity": "hide"}, "slow");},4000);
}
function Toggle_vid(id){
	$("#"+id).animate({"opacity": "toggle","height":"toggle"}, "slow");
}

function click_item(id,numero,inventario){
	if(document.getElementById(id).innerHTML!=''){
		if(last_item_id){
			document.getElementById(last_item_id).setAttribute("class", "initem");
		}
		last_item_id = id;
		document.getElementById(id).setAttribute("class", "item_elegido");
		item_elegido = numero;
		if(inventario){
			item_elegido_inventario = true;
			document.getElementById('boton_inv').innerHTML = txt_vender;
		} else {
			item_elegido_inventario = false;
			document.getElementById('boton_inv').innerHTML = txt_compra;
		}
	}
}

function createElement(name, attrs, doc, xmlns) {
	var doc = doc ? doc : document;
	var elm;
	if(doc.createElementNS)
		elm = doc.createElementNS(xmlns ? xmlns : "http://www.w3.org/1999/xhtml", name);
	else
		elm = doc.createElement(name);
	if(attrs)
		for(attr in attrs)
			elm.setAttribute(attr, attrs[attr]);
	return elm;
}
function setDisplay(e, display) {daa(e).style.display = display;}
function hide(e) {setDisplay(e, 'none');}
function show(e) {setDisplay(e, '');}
function showBlock(e) {setDisplay(e, 'block');}
function visible(e) {return daa(e).style.display != 'none';}
function toggle(e) {(visible(e) ? hide : show)(e);}
function visibleInverse(e) {return daa(e).style.display != '';}
function toggleInverse(e, display) {setDisplay(e, visibleInverse(e) ? '' : display);}
function overflow(e) {return daa(e).style.height != 'auto';}
function setHeight(e, height) {daa(e).style.height = height;}
function auto(e) {setHeight(e, 'auto');}
function notauto(e) {setHeight(e, '');}
function toggleContent(e, f, anchor, collapsed, expanded) {
	if(visible(e)) {
		hide(e);
		show(f);
		anchor.innerHTML = collapsed;
	} else {
		show(e);
		hide(f);
		anchor.innerHTML = expanded;
	}
}
function toggleOverflow(e, anchor, collapsed, expanded) {
	if(overflow(e)) {
		auto(e);
		anchor.innerHTML = collapsed;
	} else {
		notauto(e);
		anchor.innerHTML = expanded;
	}
}
function swap(e,f) {hide(e);showBlock(f);}
function getChildElementsByTagName(e, tagName) {
	var nodes = [];
	for(var i = 0; i < e.childNodes.length; i++)
		if(e.childNodes[i].nodeName.toLowerCase() == tagName)
			nodes.push(e.childNodes[i]);
	return nodes;
}
function removeChildren(e) {while(e.firstChild)e.removeChild(e.firstChild);}
function addEvent(obj, evType, fn) {
	if(obj.addEventListener) {
		obj.addEventListener(evType, fn, false);
		return true;
	} else if(obj.attachEvent)
		return obj.attachEvent("on" + evType, fn);
	return false;
}
function getFormQueryString(form) {
	var pairs = [];
	var inputs = form.getElementsByTagName('input');
	var textareas = form.getElementsByTagName('textarea');
	var selects = form.getElementsByTagName('select');

	for(var i = 0, input; input = inputs[i]; i++)
		pairs.push(input.name + '=' + encodeURI(input.value));

	for(var i = 0, input; input = textareas[i]; i++)
		pairs.push(input.name + '=' + encodeURI(input.value));

	for(var i = 0, input; input = selects[i]; i++)
		for(var j = 0, option; option = input.options[j]; j++)
			if(option.selected)
				pairs.push(input.name + '=' + encodeURI(option.value));

	return pairs.join('&');
}

function getURLParams() {
	var map = {};
	var entries = document.location.search.substr(1).split('&');
	for(var i = 0; i < entries.length; i++) {
		var entry = entries[i].split('=', 2);
		if(!map[entry[0]])
			map[entry[0]] = [];
		map[entry[0]].push(entry.length == 2 ? decodeURIComponent(entry[1]) : null);
	}
	return map;
}

function createURLSearchString(map) {
	var search = '';
	for(field in map)
		if(!Object.prototype[field]) {
			var array = map[field];
			for(var i = 0; i < array.length; i++) {
				if(search != '')
					search += '&';
				search += field;
				if(array[i] != null)
					search += '=' + array[i];
			}
		}
	if(search != '')
		search = '?' + search;
	return search;
}

function setURLParam(parameter, value) {
	var url = document.location.protocol + '//' + document.location.host + document.location.pathname;
	var params = getURLParams();
	params[parameter] = [value];
	url += createURLSearchString(params);
	url += document.location.hash;
	return url;
}

function addStylesheet(href, media) {
	document.getElementsByTagName("head")[0].appendChild(createElement('link', {
		'rel': 'stylesheet',
		'type': 'text/css',
		'media': media ? media : 'screen, projection',
		'href': href
	}));
}


function createObject(id, type, data, width, height, params, fallbackContent, createElementFunc) {
	var createElementFunc = createElementFunc || createElement;
	var obj = createElementFunc('object', {
		'type': type,
		'data': data,
		'width': width,
		'height': height
	});
	if(id)
		obj.setAttribute('id', id);
	if(params)
		for(var i = 0, pair; pair = params[i]; i++)
			obj.appendChild(createElementFunc('param', {
				'name': pair[0],
				'value': pair[1]
			}));
	if(fallbackContent)
		obj.appendChild(fallbackContent);
	return obj;
}

function createElementStr(name, attrs) {return new NodeStr(name, attrs);}

// used for DOM-like creation of object elements in IE
var NodeStr = function(name, attrs) {
	this.name = name;
	if(attrs)
		this.attrs = attrs;
	else
		this.attrs = {};
	this.childNodes = [];
}
NodeStr.prototype = {
	appendChild : function(node) {
		this.childNodes.push(node);
		return node;
	},
	setAttribute : function(name, value) {
		this.attrs[name] = value;
	},
	toString : function() {
		var str = '<' + this.name;
		if(this.attrs)
			for(attr in this.attrs)
				str += ' ' + attr + '="' + this.attrs[attr] + '"';
		str += '>';
		for(child in this.childNodes)
			str += this.childNodes[child];

		return str + '</' + this.name + '>';
	}
}
function daa(e) {if (typeof e == 'string') return document.getElementById(e);return e;}
function setFlash(target, id, data, width, height, params, fallback) {
	var FLASH_MEDIA_TYPE = 'application/x-shockwave-flash';
	var targetNode = document.getElementById(target);
	
	// DOM manipulation and styling of OBJECT tags is not available in IE
	if(Browser.ie) {
		if(typeof fallback != 'string')
			fallback = fallback.innerHTML;
		targetNode.innerHTML = createObject(id, FLASH_MEDIA_TYPE, data, width, height, params, fallback, createElementStr);
	} else {
		if(typeof fallback == 'string')
			fallback = document.createTextNode(fallback);
		removeChildren(targetNode);
		targetNode.appendChild(createObject(id, FLASH_MEDIA_TYPE, data, width, height, params, fallback));
	}
	return targetNode.firstChild;
}

function loadScript(src, id) {
	var head = document.getElementsByTagName('head')[0];
	var script = createElement('script', {
		'type': 'text/javascript',
		'src': src
	});
	if(id) {
		var old = document.getElementById(id);
		if(old)
			old.parentNode.removeChild(old);
		script.id = id;
	}
	head.appendChild(script);
}

function jsonCallback(result) {
	CookieResults = result;
	// ageAppropriate is global
	var tmp = result.ageAppropriate;

	if(tmp == null)
		ageAppropriate = null;
	else if(typeof tmp == 'string')
		ageAppropriate = tmp == "true";
	else
		ageAppropriate = !!tmp;
}



function getstrings(){return dobstring +":"+ srystring +":"+ datestring +":"+ langstring +":"+ sstrings}
function resizeFlashTextDiv(flashtextdivid,flashwidth,flashheight) {document.getElementById(flashtextdivid).style.width = flashwidth + 'px';document.getElementById(flashtextdivid).style.height = flashheight + 'px';}
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
			interval:    1050, // the loop interval
			cdClass:     'countdown', // the class to apply this plugin
			granularity: 5,
			
			label:    ['s ', 'd ', 'h ', ':', ''],
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
			
			if (secs<0) {
				$(this).attr('secs', '...');
				clearInterval(vInt);
				if (refresh)
					window.location.href = window.location.href;
			} else
				$(this).attr('secs', secs);
			
		});

	}
	
	jQuery.fn.flashtext = function () {
		return this.each(function() {
			var estilo 	= $(this).attr('estilo');
			var style 	= ftm1[estilo];
			var did 	= $(this).attr('id');
			var text 	= $(this).html();
			$(this).html('');$(this).addClass('flashtext_'+estilo);
			$(this).addClass('flashtexta');
			setFlash(did, 'T'+did, mediactx + '_flash/flashtext.swf', '100%', '100%', [['movie', mediactx + '_flash/flashtext.swf'], ['base', mediactx + '_flash/'], ['allowScriptAccess', 'always'], ['wmode', 'transparent'], ['bgcolor', '#000000'], ['menu', 'false'], ['quality', 'best'], ['flashvars', 'varFlash=divid==='+did+'***fontpath==='  + fontctx + '***fontname==='+style.f+'***fontid==='+style.fi+'***fontsize==='+style.sz+'***color1==='+style.c1+'***color2==='+style.c2+'***letterspacing==='+style.ls+'***noflash==='+text+'***flashtext==='+text+'***gradientangle==='+style.a+'***blendmode===***opacity==='+style.o]], text);
		});
	}
	jQuery.flashear = function () {
		$('.flashtext').flashtext();
	};
	
	this.tooltip = function(){
		create_tooltips();
	};
})(jQuery);
function actcabe(){
document.getElementById('rpjcabeza').setAttribute("class", "heads_"+(czs[craza+''+cgenero].s+cabeza));
document.getElementById('cabeza').value=(czs[craza+''+cgenero].s+cabeza);
}
function movx(){if(czs[craza+''+cgenero].m>cabeza){cabeza++;};actcabe();}
function movc(){if(cabeza>0){cabeza--;};actcabe();}

function act_cab(){cabeza=0;craza=document.getElementById("raza").selectedIndex+1;cgenero=document.getElementById("genero").selectedIndex+1;movc(0);}

$(document).ready(function(){
	tooltip();
	$.jtabber({mainLinkTag: "#nav a",activeLinkClass: "selected",hiddenContentClass: "hiddencontent",showDefaultTab: 1,showErrors: false,effect: 'slide',effectSpeed: 'medium'});
	$.autocountdown();
	$.flashear();
	$('.mz').animate({opacity:0},'normal');
	$('.mz').mouseover(function(){$(this).animate({opacity:1},'fast');});
	$('.mz').mouseout(function(){$(this).animate({opacity:0},'normal');});
	if (Browser.ie7) addStylesheet(mediactx + 'ie7.css');
	else if (Browser.ie6) addStylesheet(mediactx + 'ie6.css');
	else if (Browser.opera) addStylesheet(mediactx + 'opera.css');
	else if (Browser.safari) addStylesheet(mediactx + 'safari.css');
});

