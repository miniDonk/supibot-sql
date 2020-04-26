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
		193,
		'randomsadcat',
		'[\"rsc\"]',
		NULL,
		'Posts a random sad cat image SadCat',
		15000,
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
		'(() => {
	this.data.previousPosts = [];
	return {
		repeats: 3,
		links: [
			\"https://i.imgur.com/xFkm7VV.jpg\",
			\"https://i.imgur.com/3C660Pk.jpg\",
			\"https://i.imgur.com/mD71OzN.jpg\",
			\"https://i.imgur.com/dZv5bNz.jpg\",
			\"https://i.imgur.com/bhehy3k.png\",
			\"https://i.imgur.com/6oIRn5D.png\",
			\"https://i.imgur.com/EVWccQA.jpg\",
			\"https://i.imgur.com/nITklBO.jpg\",
			\"https://i.imgur.com/hkHB6jy.jpg\",
			\"https://i.imgur.com/2eXtq3a.jpg\",
			\"https://i.imgur.com/wXBwepY.jpg\",
			\"https://i.imgur.com/UVV0CQX.jpg\",
			\"https://i.imgur.com/zdeQ3rs.jpg\",
			\"https://i.imgur.com/zYFWElx.png\",
			\"https://i.imgur.com/0k1KpR4.jpg\",
			\"https://i.imgur.com/4d4Q2W2.jpg\",
			\"https://i.imgur.com/HTTBprO.png\",
			\"https://i.imgur.com/PeSlmoT.png\",
			\"https://i.imgur.com/uvgEhlc.jpg\",
			\"https://i.imgur.com/eQAxrZi.jpg\",
			\"https://i.imgur.com/7KVOO2m.jpg\",
			\"https://i.imgur.com/w4ZBo9i.jpg\",
			\"https://i.imgur.com/GJBxmBX.jpg\",
			\"https://i.imgur.com/uGdz3O8.jpg\",
			\"https://i.imgur.com/jablqRi.jpg\",
			\"https://i.imgur.com/nO0YaZV.jpg\",
			\"https://i.imgur.com/ws3MmEW.png\",
			\"https://i.imgur.com/sfkQy2S.png\",
			\"https://i.imgur.com/Ks8KQAb.jpg\",
			\"https://i.imgur.com/hg81fN7.png\",
			\"https://i.imgur.com/SNqFXOX.jpg\",
			\"https://i.imgur.com/uSel5RD.png\",
			\"https://i.imgur.com/A9btVxD.jpg\",
			\"https://i.imgur.com/3VlFNmH.png\",
			\"https://i.imgur.com/MneQNen.png\",
			\"https://i.imgur.com/V7sAokB.jpg\",
			\"https://i.imgur.com/udEeHNd.png\",
			\"https://i.imgur.com/EmDGz31.jpg\",
			\"https://i.imgur.com/1QwaWUa.jpg\",
			\"https://i.imgur.com/YOvSoYz.jpg\",
			\"https://i.imgur.com/Pc8kGIF.jpg\",
			\"https://i.imgur.com/9fpSMi4.png\",
			\"https://i.imgur.com/wmd7Y1N.jpg\",
			\"https://i.imgur.com/O15pmqg.jpg\",
			\"https://i.imgur.com/8AXrP5t.jpg\",
			\"https://i.imgur.com/37mHwJi.jpg\",
			\"https://i.imgur.com/UGe9ONF.jpg\",
			\"https://i.imgur.com/jvZfBEk.jpg\",
			\"https://i.imgur.com/EtXyjQY.jpg\",
			\"https://i.imgur.com/TMakV3F.png\",
			\"https://i.imgur.com/Ccff56Q.jpg\",
			\"https://i.imgur.com/0FSNvle.jpg\",
			\"https://i.imgur.com/qO6UUjo.png\",
			\"https://i.imgur.com/3Qd8gHd.jpg\",
			\"https://i.imgur.com/83AmZpR.jpg\",
			\"https://i.imgur.com/CdWrNyw.jpg\",
			\"https://i.imgur.com/pvLsMZZ.png\",
			\"https://i.imgur.com/Tw8M9Np.jpg\",
			\"https://i.imgur.com/58j6kXe.jpg\",
			\"https://i.imgur.com/5PcSOgo.jpg\",
			\"https://i.imgur.com/S08jBNq.png\",
			\"https://i.imgur.com/CYiniun.jpg\",
			\"https://i.imgur.com/qVfxyVF.png\",
			\"https://i.imgur.com/MTydJO3.png\",
			\"https://i.imgur.com/2zQHCGY.jpg\",
			\"https://i.imgur.com/HyMPiE1.png\",
			\"https://i.imgur.com/H7cHzNo.jpg\",
			\"https://i.imgur.com/QylmVQj.jpg\",
			\"https://i.imgur.com/QjiutEj.jpg\",
			\"https://i.imgur.com/rebC8Vn.jpg\",
			\"https://i.imgur.com/d5bX9Em.jpg\"
		]
	};
})()',
		'(async function randomSadCat () {
	const post = sb.Utils.randArray(this.staticData.links.filter(i => !this.data.previousPosts.includes(i)));
	this.data.previousPosts.unshift(post);
	this.data.previousPosts.splice(this.staticData.repeats);
	
	return {
		reply: \"SadCat \" + post
	};
})',
		NULL,
		NULL
	)

ON DUPLICATE KEY UPDATE
	Code = '(async function randomSadCat () {
	const post = sb.Utils.randArray(this.staticData.links.filter(i => !this.data.previousPosts.includes(i)));
	this.data.previousPosts.unshift(post);
	this.data.previousPosts.splice(this.staticData.repeats);
	
	return {
		reply: \"SadCat \" + post
	};
})'