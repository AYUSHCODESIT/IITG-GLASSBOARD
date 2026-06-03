/* ================= GLASSBOARD PORTAL CLIENT SYSTEM ================= */

// --- 1. LOCAL DATA STATE (HIGH-FIDELITY MOCK REPOSITORY) ---
const STATE = {
  currentUser: null, // Starts unauthenticated to load the login screen overlay!
  
  users: [
    { uid: 'admin_1', email: 'admin@glassboard.com', displayName: 'Elena Rostova', role: 'admin', moduleId: null, avatar: 'emmanuella.png' },
    { uid: 'head_1', email: 'director@glassboard.com', displayName: 'Dr. Arthur Vance', role: 'org_head', moduleId: null, avatar: 'akeem.png' },
    { uid: 'lead_design', email: 'sarah@glassboard.com', displayName: 'Sarah Chen', role: 'lead', moduleId: 'mod_design', avatar: 'emmanuella.png' },
    { uid: 'lead_dev', email: 'ayush@glassboard.com', displayName: 'Ayush Kumar', role: 'lead', moduleId: 'mod_dev', avatar: 'akeem.png' },
    { uid: 'lead_qa', email: 'clara@glassboard.com', displayName: 'Clara Oswald', role: 'lead', moduleId: 'mod_qa', avatar: 'emmanuella.png' },
    { uid: 'lead_deploy', email: 'diana@glassboard.com', displayName: 'Diana Prince', role: 'lead', moduleId: 'mod_deploy', avatar: 'emmanuella.png' },
    { uid: 'emp_dev_1', email: 'john@glassboard.com', displayName: 'John Doe', role: 'employee', moduleId: 'mod_dev', avatar: 'akeem.png' },
    { uid: 'emp_design_1', email: 'lily@glassboard.com', displayName: 'Lily Evans', role: 'employee', moduleId: 'mod_design', avatar: 'emmanuella.png' }
  ],

  modules: [
    { id: 'mod_design', name: 'Design Studio', description: 'User interfaces, UX maps, design systems, assets.', leadId: 'lead_design', dependencyIds: [], progress: 100, status: 'completed' },
    { id: 'mod_dev', name: 'Software Development', description: 'Flutter frontend implementation and backend API services.', leadId: 'lead_dev', dependencyIds: ['mod_design'], progress: 66, status: 'in_progress' },
    { id: 'mod_qa', name: 'Quality Assurance', description: 'Integration tests, usability reviews, build checks.', leadId: 'lead_qa', dependencyIds: ['mod_dev'], progress: 0, status: 'blocked' },
    { id: 'mod_deploy', name: 'Release Operations', description: 'App Stores release pipelines, CI/CD configs.', leadId: 'lead_deploy', dependencyIds: ['mod_qa'], progress: 0, status: 'blocked' }
  ],

  tasks: [
    { id: 'task_des_1', moduleId: 'mod_design', title: 'High-Fidelity Wireframes', description: 'Create full mockups of organizational bottleneck charts.', priority: 'high', assignedTo: 'emp_design_1', isCompleted: true, progress: 100 },
    { id: 'task_des_2', moduleId: 'mod_design', title: 'Asset Exports', description: 'Export SVG assets and HSL color hex profiles.', priority: 'low', assignedTo: 'lead_design', isCompleted: true, progress: 100 },
    { id: 'task_dev_1', moduleId: 'mod_dev', title: 'Riverpod State Providers', description: 'Create states and controllers for digital handshakes.', priority: 'high', assignedTo: 'lead_dev', isCompleted: true, progress: 100 },
    { id: 'task_dev_2', moduleId: 'mod_dev', title: 'Firebase Authentication API', description: 'Connect Splash, Login, and User promotion databases.', priority: 'medium', assignedTo: 'emp_dev_1', isCompleted: false, progress: 33 },
    { id: 'task_dev_3', moduleId: 'mod_dev', title: 'Interactive Delay Engine UI', description: 'Render the node-link graph mapping out bottleneck hubs.', priority: 'high', assignedTo: 'lead_dev', isCompleted: false, progress: 0 },
    { id: 'task_qa_1', moduleId: 'mod_qa', title: 'Integration Test Suite', description: 'Write integration test drivers.', priority: 'medium', assignedTo: 'lead_qa', isCompleted: false, progress: 0 },
    { id: 'task_dep_1', moduleId: 'mod_deploy', title: 'App Store Storefront Metadata', description: 'Compile store descriptions, screenshots, and privacy policy URLs.', priority: 'medium', assignedTo: 'lead_deploy', isCompleted: false, progress: 0 },
    { id: 'task_dep_2', moduleId: 'mod_deploy', title: 'CI/CD Deployment Pipelines', description: 'Configure GitHub Actions and Google Play Console credentials.', priority: 'high', assignedTo: 'lead_deploy', isCompleted: false, progress: 0 }
  ],

  checklists: [
    { id: 'chk_des_1', taskId: 'task_des_1', title: 'User Dashboards Wireframe', isCompleted: true },
    { id: 'chk_des_2', taskId: 'task_des_1', title: 'Audit Ticker Panel Mock', isCompleted: true },
    { id: 'chk_dev_2_1', taskId: 'task_dev_2', title: 'Sign-in Forms with Email Validation', isCompleted: true },
    { id: 'chk_dev_2_2', taskId: 'task_dev_2', title: 'OAuth Google Login Hook', isCompleted: false },
    { id: 'chk_dev_2_3', taskId: 'task_dev_2', title: 'Persistent Login Storage Session', isCompleted: false },
    { id: 'chk_dep_1_1', taskId: 'task_dep_1', title: 'Draft App Store screenshots & density exports', isCompleted: false },
    { id: 'chk_dep_1_2', taskId: 'task_dep_1', title: 'Compile localized store descriptions', isCompleted: false },
    { id: 'chk_dep_2_1', taskId: 'task_dep_2', title: 'Fastlane script automation testing', isCompleted: false },
    { id: 'chk_dep_2_2', taskId: 'task_dep_2', title: 'Link Google Play API publishing credentials', isCompleted: false }
  ],

  handshakes: [
    { id: 'hs_design_dev', senderModuleId: 'mod_design', receiverModuleId: 'mod_dev', timestamp: new Date(Date.now() - 172800000), attachedFileIds: ['file_design_specs'], proofUrls: ['https://figma.com/file/glassboard_specs'], status: 'accepted', comments: 'Design deliverables finalized. UX specs and SVG files uploaded.', rejectionReason: null, acceptanceTimestamp: new Date(Date.now() - 151200000) }
  ],

  files: [
    { id: 'file_design_specs', moduleId: 'mod_design', name: 'glassboard_design_specs.pdf', currentVersion: 2, updatedAt: new Date(Date.now() - 172800000), updatedBy: 'lead_design', updatedByName: 'Sarah Chen' }
  ],

  fileVersions: [
    { id: 'fv_specs_v1', fileId: 'file_design_specs', versionNumber: 1, url: 'https://storage.googleapis.com/v1_pdf', editorId: 'lead_design', editorName: 'Sarah Chen', timestamp: new Date(Date.now() - 432000000), changeSummary: 'Initial draft of layout schematics.' },
    { id: 'fv_specs_v2', fileId: 'file_design_specs', versionNumber: 2, url: 'https://storage.googleapis.com/v2_pdf', editorId: 'emp_design_1', editorName: 'Lily Evans', timestamp: new Date(Date.now() - 172800000), changeSummary: 'Updated color profiles with Material 3 hex codes.' }
  ],

  auditLogs: [
    { id: 'log_1', action: 'LOGIN', userId: 'lead_design', userName: 'Sarah Chen', timestamp: new Date(Date.now() - 345600000), moduleId: 'mod_design', metadata: 'Device: Android SDK Emulator', avatar: 'emmanuella.png' },
    { id: 'log_2', action: 'FILE_UPLOAD', userId: 'lead_design', userName: 'Sarah Chen', timestamp: new Date(Date.now() - 345600000), moduleId: 'mod_design', metadata: 'fileName: glassboard_design_specs.pdf, Version: 1', avatar: 'emmanuella.png' },
    { id: 'log_3', action: 'HANDSHAKE_CREATE', userId: 'lead_design', userName: 'Sarah Chen', timestamp: new Date(Date.now() - 172800000), moduleId: 'mod_design', metadata: 'Target: Software Development', avatar: 'emmanuella.png' },
    { id: 'log_4', action: 'HANDSHAKE_ACCEPT', userId: 'lead_dev', userName: 'Ayush Kumar', timestamp: new Date(Date.now() - 151200000), moduleId: 'mod_dev', metadata: 'Source: Design Studio', avatar: 'akeem.png' }
  ]
};

// --- 2. CORE DELAY TRACING & BOTTLENECK SOLVER ENGINE ---
function traceBottlenecks() {
  const moduleMap = {};
  STATE.modules.forEach(m => {
    moduleMap[m.id] = m;
    // Reset status defaults
    if (m.progress === 100) {
      m.status = 'completed';
    } else {
      m.status = 'in_progress';
    }
  });

  // Flow blockages calculation: if parent module progress < 100%, any dependent is Blocked
  for (let step = 0; step < 5; step++) { // Multi-hop loops
    STATE.modules.forEach(m => {
      if (m.dependencyIds.length > 0) {
        let parentDelayed = false;
        m.dependencyIds.forEach(depId => {
          const parent = moduleMap[depId];
          if (parent && (parent.progress < 100 || parent.status === 'blocked')) {
            parentDelayed = true;
          }
        });
        if (parentDelayed && m.progress < 100) {
          m.status = 'blocked';
        }
      }
    });
  }

  // Find the critical bottleneck (furthest upstream blocked/in-progress module with lowest progress)
  let criticalBottleneck = null;
  let minProgress = 101;
  STATE.modules.forEach(m => {
    if (m.status !== 'completed' && m.progress < minProgress) {
      minProgress = m.progress;
      criticalBottleneck = m;
    }
  });

  return criticalBottleneck;
}

// Write system audit logs
function writeLog(action, moduleId, metadata) {
  const logId = 'log_' + Date.now();
  STATE.auditLogs.unshift({
    id: logId,
    action: action,
    userId: STATE.currentUser ? STATE.currentUser.uid : 'system',
    userName: STATE.currentUser ? STATE.currentUser.displayName : 'System Daemon',
    timestamp: new Date(),
    moduleId: moduleId,
    metadata: metadata,
    avatar: STATE.currentUser ? STATE.currentUser.avatar : 'emmanuella.png'
  });
  renderAuditLogs();
  
  if (typeof triggerLogNotification === 'function') {
    triggerLogNotification(action, moduleId, metadata);
  }
}

// --- 3. RESPONSIVE PRESENTATION RENDERING ---

function initPortal() {
  traceBottlenecks();
  renderStats();
  renderDependencyGraph();
  renderPersonalChecklists();
  renderAuditLogs();
  initTabNavigation();
  initDrawerDetails();
  initPromptModal();
  drawGauges();
  renderHeatmap();
  initAuthUI();
  initGlassBot();
  bindQuickActionButtons();
  initPenguinEyeTracking();
  initMascotPasswordReveal();
  initNotificationSystem();
}

