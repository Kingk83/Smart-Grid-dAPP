import Web3 from 'web3';

let web3;

// Modern dapp browsers...
if (window.ethereum) {
  web3 = new Web3(window.ethereum);
  // Request account access if needed
  window.ethereum.request({ method: 'eth_requestAccounts' }) // using request instead of enable for modern dapps
    .then(() => console.log('Accounts now exposed'))
    .catch(error => console.error('User denied account access...', error));
}
// Legacy dapp browsers...
else if (window.web3) {
  // Use Mist/MetaMask's provider.
  web3 = new Web3(window.web3.currentProvider);
  console.log('Injected web3 detected.');
}
// Fallback to localhost; use dev console port by default...
else {
  const provider = new Web3.providers.HttpProvider(
    'http://localhost:8545'
  );
  web3 = new Web3(provider);
  console.log('No web3 instance injected, using Local web3.');
}

export default web3;
