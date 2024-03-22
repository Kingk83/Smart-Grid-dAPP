// Footer.js
import React from 'react';
import './Footer.css'; // Make sure to create a Footer.css file in the same src folder

function Footer() {
  return (
    <footer className="footer">
      <div className="footer-content">
        {/* You can put your footer items here */}
        <p>&copy; {new Date().getFullYear()} Your Company Name. All rights reserved.</p>
      </div>
    </footer>
  );
}

export default Footer;
