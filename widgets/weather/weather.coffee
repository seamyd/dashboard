class Dashing.Weather extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    @set 'title', @titleDecorator()

    console.log data
    if data.climacon
      console.log data
      $(@node).find('i.climacon')
        .attr('class', "climacon icon-background #{data.climacon}")

  titleDecorator: ->
    @get('title') or _.str.humanize @get('id')
