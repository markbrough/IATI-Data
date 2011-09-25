"use strict";
/*global google Raphael*/

/**
 * SpotOverlay extends OverlayView class from the Google Maps API
 * Dependencies: Google-maps-api-v3, Raphaël	
 * Uses Maps-Markers
 * @constructor
 * @param {Array} markers, Initial array of markers. 
 * @param {Map} map, Map to put overlay on.
 * @param {obj} {callBack: func, param: {}}.
 */
function SpotOverlay(markers, map, initCallback) {
	var sov = this,
	ready = false,
	markersInternal = markers || [],
	numSpotsInternal = markersInternal.length,
	spotsInternal = [],
	mapInternal = map,
	smallestSize = 20, 
	mid = 30,
	high = 175,
	spotOutcomeMultiplier = 0.00150,
	invisibleScale = 0.00001;
	

	/**
	* Object for holding spot info.
	* @constructor
	*/
	function spot() {
		return {
			radius: high / 2,
			rDiv: {},
			marker: {},
			canvas: {},
			circle: null,
			openaidName: "",
			scaleTo: invisibleScale,
			visible: false,
			region: false
		};
	}
	
	/**
	* Return Specific Raphael Attr-obj
	* @private
	*/
	
	function getSpotAttr(region, scaleTo) {
		var regionAttr =  {
			stroke: '#eee', 
			'stroke-opacity': 0.4, 
			'stroke-width': 1.5,
			fill: '#ff0000', 
			opacity: 0.9, 
			scale: scaleTo
		},
		countryAttr = {
			stroke: '#eee', 
			'stroke-opacity': 0.4, 
			'stroke-width': 1.5,
			fill: '#365e93', 
			opacity: 0.8, 
			scale: scaleTo
		};
		if (region) {
			return regionAttr;
		} else {
			return countryAttr;
		}
	}
	
  
	/**
	* Create spots objects
	* @private
	*/
	function setupSpotsInternal() {
		for (var i = 0; i < numSpotsInternal; i = i + 1) {
			spotsInternal.push(spot());
		}
	}
	
	
	/**
	 * Create initial divs and canvases for spots.
	 * Called when spot overlay is added to map.
	 */
	SpotOverlay.prototype.onAdd = function () {
		var panes = sov.getPanes(),
		rDiv,
		canvas,
		i;
		
		for (i = 0; i < numSpotsInternal;  i = i + 1) {
			rDiv = document.createElement('DIV');
			rDiv.style.border = '0';
			rDiv.style.position = 'absolute';
			rDiv.style.overflow = 'visible';
			spotsInternal[i].rDiv = rDiv;
			panes.overlayImage.appendChild(rDiv);
			canvas = new Raphael(rDiv, high, high);
			spotsInternal[i].canvas = canvas;
		}
	};
	
	/**
	* Draws overlay.
	* Redraw when maps changes, See google.maps.OverlayView
	* Uses data from already drawn spots
	*/
	
	SpotOverlay.prototype.draw = function () {
		var i,
		overlayProjection = sov.getProjection(),
		spot,
		openaidData,
		rdiv,
		radius,
		latlng,
		center,
		left,
		top;
		
		if (!overlayProjection) { 
			return; 
		}
		
		for (i = 0; i < markersInternal.length; i = i + 1) {
			if (markersInternal[i]) {
				spot = spotsInternal[i];
				rdiv = spot.rDiv;
				radius = spot.radius;
				spot.marker = markersInternal[i];
				latlng = spot.marker.getPosition();
				center = overlayProjection.fromLatLngToDivPixel(latlng);
				left = center.x - (radius);
				top = center.y - (radius);
				
				openaidData = spot.marker.openaidData;
				spot.countryName = openaidData.countryName;
				spot.region = openaidData.region;

				rdiv.setAttribute("name", spot.countryName);
				rdiv.style.left = left + 'px';
				rdiv.style.top = top + 'px';
				if (spot.circle) {
					spot.circle.remove();
				}
				//Draw circle
				spot.circle = spot.canvas.circle(radius, radius, radius).attr(getSpotAttr(spot.region, spot.scaleTo));;
				
				if (spot.visible) {
					spot.circle.show();
				} else {
					spot.circle.hide();
				}
			}
		}
		
		if (!ready) {
			initCallback.callBack(initCallback.param.year);
			ready = true;
		}
	};
	
	/**
	* Animates spot to new size
	* Hides spot if no outcome
	*/
	function animateSpot(spot, outcome) {
		outcome = outcome / 1000000; // kr to Mkr - add to backend?
		
		//Updates marker clickable area to match spot visible area
	    function markerUpdate() {
			var wid = spot.circle.getBBox().width;
			spot.marker.setIcon(new google.maps.MarkerImage(spot.marker.mImage, 
								new google.maps.Size(wid, wid),
								new google.maps.Point(0, 0),
								new google.maps.Point(wid / 2, wid / 2),
								new google.maps.Size(wid, wid)
								));
								
			spot.marker.setShape({coord: [wid / 2, wid / 2, wid / 2], type: 'circle'});
			spot.marker.setZIndex(spot.zIndex);
			spot.marker.setVisible(true);			
	    }
	
		//TODO: Check scale when there is more outcome to test
		if (outcome > 0) {
			if (outcome < smallestSize) {
				//low outcome
				outcome = outcome + smallestSize;
			} else if (outcome > mid) {
				//High, over a half billion
				if (outcome > high*2) {
					outcome = high;
				} else {
					outcome = mid + smallestSize;
				}
			} else {
				//mid
				outcome = outcome + smallestSize;
			}
			spot.scaleTo = outcome * spotOutcomeMultiplier;
		} else {
			spot.scaleTo = invisibleScale;
		}
		
		/*if (spot.region) {
			//l(outcome + ":" + spot.scaleTo);
		}*/

	    if (spot.scaleTo === invisibleScale) {
			spot.circle.animate({scale: spot.scaleTo}, 800, function () {
				spot.circle.hide();
				spot.visible = false;	
			});	
			spot.marker.setVisible(false);
	    } else {
			spot.circle.show();
			spot.visible = true;	
			spot.circle.animate({scale: spot.scaleTo}, 500, markerUpdate);	
	    }
	    
	}
	
	/**
	* Updates spots  and marker with supplied yeardata. 
	* Visualy sort spots, smallest on top.
	*/
	SpotOverlay.prototype.updateSpotsData = function (year, yearData) {
		var spot,
			spotData,
			spotsZIndex,
			outcome,
			contributions,
			i;	
		for (i = 0; i < spotsInternal.length; i = i + 1) {
			spot = spotsInternal[i];
			if (spot) {
				if (yearData) {
					spotData = yearData[spot.countryName]; 
				}
				if (spotData) {
					outcome = spotData.payment;
					spotsZIndex = spotData.order;
					
					//TODO. More Controlled version of z-index?
					spot.zIndex = 1000 - parseInt(spotsZIndex, 10);
					spot.rDiv.style.zIndex = spot.zIndex;
					contributions = spotData.contributions;
				} else {
					outcome = 0;
					contributions = 0;
				}
				spot.marker.openaidData.currentYear = year; 
				spot.marker.openaidData.outcome = outcome; 
				spot.marker.openaidData.contributions = contributions; 
				animateSpot(spot, outcome);	
			}		
		}
	};
	
	/**
	 * Called when overlay is removed from map.
	 * Removes references to objects.
	 */
	SpotOverlay.prototype.onRemove = function () {
		var spot,
		i;
		for (i = 0; i < this.markersInternal.length; i = i + 1) {
			spot = spotsInternal[i];
			// Check if spot exists before continuing
			if (!spot) {
				continue;
			}
			// Remove spot circle
			if (spot.circle) {
				spot.circle.remove();
				spot.circle = null;
			}
			//TODO: remove other stuff.
		}
	};

	setupSpotsInternal();
	sov.setMap(mapInternal);
}
SpotOverlay.prototype = new google.maps.OverlayView();


