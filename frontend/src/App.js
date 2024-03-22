// App.js
import React from 'react';
import Navbar from './Navbar';
import MainContent from './MainContent';
import Footer from './Footer';
import './App.css';

function App() {
  return (
    <div className="App">
      <Navbar />
      <MainContent />
      <Footer />
    </div>
  );
}

export default App;
