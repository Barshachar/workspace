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
});
