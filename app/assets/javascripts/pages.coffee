# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('input#search_city').autocomplete
    source: $('input#search_city').data('autocomplete-source')

  $('input#search').autocomplete
    source: $('input#search').data('autocomplete-source')
