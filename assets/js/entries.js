// Journal entries open and close smoothly. Each entry is a <details>, so it works without this
// script; this only animates the body's height. The home page arrives through innerHTML after the
// passcode, so its own scripts never run: one listener on the document catches clicks on any entry.
(function () {
  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
  var DURATION = 350;
  var EASING = "cubic-bezier(0.4, 0, 0.2, 1)";

  document.addEventListener("click", function (e) {
    var head = e.target.closest && e.target.closest("summary.entry-head");
    if (!head || reduceMotion.matches || !Element.prototype.animate) return;
    var entry = head.parentNode;
    var body = entry.querySelector(".entry-body");
    if (!body) return;
    e.preventDefault();

    var closing = entry.open && !entry.classList.contains("is-closing");
    var from = entry.open ? body.getBoundingClientRect().height : 0;
    if (body._anim) body._anim.cancel();

    if (closing) {
      entry.classList.add("is-closing");
    } else {
      entry.classList.remove("is-closing");
      entry.open = true;
    }
    var to = closing ? 0 : body.scrollHeight;

    body.style.overflow = "hidden";
    body._anim = body.animate(
      [{ height: from + "px", opacity: closing ? 1 : 0.2 }, { height: to + "px", opacity: closing ? 0 : 1 }],
      { duration: DURATION, easing: EASING }
    );
    body._anim.onfinish = function () {
      body._anim = null;
      body.style.overflow = "";
      if (closing) {
        entry.open = false;
        entry.classList.remove("is-closing");
      }
    };
  });
})();
