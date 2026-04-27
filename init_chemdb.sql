-- 1. countries
CREATE TABLE countries (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL CHECK (code ~ '^[A-Z]{3}$'),
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 2. departments
CREATE TABLE departments (
    id UUID PRIMARY KEY,
    ubigeo_code CHAR(2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 3. provinces
CREATE TABLE provinces (
    id UUID PRIMARY KEY,
    department_id UUID NOT NULL,
    ubigeo_code CHAR(4) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_prov_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT
);

-- 4. districts
CREATE TABLE districts (
    id UUID PRIMARY KEY,
    province_id UUID NOT NULL,
    ubigeo_code CHAR(6) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_dist_province FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE RESTRICT
);

-- 5. icons
CREATE TABLE icons (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(20) NOT NULL,
    type_img VARCHAR(50) NOT NULL,
    path VARCHAR(500) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 6. resource_types
CREATE TABLE resource_types (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(250),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 7. course_modalities
CREATE TABLE course_modalities (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 8. course_conditions
CREATE TABLE course_conditions (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 9. course_visibility
CREATE TABLE course_visibility (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 10. course_roles
CREATE TABLE course_roles (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 11. module_view_types
CREATE TABLE module_view_types (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 12. academic_entity_types
CREATE TABLE academic_entity_types (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(22) NOT NULL,
    description VARCHAR(230),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 13. academic_categories
CREATE TABLE academic_categories (
    id UUID PRIMARY KEY,
    code CHAR(3) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(300),
    level SMALLINT,
    parent_id UUID,
    color CHAR(6),
    icon_id UUID,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_cat_parent FOREIGN KEY (parent_id) REFERENCES academic_categories(id) ON DELETE RESTRICT,
    CONSTRAINT fk_cat_icon FOREIGN KEY (icon_id) REFERENCES icons(id) ON DELETE SET NULL
);

-- 14. academic_tags
CREATE TABLE academic_tags (
    id UUID PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    icon_id UUID,
    color CHAR(6),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_tag_icon FOREIGN KEY (icon_id) REFERENCES icons(id) ON DELETE SET NULL
);

-- 15. companies
CREATE TABLE companies (
    id UUID PRIMARY KEY,
    tax_id BIGINT NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

-- 16. people
CREATE TABLE people (
    id UUID PRIMARY KEY,
    document_type CHAR(3),
    client_code VARCHAR(20),
    document_number CHAR(8),
    full_name VARCHAR(200) NOT NULL,
    last_name VARCHAR(40),
    second_last_name VARCHAR(40),
    first_name VARCHAR(40),
    middle_name VARCHAR(40),
    other_name VARCHAR(40),
    verification_status SMALLINT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    country_id UUID,
    district_id UUID,
    gender SMALLINT,
    birth_date DATE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_people_country FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT,
    CONSTRAINT fk_people_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT
);

-- 17. users
CREATE TABLE users (
    id UUID PRIMARY KEY,
    person_id UUID NOT NULL,
    username VARCHAR(10) NOT NULL UNIQUE,
    display_name VARCHAR(200) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_blocked BOOLEAN NOT NULL DEFAULT FALSE,
    password_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_user_person FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE RESTRICT,
    CONSTRAINT fk_user_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_user_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Add FK from people to users (circular resolved)
ALTER TABLE people ADD CONSTRAINT fk_people_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL;
ALTER TABLE people ADD CONSTRAINT fk_people_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL;

-- 18. academic_entities
CREATE TABLE academic_entities (
    id UUID PRIMARY KEY ,
    entity_type_id UUID NOT NULL,
    name VARCHAR(200) NOT NULL,
    tutor_name VARCHAR(50),
    tutor_last_name VARCHAR(50),
    tutor_second_last_name VARCHAR(50),
    company_id UUID,
    user_id UUID,
    history_code VARCHAR(6),
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_acad_entity_type FOREIGN KEY (entity_type_id) REFERENCES academic_entity_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_acad_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL,
    CONSTRAINT fk_acad_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_acad_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_acad_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 19. courses
CREATE TABLE courses (
    id UUID PRIMARY KEY,
    academic_entity_id UUID,
    category_id UUID,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(1000),
    modality_id UUID NOT NULL,
    condition_id UUID NOT NULL,
    visibility_id UUID NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    color CHAR(6),
    icon_id UUID,
    district_id UUID,
    address VARCHAR(300),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    start_date DATE,
    end_date DATE,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_course_acad_entity FOREIGN KEY (academic_entity_id) REFERENCES academic_entities(id) ON DELETE SET NULL,
    CONSTRAINT fk_course_category FOREIGN KEY (category_id) REFERENCES academic_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_course_modality FOREIGN KEY (modality_id) REFERENCES course_modalities(id) ON DELETE RESTRICT,
    CONSTRAINT fk_course_condition FOREIGN KEY (condition_id) REFERENCES course_conditions(id) ON DELETE RESTRICT,
    CONSTRAINT fk_course_visibility FOREIGN KEY (visibility_id) REFERENCES course_visibility(id) ON DELETE RESTRICT,
    CONSTRAINT fk_course_icon FOREIGN KEY (icon_id) REFERENCES icons(id) ON DELETE SET NULL,
    CONSTRAINT fk_course_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE SET NULL,
    CONSTRAINT fk_course_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_course_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 20. course_tags
CREATE TABLE course_tags (
    course_id UUID NOT NULL,
    tag_id UUID NOT NULL,
    PRIMARY KEY (course_id, tag_id),
    CONSTRAINT fk_coursetag_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_coursetag_tag FOREIGN KEY (tag_id) REFERENCES academic_tags(id) ON DELETE CASCADE
);

-- 21. course_modules
CREATE TABLE course_modules (
    id UUID PRIMARY KEY,
    course_id UUID NOT NULL,
    sequence SMALLINT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(1000),
    icon_id UUID,
    color CHAR(6),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_visible BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_module_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_module_icon FOREIGN KEY (icon_id) REFERENCES icons(id) ON DELETE SET NULL,
    CONSTRAINT fk_module_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_module_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 22. module_elements
CREATE TABLE module_elements (
    id UUID PRIMARY KEY,
    module_id UUID NOT NULL,
    sequence SMALLINT NOT NULL,
    code VARCHAR(20),
    name VARCHAR(150) NOT NULL,
    description VARCHAR(1000),
    icon_id UUID,
    color CHAR(6),
    pos_x SMALLINT,
    pos_y SMALLINT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_visible BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_element_module FOREIGN KEY (module_id) REFERENCES course_modules(id) ON DELETE CASCADE,
    CONSTRAINT fk_element_icon FOREIGN KEY (icon_id) REFERENCES icons(id) ON DELETE SET NULL,
    CONSTRAINT fk_element_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_element_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 23. resources
CREATE TABLE resources (
    id UUID PRIMARY KEY,
    resource_type_id UUID NOT NULL,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(1000),
    path VARCHAR(1000),
    url VARCHAR(1000),
    mime_type VARCHAR(100),
    size BIGINT,
    extension VARCHAR(10),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_resource_type FOREIGN KEY (resource_type_id) REFERENCES resource_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_resource_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_resource_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 24. resource_assignments
CREATE TABLE resource_assignments (
    id UUID PRIMARY KEY,
    resource_id UUID NOT NULL,
    course_id UUID,
    module_id UUID,
    element_id UUID,
    sequence SMALLINT NOT NULL DEFAULT 1,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_assign_resource FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    CONSTRAINT fk_assign_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_assign_module FOREIGN KEY (module_id) REFERENCES course_modules(id) ON DELETE CASCADE,
    CONSTRAINT fk_assign_element FOREIGN KEY (element_id) REFERENCES module_elements(id) ON DELETE CASCADE,
    CONSTRAINT fk_assign_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_assign_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_assign_target CHECK (
        (course_id IS NOT NULL AND module_id IS NULL AND element_id IS NULL) OR
        (module_id IS NOT NULL AND course_id IS NULL AND element_id IS NULL) OR
        (element_id IS NOT NULL AND course_id IS NULL AND module_id IS NULL)
    )
);

-- 25. ar_vr_scenes
CREATE TABLE ar_vr_scenes (
    id UUID PRIMARY KEY,
    resource_id UUID NOT NULL,
    name VARCHAR(200),
    description VARCHAR(1000),
    engine VARCHAR(50),
    format VARCHAR(20),
    has_marker BOOLEAN NOT NULL DEFAULT FALSE,
    marker_path VARCHAR(1000),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    updated_at TIMESTAMPTZ,
    CONSTRAINT fk_scene_resource FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    CONSTRAINT fk_scene_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_scene_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 26. course_members
CREATE TABLE course_members (
    course_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (course_id, user_id),
    CONSTRAINT fk_member_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_member_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_member_role FOREIGN KEY (role_id) REFERENCES course_roles(id) ON DELETE RESTRICT,
    CONSTRAINT fk_member_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- ============================================================
-- PERFORMANCE INDEXES (UUID columns need indexes for FKs)
-- ============================================================
CREATE INDEX idx_prov_department_id ON provinces(department_id);
CREATE INDEX idx_dist_province_id ON districts(province_id);
CREATE INDEX idx_categories_parent_id ON academic_categories(parent_id);
CREATE INDEX idx_categories_icon_id ON academic_categories(icon_id);
CREATE INDEX idx_tags_icon_id ON academic_tags(icon_id);
CREATE INDEX idx_people_country_id ON people(country_id);
CREATE INDEX idx_people_district_id ON people(district_id);
CREATE INDEX idx_people_created_by ON people(created_by);
CREATE INDEX idx_people_updated_by ON people(updated_by);
CREATE INDEX idx_users_person_id ON users(person_id);
CREATE INDEX idx_users_created_by ON users(created_by);
CREATE INDEX idx_users_updated_by ON users(updated_by);
CREATE INDEX idx_acad_entities_type_id ON academic_entities(entity_type_id);
CREATE INDEX idx_acad_entities_company_id ON academic_entities(company_id);
CREATE INDEX idx_acad_entities_user_id ON academic_entities(user_id);
CREATE INDEX idx_acad_entities_created_by ON academic_entities(created_by);
CREATE INDEX idx_acad_entities_updated_by ON academic_entities(updated_by);
CREATE INDEX idx_courses_acad_entity_id ON courses(academic_entity_id);
CREATE INDEX idx_courses_category_id ON courses(category_id);
CREATE INDEX idx_courses_modality_id ON courses(modality_id);
CREATE INDEX idx_courses_condition_id ON courses(condition_id);
CREATE INDEX idx_courses_visibility_id ON courses(visibility_id);
CREATE INDEX idx_courses_icon_id ON courses(icon_id);
CREATE INDEX idx_courses_district_id ON courses(district_id);
CREATE INDEX idx_courses_created_by ON courses(created_by);
CREATE INDEX idx_courses_updated_by ON courses(updated_by);
CREATE INDEX idx_course_tags_tag_id ON course_tags(tag_id);
CREATE INDEX idx_modules_course_id ON course_modules(course_id);
CREATE INDEX idx_modules_icon_id ON course_modules(icon_id);
CREATE INDEX idx_modules_created_by ON course_modules(created_by);
CREATE INDEX idx_modules_updated_by ON course_modules(updated_by);
CREATE INDEX idx_elements_module_id ON module_elements(module_id);
CREATE INDEX idx_elements_icon_id ON module_elements(icon_id);
CREATE INDEX idx_elements_created_by ON module_elements(created_by);
CREATE INDEX idx_elements_updated_by ON module_elements(updated_by);
CREATE INDEX idx_resources_type_id ON resources(resource_type_id);
CREATE INDEX idx_resources_created_by ON resources(created_by);
CREATE INDEX idx_resources_updated_by ON resources(updated_by);
CREATE INDEX idx_assignments_resource_id ON resource_assignments(resource_id);
CREATE INDEX idx_assignments_course_id ON resource_assignments(course_id);
CREATE INDEX idx_assignments_module_id ON resource_assignments(module_id);
CREATE INDEX idx_assignments_element_id ON resource_assignments(element_id);
CREATE INDEX idx_scenes_resource_id ON ar_vr_scenes(resource_id);
CREATE INDEX idx_scenes_created_by ON ar_vr_scenes(created_by);
CREATE INDEX idx_scenes_updated_by ON ar_vr_scenes(updated_by);
CREATE INDEX idx_members_user_id ON course_members(user_id);
CREATE INDEX idx_members_role_id ON course_members(role_id);
CREATE INDEX idx_members_created_by ON course_members(created_by);

-- ============================================================
-- OPTIONAL: Comments for documentation
-- ============================================================
COMMENT ON TABLE countries IS 'List of countries';
COMMENT ON TABLE departments IS 'Peruvian departments (first-level行政区划)';
COMMENT ON TABLE provinces IS 'Peruvian provinces (second-level)';
COMMENT ON TABLE districts IS 'Peruvian districts (third-level)';
COMMENT ON TABLE icons IS 'Icons for UI elements';
COMMENT ON TABLE resource_types IS 'Types of academic resources (video, pdf, etc.)';
COMMENT ON TABLE course_modalities IS 'Course delivery mode (online, in-person, hybrid)';
COMMENT ON TABLE course_conditions IS 'Course status (draft, published, archived)';
COMMENT ON TABLE course_visibility IS 'Who can see the course';
COMMENT ON TABLE course_roles IS 'User roles within a course (student, teacher, admin)';
COMMENT ON TABLE module_view_types IS 'Visualization layout for modules';
COMMENT ON TABLE academic_entity_types IS 'Type of academic entity (university, institute, school)';
COMMENT ON TABLE academic_categories IS 'Hierarchical course categories';
COMMENT ON TABLE academic_tags IS 'Tags for course classification';
COMMENT ON TABLE companies IS 'Institutional partners or sponsors';
COMMENT ON TABLE people IS 'Person master data (students, teachers, etc.)';
COMMENT ON TABLE users IS 'System users (linked to a person)';
COMMENT ON TABLE academic_entities IS 'Institutions offering courses';
COMMENT ON TABLE courses IS 'Course master data';
COMMENT ON TABLE course_tags IS 'Many-to-many between courses and tags';
COMMENT ON TABLE course_modules IS 'Modules inside a course';
COMMENT ON TABLE module_elements IS 'Learning elements (lessons, quizzes, etc.) inside a module';
COMMENT ON TABLE resources IS 'Reusable academic resources (files, links, videos)';
COMMENT ON TABLE resource_assignments IS 'Polymorphic assignment of resources to courses/modules/elements';
COMMENT ON TABLE ar_vr_scenes IS 'AR/VR scene metadata linked to a resource';
COMMENT ON TABLE course_members IS 'Members enrolled in a course with their roles';