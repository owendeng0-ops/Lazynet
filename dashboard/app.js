const fallbackStatus = {
  name: "LazyNet",
  version: "dev",
  generatedAt: "not generated",
  rulesVersion: "dev",
  gitCommit: "unknown",
  lastUpdated: "not connected",
  overall: "warn",
  runtime: {
    host: "192.168.3.2",
    clientIp: "192.168.3.50",
    mode: "local preview",
    overlay: { used: "unknown", available: "unknown" },
    core: "mihomo"
  },
  services: [
    { name: "lazynet", state: "unknown" },
    { name: "ps5clash", state: "unknown" },
    { name: "openclash", state: "unknown" }
  ],
  ports: [
    { port: 7890, label: "mixed", open: false },
    { port: 7892, label: "redir", open: false },
    { port: 7874, label: "dns", open: false },
    { port: 9090, label: "api", open: false }
  ],
  dns: [
    { name: "Netflix", host: "www.netflix.com", result: "waiting", state: "warn" },
    { name: "PlayStation", host: "www.playstation.com", result: "waiting", state: "warn" }
  ],
  proxy: [
    { name: "GitHub", result: "waiting", state: "warn" },
    { name: "Netflix", result: "waiting", state: "warn" },
    { name: "ChatGPT", result: "waiting", state: "warn" }
  ],
  node: {
    current: "unknown",
    updatedAt: "not checked",
    checks: [
      { name: "GitHub", result: "waiting", state: "warn" },
      { name: "Netflix", result: "waiting", state: "warn" },
      { name: "ChatGPT", result: "waiting", state: "warn" }
    ]
  },
  rules: [
    { name: "AI", count: 7, target: "Proxy" },
    { name: "GitHub", count: 5, target: "Proxy" },
    { name: "Netflix", count: 8, target: "Proxy" },
    { name: "PlayStation", count: 6, target: "DIRECT" }
  ],
  scope: { label: "Scoped client", value: "192.168.3.50" },
  outputs: [
    { name: "Manifest", path: "configs/manifest/generated/lazynet.manifest.json", state: "generated" },
    { name: "Mihomo", path: "configs/mihomo/generated/lazynet.mihomo.yaml", state: "generated" },
    { name: "Shadowrocket", path: "configs/shadowrocket/generated/lazynet.shadowrocket.conf", state: "generated" },
    { name: "Verge", path: "configs/verge/generated/lazynet.verge.yaml", state: "generated" }
  ],
  modules: [
    { name: "OpenWrt", state: "ready", detail: "service, firewall, runtime config" },
    { name: "Mihomo", state: "ready", detail: "mixed, redir, dns, api" },
    { name: "DNS", state: "ready", detail: "Netflix fake-IP, PSN real-IP" },
    { name: "AI", state: "ready", detail: "AI route group" },
    { name: "Netflix", state: "ready", detail: "media route group" },
    { name: "Clients", state: "ready", detail: "Shadowrocket, Verge" }
  ]
};

async function loadStatus() {
  try {
    const response = await fetch("status.json", { cache: "no-store" });
    if (!response.ok) return fallbackStatus;
    return await response.json();
  } catch {
    return fallbackStatus;
  }
}

function setText(id, value) {
  document.getElementById(id).textContent = value || "unknown";
}

function stateClass(state) {
  if (state === true || state === "ok" || state === "ready" || state === "running" || state === "generated") return "ok";
  if (state === false || state === "fail" || state === "stopped" || state === "inactive") return "fail";
  return "warn";
}

function stateLabel(state) {
  if (state === true) return "open";
  if (state === false) return "closed";
  return state || "unknown";
}

