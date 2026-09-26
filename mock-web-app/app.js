/**
 * SkyChauffeur - Airplane Borrow & Fleet Management System
 * Client-side Mock State & Business Logic
 */

const SEED_DATA = {
  users: [
    { id: 1, username: 'student1', name: 'สมชาย ใจดี (Student)', email: 'student1@aviation.ac.th', role_id: 1 },
    { id: 2, username: 'staff1', name: 'สมพงษ์ จันทร์สุข (Staff)', email: 'staff1@aviation.ac.th', role_id: 2 },
    { id: 3, username: 'lecturer1', name: 'ดร. ประเสริฐ วงศ์สวัสดิ์ (Lecturer)', email: 'lecturer1@aviation.ac.th', role_id: 3 }
  ],
  planes: [
    {
      planeID: 1,
      planeName: 'Diamond DA40',
      planeTitle: 'General Aviation',
      status: 1, // 1 = Available, 0 = Unavailable/Maintenance, 2 = Borrowed
      category: 'Single-Engine',
      seat: '4 SEAT',
      planeDescription: 'เครื่องบินฝึกบิน 4 ที่นั่ง เครื่องยนต์เดี่ยว ยอดนิยมสำหรับการฝึกบินเดินทางและไต่ระดับ ติดตั้ง Garmin G1000 NXi',
      tailNumber: 'HS-DA40',
      image: 'assets/images/Diamond DA40.png'
    },
    {
      planeID: 2,
      planeName: 'CESSNA 172',
      planeTitle: 'General Aviation',
      status: 1,
      category: 'Single-Engine',
      seat: '4 SEAT',
      planeDescription: 'เครื่องบินปีกบนมาตรฐานสากล มีเสถียรภาพการบินสูง ปลอดภัย เหมาะสำหรับการฝึกบินเบื้องต้นและการบินเดี่ยว',
      tailNumber: 'HS-C172',
      image: 'assets/images/CESSANA 172.png'
    },
    {
      planeID: 3,
      planeName: 'Cirrus SR-22T',
      planeTitle: 'General Aviation',
      status: 1,
      category: 'High-Performance',
      seat: '5 SEAT',
      planeDescription: 'เครื่องบินสมรรถนะสูง โครงสร้างคอมโพสิต ติดตั้งระบบร่มชูชีพอากาศยาน (CAPS) และเครื่องยนต์ Turbocharged',
      tailNumber: 'HS-SR22',
      image: 'assets/images/Cirrus SR-22T.png'
    },
    {
      planeID: 4,
      planeName: 'Beechcraft Bonanza G36',
      planeTitle: 'General Aviation',
      status: 2, // currently borrowed
      category: 'Piston Single',
      seat: '6 SEAT',
      planeDescription: 'เครื่องบินระดับพรีเมียม 6 ที่นั่ง ความเร็วการเดินทางสูง เหมาะสำหรับฝึกภารกิจขนส่งบุคคลสำคัญและการเดินทางระยะไกล',
      tailNumber: 'HS-G36',
      image: 'assets/images/Beechcraft Bonanza G36.png'
    },
    {
      planeID: 5,
      planeName: 'Embraer Phenom 300',
      planeTitle: 'Business Jet',
      status: 1,
      category: 'Twin-Jet',
      seat: '8 SEAT',
      planeDescription: 'เครื่องบินเจ็ทสองเครื่องยนต์สมรรถนะสูง เพดานบินสูงสุด 45,000 ฟุต ความเร็วเดินทางสูงสุด 453 น็อต',
      tailNumber: 'HS-P300',
      image: 'assets/images/Embraer Phonom 300.png'
    },
    {
      planeID: 6,
      planeName: 'Gulfstream G280',
      planeTitle: 'Business Jet',
      status: 1,
      category: 'Twin-Jet',
      seat: '10 SEAT',
      planeDescription: 'ซูเปอร์มิดไซส์เจ็ทสำหรับการบินข้ามทวีป ความสะดวกสบายระดับเฟิร์สคลาส พร้อมระบบ Avionics ที่ทันสมัยที่สุด',
      tailNumber: 'HS-G280',
      image: 'assets/images/Gulfstream G280.png'
    }
  ],
  requests: [
    {
      requestID: 101,
      planeID: 4,
      planeName: 'Beechcraft Bonanza G36',
      tailNumber: 'HS-G36',
      rqtBy: 1,
      requesterName: 'สมชาย ใจดี (Student)',
      bDate: '2026-09-25',
      rDate: '2026-09-28',
      purpose: 'ฝึกบินเดินทางข้ามจังหวัด เชียงใหม่ - หัวหิน (Cross-Country Navigation)',
      rqtStatus: 1, // 0 = Pending, 1 = Approved, 2 = Rejected
      createdAt: '2026-09-24 10:30'
    },
    {
      requestID: 102,
      planeID: 1,
      planeName: 'Diamond DA40',
      tailNumber: 'HS-DA40',
      rqtBy: 1,
      requesterName: 'สมชาย ใจดี (Student)',
      bDate: '2026-09-29',
      rDate: '2026-09-30',
      purpose: 'ฝึกหัดท่าทางการบินเดี่ยวและการลงจอดฉุกเฉิน (Solo Maneuver)',
      rqtStatus: 0, // Pending
      createdAt: '2026-09-26 09:15'
    }
  ],
  history: [
    {
      historyId: 1,
      planeId: 4,
      planeName: 'Beechcraft Bonanza G36',
      tailNumber: 'HS-G36',
      rqtBy: 1,
      requesterName: 'สมชาย ใจดี (Student)',
      bDate: '2026-09-25',
      rDate: '2026-09-28',
      approvedBy: 'ดร. ประเสริฐ วงศ์สวัสดิ์ (Lecturer)',
      approvedStatus: 1, // 1 = Approved
      returnStatus: 0, // 0 = Not Returned yet (currently in flight)
      actionDate: '2026-09-24'
    },
    {
      historyId: 2,
      planeId: 2,
      planeName: 'CESSNA 172',
      tailNumber: 'HS-C172',
      rqtBy: 1,
      requesterName: 'สมชาย ใจดี (Student)',
      bDate: '2026-09-15',
      rDate: '2026-09-17',
      approvedBy: 'ดร. ประเสริฐ วงศ์สวัสดิ์ (Lecturer)',
      approvedStatus: 1,
      returnStatus: 1, // 1 = Returned successfully
      actionDate: '2026-09-17'
    }
  ]
};

