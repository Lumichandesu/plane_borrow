const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');
const crypto = require('crypto');
const jwt = require('jsonwebtoken'); // นำเข้า jwt สำหรับการตรวจสอบ token

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Middleware สำหรับตรวจสอบ JWT token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // ดึง token จาก header

  if (!token) return res.status(401).json({ message: 'No token provided' });

  jwt.verify(token, 'secret_key', (err, user) => { // ใช้ 'secret_key' ที่คุณตั้งไว้ตอนสร้าง token
    if (err) return res.status(403).json({ message: 'Invalid token' });
    req.user = user;
    next(); // ผ่านการยืนยัน ไปยังเส้นทางที่ร้องขอ
  });
}

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

// ================ Login =======================

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

    // สร้าง JWT token
    const token = jwt.sign({ id: user.id, role_id: user.role_id }, 'secret_key', { expiresIn: '1h' });
    res.status(200).json({ id: user.id, username: user.username, role_id: user.role_id, token });
  });
});


// ================ List Plane ===============

// Listplanes staff
app.get('/plane', (req, res) => {
  const query = 'SELECT * FROM plane';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send('Error retrieving data from database');
    }
    res.status(200).json(results); // ส่งข้อมูลกลับในรูปแบบ JSON
  });
});

// addplanes
app.post("/addplane", (req, res) => {
  const {
    planeName,
    planeTitle,
    status,
    category,
    seat,
    planeDescription,
    tailNumber,
    image,
  } = req.body;

  if (
    !planeName ||
    !planeTitle ||
    status === undefined ||
    !category ||
    !seat ||
    !planeDescription ||
    !tailNumber ||
    !image
  ) {
    return res.status(400).json({ error: "All fields are required" });
  }

  // SQL query to insert data
  const sql =
    "INSERT INTO plane (planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
  db.query(
    sql,
    [
      planeName,
      planeTitle,
      status,
      category,
      seat + " SEAT", // Add 'SEAT' suffix
      planeDescription,
      tailNumber,
      image,
    ],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Failed to insert data" });
      }

      res.json({ id: result.insertId, message: "Plane added successfully" });
    }
  );
});

//delete
app.delete('/plane/:planeID', (req, res) => {
  const planeID = req.params.planeID;

  if (!planeID) {
    return res.status(400).json({ message: 'Plane ID is required' });
  }

  const query = 'DELETE FROM plane WHERE planeID = ?';

  db.query(query, [planeID], (err, results) => {
    if (err) {
      console.error('Error deleting plane: ', err);
      return res.status(500).json({ message: 'Error deleting plane', error: err });
    }

    if (results.affectedRows === 0) {
      return res.status(404).json({ message: 'Plane not found' });
    }

    res.status(200).json({ message: 'Plane deleted successfully' });
  });
});

// ดึงข้อมูลตาม planeID
app.get('/plane/:planeID', (req, res) => {
  const { planeID } = req.params;

  const query = `SELECT * FROM plane WHERE planeID = ?`;

  db.query(query, [planeID], (err, result) => {
    if (err) {
      console.error('Database fetch error:', err);
      return res.status(500).send({ error: 'Database error' });
    }

    if (result.length === 0) {
      return res.status(404).send({ message: 'Plane not found' });
    }

    res.send(result[0]);
  });
});


// Edit Plane
app.put('/updateplane/:planeID', (req, res) => {
  const { planeID } = req.params;
  const {
    planeName,
    planeTitle,
    status,
    category,
    seat,
    planeDescription,
    tailNumber,
    image,
  } = req.body;

  // เช็คข้อมูลที่จำเป็นเท่านั้น
  if (!planeName || status === undefined || !seat || !tailNumber) {
    return res.status(400).send({ error: 'Please provide complete information' });
  }

  const query = `
    UPDATE plane
    SET planeName = ?, planeTitle = ?, status = ?, category = ?, seat = ?, planeDescription = ?, tailNumber = ?, image = ?
    WHERE planeID = ?
  `;

  db.query(
    query,
    [
      planeName || null, 
      planeTitle || null, 
      status, 
      category || 'General', // ค่าเริ่มต้นเป็น General
      seat, 
      planeDescription || 'No description', // คำอธิบายเริ่มต้น
      tailNumber, 
      image || 'airplane.jpg', // หากไม่มีรูป ใช้ airplane
      planeID,
    ],
    (err, result) => {
      if (err) {
        console.error('Database update error:', err);
        return res.status(500).send({ error: 'Error in database' });
      }

      if (result.affectedRows === 0) {
        return res.status(404).send({ message: 'Plane not found' });
      }

      res.send({ message: 'Edit plane successful' });
    }
  );
});


// ================ Request / Return ===================

// Student-Request

