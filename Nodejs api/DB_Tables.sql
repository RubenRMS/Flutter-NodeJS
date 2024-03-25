CREATE TABLE profile (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,

    bio VARCHAR(255),
    location VARCHAR(255),
    profile_img BLOB -- PFP

    -- socials/contact tab
    -- Twitter/X
  
);

CREATE TABLE users (
  -- id
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  
  profile_id INT,-- use LAST_INSERT_ID()
  FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL,

  username VARCHAR(127) NOT NULL UNIQUE,
  display_name VARCHAR(127) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL, 
  password char(255) NOT NULL, 

  -- is_admin ENUM('yes', 'no') NOT NULL DEFAULT 'no', -- create enum for category for admin and user types -- DONE
  -- is_admin TINYINT(1) DEFAULT 0,  

  

  deleted TINYINT(1) DEFAULT 0

);


CREATE TABLE notes (

  note_id INT AUTO_INCREMENT PRIMARY KEY,
  
  user_id INT,-- use LAST_INSERT_ID()
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,

  title VARCHAR(32) NOT NULL,
  text VARCHAR(255) NOT NULL,

);

-- SELECT title FROM notes where user_id = userid