function regExpMatch(url, pattern) {
	try { return new RegExp(pattern).test(url); } catch(ex) { return false; }
}

function FindProxyForURL(url, host) {
	if (shExpMatch(url, "*customerdb.openbet*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*10.1.29.*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*jira.openbet*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*projtracker*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*viewvc.orbis*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*williamhill*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*wiki.openbet*")) return 'PROXY custproxy:8080';
	if (shExpMatch(url, "*willhill*")) return 'PROXY custproxy:8080';
	return 'DIRECT';
}