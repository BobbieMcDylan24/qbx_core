'use strict';

/* ── State ── */
let uiData      = null;   // full data from Lua
let deleteTarget = null;  // citizenid of character to delete
let createSlot   = null;  // slot number for new character

/* ── NUI Bridge ── */
function getNuiResourceName() {
    try { return window.GetParentResourceName ? window.GetParentResourceName() : 'qbx_core'; }
    catch (_) { return 'qbx_core'; }
}

function nuiCallback(name, data) {
    return fetch('https://' + getNuiResourceName() + '/' + name, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data || {})
    }).then(function(r) { return r.json(); }).catch(function() { return {}; });
}

/* ── NUI Message Handler ── */
window.addEventListener('message', function(event) {
    var d = event.data;
    if (!d || !d.action) return;

    switch (d.action) {
        case 'show':
            uiData = d;
            showUI(d);
            break;
        case 'refresh':
            if (uiData) {
                uiData.characters = d.characters;
                uiData.amount     = d.amount;
            }
            renderCards(uiData || d);
            break;
        case 'close':
            hideUI();
            break;
    }
});

/* ── UI Visibility ── */
function showUI(data) {
    var app = document.getElementById('app');
    app.classList.remove('hidden');
    renderCards(data);
    spawnParticles();
}

function hideUI() {
    document.getElementById('app').classList.add('hidden');
    closeCreateModal();
    closeDeleteModal();
}

/* ── Particles ── */
function spawnParticles() {
    var container = document.getElementById('particles');
    container.innerHTML = '';
    var count = 22;
    for (var i = 0; i < count; i++) {
        (function() {
            var p = document.createElement('div');
            p.className = 'particle';
            var size = (Math.random() * 2 + 1).toFixed(1) + 'px';
            p.style.cssText = [
                'left:'      + (Math.random() * 100).toFixed(1) + '%',
                'width:'     + size,
                'height:'    + size,
                'opacity:'   + (Math.random() * 0.5 + 0.2).toFixed(2),
                'animation-duration:'  + (Math.random() * 14 + 10).toFixed(1) + 's',
                'animation-delay:'    + (Math.random() * 12).toFixed(1) + 's'
            ].join(';');
            container.appendChild(p);
        })();
    }
}

/* ── Format helpers ── */
function fmtMoney(v) {
    if (v === undefined || v === null) return '$0';
    return '$' + Math.floor(Number(v)).toLocaleString();
}

function esc(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#x27;');
}

/* ── Render Cards ── */
function renderCards(data) {
    var grid = document.getElementById('chars-grid');
    grid.innerHTML = '';

    for (var i = 0; i < data.amount; i++) {
        var char = data.characters ? data.characters[i] : null;
        var card = char && !char.empty
            ? buildCharCard(char, data.enableDelete)
            : buildEmptyCard(i + 1);
        grid.appendChild(card);
    }

    // Auto-select first filled card visually
    var first = grid.querySelector('.char-card:not(.empty)');
    if (first) first.classList.add('selected');
}

function buildCharCard(char, enableDelete) {
    var card = document.createElement('div');
    card.className = 'char-card';
    card.dataset.cid = char.citizenid;

    var genderSym   = char.gender === 0 ? '♂' : '♀';
    var genderColor = char.gender === 0 ? '#6aaaff' : '#ff92c2';

    var deleteBtn = enableDelete
        ? '<button class="btn danger-sm" title="Delete character">🗑</button>'
        : '';

    card.innerHTML = [
        '<div class="card-banner">',
            '<div class="avatar-glow"></div>',
            '<div class="avatar-char" style="color:' + genderColor + ';">' + genderSym + '</div>',
        '</div>',
        '<div class="card-content">',
            '<div class="char-name">' + esc(char.firstname) + ' ' + esc(char.lastname) + '</div>',
            '<div class="char-id">' + esc(char.citizenid) + '</div>',
            '<div class="card-sep"></div>',
            '<div class="stat-row">',
                '<span class="stat-ico">💼</span>',
                '<span class="stat-lbl">Job</span>',
                '<span class="stat-val">' + esc(char.job) + '</span>',
            '</div>',
            '<div class="stat-row">',
                '<span class="stat-ico">🏦</span>',
                '<span class="stat-lbl">Bank</span>',
                '<span class="stat-val money">' + fmtMoney(char.bank) + '</span>',
            '</div>',
            '<div class="stat-row">',
                '<span class="stat-ico">📅</span>',
                '<span class="stat-lbl">DOB</span>',
                '<span class="stat-val">' + esc(char.birthdate || 'Unknown') + '</span>',
            '</div>',
        '</div>',
        '<div class="card-foot">',
            '<button class="btn primary">▶ Play</button>',
            deleteBtn,
        '</div>'
    ].join('');

    /* Play */
    card.querySelector('.btn.primary').addEventListener('click', function(e) {
        e.stopPropagation();
        playCharacter(char.citizenid);
    });

    /* Delete */
    var delBtn = card.querySelector('.btn.danger-sm');
    if (delBtn) {
        delBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            openDeleteModal(char.citizenid, char.firstname + ' ' + char.lastname);
        });
    }

    /* Preview on card click */
    card.addEventListener('click', function() {
        document.querySelectorAll('.char-card').forEach(function(c) {
            c.classList.remove('selected');
        });
        card.classList.add('selected');
        nuiCallback('multichar_preview', { citizenid: char.citizenid });
    });

    return card;
}

