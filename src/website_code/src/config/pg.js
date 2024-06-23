import { Client } from "pg";

const pgClient = new Client({
  user: "postgres",
  host: "localhost",
  database: "Restaurant",
  password: "postgres",
  port: 5432,
});

pgClient.connect();
if (pgClient) {
  console.log("Postgres connection established");
} else {
  console.log("Postgres connection failed");
}

export default pgClient;
