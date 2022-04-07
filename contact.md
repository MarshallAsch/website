---
layout: page
title: Contact
subtitle: How you can get in touch with me
js:
  - "/assets/js/modal.js"
css:
  - "/assets/css/modal.css"
---

So you are interested in chatting with me?

Perfect, I can be found all over the Internet and I would love to talk about any of my published papers, open source contributions, software development, or anything really.


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