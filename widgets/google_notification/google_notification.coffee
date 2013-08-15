class Dashing.GoogleNotification extends Dashing.Widget

  ready: ->
    console.log $(@node).find('p.text').html()

  onData: (data) =>	
    if data["events"] is ""
      $('body').css 'margin-top', "-#{$(@node).parent('li').height() + 10}px"
    else
      $('body').css 'margin-top', "0px"
      