Template.cards.helpers
  cards: ->
    Cards.find()

Template.card.helpers

Template.card.rendered = ->
  console.log this
  $card = $(this.find('.card'))
  Cork.Helpers.centerBoard() if window.location.hash is "#card:#{this.data._id}"
  id = this.data._id
  $card.css('opacity', 1) unless Meteor.user()

  return unless Meteor.user()

  $card.css('opacity', 1)

  return if this.moveBound

  posX = this.data.position.x
  posY = this.data.position.y

  $card.on
    'movestart': (e)->
      e.stopPropagation()
      $card.addClass('dragging')
      posX = $card.position().left
      posY = $card.position().top
    'moveend': (e)->
      e.stopPropagation()
      $card.removeClass('dragging')
      posX = $card.position().left
      posY = $card.position().top
      scale = 1/(Session.get('scale') or 1)
      Card.update id,
        $set:
          position:
            x: Math.floor(posX*scale)
            y: Math.floor(posY*scale)
    'move': (e)->
      e.stopPropagation()
      scale = 1/(Session.get('scale') or 1)
      $card.css
        left: Math.floor((posX*scale + e.distX*scale))
        top: Math.floor((posY*scale + e.distY*scale))

  this.moveBound = true
