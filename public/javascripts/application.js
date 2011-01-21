// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function($) {
    $("#new_twit_user").live('submit',function() {
        $("#loading").html('<img src="/images/spinner.gif">');
        $("#twit_user_submit").attr('disabled','disabled');
    })
});