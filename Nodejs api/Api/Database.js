const mariadb = require('mariadb');

class Database {
  constructor() {
    this.pool = mariadb.createPool({
      host: 'localhost',
      user: 'admin',
      password: '1337xyz',
      database: 'MoveOn',
    });
  }

  async query(queryString, values) {
    let conn;
    try {
      conn = await this.pool.getConnection();
      const rows = await conn.query(queryString, values);
      return rows;
    } catch (err) {
      console.error(err);
      throw new Error('Database query failed');
    } finally {
      if (conn) {
        conn.release();
      }
    }
  }

}

module.exports = Database;
