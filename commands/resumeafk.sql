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
		119,
		'resumeafk',
		'[\"rafk\", \"cafk\", \"continueafk\"]',
		NULL,
		'Resumes your AFK status, if used within 5 minutes of coming back from AFK.',
		120000,
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
		0,
		NULL,
		'(async function resumeAFK (context) {
	if (context.privateMessage) {
		return {
			reply: \"Resuming your AFK status is only permitted outside of private messages!\"
		};
	}

	const lastAFK = (await sb.Query.getRecordset(rs => rs
		.select(\"ID\", \"Text\", \"Started\", \"Ended\", \"Status\")
		.from(\"chat_data\", \"AFK\")
		.where(\"User_Alias = %n\", context.user.ID)
		.orderBy(\"ID DESC\")
		.limit(1)
		.single()
	));

	if (!lastAFK) {
		return {
			reply: \"You cannot resume your AFK status, because you have never went AFK with me before!\"
		};
	}
	else if (!lastAFK.Ended) {
		return {
			reply: \"You were AFK until this moment... Try again?\",
			cooldown: 2500
		};
	}
	else if (lastAFK.Ended.addMinutes(5) <= sb.Date.now()) {
		return {
			reply: \"You cannot resume your AFK status, because it ended more than 5 minutes ago!\",
			cooldown: 2500
		};
	}

	const [oldAFK, newAFK] = await Promise.all([
		sb.Query.getRow(\"chat_data\", \"AFK\"),
		sb.Query.getRow(\"chat_data\", \"AFK\")
	]);

	newAFK.setValues({
		User_Alias: context.user.ID,
		Text: lastAFK.Text,
		Started: lastAFK.Started,
		Active: true,
		Status: lastAFK.Status
	});
	await newAFK.save();

	await oldAFK.load(lastAFK.ID);
	oldAFK.setValues({
		Interrupted_ID: newAFK.values.ID,
		Active: false
	});
	await oldAFK.save();

	sb.AwayFromKeyboard.data.push(new sb.AwayFromKeyboard(newAFK.valuesObject));

	return {
		reply: \"Your AFK status has been resumed.\"
	}
})',
		NULL,
		NULL
	)