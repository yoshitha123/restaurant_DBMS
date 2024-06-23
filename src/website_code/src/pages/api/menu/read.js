import pgClient from "@config/pg";

export default function handler(req, res) {
  pgClient.query("SELECT * FROM MENU", (err, result) => {
    if (err) throw err;
    res.status(200).json(result.rows);
  });
}