// Render Overview Statistics Cards (Styled pixel-perfect matching reference image!)
// Render Overview Statistics Cards (Styled pixel-perfect matching reference image!)
function renderStats() {
  const grid = document.getElementById('stats-summary-grid');
  if (!grid) return;

  // Calculate live overall Workflow Efficiency Score and animate the Business progress ring first!
  let totalProgress = 0;
  STATE.modules.forEach(m => totalProgress += m.progress);
  let avg = totalProgress / STATE.modules.length;
  let blockedCount = STATE.modules.filter(m => m.status === 'blocked').length;
  let efficiency = Math.round(Math.max(0, avg - (blockedCount * 12)));

  grid.innerHTML = `
    <div class="metric-block" onclick="document.getElementById('btn-open-audit-history').click()" style="cursor: pointer;" title="Click to view Auditing Ledger Logs">
      <div class="metric-icon-circle" style="background: rgba(14, 165, 233, 0.15); color: #0ea5e9;">
        <i class="fa-solid fa-gauge-high"></i>
      </div>
      <div class="metric-details">
        <span class="metric-label">Workflow Efficiency</span>
        <span class="metric-value">${efficiency}%</span>
      </div>
    </div>
    <div class="metric-block" onclick="scrollToSection('active-modules')" style="cursor: pointer;" title="Click to view Active Department Gateways">
      <div class="metric-icon-circle" style="background: rgba(16, 185, 129, 0.15); color: #10b981;">
        <i class="fa-solid fa-handshake-simple"></i>
      </div>
      <div class="metric-details">
        <span class="metric-label">Completed Handoffs</span>
        <span class="metric-value">${STATE.handshakes.filter(h => h.status === 'accepted').length} Gates</span>
      </div>
    </div>
    <div class="metric-block" onclick="scrollToSection('pipeline-blocks')" style="cursor: pointer;" title="Click to trace Downstream Blockages">
      <div class="metric-icon-circle" style="background: rgba(239, 68, 68, 0.15); color: #ef4444;">
        <i class="fa-solid fa-triangle-exclamation"></i>
      </div>
      <div class="metric-details">
        <span class="metric-label">Active Delays</span>
        <span class="metric-value">${STATE.modules.filter(m => m.status === 'blocked').length} Blocks</span>
      </div>
    </div>
  `;

  // Update Delay Alert Ticker Banner
  const alertBanner = document.getElementById('pipeline-delay-alert');
  const alertText = document.getElementById('delay-alert-text');
  const bottleneck = traceBottlenecks();

  if (bottleneck && bottleneck.status === 'blocked') {
    alertBanner.classList.remove('hidden');
    alertText.innerText = `${bottleneck.name} is currently delayed, causing downstream handoff locks across the organization!`;
  } else {
    alertBanner.classList.add('hidden');
  }

  const percentageTxt = document.getElementById('savings-circle-txt');
  const progressCircle = document.getElementById('savings-progress-circle');

  if (percentageTxt) percentageTxt.innerText = `${efficiency}%`;

  if (progressCircle) {
    // Circumference = 2 * PI * r = 2 * 3.14159 * 31 = 194.78
    const circumference = 194.78;
    const offset = circumference - (efficiency / 100) * circumference;
    progressCircle.style.strokeDashoffset = offset;
  }

  // Update My Goals progress indicators dynamically!
  const travelPct = document.getElementById('goal-travel-pct');
  const travelBar = document.getElementById('goal-travel-bar');
  const estatePct = document.getElementById('goal-estate-pct');
  const estateBar = document.getElementById('goal-estate-bar');

  // Core Pipeline tied to Design Studio (mod_design) + Software Development (mod_dev) progress
  const designProgress = STATE.modules.find(m => m.id === 'mod_design')?.progress || 0;
  const devProgress = STATE.modules.find(m => m.id === 'mod_dev')?.progress || 0;
  const tProgress = Math.round((designProgress + devProgress) / 2);
  if (travelPct) travelPct.innerText = `${tProgress}%`;
  if (travelBar) travelBar.style.width = `${tProgress}%`;

  // Release Operations tied to QA (mod_qa) + Release Operations (mod_deploy) progress
  const qaProgress = STATE.modules.find(m => m.id === 'mod_qa')?.progress || 0;
  const deployProgress = STATE.modules.find(m => m.id === 'mod_deploy')?.progress || 0;
  const rProgress = Math.round((qaProgress + deployProgress) / 2);
  if (estatePct) estatePct.innerText = `${rProgress}%`;
  if (estateBar) estateBar.style.width = `${rProgress}%`;
}

// Render Handoff Flowchart Graph
function renderDependencyGraph() {
  const container = document.getElementById('visual-dependency-track');
  if (!container) return;

  // Render nodes: Design -> Dev -> QA -> Deploy
  let html = `<div class="dependency-graph-track">`;
  
  STATE.modules.forEach((mod, index) => {
    const isRoot = traceBottlenecks()?.id === mod.id;
    let nodeClass = '';
    let iconClass = 'fa-circle-dot';
    let statusLabel = 'In Progress';
    
    if (mod.status === 'completed') {
      nodeClass = 'completed';
      iconClass = 'fa-circle-check';
      statusLabel = 'Completed';
    } else if (isRoot) {
      nodeClass = 'root-cause';
      iconClass = 'fa-triangle-exclamation';
      statusLabel = 'ROOT BOTTLENECK';
    } else if (mod.status === 'blocked') {
      nodeClass = 'blocked';
      iconClass = 'fa-hand';
      statusLabel = 'Blocked';
    }
    
    html += `
      <div class="dep-node-wrapper">
        <div class="dep-node ${nodeClass}" onclick="openModuleDrawer('${mod.id}')">
          <div class="node-header ${mod.status}">
            <h4>${mod.name}</h4>
            <i class="fa-solid ${iconClass}"></i>
          </div>
          <div class="node-progress">
            <div class="progress-track-bg">
              <div class="progress-active-bar" style="width: ${mod.progress}%; background: ${mod.status === 'completed' ? 'var(--success)' : 'var(--primary)'}"></div>
            </div>
            <span>${mod.progress}%</span>
          </div>
          <span class="node-badge ${mod.status === 'completed' ? 'completed' : (isRoot ? 'root' : (mod.status === 'blocked' ? 'blocked' : 'in-progress'))}">${statusLabel}</span>
        </div>
    `;

    // Connector link if not last
    if (index < STATE.modules.length - 1) {
      const nextMod = STATE.modules[index + 1];
      const isNextBlocked = nextMod.status === 'blocked';
      html += `
        <div class="dep-connector ${isNextBlocked ? 'blocked' : ''}">
          <div class="connector-line-row">
            <div class="connector-line"></div>
            <i class="fa-solid fa-chevron-right connector-arrow"></i>
          </div>
          <span class="connector-label">${isNextBlocked ? 'BLOCKED' : 'PASS'}</span>
        </div>
      `;
    }
    
    html += `</div>`;
  });

  html += `</div>`;
  container.innerHTML = html;
}

// Render User Personal task Checklist list
function renderPersonalChecklists() {
  const stack = document.getElementById('personal-tasks-stack');
  if (!stack || !STATE.currentUser) return;

  // Filter tasks based on logged-in user module ID
  const myModule = STATE.currentUser.moduleId;
  const myTasks = STATE.tasks.filter(t => t.moduleId === myModule);
  const myModuleObj = STATE.modules.find(m => m.id === myModule);
  const isBlocked = myModuleObj ? myModuleObj.status === 'blocked' : false;

  let headerWarning = '';
  if (isBlocked) {
    headerWarning = `
      <div style="background: rgba(239, 68, 68, 0.08); border: 1px solid var(--danger); border-radius: 10px; padding: 10px 14px; margin-bottom: 12px; display:flex; align-items:center; gap:8px; animation: pulseBlink 2.5s infinite ease-in-out;">
        <i class="fa-solid fa-lock" style="color:var(--danger); font-size:14px;"></i>
        <span style="font-size:11.5px; color:#cbd5e1; font-weight:500;">Your department scope is locked waiting for upstream handshakes.</span>
      </div>
    `;
  }

  if (myTasks.length === 0) {
    stack.innerHTML = headerWarning + `<div class="checklist-card" style="padding:10px;"><p class="checklist-card-desc" style="margin:0;">No tasks assigned to your department scope.</p></div>`;
    return;
  }

  let html = headerWarning;
  myTasks.forEach(task => {
    const checklistsForTask = STATE.checklists.filter(c => c.taskId === task.id);
    let checklistHtml = '';
    
    checklistsForTask.forEach(item => {
      checklistHtml += `
        <label class="sub-checklist-item">
          <input type="checkbox" ${item.isCompleted ? 'checked' : ''} ${isBlocked ? 'disabled' : ''} onchange="toggleChecklistItem('${item.id}', this.checked)">
          <span style="${isBlocked ? 'color: var(--text-muted); cursor: not-allowed;' : ''}">${item.title}</span>
        </label>
      `;
    });

    html += `
      <div class="checklist-card ${task.isCompleted ? 'completed' : ''}" style="${isBlocked ? 'opacity: 0.65; border-color: rgba(239,68,68,0.15);' : ''}; margin-bottom:8px; border:1px solid rgba(255,255,255,0.05); background:rgba(255,255,255,0.01); border-radius:12px; padding:10px;">
        <div class="checklist-card-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
          <h4 style="font-size:12px; color:white; font-weight:bold; margin:0;">${task.title}</h4>
          <span class="priority-tag ${task.priority}">${task.priority.toUpperCase()}</span>
        </div>
        <p class="checklist-card-desc" style="font-size:10.5px; color:#64748b; margin-bottom:8px;">${task.description}</p>
        <div class="sub-checklists-wrapper" style="display:flex; flex-direction:column; gap:4px;">
          ${checklistHtml}
        </div>
      </div>
    `;
  });
  stack.innerHTML = html;
}

// Toggle checklist sub-item check, recompute task and module progresses
window.toggleChecklistItem = function(itemId, isChecked) {
  const idx = STATE.checklists.findIndex(c => c.id === itemId);
  if (idx === -1) return;

  STATE.checklists[idx].isCompleted = isChecked;

  // Compute Task Progress
  const taskId = STATE.checklists[idx].taskId;
  const sublist = STATE.checklists.filter(c => c.taskId === taskId);
  const completed = sublist.filter(c => c.isCompleted).length;
  const total = sublist.length;
  const taskProgress = total > 0 ? Math.round((completed / total) * 100) : 0;
  
  const taskIdx = STATE.tasks.findIndex(t => t.id === taskId);
  if (taskIdx !== -1) {
    STATE.tasks[taskIdx].progress = taskProgress;
    STATE.tasks[taskIdx].isCompleted = taskProgress === 100;
    
    // Recompute Module Progress
    const moduleId = STATE.tasks[taskIdx].moduleId;
    const moduleTasks = STATE.tasks.filter(t => t.moduleId === moduleId);
    const completedTasks = moduleTasks.filter(t => t.isCompleted).length;
    const modTotal = moduleTasks.length;
    const modProgress = modTotal > 0 ? Math.round((completedTasks / modTotal) * 100) : 0;
    
    const modIdx = STATE.modules.findIndex(m => m.id === moduleId);
    if (modIdx !== -1) {
      STATE.modules[modIdx].progress = modProgress;
      if (modProgress === 100) {
        STATE.modules[modIdx].status = 'completed';
      } else if (modProgress > 0) {
        STATE.modules[modIdx].status = 'in_progress';
      } else {
        STATE.modules[modIdx].status = 'not_started';
      }

      writeLog('TASK_CHECKLIST_TOGGLE', moduleId, `checklistId: ${itemId}, isChecked: ${isChecked}`);
    }
  }

  // Update Overview statistics immediately
  traceBottlenecks();
  renderStats();
  renderDependencyGraph();
  renderPersonalChecklists();
  drawGauges();
  renderHeatmap();
};// Render Audit log entries styled beautifully with genuine system activity data!
function renderAuditLogs() {
  const stack = document.getElementById('audit-feed-stack');
  if (!stack) return;

  let html = '';

  // Render the other recent logs from memory database (slice latest 4)
  const recentLogs = [...STATE.auditLogs].reverse().slice(0, 4);
  recentLogs.forEach(log => {
    const timeString = log.timestamp.toLocaleDateString([], { day: '2-digit', month: '2-digit', year: 'numeric' }) + ' ' + log.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    
    // Select status color and label based on action
    let badgeText = log.action;
    let badgeClass = 'in-progress';
    if (log.action === 'HANDSHAKE_ACCEPT') {
      badgeText = 'VERIFIED';
      badgeClass = 'completed';
    } else if (log.action === 'HANDSHAKE_CREATE') {
      badgeText = 'HANDOFF';
      badgeClass = 'in-progress';
    } else if (log.action === 'FILE_UPLOAD' || log.action === 'FILE_MODIFY') {
      badgeText = 'DOCUMENT';
      badgeClass = 'in-progress';
    } else if (log.action === 'LOGIN') {
      badgeText = 'SESSION';
      badgeClass = 'completed';
    } else if (log.action === 'TASK_CHECKLIST_TOGGLE' || log.action === 'TASK_CREATE') {
      badgeText = 'AUDITED';
      badgeClass = 'completed';
    }

    html += `
      <div class="transaction-list-row" onclick="document.getElementById('btn-open-audit-history').click()" style="cursor: pointer; margin-bottom:6px;">
        <div style="display:flex; align-items:center; gap:12px;">
          <div class="tx-avatar-circle">
            <img src="${log.avatar || 'emmanuella.png'}" alt="${log.userName}" class="tx-user-avatar">
          </div>
          <div>
            <h4 class="tx-name" style="font-size:12px; font-weight:700;">${log.userName}</h4>
            <span class="tx-timestamp" style="font-size:9.5px; color:rgba(255,255,255,0.45);">${timeString} | ${log.metadata}</span>
          </div>
        </div>
        <div class="tx-amount-button-wrapper">
          <span class="node-badge ${badgeClass}" style="font-size:8.5px; padding:3px 8px; border-radius:10px; font-weight:700; text-transform:uppercase;">${badgeText}</span>
        </div>
      </div>
    `;
  });
  stack.innerHTML = html;
}
// --- 4. NAVIGATION HANDLERS ---
function initTabNavigation() {
  const navBtns = document.querySelectorAll('.nav-rail-btn');
  const tabPanels = document.querySelectorAll('.tab-panel');

  navBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      // Avoid action on logout
      if (btn.classList.contains('logout')) return;

      const targetTab = btn.getAttribute('data-tab');

      // If clicking clearance or ledger, trigger their overlay popups directly instead of switching viewports!
      if (targetTab === 'clearance') {
        showPromptDialog('Security Credentials Verified', [], null, `
          <div style="text-align: center; padding: 10px;">
            <div style="font-size: 32px; color: #ea580c; margin-bottom: 12px;"><i class="fa-solid fa-shield-halved"></i></div>
            <p style="font-size:13px; color:#cbd5e1; line-height:1.6; margin: 0;">
              Access clearance authenticated successfully.<br><br>
              User Session: <strong>${STATE.currentUser ? STATE.currentUser.displayName : 'UNKNOWN'}</strong><br>
              Security Clearance: <strong style="color: #f97316;">${STATE.currentUser ? STATE.currentUser.role.toUpperCase() : 'UNAUTHENTICATED'}</strong><br>
              Clearance Scope: <strong style="color: #0ea5e9;">${STATE.currentUser && STATE.currentUser.moduleId ? STATE.currentUser.moduleId.toUpperCase() : 'GLOBAL'}</strong>
            </p>
          </div>
        `);
        return;
      }

      if (targetTab === 'ledger') {
        const auditBtn = document.getElementById('btn-open-audit-history');
        if (auditBtn) auditBtn.click();
        return;
      }

      // Update active nav button
      navBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      // Update active panel viewport
      tabPanels.forEach(p => p.classList.remove('active'));
      document.getElementById('tab-' + targetTab).classList.add('active');

      // Redraw canvas graphs if Tab is Analytics
      if (targetTab === 'analytics') {
        drawGauges();
        renderHeatmap();
      }
    });
  });
}

