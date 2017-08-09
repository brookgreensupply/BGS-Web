$('#help_search').submit (event) ->
  $('#search_results .size-h4').html('Searching...')

$('#search_button').click (event) ->
  $('form#help_search').submit()

