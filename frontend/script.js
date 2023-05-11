import React, { useState } from 'react';
import './Dashboard.css';

function Dashboard() {
  const [selectedOption, setSelectedOption] = useState('attractions');

  const handleOptionClick = (option) => {
    setSelectedOption(option);
  };

  return (
    <div className="dashboard">
      <div className="sidebar">
        <h1>Dashboard</h1>
        <ul>
          <li
            className={selectedOption === 'attractions' ? 'active' : ''}
            onClick={() => handleOptionClick('attractions')}
          >
            Attractions
          </li>
          <li
            className={selectedOption === 'shows' ? 'active' : ''}
            onClick={() => handleOptionClick('shows')}
          >
            Shows
          </li>
          <li
            className={selectedOption === 'payments' ? 'active' : ''}
            onClick={() => handleOptionClick('payments')}
          >
            Payments
          </li>
        </ul>
      </div>
      <div className="main">
        {selectedOption === 'attractions' && (
          <h2>Attractions Dashboard</h2>
        )}
        {selectedOption === 'shows' && (
          <h2>Shows Dashboard</h2>
        )}
        {selectedOption === 'payments' && (
          <h2>Payments Dashboard</h2>
        )}
      </div>
    </div>
  );
}

export default Dashboard;
