---
layout: page
title: Contact
subtitle: How you can get in touch with me
js:
  - "/assets/js/modal.js"
css:
  - "/assets/css/modal.css"
---

You can find me on any of the platforms listed below if you would like to contact me.<br>
I would be happy to hear from you :)

### talk to me

I check my email accounts most often. You can encrypt secure communications to me using my PGP public key.


{% include contact-links.html %}


<!-- Trigger/Open The Modal -->
<button id="pgp_button" class="modal-button">
	<span class="fa-stack fa-lg" aria-hidden="true">
        <i class="fas fa-circle fa-stack-2x"></i>
        <i class="fas fa-key fa-stack-1x fa-inverse"></i>
      </span>
      PGP key
  </button>

<!-- The Modal -->
<div id="pgp_modal" class="modal">

  <!-- Modal content -->
  <div class="modal-content">
    <span class="close">&times;</span>
    <h2>PGP key</h2>
    <br />

    <pre>
{% include marshallasch-pubkey.asc %}
	</pre>
  </div>

</div>