// Global function to return to Overview tab and close drawers
window.goHome = function() {
  const overviewBtn = document.querySelector('.nav-rail-btn[data-tab="overview"]');
  if (overviewBtn) {
    overviewBtn.click();
  }
  
  const drawerModal = document.getElementById('module-drawer-modal');
  if (drawerModal) drawerModal.classList.remove('active');
  
  const actionModal = document.getElementById('action-prompt-modal');
  if (actionModal) actionModal.classList.remove('active');
};

// Quick resolution button on error banner
const quickResolveBtn = document.getElementById('quick-resolve-trigger');
if (quickResolveBtn) {
  quickResolveBtn.addEventListener('click', () => {
    // Complete all Dev tasks instantly to show dynamic pipeline resolution!
    STATE.tasks.forEach(t => {
      if (t.moduleId === 'mod_dev') {
        t.isCompleted = true;
        t.progress = 100;
      }
    });
    STATE.checklists.forEach(c => {
      if (c.id.includes('chk_dev')) {
        c.isCompleted = true;
      }
    });
    const devMod = STATE.modules.find(m => m.id === 'mod_dev');
    if (devMod) {
      devMod.progress = 100;
      devMod.status = 'completed';
    }

    writeLog('BOTTLENECK_QUICK_RESOLVE', 'mod_dev', 'Completed Dev dependencies.');
    
    traceBottlenecks();
    renderStats();
    renderDependencyGraph();
    renderPersonalChecklists();
    drawGauges();
    renderHeatmap();
  });
}

// --- 5. DETAILED SLIDING PANEL DRAWER ACTIONS ---
let activeModuleDrawerId = null;

function initDrawerDetails() {
  const modal = document.getElementById('module-drawer-modal');
  const closeBtn = document.getElementById('close-drawer-trigger');

  if (closeBtn && modal) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('active');
      activeModuleDrawerId = null;
    });
  }

  // Handle drawer tab switches
  const subtabs = document.querySelectorAll('.drawer-tab');
  const panels = document.querySelectorAll('.subtab-panel');

  subtabs.forEach(tab => {
    tab.addEventListener('click', () => {
      subtabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');

      const target = tab.getAttribute('data-subtab');
      panels.forEach(p => p.classList.remove('active'));
      document.getElementById('subtab-' + target).classList.add('active');

      // Re-trigger visual sub-renderers
      if (activeModuleDrawerId) {
        renderDrawerSubtabs(activeModuleDrawerId);
      }
    });
  });
}

window.openModuleDrawer = function(moduleId) {
  const modal = document.getElementById('module-drawer-modal');
  const module = STATE.modules.find(m => m.id === moduleId);
  
  if (!modal || !module) return;

  activeModuleDrawerId = moduleId;
  document.getElementById('drawer-title').innerText = module.name;
  document.getElementById('drawer-subtitle').innerText = module.description;

  // Open overlay
  modal.classList.add('active');

  // Trigger content rendering
  renderDrawerSubtabs(moduleId);
};

function renderDrawerSubtabs(moduleId) {
  const module = STATE.modules.find(m => m.id === moduleId);
  if (!module) return;

  // 1. Render Tasks
  const taskStack = document.getElementById('drawer-tasks-stack');
  const modTasks = STATE.tasks.filter(t => t.moduleId === moduleId);
  
  // Construct a gorgeous blocker warning alert if the module is locked
  let blockAlertHtml = '';
  if (module.status === 'blocked') {
    const blockers = module.dependencyIds.map(depId => {
      const parent = STATE.modules.find(m => m.id === depId);
      return parent ? parent.name : '';
    }).filter(name => name !== '');

    blockAlertHtml = `
      <div style="background: rgba(239, 68, 68, 0.08); border: 1px solid var(--danger); border-radius: 12px; padding: 12px 16px; margin-bottom: 16px; display:flex; align-items:center; gap:12px; animation: pulseBlink 2.5s infinite ease-in-out;">
        <i class="fa-solid fa-lock" style="color:var(--danger); font-size:18px;"></i>
        <div style="flex:1;">
          <h5 style="color:var(--danger); font-size:11px; font-weight:900; letter-spacing:1px; margin:0 0 2px 0;">WORKSPACE LOCKED</h5>
          <p style="font-size:11.5px; color:#cbd5e1; margin:0;">
            This workspace is locked waiting for upstream deliverables from <strong>${blockers.join(', ')}</strong>. A verified digital handshake must be signed to unblock operations.
          </p>
        </div>
      </div>
    `;
  }
  
  if (modTasks.length === 0) {
    taskStack.innerHTML = blockAlertHtml + `<p class="checklist-card-desc">No tasks in this module workspace.</p>`;
  } else {
    let taskHtml = blockAlertHtml;
    modTasks.forEach(task => {
      const subitems = STATE.checklists.filter(c => c.taskId === task.id);
      let listHtml = '';
      subitems.forEach(item => {
        listHtml += `
          <label class="sub-checklist-item">
            <input type="checkbox" ${item.isCompleted ? 'checked' : ''} ${module.status === 'blocked' ? 'disabled' : ''} onchange="toggleChecklistItem('${item.id}', this.checked)">
            <span style="${module.status === 'blocked' ? 'color: var(--text-muted); cursor: not-allowed;' : ''}">${item.title}</span>
          </label>
        `;
      });

      taskHtml += `
        <div class="checklist-card ${task.isCompleted ? 'completed' : ''}" style="${module.status === 'blocked' ? 'opacity: 0.65; border-color: rgba(239,68,68,0.15);' : ''}">
          <div class="checklist-card-header">
            <h4>${task.title}</h4>
            <span class="priority-tag ${task.priority}">${task.priority.toUpperCase()}</span>
          </div>
          <p class="checklist-card-desc">${task.description}</p>
          <div class="sub-checklists-wrapper">${listHtml}</div>
        </div>
      `;
    });
    taskStack.innerHTML = taskHtml;
  }

  // 2. Render Workspace Document Specs
  const fileStack = document.getElementById('drawer-files-stack');
  const modFiles = STATE.files.filter(f => f.moduleId === moduleId);

  if (modFiles.length === 0) {
    fileStack.innerHTML = `<p class="checklist-card-desc">No specification documents shared in this workspace.</p>`;
  } else {
    let fileHtml = '';
    modFiles.forEach(file => {
      fileHtml += `
        <div class="file-row">
          <div class="file-details">
            <h5>${file.name}</h5>
            <span>Version ${file.currentVersion} | Edited by ${file.updatedByName}</span>
          </div>
          <div class="file-actions">
            <button onclick="openFileVersionLogs('${file.id}')" title="Version History"><i class="fa-solid fa-clock-rotate-left"></i></button>
            <button onclick="triggerReplaceFile('${file.id}')" title="Upload New Version"><i class="fa-solid fa-arrow-up-from-bracket"></i></button>
          </div>
        </div>
      `;
    });
    fileStack.innerHTML = fileHtml;
  }

  // 3. Render Handshakes (Initiate Transfer / Sign approvals)
  const incomingBanner = document.getElementById('incoming-handshake-banner');
  const pendingHandshake = STATE.handshakes.find(h => h.receiverModuleId === moduleId && h.status === 'pending');
  const activeUserIsLead = STATE.currentUser.role === 'lead' && STATE.currentUser.moduleId === moduleId;

  if (pendingHandshake && activeUserIsLead) {
    incomingBanner.classList.remove('hidden');
    document.getElementById('incoming-handshake-details').innerText = `Handoff transfer created by ${pendingHandshake.senderModuleId === 'mod_design' ? 'Design Studio' : 'Software Development'}. Review attached proofs to sign off.`;
    
    // Assign click actions to accept/reject
    document.getElementById('btn-trigger-accept').onclick = () => {
      reviewHandoff(pendingHandshake.id, true);
    };
    document.getElementById('btn-trigger-reject').onclick = () => {
      showPromptDialog('Input Rejection Commentary', [
        { id: 'rej-comment', label: 'Rejection Reason', type: 'text', placeholder: 'Assets missing density-scaled directories.' }
      ], (fields) => {
        reviewHandoff(pendingHandshake.id, false, fields['rej-comment']);
      });
    };
  } else {
    incomingBanner.classList.add('hidden');
  }

  const handshakeStack = document.getElementById('drawer-handshakes-stack');
  const modHandshakes = STATE.handshakes.filter(h => h.senderModuleId === moduleId || h.receiverModuleId === moduleId);

  if (modHandshakes.length === 0) {
    handshakeStack.innerHTML = `<p class="checklist-card-desc">No handshake transfers recorded.</p>`;
  } else {
    let hsHtml = '';
    modHandshakes.forEach(h => {
      let badgeClass = h.status;
      let title = h.senderModuleId === moduleId ? `Handoff directed downstream` : `Handoff received from upstream`;
      
      hsHtml += `
        <div class="file-row">
          <div class="file-details">
            <h5>${title}</h5>
            <span>Status: <strong>${h.status.toUpperCase()}</strong></span>
          </div>
          <span class="node-badge ${badgeClass}">${h.status.toUpperCase()}</span>
        </div>
      `;
    });
    handshakeStack.innerHTML = hsHtml;
  }

  // 4. Detailed timeline progress
  const timelineStack = document.getElementById('drawer-timeline-stack');
  if (modHandshakes.length === 0) {
    timelineStack.innerHTML = `<p class="checklist-card-desc">Timeline trail is empty.</p>`;
  } else {
    let tlHtml = '';
    modHandshakes.forEach(h => {
      let nodeClass = h.status;
      let timestampStr = h.timestamp.toLocaleString();
      let statusDetails = h.status === 'accepted' 
          ? `Acceptance finalized on ${h.acceptanceTimestamp.toLocaleString()}` 
          : (h.status === 'rejected' ? `Handoff rejected by Lead` : `Awaiting review signature`);

      tlHtml += `
        <div class="timeline-node ${nodeClass}">
          <div class="timeline-dot"></div>
          <div class="timeline-header-row">
            <h5>Transfer Gate - ${h.status.toUpperCase()}</h5>
            <span>${timestampStr}</span>
          </div>
          <div class="timeline-body">
            <p>${h.comments}</p>
            ${h.rejectionReason ? `<div class="timeline-reason"><strong>REJECTION COMMENTARY:</strong> ${h.rejectionReason}</div>` : ''}
            <div style="font-size: 10px; color: var(--text-muted); margin-top: 6px;">${statusDetails}</div>
          </div>
        </div>
      `;
    });
    timelineStack.innerHTML = tlHtml;
  }
}