/* An InfoBox is like an info window, but it displays
 * under the marker, opens quicker, and has flexible styling.
 * @param {Map} Map 
 * @param {Marker} Marker has alls the information about latlng and openaidData.
 * @param {Obj} htlmData cusotm data for infobox html
 */
function InfoBox(map, marker, htmlData) {
	google.maps.OverlayView.call(this);
	this.map_ = map;
	this.marker = marker;
	this.htmlData = htmlData;
	this.latlng_ = this.marker.getPosition();
	this.offsetVertical_ = -17;
	this.offsetHorizontal_ = -9;
	this.height_ = 66;
	this.width_ = 188;
	
	var me = this;
	/*this.boundsChangedListener_ =
		google.maps.event.addListener(this.map_, "bounds_changed", function() {
	});*/
		
	this.setMap(this.map_);
}
 
/* InfoBox extends OverlayView class from the Google Maps API
 */
InfoBox.prototype = new google.maps.OverlayView();
 
/* Removes the DIV representing this InfoBox
 */
InfoBox.prototype.remove = function() {
	if (this.div_) {
		this.div_.parentNode.removeChild(this.div_);
		this.div_ = null;
	}
};
 
/* Redraw the InfoWindow based on the current marker position
 */
InfoBox.prototype.draw = function() {
	// Creates the element if it doesn't exist already.
	this.createElement();
	if (!this.div_) return;
	
	// Calculate the DIV coordinates of two opposite corners of our bounds to
	// get the size and position of our Bar
	var pixPosition = this.getProjection().fromLatLngToDivPixel(this.latlng_);
	if (!pixPosition) return;
	
	// Now position our DIV based on the DIV coordinates of our bounds
	this.div_.style.left = (pixPosition.x + this.offsetHorizontal_) + "px";
	this.div_.style.top = (pixPosition.y + this.offsetVertical_) + "px";
	this.div_.style.display = 'block';
};
 
