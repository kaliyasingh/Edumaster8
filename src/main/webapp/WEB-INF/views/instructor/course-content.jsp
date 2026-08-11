<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Curriculum Builder | EduMaster</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<div class="animated-bg"></div>

<button class="menu-toggle" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</button>

<div class="layout">
    <!-- Include Reusable Sidebar -->
    <jsp:include page="sidebar.jsp"/>

    <main class="main-content">
        <div class="page-header">
            <div class="header-content">
                <h1 id="activeCourseTitle">Course Content Builder</h1>
                <p id="activeCourseDesc">Create engaging curriculum with videos, documents, and assessments</p>
                <button class="course-switcher" onclick="showCourseSelector()" id="courseSwitcher" style="display:none;">
                    <i class="fas fa-exchange-alt"></i> Switch Course
                </button>
            </div>
        </div>

        <!-- COURSE SELECTOR -->
        <div class="course-select-container" id="courseSelector">
            <div id="courseList" class="course-list">
                <c:if test="${empty courses}">
                    <div class="empty-state">
                        <i class="fas fa-folder-open"></i>
                        <h3>No courses found</h3>
                        <p>Create a course first to manage its content.</p>
                        <a href="${pageContext.request.contextPath}/instructor/create-course" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Create Course
                        </a>
                    </div>
                </c:if>

                <c:forEach items="${courses}" var="c">
                    <div class="course-list-item"
                         data-course-id="${c.id}"
                         data-course-title="${c.title}"
                         data-course-category="${c.category}"
                         onclick="selectCourseFromElement(this)">
                        <div>
                            <div class="course-option-name">${c.title}</div>
                            <div class="course-option-meta">${c.category}</div>
                        </div>
                        <span class="course-status-badge status-${c.status}">${c.status}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- CURRICULUM AREA -->
        <div id="curriculumContainer" style="display:none;">
            <div class="course-info-bar">
                <div class="info-item">
                    <i class="fas fa-list-ol"></i>
                    <div class="info-item-content">
                        <h4>Sections</h4>
                        <p id="sectionCount">0</p>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-play-circle"></i>
                    <div class="info-item-content">
                        <h4>Video Lessons</h4>
                        <p id="videoCount">0</p>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-file-pdf"></i>
                    <div class="info-item-content">
                        <h4>Documents</h4>
                        <p id="documentCount">0</p>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-tasks"></i>
                    <div class="info-item-content">
                        <h4>Assignments</h4>
                        <p id="assignmentCount">0</p>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-clock"></i>
                    <div class="info-item-content">
                        <h4>Total Duration</h4>
                        <p id="totalDuration">0 hours</p>
                    </div>
                </div>
            </div>

            <div class="content-grid">
                <div class="curriculum-panel">
                    <div class="panel-header">
                        <h2 class="panel-title"><i class="fas fa-layer-group"></i> Curriculum Builder</h2>
                        <button class="btn btn-primary" onclick="openSectionModal()">
                            <i class="fas fa-plus"></i> Add Section
                        </button>
                    </div>
                    <div id="curriculumContent"></div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- SECTION MODAL -->
<div id="sectionModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title" id="sectionModalTitle" >Add New Section</h3>
            <button class="close-modal" onclick="closeSectionModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="form-group">
            <label>Section Title</label>
            <input type="text" id="sectionTitle" placeholder="e.g., Introduction to React">
        </div>
        <div class="form-group">
            <label>Section Description <span class="optional">(Optional)</span></label>
            <textarea id="sectionDescription" placeholder="Brief description of what students will learn..."></textarea>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeSectionModal()">Cancel</button>
            <button class="btn btn-success" onclick="saveSection()"><i class="fas fa-save"></i> Save Section</button>
        </div>
    </div>
</div>

<!-- CONTENT MODAL -->
<div id="contentModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title" id="contentModalTitle">Add Content</h3>
            <button class="close-modal" onclick="closeContentModal()"><i class="fas fa-times"></i></button>
        </div>

        <div class="content-type-tabs">
            <button class="tab-btn active" onclick="switchTab('video')">
                <i class="fas fa-play-circle"></i> Video Lesson
            </button>
            <button class="tab-btn" onclick="switchTab('document')">
                <i class="fas fa-file-pdf"></i> PDF Document
            </button>
            <button class="tab-btn" onclick="switchTab('assignment')">
                <i class="fas fa-tasks"></i> Assignment
            </button>
        </div>

        <!-- Video Tab -->
        <div id="videoTab" class="tab-content active">
        
        <!-- ✅ ADD THIS NEW SECTION -->
		    <div id="currentVideoSection" class="current-video-info" style="display: none;">
		        <div class="current-video-card">
		            <i class="fas fa-video"></i>
		            <div class="current-video-details">
		                <h4>Current Video</h4>
		                <p><span id="currentVideoFileName">intro-html.mp4</span> • <span id="currentVideoDuration">15:30</span></p>
		            </div>
		        </div>
		    </div>
		    
            <div class="form-group">
                <label>Lesson Title <span class="required">*</span></label>
                <input type="text" id="videoTitle" placeholder="e.g., Understanding React Hooks">
            </div>

            <div class="form-group">
                <label>Video Upload <span class="required">*</span></label>
                <div class="file-upload-area" onclick="document.getElementById('videoFile').click()">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <p>Drop your video file here or click to browse</p>
                    <small>Supports: MP4, WebM, MOV (Max: 2GB)</small>
                    <input type="file" id="videoFile" accept="video/*" onchange="handleVideoFile(this)" style="display:none;">
                </div>
                <div class="file-preview" id="videoPreview" style="display:none;">
                    <i class="fas fa-file-video"></i>
                    <div style="flex:1;">
                        <span id="videoFileName" style="display:block;margin-bottom:0.25rem;"></span>
                        <span id="videoDurationDisplay" class="duration-badge" style="display:none;"></span>
                    </div>
                    <button type="button" onclick="clearVideo()"><i class="fas fa-times"></i></button>
                </div>
            </div>

            <div class="form-group">
                <label>Or Video URL <span class="optional">(YouTube/Vimeo)</span></label>
                <input type="url" id="videoUrl" placeholder="https://youtube.com/watch?v=...">
            </div>

            <div class="form-group" id="durationFields" style="display:none;">
                <label>Duration (Auto-detected)</label>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
                    <input type="number" id="videoMinutes" placeholder="Minutes" min="0">
                    <input type="number" id="videoSeconds" placeholder="Seconds" min="0" max="59">
                </div>
            </div>

            <div class="form-group">
                <label>Video Transcript <span class="optional">(Optional)</span></label>
                <textarea id="videoTranscript" placeholder="Full transcript of the video..."></textarea>
            </div>
            
             <div class="form-group">
                    <label>Attached Resources <span class="optional">(Source Code, PDFs)</span></label>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('resourceFile').click()">
                        <i class="fas fa-paperclip"></i> Add Resource
                    </button>
                    <input type="file" id="resourceFile" style="display: none;" multiple onchange="handleResourceFiles(this)">
                    <div class="resources-list" id="resourcesList"></div>
             </div>
        </div>

        <!-- Document Tab -->
        <div id="documentTab" class="tab-content" style="display:none;">
            <div class="form-group">
                <label>Document Title <span class="required">*</span></label>
                <input type="text" id="documentTitle" placeholder="e.g., React Hooks Study Guide">
            </div>
            <div class="form-group">
                <label>PDF Document <span class="required">*</span></label>
                <div class="file-upload-area" onclick="document.getElementById('documentFile').click()">
                    <i class="fas fa-file-pdf"></i>
                    <p>Drop your PDF file here or click to browse</p>
                    <small>Supports: PDF only (Max: 50MB)</small>
                    <input type="file" id="documentFile" accept=".pdf,application/pdf"
                           onchange="handleDocumentFile(this)" style="display:none;">
                </div>
                <div class="file-preview" id="documentPreview" style="display:none;">
                    <i class="fas fa-file-pdf"></i>
                    <div style="flex:1;">
                        <span id="documentFileName" style="display:block;"></span>
                        <span id="documentSize" style="font-size:0.8rem;color:#94a3b8;"></span>
                    </div>
                    <button type="button" onclick="clearDocument()"><i class="fas fa-times"></i></button>
                </div>
            </div>

            <div class="form-group">
                <label>Description <span class="optional">(Optional)</span></label>
                <textarea id="documentDescription" placeholder="Brief description of what this document covers..."></textarea>
            </div>

            <div class="form-group">
                <label style="display:flex;align-items:center;gap:0.5rem;cursor:pointer;">
                    <input type="checkbox" id="documentDownloadable" style="width:auto;" checked>
                    <span>Allow students to download this PDF</span>
                </label>
            </div>
        </div>

        <!-- Assignment Tab -->
        <div id="assignmentTab" class="tab-content" style="display:none;">
            <div class="form-group">
                <label>Assignment Title <span class="required">*</span></label>
                <input type="text" id="assignmentTitle" placeholder="e.g., Build a Todo App">
            </div>

            <div class="form-group">
                <label>Instructions <span class="required">*</span></label>
                <textarea id="assignmentInstructions" placeholder="Detailed instructions for the assignment..."
                          style="min-height:110px;"></textarea>
            </div>

            <div class="form-group">
                <label>Estimated Time (hours)</label>
                <input type="number" id="assignmentTime" placeholder="Time in hours" min="0.5" step="0.5">
            </div>

            <div class="form-group">
                <label style="display:flex;align-items:center;gap:0.5rem;cursor:pointer;">
                    <input type="checkbox" id="allowSubmission" style="width:auto;">
                    <span>Allow student submissions for review</span>
                </label>
            </div>
            <div class="form-group">
                    <label>Resource Files <span class="optional">(Starter code, templates)</span></label>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('assignmentResourceFile').click()">
                        <i class="fas fa-paperclip"></i> Add Resource
                    </button>
                    <input type="file" id="assignmentResourceFile" style="display: none;" multiple onchange="handleAssignmentResourceFiles(this)">
                    <div class="resources-list" id="assignmentResourcesList"></div>
                </div>
           </div>
          
         
          
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeContentModal()">Cancel</button>
            <button class="btn btn-success" onclick="saveContent()" id="saveContentBtn">
                <i class="fas fa-save"></i> Save Content
            </button>
        </div>
    </div>
</div>

<!-- VIEW MODAL (SEPARATE) -->
		<div id="viewModal" class="modal">
		    <div class="modal-content" style="max-width: 900px;">
		        <div class="modal-header">
		            <h3 class="modal-title" id="viewModalTitle">View Content</h3>
		            <button class="close-modal" onclick="closeViewModal()"><i class="fas fa-times"></i></button>
		        </div>
		        <div id="viewModalContent"></div>
		        <div class="modal-footer">
		        </div>
		    </div>
		</div>

<div id="toast" class="toast">
    <i class="fas fa-check-circle"></i>
    <span id="toastMessage"></span>
</div>

<script>
const API_BASE = '${pageContext.request.contextPath}/instructor/course-content';
let activeCourse = null;
let sections = [];
let currentSectionId = null;
let currentContentType = 'video';
let editingSectionId = null;
let videoFile = null;
let documentFile = null;
let detectedDuration = { minutes: 0, seconds: 0 };
let editingContentId = null;
let videoResources = [];
let assignmentResources = [];

function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('active');
}

