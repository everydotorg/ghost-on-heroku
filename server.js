var path = require("path");

process.env.paths__contentPath = path.join(__dirname, "content");

// MySQL 8 changed utf8mb4's own built-in default collation from
// utf8mb4_general_ci to utf8mb4_0900_ai_ci. Knex's CREATE TABLE statements
// specify "default character set utf8mb4" without an explicit COLLATE, so on
// MySQL 8 every new table Ghost creates silently gets utf8mb4_0900_ai_ci,
// which is incompatible with the utf8mb4_general_ci columns already present
// on tables created years ago (e.g. posts.id) - breaking foreign key
// constraints on new tables that reference them (ER_FK_INCOMPATIBLE_COLUMNS).
// Setting collate explicitly keeps new tables consistent with the old ones.
process.env.database__connection__collate = "utf8mb4_general_ci";

var ghost = require("ghost");