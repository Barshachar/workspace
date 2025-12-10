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

// ROI Calculator
const roiForm = document.getElementById('roiForm');
const roiOutput = document.getElementById('roiOutput');

if (roiForm && roiOutput) {
  const resultNumber = roiOutput.querySelector('.result-number');
  const tagline = roiOutput.querySelector('.tagline');
  const pill = roiOutput.querySelector('.pill');

  const formatMoney = (value) => new Intl.NumberFormat('he-IL', { maximumFractionDigits: 0 }).format(value);

  const calculate = () => {
    const sessions = parseFloat(roiForm.sessions.value) || 0;
    const price = parseFloat(roiForm.price.value) || 0;
    const consumption = parseFloat(roiForm.consumption.value) || 0;
    const occupancy = Math.min(Math.max(parseFloat(roiForm.occupancy.value) || 0, 0), 100) / 100;
    const cost = parseFloat(roiForm.cost.value) || 0;

    const gross = sessions * price * consumption * 30 * occupancy;
    const net = Math.max(gross - cost, 0);
    const payback = gross > 0 ? Math.max((cost * 4) / Math.max(net, 1), 0) : 0;

    resultNumber.textContent = `₪ ${formatMoney(net)}`;
    if (tagline) {
      tagline.textContent = `הכנסה חודשית צפויה לפני מע"מ לאחר עלויות תפעול (${formatMoney(cost)} ₪).`;
    }
    if (pill) {
      pill.textContent = `החזר השקעה משוער: ${payback.toFixed(1)} חודשים בהיקף ההתקנות הנוכחי.`;
    }
  };

  roiForm.addEventListener('input', calculate);
  roiForm.addEventListener('submit', (e) => {
    e.preventDefault();
    calculate();
  });

  calculate();
}
