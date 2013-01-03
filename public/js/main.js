// Rabble name validation.
function validateRabbleName () {
  var validateName = $('#validation');
  $('#name').keyup(function () {
    var t = this;
    if (this.value != this.lastValue) {
      if (this.timer) clearTimeout(this.timer);

      validateName.html('<img src="/img/icons/loading.gif" height="16" width="16" />');

      this.timer = setTimeout(function () {
        $.ajax({
          url: '/a/valid',
          data: 'name=' + t.value,
          type: 'post',
          success: function (j) {
            validateName.html(j.msg);
            if (j.unlock) {

              $('#get-started-button').removeClass('disabled');
              $('#get-started-button').removeAttr('disabled');

              validateName.addClass('success');
              validateName.removeClass('failure');

            } else {

              $('#get-started-button').addClass('disabled');
              $('#get-started-button').attr('disabled', 'disabled');

              validateName.addClass('failure');
              validateName.removeClass('success');
            }
          }
        });
      }, 200);

      this.lastValue = this.value;
    }
  });
}


function kill (slug) {
  $('a#kill').click(function (event) {
    event.preventDefault();

    var session = $('a#kill').data("session");

    var params = { session: session, rabble: slug };

    $.post("/a/kill", params, function(j) {
      if (j.failed) {
        $('a#kill').remove();
      }

      if (j.penalty) {
        $('#penalty').html('-' + j.penalty);
        $('#penalty').stop(true, false).fadeIn('fast');
        $('#penalty').fadeOut('fast');
      }
    });
  });
}


function updateClocks (slug) {
  var ttl = $("span#ttl-duration");
  $.post("/a/ttl", { rabble: slug },
    function(j) {
      ttl.html(j.ttl);
  });
}


function updateClocksLoop (slug) {
  updateClocks(slug);
  var refreshId = setInterval(function() {
    updateClocks(slug);
  }, 3000);
}


$(document).ready(function() {

  if ($('div.get-started').length) {
    validateRabbleName();

  } else if ($('div.rabble').length) {

    var slug = $('div.rabble').data('rabble');

    kill(slug);
    updateClocksLoop(slug);
  }
});