$('#quote_address').on 'change', ->
  address = $('#quote_address').val()
  index = window.addresses.indexOf(address)
  $('#quote_mpan').val(window.mpans[index]) if index >= 0
  $('#quote_mprn').val(window.mprns[index]) if index >= 0
  $('.show-on-select-address').removeClass('hidden')
  if index >= 0
    window.current_mpan = new MpanModel('#quote_mpan_box', window.mpans[index])
    window.current_mpan.render()
  else
    window.current_mpan = new MpanModel('#quote_mpan_box')
    window.current_mpan.render()

$('form#new_quote').on 'submit', (e) ->
  $('input#quote_mpan').val(current_mpan.get())
