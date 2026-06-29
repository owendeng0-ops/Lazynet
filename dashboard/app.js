const fallbackStatus = {
  name: "LazyNet",
  version: "dev",
  generatedAt: "not generated",
  rulesVersion: "dev",
  gitCommit: "unknown",
  modules: [
    { name: "OpenWrt", state: "planned", detail: "Runtime service and scoped firewall templates are available." },
    { name: "Mihomo", state: "ready", detail: "Generated server config includes DNS, fake-IP, and routing metadata." },
    { name: "DNS", state: "planned", detail: "AdGuard Home integration is reserved for the next platform step." },
    { name: "AI", state: "ready", detail: "AI domains route through the AI policy group." },
    { name: "Netflix", state: "ready", detail: "Netflix rules are separated from PlayStation direct rules." },
    { name: "Clients", state: "ready", detail: "Shadowrocket and Verge outputs can be generated from source rules." }
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

function renderModules(modules) {
  const target = document.getElementById("modules");
  target.textContent = "";

  modules.forEach((module) => {
    const article = document.createElement("article");
    article.className = "module";

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
  renderModules(status.modules || fallbackStatus.modules);

  const overall = document.getElementById("overall-status");
  overall.textContent = "Ready";
  overall.classList.add("ok");
});

