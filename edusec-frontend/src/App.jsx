import React, { useContext } from 'react'
import Login from './components/Login'
import { AuthContext } from './context/AuthContext'
import './App.css'

function App() {
  const { user, loading, logout } = useContext(AuthContext);

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <div className="app-container">
      {!user ? (
        <Login />
      ) : (
        <div className="dashboard-container">
          <nav className="navbar">
            <h1>Electrogenics React</h1>
            <button onClick={logout} className="btn-secondary">Logout</button>
          </nav>
          <main className="main-content">
            <h2>Dashboard</h2>
            <p>Welcome back, {user.username}!</p>
            <div className="stats-grid">
               <div className="stat-card">
                 <h3>User Type</h3>
                 <p>{user.type}</p>
               </div>
               <div className="stat-card">
                 <h3>Status</h3>
                 <p>Active</p>
               </div>
            </div>
          </main>
        </div>
      )}
    </div>
  )
}

export default App
