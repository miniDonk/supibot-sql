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
		112,
		'pridecheck',
		NULL,
		NULL,
		'KappaPride',
		10000,
		0,
		0,
		0,
		0,
		NULL,
		0,
		0,
		0,
		1,
		1,
		0,
		1,
		NULL,
		'async () => ({ reply: \"use $emotecheck pride instead :)\" })',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = 'async () => ({ reply: \"use $emotecheck pride instead :)\" })'