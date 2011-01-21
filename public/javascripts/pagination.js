$(function() {
  $(".pagination a").live("click", function() {
      // $(".pagination").html('<img src="/images/spinner.gif">');
      //$("#twits_list").html('<img src="/images/spinner.gif" class="spinner">');
      $(".pagination").html('<div class="spinner"><img src="/images/spinner.gif"></div>');
      // .parent()
      $.get(this.href, null, null, "script");
      // почемуто запрашивает как HTML
      // $('#twits_list').load(this.href)
      return false;
  });
});
