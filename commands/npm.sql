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
		225,
		'npm',
		NULL,
		'ping,pipe',
		'Looks up an npm package with your given query, and posts a short description + link.',
		10000,
		NULL,
		NULL,
		'(async function npm (context, ...args) {
	if (args.length === 0) {
		return {
			success: false,
			reply: \"No search query provided!\"
		};
	}

	const data = await sb.Got({
		url: \"https://www.npmjs.com/search\",
		method: \"GET\",
		headers: {
			Accept: \"*/*\",
			\"X-Requested-With\": \"XMLHttpRequest\",
			\"X-Spiferack\": \"1\"
		},
		searchParams: new sb.URLParams()
			.set(\"q\", args.join(\" \"))
			.toString()
	}).json();

	if (data.objects.length === 0) {
		return {
			success: false,
			reply: \"No packages found for that query!\"
		};
	}

	const { date, description, links, name, publisher, version } = data.objects[0].package;
	return {
		reply: `${name} v${version} by ${publisher?.name ?? \"(unknown)\"}: ${description} (last publish: ${date.rel}) ${links.npm}`
	};
})',
		NULL,
		'supinic/supibot-sql'
	)