// set default
var related_users = [];

$(document).ready(function(){
  
  // $('#group_tabs').tabs();

  $("#invitation_recipient_email").autocomplete(related_users, {
    matchContains: true,
    minChars: 1,
    formatResult: function(data, i, total) {
      // return data[0].replace('&lt;', '<').replace('&gt;','>');
      var re = /\(([^ ]+)\)$/;
      var email = re.exec(data[0]);
      return email[1];
    }
  });
  
  $('a.intercede, a.nudge').click( function() {
    var li = $(this).parent();
    li.empty().html('<img src="/images/loading.gif" />');
    $.get(this.href, function(data){ li.html(data); });
    return false;
  });
  
  $('ul#views a.print').click( function() {
    var options_list = 'ul#' + this.id + "_options";
    $('ul.print_options').hide('blind');
    $(options_list).show('blind');
    return false;
  });

  $('.nudge_link').click(function(event){
    event.preventDefault();
    $('.nudge_box').hide();
    $('#' + this.id + '_box').show('blind');
  });
  
  $('a.nudge_close_link').click(function(event){
    event.preventDefault();
    $(this).parent().parent().hide('blind');
  });
  
  $("img[title]").tooltip();

});

jQuery.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader("Accept", "text/javascript") }
})

