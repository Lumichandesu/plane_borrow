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
  const sql = `SELECT 
      SUM(status = 2) AS borrowed_assets, 
      SUM(status = 1) AS available_assets, 
      SUM(status = 0) AS disabled_assets
    FROM plane;`;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching asset status: ', err);
      return res.status(500).json({ message: 'Error fetching asset status' });
    }
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
        return res.status(200).json({
            message: "Data retrieved successfully",
            data: results,
            requestBody: req.body 
        });
    });
});

// Staff-Return
app.put('/Returnplane/:request_id', function(req, res) {
    const requestID = req.params.request_id;
    const { rqtStatus } = req.body;

    if (requestID && rqtStatus) {
        const sql = "UPDATE `rqtplane` SET rqtStatus = ? WHERE requestID = ?";

        db.query(sql, [rqtStatus, requestID], (err, results) => {
            if (err) {
                console.error("Error updating request:", err);
                return res.status(500).json({ error: "Database server error" });
            }

            if (results.affectedRows === 0) {
                return res.status(404).json({ message: "data not found" });
            }

            return res.status(200).json({ message: "updated successfully", requestBody: req.body });
        });
    } else {
        res.status(400).json({ error: 'fail' });
    }
});

// Listplanes staff
app.get('/plane', (req, res) => {
  const query = 'SELECT * FROM plane';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send('Error retrieving data from database');
    }
    res.status(200).json(results); // Return plane list
  });
});

// Add planes
app.post('/addplane', (req, res) => {
  const { planeName, planeTitle, status, catagory, seat, planeDescription, tailNumber, image } = req.body;

  if (!planeName || !planeTitle || status === undefined || !catagory || !seat || !planeDescription || !tailNumber || !image) {
    return res.status(400).send({ error: 'Please provide complete information' });
  }

  const query = `INSERT INTO plane (planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

  db.query(query, [planeName, planeTitle, status, catagory, seat, planeDescription, tailNumber, image], (err, result) => {
    if (err) {
      console.error('Database insert error:', err);
      return res.status(500).send({ error: 'Database error' });
    }
    res.send({ message: 'Plane added successfully', id: result.insertId });
  });
});

// Edit plane
app.put('/updateplane/:planeID', (req, res) => {
  const { planeID } = req.params;
  const { planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image } = req.body;

  if (!planeName || !planeTitle || status === undefined || !category || !seat || !planeDescription || !tailNumber || !image) {
    return res.status(400).send({ error: 'Please provide complete information' });
  }

  const query = `UPDATE plane SET planeName = ?, planeTitle = ?, status = ?, category = ?, seat = ?, planeDescription = ?, tailNumber = ?, image = ? WHERE planeID = ?`;

  db.query(query, [planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image, planeID], (err, result) => {
    if (err) {
      console.error('Database update error:', err);
      return res.status(500).send({ error: 'Error in database' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).send({ message: 'Not found information' });
    }

    res.send({ message: 'Edit plane successful' });
  });
});

// Staff-Dashboard
app.put("/DashboardStaff", function(req, res) {
  let sql = 'SELECT status FROM `plane`';

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: "Database server error" });
    }

    return res.status(200).json({
        results,
        requestBody: req.body 
    });
  });
});

// Request Plane
app.get('/RequestStudent', (req, res) => {
  const query = 'SELECT * FROM rqtplane';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send('Error retrieving data from database');
    }
    res.status(200).json(results); // Return request list
  });
});

// Student-History
app.post("/HistoryStudent", function(req, res) {
  let sql = 'SELECT * FROM `history`';

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: "Database server error" });
    }
    return res.status(200).json({
        message: "Data retrieved successfully",
        data: results,
    });
  });
});

// New Lecture-specific Routes

// History_Lecture API: GET history data for lectures
app.get("/History_Lecture", function(req, res) {
  let sql = 'SELECT * FROM `history` WHERE type="lecture"'; // Assuming type is 'lecture'

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: "Database server error" });
    }
    return res.status(200).json({
      message: "Lecture history retrieved successfully",
      data: results,
    });
  });
});

// ListPlane_Lecture API: GET list of planes for lecture
app.get("/ListPlane_Lecture", function(req, res) {
  const query = 'SELECT * FROM plane WHERE category="lecture"'; // Assuming category is 'lecture'

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send('Error retrieving data from database');
    }
    res.status(200).json(results); // Return plane list
  });
});

// RequestList_Lecture API: GET list of plane requests related to lectures
app.get('/RequestList_Lecture', (req, res) => {
  const query = 'SELECT * FROM rqtplane WHERE request_type="lecture"'; // Assuming request_type is 'lecture'

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send('Error retrieving data from database');
    }
    res.status(200).json(results); // Return request list
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});