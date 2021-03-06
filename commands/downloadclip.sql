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
		148,
		'downloadclip',
		'[\"dlclip\"]',
		'ping,pipe',
		'Takes a Twitch clip name, and sends a download link to it into whispers.',
		30000,
		NULL,
		NULL,
		'(async function downloadClip (context, rawSlug) {
	if (!rawSlug) {
		return { reply: \"No clip slug provided!\" };
	}

	const slug = rawSlug.match(/[a-zA-z]+$/)[0];
	const data = await sb.Got.instances.Leppunen(`twitch/clip/${slug}`).json();	
	if (data.status === 404) {
		return {
			reply: \"No data found for given slug!\"
		};
	}

	const source = Object.entries(data.response.videoQualities).sort((a, b) => Number(a.quality) - Number(b.quality))[0][1].sourceURL;
	return {
		replyWithPrivateMessage: true,
		reply: source
	};
})',
		NULL,
		'supinic/supibot-sql'
	)