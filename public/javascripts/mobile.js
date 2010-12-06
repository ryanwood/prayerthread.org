$(function() {
 $('.command_bar select#view').change(function(){
   $(this).closest('form').get(0).submit();
 });
});