class SkyChauffeurApp {
  constructor() {
    this.storageKey = 'skychauffeur_fleet_db_v1';
    this.currentRole = 1; // 1 = Student, 2 = Staff, 3 = Lecturer
    this.currentView = 'default';
    this.state = this.loadState();
    this.init();
  }

  loadState() {
    try {
      const saved = localStorage.getItem(this.storageKey);
      if (saved) {
        return JSON.parse(saved);
      }
    } catch (e) {
      console.warn('Failed to load local state, using seed data', e);
    }
    this.saveState(SEED_DATA);
    return JSON.parse(JSON.stringify(SEED_DATA));
  }

  saveState(stateData) {
    try {
      localStorage.setItem(this.storageKey, JSON.stringify(stateData || this.state));
    } catch (e) {
      console.error('LocalStorage write error', e);
    }
  }

  resetData() {
    this.state = JSON.parse(JSON.stringify(SEED_DATA));
    this.saveState();
    this.render();
    this.showToast('รีเซ็ตข้อมูล Mock ทั้งระบบเรียบร้อยแล้ว', 'success');
  }

  getCurrentUser() {
    return this.state.users.find(u => u.role_id === this.currentRole) || this.state.users[0];
  }

  setRole(roleId) {
    this.currentRole = Number(roleId);
    this.currentView = 'default';
    this.render();
    const user = this.getCurrentUser();
    this.showToast(`สลับโหมดเป็น: ${user.name}`, 'info');
  }

  setView(viewName) {
    this.currentView = viewName;
    this.render();
  }

  showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        ${type === 'success' ? '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline>' : 
          type === 'danger' ? '<circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line>' :
          '<circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line>'}
      </svg>
      <span>${message}</span>
    `;

    container.appendChild(toast);
    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(10px)';
      setTimeout(() => toast.remove(), 250);
    }, 3200);
  }

  init() {
    this.bindEvents();
    this.render();
  }

  bindEvents() {
    // Role switch tabs
    document.querySelectorAll('.role-tab-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const role = Number(btn.getAttribute('data-role'));
        this.setRole(role);
      });
    });

    // Reset button
    const resetBtn = document.getElementById('resetMockBtn');
    if (resetBtn) {
      resetBtn.addEventListener('click', () => {
        if (confirm('ยืนยันที่จะรีเซ็ตข้อมูล Mock กลับสู่ค่าเริ่มต้นหรือไม่?')) {
          this.resetData();
        }
      });
    }

    // Modal close listeners
    document.querySelectorAll('.modal-close-btn, .modal-backdrop').forEach(elem => {
      elem.addEventListener('click', (e) => {
        if (e.target === elem) {
          this.closeAllModals();
        }
      });
    });
  }

  closeAllModals() {
    document.querySelectorAll('.modal-backdrop').forEach(modal => {
      modal.classList.remove('show');
    });
  }

  openModal(modalId) {
    this.closeAllModals();
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.add('show');
    }
  }

  /* ==========================================================================
     Business Logic Mutations
     ========================================================================== */

  submitBorrowRequest(planeID, bDate, rDate, purpose) {
    const plane = this.state.planes.find(p => p.planeID === planeID);
    if (!plane) return;

    if (!bDate || !rDate) {
      alert('กรุณาระบุวันที่ยืมและวันที่คืนให้ครบถ้วน');
      return;
    }

    if (new Date(rDate) < new Date(bDate)) {
      alert('วันที่คืนต้องไม่น้อยกว่าวันที่เริ่มยืม');
      return;
    }

    const newRequest = {
      requestID: Date.now(),
      planeID: plane.planeID,
      planeName: plane.planeName,
      tailNumber: plane.tailNumber,
      rqtBy: this.getCurrentUser().id,
      requesterName: this.getCurrentUser().name,
      bDate: bDate,
      rDate: rDate,
      purpose: purpose || 'การฝึกบินตามหลักสูตร',
      rqtStatus: 0, // Pending
      createdAt: new Date().toISOString().replace('T', ' ').substring(0, 16)
    };

    this.state.requests.unshift(newRequest);
    this.saveState();
    this.closeAllModals();
    this.render();
    this.showToast(`ส่งคำขอยืมเครื่องบิน ${plane.planeName} (${plane.tailNumber}) สำเร็จ รออาจารย์อนุมัติ`, 'success');
  }

  cancelBorrowRequest(requestID) {
    const idx = this.state.requests.findIndex(r => r.requestID === requestID);
    if (idx !== -1) {
      const rq = this.state.requests[idx];
      this.state.requests.splice(idx, 1);
      this.saveState();
      this.render();
      this.showToast(`ยกเลิกคำขอ #${rq.requestID} เรียบร้อยแล้ว`, 'info');
    }
  }

  approveRequest(requestID) {
    const request = this.state.requests.find(r => r.requestID === requestID);
    if (!request) return;

    request.rqtStatus = 1; // Approved

    // Update plane status to Borrowed (2)
    const plane = this.state.planes.find(p => p.planeID === request.planeID);
    if (plane) {
      plane.status = 2; // Borrowed
    }

    // Add to history
    this.state.history.unshift({
      historyId: Date.now(),
      planeId: request.planeID,
      planeName: request.planeName,
      tailNumber: request.tailNumber,
      rqtBy: request.rqtBy,
      requesterName: request.requesterName,
      bDate: request.bDate,
      rDate: request.rDate,
      approvedBy: this.getCurrentUser().name,
      approvedStatus: 1,
      returnStatus: 0, // Not returned yet
      actionDate: new Date().toISOString().substring(0, 10)
    });

    this.saveState();
    this.render();
    this.showToast(`อนุมัติคำขอ ${request.planeName} สำหรับ ${request.requesterName} เรียบร้อย`, 'success');
  }

  rejectRequest(requestID) {
    const request = this.state.requests.find(r => r.requestID === requestID);
    if (!request) return;

    request.rqtStatus = 2; // Rejected

    // Add to history as rejected
    this.state.history.unshift({
      historyId: Date.now(),
      planeId: request.planeID,
      planeName: request.planeName,
      tailNumber: request.tailNumber,
      rqtBy: request.rqtBy,
      requesterName: request.requesterName,
      bDate: request.bDate,
      rDate: request.rDate,
      approvedBy: this.getCurrentUser().name,
      approvedStatus: 0, // Rejected
      returnStatus: 0,
      actionDate: new Date().toISOString().substring(0, 10)
    });

    this.saveState();
    this.render();
    this.showToast(`ปฏิเสธคำขอ #${request.requestID} เรียบร้อย`, 'danger');
  }

  recordReturn(historyId) {
    const record = this.state.history.find(h => h.historyId === historyId);
    if (!record) return;

    record.returnStatus = 1; // Returned

    // Set plane back to available (1)
    const plane = this.state.planes.find(p => p.planeID === record.planeId);
    if (plane) {
      plane.status = 1;
    }

    this.saveState();
    this.render();
    this.showToast(`บันทึกรับคืนเครื่องบิน ${record.planeName} (${record.tailNumber}) เข้าสู่ฝูงบินเรียบร้อยแล้ว`, 'success');
  }

  savePlane(planeData) {
    if (planeData.planeID) {
      // Edit
      const idx = this.state.planes.findIndex(p => p.planeID === Number(planeData.planeID));
      if (idx !== -1) {
        this.state.planes[idx] = { ...this.state.planes[idx], ...planeData };
        this.showToast(`อัปเดตข้อมูล ${planeData.planeName} สำเร็จ`, 'success');
      }
    } else {
      // Create new
      const newPlane = {
        planeID: Date.now(),
        planeName: planeData.planeName,
        planeTitle: planeData.planeTitle || 'General Aviation',
        status: Number(planeData.status) || 1,
        category: planeData.category || 'Light Aircraft',
        seat: planeData.seat || '4 SEAT',
        planeDescription: planeData.planeDescription || 'เครื่องบินฝึกบินประจำฝูงบิน',
        tailNumber: planeData.tailNumber || 'HS-NEW',
        image: planeData.image || 'assets/images/airplane.jpg'
      };
      this.state.planes.push(newPlane);
      this.showToast(`เพิ่มเครื่องบิน ${newPlane.planeName} เข้าสู่ระบบแล้ว`, 'success');
    }

    this.saveState();
    this.closeAllModals();
    this.render();
  }

  deletePlane(planeID) {
    if (confirm('คุณแน่ใจหรือไม่ว่าต้องการลบเครื่องบินลำนี้ออกจากระบบ?')) {
      const idx = this.state.planes.findIndex(p => p.planeID === planeID);
      if (idx !== -1) {
        const name = this.state.planes[idx].planeName;
        this.state.planes.splice(idx, 1);
        this.saveState();
        this.render();
        this.showToast(`ลบเครื่องบิน ${name} ออกจากระบบแล้ว`, 'danger');
      }
    }
  }

  /* ==========================================================================
     UI Rendering
     ========================================================================== */

  render() {
    this.updateHeaderUserInfo();
    this.updateRoleTabs();
    this.renderSubNav();
    this.renderMainContent();
  }

  updateHeaderUserInfo() {
    const user = this.getCurrentUser();
    const nameElem = document.getElementById('headerUserName');
    const roleElem = document.getElementById('headerUserRole');
    const avatarElem = document.getElementById('headerUserAvatar');

    if (nameElem) nameElem.textContent = user.name;
    if (roleElem) {
      roleElem.textContent = this.currentRole === 1 ? 'Student (นักศึกษา)' :
                             this.currentRole === 2 ? 'Staff (เจ้าหน้าที่ผู้ดูแล)' :
                             'Lecturer (อาจารย์ผู้อนุมัติ)';
    }
    if (avatarElem) {
      avatarElem.textContent = user.username.substring(0, 2).toUpperCase();
    }
  }

  updateRoleTabs() {
    document.querySelectorAll('.role-tab-btn').forEach(btn => {
      const role = Number(btn.getAttribute('data-role'));
      if (role === this.currentRole) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });
  }

  renderSubNav() {
    const subNavGroup = document.getElementById('navLinksGroup');
    if (!subNavGroup) return;

    let links = [];

    if (this.currentRole === 1) {
      // Student
      links = [
        { id: 'catalog', label: 'ฝูงบินทั้งหมด (Fleet Catalog)' },
        { id: 'my-requests', label: 'คำขอยืมของฉัน (My Requests)', badge: this.state.requests.filter(r => r.rqtBy === this.getCurrentUser().id).length },
        { id: 'my-history', label: 'ประวัติการยืม (History)' }
      ];
    } else if (this.currentRole === 3) {
      // Lecturer
      const pendingCount = this.state.requests.filter(r => r.rqtStatus === 0).length;
      links = [
        { id: 'pending-requests', label: 'รอการพิจารณา (Pending Requests)', badge: pendingCount, badgeColor: 'badge-pending' },
        { id: 'fleet-status', label: 'สถานะเครื่องบิน (Fleet Status)' },
        { id: 'approval-history', label: 'ประวัติการอนุมัติ (Approval Log)' }
      ];
    } else {
      // Staff
      const borrowedCount = this.state.history.filter(h => h.returnStatus === 0 && h.approvedStatus === 1).length;
      links = [
        { id: 'fleet-crud', label: 'จัดการข้อมูลเครื่องบิน (Fleet CRUD)' },
        { id: 'returns', label: 'บันทึกรับคืน (Return Processing)', badge: borrowedCount, badgeColor: 'badge-borrowed' },
        { id: 'stats', label: 'แดชบอร์ดสถิติ (Fleet Analytics)' },
        { id: 'system-logs', label: 'ประวัติระบบ (Audit Logs)' }
      ];
    }

    if (this.currentView === 'default') {
      this.currentView = links[0].id;
    }

    subNavGroup.innerHTML = links.map(link => `
      <button class="nav-link-btn ${this.currentView === link.id ? 'active' : ''}" onclick="window.app.setView('${link.id}')">
        <span>${link.label}</span>
        ${link.badge !== undefined && link.badge > 0 ? `<span class="badge ${link.badgeColor || 'badge-info'}">${link.badge}</span>` : ''}
      </button>
    `).join('');
  }

  renderMainContent() {
    const container = document.getElementById('mainContentArea');
    if (!container) return;

    if (this.currentRole === 1) {
      this.renderStudentView(container);
    } else if (this.currentRole === 3) {
      this.renderLecturerView(container);
    } else {
      this.renderStaffView(container);
    }
  }

  /* ---------------- STUDENT VIEWS ---------------- */
  renderStudentView(container) {
    if (this.currentView === 'my-requests') {
      this.renderStudentRequests(container);
    } else if (this.currentView === 'my-history') {
      this.renderStudentHistory(container);
    } else {
      this.renderStudentCatalog(container);
    }
  }

  renderStudentCatalog(container) {
    const totalPlanes = this.state.planes.length;
    const availablePlanes = this.state.planes.filter(p => p.status === 1).length;
    const borrowedPlanes = this.state.planes.filter(p => p.status === 2).length;

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>ฝูงบินฝึกบินและเครื่องบินบริการ (Aircraft Fleet)</h1>
          <p>เลือกเครื่องบินที่พร้อมใช้งานเพื่อส่งคำขอยืมสำหรับการฝึกบินหรือภารกิจเดินทาง</p>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">เครื่องบินทั้งหมด</div>
            <div class="stat-value">${totalPlanes}</div>
          </div>
          <div class="stat-icon blue">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.8 19.2L16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"/></svg>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">พร้อมให้บริการ (Available)</div>
            <div class="stat-value">${availablePlanes}</div>
          </div>
          <div class="stat-icon green">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">กำลังปฏิบัติภารกิจ (In Flight)</div>
            <div class="stat-value">${borrowedPlanes}</div>
          </div>
          <div class="stat-icon amber">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          </div>
        </div>
      </div>

      <div class="aircraft-grid">
        ${this.state.planes.map(plane => {
          const isAvailable = plane.status === 1;
          const statusText = plane.status === 1 ? 'พร้อมใช้งาน' : (plane.status === 2 ? 'ถูกยืมอยู่' : 'งดให้บริการ');
          const badgeClass = plane.status === 1 ? 'badge-available' : (plane.status === 2 ? 'badge-borrowed' : 'badge-pending');

          return `
            <div class="aircraft-card">
              <div class="aircraft-media-box">
                <span class="status-badge-floating ${badgeClass}">
                  <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor;"></span>
                  ${statusText}
                </span>
                <span class="tail-badge-floating">${plane.tailNumber}</span>
                <img src="${plane.image}" alt="${plane.planeName}" class="aircraft-img" onerror="this.src='assets/images/airplane.jpg'">
              </div>
              <div class="aircraft-body">
                <div class="aircraft-title-wrap">
                  <h3 class="aircraft-name">${plane.planeName}</h3>
                  <span class="aircraft-category-tag">${plane.category}</span>
                </div>
                <p class="aircraft-desc">${plane.planeDescription}</p>
                
                <div class="aircraft-specs-row">
                  <div class="spec-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                    <span>${plane.seat}</span>
                  </div>
                  <div class="spec-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>
                    <span>${plane.planeTitle}</span>
                  </div>
                </div>

                <div class="aircraft-actions-row">
                  <button class="btn btn-secondary btn-sm" onclick="window.app.showPlaneDetail(${plane.planeID})">รายละเอียด</button>
                  <button class="btn btn-primary btn-sm" style="flex:1;" 
                          ${!isAvailable ? 'disabled' : ''} 
                          onclick="window.app.promptBorrow(${plane.planeID})">
                    ${isAvailable ? 'ขอยืมเครื่องบินลำนี้' : 'ไม่สามารถยืมได้'}
                  </button>
                </div>
              </div>
            </div>
          `;
        }).join('')}
      </div>
    `;
  }

  renderStudentRequests(container) {
    const user = this.getCurrentUser();
    const myRequests = this.state.requests.filter(r => r.rqtBy === user.id);

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>คำขอยืมเครื่องบินของฉัน (My Borrow Requests)</h1>
          <p>ติดตามสถานะคำขอยืมเครื่องบินที่ส่งถึงอาจารย์ผู้อนุมัติ</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-card-header">
          <div class="table-title">รายการคำขอทั้งหมด (${myRequests.length})</div>
        </div>
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>รหัสคำขอ</th>
                <th>เครื่องบิน</th>
                <th>Tail Number</th>
                <th>วันที่ยืม - คืน</th>
                <th>วัตถุประสงค์</th>
                <th>สถานะคำขอ</th>
                <th>วันที่ทำรายการ</th>
                <th>การจัดการ</th>
              </tr>
            </thead>
            <tbody>
              ${myRequests.length === 0 ? `
                <tr><td colspan="8"><div class="empty-state">ยังไม่มีรายการคำขอยืมเครื่องบิน</div></td></tr>
              ` : myRequests.map(r => {
                const statusBadge = r.rqtStatus === 0 ? '<span class="badge badge-pending">รอพิจารณา (Pending)</span>' :
                                    r.rqtStatus === 1 ? '<span class="badge badge-available">อนุมัติแล้ว (Approved)</span>' :
                                    '<span class="badge badge-borrowed">ไม่อนุมัติ (Rejected)</span>';

                return `
                  <tr>
                    <td><strong>#${r.requestID}</strong></td>
                    <td><strong>${r.planeName}</strong></td>
                    <td><code>${r.tailNumber}</code></td>
                    <td>${r.bDate} ถึง ${r.rDate}</td>
                    <td>${r.purpose}</td>
                    <td>${statusBadge}</td>
                    <td>${r.createdAt}</td>
                    <td>
                      ${r.rqtStatus === 0 ? `
                        <button class="btn btn-danger-outline btn-sm" onclick="window.app.cancelBorrowRequest(${r.requestID})">ยกเลิกคำขอ</button>
                      ` : '-'}
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  renderStudentHistory(container) {
    const user = this.getCurrentUser();
    const myHistory = this.state.history.filter(h => h.rqtBy === user.id);

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>ประวัติการบินและการยืมเครื่องบิน (My Flight History)</h1>
          <p>บันทึกประวัติภารกิจการบินและการคืนอากาศยานของนักศึกษา</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-card-header">
          <div class="table-title">บันทึกประวัติ (${myHistory.length})</div>
        </div>
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>บันทึกที่</th>
                <th>เครื่องบิน</th>
                <th>Tail Number</th>
                <th>ช่วงวันที่บิน</th>
                <th>ผู้อนุมัติ</th>
                <th>สถานะการคืนเครื่องบิน</th>
                <th>วันที่บันทึก</th>
              </tr>
            </thead>
            <tbody>
              ${myHistory.length === 0 ? `
                <tr><td colspan="7"><div class="empty-state">ยังไม่มีประวัติการยืมเครื่องบิน</div></td></tr>
              ` : myHistory.map(h => `
                <tr>
                  <td>#${h.historyId}</td>
                  <td><strong>${h.planeName}</strong></td>
                  <td><code>${h.tailNumber}</code></td>
                  <td>${h.bDate} ถึง ${h.rDate}</td>
                  <td>${h.approvedBy}</td>
                  <td>
                    ${h.returnStatus === 1 ? 
                      '<span class="badge badge-info">คืนอากาศยานเรียบร้อย</span>' : 
                      '<span class="badge badge-borrowed">อยู่ระหว่างการยืม (ยังไม่คืน)</span>'}
                  </td>
                  <td>${h.actionDate}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  /* ---------------- LECTURER VIEWS ---------------- */
  renderLecturerView(container) {
    if (this.currentView === 'fleet-status') {
      this.renderLecturerFleetStatus(container);
    } else if (this.currentView === 'approval-history') {
      this.renderLecturerApprovalHistory(container);
    } else {
      this.renderLecturerPendingRequests(container);
    }
  }

  renderLecturerPendingRequests(container) {
    const pendingList = this.state.requests.filter(r => r.rqtStatus === 0);

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>รายการคำขอรอการอนุมัติ (Approval Queue)</h1>
          <p>ตรวจสอบและพิจารณาคำขอยืมเครื่องบินจากนักศึกษาตามคุณสมบัติและวัตถุประสงค์การบิน</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-card-header">
          <div class="table-title">คำขอที่รอการพิจารณา (${pendingList.length})</div>
        </div>
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>รหัสคำขอ</th>
                <th>ผู้ขอยืม</th>
                <th>เครื่องบินที่ขอ</th>
                <th>Tail Number</th>
                <th>กำหนดการ (เริ่ม - คืน)</th>
                <th>วัตถุประสงค์การบิน</th>
                <th>วันที่ยื่น</th>
                <th style="text-align: right;">การดำเนินการ</th>
              </tr>
            </thead>
            <tbody>
              ${pendingList.length === 0 ? `
                <tr><td colspan="8"><div class="empty-state">ไม่มีคำขอค้างรอการพิจารณาในขณะนี้</div></td></tr>
              ` : pendingList.map(r => `
                <tr>
                  <td><strong>#${r.requestID}</strong></td>
                  <td><strong>${r.requesterName}</strong></td>
                  <td>${r.planeName}</td>
                  <td><code>${r.tailNumber}</code></td>
                  <td>${r.bDate} ถึง ${r.rDate}</td>
                  <td>${r.purpose}</td>
                  <td>${r.createdAt}</td>
                  <td style="text-align: right;">
                    <button class="btn btn-success btn-sm" onclick="window.app.approveRequest(${r.requestID})">✓ อนุมัติ</button>
                    <button class="btn btn-danger-outline btn-sm" onclick="window.app.rejectRequest(${r.requestID})">✗ ปฏิเสธ</button>
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  renderLecturerFleetStatus(container) {
    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>ภาพรวมสถานะอากาศยานทั้งหมด (Fleet Status Overview)</h1>
          <p>รายงานความพร้อมของเครื่องบินในสังกัดเพื่อการวางแผนตารางการบิน</p>
        </div>
      </div>

      <div class="aircraft-grid">
        ${this.state.planes.map(p => {
          const statusBadge = p.status === 1 ? '<span class="badge badge-available">พร้อมใช้งาน (Available)</span>' :
                              p.status === 2 ? '<span class="badge badge-borrowed">กำลังถูกยืม (In Service)</span>' :
                              '<span class="badge badge-pending">ซ่อมบำรุง / งดบิน</span>';
          return `
            <div class="aircraft-card">
              <div class="aircraft-media-box">
                <span class="tail-badge-floating">${p.tailNumber}</span>
                <img src="${p.image}" alt="${p.planeName}" class="aircraft-img" onerror="this.src='assets/images/airplane.jpg'">
              </div>
              <div class="aircraft-body">
                <div class="aircraft-title-wrap">
                  <h3 class="aircraft-name">${p.planeName}</h3>
                  <span class="aircraft-category-tag">${p.category}</span>
                </div>
                <div style="margin-bottom: 0.85rem;">${statusBadge}</div>
                <p class="aircraft-desc">${p.planeDescription}</p>
                <div class="aircraft-specs-row">
                  <div class="spec-item">ที่นั่ง: <strong>${p.seat}</strong></div>
                  <div class="spec-item">หมวด: <strong>${p.planeTitle}</strong></div>
                </div>
              </div>
            </div>
          `;
        }).join('')}
      </div>
    `;
  }

  renderLecturerApprovalHistory(container) {
    const approvals = this.state.history;

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>ประวัติการพิจารณาและอนุมัติ (Approval History Log)</h1>
          <p>บันทึกการตัดสินใจอนุมัติหรือปฏิเสธคำขอยืมเครื่องบินในระบบ</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>รหัสบันทึก</th>
                <th>เครื่องบิน</th>
                <th>ผู้ขอยืม</th>
                <th>ช่วงวันที่</th>
                <th>ผลการพิจารณา</th>
                <th>ผู้อนุมัติ</th>
                <th>วันที่บันทึก</th>
              </tr>
            </thead>
            <tbody>
              ${approvals.map(h => `
                <tr>
                  <td>#${h.historyId}</td>
                  <td><strong>${h.planeName} (${h.tailNumber})</strong></td>
                  <td>${h.requesterName}</td>
                  <td>${h.bDate} ถึง ${h.rDate}</td>
                  <td>
                    ${h.approvedStatus === 1 ? '<span class="badge badge-available">อนุมัติแล้ว</span>' : '<span class="badge badge-borrowed">ปฏิเสธคำขอ</span>'}
                  </td>
                  <td>${h.approvedBy}</td>
                  <td>${h.actionDate}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  /* ---------------- STAFF VIEWS ---------------- */
  renderStaffView(container) {
    if (this.currentView === 'returns') {
      this.renderStaffReturns(container);
    } else if (this.currentView === 'stats') {
      this.renderStaffStats(container);
    } else if (this.currentView === 'system-logs') {
      this.renderStaffSystemLogs(container);
    } else {
      this.renderStaffFleetCRUD(container);
    }
  }

  renderStaffFleetCRUD(container) {
    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>จัดการฝูงบินอากาศยาน (Fleet Management)</h1>
          <p>เพิ่ม แก้ไข หรือปลดระวางข้อมูลเครื่องบินในระบบ SkyChauffeur</p>
        </div>
        <button class="btn btn-primary" onclick="window.app.openAddPlaneModal()">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
          เพิ่มเครื่องบินใหม่ (Add Aircraft)
        </button>
      </div>

      <div class="table-card">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>รูปภาพ</th>
                <th>ชื่อเครื่องบิน</th>
                <th>Tail Number</th>
                <th>หมวดหมู่ / เครื่องยนต์</th>
                <th>จำนวนที่นั่ง</th>
                <th>สถานะการใช้งาน</th>
                <th style="text-align: right;">การจัดการ</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.planes.map(p => `
                <tr>
                  <td style="width: 70px;">
                    <img src="${p.image}" alt="${p.planeName}" style="width: 56px; height: 38px; object-fit: contain; border-radius: 4px; background: #e2e8f0;" onerror="this.src='assets/images/airplane.jpg'">
                  </td>
                  <td><strong>${p.planeName}</strong></td>
                  <td><code>${p.tailNumber}</code></td>
                  <td>${p.category} (${p.planeTitle})</td>
                  <td>${p.seat}</td>
                  <td>
                    ${p.status === 1 ? '<span class="badge badge-available">พร้อมใช้งาน</span>' :
                      p.status === 2 ? '<span class="badge badge-borrowed">ถูกยืมอยู่</span>' :
                      '<span class="badge badge-pending">ซ่อมบำรุง</span>'}
                  </td>
                  <td style="text-align: right;">
                    <button class="btn btn-secondary btn-sm" onclick="window.app.openEditPlaneModal(${p.planeID})">แก้ไข</button>
                    <button class="btn btn-danger-outline btn-sm" onclick="window.app.deletePlane(${p.planeID})">ลบ</button>
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  renderStaffReturns(container) {
    const unreturned = this.state.history.filter(h => h.approvedStatus === 1 && h.returnStatus === 0);

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>บันทึกการส่งคืนอากาศยาน (Return Processing)</h1>
          <p>ตรวจรับเครื่องบินกลับเข้าสู่ลานจอด และอัปเดตสถานะให้พร้อมสำหรับภารกิจถัดไป</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-card-header">
          <div class="table-title">เครื่องบินที่อยู่ระหว่างการยืมใช้งาน (${unreturned.length})</div>
        </div>
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>รหัสบันทึก</th>
                <th>เครื่องบิน</th>
                <th>Tail Number</th>
                <th>ผู้ยืมใช้งาน</th>
                <th>กำหนดคืนตามสัญญา</th>
                <th>ผู้อนุมัติ</th>
                <th style="text-align: right;">การตรวจรับ</th>
              </tr>
            </thead>
            <tbody>
              ${unreturned.length === 0 ? `
                <tr><td colspan="7"><div class="empty-state">ไม่มีเครื่องบินที่อยู่ระหว่างการยืมในขณะนี้ ทุกลำอยู่ในสถานะพร้อมใช้งาน</div></td></tr>
              ` : unreturned.map(h => `
                <tr>
                  <td>#${h.historyId}</td>
                  <td><strong>${h.planeName}</strong></td>
                  <td><code>${h.tailNumber}</code></td>
                  <td>${h.requesterName}</td>
                  <td><strong style="color: var(--danger-main);">${h.rDate}</strong> (ยืมตั้งแต่: ${h.bDate})</td>
                  <td>${h.approvedBy}</td>
                  <td style="text-align: right;">
                    <button class="btn btn-success btn-sm" onclick="window.app.recordReturn(${h.historyId})">
                      ✓ บันทึกรับคืนเครื่องบิน (Confirm Return)
                    </button>
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  renderStaffStats(container) {
    const total = this.state.planes.length;
    const available = this.state.planes.filter(p => p.status === 1).length;
    const borrowed = this.state.planes.filter(p => p.status === 2).length;
    const completedMissions = this.state.history.filter(h => h.returnStatus === 1).length;

    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>แดชบอร์ดสถิติและการใช้งานฝูงบิน (Fleet Analytics)</h1>
          <p>สรุปตัวชี้วัดความพร้อมของอากาศยาน อัตราการยืม และชั่วโมงการบินในสังกัด</p>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">จำนวนเครื่องบินทั้งหมด</div>
            <div class="stat-value">${total} ลำ</div>
          </div>
          <div class="stat-icon blue">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.8 19.2L16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"/></svg>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">พร้อมให้บริการทันที</div>
            <div class="stat-value">${available} ลำ</div>
          </div>
          <div class="stat-icon green">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">กำลังบินปฏิบัติภารกิจ</div>
            <div class="stat-value">${borrowed} ลำ</div>
          </div>
          <div class="stat-icon amber">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <div class="stat-label">ภารกิจสำเร็จสะสม</div>
            <div class="stat-value">${completedMissions} ครั้ง</div>
          </div>
          <div class="stat-icon purple">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
          </div>
        </div>
      </div>
    `;
  }

  renderStaffSystemLogs(container) {
    container.innerHTML = `
      <div class="page-header">
        <div class="page-title-block">
          <h1>ประวัติและบันทึกระบบยืม-คืนทั้งหมด (Complete Audit Trail)</h1>
          <p>บันทึกประวัติการยืม-คืนเครื่องบินทั้งหมดตั้งแต่เริ่มต้นระบบ</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>Log ID</th>
                <th>เครื่องบิน</th>
                <th>Tail Number</th>
                <th>ผู้ขอยืม</th>
                <th>วันที่ยืม - คืน</th>
                <th>ผู้อนุมัติ</th>
                <th>สถานะการส่งคืน</th>
                <th>วันที่ทำรายการ</th>
              </tr>
            </thead>
            <tbody>
              ${this.state.history.map(h => `
                <tr>
                  <td>#${h.historyId}</td>
                  <td><strong>${h.planeName}</strong></td>
                  <td><code>${h.tailNumber}</code></td>
                  <td>${h.requesterName}</td>
                  <td>${h.bDate} ถึง ${h.rDate}</td>
                  <td>${h.approvedBy}</td>
                  <td>
                    ${h.returnStatus === 1 ? '<span class="badge badge-available">คืนเรียบร้อย</span>' :
                      h.approvedStatus === 0 ? '<span class="badge badge-borrowed">ถูกปฏิเสธ</span>' :
                      '<span class="badge badge-pending">อยู่ระหว่างการยืม</span>'}
                  </td>
                  <td>${h.actionDate}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  /* ---------------- MODALS ---------------- */
  promptBorrow(planeID) {
    const plane = this.state.planes.find(p => p.planeID === planeID);
    if (!plane) return;

    const modalBody = document.getElementById('borrowModalBody');
    if (!modalBody) return;

    const today = new Date().toISOString().substring(0, 10);
    const tomorrow = new Date(Date.now() + 86400000).toISOString().substring(0, 10);

    modalBody.innerHTML = `
      <div style="display:flex; align-items:center; gap: 1rem; margin-bottom: 1.25rem; padding-bottom: 1rem; border-bottom: 1px solid var(--slate-200);">
        <img src="${plane.image}" alt="${plane.planeName}" style="width: 100px; height: 60px; object-fit: contain; border-radius: 6px; background: #e2e8f0;" onerror="this.src='assets/images/airplane.jpg'">
        <div>
          <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--navy-900);">${plane.planeName}</h3>
          <div style="font-size: 0.82rem; color: var(--slate-600);">${plane.category} • Tail: <code>${plane.tailNumber}</code></div>
          <div style="font-size: 0.8rem; color: var(--slate-500); margin-top: 0.2rem;">ความจุ: ${plane.seat}</div>
        </div>
      </div>

      <form id="borrowForm" onsubmit="event.preventDefault(); window.app.handleBorrowSubmit(${plane.planeID});">
        <div class="form-control-row">
          <div class="form-group">
            <label for="borrowBDate">วันที่เริ่มยืม (Start Date) *</label>
            <input type="date" id="borrowBDate" class="form-control" value="${today}" required>
          </div>
          <div class="form-group">
            <label for="borrowRDate">วันที่ส่งคืน (Return Date) *</label>
            <input type="date" id="borrowRDate" class="form-control" value="${tomorrow}" required>
          </div>
        </div>

        <div class="form-group">
          <label for="borrowPurpose">วัตถุประสงค์การบิน / เส้นทางบิน (Flight Purpose) *</label>
          <textarea id="borrowPurpose" class="form-control" rows="3" placeholder="เช่น ฝึกบินเดี่ยว, ฝึกเดินทางข้ามจังหวัด, ภารกิจสำรวจสภาพอากาศ" required>ฝึกบินเดินทางและซ้อมลงจอดตามหลักสูตรนักบินพาณิชย์ตรี</textarea>
        </div>

        <div class="form-group">
          <label>ผู้ขอยืม (Requester)</label>
          <input type="text" class="form-control" value="${this.getCurrentUser().name} (${this.getCurrentUser().email})" disabled>
        </div>

        <div class="modal-footer" style="padding-left: 0; padding-right: 0; background: transparent; border-top: none;">
          <button type="button" class="btn btn-secondary" onclick="window.app.closeAllModals()">ยกเลิก</button>
          <button type="submit" class="btn btn-primary">ส่งคำขอยืมเครื่องบิน</button>
        </div>
      </form>
    `;

    this.openModal('borrowModal');
  }

  handleBorrowSubmit(planeID) {
    const bDate = document.getElementById('borrowBDate').value;
    const rDate = document.getElementById('borrowRDate').value;
    const purpose = document.getElementById('borrowPurpose').value;
    this.submitBorrowRequest(planeID, bDate, rDate, purpose);
  }

  showPlaneDetail(planeID) {
    const plane = this.state.planes.find(p => p.planeID === planeID);
    if (!plane) return;

    const modalBody = document.getElementById('planeDetailModalBody');
    if (!modalBody) return;

    const statusBadge = plane.status === 1 ? '<span class="badge badge-available">พร้อมใช้งาน (Available)</span>' :
                        plane.status === 2 ? '<span class="badge badge-borrowed">กำลังถูกยืม (In Service)</span>' :
                        '<span class="badge badge-pending">ซ่อมบำรุง (Maintenance)</span>';

    modalBody.innerHTML = `
      <div style="background: linear-gradient(180deg, #e2e8f0 0%, #cbd5e1 100%); border-radius: var(--radius-md); padding: 1.5rem; text-align: center; margin-bottom: 1.25rem;">
        <img src="${plane.image}" alt="${plane.planeName}" style="max-height: 180px; max-width: 90%; object-fit: contain; filter: drop-shadow(0 6px 10px rgba(0,0,0,0.2));" onerror="this.src='assets/images/airplane.jpg'">
      </div>

      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 0.75rem;">
        <h2 style="font-size: 1.35rem; font-weight: 700; color: var(--navy-900);">${plane.planeName}</h2>
        <div>${statusBadge}</div>
      </div>

      <p style="font-size: 0.9rem; color: var(--slate-700); line-height: 1.5; margin-bottom: 1.25rem;">
        ${plane.planeDescription}
      </p>

      <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; background: var(--slate-50); padding: 1rem; border-radius: var(--radius-sm); border: 1px solid var(--slate-200); font-size: 0.85rem;">
        <div><strong>Tail Number:</strong> <code>${plane.tailNumber}</code></div>
        <div><strong>จำนวนที่นั่ง:</strong> ${plane.seat}</div>
        <div><strong>หมวดหมู่:</strong> ${plane.category}</div>
        <div><strong>ประเภทอากาศยาน:</strong> ${plane.planeTitle}</div>
      </div>
    `;

    this.openModal('planeDetailModal');
  }

  openAddPlaneModal() {
    this.openPlaneFormModal(null);
  }

  openEditPlaneModal(planeID) {
    const plane = this.state.planes.find(p => p.planeID === planeID);
    this.openPlaneFormModal(plane);
  }

  openPlaneFormModal(plane) {
    const modalTitle = document.getElementById('planeFormModalTitle');
    const modalBody = document.getElementById('planeFormModalBody');
    if (!modalBody) return;

    const isEdit = !!plane;
    modalTitle.textContent = isEdit ? `แก้ไขข้อมูล: ${plane.planeName}` : 'เพิ่มเครื่องบินใหม่เข้าสู่ฝูงบิน';

    modalBody.innerHTML = `
      <form id="planeForm" onsubmit="event.preventDefault(); window.app.handlePlaneFormSubmit(${isEdit ? plane.planeID : 'null'});">
        <div class="form-control-row">
          <div class="form-group">
            <label for="formPlaneName">ชื่อรุ่นเครื่องบิน *</label>
            <input type="text" id="formPlaneName" class="form-control" value="${isEdit ? plane.planeName : ''}" required placeholder="เช่น Diamond DA42">
          </div>
          <div class="form-group">
            <label for="formTailNumber">Tail Number *</label>
            <input type="text" id="formTailNumber" class="form-control" value="${isEdit ? plane.tailNumber : 'HS-'}" required placeholder="เช่น HS-DA42">
          </div>
        </div>

        <div class="form-control-row">
          <div class="form-group">
            <label for="formCategory">ประเภทเครื่องยนต์ / สมรรถนะ</label>
            <input type="text" id="formCategory" class="form-control" value="${isEdit ? plane.category : 'Single-Engine'}" placeholder="เช่น Single-Engine, Twin-Jet">
          </div>
          <div class="form-group">
            <label for="formSeat">จำนวนที่นั่ง</label>
            <input type="text" id="formSeat" class="form-control" value="${isEdit ? plane.seat : '4 SEAT'}" placeholder="เช่น 4 SEAT">
          </div>
        </div>

        <div class="form-control-row">
          <div class="form-group">
            <label for="formPlaneTitle">ประเภทการใช้งาน</label>
            <input type="text" id="formPlaneTitle" class="form-control" value="${isEdit ? plane.planeTitle : 'General Aviation'}" placeholder="General Aviation">
          </div>
          <div class="form-group">
            <label for="formStatus">สถานะเริ่มต้น</label>
            <select id="formStatus" class="form-control">
              <option value="1" ${isEdit && plane.status === 1 ? 'selected' : ''}>พร้อมใช้งาน (Available)</option>
              <option value="2" ${isEdit && plane.status === 2 ? 'selected' : ''}>ถูกยืมอยู่ (Borrowed)</option>
              <option value="0" ${isEdit && plane.status === 0 ? 'selected' : ''}>ซ่อมบำรุง (Maintenance)</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label for="formImage">ไฟล์รูปภาพ (Asset Path)</label>
          <input type="text" id="formImage" class="form-control" value="${isEdit ? plane.image : 'assets/images/airplane.jpg'}" placeholder="assets/images/Diamond DA40.png">
        </div>

        <div class="form-group">
          <label for="formDescription">รายละเอียดอากาศยาน</label>
          <textarea id="formDescription" class="form-control" rows="3" placeholder="ระบุข้อมูลจำเพาะและอุปกรณ์ประจำเครื่อง">${isEdit ? plane.planeDescription : ''}</textarea>
        </div>

        <div class="modal-footer" style="padding-left: 0; padding-right: 0; background: transparent; border-top: none;">
          <button type="button" class="btn btn-secondary" onclick="window.app.closeAllModals()">ยกเลิก</button>
          <button type="submit" class="btn btn-primary">${isEdit ? 'บันทึกการแก้ไข' : 'เพิ่มเครื่องบิน'}</button>
        </div>
      </form>
    `;

    this.openModal('planeFormModal');
  }

  handlePlaneFormSubmit(planeID) {
    const data = {
      planeID: planeID,
      planeName: document.getElementById('formPlaneName').value,
      tailNumber: document.getElementById('formTailNumber').value,
      category: document.getElementById('formCategory').value,
      seat: document.getElementById('formSeat').value,
      planeTitle: document.getElementById('formPlaneTitle').value,
      status: Number(document.getElementById('formStatus').value),
      image: document.getElementById('formImage').value || 'assets/images/airplane.jpg',
      planeDescription: document.getElementById('formDescription').value
    };

    this.savePlane(data);
  }
}

// Global initialization
window.addEventListener('DOMContentLoaded', () => {
  window.app = new SkyChauffeurApp();
});
