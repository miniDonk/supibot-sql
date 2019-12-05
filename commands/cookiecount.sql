INSERT INTO
	`chat_data`.`Command`
	(
		ID,
		Name,
		Aliases,
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
		Archived,
		Code,
		Examples,
		Dynamic_Description
	)
VALUES
	(
		99,
		'cookiecount',
		'[\"cc\", \"tcc\"]',
		'Fetches the amount of cookies you (or someone else) have eaten so far. If you use \"total\", then you will see the total amount of cookies eaten.',
		10000,
		0,
		0,
		1,
		0,
		NULL,
		0,
		1,
		0,
		1,
		1,
		0,
		'(async function cookieCount (context, user) {
	if (context.platform.Name === \"discord\" && user && user.includes(\"@\")) {
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || context.user;
	}

	if (user === \"total\" || context.invocation === \"tcc\") {
		const cookies = await sb.Query.getRecordset(rs => rs
			.select(\"SUM(Cookies_Total) AS Total\", \"SUM(Cookie_Gifts_Sent) AS Gifts\")
			.from(\"chat_data\", \"Extra_User_Data\")
			.single()
		);

		return {
			reply: cookies.Total + \" cookies have been eaten so far, out of which \" + cookies.Gifts + \" were gifted :)\"
		};
	}
	else if (user === \"leader\" || user === \"list\") {
		return {
			reply: \"Check the cookie statistics here: https://supinic.com/bot/cookie/list\"
		};
	}

	const targetUser = await sb.User.get(user || context.user, true);
	if (!targetUser) {
		return { reply: \"Target user does not exist in the database!\" };
	}

	const cookies = await sb.Query.getRecordset(rs => rs
		.select(\"Cookie_Today AS Today\", \"Cookies_Total AS Daily\")
		.select(\"Cookie_Gifts_Sent AS Sent\", \"Cookie_Gifts_Received AS Received\")
		.from(\"chat_data\", \"Extra_User_Data\")
		.where(\"User_Alias = %n\", targetUser.ID)
		.single()
	);

	const [who, target] = (context.user.ID === targetUser.ID)
		? [\"You have\", \"you\"]
		: [\"That user has\", \"them\"];

	if (!cookies || cookies.Daily === 0) {
		return { reply: who + \" never eaten a single cookie!\" };
	}
	else {
		// Today = has a cookie available today
		// Daily = amount of eaten daily cookies
		// Received = amount of received cookies, independent of Daily
		// Sent = amount of sent cookies, which is subtracted from Daily

		const total = cookies.Daily + cookies.Received - cookies.Sent + cookies.Today;
		const giftedString = (cookies.Sent === 0)
			? `${who} never given out a single cookie`
			: `${who} gifted away ${cookies.Sent} cookie(s)`;

		let reaction = \"\";
		const percentage = sb.Utils.round((cookies.Sent / total) * 100, 0);
		if (percentage <= 0) {
			reaction = \"😧 what a scrooge 😒\";
			if (cookies.Received > 100) {
				reaction += \" and a glutton 😠🍔\";
			}
		}
		else if (percentage < 25) {
			reaction = \"🙂 a fair person 👍\";
		}
		else if (percentage < 75) {
			reaction = \"😮 a great samaritan 😃👌\";
		}
		else {
			reaction = \"😳 an absolutely selfless saint 😇\";
		}

		let voidString = \"\";
		if (total < cookies.Received) {
			voidString = ` (the difference of ${cookies.Received - total} has been lost to the Void)`;
		}

		return {
			reply: `${who} eaten ${total} cookies so far. Out of those, ${cookies.Received} were gifted to ${target}${voidString}. ${giftedString} ${reaction}`
		};
	}
})',
		NULL,
		'async (prefix) =>  [
	\"Checks the amount of cookies a given person (or yourself) have eaten so far\",
	\"You can use \\\"total\\\" or invoke \" + prefix + \"tcc to get global data\",
	\"You can use \\\"eaters\\\" to get the data of top 10 gluttons\",
	\"You can use \\\"gifters\\\" to get the data of top 10 cookie gifters\",
	\"\",
	prefix + \"cc => You have eaten 123 cookies so far. Out of those, 123 were gifted to you. You have selflessly gifted away 123 cookies to other people :)\",
	prefix + \"cc <user> => They have eaten 123 cookies so far. Out of those, 123 were gifted to them. They have selflessly gifted away 123 cookies to other people :)\",
	prefix + \"cc total => 123 cookies have been eaten so far, out of which 123 were gifted :)\",
	prefix + \"cc eaters => Top 10 gluttons are: ...\",
	prefix + \"cc gifters => Top 10 gifters are ...\"
];'
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function cookieCount (context, user) {
	if (context.platform.Name === \"discord\" && user && user.includes(\"@\")) {
		user = await sb.Utils.getDiscordUserDataFromMentions(user, context.append) || context.user;
	}

	if (user === \"total\" || context.invocation === \"tcc\") {
		const cookies = await sb.Query.getRecordset(rs => rs
			.select(\"SUM(Cookies_Total) AS Total\", \"SUM(Cookie_Gifts_Sent) AS Gifts\")
			.from(\"chat_data\", \"Extra_User_Data\")
			.single()
		);

		return {
			reply: cookies.Total + \" cookies have been eaten so far, out of which \" + cookies.Gifts + \" were gifted :)\"
		};
	}
	else if (user === \"leader\" || user === \"list\") {
		return {
			reply: \"Check the cookie statistics here: https://supinic.com/bot/cookie/list\"
		};
	}

	const targetUser = await sb.User.get(user || context.user, true);
	if (!targetUser) {
		return { reply: \"Target user does not exist in the database!\" };
	}

	const cookies = await sb.Query.getRecordset(rs => rs
		.select(\"Cookie_Today AS Today\", \"Cookies_Total AS Daily\")
		.select(\"Cookie_Gifts_Sent AS Sent\", \"Cookie_Gifts_Received AS Received\")
		.from(\"chat_data\", \"Extra_User_Data\")
		.where(\"User_Alias = %n\", targetUser.ID)
		.single()
	);

	const [who, target] = (context.user.ID === targetUser.ID)
		? [\"You have\", \"you\"]
		: [\"That user has\", \"them\"];

	if (!cookies || cookies.Daily === 0) {
		return { reply: who + \" never eaten a single cookie!\" };
	}
	else {
		// Today = has a cookie available today
		// Daily = amount of eaten daily cookies
		// Received = amount of received cookies, independent of Daily
		// Sent = amount of sent cookies, which is subtracted from Daily

		const total = cookies.Daily + cookies.Received - cookies.Sent + cookies.Today;
		const giftedString = (cookies.Sent === 0)
			? `${who} never given out a single cookie`
			: `${who} gifted away ${cookies.Sent} cookie(s)`;

		let reaction = \"\";
		const percentage = sb.Utils.round((cookies.Sent / total) * 100, 0);
		if (percentage <= 0) {
			reaction = \"😧 what a scrooge 😒\";
			if (cookies.Received > 100) {
				reaction += \" and a glutton 😠🍔\";
			}
		}
		else if (percentage < 25) {
			reaction = \"🙂 a fair person 👍\";
		}
		else if (percentage < 75) {
			reaction = \"😮 a great samaritan 😃👌\";
		}
		else {
			reaction = \"😳 an absolutely selfless saint 😇\";
		}

		let voidString = \"\";
		if (total < cookies.Received) {
			voidString = ` (the difference of ${cookies.Received - total} has been lost to the Void)`;
		}

		return {
			reply: `${who} eaten ${total} cookies so far. Out of those, ${cookies.Received} were gifted to ${target}${voidString}. ${giftedString} ${reaction}`
		};
	}
})'