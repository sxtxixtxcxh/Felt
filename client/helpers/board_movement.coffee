Felt.Helpers.slide = (direction, speed)->
  return if $body().hasClass('transition')
  speed ||= 1
  dist = 240 * speed
  position = Felt.Helpers.bodyBgAndCenterStart()
  distX = distY = 0
  switch direction
    when 'left'
      distX += dist
    when 'right'
      distX -= dist
    when 'up'
      distY += dist
    when 'down'
      distY -= dist

  Felt.Helpers.moveBy
    x: distX
    y: distY
    slide: true

Felt.Helpers.transitionBoard = ()->
  $body().addClass('transition')
  $center().addClass('transition')
  setTimeout(->
    $body().removeClass('transition')
    $center().removeClass('transition')
  , 300)

Felt.Helpers.moveBy = (options)->
  distX = options.x
  distY = options.y
  startPositions = options.startPositions || Felt.Helpers.bodyBgAndCenterStart()
  slide = options.slide

  centerEndPosition =
    x: Math.floor(startPositions.center.x + distX)
    y: Math.floor(startPositions.center.y + distY)

  bgEndPosition =
    x: Math.floor(startPositions.bg.x + distX)
    y: Math.floor(startPositions.bg.y + distY)

  Felt.Helpers.setBoardPosition( centerEndPosition, bgEndPosition, slide)

Felt.Helpers.setBoardPosition = (center, bg, slide)->
  Felt.Helpers.transitionBoard() if slide
  $center().css
    left: center.x
    top: center.y
  $body().css 'backgroundPosition', "#{bg.x}px #{bg.y}px"
  clearTimeout Felt.setPermalinkTimeout
  Felt.setPermalinkTimeout = setTimeout(Felt.Helpers.setPermalink, 300)
  true

Felt.Helpers.setPermalink = ->
  relativeX = $viewport().width()/2 - $center().position().left
  relativeY = - ($viewport().height()/2 - $center().position().top)
  $('#viewport-permalink').attr 'href', "#x:#{relativeX};y:#{relativeY}"

Felt.Helpers.zoom = (x)->
  Session.set('scale', x)
  $center().transition {
    scale: "#{x}"
  }, 300, 'in'

Felt.Helpers.bodyBgAndCenterStart = ()->
  bgPos = $body().css('backgroundPosition').split(' ')
  bgX = parseInt bgPos[0], 10
  bgY = parseInt bgPos[1], 10
  centerPosition = $center().position()
  centerStartX = centerPosition.left
  centerStartY = centerPosition.top

  return {
    center:
      x: centerStartX
      y: centerStartY
    bg:
      x: bgX
      y: bgY
  }

Felt.Helpers.centerBoard = ->
  coords = @readCoords(Felt.coordHash)
  if coords
    position = Felt.Helpers.bodyBgAndCenterStart()
    width = $viewport().width()
    height = $viewport().height()
    position.center.x = width/2 - coords.x
    position.center.y = height/2 + coords.y
    position.bg.x =  - coords.x if coords.x
    position.bg.y = coords.y
    center=
      x: position.center.x
      y: position.center.y
    bg=
      x: position.bg.x
      y: position.bg.y
    return Felt.Helpers.setBoardPosition center, bg, true

  return Felt.Helpers.setBoardPosition {x:'50%', y:'50%'}, {x:0, y:0}

Felt.Helpers.readCoords = (coordHash)->
  coords = coordHash?.replace(/#/,'')
  if coords?.match(/x:-*\d+|y:-*\d+/)
    coords = coords.split(';')
    viewPort = {}
    _.map coords, (item)->
      coord = item.split(':')
      viewPort[coord[0]] = parseFloat(coord[1])
    coords = viewPort
  else if coords?.match(/^post:.*/)
    id = coords?.replace('post:', '')
    post = Posts.findOne(id)
    return false unless post
    coords =
      x: post.position.x + 120
      y: - post.position.y - $("#post-#{id}").height()/2
  else
    coords = false
  return coords

