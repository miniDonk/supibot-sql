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
		207,
		'set',
		'[\"unset\"]',
		'owner-override,ping',
		'Sets/unsets certain variables within Supibot. Check the extended help for full info.',
		5000,
		NULL,
		'(() => {
	const handleAmbassadors = async (type, context, ...args) => {
		const [user, channel = context.channel?.Name] = args;
		if (!user || !channel) {
			return {
				success: false,
				reply: `Must provide a proper user and channel!`
			};
		}

		const userData = await sb.User.get(user);
		const channelData = sb.Channel.get(channel, context.platform);
		if (!userData || !channelData) {
			return {
				success: false,
				reply: `Either the channel or the user have not been found!`
			};
		}

		const isAmbassador = channelData.isUserAmbassador(userData);
		if ((type === \"set\" && isAmbassador) || (type === \"unset\" && !isAmbassador)) {
			const prefix = (type === \"set\") ? \"already\" : \"not\";
			return {
				success: false,
				reply: `Cannot ${invocation} ${userData.Name} as an ambassador in ${channelData.Name}, because they are ${prefix} one!`
			};
		}

		await channelData.toggleAmbassador(userData);

		const string = (type === \"set\") ? \"now\" : \"no longer\";
		return {
			reply: `${userData.Name} is ${string} a Supibot Ambassador in #${channelData.Name}.`
		};
	};
	return {
		variables: [
			{
				names: [\"ambassador\"],
				adminOnly: true,
				parameter: \"arguments\",
				description: `Designates a user as an \"Ambassador\" in a specific channel, which grants them elevated access to some Supibot commands.`,
				set: (context, ...args) => handleAmbassadors(\"set\", context, ...args),
				unset: (context, ...args) => handleAmbassadors(\"unset\", context, ...args)
			},
			{
				names: [\"notify\", \"reminder\"],
				parameter: \"ID\",
				description: \"Unsets an active reminder either set by you, or for you.\",
				getLastID: (context) => sb.Query.getRecordset(rs => rs
					.select(\"ID\")
					.from(\"chat_data\", \"Reminder\")
					.where(\"User_From = %n\", context.user.ID)
					.where(\"Active = %b\", true)
					.orderBy(\"ID DESC\")
					.limit(1)
					.single()
					.flat(\"ID\")
				),
				unset: async (context, ID) => {
					const row = await sb.Query.getRow(\"chat_data\", \"Reminder\");
					try {
						await row.load(ID);
					}
					catch {
						return {
							success: false,
							reply: \"ID does not exist!\"
						};
					}

					if (row.values.User_From !== context.user.ID && row.values.User_To !== context.user.ID ) {
						return {
							success: false,
							reply: \"That reminder was not created by you or set for you!\"
						};
					}
					else if (!row.values.Active) {
						return {
							success: false,
							reply: \"That reminder is already deactivated!\"
						};
					}
					else if (context.channel?.ID && !row.values.Schedule && row.values.User_To === context.user.ID) {
						return {
							success: false,
							reply: \"Good job, trying to unset a reminder that just fired PepeLaugh\"
						};
					}
					else {
						const reminder = sb.Reminder.get(ID);
						if (reminder) {
							await reminder.deactivate(true);
						}
						else {
							row.values.Active = false;
							await row.save();
						}

						return {
							reply: `Reminder ID ${ID} unset successfully.`
						};
					}
				}
			},
			{
				names: [\"suggest\", \"suggestion\"],
				parameter: \"ID\",
				description: \"Marks an active suggestion created by you to be \\\"Dismissed by author\\\", therefore removing it from the list of active suggestions.\",
				getLastID: (context) => sb.Query.getRecordset(rs => rs
					.select(\"ID\")
					.from(\"data\", \"Suggestion\")
					.where(\"User_Alias = %n\", context.user.ID)
					.orderBy(\"ID DESC\")
					.limit(1)
					.single()
					.flat(\"ID\")
				),
				unset: async (context, ID) => {
					const row = await sb.Query.getRow(\"data\", \"Suggestion\");
					try {
						await row.load(ID);
					}
					catch {
						return { reply: \"ID does not exist!\" };
					}

					if (row.values.User_Alias !== context.user.ID) {
						return { reply: \"That suggestion was not created by you!\" };
					}
					else if (row.values.Status === \"Dismissed by author\") {
						return { reply: \"That reminder is already deactivated!\" };
					}
					else {
						row.values.Priority = null;
						row.values.Status = \"Dismissed by author\";
						await row.save();
						return { reply: \"Suggestion ID \" + ID + \" has been flagged as \\\"Dismissed by author\\\".\" };
					}
				}
			},
			{
				names: [\"location\"],
				parameter: \"arguments\",
				description: `Sets/unsets your IRL location. If you add the keyword \"private\", it\'s going to be hidden. This location is used in commands such as weather, time, and others.`,
				set: async (context, ...args) => {
					let hidden = false;
					if (args[0] === \"private\" || args[0] === \"hidden\") {
						hidden = true;
						args.shift();
					}

					if (args.length === 0) {
						return {
							success: false,
							reply: \"No location provided!\",
							cooldown: 2500
						};
					}

					const query = args.join(\" \");
					const { components, coordinates, formatted, location, placeID, success } = await sb.Utils.fetchGeoLocationData(
						sb.Config.get(\"API_GOOGLE_GEOCODING\"),
						query
					);

					if (!success) {
						return {
							success: false,
							reply: \"No location found for given query!\"
						};
					}

					context.user.Data.location = {
						formatted,
						placeID,
						components,
						hidden,
						coordinates: coordinates ?? location,
						original: query
					};

					await context.user.saveProperty(\"Data\", context.user.Data);
					return {
						reply: `Successfully set your ${hidden ? \"private\" : \"public\"} location!`
					};
				},
				unset: async (context) => {
					if (!context.user.Data.location) {
						return {
							success: false,
							reply: `You don\'t have a location set up, so there is nothing to unset!`
						};
					}

					context.user.Data.location = null;

					await context.user.saveProperty(\"Data\", context.user.Data);
					return {
						reply: \"Your location has been unset successfully!\"
					};
				}
			},
			{
				names: [\"gc\"],
				parameter: \"ID\",
				description: \"If you made a mistake with the gc command, you can use this to remove a track from the todo list.\",
				unset: async (context, ID) => {
					const row = await sb.Query.getRow(\"music\", \"Track\");
					try {
						await row.load(ID);
					}
					catch {
						return {
							success: false,
							reply: \"ID does not exist!\"
						};
					}

					if (!context.user.Data.administrator && row.values.Added_By !== context.user.ID) {
						return {
							success: false,
							reply: \"This track was not added by you!\"
						};
					}

					const tags = await sb.Query.getRecordset(rs => rs
						.select(\"Tag\")
						.from(\"music\", \"Track_Tag\")
						.where(\"Track = %n\", ID)
						.flat(\"Tag\")
					);

					// If gachi tag is present already, there is no reason to unset it.
					if (tags.includes(6)) {
						return {
							success: false,
							reply: \"This track has already been categorized, and cannot be changed like this!\"
						};
					}

					// Deletes TODO tag of given track.
					await sb.Query.raw(`DELETE FROM music.Track_Tag WHERE (Track = ${ID} AND Tag = 20)`);

					return {
						reply: `Track ID ${ID} (${row.values.Name}) has been stripped of the TODO tag.`
					};
				}
			},
			{
				names: [\"discord\"],
				elevatedChannelAccess: true,
				parameter: \"arguments\",
				description: \"If you\'re the channel owner or a channel ambassador, you can use this to set the response of the discord command.\",
				set: async (context, ...args) => {
					context.channel.Data.discord = args.join(\" \");
					await context.channel.saveProperty(\"Data\");

					return {
						reply: `Discord description set successfully.`
					};
				},
				unset: async (context) => {
					context.channel.Data.discord = null;
					await context.channel.saveProperty(\"Data\");

					return {
						reply: `Discord description unset successfully.`
					};
				}
			}
		]
	};
})()',
		'(async function set (context, type, ...args) {
	if (!type) {
		return {
			success: false,
			reply: \"No type provided!\"
		};
	}

	const { invocation } = context;
	type = type.toLowerCase();

	const target = this.staticData.variables.find(i => i.names.includes(type));
	if (!target) {
		return {
			success: false,
			reply: \"Invalid type provided!\"
		};
	}
	else if (typeof target[invocation] !== \"function\") {
		return {
			success: false,
			reply: `You cannot ${invocation} the type ${type}!`
		};
	}

	if (target.adminOnly && !context.user.Data.administrator) {
		return {
			success: false,
			reply: `Only administrators can work with the type \"${type}\"!`
		};
	}
	else if (
		target.elevatedChannelAccess
		&& !context.channel.isUserChannelOwner(context.user)
		&& !context.channel.isUserAmbassador(context.user)
	) {
		return {
			success: false,
			reply: `Only channel owners and ambassadords can work with the type \"${type}\"!`
		};
	}

	if (target.parameter === \"arguments\") {
		return await target[invocation](context, ...args);
	}
	else if (target.parameter === \"ID\") {
		let ID = Number(args[0]);
		if (args[0] === \"last\") {
			if (typeof target.getLastID !== \"function\") {
				return {
					success: false,
					reply: `You cannot use the keyword \"last\" while ${invocation}ting a ${type}!`
				};
			}

			ID = await target.getLastID(context);
		}

		if (!sb.Utils.isValidInteger(ID)) {
			return {
				success: false,
				reply: `Provided ID is not a valid number!`
			};
		}

		return await target[invocation](context, ID);
	}
})',
		'async (prefix, values) => {
	const { variables } = values.getStaticData();
	const list = variables.map(i => {
		let names = i.names[0];
		if (i.names.lenght > 1) {
			names += `(${i.names.slice(1).join(\", \")})`;
		}

		const types = [
			(i.set) ? \"set\" : \"\",
			(i.unset) ? \"unset\" : \"\"
		].filter(Boolean).join(\"/\");
		
		return `<li><code>${names}</code> (${types}) ${i.description}</li>`;
	}).join(\"\");

	return [
		\"Sets a variable that you can then use in Supibot\'s commands.\",
		\"\",

		`<code>${prefix}set (variable) (data)</code>`,
		`Sets the variable of the given type with given data.`,
		\"\",
		
		\"List of variables:\",
		`<ul>${list}</ul>`		
	];	
}',
		'supinic/supibot-sql'
	)