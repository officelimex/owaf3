
window.addEvent('domready', function() {

	prettyPrint()

	document.getElements('[data-example]').each(function(el) {
		el.addClass('simulated-example');
		Moobile.Simulator.create('iPhone', el.get('data-example'), { container: el });
	});

	document.getElements('[data-simulator-app]').each(function(el) {
		el.addClass('simulator-wrapper');
		var simulator = new Moobile.Simulator({container: el});
		simulator.setDevice(el.get('data-device') || 'iPhone5');
		simulator.setDeviceOrientation(el.get('data-orientation') || 'portrait');
		simulator.setApplication(el.get('data-simulator-app'));
	});

});