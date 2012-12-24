Template.viewport.helpers
  showTable: ->
    Session.get('showTable')

Template.viewport.rendered = ->
  Felt.Helpers.selectorCache('$viewport', '#viewport', true)
  Felt.Helpers.selectorCache('$center', '#center', true)
