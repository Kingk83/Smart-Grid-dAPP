import React, { useState, useEffect } from 'react';
import './MainContent.css';
import web3 from './web3'; // Assuming web3 instance is correctly set up

function MainContent() {
  const [balance, setBalance] = useState('Loading...');
  const [transactions, setTransactions] = useState([]);

  useEffect(() => {
    const fetchBalanceAndTransactions = async () => {
      try {
        const accounts = await web3.eth.getAccounts();
        const balance = await web3.eth.getBalance(accounts[0]);
        const formattedBalance = web3.utils.fromWei(balance, 'ether');

        // Fetch transactions from your smart contract or backend service
        const fetchedTransactions = await fetchTransactionsFromContractOrAPI();

        setBalance(formattedBalance);
        setTransactions(fetchedTransactions);
      } catch (error) {
        console.error('Error fetching balance and transactions:', error);
        setBalance('Error');
      }
    };

    fetchBalanceAndTransactions();
  }, []);

  return (
    <div className="main-content">
      <div className="account-balance">
        <div className="balance">€{balance}</div>
        <div className="label">Main • All</div>
      </div>
      <div className="transaction-history">
        {transactions.length > 0 ? (
          transactions.map((transaction) => (
            <div key={transaction.id} className="transaction-item">
              <div>{transaction.description}</div>
              <div>€{transaction.amount}</div>
              {/* ... other transaction details ... */}
            </div>
          ))
        ) : (
          <div>No transactions found.</div>
        )}
      </div>
    </div>
  );
}

export default MainContent;
