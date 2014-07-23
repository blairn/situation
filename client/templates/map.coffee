addLayer = (layer, layerType) ->
 console.log('add', layerType, JSON.stringify(layer.toGeoJSON()))
  
updateLayer = (layer) ->
 console.log('update', JSON.stringify(layer.toGeoJSON()))

deleteLayer = (layer) ->
 console.log('delete', JSON.stringify(layer.toGeoJSON()))

Template.map.rendered = ->
  L.Icon.Default.imagePath = '/images';
  map = L.map('map')
  L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
      maxZoom: 18,
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
          '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
          'Imagery © <a href="http://mapbox.com">Mapbox</a>',
      id: 'examples.map-i86knfo3'
  }).addTo(map)
  
#  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
#    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
#  }).addTo(map);
  
  map.locate({setView: true, maxZoom: 16})
  # Initialise the FeatureGroup to store editable layers
  editableItems = new L.FeatureGroup()
  map.addLayer(editableItems)
  # Initialise the draw control and pass it the FeatureGroup of editable layers
  drawControl = new L.Control.Draw({draw:{circle:false},edit:{featureGroup: editableItems}})
  map.addControl(drawControl)
  map.on('draw:created', (e) ->
    type = e.layerType
    layer = e.layer
    addLayer(layer, e.layerType)
    editableItems.addLayer(layer)
    Session.set('currentGeoJson',editableItems.toGeoJSON()); 
    console.log(JSON.stringify(editableItems.toGeoJSON()));
  )
  map.on('draw:edited', (e) -> 
    layers = e.layers
    layers.eachLayer((layer) ->
      updateLayer(layer)
    )
    Session.set('currentGeoJson',editableItems.toGeoJSON()); 
  )
  map.on('draw:deleted', (e) -> 
    layers = e.layers
    layers.eachLayer((layer) ->
      deleteLayer(layer)
    )
    Session.set('currentGeoJson',editableItems.toGeoJSON()); 
  )