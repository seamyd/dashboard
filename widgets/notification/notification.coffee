class Dashing.Notification extends Dashing.Widget

  ready: ->
    if $(@node).find('p.text').html() is ''
      window.grid.remove_widget $(@node).parent('li')
