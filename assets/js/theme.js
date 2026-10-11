// Light/dark toggle. With no saved choice the site follows the system
// setting (handled in CSS); clicking saves an explicit choice.
(function () {
  var root = document.documentElement;
  var button = document.querySelector(".theme-toggle");
  if (!button) return;
  var media = window.matchMedia("(prefers-color-scheme: dark)");

  function current() {
    return root.getAttribute("data-theme") || (media.matches ? "dark" : "light");
  }

  function label() {
    var next = current() === "dark" ? "light" : "dark";
    button.setAttribute("aria-label", "Switch to " + next + " theme");
  }

  var fadeTimer;

  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

  function apply(next) {
    root.setAttribute("data-theme", next);
    try { localStorage.setItem("theme", next); } catch (e) {}
    label();
  }

  button.addEventListener("click", function () {
    var next = current() === "dark" ? "light" : "dark";
    if (reduceMotion.matches) return apply(next);
    // Where supported, crossfade the whole page between the two themes, the
    // same way in both directions. Elsewhere, fall back to fading colors.
    if (document.startViewTransition) {
      document.startViewTransition(function () { apply(next); });
      return;
    }
    root.classList.add("theme-transitioning");
    clearTimeout(fadeTimer);
    fadeTimer = setTimeout(function () {
      root.classList.remove("theme-transitioning");
    }, 1000);
    apply(next);
  });

  if (media.addEventListener) media.addEventListener("change", label);
  label();
})();