// Staff-Return
app.get('/Returnplane', (req, res) => {
  const query = `
    SELECT 
    h1.planeId, h1.rqtBy, h1.bDate, h1.rDate, h1.approved, h1.Lender, 
    h1.ApprovedStatus, h1.ReturnStaus, u1.username AS rqtByName, 
    p.planeName, p.image, u2.username AS LenderName, 
    u3.username AS StaffName
  FROM history h1
  INNER JOIN users u1 ON h1.rqtBy = u1.id               
  INNER JOIN users u2 ON h1.Lender = u2.id
  INNER JOIN users u3 ON h1.approved = u3.id
  JOIN Plane p ON h1.planeId = p.planeId
  WHERE h1.ReturnStaus != 1  
    AND (h1.ApprovedStatus IS NOT NULL AND h1.ApprovedStatus != 0)
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Error retrieving data from database' });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'No requests found' });
    }
    res.status(200).json(results);
  });
});

app.put('/UpdateReturnStatus/:rqtBy', (req, res) => {
  const { status, planeID } = req.body; // รับ planeID จาก body
  const { rqtBy } = req.params;

  // ตรวจสอบว่า input ครบหรือไม่
  if (status == null || rqtBy == null || planeID == null) {
    return res.status(400).json({ error: 'Please provide rqtBy, status, and planeID' });
  }

  // คำสั่ง SQL
  const updateHistoryQuery = `
    UPDATE history
    SET ReturnStaus = ?
    WHERE rqtBy = ?;
  `;

  const updatePlaneQuery = `
    UPDATE plane
    SET status = 1
    WHERE planeID = ?;
  `;

  // อัปเดต history ก่อน
  db.query(updateHistoryQuery, [status, rqtBy], (err, result) => {
    if (err) {
      console.error('Error updating ReturnStaus:', err);
      return res.status(500).json({ error: 'Error updating return status in the database' });
    }

    // ตรวจสอบว่า history ถูกอัปเดตสำเร็จ
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'No history record found for the given rqtBy' });
    }

    // อัปเดต plane status
    db.query(updatePlaneQuery, [planeID], (err, result) => {
      if (err) {
        console.error('Error updating plane status:', err);
        return res.status(500).json({ error: 'Error updating plane status in the database' });
      }

      // ตรวจสอบว่า plane ถูกอัปเดตสำเร็จ
      if (result.affectedRows === 0) {
        return res.status(404).json({ message: 'No plane record found for the given planeID' });
      }

      // สำเร็จ
      res.status(200).json({ message: 'Return status and plane status updated successfully' });
    });
  });
});

// ============== Dashboard ====================

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

// Lecture-Dardboard
app.put("/DashboardLecture", function(req, res) {
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

// ================ Check Request Plane ====================

// Request Plane Student
app.get('/RequestStudent/:rqtBy', authenticateToken, (req, res) => {
  const { rqtBy } = req.params; // ดึงค่า rqtBy จาก URL parameter

  if (!rqtBy) {
    return res.status(400).json({ error: 'Please provide rqtBy' });
  }

  const query = `
    SELECT 
        p.image AS planeImage,
        p.planeName AS planeName,
        u.username AS requestName,
        r.bDate,
        r.rDate,
        r.rqtStatus
    FROM rqtPlane r
    INNER JOIN users u ON r.rqtBy = u.id
    INNER JOIN plane p ON r.planeID = p.planeID
    WHERE r.rqtBy = ?`;

  db.query(query, [rqtBy], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Error retrieving data from database' });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'No request found for the specified student ID' });
    }
    res.status(200).json(results);
  });
});

// Request Plane Student Lecture
app.get('/RequestLecture', (req, res) => {
  const query = 'SELECT * FROM rqtplane';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send('Error retrieving data from database');
    }
    res.status(200).json(results); // ส่งข้อมูลกลับในรูปแบบ JSON
  });
});

// ================= History Plane =============

// Student-History
app.post('/HistoryStudent/:rqtBy', (req, res) => {
  const rqtBy = req.params.rqtBy; // ดึงค่า rqtBy จาก URL
  console.log('rqtBy:', rqtBy); 

  if (!rqtBy) {
    return res.status(400).json({ message: 'Missing rqtBy parameter' });
  }
  const query = `
  SELECT 
    h1.planeId, h1.rqtBy, h1.bDate, h1.rDate, h1.approved, h1.Lender, 
    h1.ApprovedStatus, h1.ReturnStaus, u1.username AS rqtByName, 
    p.planeName,p.image, u2.username AS LenderName, 
    u3.username AS StaffName
  FROM history h1
  INNER JOIN users u1 ON h1.rqtBy = u1.id               
  INNER JOIN users u2 ON h1.Lender = u2.id
  INNER JOIN users u3 ON h1.approved = u3.id
  JOIN Plane p ON h1.planeId = p.planeId 
  WHERE h1.rqtBy = ?`;

 
  // const query = 'SELECT * FROM history WHERE rqtBy = ?';
  db.query(query, [rqtBy], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ message: 'Error retrieving data from database' });
    }
    console.log('Query Results:', results); // แสดงผลลัพธ์ที่ได้จาก query
    if (results.length === 0) {
      return res.status(404).json({ message: 'No records found' });
    }
    res.status(200).json(results);
  });
});


// Lecture-History
app.post('/HistoryLecture/:approved', (req, res) => {
  const approved = req.params.approved; // ดึงค่า approved จาก URL

  if (!approved) {
    return res.status(400).json({ message: 'Missing approved parameter' });
  }

  const query = 'SELECT * FROM history WHERE approved = ?';
  db.query(query, [approved], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ message: 'Error retrieving data from database' });
    }
    res.status(200).json(results);
  });
});


// Staff-History
app.post("/HistoryStaff", function (req, res) {
  let sql = `
  SELECT 
    h1.planeId, h1.rqtBy, h1.bDate, h1.rDate, h1.approved, h1.Lender, 
    h1.ApprovedStatus, h1.ReturnStaus, u1.username AS rqtByName, 
    p.planeName, p.image, u2.username AS LenderName, 
    u3.username AS StaffName
  FROM history h1
  INNER JOIN users u1 ON h1.rqtBy = u1.id               
  INNER JOIN users u2 ON h1.Lender = u2.id
  INNER JOIN users u3 ON h1.approved = u3.id
  JOIN Plane p ON h1.planeId = p.planeId`;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: "Database server error" });
    }

    console.log('Query Results:', results);  // ตรวจสอบผลลัพธ์จากฐานข้อมูล

    if (results.length === 0) {
      return res.status(404).json({
        message: "No history available",
        data: []
      });
    }

    return res.status(200).json({
      message: "Data retrieved successfully",
      data: results,
      requestBody: req.body
    });
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
