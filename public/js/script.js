// Rabble name validation.
function validateRabbleName () {
  var validateName = $('#validate_name');
  $('#name').keyup(function () {
    var t = this;
    if (this.value != this.lastValue) {
      if (this.timer) clearTimeout(this.timer);
      validateName.html('<img src="img/ajax_spinner.gif" height="16" width="16" /> checking availability...');

      this.timer = setTimeout(function () {
        $.ajax({
          url: 'a/validate_name',
          data: 'name=' + t.value,
          type: 'post',
          success: function (j) {
            validateName.html(j.msg);
            if (j.unlock) {
              $('#submit_button').removeClass('disabled');
              validateName.addClass('success');
              validateName.removeClass('failure');
            } else {
              $('#submit_button').addClass('disabled');
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


// Deathclock updates.
function updateClocks (slug) {
  var deathClock = $("span#death_clock");
  var createdAgo = $("span#created_ago");
  $.post("/a/clock_update", { slug: slug },
    function(j) {
      deathClock.html(j.death);
      createdAgo.html(j.created);
  });
}


// Deathclock update loop.
function updateClocksLoop () {
  var slug = $('h2#title').data("slug");
  updateClocks(slug);
  var refreshId = setInterval(function() {
    updateClocks(slug);
  }, 5000);
}


// Dismissable welcome block.
function dismissWelcome () {
  $target = $('div#welcome_container');
  $('a#welcome_dismiss').click(function () {
    $target.fadeOut(180, function() {
      $target.remove();
    });
  });
}


// Looped on pageload
$(document).ready(function() {
  var page = $('div#page_wrapper').data("page");

  if (page == 'home') {
    validateRabbleName();

  } else if (page == 'rabble') {
    updateClocksLoop();
    dismissWelcome();
  }
});