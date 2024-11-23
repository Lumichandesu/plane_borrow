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

    // If successful, send back a response
    res.status(200).json({ id: user.id, username: user.username, role_id: user.role_id });
  });
});

// ================ List Plane ===============

// Listplanes
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

// add planes
app.post('/addplane', (req, res) => {
  const { planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image } = req.body;


  if (!planeName || !planeTitle || status === undefined || !category || !seat || !planeDescription || !tailNumber || !image) {
    return res.status(400).send({ error: 'Please provide complete in formation' });
  }

  const query = `INSERT INTO plane (planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

  db.query(query, [planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image], (err, result) => {
    if (err) {
      console.error('Database insert error:', err);
      return res.status(500).send({ error: 'Database error' });
    }
    res.send({ message: 'Plane added successfully', id: result.insertId });
  });
});

//Edit plane
app.put('/updateplane/:planeID', (req, res) => {
  const { planeID } = req.params;
  const { planeName, planeTitle, status, category, seat, planeDescription, tailNumber, image } = req.body;

  // ตรวจสอบว่ามีข้อมูลครบถ้วนหรือไม่
  if (!planeName || !planeTitle || status === undefined || !category || !seat || !planeDescription || !tailNumber || !image) {
    return res.status(400).send({ error: 'Please provide complete in formation' });
  }

  //  คำสั่ง SQL สำหรับการอัปเดตข้อมูล
  const query = `UPDATE plane SET planeName = ?, planeTitle = ?, status = ?, category = ?, seat = ?, planeDescription = ?, tailNumber = ?, image = ? WHERE planeID = ?`;

  // เรียกใช้ query เพื่ออัปเดตข้อมูลในฐานข้อมูล
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

// ================ Request / Return ===================

// Student-Borrow

app.post('/student/rent', async (req, res) => {
  try {
    const { planeName, rqtBy, bDate, rDate } = req.body;


    if (!planeName || !rqtBy || !bDate || !rDate) {
      return res.status(400).json({ message: 'Missing required fields' });
    }


    const planeQuery = 'SELECT planeID FROM plane WHERE planeName = ?';
    db.query(planeQuery, [planeName], (err, results) => {
      if (err) {
        console.error('Error fetching plane:', err);
        return res.status(500).json({ message: 'Error fetching plane data' });
      }

      if (results.length === 0) {
        return res.status(404).json({ message: 'Plane not found' });
      }

      const planeID = results[0].planeID;


      const rentQuery = `
        INSERT INTO rqtplane (planeID, rqtBy, bDate, rDate)
        VALUES (?, ?, ?, ?)
      `;

      db.query(rentQuery, [planeID, rqtBy, bDate, rDate], (err, result) => {
        if (err) {
          console.error('Error inserting rent data:', err);
          return res.status(500).json({ message: 'Failed to save rent data' });
        }

    
        const updatePlaneQuery = `UPDATE plane SET status = 2 WHERE planeID = ?`;
        db.query(updatePlaneQuery, [planeID], (err, updateResult) => {
          if (err) {
            console.error('Error updating plane status:', err);
            return res.status(500).json({ message: 'Failed to update plane status' });
          }

          res.status(201).json({ message: 'Rent data saved successfully' });
        });
      });
    });
  } catch (error) {
    res.status(500).json({ message: 'Failed to save rent data', error: error.message });
  }
});




// Student-Return
app.put('/student/return/:planeID', (req, res) => {
  const { planeID } = req.params;

  // อัปเดตสถานะเครื่องบินให้เป็น "Available"
  const updateStatusQuery = 'UPDATE plane SET status = 1 WHERE planeID = ?';

  db.query(updateStatusQuery, [planeID], (err, result) => {
    if (err) {
      console.error('Error updating plane status:', err);
      return res.status(500).json({ message: 'Failed to update plane status' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Plane not found' });
    }

    res.status(200).json({ message: 'Plane status updated to available successfully' });
  });
});










// Staff-Return แสดงข้อมูล
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
//อัพเดตข้อมูล
app.put('/UpdateReturnStatus/:rqtBy', (req, res) => {
  const { status } = req.body;
  const { rqtBy } = req.params;

  if (status == null || rqtBy == null) {
    return res.status(400).json({ error: 'Please provide rqtBy and status' });
  }

  const query = `
    UPDATE history
    SET ReturnStaus = ?
    WHERE rqtBy = ?;
  `;

  db.query(query, [status, rqtBy], (err, result) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Error updating return status in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Record not found' });
    }
    res.status(200).json({ message: 'Return status updated successfully' });
    console.log(req.body); // ตรวจสอบว่าได้รับข้อมูลหรือไม่
    console.log('SQL Query:', query);
  });
});
// ============== Dashboard ====================

//Staff-Dashboard
// 0 = unavailble, 1 = Available, 2 = pending
app.put("/DashboardStaff", function (req, res) {
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
app.put("/DashboardLecture", function (req, res) {
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
app.get('/RequestStudent/:userId',  (req, res) => {
  const userId  = req.params.userId; // ดึงค่า rqtBy จาก URL parameter

  if (!userId) {
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
    WHERE r.rqtBy = ?;
  `;

  db.query(query, [userId], (err, results) => {
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
//==================Request Lecture============
// Request Plane Lecture
app.get('/RequestLecture', (req, res) => {
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
    INNER JOIN plane p ON r.planeID = p.planeID;
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

app.put('/UpdateRequestStatus', (req, res) => {
  const { planeID, status } = req.body;

  if (planeID == null || status == null) {
    return res.status(400).json({ error: 'Please provide planeId and status' });
  }

  const query = `
    UPDATE rqtPlane
    SET rqtStatus = ?
    WHERE planeID = ?;
  `;

  db.query(query, [status, planeID], (err, result) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Error updating request status in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Plane not found' });
    }
    res.status(200).json({ message: 'Request status updated successfully' });
  });
});







// ================= History Plane =============

// Student-History: ดึงข้อมูลตาม id ของผู้ใช้ที่ล็อกอิน (ใช้เป็น rqtBy ในตาราง history)
app.post('/HistoryStudent/:userId', (req, res) => {
  const userId = req.params.userId; // ดึงค่า userId จาก URL
  console.log('User ID (Logged In):', userId);

  if (!userId) {
    return res.status(400).json({ message: 'Missing userId parameter' });
  }

  // SQL Query ที่ใช้ในการดึงข้อมูลที่ rqtBy ตรงกับ userId ที่ส่งมา
  const query = `
  SELECT 
    h1.planeId, h1.rqtBy, h1.bDate, h1.rDate, h1.approved, h1.Lender, 
    h1.ApprovedStatus, h1.ReturnStaus, u1.username AS rqtByName, 
    p.planeName, p.image, u2.username AS LenderName, 
    u3.username AS StaffName
  FROM history h1
  INNER JOIN users u1 ON h1.rqtBy = u1.id
  LEFT JOIN users u2 ON h1.Lender = u2.id
  LEFT JOIN users u3 ON h1.approved = u3.id
  LEFT JOIN Plane p ON h1.planeId = p.planeId 
  WHERE h1.rqtBy = ?`;

  db.query(query, [userId], (err, results) => {
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
