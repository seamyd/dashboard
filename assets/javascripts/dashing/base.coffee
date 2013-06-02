class Dashing.BaseWidget extends Dashing.Widget

  fadeIcon: =>
    @icon = $(@node).next('i')
    currKlass = @getCurrentImgClass()
    newKlass = @getNewImgClass(currKlass)
    img = $(@node).data('icon')
    imgAlt = $(@node).data('icon-alt')


    return unless @icon? and currKlass? and img? and imgAlt?

    $(@icon).fadeOut 200, =>
      $(@icon)
        .removeClass("icon-#{currKlass}")
        .addClass("icon-#{newKlass}")
        .fadeIn(200)

  getNewImgClass: (klass) ->
    if klass is $(@node).data('icon')
      $(@node).data('icon-alt')
    else
      $(@node).data('icon')

  getCurrentImgClass: ->
    klasses = $(@icon).attr('class').split(' ').filter (x) ->
      x isnt 'icon-background' and x.match(/icon-/)
    klasses[0].replace('icon-', '')