function showCourseSelector() {
    document.getElementById('courseSelector').style.display = 'block';
    document.getElementById('curriculumContainer').style.display = 'none';
    document.getElementById('courseSwitcher').style.display = 'none';
    activeCourse = null;
    sections = [];
}

function selectCourseFromElement(element) {
    const id = element.getAttribute('data-course-id');
    const title = element.getAttribute('data-course-title');
    const category = element.getAttribute('data-course-category');
    selectCourse(id, title, category);
}

async function selectCourse(id, title, category) {
    activeCourse = { id: id, title: title, category: category };
    document.getElementById('activeCourseTitle').textContent = title;
    document.getElementById('activeCourseDesc').textContent = 'Building curriculum for ' + category;
    document.getElementById('courseSelector').style.display = 'none';
    document.getElementById('curriculumContainer').style.display = 'block';
    document.getElementById('courseSwitcher').style.display = 'inline-flex';
    await loadSections();
}

async function loadSections() {
    try {
        const response = await fetch(API_BASE + '/sections/' + activeCourse.id);
        const data = await response.json();
        if (data.sections) {
            sections = data.sections;
            renderCurriculum();
            updateStats();
        }
    } catch (error) {
        console.error('Error loading sections:', error);
        showToast('Failed to load sections', 'error');
    }
}

function openSectionModal(sectionId) {
    editingSectionId = sectionId || null;
    const modal = document.getElementById('sectionModal');
    const title = document.getElementById('sectionModalTitle');
    if (sectionId) {
        const section = sections.find(function (s) {return s.id === sectionId;});
        title.textContent = 'Edit Section';
        document.getElementById('sectionTitle').value = section.title;
        document.getElementById('sectionDescription').value = section.description || '';
    } else {
        title.textContent = 'Add New Section';
        document.getElementById('sectionTitle').value = '';
        document.getElementById('sectionDescription').value = '';
    }
    modal.classList.add('active');
}

function closeSectionModal() {
    document.getElementById('sectionModal').classList.remove('active');
    editingSectionId = null;
}

async function saveSection() {
    const title = document.getElementById('sectionTitle').value.trim();
    const description = document.getElementById('sectionDescription').value.trim();
    if (!title) {
        showToast('Please enter a section title', 'error');
        return;
    }
    try {
        const formData = new FormData();
        formData.append('courseId', activeCourse.id);
        formData.append('title', title);
        if (description) formData.append('description', description);
        formData.append('orderIndex', sections.length);
        const url = editingSectionId ? API_BASE + '/sections/' + editingSectionId : API_BASE + '/sections';
        const method = editingSectionId ? 'PUT' : 'POST';
        const response = await fetch(url, { method: method, body: formData });
        const data = await response.json();
        if (data.success) {
            showToast(editingSectionId ? 'Section updated!' : 'Section added!', 'success');
            closeSectionModal();
            await loadSections();
        } else {
            showToast(data.error || 'Failed to save section', 'error');
        }
    } catch (error) {
        console.error('Error saving section:', error);
        showToast('Failed to save section', 'error');
    }
}

async function deleteSection(sectionId) {
    if (!confirm('Delete this section and all its content?')) return;
    try {
        const response = await fetch(API_BASE + '/sections/' + sectionId, { method: 'DELETE' });
        const data = await response.json();
        if (data.success) {
            showToast('Section deleted!', 'success');
            await loadSections();
        } else {
            showToast(data.error || 'Failed to delete section', 'error');
        }
    } catch (error) {
        console.error('Error deleting section:', error);
        showToast('Failed to delete section', 'error');
    }
}

function toggleSection(header) {
    const sectionContent = header.nextElementSibling;
    const chevronIcon = header.querySelector('.expand-icon i');
    
    if (sectionContent.classList.contains('collapsed')) {
        // Expand section
        sectionContent.classList.remove('collapsed');
        header.classList.add('expanded');
        chevronIcon.classList.remove('fa-chevron-down');
        chevronIcon.classList.add('fa-chevron-up');
    } else {
        // Collapse section
        sectionContent.classList.add('collapsed');
        header.classList.remove('expanded');
        chevronIcon.classList.remove('fa-chevron-up');
        chevronIcon.classList.add('fa-chevron-down');
    }
}

function openContentModal(sectionId) {
    currentSectionId = sectionId;
    currentContentType = 'video';
    editingContentId = null;
    document.getElementById('contentModalTitle').textContent = 'Add Content';
    switchTab('video');
    clearContentForm();
    enableContentFields(true);
    document.getElementById('saveContentBtn').style.display = 'inline-flex';
    document.getElementById('contentModal').classList.add('active');
}

function closeContentModal() {
    document.getElementById('contentModal').classList.remove('active');
    currentSectionId = null;
    editingContentId = null;
    enableContentFields(true);
    document.getElementById('saveContentBtn').style.display = 'inline-flex';
    clearContentForm();
}

function switchTab(tabName) {
    currentContentType = tabName;
    const tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach(tab => tab.classList.remove('active'));
    const contents = document.querySelectorAll('.tab-content');
    contents.forEach(content => content.style.display = 'none');
    const activeBtn = document.querySelector('.tab-btn[onclick="switchTab(\'' + tabName + '\')"]');
    if (activeBtn) activeBtn.classList.add('active');
    const activeTab = document.getElementById(tabName + 'Tab');
    if (activeTab) activeTab.style.display = 'block';
}

function clearContentForm() {
    document.getElementById('videoTitle').value = '';
    document.getElementById('videoUrl').value = '';
    document.getElementById('videoMinutes').value = '';
    document.getElementById('videoSeconds').value = '';
    document.getElementById('videoTranscript').value = '';
    document.getElementById('videoPreview').style.display = 'none';
    document.getElementById('videoFile').value = '';
    document.getElementById('videoDurationDisplay').style.display = 'none';
    document.getElementById('durationFields').style.display = 'none';
    document.getElementById('documentTitle').value = '';
    document.getElementById('documentDescription').value = '';
    document.getElementById('documentDownloadable').checked = true;
    document.getElementById('documentPreview').style.display = 'none';
    document.getElementById('documentFile').value = '';
    document.getElementById('assignmentTitle').value = '';
    document.getElementById('assignmentInstructions').value = '';
    document.getElementById('assignmentTime').value = '';
    document.getElementById('allowSubmission').checked = false;
    clearResourcesOnModalClose();
    videoFile = null;
    documentFile = null;
    detectedDuration = { minutes: 0, seconds: 0 };
}

// ==================== RESOURCE MANAGEMENT ====================
function handleResourceFiles(input) {
    if (input.files && input.files.length > 0) {
        const fileArray = Array.from(input.files);
        fileArray.forEach(file => {
            const exists = videoResources.some(r => r.name === file.name && r.size === file.size);
            if (!exists) videoResources.push(file);
        });
        renderVideoResources();
        input.value = '';
    }
}

function handleAssignmentResourceFiles(input) {
    if (input.files && input.files.length > 0) {
        const fileArray = Array.from(input.files);
        fileArray.forEach(file => {
            const exists = assignmentResources.some(r => r.name === file.name && r.size === file.size);
            if (!exists) assignmentResources.push(file);
        });
        renderAssignmentResources();
        input.value = '';
    }
}

function renderVideoResources() {
    const container = document.getElementById('resourcesList');
    if (videoResources.length === 0) {
        container.innerHTML = '<p class="no-resources">No resources attached</p>';
        return;
    }
    let html = '';
    videoResources.forEach((file, index) => {
        const fileSize = formatFileSize(file.size);
        const fileIcon = getFileIcon(file.name);
        html += '<div class="resource-item"><i class="' + fileIcon + '"></i><div class="resource-info">';
        html += '<span class="resource-name">' + escapeHtml(file.name) + '</span>';
        html += '<span class="resource-size">' + fileSize + '</span></div>';
        html += '<button type="button" class="btn-remove-resource" onclick="removeVideoResource(' + index + ')" title="Remove">';
        html += '<i class="fas fa-times"></i></button></div>';
    });
    container.innerHTML = html;
}

function renderAssignmentResources() {
    const container = document.getElementById('assignmentResourcesList');
    if (assignmentResources.length === 0) {
        container.innerHTML = '<p class="no-resources">No resources attached</p>';
        return;
    }
    let html = '';
    assignmentResources.forEach((file, index) => {
        const fileSize = formatFileSize(file.size);
        const fileIcon = getFileIcon(file.name);
        html += '<div class="resource-item"><i class="' + fileIcon + '"></i><div class="resource-info">';
        html += '<span class="resource-name">' + escapeHtml(file.name) + '</span>';
        html += '<span class="resource-size">' + fileSize + '</span></div>';
        html += '<button type="button" class="btn-remove-resource" onclick="removeAssignmentResource(' + index + ')" title="Remove">';
        html += '<i class="fas fa-times"></i></button></div>';
    });
    container.innerHTML = html;
}

function removeVideoResource(index) {
    videoResources.splice(index, 1);
    renderVideoResources();
}

