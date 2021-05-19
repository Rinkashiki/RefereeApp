$(document).on('turbolinks:load', function(){
  $('#sidebar').toggleClass('active');
  $('#sidebarCollapse').toggleClass('active');

  $('#sidebarCollapse').on('click', function () {
    $('#sidebar').toggleClass('active');
    $('#sidebarCollapse').toggleClass('active');
  });

  $('#adminCollapse').on('click', function () {
    $('#adminSubmenu').toggleClass('show');
    $('#sidebar').toggleClass('resize');
  });

  $('#toolCollapse').on('click', function () {
    $('#toolSubmenu').toggleClass('show');
    $('#sidebar').toggleClass('resize');
  });
});