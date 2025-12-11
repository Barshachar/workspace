// script.js

// Burger Menu Toggle
const burger = document.getElementById('burger-menu');
const navLinks = document.getElementById('nav-links');

burger.addEventListener('click', () => {
  navLinks.classList.toggle('expanded');
});

// Back to Top Button
const backToTopBtn = document.getElementById('backToTopBtn');

// Show/hide backToTopBtn on scroll
window.onscroll = function() {
  if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
    backToTopBtn.style.display = "block";
  } else {
    backToTopBtn.style.display = "none";
  }

  // Fade-in on scroll for elements with .fade-in-on-scroll
  document.querySelectorAll('.fade-in-on-scroll').forEach(elem => {
    const rect = elem.getBoundingClientRect();
    if(rect.top < window.innerHeight - 100) {
      elem.style.opacity = 1;
      elem.style.transform = "translateY(0)";
      elem.style.transition = "opacity 0.8s ease-out, transform 0.8s ease-out";
    }
  });
};

// Scroll to top smoothly
backToTopBtn.addEventListener('click', () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
});

// Trigger fade-in on load for .fade-in-on-load
window.addEventListener('load', () => {
  document.querySelectorAll('.fade-in-on-load').forEach(elem => {
    // they fade in automatically by CSS keyframes
  });

  // Analytics: track CTA clicks
  const ctaButtons = document.querySelectorAll('.btn-cta');
  if (ctaButtons.length) {
    ctaButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        const label = btn.textContent.trim() || btn.getAttribute('aria-label') || 'CTA Click';
        const href = btn.getAttribute('href') || 'button';
        const trackingPayload = {
          event: 'cta_click',
          cta_text: label,
          cta_href: href
        };

        window.dataLayer = window.dataLayer || [];
        window.dataLayer.push(trackingPayload);

        if (typeof gtag === 'function') {
          gtag('event', 'cta_click', {
            event_category: 'engagement',
            event_label: label,
            event_action: href
          });
        }
      });
    });
  }

  // Analytics: track form submissions
  const trackedForms = document.querySelectorAll('form.styled-form');
  if (trackedForms.length) {
    trackedForms.forEach(form => {
      form.addEventListener('submit', () => {
        const formLabel = form.getAttribute('name') || form.getAttribute('id') || form.getAttribute('action') || 'Styled Form';
        const trackingPayload = {
          event: 'lead_form_submit',
          form_name: formLabel
        };

        window.dataLayer = window.dataLayer || [];
        window.dataLayer.push(trackingPayload);

        if (typeof gtag === 'function') {
          gtag('event', 'lead_form_submit', {
            event_category: 'lead',
            event_label: formLabel
          });
        }
      });
    });
  }
});