/* Creates the DIV representing this InfoBox in the floatPane.  If the panes
 * object, retrieved by calling getPanes, is null, remove the element from the
 * DOM.  If the div exists, but its parent is not the floatPane, move the div
 * to the new pane.
 * Called from within draw.  Alternatively, this can be called specifically on
 * a panes_changed event.
 */
InfoBox.prototype.createElement = function() {
	var panes = this.getPanes(),
	infoBoxDiv = this.div_,
	pointer,
	contentBody,
	closeButton,
	countryLink,
	dataList,
	openaidData = this.marker.openaidData, 
	htmlData = this.htmlData, 
	computedOutcome = 0;
	
	function replaceDot(value, replace) {
		var str = value.toString();
		return str.replace('.', replace);
	};
	
	function removeInfoBox(ib) {
		return function() {
			ib.setMap(null);
		};
	}
	
	if (!infoBoxDiv) {
		// This does not handle changing panes.  You can set the map to be null and
		// then reset the map to move the div.
		
		infoBoxDiv = this.div_ = document.createElement("div");
		infoBoxDiv.id = 'infoBox';
		pointer = document.createElement("div");
		pointer.className = 'pointer';
		contentBody = document.createElement("div");
		contentBody.className = 'body';
		closeButton = document.createElement("a");
		closeButton.setAttribute('href', '#');
		closeButton.innerHTML = htmlData.locales.close;
		closeButton.className = 'close';
		countryLink = document.createElement("a");
		countryLink.setAttribute('href', '?countryregion=' + openaidData.countryId + htmlData.coutryLinkPath);
		countryLink.innerHTML = openaidData.countryName;
		dataList = document.createElement("ul");
		
		// check if outcome is less then 1 million, list with 2 decimals.
		if (Math.round(openaidData.outcome / 1000000) > 0) {
			computedOutcome = Math.round(openaidData.outcome / 1000000);
		} else { 
			computedOutcome = Math.round((openaidData.outcome / 1000000)*100)/100;
		}
		
		dataList.innerHTML  = '<li>' + openaidData.contributions + ' ' + htmlData.locales.contributions + '</li><li>' + computedOutcome +
								' ' + htmlData.locales.million_kr + '</li>'
		
		contentBody.appendChild(closeButton);
		contentBody.appendChild(countryLink);
		contentBody.appendChild(dataList);
		infoBoxDiv.appendChild(pointer);
		infoBoxDiv.appendChild(contentBody);
		
		google.maps.event.addDomListenerOnce(closeButton, 'click', removeInfoBox(this));
		
		panes.floatPane.appendChild(infoBoxDiv);

	} else if (infoBoxDiv.parentNode != panes.floatPane) {
		// The panes have changed.  Move the div.
		infoBoxDiv.parentNode.removeChild(infoBoxDiv);
		panes.floatPane.appendChild(infoBoxDiv);
	}
}