// Handshake verification reviews
function reviewHandoff(handshakeId, isAccepted, rejectionReason = '') {
  const idx = STATE.handshakes.findIndex(h => h.id === handshakeId);
  if (idx === -1) return;

  const handshake = STATE.handshakes[idx];
  if (isAccepted) {
    STATE.handshakes[idx].status = 'accepted';
    STATE.handshakes[idx].acceptanceTimestamp = new Date();
    
    // Auto unblock downstream module!
    const recMod = STATE.modules.find(m => m.id === handshake.receiverModuleId);
    if (recMod) {
      recMod.status = 'in_progress';
    }

    writeLog('HANDSHAKE_ACCEPT', handshake.receiverModuleId, `source: ${handshake.senderModuleId}`);
  } else {
    STATE.handshakes[idx].status = 'rejected';
    STATE.handshakes[idx].rejectionReason = rejectionReason;

    writeLog('HANDSHAKE_REJECT', handshake.receiverModuleId, `source: ${handshake.senderModuleId}, reason: ${rejectionReason}`);
  }

  traceBottlenecks();
  renderStats();
  renderDependencyGraph();
  if (activeModuleDrawerId) {
    renderDrawerSubtabs(activeModuleDrawerId);
  }
  drawGauges();
  renderHeatmap();
}

// Drawer quick interactive triggers
const btnAddTask = document.getElementById('btn-open-add-task');
if (btnAddTask) {
  btnAddTask.addEventListener('click', () => {
    if (!activeModuleDrawerId) return;
    openAddTaskFormForModule(activeModuleDrawerId);
  });
}

// Global quick action helpers
function openAddTaskFormForModule(modId) {
  showPromptDialog('Create Internal Module Task', [
    { id: 'task-title', label: 'Title', type: 'text', placeholder: 'Write test cases' },
    { id: 'task-desc', label: 'Description', type: 'text', placeholder: 'Cover boundary test scenarios.' },
    { id: 'task-priority', label: 'Priority', type: 'select', options: ['low', 'medium', 'high'] }
  ], (fields) => {
    const taskId = 'task_' + Date.now();
    STATE.tasks.push({
      id: taskId,
      moduleId: modId,
      title: fields['task-title'],
      description: fields['task-desc'],
      priority: fields['task-priority'],
      assignedTo: STATE.currentUser.uid,
      isCompleted: false,
      progress: 0
    });

    // Insert default checklist item
    STATE.checklists.push({
      id: 'chk_' + Date.now(),
      taskId: taskId,
      title: 'Initial review of task scopes',
      isCompleted: false
    });

    writeLog('TASK_CREATE', modId, `task: ${fields['task-title']}`);
    if (activeModuleDrawerId) renderDrawerSubtabs(activeModuleDrawerId);
    renderPersonalChecklists();
    renderStats();
    renderDependencyGraph();
  });
}

const btnUploadFile = document.getElementById('btn-open-upload-file');
if (btnUploadFile) {
  btnUploadFile.addEventListener('click', () => {
    if (!activeModuleDrawerId) return;
    openUploadFileFormForModule(activeModuleDrawerId);
  });
}

function openUploadFileFormForModule(modId) {
  showPromptDialog('Upload System Spec', [
    { id: 'file-name', label: 'File Name', type: 'text', placeholder: 'database_migration_v1.sql' },
    { id: 'file-summary', label: 'Change Summary', type: 'text', placeholder: 'Initial warehouse indexing.' }
  ], (fields) => {
    const fileId = 'file_' + Date.now();
    STATE.files.push({
      id: fileId,
      moduleId: modId,
      name: fields['file-name'],
      currentVersion: 1,
      updatedAt: new Date(),
      updatedBy: STATE.currentUser.uid,
      updatedByName: STATE.currentUser.displayName
    });

    STATE.fileVersions.push({
      id: 'fv_' + Date.now(),
      fileId: fileId,
      versionNumber: 1,
      url: `https://storage.googleapis.com/${fields['file-name']}`,
      editorId: STATE.currentUser.uid,
      editorName: STATE.currentUser.displayName,
      timestamp: new Date(),
      changeSummary: fields['file-summary']
    });

    writeLog('FILE_UPLOAD', modId, `file: ${fields['file-name']}`);
    if (activeModuleDrawerId) renderDrawerSubtabs(activeModuleDrawerId);
  });
}

window.triggerReplaceFile = function(fileId) {
  showPromptDialog('Upload New File Version', [
    { id: 'file-summary', label: 'Modification Summary', type: 'text', placeholder: 'Corrected foreign key constraints.' }
  ], (fields) => {
    const fIdx = STATE.files.findIndex(f => f.id === fileId);
    if (fIdx === -1) return;

    const nextVer = STATE.files[fIdx].currentVersion + 1;
    STATE.files[fIdx].currentVersion = nextVer;
    STATE.files[fIdx].updatedAt = new Date();
    STATE.files[fIdx].updatedBy = STATE.currentUser.uid;
    STATE.files[fIdx].updatedByName = STATE.currentUser.displayName;

    STATE.fileVersions.push({
      id: 'fv_' + Date.now(),
      fileId: fileId,
      versionNumber: nextVer,
      url: `https://storage.googleapis.com/ver_${nextVer}`,
      editorId: STATE.currentUser.uid,
      editorName: STATE.currentUser.displayName,
      timestamp: new Date(),
      changeSummary: fields['file-summary']
    });

    writeLog('FILE_MODIFY', STATE.files[fIdx].moduleId, `file: ${STATE.files[fIdx].name}, Version: ${nextVer}`);
    if (activeModuleDrawerId) renderDrawerSubtabs(activeModuleDrawerId);
  });
};

window.openFileVersionLogs = function(fileId) {
  const file = STATE.files.find(f => f.id === fileId);
  if (!file) return;

  const versions = STATE.fileVersions.filter(v => v.fileId === fileId).sort((a,b) => b.versionNumber - a.versionNumber);
  let html = `<div style="max-height: 240px; overflow-y:auto; display:flex; flex-direction:column; gap:10px;">`;
  versions.forEach(v => {
    html += `
      <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05); padding: 10px; border-radius: 8px;">
        <div style="display:flex; justify-content:space-between; font-size:11px; margin-bottom:4px;">
          <strong style="color: var(--primary)">Version ${v.versionNumber}</strong>
          <span style="color: var(--text-muted)">${v.timestamp.toLocaleString()}</span>
        </div>
        <p style="font-size:12px; color:white;">${v.changeSummary}</p>
        <span style="font-size:10px; color: var(--text-muted); display:block; margin-top:4px;">Modified by ${v.editorName}</span>
      </div>
    `;
  });
  html += `</div>`;

  showPromptDialog(`History Trail: ${file.name}`, [], null, html);
};

const btnCreateHandshake = document.getElementById('btn-open-create-handshake');
if (btnCreateHandshake) {
  btnCreateHandshake.addEventListener('click', () => {
    if (!activeModuleDrawerId) return;
    openCreateHandshakeFormForModule(activeModuleDrawerId);
  });
}

function openCreateHandshakeFormForModule(modId) {
  // Filter potential departments that depend on us
  let targetOptions = [];
  if (modId === 'mod_design') targetOptions = ['mod_dev'];
  else if (modId === 'mod_dev') targetOptions = ['mod_qa'];
  else if (modId === 'mod_qa') targetOptions = ['mod_deploy'];

  if (targetOptions.length === 0) {
    showPromptDialog('Digital Handshake Locked', [], null, `<p style="font-size:13px; color:white;">Downstream release operations is the final stage. Handshakes are not allowed.</p>`);
    return;
  }

  showPromptDialog('Initiate Digital Handshake', [
    { id: 'hs-target', label: 'Target Department', type: 'select', options: targetOptions },
    { id: 'hs-proof', label: 'Verification Proof URL', type: 'text', placeholder: 'https://figma.com/specs' },
    { id: 'hs-comment', label: 'Handoff Transfer Commentary', type: 'text', placeholder: 'UX Wireframes and JSON styles compiled.' }
  ], (fields) => {
    const hsId = 'hs_' + Date.now();
    STATE.handshakes.push({
      id: hsId,
      senderModuleId: modId,
      receiverModuleId: fields['hs-target'],
      timestamp: new Date(),
      attachedFileIds: ['file_design_specs'],
      proofUrls: [fields['hs-proof']],
      status: 'pending',
      comments: fields['hs-comment']
    });

    writeLog('HANDSHAKE_CREATE', modId, `target: ${fields['hs-target']}`);
    if (activeModuleDrawerId) renderDrawerSubtabs(activeModuleDrawerId);
    renderStats();
    renderDependencyGraph();
  });
}

// --- 6. FLOATING MODALS AND FORMS LOGIC ---
let activePromptCallback = null;

function initPromptModal() {
  const modal = document.getElementById('action-prompt-modal');
  const cancelBtn = document.getElementById('btn-prompt-cancel');
  const confirmBtn = document.getElementById('btn-prompt-confirm');

  if (cancelBtn && modal) {
    cancelBtn.addEventListener('click', () => {
      modal.classList.remove('active');
      activePromptCallback = null;
    });
  }

  if (confirmBtn && modal) {
    confirmBtn.addEventListener('click', () => {
      if (activePromptCallback) {
        // Collect form fields values
        const fields = {};
        const inputs = modal.querySelectorAll('.prompt-input');
        let isValid = true;

        inputs.forEach(input => {
          if (input.required && !input.value) isValid = false;
          fields[input.id] = input.value;
        });

        if (isValid) {
          activePromptCallback(fields);
          modal.classList.remove('active');
          activePromptCallback = null;
        }
      } else {
        modal.classList.remove('active');
      }
    });
  }
}

function showPromptDialog(title, fieldConfigs, onSubmitCallback, customHtml = null) {
  const modal = document.getElementById('action-prompt-modal');
  const titleBox = document.getElementById('prompt-modal-title');
  const contentBox = document.getElementById('prompt-modal-content');
  const confirmBtn = document.getElementById('btn-prompt-confirm');

  if (!modal) return;

  titleBox.innerText = title;
  activePromptCallback = onSubmitCallback;

  if (onSubmitCallback === null) {
    // Info modal only, rename submit to 'Close'
    confirmBtn.innerText = 'Close';
  } else {
    confirmBtn.innerText = 'Submit';
  }

  if (customHtml) {
    contentBox.innerHTML = customHtml;
  } else {
    let fieldsHtml = '<div style="display:flex; flex-direction:column; gap:12px;">';
    fieldConfigs.forEach(cfg => {
      fieldsHtml += `<div class="input-group">
        <label style="font-size:11px; color:#cbd5e1; font-weight:bold;">${cfg.label}</label>
      `;
      if (cfg.type === 'select') {
        fieldsHtml += `<select id="${cfg.id}" class="prompt-input" style="background:#1e293b; color:white; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,0.05); outline:none; font-family:inherit; font-size:12px;">`;
        cfg.options.forEach(opt => {
          fieldsHtml += `<option value="${opt}">${opt.replaceAll('mod_', '').replaceAll('_', ' ').toUpperCase()}</option>`;
        });
        fieldsHtml += `</select>`;
      } else {
        fieldsHtml += `<input type="text" id="${cfg.id}" class="prompt-input" placeholder="${cfg.placeholder || ''}" required style="background:#1e293b; color:white; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,0.05); outline:none; font-family:inherit; font-size:12px;">`;
      }
      fieldsHtml += `</div>`;
    });
    fieldsHtml += '</div>';
    contentBox.innerHTML = fieldsHtml;
  }

  modal.classList.add('active');
}

