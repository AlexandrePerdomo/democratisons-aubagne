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

  $("img[data-enlargable]")
    .addClass("img-enlargable")
    .click(function openModal() {
      const src = $(this).attr("src");
      let modal;
      function removeModal() {
        modal.remove();
        $("body").off("keyup.modal-close");
      }
      modal = $("<div>")
        .css({
          background: `RGBA(0,0,0,.5) url(${src}) no-repeat center`,
          backgroundSize: "contain",
          width: "100%",
          height: "100%",
          position: "fixed",
          zIndex: "10000",
          top: "0",
          left: "0",
          cursor: "zoom-out"
        })
        .click(function handleModalClose() {
          removeModal();
        })
        .appendTo("body");
      $("body").on("keyup.modal-close", function escapeModal(e) {
        if (e.key === "Escape") {
          removeModal();
        }
      });
    });
});
