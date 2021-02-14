
document.addEventListener("DOMContentLoaded", function() {
  var navbar = document.querySelector("#sidebar-left");
  var burger = document.querySelector(".burger");
  burger.addEventListener("click", toggleBurger);
  function toggleBurger() {
    navbar.classList.toggle("sidebar-left-hide");
  }
});
