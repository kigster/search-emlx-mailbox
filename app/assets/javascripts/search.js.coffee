# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "mouseover", ".email-summary td", (e) ->
  e.preventDefault()
  parent = $(e.target).closest(".email-summary")
  email_id = parent.data('email-id')
  $.ajax
      url: "/emails/#{email_id}"
      type: 'GET'
      dataType: 'script'