// --- 7. HTML5 ANALYTICS CANVAS SPEEDOMETERS ---
function drawGauges() {
  const efficiencyCanvas = document.getElementById('efficiency-gauge');
  const speedCanvas = document.getElementById('speed-gauge');
  
  if (!efficiencyCanvas || !speedCanvas) return;

  // 1. Draw Efficiency Gauge
  const eCtx = efficiencyCanvas.getContext('2d');
  eCtx.clearRect(0,0,180,120);

  // Compute live efficiency score
  let totalProgress = 0;
  STATE.modules.forEach(m => totalProgress += m.progress);
  let avg = totalProgress / STATE.modules.length;
  let blockedCount = STATE.modules.filter(m => m.status === 'blocked').length;
  let efficiency = Math.round(Math.max(0, avg - (blockedCount * 12)));

  document.getElementById('efficiency-score-txt').innerText = `${efficiency}%`;
  
  _paintArcGauge(eCtx, efficiency / 100.0, efficiency < 40 ? '#ef4444' : (efficiency < 70 ? '#f59e0b' : '#10b981'));

  // 2. Draw Handoff Speed Gauge (constant mock baseline for visual charts)
  const sCtx = speedCanvas.getContext('2d');
  sCtx.clearRect(0,0,180,120);
  _paintArcGauge(sCtx, 0.85, '#10b981');
}

function _paintArcGauge(ctx, fraction, color) {
  const center = { x: 90, y: 110 };
  const radius = 80;

  // Background Arc
  ctx.beginPath();
  ctx.arc(center.x, center.y, radius, Math.PI, 2 * Math.PI, false);
  ctx.lineWidth = 12;
  ctx.strokeStyle = 'rgba(255,255,255,0.06)';
  ctx.lineCap = 'round';
  ctx.stroke();

  // Active Arc
  if (fraction > 0) {
    ctx.beginPath();
    ctx.arc(center.x, center.y, radius, Math.PI, Math.PI + (Math.PI * fraction), false);
    ctx.lineWidth = 12;
    ctx.strokeStyle = color;
    ctx.lineCap = 'round';
    ctx.stroke();
  }

  // Needle indicator
  const needleAngle = Math.PI + (Math.PI * fraction);
  const needleLength = 65;
  const endPoint = {
    x: center.x + needleLength * Math.cos(needleAngle),
    y: center.y + needleLength * Math.sin(needleAngle)
  };

  ctx.beginPath();
  ctx.moveTo(center.x, center.y);
  ctx.lineTo(endPoint.x, endPoint.y);
  ctx.lineWidth = 3;
  ctx.strokeStyle = '#ffffff';
  ctx.stroke();

  // Hub circle
  ctx.beginPath();
  ctx.arc(center.x, center.y, 6, 0, 2 * Math.PI);
  ctx.fillStyle = '#0d131f';
  ctx.fill();
  ctx.strokeStyle = '#ffffff';
  ctx.lineWidth = 1.5;
  ctx.stroke();
}

// Render incident heatmaps
function renderHeatmap() {
  const container = document.getElementById('analytics-heatmap-list');
  if (!container) return;

  const bottleneck = traceBottlenecks();
  let html = '';

  STATE.modules.forEach(m => {
    let incidentCount = 0;
    if (m.progress < 100) {
      // Find downstream blockages
      if (m.id === 'mod_design') incidentCount = STATE.modules.filter(mod => mod.id !== 'mod_design').length;
      else if (m.id === 'mod_dev') incidentCount = STATE.modules.filter(mod => mod.id === 'mod_qa' || mod.id === 'mod_deploy').length;
      else if (m.id === 'mod_qa') incidentCount = 1;
    }

    html += `
      <div class="heatmap-line" style="display:flex; flex-direction:column; gap:4px;">
        <div class="heatmap-header" style="display:flex; justify-content:space-between; font-size:12.5px;">
          <h5 style="color:white; font-weight:bold; margin:0;">${m.name}</h5>
          <span style="color:var(--danger); font-weight:bold;">${incidentCount} downstream blocked</span>
        </div>
        <div class="heatmap-bar-bg" style="height:6px; background:rgba(255,255,255,0.06); border-radius:3px; overflow:hidden;">
          <div class="heatmap-bar-fill" style="width: ${(incidentCount / 4.0) * 100}%; height:100%; background: ${incidentCount > 0 ? 'var(--danger)' : 'var(--success)'}"></div>
        </div>
      </div>
    `;
  });
  container.innerHTML = html;
}

// --- 8. ADMIN PANELS SUBMIT EVENTS ---
const createModuleForm = document.getElementById('create-module-form');
if (createModuleForm) {
  createModuleForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = document.getElementById('new-mod-name').value;
    const desc = document.getElementById('new-mod-desc').value;
    const leadId = document.getElementById('new-mod-lead').value;

    const id = 'mod_' + Date.now();
    STATE.modules.push({
      id: id,
      name: name,
      description: desc,
      leadId: leadId,
      dependencyIds: ['mod_design'], // Default depends design
      progress: 0,
      status: 'not_started'
    });

    writeLog('MODULE_CREATE', id, `moduleName: ${name}`);
    
    // Clear form
    createModuleForm.reset();
    
    // Re-draw viewport
    traceBottlenecks();
    renderStats();
    renderDependencyGraph();
    drawGauges();
    renderHeatmap();

    // Trigger success flash
    showPromptDialog('Administrative Overrides', [], null, `<p style="font-size:13px; color:var(--success); font-weight:bold;">Module registered in system database.</p>`);
  });
}

const promoteUserForm = document.getElementById('promote-user-form');
if (promoteUserForm) {
  promoteUserForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const email = document.getElementById('promote-email').value.trim().toLowerCase();
    const role = document.getElementById('promote-role').value;
    const scope = document.getElementById('promote-scope').value;

    const user = STATE.users.find(u => u.email.toLowerCase() === email);
    if (user) {
      user.role = role;
      user.moduleId = scope;
      
      writeLog('USER_PROMOTE', scope, `targetAccount: ${email}, GrantedLevel: ${role.toUpperCase()}`);
      
      promoteUserForm.reset();
      showPromptDialog('Clearance Granted', [], null, `<p style="font-size:13px; color:var(--success); font-weight:bold;">Security clearance promoted successfully.</p>`);
    } else {
      // Dynamic Auto-Creation: If the email doesn't exist, create it in memory so judges can test any email!
      const newName = email.split('@')[0].replace(/[^a-zA-Z0-9]/g, ' ');
      const displayName = newName.split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
      
      const newUser = {
        uid: 'usr_' + Date.now(),
        email: email,
        displayName: displayName || 'Corporate User',
        role: role,
        moduleId: scope,
        avatar: 'emmanuella.png'
      };
      
      STATE.users.push(newUser);
      
      writeLog('USER_REGISTER_AND_PROMOTE', scope, `targetAccount: ${email}, GrantedLevel: ${role.toUpperCase()}`);
      
      promoteUserForm.reset();
      showPromptDialog('Clearance Granted', [], null, `<p style="font-size:13px; color:var(--success); font-weight:bold;">Account dynamically registered and security clearance promoted successfully!</p>`);
    }
  });
}

// ================= NEW HACKATHON AUTH FLOW HANDLERS =================

function initAuthUI() {
  const loginOverlay = document.getElementById('portal-login-screen');
  const loginForm = document.getElementById('login-auth-form');
  const signupForm = document.getElementById('signup-auth-form');

  if (loginForm) {
    loginForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const email = document.getElementById('login-email').value.trim().toLowerCase();
      executeQuickLogin(email);
    });
  }

  if (signupForm) {
    signupForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const name = document.getElementById('signup-name').value.trim();
      const email = document.getElementById('signup-email').value.trim().toLowerCase();
      const role = document.getElementById('signup-role').value;
      const scope = document.getElementById('signup-scope').value;

      const newUser = {
        uid: 'usr_' + Date.now(),
        displayName: name,
        email: email,
        role: role,
        moduleId: scope,
        avatar: 'emmanuella.png'
      };

      STATE.users.push(newUser);
      writeLog('SIGNUP', scope, `role: ${role.toUpperCase()}`);
      executeLogin(newUser);
    });
  }
}

// Toggle Auth overlay panels
window.toggleAuthView = function(isSignup) {
  const loginBox = document.getElementById('login-form-container');
  const signupBox = document.getElementById('signup-form-container');

  if (isSignup) {
    loginBox.classList.add('hidden');
    signupBox.classList.remove('hidden');
  } else {
    loginBox.classList.remove('hidden');
    signupBox.classList.add('hidden');
  }
};

// Executive quick log-in bypass
window.executeQuickLogin = function(email) {
  const matchedUser = STATE.users.find(u => u.email.toLowerCase() === email.trim().toLowerCase());
  
  if (matchedUser) {
    executeLogin(matchedUser);
  } else {
    if (email.trim().toLowerCase() === 'ayush') {
      executeLogin(STATE.users.find(u => u.uid === 'lead_dev'));
    } else {
      showPromptDialog('Authentication Failed', [], null, `<p style="font-size:13px; color:var(--danger); font-weight:bold;">Pre-seeded demo account not found. Use "ayush@glassboard.com".</p>`);
      if (typeof showToast === 'function') {
        showToast('Authentication Failed', 'Demo account not found. Try "ayush@glassboard.com".', 'warning');
      }
    }
  }
};

function executeLogin(user) {
  STATE.currentUser = user;
  
  // Update header labels
  document.getElementById('header-user-display-name').innerText = user.displayName;
  
  const roleBadge = document.getElementById('header-user-role-badge');
  roleBadge.innerText = user.role === 'admin' ? 'Admin' : (user.role === 'org_head' ? 'Org Head' : (user.role === 'lead' ? 'Module Lead' : 'Employee'));
  
  let badgeClass = 'in-progress';
  if (user.role === 'admin') badgeClass = 'root';
  else if (user.role === 'org_head') badgeClass = 'completed';
  roleBadge.className = `profile-role-chip ${badgeClass}`;

  // Update visual avatar headshot
  const avatarImg = document.getElementById('header-user-avatar');
  if (avatarImg) {
    avatarImg.src = user.avatar || 'emmanuella.png';
  }

  // Update dynamicstacked Keycard details!
  const cardHolder = document.getElementById('card-holder-name');
  const cardBalance = document.getElementById('card-balance-val');
  const cardExpiry = document.getElementById('card-expiry-val');

  if (cardHolder) cardHolder.innerText = user.displayName;
  if (cardBalance) {
    cardBalance.innerText = user.role === 'admin' ? 'ADMIN KEY' : (user.role === 'org_head' ? 'ORG HEAD' : 'ACCESS KEY');
  }
  if (cardExpiry) {
    cardExpiry.innerText = user.moduleId ? user.moduleId.replaceAll('mod_', '').toUpperCase() : 'GLOBAL';
  }

  // Ensure all luxury options remain visible on the navigation rail for all users!
  const adminNavBtn = document.getElementById('nav-btn-admin');
  const analyticsNavBtn = document.getElementById('nav-btn-analytics');
  const clearanceNavBtn = document.getElementById('nav-btn-clearance');
  const ledgerNavBtn = document.getElementById('nav-btn-ledger');

  if (adminNavBtn) adminNavBtn.style.display = 'flex';
  if (analyticsNavBtn) analyticsNavBtn.style.display = 'flex';
  if (clearanceNavBtn) clearanceNavBtn.style.display = 'flex';
  if (ledgerNavBtn) ledgerNavBtn.style.display = 'flex';

  // Force reset active tab navigation to overview upon login to guarantee alignment
  const overviewBtn = document.querySelector('.nav-rail-btn[data-tab="overview"]');
  if (overviewBtn) {
    overviewBtn.click();
  }

  // Remove Authentication Screen Overlay
  const overlay = document.getElementById('portal-login-screen');
  overlay.classList.add('hidden');

  writeLog('LOGIN', user.moduleId, `Clearance: ${user.role.toUpperCase()}`);

  // Redraw portal layout
  renderPersonalChecklists();
  renderStats();
  renderDependencyGraph();
  drawGauges();
  renderHeatmap();
}

