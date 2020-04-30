INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Rollbackable,
		System,
		Skip_Banphrases,
		Whitelisted,
		Whitelist_Response,
		Read_Only,
		Opt_Outable,
		Blockable,
		Ping,
		Pipeable,
		Owner_Override,
		Archived,
		Static_Data,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		14,
		'vanishme',
		NULL,
		NULL,
		'Posts !vanish',
		5000,
		0,
		0,
		1,
		1,
		NULL,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		NULL,
		'(async function vanishMe (context) {
	return {
		reply: \"!vanish monkaS\"
	};
})',
		NULL,
		NULL
	)