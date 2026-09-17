// A handful of Ghost's own core migrations call createDropNullableMigration /
// createSetNullableMigration on a column that has a foreign key, without
// passing {disableForeignKeyChecks: true}. This works fine under MySQL 8's
// own default strict sql_mode, but fails with ER_FK_COLUMN_CANNOT_CHANGE
// under a legacy/non-strict sql_mode (which our production database has, a
// holdover from whenever it was first provisioned under an old MySQL
// version). Ghost's own utility already supports this flag for exactly this
// case - these specific migrations just don't set it. Patch them in place
// after every npm install, since node_modules isn't committed to git.
const fs = require("fs");
const path = require("path");

const patches = [
	{
		file: "node_modules/ghost/core/server/data/migrations/versions/5.20/2022-10-18-05-39-drop-nullable-tier-id.js",
		search: "createDropNullableMigration('subscriptions', 'tier_id');",
		replace: "createDropNullableMigration('subscriptions', 'tier_id', {disableForeignKeyChecks: true});",
	},
	{
		file: "node_modules/ghost/core/server/data/migrations/versions/6.25/2026-03-31-20-31-19-drop-nullable-on-automated-emails-email-design-setting-id.js",
		search: "createDropNullableMigration('automated_emails', 'email_design_setting_id');",
		replace: "createDropNullableMigration('automated_emails', 'email_design_setting_id', {disableForeignKeyChecks: true});",
	},
];

for (const {file, search, replace} of patches) {
	const fullPath = path.join(__dirname, "..", file);
	if (!fs.existsSync(fullPath)) {
		continue;
	}
	const contents = fs.readFileSync(fullPath, "utf8");
	if (contents.includes(replace)) {
		continue;
	}
	if (!contents.includes(search)) {
		throw new Error(`patch-ghost-migrations: expected text not found in ${file}`);
	}
	fs.writeFileSync(fullPath, contents.replace(search, replace));
	console.log(`patch-ghost-migrations: patched ${file}`);
}
