class Dashing.Project extends Dashing.Widget
  onData: (data) ->
    @set 'title', @titleDecorator()

    @updateCurrentStatus(data.jenkins)
    @updateBrokenBy(data.jenkins)
    @updateBuildStatus(data.jenkins)

  titleDecorator: ->
    @get('title') or _.str.humanize @get('id')

  updateCurrentStatus: (data) ->
    if data.latestResult != data.result and ! data.building
      @transitionState(data.latestResult, data.result)
    else
    $(@node).removeClass('failed unknown passed')
    $(@node).addClass(@state_class(data.latestResult))

  updateBrokenBy: (data) ->
    if _.indexOf(['FAILURE', 'ABORTED'], data.latestResult) isnt -1
      if data.culprits.length is 1
        txt = "build broken by #{data.culprits[0]}"
      else if data.culprits.length > 1
        txt = "committers since build broke:<br />#{data.culprits.join(', ')}"
      else
        txt = 'build broken by unknown source'

    $(@node).find('.culprits').html(txt)

  updateBuildStatus: (data) ->
    if data.building
      $(@node).addClass('building')
    else
      $(@node).removeClass('building')

  state_class: (state) ->
    switch state
      when 'SUCCESS'  then 'passed'
      else 'failed'


  transitionState: (current_state, new_state) ->
    $(@node)
      .toggleClass(@state_class(current_state), 250)
      .toggleClass(@state_class(new_state), 250)
#
