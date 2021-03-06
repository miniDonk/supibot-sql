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
		202,
		'externalbot',
		'[\"ebot\"]',
		'ping,pipe,whitelist',
		'Makes supibot execute a command of a different bot, and then the result will be that bot\'s command response. As such, this command can only be used in a pipe.',
		0,
		'Currently being tested, and only available to trusted developers',
		'({
	responseTimeout: 10_000
})',
		'(async function externalBot (context, ...rest) {
	if (!context.channel) {
		return {
			reply: \"Can\'t use this command in PMs!\"
		};
	}
	else if (!context.append.pipe) {
		return {
			reply: \"Can\'t use this command outside of pipe!\"
		};
	}

	if (!this.data.prefixes) {
		this.data.prefixes = await sb.Query.getRecordset(rs => rs
			.select(\"Bot_Alias\", \"Prefix\")
			.from(\"bot_data\", \"Bot\")
			.where(\"Prefix IS NOT NULL\")
			.orderBy(\"LENGTH(Prefix) DESC\")
		);
	}

	let botData = null;
	const message = rest.join(\" \");
	for (const {Prefix: prefix, Bot_Alias: botID} of this.data.prefixes) {
		if (message.startsWith(prefix)) {
			botData = await sb.User.get(botID);
			break;
		}
	}

	if (!botData) {
		return {
			reason: \"bad_invocation\",
			reply: \"No bot with that prefix has been found!\"
		};
	}

	const key = (context.channel.ID + \"_\" + botData.ID);

	if (!sb.Master.data.externalPipePromises) {
		sb.Master.data.externalPipePromises = new Map();
	}
	if (sb.Master.data.externalPipePromises.get(key)) {
		return {
			reply: \"Already awaiting a bot response in this channel!\"
		};
	}

	// Sends the actual external bot\'s command, and wait to see if it responds
	const safeMessage = await sb.Master.prepareMessage(message, context.channel);
	await sb.Master.send(safeMessage, context.channel);

	const promise = new sb.Promise();
	sb.Master.data.externalPipePromises.set(key, promise);

	// Set up a timeout to abort awaiting if the external bot isn\'t replying
	setTimeout(() => {
		sb.Master.data.externalPipePromises.delete(key);
		promise.resolve(null);
	}, this.staticData.responseTimeout);

	const resultMessage = await promise;
	if (resultMessage === null) {
		return {
			reason: \"bad_invocation\",
			reply: `No response from external bot after ${this.staticData.responseTimeout / 1000} seconds!`
		};
	}

	const selfRegex = new RegExp(\"^@?\" + context.platform.Self_Name + \",?\", \"i\");
	return {
		reply: resultMessage.replace(selfRegex, \"\")
	};
})',
		NULL,
		'supinic/supibot-sql'
	)