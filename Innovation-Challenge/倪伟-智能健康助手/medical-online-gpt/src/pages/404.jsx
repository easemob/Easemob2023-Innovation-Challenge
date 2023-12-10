import React from 'react';

function NotFound() {
  const styles = {
    container: {
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      height: '100vh',
      backgroundColor: '#f5f5f5',
    },
    content: {
      textAlign: 'center',
    },
    h1: {
      fontSize: '10rem',
      margin: 0,
      color: '#333',
    },
    p: {
      fontSize: '2rem',
      margin: "0 10px",
      color: '#666',
    },
  };

  return (
    <div style={styles.container}>
      <div style={styles.content}>
        <h1 style={styles.h1}>404</h1>
        <p style={styles.p}>Oops! The page you are looking for does not exist.</p>
      </div>
    </div>
  );
}

export default NotFound;