function buildEmptyCard(slot) {
    var card = document.createElement('div');
    card.className = 'char-card empty';

    card.innerHTML = [
        '<div class="empty-body">',
            '<div class="empty-plus">+</div>',
            '<div class="empty-label">Empty Slot</div>',
            '<div class="empty-slot">Character ' + slot + '</div>',
        '</div>',
        '<div class="card-foot">',
            '<button class="btn create">Create Character</button>',
        '</div>'
    ].join('');

    card.querySelector('.btn.create').addEventListener('click', function(e) {
        e.stopPropagation();
        openCreateModal(slot);
    });
    card.addEventListener('click', function() { openCreateModal(slot); });

    return card;
}

/* ── Play ── */
function playCharacter(citizenid) {
    nuiCallback('multichar_play', { citizenid: citizenid });
}

/* ── Delete Modal ── */
function openDeleteModal(citizenid, name) {
    deleteTarget = citizenid;
    document.getElementById('del-name').textContent = name;
    document.getElementById('modal-delete').classList.remove('hidden');
}

function closeDeleteModal() {
    document.getElementById('modal-delete').classList.add('hidden');
    deleteTarget = null;
}

function confirmDelete() {
    if (!deleteTarget) return;
    var btn = document.getElementById('btn-del-confirm');
    if (btn) btn.disabled = true;

    nuiCallback('multichar_delete', { citizenid: deleteTarget }).then(function(res) {
        closeDeleteModal();
        if (btn) btn.disabled = false;
    });
}

/* ── Create Modal ── */
function openCreateModal(slot) {
    createSlot = slot;

    /* Reset fields */
    document.getElementById('inp-fn').value  = '';
    document.getElementById('inp-ln').value  = '';

    var dobEl = document.getElementById('inp-dob');
    if (uiData) {
        dobEl.min   = uiData.dateMin  || '1900-01-01';
        dobEl.max   = uiData.dateMax  || '2006-12-31';
        dobEl.value = uiData.dateMax  || '2006-12-31';
    }

    /* Gender reset */
    document.querySelectorAll('.gender-btn').forEach(function(b) {
        b.classList.remove('active');
    });
    var maleBtn = document.querySelector('.gender-btn[data-val="0"]');
    if (maleBtn) maleBtn.classList.add('active');

    /* Nationality */
    buildNationalityField();

    /* Clear error */
    var err = document.getElementById('create-err');
    err.textContent = '';
    err.classList.add('hidden');

    /* Reset create button */
    var btn = document.getElementById('btn-create-confirm');
    if (btn) { btn.disabled = false; btn.textContent = 'Create Character'; }

    document.getElementById('modal-create').classList.remove('hidden');
}

function closeCreateModal() {
    document.getElementById('modal-create').classList.add('hidden');
    createSlot = null;
}

function buildNationalityField() {
    var field = document.getElementById('nationality-field');
    /* Keep the label */
    field.innerHTML = '<label>Nationality</label>';

    if (uiData && uiData.limitNationalities && uiData.nationalities && uiData.nationalities.length) {
        var sel = document.createElement('select');
        sel.id = 'inp-nat';
        uiData.nationalities.forEach(function(nat) {
            var opt = document.createElement('option');
            opt.value = nat;
            opt.textContent = nat;
            if (nat === 'American') opt.selected = true;
            sel.appendChild(opt);
        });
        field.appendChild(sel);
    } else {
        var inp = document.createElement('input');
        inp.type = 'text';
        inp.id   = 'inp-nat';
        inp.placeholder = 'Enter nationality';
        inp.maxLength   = 50;
        inp.autocomplete = 'off';
        field.appendChild(inp);
    }
}

/* Called from HTML onclick */
function selectGender(btn) {
    document.querySelectorAll('.gender-btn').forEach(function(b) {
        b.classList.remove('active');
    });
    btn.classList.add('active');
}

function showCreateError(msg) {
    var err = document.getElementById('create-err');
    err.textContent = msg;
    err.classList.remove('hidden');
}

function submitCreate() {
    var fn  = (document.getElementById('inp-fn').value  || '').trim();
    var ln  = (document.getElementById('inp-ln').value  || '').trim();
    var nat = (document.getElementById('inp-nat') ? document.getElementById('inp-nat').value : '') || '';
    nat = nat.trim ? nat.trim() : nat;
    var dob = document.getElementById('inp-dob').value  || '';
    var genderEl = document.querySelector('.gender-btn.active');
    var gender   = genderEl ? parseInt(genderEl.dataset.val, 10) : 0;

    if (!fn || !ln || !nat || !dob) {
        showCreateError('Please fill in all required fields.');
        return;
    }

    document.getElementById('create-err').classList.add('hidden');

    var btn = document.getElementById('btn-create-confirm');
    if (btn) { btn.disabled = true; btn.textContent = 'Creating…'; }

    nuiCallback('multichar_create', {
        firstname:   fn,
        lastname:    ln,
        nationality: nat,
        gender:      gender,
        birthdate:   dob,
        slot:        createSlot
    }).then(function(res) {
        if (res && res.error) {
            showCreateError(res.error);
            if (btn) { btn.disabled = false; btn.textContent = 'Create Character'; }
        } else {
            closeCreateModal();
        }
    });
}
