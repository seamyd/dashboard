class Dashing.Weather extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    @set 'temp', data.temp
    @set 'title', @titleDecorator()

    if data.climacon
      $(@node).find('i.climacon.icon-weather')
        .attr('class', "climacon icon-weather #{data.climacon}")

  titleDecorator: ->
    @get('title') or _.str.humanize @get('id')
