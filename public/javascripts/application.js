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
  
  $('.intercession a.intercede').click( function() {
    var li = $(this).parent();
    li.empty().html('<img src="/images/loading.gif" />');
    $.get(this.href, function(data){ li.html(data); });
    return false;
  });
  
  // $('form.member').ajaxForm( 
  //   target: '#add_member_area'
  // );

});

jQuery.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader("Accept", "text/javascript") }
})