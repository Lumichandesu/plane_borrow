const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');
const crypto = require('crypto');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Create a MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'plane_borrow'
});

// Connect to the database
db.connect((err) => {
  if (err) {
    console.error('Database connection failed: ' + err.stack);
    process.exit(1);
  }
  console.log('Connected to database.');
});

// Route to get asset status totals
app.get('/asset-status', (req, res) => {
  const sql = `
    SELECT 
      SUM(status = 2) AS borrowed_assets, 
      SUM(status = 1) AS available_assets, 
      SUM(status = 0) AS disabled_assets
    FROM plane;
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching asset status: ', err);
      return res.status(500).json({ message: 'Error fetching asset status' });
    }

    // Commented out the log statement
    // console.log('Asset status results:', results);
    res.status(200).json(results[0]);
  });
});

// User registration route
app.post('/register', (req, res) => {
  const { username, email, password, role_id } = req.body;

  // Check if the required fields are provided
  if (!username || !email || !password || !role_id) {
    return res.status(400).json({ message: 'All fields are required.' });
  }

  // Check if user already exists
  const checkUserSql = 'SELECT * FROM users WHERE email = ? OR username = ?';
  db.query(checkUserSql, [email, username], (err, results) => {
    if (err) {
      console.error('Error checking user existence: ', err);
      return res.status(500).json({ message: 'Internal server error' });
    }

    if (results.length > 0) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash the password using SHA-256
    const hashedPassword = crypto.createHash('sha256').update(password).digest('hex');

    const sql = 'INSERT INTO users (username, email, password, role_id) VALUES (?, ?, ?, ?)';
    db.query(sql, [username, email, hashedPassword, role_id], (err, result) => {
      if (err) {
        console.error('Error inserting user: ', err);
        return res.status(500).json({ message: 'Error registering user' });
      }
      res.status(201).json({ message: 'User registered successfully', userId: result.insertId });
    });
  });
});

// User login route
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Check if the required fields are provided
  if (!username || !password) {
    return res.status(400).json({ message: 'Username and password are required.' });
  }

  const sql = 'SELECT * FROM users WHERE username = ?';
  db.query(sql, [username], (err, results) => {
    if (err) {
      console.error('Error fetching user: ', err);
      return res.status(500).json({ message: 'Error logging in' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    const user = results[0];

    // Hash the provided password to compare
    const hashedProvidedPassword = crypto.createHash('sha256').update(password).digest('hex');

    // Compare the provided hashed password with the stored hashed password
    if (hashedProvidedPassword !== user.password) {
      return res.status(401).json({ accessToken: null, message: 'Invalid password' });
    }

    // If successful, send back a response
    res.status(200).json({ id: user.id, username: user.username, role_id: user.role_id });
  });
});

// Staff-History
app.post("/HistoryStaff", function(req, res) {
    let sql = 'SELECT * FROM `history`';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: "Database server error" });
        }
        console.log('Query results:', results);
        return res.status(200).json({
            message: "Data retrieved successfully",
            data: results,
            requestBody: req.body 
        });
    });
});

// Staff-Return
//ตัวนี้ต้องมีข้อมูลในดาต้าเบส เอาตัวเลขใน requestID ในdatabaseแทนที่ :request_id ของurl ถึงจะใช้งานได้
app.put('/Returnplane/:request_id', function(req, res) {
    const requestID = req.params.request_id; // ใช้ request_id จาก URL ที่ถูกต้อง
    const { rqtStatus } = req.body; // รับข้อมูลที่ต้องการอัปเดต

    // ตรวจสอบข้อมูลที่ส่งมา
    if (requestID && rqtStatus) {
        // SQL query เพื่ออัปเดตสถานะใน rqtplane
        const sql = "UPDATE `rqtplane` SET rqtStatus = ? WHERE requestID = ?";

        db.query(sql, [rqtStatus, requestID], (err, results) => {
            if (err) {
                console.error("Error updating request:", err);
                return res.status(500).json({ error: "Database server error" });
            }

            if (results.affectedRows === 0) {
                return res.status(404).json({ message: "data not found" });
            }

            return res.status(200).json({ message: "updated successfully",requestBody: req.body  });
        });
    } else {
        res.status(400).json({ error: 'fail' });
    }
});

//Staff-Dashboard
// 0 = unavailble, 1 = Available, 2 = pending
app.put("/DashboardStaff", function(req, res) {
    let sql = 'SELECT status FROM `plane`';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: "Database server error" });
        }
        
        console.log('Query results:', results);

        
        return res.status(200).json({
            results,
            requestBody: req.body 
        });
    });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// ทำถูกมั้ยนะ
