const fallbackStatus = {
  name: "LazyNet",
  version: "dev",
  generatedAt: "未生成",
  rulesVersion: "dev",
  gitCommit: "unknown",
  lastUpdated: "未连接",
  overall: "warn",
  runtime: {
    host: "192.168.3.2",
    clientIp: "192.168.3.50",
    mode: "本地预览",
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
    { name: "Netflix", host: "www.netflix.com", result: "等待检测", state: "warn" },
    { name: "PlayStation", host: "www.playstation.com", result: "等待检测", state: "warn" }
  ],
  proxy: [
    { name: "GitHub", result: "等待检测", state: "warn" },
    { name: "Netflix", result: "等待检测", state: "warn" },
    { name: "ChatGPT", result: "等待检测", state: "warn" }
  ],
  node: {
    current: "unknown",
    updatedAt: "未检测",
    exit: { ip: "unknown", country: "unknown", city: "unknown" },
    checks: [
      { name: "GitHub", result: "等待检测", state: "warn" },
      { name: "Netflix", result: "等待检测", state: "warn" },
      { name: "ChatGPT", result: "等待检测", state: "warn" }
    ]
  },
  rules: [
    { name: "AI", count: 7, target: "Proxy" },
    { name: "GitHub", count: 5, target: "Proxy" },
    { name: "Netflix", count: 8, target: "Proxy" },
    { name: "PlayStation", count: 6, target: "DIRECT" }
  ],
  scope: { label: "透明代理设备", value: "192.168.3.50" },
  outputs: [
    { name: "清单", path: "configs/manifest/generated/lazynet.manifest.json", state: "generated" },
    { name: "Mihomo", path: "configs/mihomo/generated/lazynet.mihomo.yaml", state: "generated" },
    { name: "Shadowrocket", path: "configs/shadowrocket/generated/lazynet.shadowrocket.conf", state: "generated" },
    { name: "Clash Verge", path: "configs/verge/generated/lazynet.verge.yaml", state: "generated" }
  ],
  modules: [
    { name: "OpenWrt", state: "ready", detail: "服务、防火墙、运行配置" },
    { name: "Mihomo", state: "ready", detail: "混合端口、透明代理、DNS、API" },
    { name: "DNS", state: "ready", detail: "Netflix fake-IP，PSN real-IP" },
    { name: "AI", state: "ready", detail: "AI 服务分流" },
    { name: "Netflix", state: "ready", detail: "流媒体分流" },
    { name: "客户端", state: "ready", detail: "Shadowrocket、Clash Verge" }
  ]
};

const translations = {
  ok: "正常",
  ready: "就绪",
  running: "运行中",
  generated: "已生成",
  enabled: "已启用",
  disabled: "已禁用",
  warn: "注意",
  fail: "异常",
  inactive: "未运行",
  stopped: "已停止",
  unknown: "未知",
  open: "开放",
  closed: "关闭",
  true: "开放",
  false: "关闭",
  mixed: "混合端口",
  redir: "透明代理",
  dns: "DNS",
  api: "API",
  lazynet: "LazyNet 主服务",
  ps5clash: "旧 PS5Clash",
  openclash: "旧 OpenClash",
  Manifest: "清单",
  Verge: "Clash Verge",
  Clients: "客户端",
  Proxy: "代理",
  DIRECT: "直连",
  "Proxy group": "代理组",
  "鏋侀€熶簯": "代理组",
  HK: "香港",
  "Hong Kong": "香港",
  US: "美国",
  "United States": "美国",
  "San Jose": "圣何塞"
};

function t(value) {
  const key = String(value);
  return translations[key] || value || "未知";
}

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
  document.getElementById(id).textContent = value || "未知";
}

function stateClass(state) {
  if (state === true || state === "ok" || state === "ready" || state === "running" || state === "generated") return "ok";
  if (state === false || state === "fail" || state === "stopped" || state === "inactive") return "fail";
  return "warn";
}

function stateLabel(state) {
  if (state === true) return "开放";
  if (state === false) return "关闭";
  return t(state);
}

function formatMeta(value) {
  if (!value) return "";
  if (typeof value !== "string") return value;
  return translations[value] || value;
}

function itemRow(item) {
  const row = document.createElement("div");
  row.className = "row";

  const body = document.createElement("div");
  const name = document.createElement("strong");
  name.textContent = t(item.name || item.label || item.host || "项目");
  const meta = document.createElement("span");
  meta.textContent = formatMeta(item.result || item.detail || item.path || item.host || "");
  body.append(name, meta);

  const badge = document.createElement("em");
  const badgeState = item.health || item.state || item.open;
  badge.className = `badge ${stateClass(badgeState)}`;
  badge.textContent = t(item.label || stateLabel(item.state ?? item.open));

  row.append(body, badge);
  return row;
}

function renderRuntime(runtime) {
  setText("runtime-host", runtime.host || "--");
  const target = document.getElementById("runtime-grid");
  target.textContent = "";
  [
    ["透明代理设备", runtime.clientIp],
    ["运行模式", runtime.mode],
    ["核心", runtime.core],
    ["Overlay 已用", runtime.overlay?.used],
    ["Overlay 可用", runtime.overlay?.available],
    ["运行目录", runtime.runtimeDir || "/tmp/lazynet"]
  ].forEach(([label, value]) => {
    const cell = document.createElement("div");
    cell.className = "metric";
    const key = document.createElement("span");
    key.textContent = label;
    const val = document.createElement("strong");
    val.textContent = value || "未知";
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
    label.textContent = t(port.label);
    cell.append(number, label);
    target.append(cell);
  });
}

function renderRules(status) {
  setText("scope-label", `${status.scope?.label || "范围"}: ${status.scope?.value || "未知"}`);
  const target = document.getElementById("rule-strip");
  target.textContent = "";
  (status.rules || []).forEach((rule) => {
    const cell = document.createElement("div");
    cell.className = "rule";
    const name = document.createElement("strong");
    name.textContent = rule.name;
    const meta = document.createElement("span");
    meta.textContent = `${rule.count} 条规则 -> ${t(rule.target)}`;
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
    label.textContent = t(module.state || "unknown");

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
  setText("node-current", status.node?.current || "未知");
  const nodeExit = status.node?.exit;
  setText("node-exit", nodeExit ? `${t(nodeExit.country || "--")} / ${t(nodeExit.city || "--")} / ${nodeExit.ip || "--"}` : "未知");
  setText("node-updated", status.node?.updatedAt || "未检测");
  renderRows("node-checks", status.node?.checks || fallbackStatus.node.checks);
  renderRules(status);
  renderRows("outputs", status.outputs || fallbackStatus.outputs);
  renderModules(status.modules || fallbackStatus.modules);
  setText("module-summary", `正在跟踪 ${(status.modules || fallbackStatus.modules).length} 个模块`);

  const overall = document.getElementById("overall-status");
  overall.textContent = status.overall === "ok" ? "健康" : "需要检查";
  overall.className = `status-pill ${stateClass(status.overall)}`;
});
