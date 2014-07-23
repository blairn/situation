Template.situations.json = -> 
  Deps.afterFlush(-> prettyPrint())
  JSON.stringify(Session.get('currentGeoJson'), null, 2)
  


