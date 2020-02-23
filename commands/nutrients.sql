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
		155,
		'nutrients',
		NULL,
		'Posts basic nutrients for a specified food query',
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
		'(async function nutrients (context, ...args) {
	if (args.length === 0) {
		return { reply: \"No food provided!\" };
	}

	const data = await sb.Got({
		method: \"POST\",
		url: \"https://trackapi.nutritionix.com/v2/natural/nutrients\",
		headers: {
			\"x-app-id\": sb.Config.get(\"API_NUTRITIONIX_APP_ID\"),
			\"x-app-key\": sb.Config.get(\"API_NUTRITIONIX\"),
			\"x-remote-user-id\": 0
		},
		json: {
			query: args.join(\" \")
		},
		throwHttpErrors: false
	}).json();

	if (data.message) {
		return { reply: data.message };
	}
	else if (data.foods.length > 1) {
		return { reply: \"Only one food is supported at a time (for now)\" };
	}

	const food = data.foods[0];
	return {
		reply: [
			food.serving_qty,
			food.serving_unit,
			food.food_name,
			\"(\" + food.serving_weight_grams + \"g)\",
			\"contains\",
			food.nf_calories + \" kcal,\",
			food.nf_total_fat + \"g of fat (\" + (food.nf_saturated_fat || 0) + \"g saturated),\",
			food.nf_total_carbohydrate + \"g of carbohydrates (\" + (food.nf_sugars || 0) + \"g sugar),\",
			food.nf_protein + \"g protein\"
		].join(\" \")
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function nutrients (context, ...args) {
	if (args.length === 0) {
		return { reply: \"No food provided!\" };
	}

	const data = await sb.Got({
		method: \"POST\",
		url: \"https://trackapi.nutritionix.com/v2/natural/nutrients\",
		headers: {
			\"x-app-id\": sb.Config.get(\"API_NUTRITIONIX_APP_ID\"),
			\"x-app-key\": sb.Config.get(\"API_NUTRITIONIX\"),
			\"x-remote-user-id\": 0
		},
		json: {
			query: args.join(\" \")
		},
		throwHttpErrors: false
	}).json();

	if (data.message) {
		return { reply: data.message };
	}
	else if (data.foods.length > 1) {
		return { reply: \"Only one food is supported at a time (for now)\" };
	}

	const food = data.foods[0];
	return {
		reply: [
			food.serving_qty,
			food.serving_unit,
			food.food_name,
			\"(\" + food.serving_weight_grams + \"g)\",
			\"contains\",
			food.nf_calories + \" kcal,\",
			food.nf_total_fat + \"g of fat (\" + (food.nf_saturated_fat || 0) + \"g saturated),\",
			food.nf_total_carbohydrate + \"g of carbohydrates (\" + (food.nf_sugars || 0) + \"g sugar),\",
			food.nf_protein + \"g protein\"
		].join(\" \")
	};
})'