function removeAssignmentResource(index) {
    assignmentResources.splice(index, 1);
    renderAssignmentResources();
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

function getFileIcon(filename) {
    const ext = filename.split('.').pop().toLowerCase();
    const iconMap = {
        'pdf': 'fas fa-file-pdf', 'doc': 'fas fa-file-word', 'docx': 'fas fa-file-word',
        'txt': 'fas fa-file-alt', 'xls': 'fas fa-file-excel', 'xlsx': 'fas fa-file-excel',
        'csv': 'fas fa-file-csv', 'ppt': 'fas fa-file-powerpoint', 'pptx': 'fas fa-file-powerpoint',
        'zip': 'fas fa-file-archive', 'rar': 'fas fa-file-archive', '7z': 'fas fa-file-archive',
        'js': 'fas fa-file-code', 'html': 'fas fa-file-code', 'css': 'fas fa-file-code',
        'py': 'fas fa-file-code', 'java': 'fas fa-file-code', 'json': 'fas fa-file-code',
        'jpg': 'fas fa-file-image', 'png': 'fas fa-file-image', 'gif': 'fas fa-file-image',
        'mp4': 'fas fa-file-video', 'mp3': 'fas fa-file-audio'
    };
    return iconMap[ext] || 'fas fa-file';
}

function clearResourcesOnModalClose() {
    videoResources = [];
    assignmentResources = [];
    document.getElementById('resourcesList').innerHTML = '<p class="no-resources">No resources attached</p>';
    document.getElementById('assignmentResourcesList').innerHTML = '<p class="no-resources">No resources attached</p>';
}

function handleVideoFile(input) {
    if (input.files && input.files[0]) {
        videoFile = input.files[0];
        document.getElementById('videoFileName').textContent = videoFile.name;
        document.getElementById('videoPreview').style.display = 'flex';
        const video = document.createElement('video');
        video.preload = 'metadata';
        video.onloadedmetadata = function () {
            window.URL.revokeObjectURL(video.src);
            const duration = Math.floor(video.duration);
            detectedDuration.minutes = Math.floor(duration / 60);
            detectedDuration.seconds = duration % 60;
            document.getElementById('videoMinutes').value = detectedDuration.minutes;
            document.getElementById('videoSeconds').value = detectedDuration.seconds;
            document.getElementById('videoDurationDisplay').textContent = detectedDuration.minutes + ':' + (detectedDuration.seconds < 10 ? '0' : '') + detectedDuration.seconds + ' min';
            document.getElementById('videoDurationDisplay').style.display = 'inline-block';
            document.getElementById('durationFields').style.display = 'block';
        };
        video.src = URL.createObjectURL(videoFile);
    }
}

function clearVideo() {
    document.getElementById('videoFile').value = '';
    document.getElementById('videoPreview').style.display = 'none';
    document.getElementById('videoDurationDisplay').style.display = 'none';
    document.getElementById('durationFields').style.display = 'none';
    videoFile = null;
    detectedDuration = { minutes: 0, seconds: 0 };
}

function handleDocumentFile(input) {
    if (input.files && input.files[0]) {
        documentFile = input.files[0];
        const fileSizeMB = (documentFile.size / (1024 * 1024)).toFixed(2);
        document.getElementById('documentFileName').textContent = documentFile.name;
        document.getElementById('documentSize').textContent = fileSizeMB + ' MB';
        document.getElementById('documentPreview').style.display = 'flex';
    }
}

function clearDocument() {
    document.getElementById('documentFile').value = '';
    document.getElementById('documentPreview').style.display = 'none';
    documentFile = null;
}

async function saveContent() {
    if (!currentSectionId) return;
    const btn = document.getElementById('saveContentBtn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
    try {
        if (currentContentType === 'video') {
            await saveVideoContent(editingContentId);
        } else if (currentContentType === 'document') {
            await saveDocumentContent(editingContentId);
        } else if (currentContentType === 'assignment') {
            await saveAssignmentContent(editingContentId);
        }
    } finally {
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-save"></i> Save Content';
    }
}

async function saveVideoContent(editId) {
    const title = document.getElementById('videoTitle').value.trim();
    if (!title || (!videoFile && !document.getElementById('videoUrl').value.trim())) {
        showToast('Please enter title and provide video', 'error');
        return;
    }
    const formData = new FormData();
    formData.append('sectionId', currentSectionId);
    formData.append('title', title);
    if (videoFile) {
        formData.append('videoFile', videoFile);
        formData.append('durationMinutes', detectedDuration.minutes);
        formData.append('durationSeconds', detectedDuration.seconds);
    } else {
        formData.append('videoUrl', document.getElementById('videoUrl').value.trim());
    }
    const transcript = document.getElementById('videoTranscript').value.trim();
    if (transcript) formData.append('transcript', transcript);
    videoResources.forEach(file => formData.append('resourceFiles', file));
    try {
        const url = editId ? API_BASE + '/content/video/' + editId : API_BASE + '/content/video';
        const method = editId ? 'PUT' : 'POST';
        const response = await fetch(url, { method: method, body: formData });
        const data = await response.json();
        if (data.success) {
            showToast(editId ? 'Video updated!' : 'Video added!', 'success');
            closeContentModal();
            await loadSections();
        } else {
            showToast(data.error || 'Failed to upload video', 'error');
        }
    } catch (error) {
        console.error('Error uploading video:', error);
        showToast('Failed to upload video', 'error');
    }
}

async function saveDocumentContent(editId) {
    const title = document.getElementById('documentTitle').value.trim();
    if (!title || (!documentFile && !editId)) {
        showToast('Please enter title and select PDF', 'error');
        return;
    }
    const formData = new FormData();
    formData.append('sectionId', currentSectionId);
    formData.append('title', title);
    if (documentFile) formData.append('documentFile', documentFile);
    const description = document.getElementById('documentDescription').value.trim();
    if (description) formData.append('description', description);
    formData.append('downloadable', document.getElementById('documentDownloadable').checked);
    try {
        const url = editId ? API_BASE + '/content/document/' + editId : API_BASE + '/content/document';
        const method = editId ? 'PUT' : 'POST';
        const response = await fetch(url, { method: method, body: formData });
        const data = await response.json();
        if (data.success) {
            showToast(editId ? 'Document updated!' : 'Document added!', 'success');
            closeContentModal();
            await loadSections();
        } else {
            showToast(data.error || 'Failed to upload document', 'error');
        }
    } catch (error) {
        console.error('Error uploading document:', error);
        showToast('Failed to upload document', 'error');
    }
}

async function saveAssignmentContent(editId) {
    const title = document.getElementById('assignmentTitle').value.trim();
    const instructions = document.getElementById('assignmentInstructions').value.trim();
    if (!title || !instructions) {
        showToast('Please enter title and instructions', 'error');
        return;
    }
    const formData = new FormData();
    formData.append('sectionId', currentSectionId);
    formData.append('title', title);
    formData.append('instructions', instructions);
    const time = document.getElementById('assignmentTime').value;
    if (time) formData.append('estimatedHours', time);
    formData.append('allowSubmission', document.getElementById('allowSubmission').checked);
    assignmentResources.forEach(file => formData.append('resourceFiles', file));
    try {
        const url = editId ? API_BASE + '/content/assignment/' + editId : API_BASE + '/content/assignment';
        const method = editId ? 'PUT' : 'POST';
        const response = await fetch(url, { method: method, body: formData });
        const data = await response.json();
        if (data.success) {
            showToast(editId ? 'Assignment updated!' : 'Assignment added!', 'success');
            closeContentModal();
            await loadSections();
        } else {
            showToast(data.error || 'Failed to create assignment', 'error');
        }
    } catch (error) {
        console.error('Error creating assignment:', error);
        showToast('Failed to create assignment', 'error');
    }
}

async function deleteContent(contentId) {
    if (!confirm('Delete this content?')) return;
    try {
        const response = await fetch(API_BASE + '/content/' + contentId, { method: 'DELETE' });
        const data = await response.json();
        if (data.success) {
            showToast('Content deleted!', 'success');
            await loadSections();
        } else {
            showToast(data.error || 'Failed to delete content', 'error');
        }
    } catch (error) {
        console.error('Error deleting content:', error);
        showToast('Failed to delete content', 'error');
    }
}

//==================== FIXED RENDER CURRICULUM FUNCTION ====================
//Replace your existing renderCurriculum() function with this one

function renderCurriculum() {
 const container = document.getElementById('curriculumContent');
 if (!sections || sections.length === 0) {
     container.innerHTML = '<div class="empty-state"><i class="fas fa-folder-open"></i><h3>No sections yet</h3><p>Start by adding your first section to build the course curriculum.</p><button class="btn btn-primary" onclick="openSectionModal()"><i class="fas fa-plus"></i> Add First Section</button></div>';
     return;
 }
 let html = '';
 for (let i = 0; i < sections.length; i++) {
     const section = sections[i];
     const contents = section.contents || [];
     const sectionNum = i + 1;
     
     // FIXED: Remove 'expanded' class from section-header by default
     html += '<div class="section-block"><div class="section-header" onclick="toggleSection(this)"><div class="section-info"><div class="section-number">' + sectionNum + '</div><div class="section-details"><h3>' + escapeHtml(section.title) + '</h3><p class="section-meta">' + contents.length + ' items';
     if (section.description) html += ' • ' + escapeHtml(section.description);
     html += '</p></div></div><div class="section-actions"><button class="btn-icon" onclick="event.stopPropagation(); openSectionModal(' + section.id + ')" title="Edit Section"><i class="fas fa-edit"></i></button><button class="btn-icon" onclick="event.stopPropagation(); deleteSection(' + section.id + ')" title="Delete Section"><i class="fas fa-trash"></i></button>';
     
     // FIXED: Change chevron to down by default
     html += '<button class="btn-icon expand-icon"><i class="fas fa-chevron-down"></i></button>';
     html += '</div></div>';
     
     // FIXED: Add 'collapsed' class to section-content by default
     html += '<div class="section-content collapsed">';
     
     if (contents.length === 0) {
         html += '<div class="empty-content"><button class="btn btn-sm btn-secondary" onclick="openContentModal(' + section.id + ')"><i class="fas fa-plus"></i> Add Content</button></div>';
     } else {
         for (let j = 0; j < contents.length; j++) {
             const content = contents[j];
             html += '<div class="content-item">';
             if (content.contentType === 'VIDEO') html += '<div class="content-icon video-icon"><i class="fas fa-play"></i></div>';
             else if (content.contentType === 'DOCUMENT') html += '<div class="content-icon document-icon"><i class="fas fa-file-alt"></i></div>';
             else if (content.contentType === 'ASSIGNMENT') html += '<div class="content-icon assignment-icon"><i class="fas fa-list-check"></i></div>';
             html += '<div class="content-info-wrapper"><h4 class="content-title">' + escapeHtml(content.title) + '</h4><div class="content-badges">';
             if (content.contentType === 'VIDEO') {
                 let displayTime = '00:00';
                 if (content.durationSeconds) {
                     const totalSecs = parseInt(content.durationSeconds);
                     const mins = Math.floor(totalSecs / 60).toString().padStart(2, '0');
                     const secs = (totalSecs % 60).toString().padStart(2, '0');
                     displayTime = mins + ':' + secs;
                 } else if (content.duration) displayTime = content.duration;
                 html += '<span class="content-badge duration-badge">' + displayTime + '</span>';
             } else if (content.contentType === 'DOCUMENT' && content.fileSize) {
                 var bytes = parseFloat(content.fileSize) || 0;
                 var mb = (bytes / 1024 / 1024).toFixed(2);
                 html += '<span class="content-badge size-badge">' + mb + ' MB</span>';
             } else if (content.contentType === 'ASSIGNMENT' && content.estimatedTime) {
                 html += '<span class="content-badge duration-badge">' + content.estimatedTime + '</span>';
             }
             if (content.contentType === 'VIDEO') html += '<span class="content-badge type-badge">Video</span>';
             else if (content.contentType === 'DOCUMENT') html += '<span class="content-badge type-badge">Document</span>';
             else if (content.contentType === 'ASSIGNMENT') html += '<span class="content-badge type-badge">Assignment</span>';
             html += '</div></div><div class="content-actions"><button class="btn-icon" onclick="openEditContent(' + content.id + ')" title="Edit"><i class="fas fa-pen"></i></button><button class="btn-icon" onclick="deleteContent(' + content.id + ')" title="Delete"><i class="fas fa-trash"></i></button><button class="btn-icon" onclick="viewContent(' + content.id + ')" title="View"><i class="fas fa-eye"></i></button></div></div>';
         }
         html += '<div class="add-content-row"><button class="btn btn-sm btn-add-content" onclick="openContentModal(' + section.id + ')"><i class="fas fa-plus"></i> Add Content</button></div>';
     }
     html += '</div></div>';
 }
 container.innerHTML = html;
}
function updateStats() {
    let videoCount = 0, documentCount = 0, assignmentCount = 0, totalMinutes = 0;
    sections.forEach(section => {
        if (section.contents) {
            section.contents.forEach(content => {
                if (content.contentType === 'VIDEO') {
                    videoCount++;
                    if (content.duration) {
                        const parts = content.duration.split(':');
                        if (parts.length === 2) totalMinutes += parseInt(parts[0]) + (parseInt(parts[1]) > 0 ? 1 : 0);
                    }
                } else if (content.contentType === 'DOCUMENT') documentCount++;
                else if (content.contentType === 'ASSIGNMENT') assignmentCount++;
            });
        }
    });
    document.getElementById('sectionCount').textContent = sections.length;
    document.getElementById('videoCount').textContent = videoCount;
    document.getElementById('documentCount').textContent = documentCount;
    document.getElementById('assignmentCount').textContent = assignmentCount;
    const hours = Math.floor(totalMinutes / 60);
    const mins = totalMinutes % 60;
    let durationText = '';
    if (hours > 0) durationText += hours + 'h ';
    if (mins > 0) durationText += mins + 'm';
    if (durationText === '') durationText = '0 hours';
    document.getElementById('totalDuration').textContent = durationText;
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function showToast(message, type) {
    const toast = document.getElementById('toast');
    const icon = toast.querySelector('i');
    const msg = document.getElementById('toastMessage');
    msg.textContent = message;
    if (type === 'error') {
        icon.className = 'fas fa-exclamation-circle';
        toast.style.background = 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)';
    } else {
        icon.className = 'fas fa-check-circle';
        toast.style.background = 'linear-gradient(135deg, #10b981 0%, #059669 100%)';
    }
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
}

function findContentById(contentId) {
    for (let i = 0; i < sections.length; i++) {
        const sec = sections[i];
        if (sec.contents) {
            const found = sec.contents.find(c => c.id === contentId);
            if (found) return { section: sec, content: found };
        }
    }
    return null;
}

function enableContentFields(enabled) {
    document.querySelectorAll('#contentModal input, #contentModal textarea, #contentModal select').forEach(el => {
        if (el.type === 'checkbox') el.disabled = !enabled;
        else el.readOnly = !enabled;
    });
}
//This function is called when user clicks the "View" button
function viewContent(contentId) {
    const result = findContentById(contentId);
    if (!result) {
        showToast('Content not found', 'error');
        return;
    }
    
    console.log('Content data:', result.content);
    
    const modal = document.getElementById('viewModal');
    const title = document.getElementById('viewModalTitle');
    const content = document.getElementById('viewModalContent');
    
    title.textContent = result.content.title || 'View Content';
    
    if (result.content.contentType === 'VIDEO') {
        let duration = '00:00';
        if (result.content.durationSeconds) {
            const totalSecs = parseInt(result.content.durationSeconds);
            const mins = Math.floor(totalSecs / 60).toString().padStart(2, '0');
            const secs = (totalSecs % 60).toString().padStart(2, '0');
            duration = mins + ':' + secs;
        } else if (result.content.duration) {
            duration = result.content.duration;
        }
        
        const videoUrl = result.content.videoUrl || 
                        result.content.fileUrl || 
                        result.content.url || 
                        result.content.video_url || '';
        const fileName = result.content.videoFileName || 
                        result.content.video_file_name || 
                        (videoUrl ? videoUrl.split('/').pop() : 'No file uploaded');
        const hasVideo = videoUrl && 
                        videoUrl.trim() !== '' && 
                        videoUrl !== 'null' && 
                        videoUrl !== 'undefined';
        const isCloudinaryVideo = hasVideo && (videoUrl.includes('cloudinary.com') || videoUrl.includes('res.cloudinary.com'));
        const isYouTubeVideo = hasVideo && (videoUrl.includes('youtube.com') || videoUrl.includes('youtu.be'));
        const isVimeoVideo = hasVideo && videoUrl.includes('vimeo.com');
        
        console.log('=== VIDEO DEBUG ===');
        console.log('Full content object:', result.content);
        console.log('videoUrl field:', result.content.videoUrl);
        console.log('fileUrl field:', result.content.fileUrl);
        console.log('Final Video URL:', videoUrl);
        console.log('Has Video:', hasVideo);
        console.log('Is Cloudinary:', isCloudinaryVideo);
        console.log('Field names in object:', Object.keys(result.content));
        
        let html = '';
        html += '<div class="view-content-section">';
        html += '<h4><i class="fas fa-video"></i> Video Preview</h4>';
        
        if (hasVideo && isCloudinaryVideo) {
            html += '<div class="video-player-container">';
            html += '<video controls style="width:100%;height:100%;">';
            html += '<source src="' + escapeHtml(videoUrl) + '" type="video/mp4">';
            html += 'Your browser does not support the video tag.';
            html += '</video>';
            html += '</div>';
        } else if (hasVideo && isYouTubeVideo) {
            let videoId = '';
            if (videoUrl.includes('youtube.com/watch?v=')) {
                videoId = videoUrl.split('v=')[1].split('&')[0];
            } else if (videoUrl.includes('youtu.be/')) {
                videoId = videoUrl.split('youtu.be/')[1].split('?')[0];
            }
            if (videoId) {
                html += '<div class="video-player-container">';
                html += '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/' + videoId + '" ';
                html += 'frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
                html += '</div>';
            }
        } else if (hasVideo && isVimeoVideo) {
            const videoId = videoUrl.split('vimeo.com/')[1];
            if (videoId) {
                html += '<div class="video-player-container">';
                html += '<iframe width="100%" height="100%" src="https://player.vimeo.com/video/' + videoId + '" ';
                html += 'frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>';
                html += '</div>';
            }
        } else {
            html += '<div class="video-placeholder">';
            html += '<i class="fas fa-film"></i>';
            html += '<p>Video file: ' + escapeHtml(fileName) + '</p>';
            if (hasVideo) {
                html += '<p style="font-size: 0.85rem; word-break: break-all; margin-top: 0.5rem;">URL: <a href="' + escapeHtml(videoUrl) + '" target="_blank">' + escapeHtml(videoUrl) + '</a></p>';
            } else {
                html += '<p style="color: #ef4444; margin-top: 0.5rem;">No video URL found in database</p>';
            }
            html += '</div>';
        }
        
        html += '<div class="video-meta-bar">';
        html += '<div class="video-meta-item"><i class="fas fa-clock"></i><strong>Duration:</strong> ' + duration + '</div>';
        html += '<div class="video-meta-item"><i class="fas fa-file"></i><strong>File:</strong> ' + escapeHtml(fileName) + '</div>';
        html += '</div>';
        html += '</div>';
        
        if (result.content.transcript) {
            html += '<div class="view-content-section">';
            html += '<h4><i class="fas fa-align-left"></i> Transcript</h4>';
            html += '<div class="transcript-box">';
            html += '<p>' + escapeHtml(result.content.transcript) + '</p>';
            html += '</div>';
            html += '</div>';
        }
        
        html += '<div class="view-content-section">';
        html += '<h4><i class="fas fa-paperclip"></i> Resources</h4>';
        
        if (result.content.resources && result.content.resources.length > 0) {
            result.content.resources.forEach(function(res) {
                const resFileName = res.split('/').pop();
                const fileIcon = getFileIcon(resFileName);
                html += '<div class="resource-card">';
                html += '<div class="resource-card-content">';
                html += '<i class="' + fileIcon + '"></i>';
                html += '<span class="resource-filename">' + escapeHtml(resFileName) + '</span>';
                html += '</div>';
                html += '<button type="button" class="resource-download-btn" onclick="window.open(\'' + escapeHtml(res) + '\', \'_blank\')">';
                html += 'Download</button>';
                html += '</div>';
            });
        } else {
            html += '<p style="color:#94a3b8;">No resources attached.</p>';
        }
        
        html += '</div>';
        content.innerHTML = html;
        
    } else if (result.content.contentType === 'DOCUMENT') {
        const documentUrl = result.content.fileUrl || 
                           result.content.documentUrl || 
                           result.content.url || '';
        const hasFile = documentUrl && 
                       documentUrl.trim() !== '' && 
                       documentUrl !== 'null' && 
                       documentUrl !== 'undefined' &&
                       documentUrl.length > 0;
        
        console.log('=== DOCUMENT DEBUG ===');
        console.log('Document URL (fileUrl):', documentUrl);
        console.log('Has File:', hasFile);
        
        const fileName = hasFile ? (result.content.documentFileName || documentUrl.split('/').pop()) : 'No file uploaded';
        const fileSize = result.content.fileSize ? (parseFloat(result.content.fileSize) / 1024 / 1024).toFixed(1) + ' MB' : '0.04 MB';
        const downloadable = result.content.downloadable ? 'Downloadable' : 'View only';
        
        let html = '';
        html += '<div class="view-content-section">';
        html += '<h4><i class="fas fa-file-pdf"></i> PDF Document</h4>';
        html += '<div class="pdf-viewer-container">';
        html += '<div class="pdf-icon-large">';
        html += '<i class="fas fa-file-pdf"></i>';
        html += '</div>';
        html += '<div class="pdf-info">';
        html += '<h5>' + escapeHtml(fileName) + '</h5>';
        html += '<p>' + escapeHtml(result.content.description || 'No description provided.') + '</p>';
        html += '</div>';
        
        if (hasFile) {
            html += '<div class="pdf-actions">';
            html += '<button class="pdf-btn-preview" onclick="window.open(\'' + escapeHtml(documentUrl) + '\', \'_blank\')">';
            html += '<div class="pdf-btn-icon"><i class="fas fa-eye"></i></div>';
            html += '<span>Preview</span>';
            html += '</button>';
            if (result.content.downloadable) {
                // FIXED: Modify URL to force download by adding fl_attachment flag
                const downloadUrl = documentUrl.replace('/upload/', '/upload/fl_attachment/');
                html += '<button class="pdf-btn-download" onclick="window.open(\'' + escapeHtml(downloadUrl) + '\', \'_blank\')">';
                html += '<div class="pdf-btn-icon"><i class="fas fa-download"></i></div>';
                html += '<span>Download</span>';
                html += '</button>';
            }
            html += '</div>';
        }
        
        html += '</div>';
        html += '<div class="pdf-meta-bar">';
        html += '<div class="pdf-meta-item"><i class="fas fa-weight-hanging"></i> <span>' + fileSize + '</span></div>';
        html += '<div class="pdf-meta-item"><i class="fas fa-hand-pointer"></i> <span>' + downloadable + '</span></div>';
        html += '</div>';
        html += '</div>';
        content.innerHTML = html;
        
    } else if (result.content.contentType === 'ASSIGNMENT') {
        const timeDisplay = result.content.estimatedTime || 'Flexible time';
        const submissionStatus = result.content.allowSubmission ? 'Submissions allowed' : 'Submissions not allowed';
        
        let html = '';
        html += '<div class="view-content-section">';
        html += '<h4><i class="fas fa-tasks"></i> Assignment Details</h4>';
        html += '<div class="assignment-instructions-box">';
        html += '<h5><i class="fas fa-info-circle"></i> Instructions</h5>';
        html += '<p>' + escapeHtml(result.content.instructions || 'No instructions provided.') + '</p>';
        html += '</div>';
        html += '<div class="assignment-meta-bar">';
        html += '<div class="assignment-meta-item"><i class="fas fa-clock"></i> <span>' + escapeHtml(timeDisplay) + '</span></div>';
        html += '<div class="assignment-meta-item"><i class="fas fa-upload"></i> <span>' + submissionStatus + '</span></div>';
        html += '</div>';
        html += '</div>';
        
        if (result.content.resources && result.content.resources.length > 0) {
            html += '<div class="view-content-section">';
            html += '<h4><i class="fas fa-paperclip"></i> Resources</h4>';
            
            result.content.resources.forEach(function(res) {
                const resFileName = res.split('/').pop();
                const fileIcon = getFileIcon(resFileName);
                html += '<div class="resource-card">';
                html += '<div class="resource-card-content">';
                html += '<i class="' + fileIcon + '"></i>';
                html += '<span class="resource-filename">' + escapeHtml(resFileName) + '</span>';
                html += '</div>';
                html += '<button type="button" class="resource-download-btn" onclick="window.open(\'' + escapeHtml(res) + '\', \'_blank\')">';
                html += 'Download</button>';
                html += '</div>';
            });
            
            html += '</div>';
        }
        
        content.innerHTML = html;
    }
    
    modal.classList.add('active');
}

function closeViewModal() {
    const modal = document.getElementById('viewModal');
    
    // Stop all videos when closing modal
    const videos = modal.querySelectorAll('video');
    videos.forEach(video => {
        video.pause();
        video.currentTime = 0;
    });
    
    // Stop all iframes (YouTube/Vimeo) by reloading their src
    const iframes = modal.querySelectorAll('iframe');
    iframes.forEach(iframe => {
        const src = iframe.src;
        iframe.src = '';
        iframe.src = src;
    });
    
    modal.classList.remove('active');
}

function openEditContent(contentId) {
    const result = findContentById(contentId);
    if (!result) return;
    
    currentSectionId = result.section.id;
    editingContentId = contentId;
    document.getElementById('contentModalTitle').textContent = 'Edit Content';
    document.getElementById('saveContentBtn').style.display = 'inline-flex';
    enableContentFields(true);
    
    // Clear previous resources
    videoResources = [];
    assignmentResources = [];
    
    if (result.content.contentType === 'VIDEO') {
        switchTab('video');
        document.getElementById('videoTitle').value = result.content.title || '';
        document.getElementById('videoUrl').value = result.content.videoUrl || '';
        document.getElementById('videoTranscript').value = result.content.transcript || '';
        
        // Show existing video file info
        if (result.content.videoUrl && !result.content.videoUrl.includes('youtube') && !result.content.videoUrl.includes('vimeo')) {
            const fileName = result.content.videoUrl.split('/').pop();
            document.getElementById('videoFileName').textContent = fileName || 'video.mp4';
            document.getElementById('videoPreview').style.display = 'flex';
        }
        
        // Set duration
        if (result.content.durationSeconds) {
            const totalSecs = parseInt(result.content.durationSeconds);
            detectedDuration.minutes = Math.floor(totalSecs / 60);
            detectedDuration.seconds = totalSecs % 60;
            document.getElementById('videoMinutes').value = detectedDuration.minutes;
            document.getElementById('videoSeconds').value = detectedDuration.seconds;
            document.getElementById('videoDurationDisplay').textContent = detectedDuration.minutes + ':' + (detectedDuration.seconds < 10 ? '0' : '') + detectedDuration.seconds + ' min';
            document.getElementById('videoDurationDisplay').style.display = 'inline-block';
            document.getElementById('durationFields').style.display = 'block';
        } else if (result.content.duration) {
            const parts = result.content.duration.split(':');
            if (parts.length === 2) {
                detectedDuration.minutes = parseInt(parts[0]);
                detectedDuration.seconds = parseInt(parts[1]);
                document.getElementById('videoMinutes').value = detectedDuration.minutes;
                document.getElementById('videoSeconds').value = detectedDuration.seconds;
                document.getElementById('videoDurationDisplay').textContent = result.content.duration + ' min';
                document.getElementById('videoDurationDisplay').style.display = 'inline-block';
                document.getElementById('durationFields').style.display = 'block';
            }
        }
        
        // Load existing resources
        if (result.content.resources && result.content.resources.length > 0) {
            loadExistingResources(result.content.resources, 'video');
        }
        
    } else if (result.content.contentType === 'DOCUMENT') {
        switchTab('document');
        document.getElementById('documentTitle').value = result.content.title || '';
        document.getElementById('documentDescription').value = result.content.description || '';
        document.getElementById('documentDownloadable').checked = !!result.content.downloadable;
        
        // Show existing document info - FIXED: Use fileUrl instead of documentUrl
        const documentUrl = result.content.fileUrl || result.content.documentUrl || '';
        if (documentUrl && documentUrl.trim() !== '') {
            const fileName = result.content.documentFileName || documentUrl.split('/').pop();
            const fileSize = result.content.fileSize ? (parseFloat(result.content.fileSize) / 1024 / 1024).toFixed(2) : '0.00';
            document.getElementById('documentFileName').textContent = fileName || 'document.pdf';
            document.getElementById('documentSize').textContent = fileSize + ' MB';
            document.getElementById('documentPreview').style.display = 'flex';
        }
        
    } else if (result.content.contentType === 'ASSIGNMENT') {
        switchTab('assignment');
        document.getElementById('assignmentTitle').value = result.content.title || '';
        document.getElementById('assignmentInstructions').value = result.content.instructions || '';
        document.getElementById('assignmentTime').value = result.content.estimatedTime || '';
        document.getElementById('allowSubmission').checked = !!result.content.allowSubmission;
        
        // Load existing resources
        if (result.content.resources && result.content.resources.length > 0) {
            loadExistingResources(result.content.resources, 'assignment');
        }
    }
    
    document.getElementById('contentModal').classList.add('active');
}

function loadExistingResources(resourceUrls, type) {
    if (!resourceUrls || resourceUrls.length === 0) return;
    
    const container = type === 'video' ? document.getElementById('resourcesList') : document.getElementById('assignmentResourcesList');
    let html = '';
    
    resourceUrls.forEach((url, index) => {
        const fileName = url.split('/').pop();
        const fileIcon = getFileIcon(fileName);
        
        html += '<div class="resource-item existing-resource" data-url="' + escapeHtml(url) + '">';
        html += '<i class="' + fileIcon + '"></i>';
        html += '<div class="resource-info">';
        html += '<span class="resource-name">' + escapeHtml(fileName) + '</span>';
        html += '<span class="resource-size">Existing file</span>';
        html += '</div>';
        html += '<button type="button" class="btn-remove-resource" onclick="removeExistingResource(this, \'' + type + '\')" title="Remove">';
        html += '<i class="fas fa-times"></i>';
        html += '</button>';
        html += '</div>';
    });
    
    container.innerHTML = html;
}

function removeExistingResource(button, type) {
    const resourceItem = button.closest('.resource-item');
    resourceItem.remove();
    
    // Check if container is empty
    const container = type === 'video' ? document.getElementById('resourcesList') : document.getElementById('assignmentResourcesList');
    if (container.children.length === 0) {
        container.innerHTML = '<p class="no-resources">No resources attached</p>';
    }
}
</script>

<style>
/* ==================== CURRICULUM BUILDER - UPDATED CSS ==================== */
/* Enhanced Modern Design with Animations & Glassmorphism */

/* ==================== RESET & BASE ==================== */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
    color: #e2e8f0;
    overflow-x: hidden;
    line-height: 1.4;
}
/* ==================== VIEW CONTENT MODAL CSS ==================== */
.section-content.collapsed {
    display: none;
    max-height: 0;
    overflow: hidden;
}

.section-content {
    display: block;
}
/* View Content Section Base */
.view-content-section {
    margin-bottom: 2rem;
}

.view-content-section:last-child {
    margin-bottom: 2rem;
}

.view-content-section h4 {
    font-size: 1.1rem;
    margin-bottom: 1rem;
    color: #6366f1;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.view-content-section h4 i {
    font-size: 1rem;
}

/* Video Player Container */
.video-player-container {
    background: #000;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 1.5rem;
    aspect-ratio: 16/9;
    position: relative;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

.video-player-container video,
.video-player-container iframe {
    width: 100%;
    height: 100%;
    display: block;
    object-fit: contain;
    border: none;
}

/* Video Placeholder */
.video-placeholder {
    background: linear-gradient(135deg, #1e293b, #0f172a);
    padding: 4rem 2rem;
    text-align: center;
    border-radius: 12px;
    margin-bottom: 1.5rem;
    border: 2px dashed rgba(99, 102, 241, 0.3);
    aspect-ratio: 16/9;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.video-placeholder i {
    font-size: 4rem;
    color: #6366f1;
    margin-bottom: 1rem;
    opacity: 0.5;
    animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 0.5; }
    50% { opacity: 0.7; }
}

.video-placeholder p {
    color: #94a3b8;
    margin-bottom: 0.5rem;
    font-size: 0.95rem;
}

.video-placeholder a {
    color: #6366f1;
    text-decoration: none;
    font-weight: 600;
    word-break: break-all;
}

.video-placeholder a:hover {
    text-decoration: underline;
    color: #8b5cf6;
}

/* Video Meta Bar */
.video-meta-bar {
    display: flex;
    gap: 2rem;
    padding: 1rem;
    background: rgba(99, 102, 241, 0.1);
    border-radius: 10px;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
}

.video-meta-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #e2e8f0;
    font-size: 0.9rem;
}

.video-meta-item i {
    color: #6366f1;
    font-size: 1rem;
}

.video-meta-item strong {
    color: #94a3b8;
    margin-right: 0.25rem;
}

/* Transcript Box */
.transcript-box {
    background: rgba(15, 23, 42, 0.5);
    border: 1px solid rgba(99, 102, 241, 0.2);
    border-radius: 12px;
    padding: 1.5rem;
    margin-top: 1rem;
    max-height: 300px;
    overflow-y: auto;
}

.transcript-box p {
    color: #cbd5e1;
    line-height: 1.8;
    white-space: pre-wrap;
    margin: 0;
}

.transcript-box::-webkit-scrollbar {
    width: 8px;
}

.transcript-box::-webkit-scrollbar-track {
    background: rgba(15, 23, 42, 0.5);
    border-radius: 10px;
}

.transcript-box::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    border-radius: 10px;
}

/* Resources Card Styling - NEW DESIGN */
.resource-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: rgba(15, 23, 42, 0.5);
    border: 1px solid rgba(99, 102, 241, 0.2);
    border-radius: 10px;
    padding: 1rem 1.25rem;
    margin-bottom: 0.75rem;
    transition: all 0.3s ease;
}

