const mysql = require('mysql2');

// Create a MySQL connection
const db = mysql.createConnection({
  host: 'localhost',             // Change if your MySQL server is running on a different host
  user: 'root',                  // Default XAMPP MySQL username
  password: '',                  // No password by default
  database: 'plane_borrow'       // Your database name
});

// Connect to the database
db.connect((err) => {
  if (err) {
    console.error('Database connection failed: ' + err.stack);
    return;
  }
  console.log('Connected to database.');

  // Example query to fetch all users
  db.query('SELECT * FROM users', (error, results) => {
    if (error) {
      console.error('Error fetching users: ', error);
      return;
    }
    console.log('Users:', results);
  });
});
