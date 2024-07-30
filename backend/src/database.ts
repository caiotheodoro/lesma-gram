import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: `localhost`,
    port: 5432,
    database: process.env.DB_DATABASE,
    password: process.env.DB_PASSWORD,
});


const initalize =  async () => {
}




export  {pool, initalize};