.resource-card:hover {
    border-color: #6366f1;
    background: rgba(99, 102, 241, 0.1);
    transform: translateX(4px);
}

.resource-card-content {
    display: flex;
    align-items: center;
    gap: 1rem;
    flex: 1;
}

.resource-card-content i {
    font-size: 1.5rem;
    color: #6366f1;
    min-width: 24px;
}

.resource-filename {
    color: #e2e8f0;
    font-size: 15px;
    font-weight: 500;
    word-break: break-word;
}

.resource-download-btn {
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    white-space: nowrap;
}

.resource-download-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
}

.resource-download-btn:active {
    transform: translateY(0);
}

/* PDF Viewer Container */
.pdf-viewer-container {
    background: rgba(30, 41, 59, 0.6);
    border-radius: 12px;
    padding: 2rem 1.5rem;
    text-align: center;
    margin-bottom: 1.5rem;
    border: 1px solid rgba(71, 85, 105, 0.5);
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

/* PDF Large Icon */
.pdf-icon-large {
    position: relative;
    display: inline-block;
    margin-bottom: 1rem;
}

.pdf-icon-large i {
    font-size: 4rem;
    color: #ef4444;
    display: block;
}

.pdf-icon-large span {
    position: absolute;
    bottom: 0.6rem;
    left: 50%;
    transform: translateX(-50%);
    color: white;
    font-weight: 700;
    font-size: 1rem;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.pdf-info {
    margin-bottom: 1.5rem;
}

.pdf-info h5 {
    font-size: 1.1rem;
    margin-bottom: 0.5rem;
    color: #e2e8f0;
    font-weight: 600;
}

.pdf-info p {
    color: #94a3b8;
    font-size: 0.9rem;
    line-height: 1.5;
}

/* PDF Action Buttons */
.pdf-actions {
    display: flex;
    gap: 0.75rem;
    justify-content: center;
    flex-wrap: wrap;
}

.pdf-btn-preview,
.pdf-btn-download {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.4rem;
    padding: 0.875rem 1.75rem;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 0.9rem;
    font-weight: 600;
    min-width: 120px;
}

.pdf-btn-preview {
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    color: white;
}

.pdf-btn-preview:hover {
    background: linear-gradient(135deg, #4f46e5, #4338ca);
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
}

.pdf-btn-download {
    background: rgba(51, 65, 85, 0.6);
    border: 1px solid rgba(71, 85, 105, 0.6);
    color: #e2e8f0;
}

.pdf-btn-download:hover {
    background: rgba(71, 85, 105, 0.8);
    border-color: rgba(99, 102, 241, 0.5);
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(71, 85, 105, 0.3);
}

.pdf-btn-icon {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.1);
}

.pdf-btn-preview .pdf-btn-icon {
    background: rgba(239, 68, 68, 0.2);
}

.pdf-btn-download .pdf-btn-icon {
    background: rgba(239, 68, 68, 0.2);
}

.pdf-btn-icon i {
    font-size: 1.3rem;
    color: #ef4444;
}

/* PDF Meta Bar */
.pdf-meta-bar {
    display: flex;
    gap: 2rem;
    padding: 1rem;
    background: rgba(99, 102, 241, 0.1);
    border-radius: 10px;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
    justify-content: center;
}

.pdf-meta-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #e2e8f0;
    font-size: 0.9rem;
}

.pdf-meta-item i {
    color: #6366f1;
    font-size: 1rem;
}

/* Assignment Instructions Box */
.assignment-instructions-box {
    background: rgba(15, 23, 42, 0.5);
    border: 1px solid rgba(99, 102, 241, 0.2);
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
}

.assignment-instructions-box h5 {
    color: #6366f1;
    margin-bottom: 1rem;
    font-size: 1rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.assignment-instructions-box p {
    color: #e2e8f0;
    line-height: 1.6;
    white-space: pre-wrap;
    margin: 0;
}

/* Assignment Meta Bar */
.assignment-meta-bar {
    display: flex;
    gap: 2rem;
    padding: 1rem;
    background: rgba(99, 102, 241, 0.1);
    border-radius: 10px;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
}

.assignment-meta-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #e2e8f0;
    font-size: 0.9rem;
}

.assignment-meta-item i {
    color: #6366f1;
    font-size: 1rem;
}

/* Icon Colors for Resources */
.resource-card-content .fa-file-pdf { color: #ef4444; }
.resource-card-content .fa-file-word { color: #3b82f6; }
.resource-card-content .fa-file-excel { color: #10b981; }
.resource-card-content .fa-file-powerpoint { color: #f59e0b; }
.resource-card-content .fa-file-archive { color: #8b5cf6; }
.resource-card-content .fa-file-code { color: #06b6d4; }
.resource-card-content .fa-file-image { color: #ec4899; }
.resource-card-content .fa-file-video { color: #f97316; }
.resource-card-content .fa-file-audio { color: #14b8a6; }

/* Attached Resource Items - For Edit/Upload Forms */
.attached-resource-item {
    background: rgba(71, 85, 105, 0.3);
    border: 1px solid rgba(71, 85, 105, 0.5);
    border-radius: 10px;
    padding: 14px 16px;
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 8px;
    transition: all 0.2s ease;
}

.attached-resource-item:hover {
    background: rgba(71, 85, 105, 0.4);
    border-color: rgba(99, 102, 241, 0.5);
}

.resource-file-icon {
    font-size: 24px;
    color: #6366f1;
    min-width: 24px;
}

.attached-resource-info {
    flex: 1;
    min-width: 0;
}

.attached-resource-name {
    font-size: 15px;
    font-weight: 600;
    color: #e2e8f0;
    margin-bottom: 2px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.attached-resource-label {
    font-size: 13px;
    color: #94a3b8;
}

.btn-delete-resource {
    background: transparent;
    border: none;
    color: #94a3b8;
    padding: 8px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-delete-resource:hover {
    background: rgba(239, 68, 68, 0.2);
    color: #ef4444;
}

.btn-delete-resource i {
    font-size: 16px;
}

.attached-resource-item.existing-resource {
    border-left: 3px solid #6366f1;
}

.attached-resource-item[data-deleted="true"] {
    opacity: 0.5;
    pointer-events: none;
}

/* Responsive Design */
@media (max-width: 768px) {
    .video-placeholder {
        padding: 2rem 1rem;
    }
    
    .video-meta-bar,
    .pdf-meta-bar,
    .assignment-meta-bar {
        flex-direction: column;
        gap: 1rem;
    }
    
    .pdf-viewer-container {
        padding: 1.5rem;
    }
    
    .resource-card {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .resource-download-btn {
        width: 100%;
        justify-content: center;
    }
}

/* ==================== RESOURCE ATTACHMENTS - CSS ==================== */
.current-video-info {
    margin-bottom: 20px;
}

.current-video-card {
    background: rgba(99, 102, 241, 0.1);
    border: 2px solid rgba(99, 102, 241, 0.3);
    border-radius: 12px;
    padding: 16px;
    display: flex;
    align-items: center;
    gap: 12px;
}

.current-video-card i {
    font-size: 32px;
    color: #6366f1;
}

.current-video-details h4 {
    margin: 0 0 4px 0;
    font-size: 14px;
    color: #94a3b8;
    font-weight: 500;
}

.current-video-details p {
    margin: 0;
    font-size: 16px;
    color: #e2e8f0;
    font-weight: 600;
}

/* Resources List Container */
.resources-list {
    margin-top: 1rem;
    border: 2px solid rgba(99, 102, 241, 0.3);
    border-radius: 12px;
    background: rgba(15, 23, 42, 0.4);
    padding: 1rem;
    max-height: 300px;
    overflow-y: auto;
}

/* No Resources Message */
.no-resources {
    text-align: center;
    color: #64748b;
    font-size: 0.875rem;
    padding: 1.5rem;
    font-style: italic;
}

/* Individual Resource Item */
.resource-item {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.875rem;
    background: rgba(30, 41, 59, 0.6);
    border-radius: 10px;
    margin-bottom: 0.625rem;
    border: 1px solid rgba(71, 85, 105, 0.4);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    animation: resourceSlideIn 0.3s ease;
}

@keyframes resourceSlideIn {
    from {
        opacity: 0;
        transform: translateX(-20px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

.resource-item:last-child {
    margin-bottom: 0;
}

.resource-item:hover {
    background: rgba(30, 41, 59, 0.8);
    border-color: rgba(99, 102, 241, 0.5);
    transform: translateX(4px);
}

/* Resource Icon */
.resource-item > i {
    font-size: 1.5rem;
    color: #6366f1;
    min-width: 32px;
    text-align: center;
}

/* Resource Icon Color Variations */
.resource-item .fa-file-pdf {
    color: #ef4444;
}

.resource-item .fa-file-word {
    color: #3b82f6;
}

.resource-item .fa-file-excel {
    color: #10b981;
}

.resource-item .fa-file-powerpoint {
    color: #f59e0b;
}

.resource-item .fa-file-archive {
    color: #8b5cf6;
}

.resource-item .fa-file-code {
    color: #06b6d4;
}

.resource-item .fa-file-image {
    color: #ec4899;
}

.resource-item .fa-file-video {
    color: #f97316;
}

.resource-item .fa-file-audio {
    color: #14b8a6;
}

/* Resource Info */
.resource-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
}

.resource-name {
    font-weight: 600;
    color: #e2e8f0;
    font-size: 0.9375rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.resource-size {
    font-size: 0.8125rem;
    color: #94a3b8;
    font-weight: 500;
}

/* Remove Resource Button */
.btn-remove-resource {
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #ef4444;
    cursor: pointer;
    padding: 0.5rem;
    border-radius: 8px;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 32px;
    height: 32px;
}

.btn-remove-resource:hover {
    background: rgba(239, 68, 68, 0.2);
    border-color: #ef4444;
    transform: scale(1.1) rotate(90deg);
}

.btn-remove-resource i {
    font-size: 0.875rem;
}

/* Add Resource Button Enhancement */
.form-group .btn-secondary.btn-sm {
    margin-bottom: 0.75rem;
    background: rgba(99, 102, 241, 0.15);
    border: 2px dashed rgba(99, 102, 241, 0.4);
    color: #a5b4fc;
    font-weight: 600;
    padding: 0.625rem 1.25rem;
    transition: all 0.3s ease;
}

.form-group .btn-secondary.btn-sm:hover {
    background: rgba(99, 102, 241, 0.25);
    border-color: #6366f1;
    border-style: solid;
    color: #c7d2fe;
    transform: translateY(-2px);
}

/* Resources List Scrollbar */
.resources-list::-webkit-scrollbar {
    width: 8px;
}

.resources-list::-webkit-scrollbar-track {
    background: rgba(15, 23, 42, 0.5);
    border-radius: 10px;
}

.resources-list::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    border-radius: 10px;
}

.resources-list::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(135deg, #8b5cf6, #a855f7);
}

/* Empty State for Resources */
.resources-list:empty::after {
    content: 'No resources attached yet';
    display: block;
    text-align: center;
    color: #64748b;
    font-size: 0.875rem;
    padding: 1.5rem;
    font-style: italic;
}

/* Resource Count Badge (Optional) */
.resource-count-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.375rem;
    background: rgba(99, 102, 241, 0.2);
    color: #a5b4fc;
    padding: 0.25rem 0.625rem;
    border-radius: 6px;
    font-size: 0.75rem;
    font-weight: 700;
    margin-left: 0.5rem;
    border: 1px solid rgba(99, 102, 241, 0.3);
}

/* Drag and Drop Styling (Optional Enhancement) */
.resources-list.drag-over {
    border-color: #6366f1;
    background: rgba(99, 102, 241, 0.1);
}

/* Loading State for Resources */
.resource-item.loading {
    opacity: 0.6;
    pointer-events: none;
}

.resource-item.loading::after {
    content: '';
    position: absolute;
    top: 50%;
    right: 1rem;
    width: 16px;
    height: 16px;
    border: 2px solid rgba(99, 102, 241, 0.3);
    border-top-color: #6366f1;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
}

@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}

/* Responsive Adjustments for Resources */
@media (max-width: 600px) {
    .resource-item {
        padding: 0.75rem;
    }
    
    .resource-item > i {
        font-size: 1.25rem;
        min-width: 28px;
    }
    
    .resource-name {
        font-size: 0.875rem;
    }
    
    .resource-size {
        font-size: 0.75rem;
    }
    
    .btn-remove-resource {
        min-width: 28px;
        height: 28px;
        padding: 0.375rem;
    }
    
    .resources-list {
        max-height: 200px;
    }
}

/* File Type Specific Styling */
.resource-item[data-file-type="pdf"] {
    border-left: 3px solid #ef4444;
}

.resource-item[data-file-type="doc"],
.resource-item[data-file-type="docx"] {
    border-left: 3px solid #3b82f6;
}

.resource-item[data-file-type="zip"],
.resource-item[data-file-type="rar"] {
    border-left: 3px solid #8b5cf6;
}

.resource-item[data-file-type="code"] {
    border-left: 3px solid #06b6d4;
}

/* Success/Error States */
.resource-item.success {
    border-color: rgba(16, 185, 129, 0.5);
    background: rgba(16, 185, 129, 0.1);
}

.resource-item.error {
    border-color: rgba(239, 68, 68, 0.5);
    background: rgba(239, 68, 68, 0.1);
}

/* Hover Effects Enhancement */
.resource-item {
    position: relative;
    overflow: hidden;
}

.resource-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(99, 102, 241, 0.1), transparent);
    transition: left 0.5s ease;
}

.resource-item:hover::before {
    left: 100%;
}
/* ==================== ANIMATED BACKGROUND ==================== */
.animated-bg {
    position: fixed;
    inset: 0;
    z-index: 0;
    pointer-events: none;
    overflow: hidden;
}

.animated-bg::before,
.animated-bg::after {
    content: '';
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    opacity: 0.4;
    animation: float 25s ease-in-out infinite;
}

.animated-bg::before {
    width: 600px;
    height: 600px;
    background: radial-gradient(circle, rgba(99, 102, 241, 0.3) 0%, transparent 70%);
    top: -300px;
    right: -300px;
}

.animated-bg::after {
    width: 500px;
    height: 500px;
    background: radial-gradient(circle, rgba(139, 92, 246, 0.25) 0%, transparent 70%);
    bottom: -250px;
    left: -250px;
    animation-duration: 20s;
    animation-direction: reverse;
}

@keyframes float {
    0%, 100% { transform: translate(0, 0) scale(1) rotate(0deg); }
    33% { transform: translate(120px, -120px) scale(1.15) rotate(120deg); }
    66% { transform: translate(-80px, 120px) scale(0.9) rotate(240deg); }
}

/* ==================== SIDEBAR ==================== */
.sidebar {
    width: 260px;
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
    z-index: 1000;
    overflow-y: auto;
    box-shadow: 4px 0 24px rgba(0, 0, 0, 0.3);
    border-right: 1px solid rgba(99, 102, 241, 0.1);
    transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.sidebar-brand {
    padding: 1.75rem 1.5rem;
    font-weight: 700;
    font-size: 1.35rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    align-items: center;
    gap: 0.75rem;
    background: rgba(99, 102, 241, 0.15);
    color: #e2e8f0;
}

.sidebar-brand i {
    font-size: 1.5rem;
    animation: pulse 2s ease-in-out infinite;
    color: #6366f1;
}

@keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

.nav-section {
    padding: 1.25rem 0;
}

.nav-link {
    color: #94a3b8;
    padding: 0.85rem 1.5rem;
    font-weight: 500;
    display: flex;
    align-items: center;
    text-decoration: none;
    border-left: 3px solid transparent;
    transition: all 0.3s ease;
}

.nav-link:hover {
    color: #fff;
    background: rgba(99, 102, 241, 0.1);
    border-left-color: #6366f1;
    transform: translateX(4px);
}

.nav-link.active {
    color: #fff;
    background: rgba(99, 102, 241, 0.2);
    border-left-color: #6366f1;
    box-shadow: 0 0 20px rgba(99, 102, 241, 0.3);
}

.nav-link i {
    width: 24px;
    margin-right: 0.85rem;
    transition: transform 0.3s ease;
}

.nav-link:hover i {
    transform: scale(1.2) rotate(5deg);
}

/* ==================== MENU TOGGLE ==================== */
.menu-toggle {
    display: none;
    position: fixed;
    top: 1.25rem;
    left: 1.25rem;
    z-index: 1001;
    background: rgba(30, 41, 59, 0.95);
    backdrop-filter: blur(10px);
    border: 2px solid rgba(99, 102, 241, 0.4);
    color: #e2e8f0;
    padding: 0.875rem;
    border-radius: 12px;
    cursor: pointer;
    font-size: 1.25rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
}

.menu-toggle:hover {
    background: rgba(99, 102, 241, 0.2);
    border-color: #6366f1;
    transform: scale(1.05);
}

/* ==================== MAIN CONTENT ==================== */
.main-content {
    margin-left: 260px;
    padding: 2.5rem;
    min-height: 100vh;
    position: relative;
    z-index: 1;
    transition: margin-left 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

/* ==================== PAGE HEADER ==================== */
.page-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 20px; padding: 2.5rem; margin-bottom: 2rem; box-shadow: 0 8px 32px rgba(0,0,0,0.3); position: relative; overflow: hidden; animation: slideDown 0.6s; }
@keyframes slideDown { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
.page-header::before { content: ''; position: absolute; top: -50%; right: -10%; width: 300px; height: 300px; background: rgba(255,255,255,0.1); border-radius: 50%; animation: headerFloat 8s ease-in-out infinite; }

@keyframes headerFloat {
    0%, 100% {
        transform: translate(0, 0) rotate(0deg);
    }
    50% {
        transform: translate(-50px, 50px) rotate(180deg);
    }
}

.header-content {
    position: relative;
    z-index: 1;
}

.header-content h1 {
    font-size: 2rem;
    font-weight: 800;
    margin-bottom: 0.5rem;
    text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    letter-spacing: -0.5px;
    color: #fff;
}

.header-content p {
    opacity: 0.9;
    font-size: 1.05rem;
    font-weight: 500;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    color: #fff;
}

/* ==================== COURSE SWITCHER ==================== */
.course-switcher {
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 12px;
    padding: 0.55rem 1rem;
    color: white;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    margin-top: 1rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.course-switcher:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
}

/* ==================== COURSE SELECTOR ==================== */
.course-select-container {
    position: relative;
    margin-bottom: 2rem;
}

.course-list {
    background: rgba(30, 41, 59, 0.6);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    border: 2px solid rgba(99, 102, 241, 0.3);
    overflow: hidden;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

.course-list-item {
    padding: 1rem 1.25rem;
    border-bottom: 1px solid rgba(99, 102, 241, 0.1);
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.course-list-item:last-child {
    border-bottom: none;
}

.course-list-item:hover {
    background: rgba(99, 102, 241, 0.15);
    transform: translateX(8px);
}

.course-option-name {
    font-weight: 600;
    font-size: 1.125rem;
    margin-bottom: 0.25rem;
    color: #f1f5f9;
}

.course-option-meta {
    font-size: 0.85rem;
    color: #94a3b8;
}

.course-status-badge {
    padding: 0.25rem 0.75rem;
    border-radius: 6px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.status-DRAFT,
.status-draft {
    background: linear-gradient(135deg, rgba(245, 158, 11, 0.25), rgba(217, 119, 6, 0.25));
    color: #fbbf24;
    border: 1px solid rgba(245, 158, 11, 0.4);
}

.status-PUBLISHED,
.status-published {
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.25), rgba(5, 150, 105, 0.25));
    color: #10b981;
    border: 1px solid rgba(16, 185, 129, 0.4);
}

/* ==================== COURSE INFO BAR ==================== */
.course-info-bar {
   background: #1e293b;
    border-radius: 16px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(99, 102, 241, 0.2);
    display: flex;
    gap: 2rem;
    flex-wrap: wrap;
    animation: fadeIn 0.6s 0.2s both;
}
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.info-item {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.info-item i {
    color: #6366f1;
    font-size: 1.2rem;
}

.info-item-content h4 {
    font-size: 0.85rem;
    color: #94a3b8;
    margin-bottom: 0.25rem;
}

.info-item-content p {
    font-size: 1.1rem;
    font-weight: 700;
    color: #e2e8f0;
}

/* ==================== CURRICULUM PANEL ==================== */
.content-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 2rem;
    animation: fadeIn 0.6s 0.4s both;
}

.curriculum-panel {
    background:#1e293b;
    border-radius: 16px;
    padding: 2rem;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
    border: 1px solid rgba(99, 102, 241, 0.25);
}

/* ==================== PANEL HEADER ==================== */
.panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    flex-wrap: wrap;
    gap: 1rem;
}

.panel-title {
    font-size: 1.5rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.panel-title i {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* ==================== BUTTONS ==================== */
.btn {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    font-family: 'Inter', sans-serif;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.9rem;
    text-decoration: none;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.btn-primary {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    color: white;
}

.btn-primary:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 28px rgba(99, 102, 241, 0.5);
}

.btn-secondary {
    background: rgba(99, 102, 241, 0.15);
    color: #a5b4fc;
    border: 2px solid rgba(99, 102, 241, 0.4);
}

.btn-secondary:hover {
    background: rgba(99, 102, 241, 0.25);
    border-color: #6366f1;
    transform: translateY(-2px);
}

.btn-success {
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
}

.btn-success:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 28px rgba(16, 185, 129, 0.5);
}

.btn-sm {
    padding: 0.625rem 1.25rem;
    font-size: 0.875rem;
}

.btn-icon,
.icon-btn {
    background: transparent;
    border: none;
    color: #94a3b8;
    cursor: pointer;
    padding: 0.625rem;
    border-radius: 10px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    font-size: 1.125rem;
}

.btn-icon:hover,
.icon-btn:hover {
    background: rgba(99, 102, 241, 0.2);
    color: #6366f1;
    transform: scale(1.15);
}

/* ==================== SECTIONS ==================== */
.section-block,
.section-card {
    background: rgba(15,23,42,0.5);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(71, 85, 105, 0.5);
    border-radius: 12px;
    margin-bottom: 1.5rem;
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.section-block:hover,
.section-card:hover {
    border-color: rgba(99, 102, 241, 0.5);
    box-shadow: 0 8px 24px rgba(99, 102, 241, 0.15);
}

.section-header {
    padding: 1.25rem 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    background: rgba(15, 23, 42, 0.4);
}

.section-header:hover {
    background: rgba(30, 41, 59, 0.6);
}

.section-header.expanded {
    background: rgba(30, 41, 59, 0.8);
    border-bottom: 1px solid rgba(71, 85, 105, 0.5);
}

.section-info {
    display: flex;
    align-items: center;
    gap: 1rem;
    flex: 1;
}

.section-number {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 1.1rem;
}

.section-details {
    flex: 1;
}

.section-details h3 {
    font-size: 1.1rem;
    margin-bottom: 0.25rem;
}

.section-meta {
    font-size: 0.9rem;
    color: #94a3b8;
    font-weight: 500;
}

.section-actions {
    display: flex;
    gap: 0.5rem;
    align-items: center;
}

.expand-icon {
    transition: transform 0.3s ease;
}

.section-header.expanded .expand-icon {
    transform: rotate(180deg);
}

/* ==================== SECTION CONTENT ==================== */
.section-content,
.lessons-list {
    padding: 0;
    display: block; padding: 0;
    display: none;
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.section-header.expanded + .section-content,
.section-header.expanded + .lessons-list {
    display: block;
    max-height: 5000px;
    
}

.empty-content {
    padding: 2.5rem;
    text-align: center;
    color: #64748b;
}

/* ==================== CONTENT ITEMS ==================== */
.content-item,
.lesson-item {
    padding: 1rem 1.5rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    justify-content: space-between;
    border-bottom: 1px solid rgba(71, 85, 105, 0.3);
    transition: all 0.3s ease;
    background: transparent;
}

.content-item:last-child,
.lesson-item:last-child {
    border-bottom: none;
}

.content-item:hover,
.lesson-item:hover {
    background: rgba(30, 41, 59, 0.5);
}

.content-icon,
.lesson-icon {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.content-icon.video-icon,
.lesson-icon.video {
    background: linear-gradient(135deg, #8b5cf6, #7c3aed);
    color: white;
}

.content-icon.assignment-icon,
.lesson-icon.assignment {
    background: linear-gradient(135deg, #f59e0b, #d97706);
    color: white;
}

.content-icon.document-icon,
.lesson-icon.document {
    background: linear-gradient(135deg, #ef4444, #dc2626);
    color: white;
}

.content-info-wrapper,
.lesson-details {
    flex: 1;
    min-width: 0;
}

.content-title,
.lesson-details h4 {
    font-size: 0.95rem;
    margin-bottom: 0.35rem;
    font-weight: 600;
}

.content-badges,
lesson-meta {
    font-size: 0.8rem;
    color: #94a3b8;
    display: flex;
    gap: 1rem;
    align-items: center;
    flex-wrap: wrap;
}

.content-badge,
.lesson-badge {
    background: rgba(99, 102, 241, 0.2);
    color: #a5b4fc;
    padding: 0.2rem 0.6rem;
    border-radius: 6px;
    font-size: 0.75rem;
    font-weight: 600;
}

.duration-badge,
.size-badge {
    background: rgba(100, 116, 139, 0.3);
    color: #cbd5e1;
    border: 1px solid rgba(100, 116, 139, 0.4);
}

.type-badge {
    background: rgba(99, 102, 241, 0.2);
    color: #a5b4fc;
    border: 1px solid rgba(99, 102, 241, 0.3);
}

.content-actions,
.lesson-actions {
    display: flex;
    gap: 0.375rem;
    margin-left: auto;
}

.add-content-row {
    padding: 1rem 1.75rem;
    background: rgba(15, 23, 42, 0.2);
    border-top: 1px solid rgba(71, 85, 105, 0.3);
}

.btn-add-content {
    background: transparent !important;
    color: #94a3b8 !important;
    border: 1px dashed rgba(100, 116, 139, 0.5) !important;
    padding: 0.625rem 1.25rem !important;
    font-size: 0.875rem !important;
}

.btn-add-content:hover {
    background: rgba(99, 102, 241, 0.1) !important;
    border-color: rgba(99, 102, 241, 0.5) !important;
    color: #a5b4fc !important;
}

/* ==================== MODAL ==================== */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.7);
    z-index: 2000;
    align-items: center;
    justify-content: center;
    backdrop-filter: blur(4px);
}

.modal.active {
    display: flex;
}

.modal-content {
    background: #1e293b;
    border-radius: 20px;
    padding: 2rem;
    max-width: 700px;
    width: 90%;
    max-height: 90vh;
    overflow-y: auto;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
    border: 1px solid rgba(99, 102, 241, 0.3);
    animation: modalSlideIn 0.3s;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-60px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
}

.modal-title {
    font-size: 1.5rem;
    font-weight: 700;
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.close-modal {
    background: rgba(239, 68, 68, 0.1);
    border: 2px solid rgba(239, 68, 68, 0.3);
    color: #ef4444;
    cursor: pointer;
    font-size: 1.5rem;
    padding: 0.625rem;
    border-radius: 10px;
    transition: all 0.3s ease;
    line-height: 1;
}

.close-modal:hover {
    background: rgba(239, 68, 68, 0.2);
    transform: rotate(90deg) scale(1.1);
}

.modal-footer {
    display: flex;
    gap: 1rem;
    justify-content: flex-end;
    margin-top: 2.5rem;
    padding-top: 2rem;
    border-top: 2px solid rgba(99, 102, 241, 0.25);
}

/* ==================== TABS ==================== */
.content-type-tabs {
    display: flex;
    gap: 0.75rem;
    margin-bottom: 2rem;
    border-bottom: 2px solid rgba(99, 102, 241, 0.25);
    overflow-x: auto;
}

.tab-btn {
    background: transparent;
    border: none;
    color: #94a3b8;
    padding: 1rem 1.5rem;
    cursor: pointer;
    font-weight: 700;
    border-bottom: 3px solid transparent;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.625rem;
    font-family: 'Inter', sans-serif;
    font-size: 0.9375rem;
    white-space: nowrap;
}

.tab-btn:hover {
    color: #e2e8f0;
    background: rgba(99, 102, 241, 0.05);
}

.tab-btn.active {
    color: #6366f1;
    border-bottom-color: #6366f1;
    background: rgba(99, 102, 241, 0.1);
}

.tab-btn i {
    font-size: 1.25rem;
}

.tab-content {
    display: none;
}

.tab-content.active {
    display: block;
    animation: fadeIn 0.4s ease;
}

/* ==================== FORMS ==================== */
.form-group {
    margin-bottom: 1.75rem;
}

label {
    display: block;
    font-weight: 700;
    margin-bottom: 0.625rem;
    color: #f1f5f9;
    font-size: 0.9375rem;
}

label .optional {
    color: #94a3b8;
    font-weight: 400;
    font-size: 0.875rem;
}

label .required {
    color: #ef4444;
    font-weight: 700;
    font-size: 0.875rem;
}

input[type="text"],
input[type="number"],
input[type="url"],
input[type="email"],
select,
textarea {
    width: 100%;
    padding: 1rem 1.25rem;
    border: 2px solid rgba(99, 102, 241, 0.3);
    border-radius: 14px;
    background: rgba(15, 23, 42, 0.6);
    color: #e2e8f0;
    font-family: 'Inter', sans-serif;
    font-size: 1rem;
    transition: all 0.3s ease;
}

input:focus,
select:focus,
textarea:focus {
    outline: none;
    border-color: #6366f1;
    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.25);
    background: rgba(15, 23, 42, 0.8);
}

textarea {
    min-height: 100px;
    resize: vertical;
}

input[type="checkbox"] {
    width: 20px;
    height: 20px;
    cursor: pointer;
    accent-color: #6366f1;
}

/* ==================== FILE UPLOAD ==================== */
.file-upload-area {
    border: 3px dashed rgba(99, 102, 241, 0.4);
    border-radius: 16px;
    padding: 2.5rem;
    text-align: center;
    background: rgba(15, 23, 42, 0.4);
    cursor: pointer;
    transition: all 0.3s ease;
}

.file-upload-area:hover {
    border-color: #6366f1;
    background: rgba(99, 102, 241, 0.15);
    transform: translateY(-3px);
}

.file-upload-area.processing {
    border-color: #f59e0b;
    background: rgba(245, 158, 11, 0.1);
}

.file-upload-area i {
    font-size: 3.5rem;
    color: #6366f1;
    margin-bottom: 1.25rem;
    display: block;
}

.file-upload-area p {
    color: #cbd5e1;
    margin-bottom: 0.625rem;
    font-weight: 600;
    font-size: 1.0625rem;
}

.file-upload-area small {
    color: #64748b;
    font-size: 0.875rem;
}

.file-upload-area input[type="file"] {
    display: none;
}

.file-preview {
    margin-top: 1.25rem;
    padding: 1rem 1.25rem;
    background: rgba(99, 102, 241, 0.15);
    border-radius: 12px;
    display: none;
    align-items: center;
    gap: 1rem;
    border: 2px solid rgba(99, 102, 241, 0.3);
}

.file-preview.active {
    display: flex;
}

.file-preview i {
    color: #6366f1;
    font-size: 1.75rem;
}

.file-preview span {
    flex: 1;
    color: #f1f5f9;
    font-weight: 600;
}

.file-preview button {
    background: rgba(239, 68, 68, 0.1);
    border: 2px solid rgba(239, 68, 68, 0.3);
    color: #ef4444;
    cursor: pointer;
    padding: 0.625rem;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.file-preview button:hover {
    background: rgba(239, 68, 68, 0.2);
    transform: scale(1.1);
}

/* ==================== TOAST ==================== */
.toast {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    padding: 1.25rem 1.75rem;
    border-radius: 14px;
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.4);
    z-index: 9999;
    transform: translateX(400px);
    transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 1rem;
    border: 1px solid rgba(255, 255, 255, 0.2);
}

.toast.show {
    transform: translateX(0);
}

.toast.error {
    background: linear-gradient(135deg, #ef4444, #dc2626);
}

.toast.warning {
    background: linear-gradient(135deg, #f59e0b, #d97706);
}

.toast i {
    font-size: 1.5rem;
}

/* ==================== EMPTY STATE ==================== */
.empty-state {
    text-align: center;
    padding: 5rem 2rem;
    color: #94a3b8;
}

.empty-state i {
    font-size: 5rem;
    margin-bottom: 1.5rem;
    opacity: 0.4;
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.empty-state h3 {
    margin-bottom: 0.75rem;
    font-size: 1.5rem;
    font-weight: 700;
    color: #cbd5e1;
}

.empty-state p {
    margin-bottom: 2rem;
    font-size: 1.0625rem;
}

/* ==================== SCROLLBAR ==================== */
::-webkit-scrollbar {
    width: 10px;
    height: 10px;
}

::-webkit-scrollbar-track {
    background: rgba(15, 23, 42, 0.5);
    border-radius: 10px;
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(135deg, #8b5cf6, #a855f7);
}

/* ==================== RESPONSIVE ==================== */
@media (max-width: 1200px) {
    .course-info-bar {
        grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
        gap: 1.5rem;
    }
}

@media (max-width: 900px) {
    .menu-toggle {
        display: block;
    }

    .sidebar {
        margin-left: -260px;
    }

    .sidebar.active {
        margin-left: 0;
    }

    .main-content {
        margin-left: 0;
        padding: 1.5rem 1rem;
    }

    .page-header {
        padding: 2rem 1.5rem;
        border-radius: 16px;
    }

    .header-content h1 {
        font-size: 1.75rem;
    }

    .course-info-bar {
        grid-template-columns: 1fr;
        gap: 1rem;
        padding: 1.5rem;
    }

    .content-type-tabs {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    .panel-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .panel-title {
        font-size: 1.5rem;
    }

    .modal-content {
        padding: 1.5rem;
        margin: 1rem;
    }

    .section-header {
        padding: 1.25rem;
    }

    .section-info {
        gap: 1rem;
    }

    .content-item,
    .lesson-item {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }

    .content-actions,
    .lesson-actions {
        width: 100%;
        justify-content: flex-end;
    }
}

@media (max-width: 600px) {
    .page-header {
        padding: 1.5rem;
    }

    .header-content h1 {
        font-size: 1.5rem;
    }

    .header-content p {
        font-size: 0.9375rem;
    }

    .curriculum-panel {
        padding: 1.5rem;
    }

    .btn {
        padding: 0.75rem 1.25rem;
        font-size: 0.875rem;
    }

    .modal-content {
        padding: 1.25rem;
    }

    .modal-title {
        font-size: 1.375rem;
    }

    .toast {
        bottom: 1rem;
        right: 1rem;
        left: 1rem;
        padding: 1rem 1.25rem;
    }
</style>
</body>
</html>
