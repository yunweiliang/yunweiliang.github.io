// Opens invite-only pages. The page holds an encrypted payload (written by
// tools/research.rb); the invite code decrypts it here in the browser.
// A code that worked is remembered so the other papers open directly.
(function () {
  var root = document.querySelector("[data-locked]");
  var payloadEl = document.getElementById("locked-payload");
  if (!root || !payloadEl) return;

  var form = root.querySelector(".unlock-form");
  var input = form.querySelector("input");
  var button = form.querySelector("button");
  var error = form.querySelector(".unlock-error");
  var content = root.querySelector(".locked-content");
  var STORAGE_KEY = "research-code";

  // Must match normalize() in tools/research.rb.
  function normalize(code) {
    return code.trim().toLowerCase().split(/\s+/).join(" ");
  }

  function bytes(base64) {
    return Uint8Array.from(atob(base64), function (c) { return c.charCodeAt(0); });
  }

  function decrypt(code) {
    var payload = JSON.parse(payloadEl.textContent);
    return crypto.subtle
      .importKey("raw", new TextEncoder().encode(code), "PBKDF2", false, ["deriveKey"])
      .then(function (base) {
        return crypto.subtle.deriveKey(
          { name: "PBKDF2", salt: bytes(payload.salt), iterations: payload.iterations, hash: "SHA-256" },
          base,
          { name: "AES-GCM", length: 256 },
          false,
          ["decrypt"]
        );
      })
      .then(function (key) {
        return crypto.subtle.decrypt({ name: "AES-GCM", iv: bytes(payload.iv) }, key, bytes(payload.data));
      })
      .then(function (plain) {
        return JSON.parse(new TextDecoder().decode(plain));
      });
  }

  function show(doc, moveFocus) {
    content.innerHTML = doc.html;
    content.hidden = false;
    form.hidden = true;
    document.title = doc.title + " · " + root.getAttribute("data-site-title");
    var heading = content.querySelector("h1");
    if (moveFocus && heading) heading.focus();
  }

  function remember(code) {
    try { localStorage.setItem(STORAGE_KEY, code); } catch (e) {}
  }

  form.addEventListener("submit", function (event) {
    event.preventDefault();
    var code = normalize(input.value);
    if (!code) return;
    button.disabled = true;
    error.textContent = "";
    decrypt(code)
      .then(function (doc) {
        remember(code);
        show(doc, true);
      })
      .catch(function () {
        error.textContent = "That code didn't work. Check it and try again.";
        input.select();
      })
      .then(function () {
        button.disabled = false;
      });
  });

  var saved = null;
  try { saved = localStorage.getItem(STORAGE_KEY); } catch (e) {}
  if (saved) {
    decrypt(saved).then(function (doc) { show(doc, false); }, function () {});
  }
})();
