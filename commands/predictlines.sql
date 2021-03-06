INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
		Flags,
		Description,
		Cooldown,
		Whitelist_Response,
		Static_Data,
		Code,
		Dynamic_Description,
		Source
	)
VALUES
	(
		158,
		'predictlines',
		'[\"pl\"]',
		'ping,pipe',
		'Predicts the amount of lines a given user will have in some amount of time.',
		60000,
		NULL,
		NULL,
		'(async function predictLines (context, user, ...args) {
	if (!user) {
		return { reply: \"No user provided!\", meta: { skipCooldown: true } };
	}
	else if (args.length === 0) {
		return { reply: \"No time provided!\", meta: { skipCooldown: true } };
	}

	const userData = await sb.User.get(user, true);
	if (!userData) {
		return { reply: \"Provided user does not exist!\" };
	}

	const offset = sb.Utils.parseDuration(args.join(\" \"), { returnData: false });
	if (!offset || offset < 0) {
		return { reply: \"Provided time must be valid and it must refer to future!\" };
	}

	const total = (await sb.Query.getRecordset(rs => rs
		.select(\"SUM(Message_Count) AS Total\")
		.from(\"chat_data\", \"Message_Meta_User_Alias\")
		.where(\"User_Alias = %n\", context.user.ID)
		.single()
	)).Total;

	const ratio = total / (sb.Date.now() - userData.Started_Using);
	const messages = sb.Utils.round(offset * ratio, 0);

	if (messages > Number.MAX_SAFE_INTEGER) {
		return { reply: \"There\'s too many lines to be precise! Try a smaller time interval.\" };
	}

	const when = new sb.Date().addMilliseconds(offset);
	const whenString = (when.valueOf())
		? sb.Utils.timeDelta(when)
		: \"too far in the future WAYTOODANK\";

	return {
		reply: \"I predict that there will be \" + messages + \" extra lines \" + whenString
	};
})',
		NULL,
		'supinic/supibot-sql'
	)