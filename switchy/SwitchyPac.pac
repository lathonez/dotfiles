function regExpMatch(url, pattern) {
	try { return new RegExp(pattern).test(url); } catch(ex) { return false; }
}

function FindProxyForURL(url, host) {
	if (shExpMatch(url, "*195.53.238.102*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*orbis*")) return 'PROXY proxy:8081';
	if (shExpMatch(url, "*willhill*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*openbet*")) return 'PROXY proxy:8081';
	return 'DIRECT';
}