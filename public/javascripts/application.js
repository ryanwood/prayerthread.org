// set default
var related_users = [];

$(document).ready(function(){
  
  // $('#group_tabs').tabs();

  $("#invitation_recipient_email").autocomplete(related_users, {
    matchContains: true,
    minChars: 0,
    formatResult: function(data, i, total) {
      // return data[0].replace('&lt;', '<').replace('&gt;','>');
      var re = /&lt;(.+)&gt;/;
      var email = re.exec(data[0]);
      return email[1];
    }
  });
  
  // $('form.member').ajaxForm( 
  //   target: '#add_member_area'
  // );

});