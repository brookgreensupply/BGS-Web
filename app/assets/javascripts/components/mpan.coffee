class MpanModel
  constructor: (@css_id, @mpan) ->

  get: (part) ->
    @read_mpan()
    switch part
      when 'pc' then @mpan.substr(0, 2)
      when 'mtc' then @mpan.substr(2, 3)
      when 'llfc' then @mpan.substr(5, 3)
      when 'did' then @mpan.substr(8, 2)
      when 'uid' then @mpan.substr(10, 8)
      when 'cd' then @mpan.substr(18, 3)
      else @mpan

  render: ->
    $("#{@css_id} input.mpan").remove()
    if @mpan
      $("#{@css_id} .mpan-pc").text @get('pc')
      $("#{@css_id} .mpan-mtc").text @get('mtc')
      $("#{@css_id} .mpan-llfc").text @get('llfc')
      $("#{@css_id} .mpan-did").text @get('did')
      uid_1 = @get('uid').substr(0, 4);
      uid_2 = @get('uid').substr(4, 4);
      $("#{@css_id} .mpan-uid").html "#{uid_1}&nbsp;#{uid_2}"
      $("#{@css_id} .mpan-cd").text @get('cd')
    else
      $("#{@css_id} .mpan-pc").html '<input name="pc" class="input-pc mpan" style="width: 30px;" maxlength="2"/>'
      $("#{@css_id} .mpan-mtc").html '<input name="mtc" class="input-mtc mpan" style="width: 60px;" maxlength="3"/>'
      $("#{@css_id} .mpan-llfc").html '<input name="llfc" class="input-llfc mpan" style="width: 50px;" maxlength="3"/>'
      $("#{@css_id} .mpan-did").html '<input name="did" class="input-did mpan" style="width: 30px;" maxlength="2"/>'
      $("#{@css_id} .mpan-uid").html '<input name="uid" class="input-uid mpan" style="width: 110px;" maxlength="9"/>'
      $("#{@css_id} .mpan-cd").html '<input name="llfc" class="input-cd mpan" style="width: 30px;" maxlength="3"/>'

  read_mpan: ->
    if $("#{@css_id} .input-pc").length
      @mpan = ('0000' + $("#{@css_id} .input-pc").val()).slice(-2)
      @mpan += ('0000' + $("#{@css_id} .input-mtc").val()).slice(-3)
      @mpan += ('0000' + $("#{@css_id} .input-llfc").val()).slice(-3)
      @mpan += ('0000' + $("#{@css_id} .input-did").val()).slice(-2)
      @mpan += ('00000000' + $("#{@css_id} .input-uid").val().replace(/\s+/g, '')).slice(-8)
      @mpan += ('0000' + $("#{@css_id} .input-cd").val()).slice(-3)

window.MpanModel = MpanModel