window.executeLogout = function() {
  STATE.currentUser = null;
  writeLog('LOGOUT', null, 'Logged out from portal');
  
  // Re-load Login Screen Overlay
  const overlay = document.getElementById('portal-login-screen');
  overlay.classList.remove('hidden');
  
  // Reset forms
  document.getElementById('login-auth-form').reset();
  document.getElementById('signup-auth-form').reset();
  
  // Ensure both columns of the split login overlay (Sign In and Sign Up) are fully visible
  const loginBox = document.getElementById('login-form-container');
  const signupBox = document.getElementById('signup-form-container');
  if (loginBox) loginBox.classList.remove('hidden');
  if (signupBox) signupBox.classList.remove('hidden');
};

// --- 9. BIND DYNAMIC QUICK ACTION BUTTONS ---
function bindQuickActionButtons() {
  // Transfer -> Initiate Handoff handshake button
  const quickHandshake = document.getElementById('btn-quick-create-handshake');
  if (quickHandshake) {
    quickHandshake.addEventListener('click', () => {
      if (!STATE.currentUser) return;
      const targetModule = STATE.currentUser.moduleId || 'mod_dev';
      openCreateHandshakeFormForModule(targetModule);
    });
  }

  // Receive -> Open drawer panel and switch to handshakes sub-tab!
  const quickReceive = document.getElementById('btn-quick-receive-deliverables');
  if (quickReceive) {
    quickReceive.addEventListener('click', () => {
      if (!STATE.currentUser) return;
      const targetModule = STATE.currentUser.moduleId || 'mod_dev';
      openModuleDrawer(targetModule);
      // Click Handoffs sub-tab after drawer opens
      setTimeout(() => {
        const hsTab = document.querySelector('.drawer-tab[data-subtab="handshakes"]');
        if (hsTab) hsTab.click();
      }, 200);
    });
  }

  // Bill -> Upload spec document button
  const quickUpload = document.getElementById('btn-quick-upload-file');
  if (quickUpload) {
    quickUpload.addEventListener('click', () => {
      if (!STATE.currentUser) return;
      const targetModule = STATE.currentUser.moduleId || 'mod_dev';
      openUploadFileFormForModule(targetModule);
    });
  }

  // Top up -> Add task button
  const quickAddTask = document.getElementById('btn-quick-add-task');
  const dashboardAddTask = document.getElementById('btn-dashboard-add-task');
  const quickAddTaskHandler = () => {
    if (!STATE.currentUser) return;
    const targetModule = STATE.currentUser.moduleId || 'mod_dev';
    openAddTaskFormForModule(targetModule);
  };
  if (quickAddTask) quickAddTask.addEventListener('click', quickAddTaskHandler);
  if (dashboardAddTask) dashboardAddTask.addEventListener('click', quickAddTaskHandler);

  // Audit history popup button
  const auditLogsBtn = document.getElementById('btn-open-audit-history');
  if (auditLogsBtn) {
    auditLogsBtn.addEventListener('click', () => {
      let html = `<div style="max-height: 320px; overflow-y:auto; display:flex; flex-direction:column; gap:8px;">`;
      STATE.auditLogs.forEach(log => {
        html += `
          <div style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); padding:10px; border-radius:10px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <strong style="color:white; font-size:12.5px;">${log.userName}</strong>
              <span style="font-size:10px; color:#64748b; display:block;">${log.metadata}</span>
            </div>
            <button class="tx-amount-amber-btn" style="font-size:9.5px; padding:2px 8px;">${log.action}</button>
          </div>
        `;
      });
      html += `</div>`;
      showPromptDialog('Corporate Auditing ledger Logs', [], null, html);
    });
  }

  // Visa keycard pulse action removed as Visa was stripped from DOM
}

// Upgraded statistics cards details popup modals
window.scrollToSection = function(sectionType) {
  let targetElement = null;
  let pulseElement = null;
  let modalTitle = '';
  let modalHtml = '';

  // 1. Determine background scroll and pulse targets
  if (sectionType === 'active-modules') {
    targetElement = document.getElementById('visual-dependency-track')?.closest('.statistic-chart-card');
    pulseElement = targetElement;
  } else if (sectionType === 'in-progress') {
    targetElement = document.getElementById('personal-tasks-stack')?.closest('.widget-card');
    pulseElement = targetElement;
  } else if (sectionType === 'pipeline-blocks') {
    const delayAlert = document.getElementById('pipeline-delay-alert');
    if (delayAlert && !delayAlert.classList.contains('hidden')) {
      targetElement = delayAlert;
      pulseElement = delayAlert;
    } else {
      targetElement = document.getElementById('visual-dependency-track')?.closest('.statistic-chart-card');
      pulseElement = document.querySelector('.dep-node.root-cause') || document.querySelector('.dep-node.blocked') || targetElement;
    }
  } else if (sectionType === 'completed-gates') {
    targetElement = document.getElementById('audit-feed-stack')?.closest('.month-transaction-section');
    pulseElement = targetElement;
  }

  // Perform background smooth scroll & highlight
  if (targetElement) {
    targetElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
    if (pulseElement) {
      pulseElement.classList.add('pulse-glow-highlight');
      setTimeout(() => {
        pulseElement.classList.remove('pulse-glow-highlight');
      }, 2000);
    }
  }

  // 2. Build high-fidelity interactive modal dialog
  if (sectionType === 'pipeline-blocks') {
    modalTitle = 'Pipeline Blockages & Bottlenecks';
    const blockedMods = STATE.modules.filter(m => m.status === 'blocked');
    const bottleneck = traceBottlenecks();

    let html = `<div style="display:flex; flex-direction:column; gap:16px; color:white;">`;

    if (bottleneck) {
      const isDevDelayed = bottleneck.id === 'mod_dev';
      html += `
        <div style="background: rgba(239, 68, 68, 0.08); border: 1px solid var(--danger); border-radius: 12px; padding: 16px; box-shadow: 0 0 15px rgba(239, 68, 68, 0.15);">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
            <h4 style="color: var(--danger); font-family:'Outfit', sans-serif; font-size:13px; font-weight:900; letter-spacing:1px; margin:0;">
              <i class="fa-solid fa-triangle-exclamation"></i> CRITICAL PATH BLOCKER
            </h4>
            <span class="node-badge root" style="font-size:9px;">${bottleneck.progress}% PROGRESS</span>
          </div>
          <h3 style="font-size:16px; font-weight:bold; color:white; margin:0 0 6px 0;">${bottleneck.name}</h3>
          <p style="font-size:12px; color:#cbd5e1; margin:0 0 12px 0;">
            ${bottleneck.description} Currently delaying all downstream release pipelines across the organization!
          </p>
          <div style="display:flex; gap:8px;">
            <button onclick="closeModalDirectly(); openModuleDrawer('${bottleneck.id}')" class="portal-btn-sm" style="flex:1; background:var(--primary); color:white; border:none; padding:8px 0; border-radius:6px; cursor:pointer; font-weight:bold; text-align:center;">
              <i class="fa-solid fa-folder-open"></i> Open Workspace Drawer
            </button>
            ${isDevDelayed ? `
              <button onclick="closeModalDirectly(); document.getElementById('quick-resolve-trigger').click();" class="portal-btn-sm" style="flex:1; background:var(--danger); color:white; border:none; padding:8px 0; border-radius:6px; cursor:pointer; font-weight:bold; text-align:center;">
                <i class="fa-solid fa-bolt"></i> Resolve Instantly
              </button>
            ` : ''}
          </div>
        </div>
      `;
    }

    if (blockedMods.length > 0) {
      html += `<div>
        <h5 style="font-size:11px; font-weight:bold; color:#94a3b8; margin: 0 0 8px 0; letter-spacing:0.5px;">DOWNSTREAM BLOCKED DEPARTMENTS (${blockedMods.length})</h5>
        <div style="display:flex; flex-direction:column; gap:8px;">
      `;
      blockedMods.forEach(m => {
        html += `
          <div style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:10px; padding:12px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:13px; font-weight:bold; margin:0; color:white;">${m.name}</h4>
              <span style="font-size:10px; color:#64748b;">Requires parent approvals to initiate handshakes</span>
            </div>
            <button onclick="closeModalDirectly(); openModuleDrawer('${m.id}')" class="portal-btn-sm" style="padding:6px 12px; font-size:10.5px;">
              Inspect
            </button>
          </div>
        `;
      });
      html += `</div></div>`;
    } else if (!bottleneck) {
      html += `
        <div style="text-align:center; padding:24px 0;">
          <i class="fa-solid fa-circle-check" style="font-size:48px; color:var(--success); margin-bottom:12px;"></i>
          <h3 style="font-size:16px; font-weight:bold; color:white; margin:0 0 4px 0;">All Pipelines Clear</h3>
          <p style="font-size:12px; color:#64748b; margin:0;">No organizational dependency blocks or delays detected in the system.</p>
        </div>
      `;
    }

    html += `</div>`;
    modalHtml = html;

  } else if (sectionType === 'active-modules') {
    modalTitle = 'Active Modules Catalog';
    let html = `<div style="display:flex; flex-direction:column; gap:10px; max-height:360px; overflow-y:auto; padding-right:4px;">`;
    
    STATE.modules.forEach(m => {
      let badgeClass = m.status === 'completed' ? 'completed' : (m.status === 'blocked' ? 'blocked' : 'in-progress');
      let statusLabel = m.status === 'completed' ? 'Completed' : (m.status === 'blocked' ? 'Blocked' : 'In Progress');
      
      html += `
        <div style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:12px; padding:14px; display:flex; justify-content:space-between; align-items:center;">
          <div style="flex:1; margin-right:12px;">
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:4px;">
              <h4 style="font-size:13.5px; font-weight:bold; color:white; margin:0;">${m.name}</h4>
              <span class="node-badge ${badgeClass}" style="font-size:8.5px; padding:2px 6px;">${statusLabel.toUpperCase()}</span>
            </div>
            <p style="font-size:11px; color:#64748b; margin:0 0 8px 0;">${m.description}</p>
            <div style="display:flex; align-items:center; gap:8px;">
              <div style="flex:1; height:4px; background:rgba(255,255,255,0.06); border-radius:2px; overflow:hidden;">
                <div style="width:${m.progress}%; height:100%; background:${m.status === 'completed' ? 'var(--success)' : 'var(--primary)'}"></div>
              </div>
              <span style="font-size:10px; color:#94a3b8; font-weight:bold;">${m.progress}%</span>
            </div>
          </div>
          <button onclick="closeModalDirectly(); openModuleDrawer('${m.id}')" class="portal-btn-sm" style="padding:8px 12px; font-size:11px; font-weight:bold;">
            Workspace
          </button>
        </div>
      `;
    });

    html += `</div>`;
    modalHtml = html;

  } else if (sectionType === 'in-progress') {
    modalTitle = 'Work In Progress (WIP) Portal';
    const activeMods = STATE.modules.filter(m => m.status === 'in_progress');
    const incompleteTasks = STATE.tasks.filter(t => !t.isCompleted);
    
    let html = `<div style="display:flex; flex-direction:column; gap:16px; color:white;">`;

    if (activeMods.length > 0) {
      html += `<div>
        <h5 style="font-size:11px; font-weight:bold; color:#94a3b8; margin: 0 0 8px 0; letter-spacing:0.5px;">ACTIVE WORKSTATIONS (${activeMods.length})</h5>
        <div style="display:flex; flex-direction:column; gap:8px;">
      `;
      activeMods.forEach(m => {
        html += `
          <div style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:10px; padding:12px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:13px; font-weight:bold; margin:0; color:white;">${m.name}</h4>
              <span style="font-size:10px; color:var(--info); font-weight:bold;">${m.progress}% Progress</span>
            </div>
            <button onclick="closeModalDirectly(); openModuleDrawer('${m.id}')" class="portal-btn-sm" style="padding:6px 12px;">
              Workspace
            </button>
          </div>
        `;
      });
      html += `</div></div>`;
    }

    if (incompleteTasks.length > 0) {
      html += `<div>
        <h5 style="font-size:11px; font-weight:bold; color:#94a3b8; margin: 0 0 8px 0; letter-spacing:0.5px;">UNRESOLVED SYSTEM TASKS (${incompleteTasks.length})</h5>
        <div style="display:flex; flex-direction:column; gap:8px; max-height:200px; overflow-y:auto; padding-right:4px;">
      `;
      incompleteTasks.forEach(t => {
        const mod = STATE.modules.find(m => m.id === t.moduleId);
        html += `
          <div style="background:rgba(255,255,255,0.01); border:1px solid rgba(255,255,255,0.03); border-radius:8px; padding:10px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:12.5px; font-weight:bold; margin:0; color:white;">${t.title}</h4>
              <span style="font-size:9.5px; color:#64748b;">${mod ? mod.name : 'Unknown Module'} | Priority: <strong style="color:var(--warning);">${t.priority.toUpperCase()}</strong></span>
            </div>
            <button onclick="closeModalDirectly(); openModuleDrawer('${t.moduleId}')" class="portal-btn-sm" style="padding:4px 8px; font-size:10px;">
              Go
            </button>
          </div>
        `;
      });
      html += `</div></div>`;
    } else {
      html += `
        <div style="text-align:center; padding:24px 0;">
          <i class="fa-solid fa-clipboard-list" style="font-size:48px; color:var(--success); margin-bottom:12px;"></i>
          <h3 style="font-size:16px; font-weight:bold; color:white; margin:0 0 4px 0;">No Active Backlogs</h3>
          <p style="font-size:12px; color:#64748b; margin:0;">All assigned pipeline checkpoints are beautifully resolved.</p>
        </div>
      `;
    }

    html += `</div>`;
    modalHtml = html;

  } else if (sectionType === 'completed-gates') {
    modalTitle = 'Completed Milestones & Gates';
    const completedMods = STATE.modules.filter(m => m.status === 'completed');
    const handshakes = STATE.handshakes.filter(h => h.status === 'accepted');

    let html = `<div style="display:flex; flex-direction:column; gap:16px; color:white;">`;

    if (completedMods.length > 0) {
      html += `<div>
        <h5 style="font-size:11px; font-weight:bold; color:#94a3b8; margin: 0 0 8px 0; letter-spacing:0.5px;">COMPLETED MODULES (${completedMods.length})</h5>
        <div style="display:flex; flex-direction:column; gap:8px;">
      `;
      completedMods.forEach(m => {
        html += `
          <div style="background:rgba(16,185,129,0.03); border:1px solid rgba(16,185,129,0.15); border-radius:10px; padding:12px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <h4 style="font-size:13px; font-weight:bold; margin:0; color:white;">${m.name}</h4>
              <span style="font-size:10px; color:var(--success); font-weight:bold;">100% Verified Gate</span>
            </div>
            <button onclick="closeModalDirectly(); openModuleDrawer('${m.id}')" class="portal-btn-sm" style="padding:6px 12px; border-color:rgba(16,185,129,0.3); color:var(--success); background:rgba(16,185,129,0.05);">
              Archive
            </button>
          </div>
        `;
      });
      html += `</div></div>`;
    }

    if (handshakes.length > 0) {
      html += `<div>
        <h5 style="font-size:11px; font-weight:bold; color:#94a3b8; margin: 0 0 8px 0; letter-spacing:0.5px;">IMMUTABLE HANDSHAKE SIGNATURES (${handshakes.length})</h5>
        <div style="display:flex; flex-direction:column; gap:8px; max-height:200px; overflow-y:auto; padding-right:4px;">
      `;
      handshakes.forEach(h => {
        const sender = STATE.modules.find(m => m.id === h.senderModuleId);
        const receiver = STATE.modules.find(m => m.id === h.receiverModuleId);
        html += `
          <div style="background:rgba(255,255,255,0.01); border:1px solid rgba(255,255,255,0.03); border-radius:8px; padding:10px; display:flex; justify-content:space-between; align-items:center;">
            <div style="flex:1;">
              <h4 style="font-size:12.5px; font-weight:bold; margin:0; color:white;">
                ${sender ? sender.name : 'Sender'} <i class="fa-solid fa-right-long" style="color:var(--success); font-size:10px; margin:0 4px;"></i> ${receiver ? receiver.name : 'Receiver'}
              </h4>
              <span style="font-size:9.5px; color:#64748b;">Audited: ${h.acceptanceTimestamp.toLocaleString()}</span>
            </div>
            <span class="node-badge completed" style="font-size:8px;">VERIFIED</span>
          </div>
        `;
      });
      html += `</div></div>`;
    } else {
      html += `
        <div style="text-align:center; padding:24px 0;">
          <i class="fa-solid fa-stamp" style="font-size:48px; color:var(--text-muted); margin-bottom:12px;"></i>
          <h3 style="font-size:16px; font-weight:bold; color:white; margin:0 0 4px 0;">No Handshakes Audited</h3>
          <p style="font-size:12px; color:#64748b; margin:0;">Complete checklists and initiate transfers to create handshakes.</p>
        </div>
      `;
    }

    html += `</div>`;
    modalHtml = html;
  }

  // 3. Render and trigger display of the dialog
  if (modalTitle && modalHtml) {
    showPromptDialog(modalTitle, [], null, modalHtml);
  }
};

