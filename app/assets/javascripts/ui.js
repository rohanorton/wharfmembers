$(document).ready(function () {
  $("#member_over_18").click(function(e) {
    var over18el = $(e.target)
    var regEl = over18el.closest("form").find("input:submit")
    regEl.prop('disabled', !over18el.prop("checked"))
    regEl.prop('title', over18el.prop("checked") ? "" : "Must be over 18")
  })
})
