$('#quote_address').on 'change', ->
  address = $('#quote_address').val()
  index = window.addresses.indexOf(address)
  if index >= 0
    $('#quote_mpan').val(window.mpans[index])
    $('#quote_mprn').val(window.mprns[index])
  else
    $('#quote_mpan').val('')
    $('#quote_mprn').val('')
  $('.show-on-select-address').removeClass('hidden')
  if index >= 0
    window.current_mpan = new MpanModel('#quote_mpan_box', window.mpans[index])
    window.current_mpan.render()
  else
    window.current_mpan = new MpanModel('#quote_mpan_box')
    window.current_mpan.render()

$('form#new_quote').on 'submit', (e) ->
  $('input#quote_mpan').val(window.current_mpan.get()) if window.current_mpan
