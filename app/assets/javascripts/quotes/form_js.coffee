$('#quote_address').on 'change', () ->
  address = $('#quote_address').val()
  index = window.addresses.indexOf(address)
  $('#quote_mpan').val(window.mpans[index]) if index >= 0
  $('#quote_mprn').val(window.mprns[index]) if index >= 0
  $('.show-on-select-address').removeClass('hidden')
