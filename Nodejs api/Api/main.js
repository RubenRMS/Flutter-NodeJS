const express = require("express");
const multer = require("multer");
const Database = require("./Database"); // Import your Database class
const app = express();

app.use(express.json({ limit: "10mb" })); // Body parsing middleware

const db = new Database(); // Create an instance of the Database class
//const upload = multer();
const storage = multer.memoryStorage(); // You can adjust storage as needed
const upload = multer({ storage: storage });

app.get("/api/data", async (req, res) => {
  try {
    const { isadmin } = req.query; // Retrieve the isadmin parameter from the query string
    if (!isadmin) {
      return res.status(400).json({ error: "Missing isadmin parameter" });
    }

    const queryString = "SELECT * FROM users WHERE is_admin = ?";

    const rows = await db.query(queryString, [isadmin]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.get("/api/allusers", async (req, res) => {
  try {
    const {} = req.query; // Retrieve the isadmin parameter from the query string
    /*if (!isadmin) {
      return res.status(400).json({ error: 'Missing isadmin parameter' });
    }*/

    const queryString = "SELECT * FROM users";

    const rows = await db.query(queryString, []);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

/*app.post('/api/login', async (req, res) => {
  try {
    const { username,password } = req.body; // Retrieve parameters from the query string
    if (!username || !password) {
      return res.status(400).json({ error: 'Missing parameter' });
    }

    const queryString = 
    'SELECT password FROM users WHERE username = ?';
    
    const rows = await db.query(queryString, [username]);

    if(rows[0].password==password){
      //login
      jsonresponse = {
        'status': true,
        'message': 'Login ok',
      };
      res.json(jsonresponse);
    }else{
      //wrong creds
      jsonresponse = {
        'status': false,
        'message': 'Login unsuccessful',
      };
      res.json(jsonresponse);
    }

    //res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});*/

app.post("/api/login", upload.none(), async (req, res) => {
  try {
    const { username, password } = req.body; // Retrieve parameters from the request body

    if (!username || !password) {
      return res.status(400).json({ error: "Missing parameter" });
    }
    const queryString =
      "SELECT * FROM users WHERE username = ? AND password = ?";
    // Rest of the login route logic
    const rows = await db.query(queryString, [username, password]);
    console.log("-=-debug-=-");
    console.log(rows);
    //if(password=="sample"){console.log("xdasfasf");}

    //check if rows are empty first!!!

    /*if((rows[0].password==password)&&rows!=null) {
      //login
      jsonresponse = {
        'status': true,
        'message': 'Login ok',
      };
      res.json(jsonresponse);
    }else{
      //wrong pw
      jsonresponse = {
        'status': false,
        'message': 'Login unsuccessful',
      };
      
    }*/

    if (rows && rows.length > 0 && rows[0].password == password) {
      jsonresponse = {
        status: true,
        message: "Login ok",
        userid: rows[0].user_id,
      };
    } else {
      jsonresponse = {
        status: false,
        message: "Login unsuccessful",
      };
    }

    res.json(jsonresponse);

    //console.log(rows);

    //res.json({ status: true, message: 'Login successful' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.post("/api/register", upload.none(), async (req, res) => {
  try {
    const { username, password, display_name, email } = req.body;
    //user, pw, name, email etc etc
    if (!username || !password || !display_name || !email) {
      return res.status(400).json({ error: "Missing parameter" });
    }

    // Start a transaction
    const connection = await db.pool.getConnection(); //fixed with .pool

    await connection.beginTransaction();

    try {
      defaultbio = "Hi, I'm new here!";
      defaultlocation = "no location set";
      const insertProfileQueryString =
        "INSERT INTO profile (bio, location, profile_img) VALUES (?, ?, ?)";
      await connection.query(insertProfileQueryString, [
        defaultbio,
        defaultlocation,
        "",
      ]);

      //get last insert id for profile
      const profileId = await connection.query(
        "SELECT LAST_INSERT_ID() as profileId"
      );

      // Extract the profile ID from the result
      const { profileId: lastInsertId } = profileId[0];

      const insertQueryString =
        "INSERT INTO users (username, profile_id ,password, display_name, email) VALUES (?, ?, ?, ?,?)";
      // Rest of the login route logic
      //const rows = await db.query(queryString, [username,password]);
      await connection.query(insertQueryString, [
        username,
        lastInsertId,
        password,
        display_name,
        email,
      ]);

      await connection.commit();

      res.json({ status: true, message: "Registration successful" });
    } catch (error) {
      // Rollback the transaction if there's an error
      await connection.rollback();
      console.log(error);
      res.json({
        status: true,
        message: "Registration unsuccessful",
        error: error.message,
      });
      //throw error;
    } finally {
      // Release the connection back to the pool
      connection.release();
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.post("/api/getprofile", upload.none(), async (req, res) => {
  try {
    const { userid } = req.body; // Retrieve parameters from the request body

    if (!userid) {
      return res.status(400).json({ error: "Missing parameter" });
    }
    const queryString =
      //'SELECT * FROM users JOIN profile on users.profile_id = profile.profile_id WHERE users.user_id = ?';//gives error, 2 solutions below
      //'SELECT users.user_id, users.username, users.display_name, users.email,profile.profile_id AS profile_id_profile, profile.bio, profile.location FROM users JOIN profile ON users.profile_id = profile.profile_id WHERE users.user_id = ?';//use aliases when both tables have a same tupple name

      //no pfp
      //'SELECT username,display_name,bio,location FROM users JOIN profile on users.profile_id = profile.profile_id WHERE users.user_id = ?';

      //pfp
      "SELECT users.username,users.display_name,profile.bio,profile.location,profile.profile_img FROM users JOIN profile on users.profile_id = profile.profile_id WHERE users.user_id = ?";
    // Rest of the login route logic
    const rows = await db.query(queryString, [userid]);
    console.log("-=-debug-=-");
    console.log(rows);

    if (rows && rows.length > 0) {
      jsonresponse = {
        status: true,
        message: "fetched profile",
        //get profile data:

        username: rows[0].username,
        displayname: rows[0].display_name,
        bio: rows[0].bio,
        location: rows[0].location,
        //pfp to implement
        pfp: rows[0].profile_img,
        //pfp: rows[0].profile_img ? rows[0].profile_img.toString('base64') : null,
      };
    } else {
      jsonresponse = {
        status: false,
        message: "unable to load profile",
      };
    }

    res.json(jsonresponse);

    //console.log(rows);

    //res.json({ status: true, message: 'Login successful' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.post("/api/updateProfile", upload.single("pfp"), async (req, res) => {
  //pfp in file format
  try {
    const { userid, display_name, bio, location } = req.body;
    //user, pw, name, email etc etc
    if (!userid) {
      return res.status(400).json({ error: "Missing parameter" });
    }

    // Start a transaction
    const connection = await db.pool.getConnection(); //fixed with .pool

    await connection.beginTransaction();

    try {
      // Handle the image file
      const pfp = req.file; // Assuming you are using multer for file upload

      console.log(pfp);
      // Check if the file is provided
      /*if (!pfp) {
        throw new Error("Profile image is required");
      }*/

      /*      const insertProfileQueryString =
        "UPDATE profile SET bio = ?, location = ?, profile_img = ? WHERE profile_id = (select profile_id from users where user_id = ?)";
      await connection.query(insertProfileQueryString, [
        bio,
        location,
        pfp.buffer,
        userid,
      ]);*/

      //new shit
      // Construct the update query based on provided fields
      let updateProfileQueryString = "UPDATE profile SET ";
      const updateParams = [];

      if (bio) {
        updateProfileQueryString += "bio = ?, ";
        updateParams.push(bio);
      }

      if (location) {
        updateProfileQueryString += "location = ?, ";
        updateParams.push(location);
      }

      console.log("before pfp");
      if (pfp) {
        console.log("inside pfp");
        updateProfileQueryString += "profile_img = ?, ";
        updateParams.push(pfp.buffer); // Assuming pfp.buffer contains the image data
      }

      // Remove the trailing comma and space
      updateProfileQueryString = updateProfileQueryString.slice(0, -2);
      // Append the WHERE clause
      updateProfileQueryString +=
        " WHERE profile_id = (SELECT profile_id FROM users WHERE user_id = ?)";
      updateParams.push(userid);

      // Execute the update query
      await connection.query(updateProfileQueryString, updateParams);
      //------

      /*const insertQueryString =
        "UPDATE users SET display_name = ? where user_id = ?";
      // Rest of the login route logic
      //const rows = await db.query(queryString, [username,password]);
      await connection.query(insertQueryString, [display_name, userid]);*/

      // Update the display name if provided
      if (display_name) {
        const insertQueryString =
          "UPDATE users SET display_name = ? WHERE user_id = ?";
        await connection.query(insertQueryString, [display_name, userid]);
      }

      await connection.commit();

      res.json({ status: true, message: "Profile update successful" });
    } catch (error) {
      // Rollback the transaction if there's an error
      await connection.rollback();
      console.log(error);
      res.json({
        status: true,
        message: "Profile update unsuccessful",
        error: error.message,
      });
      //throw error;
    } finally {
      // Release the connection back to the pool
      connection.release();
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

/* 
//old where pfp had to be present to update profile
app.post("/api/updateProfile", upload.single("pfp"), async (req, res) => {
  //pfp in file format
  try {
    const { userid, display_name, bio, location } = req.body;
    //user, pw, name, email etc etc
    if (!userid || !display_name || !bio || !location) {
      return res.status(400).json({ error: "Missing parameter" });
    }

    // Start a transaction
    const connection = await db.pool.getConnection(); //fixed with .pool

    await connection.beginTransaction();

    try {
      // Handle the image file
      const pfp = req.file; // Assuming you are using multer for file upload

      console.log(pfp);
      // Check if the file is provided
      if (!pfp) {
        throw new Error("Profile image is required");
      }

      // Process and save the image to your storage (e.g., Amazon S3, local file system, etc.)
      //const imagePath = '/home/centos/Documents/Api/media/' + pfp.originalname; // Adjust the storage path

      // Use your preferred method to save the image
      // fs.writeFileSync(imagePath, pfp.buffer); // Example for local storage
      //fs.writeFileSync(imagePath, pfp.buffer);

      //print(pfp);
      //print(pfp.buffer);

      const insertProfileQueryString =
        "UPDATE profile SET bio = ?, location = ?, profile_img = ? WHERE profile_id = (select profile_id from users where user_id = ?)";
      await connection.query(insertProfileQueryString, [
        bio,
        location,
        pfp.buffer,
        userid,
      ]);

      const insertQueryString =
        "UPDATE users SET display_name = ? where user_id = ?";
      // Rest of the login route logic
      //const rows = await db.query(queryString, [username,password]);
      await connection.query(insertQueryString, [display_name, userid]);

      await connection.commit();

      res.json({ status: true, message: "Profile update successful" });
    } catch (error) {
      // Rollback the transaction if there's an error
      await connection.rollback();
      console.log(error);
      res.json({
        status: true,
        message: "Profile update unsuccessful",
        error: error.message,
      });
      //throw error;
    } finally {
      // Release the connection back to the pool
      connection.release();
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
*/

app.post("/api/updateProfileNew", upload.none(), async (req, res) => {
  //data all in json format
  try {
    const { userid, display_name, pfp, bio, location } = req.body;
    //user, pw, name, email etc etc
    if (!userid || !display_name || !pfp || !bio || !location) {
      return res.status(400).json({ error: "Missing parameter" });
    }

    // Start a transaction
    const connection = await db.pool.getConnection(); //fixed with .pool

    await connection.beginTransaction();

    try {
      // Handle the image file

      const insertProfileQueryString =
        "UPDATE profile SET bio = ?, location = ?, profile_img = ? WHERE profile_id = (select profile_id from users where user_id = ?)";
      await connection.query(insertProfileQueryString, [
        bio,
        location,
        pfp,
        userid,
      ]); //pfp to implement

      const insertQueryString =
        "UPDATE users SET display_name = ? where user_id = ?";
      // Rest of the login route logic
      //const rows = await db.query(queryString, [username,password]);
      await connection.query(insertQueryString, [display_name, userid]);

      await connection.commit();

      res.json({ status: true, message: "Profile update successful" });
    } catch (error) {
      // Rollback the transaction if there's an error
      await connection.rollback();
      console.log(error);
      res.json({
        status: true,
        message: "Profile update unsuccessful",
        error: error.message,
      });
      //throw error;
    } finally {
      // Release the connection back to the pool
      connection.release();
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

app.post("/api/getusernotes", upload.none(), async (req, res) => {
  try {
    const { userid } = req.body; // Retrieve parameters from the request body

    if (!userid) {
      return res.status(400).json({ error: "Missing parameter" });
    }
    const queryString = "SELECT * FROM notes where user_id = ?";

    // Rest of the login route logic
    const rows = await db.query(queryString, [userid]);
    console.log("-=-debug-=-");
    console.log(rows);

    /*if (rows && rows.length > 0) {
      jsonresponse = {
        status: true,
        message: "fetched notes",

        note_id: rows[0].note_id,
        title: rows[0].title,
      };
    } else {
      jsonresponse = {
        status: false,
        message: "unable to load notes",
      };
    }*/
    //res.json(jsonresponse);

    res.json(rows);

    //console.log(rows);

    //res.json({ status: true, message: 'Login successful' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.post("/api/deletenote", upload.none(), async (req, res) => {
  try {
    const { noteid } = req.body; // Retrieve parameters from the request body

    if (!noteid) {
      return res.status(400).json({ error: "Missing parameter" });
    }
    const queryString = "delete FROM notes where note_id = ?";

    // Rest of the login route logic
    const rows = await db.query(queryString, [noteid]);
    console.log("-=-debug-=-");
    console.log(rows);

    res.json({ status: true, message: "Note deleted" });

    //console.log(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