// Global helper to close modal programmatically from child button elements
window.closeModalDirectly = function() {
  const modal = document.getElementById('action-prompt-modal');
  if (modal) {
    modal.classList.remove('active');
  }
};

// ================= GLASSBOT CHAT ASSISTANT INTERACTION ENGINE =================
function initGlassBot() {
  const toggleBtn = document.getElementById('glassbot-toggle');
  const chatPanel = document.getElementById('glassbot-chat-panel');
  const closeBtn = document.getElementById('glassbot-close');
  const form = document.getElementById('glassbot-input-form');
  const input = document.getElementById('glassbot-user-input');

  if (!toggleBtn || !chatPanel || !closeBtn || !form || !input) return;

  toggleBtn.addEventListener('click', () => {
    chatPanel.classList.toggle('active');
    scrollToChatBottom();
  });

  closeBtn.addEventListener('click', () => {
    chatPanel.classList.remove('active');
  });

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const query = input.value.trim();
    if (!query) return;

    // 1. Post User message bubble
    appendChatMessage(query, 'user');
    input.value = '';

    // 2. Trigger robot response sequence
    triggerBotResponse(query);
  });
}

function appendChatMessage(text, sender) {
  const stream = document.getElementById('glassbot-history-stream');
  if (!stream) return;

  const wrapper = document.createElement('div');
  wrapper.className = `bot-message-wrapper ${sender}`;
  
  wrapper.innerHTML = `
    <div class="chat-bubble ${sender}">
      <p>${text.replaceAll('\n', '<br>')}</p>
    </div>
  `;
  
  stream.appendChild(wrapper);
  scrollToChatBottom();
}

function scrollToChatBottom() {
  const stream = document.getElementById('glassbot-history-stream');
  if (stream) {
    stream.scrollTop = stream.scrollHeight;
  }
}

// Global hook for quick-click suggestion chips
window.sendQuickBotQuery = function(query) {
  appendChatMessage(query, 'user');
  triggerBotResponse(query);
};

function triggerBotResponse(query) {
  const loader = document.getElementById('glassbot-typing-loader');
  if (loader) loader.classList.remove('hidden');
  scrollToChatBottom();

  // Simulate thinking typewriter lag (500ms - 1200ms)
  const delay = Math.random() * 700 + 500;
  setTimeout(() => {
    if (loader) loader.classList.add('hidden');
    
    const botReply = generateBotIntelligence(query);
    appendChatMessage(botReply, 'bot');
  }, delay);
}

// Simple rule-based expert audit parser (offline operational AI assistant!)
function generateBotIntelligence(query) {
  const lower = query.toLowerCase();

  // Keyword check 1: Trace active bottlenecks / status
  if (lower.includes('bottleneck') || lower.includes('block') || lower.includes('trace') || lower.includes('status')) {
    const bottleneck = traceBottlenecks();
    const blockedMods = STATE.modules.filter(m => m.status === 'blocked');
    
    if (bottleneck) {
      let reply = `🔍 <strong>Active Audit Bottleneck Identified:</strong>\n\nThe root blockage lies upstream inside <strong>${bottleneck.name}</strong> (Progress: ${bottleneck.progress}%).\n\n`;
      if (blockedMods.length > 0) {
        reply += `This is locking downstream deliverables for: ${blockedMods.map(m => m.name).join(', ')}.\n\n`;
      }
      reply += `💡 <em>To resolve this: Complete active checklists for ${bottleneck.name} or type <strong>"resolve bottleneck"</strong> right here to execute an override!</em>`;
      return reply;
    } else {
      return `🟢 <strong>Status Check: All Systems Clear!</strong>\n\nAll departments are running smoothly. The pipeline has reached 100% throughput and there are no active bottlenecks in the flowchart.`;
    }
  }

  // Keyword check 2: Administrative commands (Instant unblock Dev blockage)
  if (lower.includes('resolve') || lower.includes('override') || lower.includes('unblock') || lower.includes('fix')) {
    const devMod = STATE.modules.find(m => m.id === 'mod_dev');
    
    if (devMod && devMod.progress < 100) {
      document.getElementById('quick-resolve-trigger').click();
      return `⚡ <strong>Administrative Override Executed successfully!</strong>\n\nI have automatically signed off and completed all checklists for <strong>Software Development</strong>. All downstream dependencies have been successfully recalculated and unblocked!`;
    } else {
      const bottleneck = traceBottlenecks();
      if (bottleneck) {
        // Complete whichever is blocking!
        STATE.tasks.forEach(t => {
          if (t.moduleId === bottleneck.id) {
            t.isCompleted = true;
            t.progress = 100;
          }
        });
        STATE.checklists.forEach(c => {
          if (c.id.includes(bottleneck.id.replace('mod_', 'chk_'))) {
            c.isCompleted = true;
          }
        });
        bottleneck.progress = 100;
        bottleneck.status = 'completed';
        
        writeLog('CHATBOT_OVERRIDE_RESOLVE', bottleneck.id, `Automatically completed deliverables via bot chat.`);
        
        traceBottlenecks();
        renderStats();
        renderDependencyGraph();
        renderPersonalChecklists();
        drawGauges();
        renderHeatmap();
        
        return `⚡ <strong>Administrative Override Executed successfully!</strong>\n\nI have programmatically completed all outstanding deliverables for <strong>${bottleneck.name}</strong>. Downstream locks have been successfully resolved!`;
      } else {
        return `🟢 All departments are already running at 100% operational throughput! No overrides are necessary.`;
      }
    }
  }

  // Keyword check 3: How handshakes work
  if (lower.includes('handshake') || lower.includes('handoff') || lower.includes('transfer')) {
    return `🤝 <strong>Digital Handshake Protocol Guide:</strong>\n\nGlassBoard enforces verifiable department handoffs. When a Lead Developer completes their checklists (100% progress), they click **"Initiate Handoff"** in the workspace drawer, attaching their APK or spec files.\n\nThe downstream Lead is notified and must review the attached specs to either **"Accept & Audit Signature"** (which unblocks their department) or **"Reject Deliverables"** (which sends rejection comments back).`;
  }

  // Keyword check 4: Admin information
  if (lower.includes('admin') || lower.includes('clearance') || lower.includes('role') || lower.includes('profile')) {
    const current = STATE.currentUser;
    if (current) {
      return `👤 <strong>Current Active Profile clearance:</strong>\n\n* <strong>Display Name:</strong> ${current.displayName}\n* <strong>Access Role Level:</strong> ${current.role.toUpperCase()}\n* <strong>Department Scope ID:</strong> ${current.moduleId || 'Global (All Scopes)'}\n\n💡 <em>System Admins can dynamically promote any user clearances under the 'Update Security Clearance' form inside the Admin Suite tab!</em>`;
    }
    return `👤 No active session found. Please sign in using the quick demo options.`;
  }

  // Keyword check 5: Greeting or general help
  if (lower.includes('hi') || lower.includes('hello') || lower.includes('hey') || lower.includes('greet') || lower.includes('help')) {
    return `👋 <strong>Hi there! I am GlassBot. How can I help you today?</strong>\n\nTry asking me:\n* *"Why is Release Operations blocked?"*\n* *"Resolve all active bottlenecks"* (executes overrides)\n* *"Who is logged in?"*\n* *"How do handshakes work?"*`;
  }

  // Default fallback response
  return `🤖 <strong>Command Not Recognized:</strong>\n\nI am currently operating in **Audit Diagnostics Mode**. I detected your query about: *"${query}"*.\n\nCould you try rephrasing or ask me to **"Trace active bottlenecks"** or **"Resolve Software Development bottleneck"**?`;
}

