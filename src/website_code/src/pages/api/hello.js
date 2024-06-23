import pgClient from "../../config/pg";

export default function handler(req, res) {
  pgClient.query("SELECT * FROM USERS", (err, res) => {
    if (err) throw err;
    for (let row of res.rows) {
      console.log(JSON.stringify(row));
    }
    pgClient.end();
  });

  res.status(200).json({ name: "John Doe" });
}
