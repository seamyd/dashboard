class Dashing.Number extends Dashing.BaseWidget
  onData: (data) ->
    @set 'number', @getNumber() ? ''
    @fadeIcon() if @stateChange()

    if @noticeNumber is 0 and @warningNumber is 0
      @fadeClass()
    else if @warningNumber > 0
      @fadeClass(@warningClass) if @currentClass() isnt @warningClass
    else
      @fadeClass(@noticeClass) if @currentClass() isnt @noticeClass

  getNumber: ->
    if @warningNumber > 0
      @warningNumber
    else if @noticeNumber > 0
      @noticeNumber
    else
      null

  fadeClass: (newClass = null) ->
    if newClass
      $(@node).switchClass(@currentClass(), newClass, 1000)
    else
      $(@node).fadeOut 1000, => $(@node).removeClass(@currentClass()).fadeIn(0)

  stateChange: ->
    if ! @currentClass()?
      true if @getNumber() > 0
    else if ! @getNumber()?
      true
    else
      false

  currentClass: ->
    klass = $(@node).attr('class').split(' ').filter (x) ->
        x.match(/status-(notice|warning)/)
    klass[0] or null

  noticeNumber: @get('noticeNumber')
  warningNumber: @get('warningNumber')

  noticeClass: 'status-notice'
  warningClass: 'status-warning'
