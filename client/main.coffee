Meteor.autosubscribe ->
  Meteor.subscribe "cards", Decks.findOne({slug: Session.get('deckId')})?._id
  Meteor.subscribe "decks", (Meteor.userId() if Meteor.user())
  Meteor.subscribe 'users'


Meteor.startup ->
  if Modernizr.hasEvent('mousewheel')
    $('html').addClass('mousewheel')

  window.$body = ->
    Felt.Helpers.selectorCache('$body', 'body')
  window.$center = ->
    Felt.Helpers.selectorCache('$center', '#center')
  window.$viewport = ->
    Felt.Helpers.selectorCache('$viewport', '#viewport')

  $document = $(document)
  startPositions = {}
  $document.on
    'movestart': (e)->
      return if e.finger > 1
      window.location.hash = ''
      startPositions = Felt.Helpers.bodyBgAndCenterStart()

    'move': (e)->
      return if e.finger > 1
      Felt.Helpers.moveBy
        x: e.distX,
        y: e.distY
        startPositions: startPositions

    'mousewheel wheel': (e)->
      e.preventDefault()
      e = e.originalEvent || e
      window.location.hash = ''
      x = e.wheelDeltaX || - e.deltaX || 0
      y = e.wheelDeltaY || - e.deltaY || 0
      speed = 0.4
      Felt.Helpers.moveBy
        x: x*speed
        y: y*speed

  , '#viewport'

