import React, { useState, useEffect } from 'react';
import './Navbar.css';
import Web3 from 'web3';

function Navbar() {
  const [balance, setBalance] = useState('Loading...');
  const [web3, setWeb3] = useState(null);

  useEffect(() => {
    const initWeb3 = async () => {
      if (window.ethereum) { // Check if MetaMask is installed
        const web3Instance = new Web3(window.ethereum); // Use the MetaMask provider
        setWeb3(web3Instance);
      } else {
        setBalance('MetaMask not installed');
      }
    };

    initWeb3();
  }, []);

  useEffect(() => {
    if (web3) {
      const loadBalance = async () => {
        try {
          const accounts = await web3.eth.getAccounts(); // Get the list of accounts
          if (accounts.length > 0) {
            const balanceWei = await web3.eth.getBalance(accounts[0]); // Get the balance of the first account in Wei
            const balanceEther = web3.utils.fromWei(balanceWei, 'ether'); // Convert balance to Ether
            setBalance(balanceEther); // Update state with balance in Ether
          } else {
            setBalance('0'); // If no accounts, set balance to 0
          }
        } catch (error) {
          console.error(error);
          setBalance('Error'); // In case of an error, update state to show it
        }
      };
      loadBalance();
    }
  }, [web3]);

  // Listen for account changes
  useEffect(() => {
    const accountChangedHandler = (accounts) => {
      loadBalance();
    };

    window.ethereum && window.ethereum.on('accountsChanged', accountChangedHandler);
    
    // Cleanup
    return () => {
      window.ethereum && window.ethereum.removeListener('accountsChanged', accountChangedHandler);
    };
  }, [web3]);

  // The loadBalance function needs to be defined or wrapped in a useCallback if used in dependencies
  const loadBalance = useCallback(async () => {
    const accounts = await web3.eth.getAccounts();
    if (accounts.length === 0) {
      console.log('Please connect to MetaMask.');
    } else {
      const balanceWei = await web3.eth.getBalance(accounts[0]);
      const balanceEther = web3.utils.fromWei(balanceWei, 'ether');
      setBalance(balanceEther);
    }
  }, [web3]);

  return (
    <div className="navbar">
      <div className="balance-info">
        <span className="balance-amount">Ξ{balance}</span>
        <span className="balance-label">Balance</span>
      </div>
      {/* Add additional navbar items if needed */}
    </div>
  );
}

export default Navbar;
