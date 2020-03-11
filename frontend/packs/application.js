import "../../node_modules/bootstrap/dist/css/bootstrap.css";
import "../../node_modules/bootstrap/dist/js/bootstrap";

import "./application.pcss";

require("@rails/ujs").start();
require("chartkick");
require("chart.js");
require("jquery");

$(document).ready(function ready() {
  $(".hide_percentage").on("click", function Hidepercentage() {
    $(".percentage").addClass("d-none");
    $(".count").removeClass("d-none");
  });
  $(".hide_count").on("click", function Hidecount() {
    $(".percentage").removeClass("d-none");
    $(".count").addClass("d-none");
  });
});
