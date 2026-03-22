-- ══════════════════════════════════════════════════════════════════
-- HireFlow — PostgreSQL Schema
-- Run this once against your Render PostgreSQL database
-- ══════════════════════════════════════════════════════════════════

-- ── 1. Users ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    user_id       SERIAL PRIMARY KEY,
    full_name     VARCHAR(100)  NOT NULL,
    email         VARCHAR(150)  UNIQUE NOT NULL,
    password_hash VARCHAR(255)  NOT NULL,
    role          VARCHAR(20)   NOT NULL CHECK (role IN ('seeker', 'employer', 'admin')),
    phone         VARCHAR(20),
    is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP     NOT NULL DEFAULT NOW()
);

-- ── 2. Categories ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    icon        VARCHAR(50)
);

-- ── 3. Jobs ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS jobs (
    job_id        SERIAL PRIMARY KEY,
    employer_id   INT           NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category_id   INT           REFERENCES categories(category_id) ON DELETE SET NULL,
    title         VARCHAR(200)  NOT NULL,
    description   TEXT,
    location      VARCHAR(150),
    job_type      VARCHAR(50)   DEFAULT 'Full-time',
    salary_min    NUMERIC(10,2),
    salary_max    NUMERIC(10,2),
    skills        TEXT[],
    status        VARCHAR(20)   NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'active', 'closed', 'expired')),
    is_featured   BOOLEAN       NOT NULL DEFAULT FALSE,
    posted_at     TIMESTAMP     NOT NULL DEFAULT NOW(),
    expires_at    TIMESTAMP
);

-- ── 4. Applications ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS applications (
    application_id SERIAL PRIMARY KEY,
    job_id         INT          NOT NULL REFERENCES jobs(job_id) ON DELETE CASCADE,
    seeker_id      INT          NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    resume_url     VARCHAR(500),
    cover_letter   TEXT,
    status         VARCHAR(20)  NOT NULL DEFAULT 'applied'
                       CHECK (status IN ('applied', 'reviewed', 'hired', 'rejected')),
    applied_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    UNIQUE (job_id, seeker_id)
);

-- ── 5. Indexes ────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_jobs_employer ON jobs(employer_id);
CREATE INDEX IF NOT EXISTS idx_jobs_status   ON jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_category ON jobs(category_id);
CREATE INDEX IF NOT EXISTS idx_apps_job      ON applications(job_id);
CREATE INDEX IF NOT EXISTS idx_apps_seeker   ON applications(seeker_id);
CREATE INDEX IF NOT EXISTS idx_users_email   ON users(email);

-- ── 6. Seed Categories ────────────────────────────────────────────
INSERT INTO categories (name, icon) VALUES
    ('Technology',       '💻'),
    ('Design',           '🎨'),
    ('Marketing',        '📣'),
    ('Finance',          '💰'),
    ('Healthcare',       '🏥'),
    ('Education',        '📚'),
    ('Sales',            '🤝'),
    ('Human Resources',  '👥'),
    ('Engineering',      '⚙️'),
    ('Customer Support', '🎧')
ON CONFLICT DO NOTHING;

-- ── 7. Seed Admin User ────────────────────────────────────────────
-- Default password: admin123
-- IMPORTANT: Change this immediately after first login
INSERT INTO users (full_name, email, password_hash, role) VALUES (
    'Admin',
    'admin@hireflow.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/HS.iXWC',
    'admin'
) ON CONFLICT (email) DO NOTHING;