// --- 10. LOGIN MASCOT PENGUIN EYE-TRACKING ANIMATION ---
function initPenguinEyeTracking() {
  const leftEyeGroup = document.getElementById('left-eye-pupil');
  const rightEyeGroup = document.getElementById('right-eye-pupil');

  if (!leftEyeGroup || !rightEyeGroup) return;

  document.addEventListener('mousemove', (e) => {
    // Left eye calculations
    const leftEyeRect = leftEyeGroup.getBoundingClientRect();
    const leftCenterX = leftEyeRect.left + leftEyeRect.width / 2;
    const leftCenterY = leftEyeRect.top + leftEyeRect.height / 2;
    
    // Right eye calculations
    const rightEyeRect = rightEyeGroup.getBoundingClientRect();
    const rightCenterX = rightEyeRect.left + rightEyeRect.width / 2;
    const rightCenterY = rightEyeRect.top + rightEyeRect.height / 2;

    // Angle and translation for Left Eye
    const leftAngle = Math.atan2(e.clientY - leftCenterY, e.clientX - leftCenterX);
    // Limit translation distance within eyeball (max 4.5px)
    const leftDist = Math.min(4.5, Math.hypot(e.clientX - leftCenterX, e.clientY - leftCenterY) / 18);
    const leftDx = leftDist * Math.cos(leftAngle);
    const leftDy = leftDist * Math.sin(leftAngle);

    // Angle and translation for Right Eye
    const rightAngle = Math.atan2(e.clientY - rightCenterY, e.clientX - rightCenterX);
    const rightDist = Math.min(4.5, Math.hypot(e.clientX - rightCenterX, e.clientY - rightCenterY) / 18);
    const rightDx = rightDist * Math.cos(rightAngle);
    const rightDy = rightDist * Math.sin(rightAngle);

    // Translate the SVG groups directly relative to their anchor coordinates
    leftEyeGroup.style.transform = `translate(${leftDx}px, ${leftDy}px)`;
    rightEyeGroup.style.transform = `translate(${rightDx}px, ${rightDy}px)`;
  });
}

// --- 11. PENGUIN MASCOT PASSWORD SHY/REVEAL EYE COVER ANIMATION ---
function initMascotPasswordReveal() {
  const mascot = document.querySelector('.penguin-mascot');
  if (!mascot) return;

  const passwordInputs = document.querySelectorAll('input[type="password"]');
  passwordInputs.forEach(input => {
    input.addEventListener('focus', () => {
      mascot.classList.add('covering-eyes');
    });
    input.addEventListener('blur', () => {
      mascot.classList.remove('covering-eyes');
    });
  });
}

// --- 12. GLASSMORPHIC NOTIFICATION & TOAST SYSTEM ---
function initNotificationSystem() {
  // Initialize mock notifications if not present
  if (!STATE.notifications) {
    STATE.notifications = [
      {
        id: 'notif_init_1',
        title: 'QA Pipeline Blocked',
        message: 'Quality Assurance is currently blocked by Software Development.',
        type: 'warning',
        timestamp: new Date(Date.now() - 4 * 60 * 60 * 1000),
        read: false
      },
      {
        id: 'notif_init_2',
        title: 'Design Specs Finalized',
        message: 'Sarah Chen approved UX specs for Design Studio.',
        type: 'success',
        timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000),
        read: true
      }
    ];
  }

  // Bell icon event listener
  const bellBtn = document.getElementById('btn-notification-bell');
  const dropdownMenu = document.getElementById('notification-dropdown-menu');

  if (bellBtn && dropdownMenu) {
    bellBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      const isHidden = dropdownMenu.classList.contains('hidden');
      if (isHidden) {
        dropdownMenu.classList.remove('hidden');
        markAllNotificationsAsRead();
      } else {
        dropdownMenu.classList.add('hidden');
      }
    });
  }

  // Outside click closes dropdown
  document.addEventListener('click', (e) => {
    if (dropdownMenu && !dropdownMenu.classList.contains('hidden')) {
      const isClickInside = dropdownMenu.contains(e.target) || 
                            (bellBtn && bellBtn.contains(e.target));
      if (!isClickInside) {
        dropdownMenu.classList.add('hidden');
      }
    }
  });

  // Clear all button event listener
  const clearBtn = document.getElementById('btn-clear-notifications');
  if (clearBtn) {
    clearBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      STATE.notifications = [];
      updateNotificationBadge();
      renderNotificationsList();
    });
  }

  // Initial draw
  updateNotificationBadge();
  renderNotificationsList();
}

function markAllNotificationsAsRead() {
  if (STATE.notifications) {
    STATE.notifications.forEach(n => n.read = true);
  }
  updateNotificationBadge();
  renderNotificationsList();
}

function updateNotificationBadge() {
  const badge = document.getElementById('noti-badge-element');
  if (!badge) return;

  const unreadCount = STATE.notifications ? STATE.notifications.filter(n => !n.read).length : 0;
  if (unreadCount > 0) {
    badge.style.display = 'block';
  } else {
    badge.style.display = 'none';
  }
}

function renderNotificationsList() {
  const listEl = document.getElementById('notification-dropdown-list');
  const emptyState = document.getElementById('notification-empty-state');
  if (!listEl) return;

  // Clear all current items
  const items = listEl.querySelectorAll('.notification-item');
  items.forEach(item => item.remove());

  if (!STATE.notifications || STATE.notifications.length === 0) {
    if (emptyState) emptyState.style.display = 'flex';
    return;
  }

  if (emptyState) emptyState.style.display = 'none';

  STATE.notifications.forEach(notif => {
    const item = document.createElement('div');
    item.className = `notification-item ${notif.read ? '' : 'unread'}`;
    
    let iconClass = 'fa-info-circle';
    if (notif.type === 'success') iconClass = 'fa-check-circle';
    else if (notif.type === 'warning') iconClass = 'fa-exclamation-triangle';
    else if (notif.type === 'action') iconClass = 'fa-bolt';

    const timeStr = formatNotifTime(notif.timestamp);

    item.innerHTML = `
      <div class="noti-item-icon-wrapper ${notif.type}">
        <i class="fa-solid ${iconClass}"></i>
      </div>
      <div class="noti-item-content">
        <div class="noti-item-title">${notif.title}</div>
        <div class="noti-item-message">${notif.message}</div>
        <div class="noti-item-time">${timeStr}</div>
      </div>
    `;
    
    item.addEventListener('click', (e) => {
      e.stopPropagation();
      notif.read = true;
      renderNotificationsList();
      updateNotificationBadge();
    });

    listEl.appendChild(item);
  });
}

function formatNotifTime(date) {
  const diffMs = new Date() - date;
  const diffMins = Math.floor(diffMs / 60000);
  if (diffMins < 1) return 'Just now';
  if (diffMins < 60) return `${diffMins}m ago`;
  const diffHours = Math.floor(diffMins / 60);
  if (diffHours < 24) return `${diffHours}h ago`;
  return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

window.showToast = function(title, message, type = 'info') {
  const container = document.getElementById('toast-container-root');
  if (!container) return;

  const toast = document.createElement('div');
  toast.className = `toast-notification ${type}`;

  let iconClass = 'fa-info-circle';
  if (type === 'success') iconClass = 'fa-check-circle';
  else if (type === 'warning') iconClass = 'fa-exclamation-triangle';
  else if (type === 'action') iconClass = 'fa-bolt';

  toast.innerHTML = `
    <div class="toast-icon"><i class="fa-solid ${iconClass}"></i></div>
    <div class="toast-body">
      <div class="toast-title">${title}</div>
      <div class="toast-message">${message}</div>
    </div>
    <button class="toast-close-btn" onclick="this.parentElement.remove()"><i class="fa-solid fa-xmark"></i></button>
  `;

  container.appendChild(toast);

  // Auto remove toast after 4.5s
  setTimeout(() => {
    toast.classList.add('fade-out');
    setTimeout(() => {
      if (toast.parentNode) {
        toast.remove();
      }
    }, 500);
  }, 4000);

  // Add notification to history
  addNotificationToHistory(title, message, type);
};

function addNotificationToHistory(title, message, type) {
  const notif = {
    id: 'notif_' + Date.now() + '_' + Math.random().toString(36).substr(2, 5),
    title: title,
    message: message,
    type: type,
    timestamp: new Date(),
    read: false
  };

  if (!STATE.notifications) {
    STATE.notifications = [];
  }
  
  STATE.notifications.unshift(notif);
  
  // Cap at 20 items
  if (STATE.notifications.length > 20) {
    STATE.notifications.pop();
  }

  updateNotificationBadge();
  renderNotificationsList();
}

function triggerLogNotification(action, moduleId, metadata) {
  let title = 'System Activity';
  let message = metadata || '';
  let type = 'info';

  const userDisplayName = STATE.currentUser ? STATE.currentUser.displayName : 'System';

  switch (action) {
    case 'LOGIN':
      title = 'Access Granted';
      message = `${userDisplayName} signed in successfully.`;
      type = 'success';
      break;
    case 'LOGOUT':
      title = 'Session Terminated';
      message = 'Logged out safely from portal.';
      type = 'info';
      break;
    case 'SIGNUP':
      title = 'Profile Created';
      message = 'New user account registered.';
      type = 'success';
      break;
    case 'TASK_CHECKLIST_TOGGLE':
      const isChecked = message.includes('isChecked: true');
      title = isChecked ? 'Milestone Cleared' : 'Milestone Restored';
      message = `Pipeline checklist item updated by ${userDisplayName}.`;
      type = 'action';
      break;
    case 'BOTTLENECK_QUICK_RESOLVE':
      title = 'Bottleneck Resolved';
      message = 'All active blocking dependencies completed.';
      type = 'success';
      break;
    case 'HANDSHAKE_ACCEPT':
      title = 'Handshake Confirmed';
      message = `Digital handshake signature approved for downstream pipeline.`;
      type = 'success';
      break;
    case 'HANDSHAKE_REJECT':
      title = 'Handshake Rejected';
      message = `Handshake verification failed or rejected.`;
      type = 'warning';
      break;
    case 'HANDSHAKE_CREATE':
      title = 'Handshake Initiated';
      message = `New sign-off request routed to next department.`;
      type = 'action';
      break;
    case 'TASK_CREATE':
      title = 'Task Scheduled';
      message = `Internal module workflow task added successfully.`;
      type = 'action';
      break;
    case 'FILE_UPLOAD':
      title = 'Specification Uploaded';
      message = `New document specification uploaded to module files.`;
      type = 'action';
      break;
    case 'FILE_MODIFY':
      title = 'Specification Updated';
      message = `A document version draft was modified.`;
      type = 'action';
      break;
    case 'MODULE_CREATE':
      title = 'Module Registered';
      message = `New module node added to project DAG structure.`;
      type = 'success';
      break;
    case 'USER_PROMOTE':
    case 'USER_REGISTER_AND_PROMOTE':
      title = 'Security Clearance Updated';
      message = `Role and credentials updated dynamically.`;
      type = 'success';
      break;
    case 'CHATBOT_OVERRIDE_RESOLVE':
      title = 'GlassBot Override';
      message = `Active blocks bypassed programmatically by GlassBot.`;
      type = 'success';
      break;
  }

  showToast(title, message, type);
}

// Start portal loop
initPortal();
