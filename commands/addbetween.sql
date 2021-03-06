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
		174,
		'addbetween',
		'[\"ab\"]',
		'ping,pipe',
		'Fills the message provided with the word (usually an emote) provided as the first argument.',
		30000,
		NULL,
		NULL,
		'(async function addBetween (context, word, ...args) {
	if (!word || args.length === 0) {
		return {
			reply: \"Both the word and the message must be provided!\"
		};
	}

	if (args.length === 1) {
		args = Array.from(args[0]);
	}

	const result = [];
	for (const messageWord of args) {
		result.push(word);
		result.push(messageWord);
	}

	result.push(word);
	return {
		reply: result.join(\" \"),
		cooldown: {
			length: (context.append.pipe) ? null : this.Cooldown
		}
	};
})',
		NULL,
		'supinic/supibot-sql'
	)