function itemRow(item) {
  const row = document.createElement("div");
  row.className = "row";

  const body = document.createElement("div");
  const name = document.createElement("strong");
  name.textContent = item.name || item.label || item.host || "item";
  const meta = document.createElement("span");
  meta.textContent = item.result || item.detail || item.path || item.host || "";
  body.append(name, meta);

  const badge = document.createElement("em");
  const badgeState = item.health || item.state || item.open;
  badge.className = `badge ${stateClass(badgeState)}`;
  badge.textContent = item.label || stateLabel(item.state ?? item.open);

  row.append(body, badge);
  return row;
}

function renderRuntime(runtime) {
  setText("runtime-host", runtime.host || "--");
  const target = document.getElementById("runtime-grid");
  target.textContent = "";
  [
    ["Client", runtime.clientIp],
    ["Mode", runtime.mode],
    ["Core", runtime.core],
    ["Overlay used", runtime.overlay?.used],
    ["Overlay free", runtime.overlay?.available],
    ["Runtime", runtime.runtimeDir || "/tmp/lazynet"]
  ].forEach(([label, value]) => {
    const cell = document.createElement("div");
    cell.className = "metric";
    const key = document.createElement("span");
    key.textContent = label;
    const val = document.createElement("strong");
    val.textContent = value || "unknown";
    cell.append(key, val);
    target.append(cell);
  });
}

function renderRows(id, rows) {
  const target = document.getElementById(id);
  target.textContent = "";
  rows.forEach((row) => target.append(itemRow(row)));
}

function renderPorts(ports) {
  const target = document.getElementById("ports");
  target.textContent = "";
  ports.forEach((port) => {
    const cell = document.createElement("div");
    cell.className = `port ${stateClass(port.open)}`;
    const number = document.createElement("strong");
    number.textContent = port.port;
    const label = document.createElement("span");
    label.textContent = port.label;
    cell.append(number, label);
    target.append(cell);
  });
}

function renderRules(status) {
  setText("scope-label", `${status.scope?.label || "Scope"}: ${status.scope?.value || "unknown"}`);
  const target = document.getElementById("rule-strip");
  target.textContent = "";
  (status.rules || []).forEach((rule) => {
    const cell = document.createElement("div");
    cell.className = "rule";
    const name = document.createElement("strong");
    name.textContent = rule.name;
    const meta = document.createElement("span");
    meta.textContent = `${rule.count} rules -> ${rule.target}`;
    cell.append(name, meta);
    target.append(cell);
  });
}

function renderModules(modules) {
  const target = document.getElementById("modules");
  target.textContent = "";

  modules.forEach((module) => {
    const article = document.createElement("article");
    article.className = `module ${stateClass(module.state)}`;

    const label = document.createElement("span");
    label.textContent = module.state || "unknown";

    const title = document.createElement("strong");
    title.textContent = module.name;

    const detail = document.createElement("p");
    detail.textContent = module.detail;

    article.append(label, title, detail);
    target.append(article);
  });
}

loadStatus().then((status) => {
  setText("version", status.version);
  setText("generated-at", status.generatedAt);
  setText("rules-version", status.rulesVersion);
  setText("git-commit", status.gitCommit);
  setText("last-updated", status.lastUpdated);
  renderRuntime(status.runtime || fallbackStatus.runtime);
  renderRows("services", status.services || fallbackStatus.services);
  renderPorts(status.ports || fallbackStatus.ports);
  renderRows("dns-checks", status.dns || fallbackStatus.dns);
  renderRows("proxy-checks", status.proxy || fallbackStatus.proxy);
  setText("node-current", status.node?.current || "unknown");
  setText("node-updated", status.node?.updatedAt || "not checked");
  renderRows("node-checks", status.node?.checks || fallbackStatus.node.checks);
  renderRules(status);
  renderRows("outputs", status.outputs || fallbackStatus.outputs);
  renderModules(status.modules || fallbackStatus.modules);
  setText("module-summary", `${(status.modules || fallbackStatus.modules).length} modules tracked`);

  const overall = document.getElementById("overall-status");
  overall.textContent = status.overall === "ok" ? "Healthy" : "Needs Check";
  overall.className = `status-pill ${stateClass(status.overall)}`;
});
