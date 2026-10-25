CREATE SCHEMA IF NOT EXISTS app;

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA app;

CREATE TABLE "app"."core_countries" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "iso3" CHAR(3) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_countries_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_regions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "country_id" UUID NOT NULL,
    "code" VARCHAR(12) NOT NULL,
    "name" VARCHAR(130) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_regions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_provinces" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "region_id" UUID NOT NULL,
    "code" VARCHAR(12) NOT NULL,
    "name" VARCHAR(130) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_provinces_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_districts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "province_id" UUID NOT NULL,
    "code" VARCHAR(12) NOT NULL,
    "name" VARCHAR(130) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_districts_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_people" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "given_names" VARCHAR(160) NOT NULL,
    "family_names" VARCHAR(160),
    "document_type" VARCHAR(20),
    "document_number" VARCHAR(40),
    "birth_date" DATE,
    "phone" VARCHAR(30),
    "district_id" UUID,
    "status" VARCHAR(20) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_people_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_profiles" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "username" VARCHAR(60) NOT NULL,
    "display_name" VARCHAR(160) NOT NULL,
    "bio" TEXT,
    "avatar_url" TEXT,
    "headline" VARCHAR(180),
    "study_area" VARCHAR(150),
    "interests" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "skills" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "is_public" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_profiles_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_user_preferences" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "theme" VARCHAR(20) NOT NULL DEFAULT 'system',
    "locale" VARCHAR(15) NOT NULL DEFAULT 'es-PE',
    "timezone" VARCHAR(80) NOT NULL DEFAULT 'America/Lima',
    "settings" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_user_preferences_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organizations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "slug" VARCHAR(100) NOT NULL,
    "legal_name" VARCHAR(240) NOT NULL,
    "display_name" VARCHAR(180) NOT NULL,
    "organization_type" VARCHAR(30) NOT NULL,
    "tax_identifier" VARCHAR(30),
    "logo_url" TEXT,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "owner_person_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organizations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organization_sites" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "code" VARCHAR(30) NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "district_id" UUID,
    "address" TEXT,
    "latitude" NUMERIC(10,7),
    "longitude" NUMERIC(10,7),
    "is_virtual" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organization_sites_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organization_memberships" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "member_code" VARCHAR(50),
    "status" VARCHAR(20) NOT NULL DEFAULT 'active',
    "joined_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ended_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organization_memberships_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organization_roles" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "code" VARCHAR(40) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "permissions" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organization_roles_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_membership_roles" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "membership_id" UUID NOT NULL,
    "role_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_membership_roles_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organization_settings" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "settings" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "branding" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "timezone" VARCHAR(80) NOT NULL DEFAULT 'America/Lima',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organization_settings_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organization_invitations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "invite_token_hash" VARCHAR(255) NOT NULL,
    "invited_by" UUID,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "accepted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organization_invitations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_institution_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "applicant_id" UUID NOT NULL,
    "requested_name" VARCHAR(240) NOT NULL,
    "registration_info" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "status" VARCHAR(25) NOT NULL DEFAULT 'submitted',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_institution_requests_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_legal_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "document_type" VARCHAR(35) NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "version" VARCHAR(30) NOT NULL,
    "resource_url" TEXT NOT NULL,
    "published_at" TIMESTAMPTZ,
    "effective_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_legal_documents_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_legal_acceptances" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "document_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "accepted_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "evidence" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_legal_acceptances_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_organization_announcements" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "body" TEXT NOT NULL,
    "audience" VARCHAR(30) NOT NULL DEFAULT 'all',
    "publish_at" TIMESTAMPTZ,
    "expires_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_organization_announcements_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."core_audit_logs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "actor_id" UUID,
    "event_type" VARCHAR(90) NOT NULL,
    "object_type" VARCHAR(100) NOT NULL,
    "object_id" UUID,
    "occurred_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ip_hash" VARCHAR(128),
    "details" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_core_audit_logs_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_categories" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "parent_id" UUID,
    "code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "icon_key" VARCHAR(80),
    "color_hex" CHAR(6),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_categories_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_tags" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "slug" VARCHAR(80) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_tags_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_skills" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" VARCHAR(160) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_skills_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_media_assets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "owner_id" UUID,
    "organization_id" UUID,
    "storage_key" TEXT NOT NULL,
    "mime_type" VARCHAR(120) NOT NULL,
    "byte_size" BIGINT NOT NULL,
    "checksum_sha256" CHAR(64),
    "duration_seconds" INTEGER,
    "visibility" VARCHAR(25) NOT NULL DEFAULT 'private',
    "scan_status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "alt_text" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_media_assets_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_courses" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "owner_person_id" UUID,
    "category_id" UUID,
    "slug" VARCHAR(120) NOT NULL,
    "title" VARCHAR(240) NOT NULL,
    "summary" TEXT,
    "description" TEXT,
    "thumbnail_id" UUID,
    "language_code" VARCHAR(15) NOT NULL DEFAULT 'es',
    "course_kind" VARCHAR(25) NOT NULL DEFAULT 'open',
    "delivery_mode" VARCHAR(25) NOT NULL DEFAULT 'asynchronous',
    "visibility" VARCHAR(25) NOT NULL DEFAULT 'public',
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "requires_enrollment" BOOLEAN NOT NULL DEFAULT true,
    "published_at" TIMESTAMPTZ,
    "estimated_minutes" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_courses_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_course_tags" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "tag_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_course_tags_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_course_skills" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "skill_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_course_skills_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_course_instructors" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(25) NOT NULL DEFAULT 'instructor',
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_course_instructors_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_course_prerequisites" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "required_course_id" UUID NOT NULL,
    "is_mandatory" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_course_prerequisites_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_course_versions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "version_no" INTEGER NOT NULL,
    "release_notes" TEXT,
    "published_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_course_versions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_modules" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(20) NOT NULL DEFAULT 'published',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_modules_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_lessons" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "module_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "estimated_minutes" INTEGER,
    "is_preview" BOOLEAN NOT NULL DEFAULT false,
    "status" VARCHAR(20) NOT NULL DEFAULT 'published',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_lessons_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_resources" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "owner_id" UUID,
    "organization_id" UUID,
    "asset_id" UUID,
    "title" VARCHAR(240) NOT NULL,
    "resource_type" VARCHAR(35) NOT NULL,
    "description" TEXT,
    "external_url" TEXT,
    "duration_seconds" INTEGER,
    "license_type" VARCHAR(60),
    "is_downloadable" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_resources_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_lesson_resources" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "lesson_id" UUID NOT NULL,
    "resource_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "is_required" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_lesson_resources_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_learning_paths" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "owner_id" UUID,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "visibility" VARCHAR(25) NOT NULL DEFAULT 'public',
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_learning_paths_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_learning_path_courses" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "path_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "is_required" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_learning_path_courses_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_external_libraries" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "name" VARCHAR(160) NOT NULL,
    "description" TEXT,
    "homepage_url" TEXT NOT NULL,
    "logo_asset_id" UUID,
    "access_type" VARCHAR(30) NOT NULL DEFAULT 'public',
    "requires_institution" BOOLEAN NOT NULL DEFAULT false,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_external_libraries_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_external_library_links" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "library_id" UUID NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "url" TEXT NOT NULL,
    "thumbnail_id" UUID,
    "description" TEXT,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_external_library_links_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_bookmarks" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "course_id" UUID,
    "resource_id" UUID,
    "external_link_id" UUID,
    "note" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_bookmarks_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_collections" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "title" VARCHAR(160) NOT NULL,
    "description" TEXT,
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_collections_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."catalog_collection_items" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "collection_id" UUID NOT NULL,
    "bookmark_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_catalog_collection_items_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_cohorts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "organization_id" UUID,
    "title" VARCHAR(180),
    "starts_at" TIMESTAMPTZ,
    "ends_at" TIMESTAMPTZ,
    "expires_at" TIMESTAMPTZ,
    "archived_at" TIMESTAMPTZ,
    "max_participants" INTEGER,
    "status" VARCHAR(25) NOT NULL DEFAULT 'open',
    "enrollment_mode" VARCHAR(25) NOT NULL DEFAULT 'open',
    "access_code_hash" VARCHAR(255),
    "publication_policy" VARCHAR(30) NOT NULL DEFAULT 'never',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_cohorts_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_cohort_instructors" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "cohort_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(30) NOT NULL DEFAULT 'instructor',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_cohort_instructors_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_enrollments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "cohort_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "enrolled_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMPTZ,
    "access_ends_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_enrollments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_lesson_progress" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "enrollment_id" UUID NOT NULL,
    "lesson_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'not_started',
    "progress_percent" NUMERIC(5,2) NOT NULL DEFAULT 0,
    "first_opened_at" TIMESTAMPTZ,
    "last_opened_at" TIMESTAMPTZ,
    "completed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_lesson_progress_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_resource_progress" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "enrollment_id" UUID NOT NULL,
    "resource_id" UUID NOT NULL,
    "progress_percent" NUMERIC(5,2) NOT NULL DEFAULT 0,
    "time_seconds" INTEGER NOT NULL DEFAULT 0,
    "completed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_resource_progress_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_course_progress" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "enrollment_id" UUID NOT NULL,
    "percent_complete" NUMERIC(5,2) NOT NULL DEFAULT 0,
    "active_seconds" BIGINT NOT NULL DEFAULT 0,
    "last_activity_at" TIMESTAMPTZ,
    "completed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_course_progress_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_study_sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "enrollment_id" UUID,
    "lesson_id" UUID,
    "resource_id" UUID,
    "started_at" TIMESTAMPTZ NOT NULL,
    "ended_at" TIMESTAMPTZ,
    "active_seconds" INTEGER NOT NULL DEFAULT 0,
    "device_session_key" VARCHAR(120),
    "source" VARCHAR(20) NOT NULL DEFAULT 'app',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_study_sessions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_learning_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "enrollment_id" UUID,
    "resource_id" UUID,
    "event_key" UUID NOT NULL,
    "event_type" VARCHAR(45) NOT NULL,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "received_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_learning_events_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_course_notes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "lesson_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "position_seconds" INTEGER,
    "is_private" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_course_notes_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_course_reviews" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "rating" SMALLINT NOT NULL,
    "body" TEXT,
    "status" VARCHAR(25) NOT NULL DEFAULT 'published',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_course_reviews_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_learning_goals" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "title" VARCHAR(180) NOT NULL,
    "target_count" INTEGER NOT NULL DEFAULT 0,
    "target_minutes" INTEGER NOT NULL DEFAULT 0,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_learning_goals_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_certificate_templates" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "name" VARCHAR(180) NOT NULL,
    "template_asset_id" UUID,
    "verification_template" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_certificate_templates_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_certificates" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "course_id" UUID,
    "organization_id" UUID,
    "template_id" UUID,
    "certificate_code" VARCHAR(90) NOT NULL,
    "issued_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revoked_at" TIMESTAMPTZ,
    "document_asset_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_certificates_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_badges" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "icon_asset_id" UUID,
    "criteria" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_badges_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."learning_person_badges" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "badge_id" UUID NOT NULL,
    "awarded_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reason" TEXT,
    "revoked_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_learning_person_badges_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_rubrics" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "owner_id" UUID NOT NULL,
    "name" VARCHAR(180) NOT NULL,
    "description" TEXT,
    "max_score" NUMERIC(10,2) NOT NULL DEFAULT 20,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_rubrics_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_rubric_criteria" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "rubric_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "name" VARCHAR(180) NOT NULL,
    "description" TEXT,
    "max_points" NUMERIC(10,2) NOT NULL,
    "performance_levels" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_rubric_criteria_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_question_banks" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "owner_id" UUID NOT NULL,
    "name" VARCHAR(180) NOT NULL,
    "visibility" VARCHAR(20) NOT NULL DEFAULT 'private',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_question_banks_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_questions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "bank_id" UUID NOT NULL,
    "question_type" VARCHAR(30) NOT NULL,
    "prompt" TEXT NOT NULL,
    "media_id" UUID,
    "solution" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "difficulty" SMALLINT NOT NULL DEFAULT 1,
    "points" NUMERIC(10,2) NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_questions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_question_options" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "question_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "label" TEXT NOT NULL,
    "is_correct" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_question_options_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_assessments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "course_id" UUID NOT NULL,
    "cohort_id" UUID,
    "title" VARCHAR(220) NOT NULL,
    "assessment_type" VARCHAR(30) NOT NULL,
    "grading_type" VARCHAR(25) NOT NULL DEFAULT 'points',
    "rubric_id" UUID,
    "instructions" TEXT,
    "max_score" NUMERIC(10,2) NOT NULL DEFAULT 20,
    "allowed_attempts" INTEGER NOT NULL DEFAULT 1,
    "is_group_work" BOOLEAN NOT NULL DEFAULT false,
    "open_at" TIMESTAMPTZ,
    "due_at" TIMESTAMPTZ,
    "close_at" TIMESTAMPTZ,
    "late_policy" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "settings" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_assessments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_assessment_questions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "assessment_id" UUID NOT NULL,
    "question_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "points_override" NUMERIC(10,2),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_assessment_questions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_teams" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "cohort_id" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "leader_person_id" UUID,
    "created_for_assessment_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_teams_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_team_members" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "team_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(25) NOT NULL DEFAULT 'member',
    "joined_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "left_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_team_members_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_assessment_extensions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "assessment_id" UUID NOT NULL,
    "person_id" UUID,
    "team_id" UUID,
    "new_due_at" TIMESTAMPTZ,
    "extra_attempts" INTEGER NOT NULL DEFAULT 0,
    "reason" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_assessment_extensions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_submissions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "assessment_id" UUID NOT NULL,
    "person_id" UUID,
    "team_id" UUID,
    "attempt_number" INTEGER NOT NULL DEFAULT 1,
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "text_answer" TEXT,
    "submitted_at" TIMESTAMPTZ,
    "graded_at" TIMESTAMPTZ,
    "score" NUMERIC(10,2),
    "graded_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_submissions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_submission_files" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "submission_id" UUID NOT NULL,
    "asset_id" UUID NOT NULL,
    "display_name" VARCHAR(220),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_submission_files_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_submission_members" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "submission_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "individual_score" NUMERIC(10,2),
    "participation_note" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_submission_members_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_attempt_answers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "submission_id" UUID NOT NULL,
    "question_id" UUID NOT NULL,
    "answer_payload" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "score" NUMERIC(10,2),
    "graded_by" UUID,
    "graded_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_attempt_answers_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_criterion_scores" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "submission_id" UUID NOT NULL,
    "criterion_id" UUID NOT NULL,
    "person_id" UUID,
    "points" NUMERIC(10,2) NOT NULL,
    "comments" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_criterion_scores_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."assessment_grade_changes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "submission_id" UUID NOT NULL,
    "previous_score" NUMERIC(10,2),
    "new_score" NUMERIC(10,2),
    "reason" TEXT NOT NULL,
    "changed_by" UUID NOT NULL,
    "changed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_assessment_grade_changes_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_faculties" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "parent_id" UUID,
    "code" VARCHAR(30) NOT NULL,
    "name" VARCHAR(180) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_faculties_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_programs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "faculty_id" UUID,
    "code" VARCHAR(35) NOT NULL,
    "name" VARCHAR(220) NOT NULL,
    "degree_level" VARCHAR(35),
    "awarded_title" VARCHAR(200),
    "status" VARCHAR(20) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_programs_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_curricula" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "program_id" UUID NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "version_label" VARCHAR(80) NOT NULL,
    "effective_from" DATE,
    "effective_to" DATE,
    "required_credits" NUMERIC(7,2),
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_curricula_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_curriculum_courses" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "curriculum_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "code" VARCHAR(30) NOT NULL,
    "term_number" SMALLINT,
    "credits" NUMERIC(6,2) NOT NULL,
    "required" BOOLEAN NOT NULL DEFAULT true,
    "group_code" VARCHAR(35),
    "hours_weekly" NUMERIC(5,2),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_curriculum_courses_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_curriculum_prerequisites" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "curriculum_course_id" UUID NOT NULL,
    "prerequisite_course_id" UUID NOT NULL,
    "minimum_grade" NUMERIC(5,2),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_curriculum_prerequisites_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_terms" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "code" VARCHAR(40) NOT NULL,
    "name" VARCHAR(130) NOT NULL,
    "starts_on" DATE NOT NULL,
    "ends_on" DATE NOT NULL,
    "enrollment_starts_on" DATE,
    "enrollment_ends_on" DATE,
    "status" VARCHAR(25) NOT NULL DEFAULT 'planned',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_terms_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_student_programs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "program_id" UUID NOT NULL,
    "curriculum_id" UUID NOT NULL,
    "site_id" UUID,
    "student_number" VARCHAR(50) NOT NULL,
    "admitted_on" DATE,
    "status" VARCHAR(30) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_student_programs_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_admission_applications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "program_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "term_id" UUID,
    "application_code" VARCHAR(70) NOT NULL,
    "status" VARCHAR(30) NOT NULL DEFAULT 'submitted',
    "decision_at" TIMESTAMPTZ,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_admission_applications_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_admission_requirements" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "program_id" UUID NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "label" VARCHAR(200) NOT NULL,
    "is_required" BOOLEAN NOT NULL DEFAULT true,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_admission_requirements_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_application_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "application_id" UUID NOT NULL,
    "requirement_id" UUID NOT NULL,
    "asset_id" UUID NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'pending',
    "reviewed_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_application_documents_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_registrations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_program_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "registered_at" TIMESTAMPTZ,
    "confirmed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_registrations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_sections" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "cohort_id" UUID,
    "site_id" UUID,
    "code" VARCHAR(50) NOT NULL,
    "capacity" INTEGER,
    "delivery_mode" VARCHAR(25) NOT NULL DEFAULT 'hybrid',
    "status" VARCHAR(25) NOT NULL DEFAULT 'planned',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_sections_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_section_instructors" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "section_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(25) NOT NULL DEFAULT 'teacher',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_section_instructors_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_section_enrollments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "registration_id" UUID NOT NULL,
    "section_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'enrolled',
    "attempt_number" SMALLINT NOT NULL DEFAULT 1,
    "withdrawn_at" TIMESTAMPTZ,
    "final_grade" NUMERIC(6,2),
    "result" VARCHAR(25),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_section_enrollments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_class_sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "section_id" UUID NOT NULL,
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ NOT NULL,
    "session_type" VARCHAR(25) NOT NULL DEFAULT 'class',
    "room" VARCHAR(100),
    "meeting_url" TEXT,
    "recording_id" UUID,
    "status" VARCHAR(25) NOT NULL DEFAULT 'scheduled',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_class_sessions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_attendance" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "class_session_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'absent',
    "marked_at" TIMESTAMPTZ,
    "marked_by" UUID,
    "justification" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_attendance_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_gradebook_items" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "section_id" UUID NOT NULL,
    "assessment_id" UUID,
    "title" VARCHAR(180) NOT NULL,
    "weight_percent" NUMERIC(5,2) NOT NULL,
    "max_score" NUMERIC(7,2) NOT NULL DEFAULT 20,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_gradebook_items_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_gradebook_scores" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "item_id" UUID NOT NULL,
    "section_enrollment_id" UUID NOT NULL,
    "score" NUMERIC(7,2),
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "published_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_gradebook_scores_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_grade_appeals" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "section_enrollment_id" UUID NOT NULL,
    "gradebook_item_id" UUID,
    "reason" TEXT NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'submitted',
    "resolution" TEXT,
    "resolved_by" UUID,
    "resolved_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_grade_appeals_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_credit_recognitions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_program_id" UUID NOT NULL,
    "curriculum_course_id" UUID NOT NULL,
    "source_institution" VARCHAR(220),
    "source_course" VARCHAR(220),
    "recognized_credits" NUMERIC(6,2) NOT NULL,
    "approved_by" UUID,
    "approved_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_credit_recognitions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_academic_records" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_program_id" UUID NOT NULL,
    "section_enrollment_id" UUID,
    "curriculum_course_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "final_grade" NUMERIC(7,2),
    "result" VARCHAR(25) NOT NULL,
    "credits_earned" NUMERIC(6,2) NOT NULL DEFAULT 0,
    "recorded_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_academic_records_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."academic_degree_applications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_program_id" UUID NOT NULL,
    "degree_type" VARCHAR(60) NOT NULL,
    "status" VARCHAR(30) NOT NULL DEFAULT 'submitted',
    "submitted_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approved_at" TIMESTAMPTZ,
    "document_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_academic_degree_applications_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_communities" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "owner_id" UUID NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "description" TEXT,
    "cover_asset_id" UUID,
    "privacy" VARCHAR(25) NOT NULL DEFAULT 'public',
    "join_policy" VARCHAR(25) NOT NULL DEFAULT 'open',
    "status" VARCHAR(20) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_communities_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_community_members" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(30) NOT NULL DEFAULT 'member',
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "joined_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "muted_until" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_community_members_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_community_join_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_community_join_requests_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_community_rules" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "title" VARCHAR(160) NOT NULL,
    "body" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_community_rules_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_groups" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "description" TEXT,
    "privacy" VARCHAR(25) NOT NULL DEFAULT 'members',
    "posting_policy" VARCHAR(25) NOT NULL DEFAULT 'members',
    "expires_messages_hours" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_groups_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_group_members" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "group_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(25) NOT NULL DEFAULT 'member',
    "mute_until" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_group_members_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_channels" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "description" TEXT,
    "posting_policy" VARCHAR(25) NOT NULL DEFAULT 'admins',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_channels_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_channel_subscribers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "channel_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "muted" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_channel_subscribers_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_posts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "title" VARCHAR(200),
    "body" TEXT,
    "course_id" UUID,
    "resource_id" UUID,
    "status" VARCHAR(25) NOT NULL DEFAULT 'published',
    "scheduled_at" TIMESTAMPTZ,
    "published_at" TIMESTAMPTZ,
    "is_pinned" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_posts_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_post_attachments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "asset_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_post_attachments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_post_comments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "parent_id" UUID,
    "author_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'published',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_post_comments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_post_reactions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "reaction" VARCHAR(30) NOT NULL DEFAULT 'like',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_post_reactions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_qa_questions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "community_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "title" VARCHAR(220) NOT NULL,
    "body" TEXT NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'open',
    "accepted_answer_id" UUID,
    "votes_cache" INTEGER NOT NULL DEFAULT 0,
    "views_cache" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_qa_questions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_qa_answers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "question_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "votes_cache" INTEGER NOT NULL DEFAULT 0,
    "is_accepted" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_qa_answers_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_qa_votes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "answer_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "value" SMALLINT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_qa_votes_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_reputation_ledger" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "community_id" UUID,
    "reason" VARCHAR(100) NOT NULL,
    "points" INTEGER NOT NULL,
    "source_type" VARCHAR(60),
    "source_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_reputation_ledger_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_course_forums" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "cohort_id" UUID NOT NULL,
    "title" VARCHAR(180) NOT NULL,
    "visibility" VARCHAR(25) NOT NULL DEFAULT 'participants',
    "teacher_only" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_course_forums_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_forum_threads" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "forum_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "title" VARCHAR(220) NOT NULL,
    "body" TEXT,
    "is_locked" BOOLEAN NOT NULL DEFAULT false,
    "is_pinned" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_forum_threads_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_forum_replies" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "thread_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "parent_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_forum_replies_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_chat_rooms" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "cohort_id" UUID,
    "group_id" UUID,
    "channel_id" UUID,
    "room_type" VARCHAR(25) NOT NULL,
    "name" VARCHAR(160),
    "posting_policy" VARCHAR(25) NOT NULL DEFAULT 'members',
    "expires_messages_hours" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_chat_rooms_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_chat_members" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "room_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "role" VARCHAR(25) NOT NULL DEFAULT 'member',
    "last_read_at" TIMESTAMPTZ,
    "muted_until" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_chat_members_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_chat_messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "room_id" UUID NOT NULL,
    "sender_id" UUID NOT NULL,
    "reply_to_id" UUID,
    "body" TEXT,
    "asset_id" UUID,
    "sent_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "edited_at" TIMESTAMPTZ,
    "deleted_at" TIMESTAMPTZ,
    "client_message_key" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_chat_messages_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_moderation_reports" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "reporter_id" UUID NOT NULL,
    "community_id" UUID,
    "target_type" VARCHAR(50) NOT NULL,
    "target_id" UUID NOT NULL,
    "reason" VARCHAR(70) NOT NULL,
    "details" TEXT,
    "status" VARCHAR(25) NOT NULL DEFAULT 'open',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_moderation_reports_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_moderation_actions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "report_id" UUID,
    "moderator_id" UUID NOT NULL,
    "action_type" VARCHAR(40) NOT NULL,
    "target_type" VARCHAR(50) NOT NULL,
    "target_id" UUID NOT NULL,
    "reason" TEXT,
    "expires_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_moderation_actions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_bot_agents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "community_id" UUID,
    "name" VARCHAR(150) NOT NULL,
    "agent_type" VARCHAR(45) NOT NULL,
    "is_disclosed" BOOLEAN NOT NULL DEFAULT true,
    "is_enabled" BOOLEAN NOT NULL DEFAULT false,
    "permissions" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "configuration" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_bot_agents_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_bot_runs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "agent_id" UUID NOT NULL,
    "run_type" VARCHAR(50) NOT NULL,
    "status" VARCHAR(25) NOT NULL,
    "action_summary" TEXT,
    "started_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finished_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_bot_runs_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_saved_lists" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "color_hex" CHAR(6),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_saved_lists_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."social_saved_list_items" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "list_id" UUID NOT NULL,
    "community_id" UUID,
    "room_id" UUID,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_social_saved_list_items_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."calendar_calendars" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "owner_person_id" UUID,
    "organization_id" UUID,
    "cohort_id" UUID,
    "name" VARCHAR(150) NOT NULL,
    "color_hex" CHAR(6),
    "visibility" VARCHAR(25) NOT NULL DEFAULT 'private',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_calendar_calendars_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."calendar_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "calendar_id" UUID NOT NULL,
    "title" VARCHAR(220) NOT NULL,
    "description" TEXT,
    "event_type" VARCHAR(45) NOT NULL,
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ NOT NULL,
    "location" VARCHAR(220),
    "meeting_url" TEXT,
    "course_id" UUID,
    "section_id" UUID,
    "assessment_id" UUID,
    "is_all_day" BOOLEAN NOT NULL DEFAULT false,
    "created_for_person_id" UUID,
    "status" VARCHAR(25) NOT NULL DEFAULT 'scheduled',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_calendar_events_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."calendar_event_recurrences" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "event_id" UUID NOT NULL,
    "rrule" TEXT NOT NULL,
    "timezone" VARCHAR(80) NOT NULL,
    "until_at" TIMESTAMPTZ,
    "excluded_dates" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_calendar_event_recurrences_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."calendar_event_attendees" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "event_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "response" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "attended_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_calendar_event_attendees_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."calendar_reminders" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "event_id" UUID,
    "title" VARCHAR(220) NOT NULL,
    "remind_at" TIMESTAMPTZ NOT NULL,
    "channel" VARCHAR(25) NOT NULL DEFAULT 'push',
    "completed_at" TIMESTAMPTZ,
    "status" VARCHAR(25) NOT NULL DEFAULT 'scheduled',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_calendar_reminders_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."calendar_calendar_subscriptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "calendar_id" UUID NOT NULL,
    "is_visible" BOOLEAN NOT NULL DEFAULT true,
    "notify" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_calendar_calendar_subscriptions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."communication_notifications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "organization_id" UUID,
    "notification_type" VARCHAR(70) NOT NULL,
    "title" VARCHAR(220) NOT NULL,
    "body" TEXT,
    "payload" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "read_at" TIMESTAMPTZ,
    "expires_at" TIMESTAMPTZ,
    "priority" SMALLINT NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_communication_notifications_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."communication_notification_preferences" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "organization_id" UUID,
    "event_type" VARCHAR(70) NOT NULL,
    "channel" VARCHAR(20) NOT NULL,
    "delivery_mode" VARCHAR(20) NOT NULL DEFAULT 'immediate',
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "quiet_hours" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_communication_notification_preferences_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."communication_notification_deliveries" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "notification_id" UUID NOT NULL,
    "channel" VARCHAR(20) NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "attempts" SMALLINT NOT NULL DEFAULT 0,
    "sent_at" TIMESTAMPTZ,
    "failure_code" VARCHAR(100),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_communication_notification_deliveries_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."communication_ai_conversations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "course_id" UUID,
    "cohort_id" UUID,
    "organization_id" UUID,
    "title" VARCHAR(160),
    "context_type" VARCHAR(40) NOT NULL DEFAULT 'general',
    "privacy" VARCHAR(20) NOT NULL DEFAULT 'private',
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_communication_ai_conversations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."communication_ai_messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "conversation_id" UUID NOT NULL,
    "role" VARCHAR(20) NOT NULL,
    "content" TEXT NOT NULL,
    "model_name" VARCHAR(100),
    "tokens_input" INTEGER,
    "tokens_output" INTEGER,
    "is_simulated" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_communication_ai_messages_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."communication_ai_usage" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "person_id" UUID NOT NULL,
    "organization_id" UUID,
    "usage_date" DATE NOT NULL,
    "feature_code" VARCHAR(60) NOT NULL,
    "units" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_communication_ai_usage_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_interactive_2d" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "resource_id" UUID NOT NULL,
    "scene_kind" VARCHAR(40) NOT NULL,
    "renderer" VARCHAR(30) NOT NULL DEFAULT 'native',
    "asset_id" UUID,
    "scene_data" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "min_app_version" VARCHAR(30),
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_interactive_2d_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_interactive_hotspots" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "scene_id" UUID NOT NULL,
    "code" VARCHAR(90) NOT NULL,
    "label" VARCHAR(160) NOT NULL,
    "geometry" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "action_type" VARCHAR(40) NOT NULL DEFAULT 'open_resource',
    "resource_id" UUID,
    "course_id" UUID,
    "payload" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_interactive_hotspots_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_models_3d" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "resource_id" UUID NOT NULL,
    "model_asset_id" UUID NOT NULL,
    "format" VARCHAR(25) NOT NULL,
    "viewer_options" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "is_ar_enabled" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_models_3d_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_model_annotations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "model_id" UUID NOT NULL,
    "label" VARCHAR(160) NOT NULL,
    "body" TEXT,
    "anchor" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_model_annotations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_simulators" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "owner_id" UUID NOT NULL,
    "title" VARCHAR(220) NOT NULL,
    "description" TEXT,
    "simulator_type" VARCHAR(35) NOT NULL,
    "runtime" VARCHAR(35) NOT NULL,
    "version" VARCHAR(30) NOT NULL DEFAULT 1.0,
    "config" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_simulators_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_simulator_parameters" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "simulator_id" UUID NOT NULL,
    "code" VARCHAR(80) NOT NULL,
    "label" VARCHAR(160) NOT NULL,
    "data_type" VARCHAR(25) NOT NULL,
    "unit" VARCHAR(35),
    "min_value" NUMERIC(18,6),
    "max_value" NUMERIC(18,6),
    "default_value" JSONB,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_simulator_parameters_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_simulator_experiments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "simulator_id" UUID NOT NULL,
    "course_id" UUID,
    "lesson_id" UUID,
    "title" VARCHAR(200) NOT NULL,
    "instructions" TEXT,
    "expected_results" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_simulator_experiments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."content_simulation_runs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "experiment_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "started_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finished_at" TIMESTAMPTZ,
    "input_values" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "output_values" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "status" VARCHAR(25) NOT NULL DEFAULT 'running',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_content_simulation_runs_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_plans" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "code" VARCHAR(40) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "target_type" VARCHAR(25) NOT NULL DEFAULT 'person',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_plans_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_features" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "code" VARCHAR(75) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "value_type" VARCHAR(20) NOT NULL DEFAULT 'boolean',
    "description" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_features_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_plan_entitlements" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "plan_id" UUID NOT NULL,
    "feature_id" UUID NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "limit_numeric" NUMERIC(15,2),
    "config" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_plan_entitlements_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_plan_prices" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "plan_id" UUID NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'PEN',
    "billing_interval" VARCHAR(25) NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_plan_prices_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_subscriptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "plan_id" UUID NOT NULL,
    "person_id" UUID,
    "organization_id" UUID,
    "status" VARCHAR(25) NOT NULL DEFAULT 'trialing',
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ,
    "auto_renew" BOOLEAN NOT NULL DEFAULT false,
    "external_reference" VARCHAR(130),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_subscriptions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_subscription_usage" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "subscription_id" UUID NOT NULL,
    "feature_id" UUID NOT NULL,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "units_used" NUMERIC(15,2) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_subscription_usage_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_checkout_orders" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "subscription_id" UUID,
    "buyer_person_id" UUID,
    "organization_id" UUID,
    "currency" CHAR(3) NOT NULL DEFAULT 'PEN',
    "amount_due" NUMERIC(14,2) NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "external_reference" VARCHAR(140),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_checkout_orders_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_platform_payments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "order_id" UUID NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'PEN',
    "provider" VARCHAR(50) NOT NULL,
    "provider_reference" VARCHAR(160),
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "paid_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_platform_payments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_ad_campaigns" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "advertiser_name" VARCHAR(180) NOT NULL,
    "title" VARCHAR(160) NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "starts_at" TIMESTAMPTZ,
    "ends_at" TIMESTAMPTZ,
    "budget" NUMERIC(14,2),
    "targeting" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_ad_campaigns_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_ad_creatives" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "campaign_id" UUID NOT NULL,
    "asset_id" UUID,
    "headline" VARCHAR(160) NOT NULL,
    "body" TEXT,
    "target_url" TEXT NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending_review',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_ad_creatives_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_ad_placements" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "code" VARCHAR(70) NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "surface" VARCHAR(35) NOT NULL,
    "max_frequency_per_day" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_ad_placements_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."platform_ad_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "campaign_id" UUID NOT NULL,
    "creative_id" UUID NOT NULL,
    "placement_id" UUID NOT NULL,
    "person_id" UUID,
    "event_type" VARCHAR(20) NOT NULL,
    "occurred_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "anonymous_session_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_platform_ad_events_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_tuition_schedules" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "program_id" UUID,
    "name" VARCHAR(160) NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'PEN',
    "amount" NUMERIC(14,2) NOT NULL,
    "installments_count" SMALLINT NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_tuition_schedules_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_student_accounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "student_program_id" UUID NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'PEN',
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_student_accounts_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_student_charges" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "account_id" UUID NOT NULL,
    "term_id" UUID,
    "charge_type" VARCHAR(40) NOT NULL,
    "description" VARCHAR(240) NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "issued_on" DATE NOT NULL,
    "due_on" DATE,
    "status" VARCHAR(25) NOT NULL DEFAULT 'open',
    "reference_code" VARCHAR(90),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_student_charges_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_installments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "charge_id" UUID NOT NULL,
    "installment_number" SMALLINT NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "due_on" DATE NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_installments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_student_payments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "account_id" UUID NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'PEN',
    "payment_method" VARCHAR(40) NOT NULL,
    "provider_reference" VARCHAR(160),
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "paid_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_student_payments_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_payment_allocations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "payment_id" UUID NOT NULL,
    "installment_id" UUID NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_payment_allocations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_scholarships" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(170) NOT NULL,
    "benefit_type" VARCHAR(25) NOT NULL,
    "benefit_value" NUMERIC(14,2) NOT NULL,
    "rules" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_scholarships_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_scholarship_applications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "scholarship_id" UUID NOT NULL,
    "student_program_id" UUID NOT NULL,
    "status" VARCHAR(25) NOT NULL DEFAULT 'submitted',
    "requested_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decision_at" TIMESTAMPTZ,
    "reviewer_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_scholarship_applications_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_scholarship_awards" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "application_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "approved_value" NUMERIC(14,2) NOT NULL,
    "starts_on" DATE,
    "ends_on" DATE,
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_scholarship_awards_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."finance_financial_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "payment_id" UUID,
    "document_type" VARCHAR(30) NOT NULL,
    "series" VARCHAR(30),
    "number" VARCHAR(40),
    "asset_id" UUID,
    "issued_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_finance_financial_documents_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_procedures" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "code" VARCHAR(60) NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "fee_amount" NUMERIC(14,2) NOT NULL DEFAULT 0,
    "response_days" INTEGER,
    "requirements" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_procedures_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_procedure_steps" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "procedure_id" UUID NOT NULL,
    "step_order" INTEGER NOT NULL,
    "name" VARCHAR(140) NOT NULL,
    "required_role" VARCHAR(80),
    "settings" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_procedure_steps_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_procedure_fields" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "procedure_id" UUID NOT NULL,
    "field_code" VARCHAR(70) NOT NULL,
    "label" VARCHAR(180) NOT NULL,
    "field_type" VARCHAR(30) NOT NULL,
    "required" BOOLEAN NOT NULL DEFAULT false,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "validation_rules" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_procedure_fields_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "procedure_id" UUID NOT NULL,
    "requester_id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "tracking_code" VARCHAR(80) NOT NULL,
    "status" VARCHAR(30) NOT NULL DEFAULT 'submitted',
    "current_step_id" UUID,
    "submitted_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "closed_at" TIMESTAMPTZ,
    "form_data" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_requests_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_request_files" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "asset_id" UUID NOT NULL,
    "purpose" VARCHAR(100),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_request_files_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_request_transitions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "step_id" UUID,
    "actor_id" UUID,
    "from_status" VARCHAR(30),
    "to_status" VARCHAR(30) NOT NULL,
    "remarks" TEXT,
    "occurred_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_request_transitions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_service_offerings" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "code" VARCHAR(60) NOT NULL,
    "name" VARCHAR(160) NOT NULL,
    "service_type" VARCHAR(40) NOT NULL,
    "description" TEXT,
    "eligibility_rules" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_service_offerings_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_service_memberships" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "offering_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ,
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_service_memberships_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_physical_assets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID NOT NULL,
    "site_id" UUID,
    "asset_code" VARCHAR(60) NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "asset_type" VARCHAR(40) NOT NULL,
    "inventory_status" VARCHAR(25) NOT NULL DEFAULT 'available',
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_physical_assets_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_asset_reservations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "asset_id" UUID NOT NULL,
    "requested_by" UUID NOT NULL,
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ NOT NULL,
    "purpose" TEXT,
    "status" VARCHAR(25) NOT NULL DEFAULT 'pending',
    "approved_by" UUID,
    "approved_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_asset_reservations_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_reservation_attendees" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "reservation_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_reservation_attendees_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_asset_loans" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "asset_id" UUID NOT NULL,
    "person_id" UUID NOT NULL,
    "loaned_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "due_at" TIMESTAMPTZ NOT NULL,
    "returned_at" TIMESTAMPTZ,
    "status" VARCHAR(25) NOT NULL DEFAULT 'active',
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_asset_loans_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_surveys" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "course_id" UUID,
    "section_id" UUID,
    "teacher_id" UUID,
    "title" VARCHAR(220) NOT NULL,
    "description" TEXT,
    "survey_type" VARCHAR(40) NOT NULL,
    "starts_at" TIMESTAMPTZ,
    "ends_at" TIMESTAMPTZ,
    "anonymous" BOOLEAN NOT NULL DEFAULT false,
    "status" VARCHAR(25) NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_surveys_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_survey_questions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "survey_id" UUID NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "prompt" TEXT NOT NULL,
    "question_type" VARCHAR(30) NOT NULL,
    "options" JSONB NOT NULL DEFAULT '[]'::jsonb,
    "is_required" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_survey_questions_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_survey_responses" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "survey_id" UUID NOT NULL,
    "respondent_id" UUID,
    "submitted_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "anonymous_token" UUID,
    "metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_survey_responses_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_survey_answers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "response_id" UUID NOT NULL,
    "question_id" UUID NOT NULL,
    "answer" JSONB NOT NULL DEFAULT '{}'::jsonb,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_survey_answers_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_support_tickets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "requester_id" UUID NOT NULL,
    "assigned_to" UUID,
    "subject" VARCHAR(220) NOT NULL,
    "description" TEXT NOT NULL,
    "priority" VARCHAR(25) NOT NULL DEFAULT 'normal',
    "status" VARCHAR(25) NOT NULL DEFAULT 'open',
    "closed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_support_tickets_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_support_messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "ticket_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "asset_id" UUID,
    "is_internal" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_support_messages_" PRIMARY KEY ("id")
);

CREATE TABLE "app"."services_job_postings" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "organization_id" UUID,
    "company_name" VARCHAR(180) NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "application_url" TEXT,
    "closes_at" TIMESTAMPTZ,
    "status" VARCHAR(25) NOT NULL DEFAULT 'published',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" UUID,
    "updated_by" UUID,
    CONSTRAINT "pk_services_job_postings_" PRIMARY KEY ("id")
);


-- ============================================================================
-- 2. CLAVES FORANEAS Y RESTRICCIONES
-- ============================================================================

ALTER TABLE "app"."core_countries" ADD CONSTRAINT "fk_core_countries_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_countries" ADD CONSTRAINT "fk_core_countries_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_regions" ADD CONSTRAINT "fk_core_regions_country_id" FOREIGN KEY ("country_id") REFERENCES "app"."core_countries"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_regions" ADD CONSTRAINT "fk_core_regions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_regions" ADD CONSTRAINT "fk_core_regions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_provinces" ADD CONSTRAINT "fk_core_provinces_region_id" FOREIGN KEY ("region_id") REFERENCES "app"."core_regions"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_provinces" ADD CONSTRAINT "fk_core_provinces_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_provinces" ADD CONSTRAINT "fk_core_provinces_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_districts" ADD CONSTRAINT "fk_core_districts_province_id" FOREIGN KEY ("province_id") REFERENCES "app"."core_provinces"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_districts" ADD CONSTRAINT "fk_core_districts_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_districts" ADD CONSTRAINT "fk_core_districts_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_people" ADD CONSTRAINT "fk_core_people_district_id" FOREIGN KEY ("district_id") REFERENCES "app"."core_districts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_profiles" ADD CONSTRAINT "fk_core_profiles_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_profiles" ADD CONSTRAINT "fk_core_profiles_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_profiles" ADD CONSTRAINT "fk_core_profiles_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_user_preferences" ADD CONSTRAINT "fk_core_user_preferences_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_user_preferences" ADD CONSTRAINT "fk_core_user_preferences_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_user_preferences" ADD CONSTRAINT "fk_core_user_preferences_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organizations" ADD CONSTRAINT "fk_core_organizations_owner_person_id" FOREIGN KEY ("owner_person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organizations" ADD CONSTRAINT "fk_core_organizations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organizations" ADD CONSTRAINT "fk_core_organizations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_sites" ADD CONSTRAINT "fk_core_organization_sites_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_sites" ADD CONSTRAINT "fk_core_organization_sites_district_id" FOREIGN KEY ("district_id") REFERENCES "app"."core_districts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_sites" ADD CONSTRAINT "fk_core_organization_sites_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_sites" ADD CONSTRAINT "fk_core_organization_sites_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_memberships" ADD CONSTRAINT "fk_core_organization_memberships_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_memberships" ADD CONSTRAINT "fk_core_organization_memberships_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_memberships" ADD CONSTRAINT "fk_core_organization_memberships_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_memberships" ADD CONSTRAINT "fk_core_organization_memberships_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_roles" ADD CONSTRAINT "fk_core_organization_roles_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_roles" ADD CONSTRAINT "fk_core_organization_roles_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_roles" ADD CONSTRAINT "fk_core_organization_roles_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_membership_roles" ADD CONSTRAINT "fk_core_membership_roles_membership_id" FOREIGN KEY ("membership_id") REFERENCES "app"."core_organization_memberships"("id") ON DELETE CASCADE;
ALTER TABLE "app"."core_membership_roles" ADD CONSTRAINT "fk_core_membership_roles_role_id" FOREIGN KEY ("role_id") REFERENCES "app"."core_organization_roles"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_membership_roles" ADD CONSTRAINT "fk_core_membership_roles_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_membership_roles" ADD CONSTRAINT "fk_core_membership_roles_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_settings" ADD CONSTRAINT "fk_core_organization_settings_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_settings" ADD CONSTRAINT "fk_core_organization_settings_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_settings" ADD CONSTRAINT "fk_core_organization_settings_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_invitations" ADD CONSTRAINT "fk_core_organization_invitations_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_invitations" ADD CONSTRAINT "fk_core_organization_invitations_invited_by" FOREIGN KEY ("invited_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_invitations" ADD CONSTRAINT "fk_core_organization_invitations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_invitations" ADD CONSTRAINT "fk_core_organization_invitations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_institution_requests" ADD CONSTRAINT "fk_core_institution_requests_applicant_id" FOREIGN KEY ("applicant_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_institution_requests" ADD CONSTRAINT "fk_core_institution_requests_reviewed_by" FOREIGN KEY ("reviewed_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_institution_requests" ADD CONSTRAINT "fk_core_institution_requests_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_institution_requests" ADD CONSTRAINT "fk_core_institution_requests_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_legal_documents" ADD CONSTRAINT "fk_core_legal_documents_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_legal_documents" ADD CONSTRAINT "fk_core_legal_documents_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_legal_documents" ADD CONSTRAINT "fk_core_legal_documents_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_legal_acceptances" ADD CONSTRAINT "fk_core_legal_acceptances_document_id" FOREIGN KEY ("document_id") REFERENCES "app"."core_legal_documents"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_legal_acceptances" ADD CONSTRAINT "fk_core_legal_acceptances_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_legal_acceptances" ADD CONSTRAINT "fk_core_legal_acceptances_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_legal_acceptances" ADD CONSTRAINT "fk_core_legal_acceptances_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_announcements" ADD CONSTRAINT "fk_core_organization_announcements_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."core_organization_announcements" ADD CONSTRAINT "fk_core_organization_announcements_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_organization_announcements" ADD CONSTRAINT "fk_core_organization_announcements_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_audit_logs" ADD CONSTRAINT "fk_core_audit_logs_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_audit_logs" ADD CONSTRAINT "fk_core_audit_logs_actor_id" FOREIGN KEY ("actor_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_audit_logs" ADD CONSTRAINT "fk_core_audit_logs_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_audit_logs" ADD CONSTRAINT "fk_core_audit_logs_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_categories" ADD CONSTRAINT "fk_catalog_categories_parent_id" FOREIGN KEY ("parent_id") REFERENCES "app"."catalog_categories"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_categories" ADD CONSTRAINT "fk_catalog_categories_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_categories" ADD CONSTRAINT "fk_catalog_categories_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_tags" ADD CONSTRAINT "fk_catalog_tags_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_tags" ADD CONSTRAINT "fk_catalog_tags_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_skills" ADD CONSTRAINT "fk_catalog_skills_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_skills" ADD CONSTRAINT "fk_catalog_skills_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_media_assets" ADD CONSTRAINT "fk_catalog_media_assets_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_media_assets" ADD CONSTRAINT "fk_catalog_media_assets_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_media_assets" ADD CONSTRAINT "fk_catalog_media_assets_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_media_assets" ADD CONSTRAINT "fk_catalog_media_assets_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "fk_catalog_courses_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "fk_catalog_courses_owner_person_id" FOREIGN KEY ("owner_person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "fk_catalog_courses_category_id" FOREIGN KEY ("category_id") REFERENCES "app"."catalog_categories"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "fk_catalog_courses_thumbnail_id" FOREIGN KEY ("thumbnail_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "fk_catalog_courses_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "fk_catalog_courses_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_tags" ADD CONSTRAINT "fk_catalog_course_tags_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_tags" ADD CONSTRAINT "fk_catalog_course_tags_tag_id" FOREIGN KEY ("tag_id") REFERENCES "app"."catalog_tags"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_tags" ADD CONSTRAINT "fk_catalog_course_tags_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_tags" ADD CONSTRAINT "fk_catalog_course_tags_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_skills" ADD CONSTRAINT "fk_catalog_course_skills_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_skills" ADD CONSTRAINT "fk_catalog_course_skills_skill_id" FOREIGN KEY ("skill_id") REFERENCES "app"."catalog_skills"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_skills" ADD CONSTRAINT "fk_catalog_course_skills_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_skills" ADD CONSTRAINT "fk_catalog_course_skills_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_instructors" ADD CONSTRAINT "fk_catalog_course_instructors_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_instructors" ADD CONSTRAINT "fk_catalog_course_instructors_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."catalog_course_instructors" ADD CONSTRAINT "fk_catalog_course_instructors_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_instructors" ADD CONSTRAINT "fk_catalog_course_instructors_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_prerequisites" ADD CONSTRAINT "fk_catalog_course_prerequisites_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_prerequisites" ADD CONSTRAINT "fk_catalog_course_prerequisites_required_course_id" FOREIGN KEY ("required_course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."catalog_course_prerequisites" ADD CONSTRAINT "fk_catalog_course_prerequisites_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_prerequisites" ADD CONSTRAINT "fk_catalog_course_prerequisites_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_versions" ADD CONSTRAINT "fk_catalog_course_versions_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_course_versions" ADD CONSTRAINT "fk_catalog_course_versions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_course_versions" ADD CONSTRAINT "fk_catalog_course_versions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_modules" ADD CONSTRAINT "fk_catalog_modules_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_modules" ADD CONSTRAINT "fk_catalog_modules_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_modules" ADD CONSTRAINT "fk_catalog_modules_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_lessons" ADD CONSTRAINT "fk_catalog_lessons_module_id" FOREIGN KEY ("module_id") REFERENCES "app"."catalog_modules"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_lessons" ADD CONSTRAINT "fk_catalog_lessons_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_lessons" ADD CONSTRAINT "fk_catalog_lessons_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_resources" ADD CONSTRAINT "fk_catalog_resources_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_resources" ADD CONSTRAINT "fk_catalog_resources_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_resources" ADD CONSTRAINT "fk_catalog_resources_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_resources" ADD CONSTRAINT "fk_catalog_resources_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_resources" ADD CONSTRAINT "fk_catalog_resources_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_lesson_resources" ADD CONSTRAINT "fk_catalog_lesson_resources_lesson_id" FOREIGN KEY ("lesson_id") REFERENCES "app"."catalog_lessons"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_lesson_resources" ADD CONSTRAINT "fk_catalog_lesson_resources_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."catalog_lesson_resources" ADD CONSTRAINT "fk_catalog_lesson_resources_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_lesson_resources" ADD CONSTRAINT "fk_catalog_lesson_resources_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_learning_paths" ADD CONSTRAINT "fk_catalog_learning_paths_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_learning_paths" ADD CONSTRAINT "fk_catalog_learning_paths_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_learning_paths" ADD CONSTRAINT "fk_catalog_learning_paths_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_learning_paths" ADD CONSTRAINT "fk_catalog_learning_paths_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_learning_path_courses" ADD CONSTRAINT "fk_catalog_learning_path_courses_path_id" FOREIGN KEY ("path_id") REFERENCES "app"."catalog_learning_paths"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_learning_path_courses" ADD CONSTRAINT "fk_catalog_learning_path_courses_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."catalog_learning_path_courses" ADD CONSTRAINT "fk_catalog_learning_path_courses_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_learning_path_courses" ADD CONSTRAINT "fk_catalog_learning_path_courses_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_libraries" ADD CONSTRAINT "fk_catalog_external_libraries_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_libraries" ADD CONSTRAINT "fk_catalog_external_libraries_logo_asset_id" FOREIGN KEY ("logo_asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_libraries" ADD CONSTRAINT "fk_catalog_external_libraries_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_libraries" ADD CONSTRAINT "fk_catalog_external_libraries_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_library_links" ADD CONSTRAINT "fk_catalog_external_library_links_library_id" FOREIGN KEY ("library_id") REFERENCES "app"."catalog_external_libraries"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_external_library_links" ADD CONSTRAINT "fk_catalog_external_library_links_thumbnail_id" FOREIGN KEY ("thumbnail_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_library_links" ADD CONSTRAINT "fk_catalog_external_library_links_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_external_library_links" ADD CONSTRAINT "fk_catalog_external_library_links_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "fk_catalog_bookmarks_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "fk_catalog_bookmarks_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "fk_catalog_bookmarks_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "fk_catalog_bookmarks_external_link_id" FOREIGN KEY ("external_link_id") REFERENCES "app"."catalog_external_library_links"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "fk_catalog_bookmarks_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "fk_catalog_bookmarks_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_collections" ADD CONSTRAINT "fk_catalog_collections_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."catalog_collections" ADD CONSTRAINT "fk_catalog_collections_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_collections" ADD CONSTRAINT "fk_catalog_collections_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_collection_items" ADD CONSTRAINT "fk_catalog_collection_items_collection_id" FOREIGN KEY ("collection_id") REFERENCES "app"."catalog_collections"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_collection_items" ADD CONSTRAINT "fk_catalog_collection_items_bookmark_id" FOREIGN KEY ("bookmark_id") REFERENCES "app"."catalog_bookmarks"("id") ON DELETE CASCADE;
ALTER TABLE "app"."catalog_collection_items" ADD CONSTRAINT "fk_catalog_collection_items_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."catalog_collection_items" ADD CONSTRAINT "fk_catalog_collection_items_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_cohorts" ADD CONSTRAINT "fk_learning_cohorts_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_cohorts" ADD CONSTRAINT "fk_learning_cohorts_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_cohorts" ADD CONSTRAINT "fk_learning_cohorts_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_cohorts" ADD CONSTRAINT "fk_learning_cohorts_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_cohort_instructors" ADD CONSTRAINT "fk_learning_cohort_instructors_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE CASCADE;
ALTER TABLE "app"."learning_cohort_instructors" ADD CONSTRAINT "fk_learning_cohort_instructors_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_cohort_instructors" ADD CONSTRAINT "fk_learning_cohort_instructors_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_cohort_instructors" ADD CONSTRAINT "fk_learning_cohort_instructors_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_enrollments" ADD CONSTRAINT "fk_learning_enrollments_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_enrollments" ADD CONSTRAINT "fk_learning_enrollments_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_enrollments" ADD CONSTRAINT "fk_learning_enrollments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_enrollments" ADD CONSTRAINT "fk_learning_enrollments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_lesson_progress" ADD CONSTRAINT "fk_learning_lesson_progress_enrollment_id" FOREIGN KEY ("enrollment_id") REFERENCES "app"."learning_enrollments"("id") ON DELETE CASCADE;
ALTER TABLE "app"."learning_lesson_progress" ADD CONSTRAINT "fk_learning_lesson_progress_lesson_id" FOREIGN KEY ("lesson_id") REFERENCES "app"."catalog_lessons"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_lesson_progress" ADD CONSTRAINT "fk_learning_lesson_progress_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_lesson_progress" ADD CONSTRAINT "fk_learning_lesson_progress_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "fk_learning_resource_progress_enrollment_id" FOREIGN KEY ("enrollment_id") REFERENCES "app"."learning_enrollments"("id") ON DELETE CASCADE;
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "fk_learning_resource_progress_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "fk_learning_resource_progress_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "fk_learning_resource_progress_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_course_progress" ADD CONSTRAINT "fk_learning_course_progress_enrollment_id" FOREIGN KEY ("enrollment_id") REFERENCES "app"."learning_enrollments"("id") ON DELETE CASCADE;
ALTER TABLE "app"."learning_course_progress" ADD CONSTRAINT "fk_learning_course_progress_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_course_progress" ADD CONSTRAINT "fk_learning_course_progress_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "fk_learning_study_sessions_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "fk_learning_study_sessions_enrollment_id" FOREIGN KEY ("enrollment_id") REFERENCES "app"."learning_enrollments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "fk_learning_study_sessions_lesson_id" FOREIGN KEY ("lesson_id") REFERENCES "app"."catalog_lessons"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "fk_learning_study_sessions_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "fk_learning_study_sessions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "fk_learning_study_sessions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_learning_events" ADD CONSTRAINT "fk_learning_learning_events_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_learning_events" ADD CONSTRAINT "fk_learning_learning_events_enrollment_id" FOREIGN KEY ("enrollment_id") REFERENCES "app"."learning_enrollments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_learning_events" ADD CONSTRAINT "fk_learning_learning_events_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_learning_events" ADD CONSTRAINT "fk_learning_learning_events_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_learning_events" ADD CONSTRAINT "fk_learning_learning_events_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_course_notes" ADD CONSTRAINT "fk_learning_course_notes_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_course_notes" ADD CONSTRAINT "fk_learning_course_notes_lesson_id" FOREIGN KEY ("lesson_id") REFERENCES "app"."catalog_lessons"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_course_notes" ADD CONSTRAINT "fk_learning_course_notes_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_course_notes" ADD CONSTRAINT "fk_learning_course_notes_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_course_reviews" ADD CONSTRAINT "fk_learning_course_reviews_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_course_reviews" ADD CONSTRAINT "fk_learning_course_reviews_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_course_reviews" ADD CONSTRAINT "fk_learning_course_reviews_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_course_reviews" ADD CONSTRAINT "fk_learning_course_reviews_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_learning_goals" ADD CONSTRAINT "fk_learning_learning_goals_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_learning_goals" ADD CONSTRAINT "fk_learning_learning_goals_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_learning_goals" ADD CONSTRAINT "fk_learning_learning_goals_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificate_templates" ADD CONSTRAINT "fk_learning_certificate_templates_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificate_templates" ADD CONSTRAINT "fk_learning_certificate_templates_template_asset_id" FOREIGN KEY ("template_asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificate_templates" ADD CONSTRAINT "fk_learning_certificate_templates_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificate_templates" ADD CONSTRAINT "fk_learning_certificate_templates_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_template_id" FOREIGN KEY ("template_id") REFERENCES "app"."learning_certificate_templates"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_document_asset_id" FOREIGN KEY ("document_asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "fk_learning_certificates_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_badges" ADD CONSTRAINT "fk_learning_badges_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_badges" ADD CONSTRAINT "fk_learning_badges_icon_asset_id" FOREIGN KEY ("icon_asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_badges" ADD CONSTRAINT "fk_learning_badges_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_badges" ADD CONSTRAINT "fk_learning_badges_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_person_badges" ADD CONSTRAINT "fk_learning_person_badges_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_person_badges" ADD CONSTRAINT "fk_learning_person_badges_badge_id" FOREIGN KEY ("badge_id") REFERENCES "app"."learning_badges"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."learning_person_badges" ADD CONSTRAINT "fk_learning_person_badges_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."learning_person_badges" ADD CONSTRAINT "fk_learning_person_badges_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_rubrics" ADD CONSTRAINT "fk_assessment_rubrics_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_rubrics" ADD CONSTRAINT "fk_assessment_rubrics_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_rubrics" ADD CONSTRAINT "fk_assessment_rubrics_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_rubrics" ADD CONSTRAINT "fk_assessment_rubrics_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_rubric_criteria" ADD CONSTRAINT "fk_assessment_rubric_criteria_rubric_id" FOREIGN KEY ("rubric_id") REFERENCES "app"."assessment_rubrics"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_rubric_criteria" ADD CONSTRAINT "fk_assessment_rubric_criteria_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_rubric_criteria" ADD CONSTRAINT "fk_assessment_rubric_criteria_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_question_banks" ADD CONSTRAINT "fk_assessment_question_banks_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_question_banks" ADD CONSTRAINT "fk_assessment_question_banks_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_question_banks" ADD CONSTRAINT "fk_assessment_question_banks_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_question_banks" ADD CONSTRAINT "fk_assessment_question_banks_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_questions" ADD CONSTRAINT "fk_assessment_questions_bank_id" FOREIGN KEY ("bank_id") REFERENCES "app"."assessment_question_banks"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_questions" ADD CONSTRAINT "fk_assessment_questions_media_id" FOREIGN KEY ("media_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_questions" ADD CONSTRAINT "fk_assessment_questions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_questions" ADD CONSTRAINT "fk_assessment_questions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_question_options" ADD CONSTRAINT "fk_assessment_question_options_question_id" FOREIGN KEY ("question_id") REFERENCES "app"."assessment_questions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_question_options" ADD CONSTRAINT "fk_assessment_question_options_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_question_options" ADD CONSTRAINT "fk_assessment_question_options_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "fk_assessment_assessments_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "fk_assessment_assessments_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "fk_assessment_assessments_rubric_id" FOREIGN KEY ("rubric_id") REFERENCES "app"."assessment_rubrics"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "fk_assessment_assessments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "fk_assessment_assessments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessment_questions" ADD CONSTRAINT "fk_assessment_assessment_questions_assessment_id" FOREIGN KEY ("assessment_id") REFERENCES "app"."assessment_assessments"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_assessment_questions" ADD CONSTRAINT "fk_assessment_assessment_questions_question_id" FOREIGN KEY ("question_id") REFERENCES "app"."assessment_questions"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_assessment_questions" ADD CONSTRAINT "fk_assessment_assessment_questions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessment_questions" ADD CONSTRAINT "fk_assessment_assessment_questions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_teams" ADD CONSTRAINT "fk_assessment_teams_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_teams" ADD CONSTRAINT "fk_assessment_teams_leader_person_id" FOREIGN KEY ("leader_person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_teams" ADD CONSTRAINT "fk_assessment_teams_created_for_assessment_id" FOREIGN KEY ("created_for_assessment_id") REFERENCES "app"."assessment_assessments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_teams" ADD CONSTRAINT "fk_assessment_teams_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_teams" ADD CONSTRAINT "fk_assessment_teams_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_team_members" ADD CONSTRAINT "fk_assessment_team_members_team_id" FOREIGN KEY ("team_id") REFERENCES "app"."assessment_teams"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_team_members" ADD CONSTRAINT "fk_assessment_team_members_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_team_members" ADD CONSTRAINT "fk_assessment_team_members_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_team_members" ADD CONSTRAINT "fk_assessment_team_members_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessment_extensions" ADD CONSTRAINT "fk_assessment_assessment_extensions_assessment_id" FOREIGN KEY ("assessment_id") REFERENCES "app"."assessment_assessments"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_assessment_extensions" ADD CONSTRAINT "fk_assessment_assessment_extensions_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessment_extensions" ADD CONSTRAINT "fk_assessment_assessment_extensions_team_id" FOREIGN KEY ("team_id") REFERENCES "app"."assessment_teams"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessment_extensions" ADD CONSTRAINT "fk_assessment_assessment_extensions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_assessment_extensions" ADD CONSTRAINT "fk_assessment_assessment_extensions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "fk_assessment_submissions_assessment_id" FOREIGN KEY ("assessment_id") REFERENCES "app"."assessment_assessments"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "fk_assessment_submissions_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "fk_assessment_submissions_team_id" FOREIGN KEY ("team_id") REFERENCES "app"."assessment_teams"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "fk_assessment_submissions_graded_by" FOREIGN KEY ("graded_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "fk_assessment_submissions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "fk_assessment_submissions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submission_files" ADD CONSTRAINT "fk_assessment_submission_files_submission_id" FOREIGN KEY ("submission_id") REFERENCES "app"."assessment_submissions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_submission_files" ADD CONSTRAINT "fk_assessment_submission_files_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_submission_files" ADD CONSTRAINT "fk_assessment_submission_files_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submission_files" ADD CONSTRAINT "fk_assessment_submission_files_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submission_members" ADD CONSTRAINT "fk_assessment_submission_members_submission_id" FOREIGN KEY ("submission_id") REFERENCES "app"."assessment_submissions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_submission_members" ADD CONSTRAINT "fk_assessment_submission_members_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_submission_members" ADD CONSTRAINT "fk_assessment_submission_members_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_submission_members" ADD CONSTRAINT "fk_assessment_submission_members_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_attempt_answers" ADD CONSTRAINT "fk_assessment_attempt_answers_submission_id" FOREIGN KEY ("submission_id") REFERENCES "app"."assessment_submissions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_attempt_answers" ADD CONSTRAINT "fk_assessment_attempt_answers_question_id" FOREIGN KEY ("question_id") REFERENCES "app"."assessment_questions"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_attempt_answers" ADD CONSTRAINT "fk_assessment_attempt_answers_graded_by" FOREIGN KEY ("graded_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_attempt_answers" ADD CONSTRAINT "fk_assessment_attempt_answers_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_attempt_answers" ADD CONSTRAINT "fk_assessment_attempt_answers_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_criterion_scores" ADD CONSTRAINT "fk_assessment_criterion_scores_submission_id" FOREIGN KEY ("submission_id") REFERENCES "app"."assessment_submissions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_criterion_scores" ADD CONSTRAINT "fk_assessment_criterion_scores_criterion_id" FOREIGN KEY ("criterion_id") REFERENCES "app"."assessment_rubric_criteria"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_criterion_scores" ADD CONSTRAINT "fk_assessment_criterion_scores_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_criterion_scores" ADD CONSTRAINT "fk_assessment_criterion_scores_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_criterion_scores" ADD CONSTRAINT "fk_assessment_criterion_scores_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_grade_changes" ADD CONSTRAINT "fk_assessment_grade_changes_submission_id" FOREIGN KEY ("submission_id") REFERENCES "app"."assessment_submissions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."assessment_grade_changes" ADD CONSTRAINT "fk_assessment_grade_changes_changed_by" FOREIGN KEY ("changed_by") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."assessment_grade_changes" ADD CONSTRAINT "fk_assessment_grade_changes_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."assessment_grade_changes" ADD CONSTRAINT "fk_assessment_grade_changes_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_faculties" ADD CONSTRAINT "fk_academic_faculties_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_faculties" ADD CONSTRAINT "fk_academic_faculties_parent_id" FOREIGN KEY ("parent_id") REFERENCES "app"."academic_faculties"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_faculties" ADD CONSTRAINT "fk_academic_faculties_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_faculties" ADD CONSTRAINT "fk_academic_faculties_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_programs" ADD CONSTRAINT "fk_academic_programs_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_programs" ADD CONSTRAINT "fk_academic_programs_faculty_id" FOREIGN KEY ("faculty_id") REFERENCES "app"."academic_faculties"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_programs" ADD CONSTRAINT "fk_academic_programs_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_programs" ADD CONSTRAINT "fk_academic_programs_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_curricula" ADD CONSTRAINT "fk_academic_curricula_program_id" FOREIGN KEY ("program_id") REFERENCES "app"."academic_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_curricula" ADD CONSTRAINT "fk_academic_curricula_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_curricula" ADD CONSTRAINT "fk_academic_curricula_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_curriculum_courses" ADD CONSTRAINT "fk_academic_curriculum_courses_curriculum_id" FOREIGN KEY ("curriculum_id") REFERENCES "app"."academic_curricula"("id") ON DELETE CASCADE;
ALTER TABLE "app"."academic_curriculum_courses" ADD CONSTRAINT "fk_academic_curriculum_courses_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_curriculum_courses" ADD CONSTRAINT "fk_academic_curriculum_courses_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_curriculum_courses" ADD CONSTRAINT "fk_academic_curriculum_courses_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_curriculum_prerequisites" ADD CONSTRAINT "fk_academic_curriculum_prerequisites_curriculum_course_id" FOREIGN KEY ("curriculum_course_id") REFERENCES "app"."academic_curriculum_courses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."academic_curriculum_prerequisites" ADD CONSTRAINT "fk_academic_curriculum_prerequisites_prerequisite_course_id" FOREIGN KEY ("prerequisite_course_id") REFERENCES "app"."academic_curriculum_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_curriculum_prerequisites" ADD CONSTRAINT "fk_academic_curriculum_prerequisites_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_curriculum_prerequisites" ADD CONSTRAINT "fk_academic_curriculum_prerequisites_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_terms" ADD CONSTRAINT "fk_academic_terms_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_terms" ADD CONSTRAINT "fk_academic_terms_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_terms" ADD CONSTRAINT "fk_academic_terms_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "fk_academic_student_programs_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "fk_academic_student_programs_program_id" FOREIGN KEY ("program_id") REFERENCES "app"."academic_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "fk_academic_student_programs_curriculum_id" FOREIGN KEY ("curriculum_id") REFERENCES "app"."academic_curricula"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "fk_academic_student_programs_site_id" FOREIGN KEY ("site_id") REFERENCES "app"."core_organization_sites"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "fk_academic_student_programs_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "fk_academic_student_programs_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_admission_applications" ADD CONSTRAINT "fk_academic_admission_applications_program_id" FOREIGN KEY ("program_id") REFERENCES "app"."academic_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_admission_applications" ADD CONSTRAINT "fk_academic_admission_applications_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_admission_applications" ADD CONSTRAINT "fk_academic_admission_applications_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_admission_applications" ADD CONSTRAINT "fk_academic_admission_applications_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_admission_applications" ADD CONSTRAINT "fk_academic_admission_applications_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_admission_requirements" ADD CONSTRAINT "fk_academic_admission_requirements_program_id" FOREIGN KEY ("program_id") REFERENCES "app"."academic_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_admission_requirements" ADD CONSTRAINT "fk_academic_admission_requirements_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_admission_requirements" ADD CONSTRAINT "fk_academic_admission_requirements_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_application_documents" ADD CONSTRAINT "fk_academic_application_documents_application_id" FOREIGN KEY ("application_id") REFERENCES "app"."academic_admission_applications"("id") ON DELETE CASCADE;
ALTER TABLE "app"."academic_application_documents" ADD CONSTRAINT "fk_academic_application_documents_requirement_id" FOREIGN KEY ("requirement_id") REFERENCES "app"."academic_admission_requirements"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_application_documents" ADD CONSTRAINT "fk_academic_application_documents_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_application_documents" ADD CONSTRAINT "fk_academic_application_documents_reviewed_by" FOREIGN KEY ("reviewed_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_application_documents" ADD CONSTRAINT "fk_academic_application_documents_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_application_documents" ADD CONSTRAINT "fk_academic_application_documents_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_registrations" ADD CONSTRAINT "fk_academic_registrations_student_program_id" FOREIGN KEY ("student_program_id") REFERENCES "app"."academic_student_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_registrations" ADD CONSTRAINT "fk_academic_registrations_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_registrations" ADD CONSTRAINT "fk_academic_registrations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_registrations" ADD CONSTRAINT "fk_academic_registrations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_site_id" FOREIGN KEY ("site_id") REFERENCES "app"."core_organization_sites"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "fk_academic_sections_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_section_instructors" ADD CONSTRAINT "fk_academic_section_instructors_section_id" FOREIGN KEY ("section_id") REFERENCES "app"."academic_sections"("id") ON DELETE CASCADE;
ALTER TABLE "app"."academic_section_instructors" ADD CONSTRAINT "fk_academic_section_instructors_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_section_instructors" ADD CONSTRAINT "fk_academic_section_instructors_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_section_instructors" ADD CONSTRAINT "fk_academic_section_instructors_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_section_enrollments" ADD CONSTRAINT "fk_academic_section_enrollments_registration_id" FOREIGN KEY ("registration_id") REFERENCES "app"."academic_registrations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_section_enrollments" ADD CONSTRAINT "fk_academic_section_enrollments_section_id" FOREIGN KEY ("section_id") REFERENCES "app"."academic_sections"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_section_enrollments" ADD CONSTRAINT "fk_academic_section_enrollments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_section_enrollments" ADD CONSTRAINT "fk_academic_section_enrollments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_class_sessions" ADD CONSTRAINT "fk_academic_class_sessions_section_id" FOREIGN KEY ("section_id") REFERENCES "app"."academic_sections"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_class_sessions" ADD CONSTRAINT "fk_academic_class_sessions_recording_id" FOREIGN KEY ("recording_id") REFERENCES "app"."catalog_resources"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_class_sessions" ADD CONSTRAINT "fk_academic_class_sessions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_class_sessions" ADD CONSTRAINT "fk_academic_class_sessions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_attendance" ADD CONSTRAINT "fk_academic_attendance_class_session_id" FOREIGN KEY ("class_session_id") REFERENCES "app"."academic_class_sessions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."academic_attendance" ADD CONSTRAINT "fk_academic_attendance_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_attendance" ADD CONSTRAINT "fk_academic_attendance_marked_by" FOREIGN KEY ("marked_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_attendance" ADD CONSTRAINT "fk_academic_attendance_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_attendance" ADD CONSTRAINT "fk_academic_attendance_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_gradebook_items" ADD CONSTRAINT "fk_academic_gradebook_items_section_id" FOREIGN KEY ("section_id") REFERENCES "app"."academic_sections"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_gradebook_items" ADD CONSTRAINT "fk_academic_gradebook_items_assessment_id" FOREIGN KEY ("assessment_id") REFERENCES "app"."assessment_assessments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_gradebook_items" ADD CONSTRAINT "fk_academic_gradebook_items_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_gradebook_items" ADD CONSTRAINT "fk_academic_gradebook_items_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_gradebook_scores" ADD CONSTRAINT "fk_academic_gradebook_scores_item_id" FOREIGN KEY ("item_id") REFERENCES "app"."academic_gradebook_items"("id") ON DELETE CASCADE;
ALTER TABLE "app"."academic_gradebook_scores" ADD CONSTRAINT "fk_academic_gradebook_scores_section_enrollment_id" FOREIGN KEY ("section_enrollment_id") REFERENCES "app"."academic_section_enrollments"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_gradebook_scores" ADD CONSTRAINT "fk_academic_gradebook_scores_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_gradebook_scores" ADD CONSTRAINT "fk_academic_gradebook_scores_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_grade_appeals" ADD CONSTRAINT "fk_academic_grade_appeals_section_enrollment_id" FOREIGN KEY ("section_enrollment_id") REFERENCES "app"."academic_section_enrollments"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_grade_appeals" ADD CONSTRAINT "fk_academic_grade_appeals_gradebook_item_id" FOREIGN KEY ("gradebook_item_id") REFERENCES "app"."academic_gradebook_items"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_grade_appeals" ADD CONSTRAINT "fk_academic_grade_appeals_resolved_by" FOREIGN KEY ("resolved_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_grade_appeals" ADD CONSTRAINT "fk_academic_grade_appeals_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_grade_appeals" ADD CONSTRAINT "fk_academic_grade_appeals_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_credit_recognitions" ADD CONSTRAINT "fk_academic_credit_recognitions_student_program_id" FOREIGN KEY ("student_program_id") REFERENCES "app"."academic_student_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_credit_recognitions" ADD CONSTRAINT "fk_academic_credit_recognitions_curriculum_course_id" FOREIGN KEY ("curriculum_course_id") REFERENCES "app"."academic_curriculum_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_credit_recognitions" ADD CONSTRAINT "fk_academic_credit_recognitions_approved_by" FOREIGN KEY ("approved_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_credit_recognitions" ADD CONSTRAINT "fk_academic_credit_recognitions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_credit_recognitions" ADD CONSTRAINT "fk_academic_credit_recognitions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_academic_records" ADD CONSTRAINT "fk_academic_academic_records_student_program_id" FOREIGN KEY ("student_program_id") REFERENCES "app"."academic_student_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_academic_records" ADD CONSTRAINT "fk_academic_academic_records_section_enrollment_id" FOREIGN KEY ("section_enrollment_id") REFERENCES "app"."academic_section_enrollments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_academic_records" ADD CONSTRAINT "fk_academic_academic_records_curriculum_course_id" FOREIGN KEY ("curriculum_course_id") REFERENCES "app"."academic_curriculum_courses"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_academic_records" ADD CONSTRAINT "fk_academic_academic_records_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_academic_records" ADD CONSTRAINT "fk_academic_academic_records_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_academic_records" ADD CONSTRAINT "fk_academic_academic_records_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_degree_applications" ADD CONSTRAINT "fk_academic_degree_applications_student_program_id" FOREIGN KEY ("student_program_id") REFERENCES "app"."academic_student_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."academic_degree_applications" ADD CONSTRAINT "fk_academic_degree_applications_document_id" FOREIGN KEY ("document_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_degree_applications" ADD CONSTRAINT "fk_academic_degree_applications_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."academic_degree_applications" ADD CONSTRAINT "fk_academic_degree_applications_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_communities" ADD CONSTRAINT "fk_social_communities_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_communities" ADD CONSTRAINT "fk_social_communities_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_communities" ADD CONSTRAINT "fk_social_communities_cover_asset_id" FOREIGN KEY ("cover_asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_communities" ADD CONSTRAINT "fk_social_communities_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_communities" ADD CONSTRAINT "fk_social_communities_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_members" ADD CONSTRAINT "fk_social_community_members_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_community_members" ADD CONSTRAINT "fk_social_community_members_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_community_members" ADD CONSTRAINT "fk_social_community_members_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_members" ADD CONSTRAINT "fk_social_community_members_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_join_requests" ADD CONSTRAINT "fk_social_community_join_requests_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_community_join_requests" ADD CONSTRAINT "fk_social_community_join_requests_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_community_join_requests" ADD CONSTRAINT "fk_social_community_join_requests_reviewed_by" FOREIGN KEY ("reviewed_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_join_requests" ADD CONSTRAINT "fk_social_community_join_requests_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_join_requests" ADD CONSTRAINT "fk_social_community_join_requests_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_rules" ADD CONSTRAINT "fk_social_community_rules_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_community_rules" ADD CONSTRAINT "fk_social_community_rules_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_community_rules" ADD CONSTRAINT "fk_social_community_rules_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_groups" ADD CONSTRAINT "fk_social_groups_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_groups" ADD CONSTRAINT "fk_social_groups_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_groups" ADD CONSTRAINT "fk_social_groups_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_group_members" ADD CONSTRAINT "fk_social_group_members_group_id" FOREIGN KEY ("group_id") REFERENCES "app"."social_groups"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_group_members" ADD CONSTRAINT "fk_social_group_members_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_group_members" ADD CONSTRAINT "fk_social_group_members_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_group_members" ADD CONSTRAINT "fk_social_group_members_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_channels" ADD CONSTRAINT "fk_social_channels_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_channels" ADD CONSTRAINT "fk_social_channels_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_channels" ADD CONSTRAINT "fk_social_channels_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_channel_subscribers" ADD CONSTRAINT "fk_social_channel_subscribers_channel_id" FOREIGN KEY ("channel_id") REFERENCES "app"."social_channels"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_channel_subscribers" ADD CONSTRAINT "fk_social_channel_subscribers_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_channel_subscribers" ADD CONSTRAINT "fk_social_channel_subscribers_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_channel_subscribers" ADD CONSTRAINT "fk_social_channel_subscribers_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_posts" ADD CONSTRAINT "fk_social_posts_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_posts" ADD CONSTRAINT "fk_social_posts_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_posts" ADD CONSTRAINT "fk_social_posts_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_posts" ADD CONSTRAINT "fk_social_posts_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_posts" ADD CONSTRAINT "fk_social_posts_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_posts" ADD CONSTRAINT "fk_social_posts_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_attachments" ADD CONSTRAINT "fk_social_post_attachments_post_id" FOREIGN KEY ("post_id") REFERENCES "app"."social_posts"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_post_attachments" ADD CONSTRAINT "fk_social_post_attachments_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_post_attachments" ADD CONSTRAINT "fk_social_post_attachments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_attachments" ADD CONSTRAINT "fk_social_post_attachments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_comments" ADD CONSTRAINT "fk_social_post_comments_post_id" FOREIGN KEY ("post_id") REFERENCES "app"."social_posts"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_post_comments" ADD CONSTRAINT "fk_social_post_comments_parent_id" FOREIGN KEY ("parent_id") REFERENCES "app"."social_post_comments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_comments" ADD CONSTRAINT "fk_social_post_comments_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_post_comments" ADD CONSTRAINT "fk_social_post_comments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_comments" ADD CONSTRAINT "fk_social_post_comments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_reactions" ADD CONSTRAINT "fk_social_post_reactions_post_id" FOREIGN KEY ("post_id") REFERENCES "app"."social_posts"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_post_reactions" ADD CONSTRAINT "fk_social_post_reactions_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_post_reactions" ADD CONSTRAINT "fk_social_post_reactions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_post_reactions" ADD CONSTRAINT "fk_social_post_reactions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_questions" ADD CONSTRAINT "fk_social_qa_questions_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_qa_questions" ADD CONSTRAINT "fk_social_qa_questions_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_qa_questions" ADD CONSTRAINT "fk_social_qa_questions_accepted_answer_id" FOREIGN KEY ("accepted_answer_id") REFERENCES "app"."social_qa_answers"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_questions" ADD CONSTRAINT "fk_social_qa_questions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_questions" ADD CONSTRAINT "fk_social_qa_questions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_answers" ADD CONSTRAINT "fk_social_qa_answers_question_id" FOREIGN KEY ("question_id") REFERENCES "app"."social_qa_questions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_qa_answers" ADD CONSTRAINT "fk_social_qa_answers_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_qa_answers" ADD CONSTRAINT "fk_social_qa_answers_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_answers" ADD CONSTRAINT "fk_social_qa_answers_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_votes" ADD CONSTRAINT "fk_social_qa_votes_answer_id" FOREIGN KEY ("answer_id") REFERENCES "app"."social_qa_answers"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_qa_votes" ADD CONSTRAINT "fk_social_qa_votes_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_qa_votes" ADD CONSTRAINT "fk_social_qa_votes_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_qa_votes" ADD CONSTRAINT "fk_social_qa_votes_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_reputation_ledger" ADD CONSTRAINT "fk_social_reputation_ledger_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_reputation_ledger" ADD CONSTRAINT "fk_social_reputation_ledger_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_reputation_ledger" ADD CONSTRAINT "fk_social_reputation_ledger_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_reputation_ledger" ADD CONSTRAINT "fk_social_reputation_ledger_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_course_forums" ADD CONSTRAINT "fk_social_course_forums_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_course_forums" ADD CONSTRAINT "fk_social_course_forums_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_course_forums" ADD CONSTRAINT "fk_social_course_forums_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_forum_threads" ADD CONSTRAINT "fk_social_forum_threads_forum_id" FOREIGN KEY ("forum_id") REFERENCES "app"."social_course_forums"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_forum_threads" ADD CONSTRAINT "fk_social_forum_threads_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_forum_threads" ADD CONSTRAINT "fk_social_forum_threads_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_forum_threads" ADD CONSTRAINT "fk_social_forum_threads_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_forum_replies" ADD CONSTRAINT "fk_social_forum_replies_thread_id" FOREIGN KEY ("thread_id") REFERENCES "app"."social_forum_threads"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_forum_replies" ADD CONSTRAINT "fk_social_forum_replies_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_forum_replies" ADD CONSTRAINT "fk_social_forum_replies_parent_id" FOREIGN KEY ("parent_id") REFERENCES "app"."social_forum_replies"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_forum_replies" ADD CONSTRAINT "fk_social_forum_replies_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_forum_replies" ADD CONSTRAINT "fk_social_forum_replies_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_rooms" ADD CONSTRAINT "fk_social_chat_rooms_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_rooms" ADD CONSTRAINT "fk_social_chat_rooms_group_id" FOREIGN KEY ("group_id") REFERENCES "app"."social_groups"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_rooms" ADD CONSTRAINT "fk_social_chat_rooms_channel_id" FOREIGN KEY ("channel_id") REFERENCES "app"."social_channels"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_rooms" ADD CONSTRAINT "fk_social_chat_rooms_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_rooms" ADD CONSTRAINT "fk_social_chat_rooms_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_members" ADD CONSTRAINT "fk_social_chat_members_room_id" FOREIGN KEY ("room_id") REFERENCES "app"."social_chat_rooms"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_chat_members" ADD CONSTRAINT "fk_social_chat_members_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_chat_members" ADD CONSTRAINT "fk_social_chat_members_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_members" ADD CONSTRAINT "fk_social_chat_members_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "fk_social_chat_messages_room_id" FOREIGN KEY ("room_id") REFERENCES "app"."social_chat_rooms"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "fk_social_chat_messages_sender_id" FOREIGN KEY ("sender_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "fk_social_chat_messages_reply_to_id" FOREIGN KEY ("reply_to_id") REFERENCES "app"."social_chat_messages"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "fk_social_chat_messages_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "fk_social_chat_messages_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "fk_social_chat_messages_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_moderation_reports" ADD CONSTRAINT "fk_social_moderation_reports_reporter_id" FOREIGN KEY ("reporter_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_moderation_reports" ADD CONSTRAINT "fk_social_moderation_reports_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_moderation_reports" ADD CONSTRAINT "fk_social_moderation_reports_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_moderation_reports" ADD CONSTRAINT "fk_social_moderation_reports_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_moderation_actions" ADD CONSTRAINT "fk_social_moderation_actions_report_id" FOREIGN KEY ("report_id") REFERENCES "app"."social_moderation_reports"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_moderation_actions" ADD CONSTRAINT "fk_social_moderation_actions_moderator_id" FOREIGN KEY ("moderator_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_moderation_actions" ADD CONSTRAINT "fk_social_moderation_actions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_moderation_actions" ADD CONSTRAINT "fk_social_moderation_actions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_bot_agents" ADD CONSTRAINT "fk_social_bot_agents_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_bot_agents" ADD CONSTRAINT "fk_social_bot_agents_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_bot_agents" ADD CONSTRAINT "fk_social_bot_agents_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_bot_agents" ADD CONSTRAINT "fk_social_bot_agents_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_bot_runs" ADD CONSTRAINT "fk_social_bot_runs_agent_id" FOREIGN KEY ("agent_id") REFERENCES "app"."social_bot_agents"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_bot_runs" ADD CONSTRAINT "fk_social_bot_runs_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_bot_runs" ADD CONSTRAINT "fk_social_bot_runs_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_saved_lists" ADD CONSTRAINT "fk_social_saved_lists_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."social_saved_lists" ADD CONSTRAINT "fk_social_saved_lists_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_saved_lists" ADD CONSTRAINT "fk_social_saved_lists_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_saved_list_items" ADD CONSTRAINT "fk_social_saved_list_items_list_id" FOREIGN KEY ("list_id") REFERENCES "app"."social_saved_lists"("id") ON DELETE CASCADE;
ALTER TABLE "app"."social_saved_list_items" ADD CONSTRAINT "fk_social_saved_list_items_community_id" FOREIGN KEY ("community_id") REFERENCES "app"."social_communities"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_saved_list_items" ADD CONSTRAINT "fk_social_saved_list_items_room_id" FOREIGN KEY ("room_id") REFERENCES "app"."social_chat_rooms"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_saved_list_items" ADD CONSTRAINT "fk_social_saved_list_items_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."social_saved_list_items" ADD CONSTRAINT "fk_social_saved_list_items_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendars" ADD CONSTRAINT "fk_calendar_calendars_owner_person_id" FOREIGN KEY ("owner_person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendars" ADD CONSTRAINT "fk_calendar_calendars_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendars" ADD CONSTRAINT "fk_calendar_calendars_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendars" ADD CONSTRAINT "fk_calendar_calendars_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendars" ADD CONSTRAINT "fk_calendar_calendars_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_calendar_id" FOREIGN KEY ("calendar_id") REFERENCES "app"."calendar_calendars"("id") ON DELETE CASCADE;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_section_id" FOREIGN KEY ("section_id") REFERENCES "app"."academic_sections"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_assessment_id" FOREIGN KEY ("assessment_id") REFERENCES "app"."assessment_assessments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_created_for_person_id" FOREIGN KEY ("created_for_person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "fk_calendar_events_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_event_recurrences" ADD CONSTRAINT "fk_calendar_event_recurrences_event_id" FOREIGN KEY ("event_id") REFERENCES "app"."calendar_events"("id") ON DELETE CASCADE;
ALTER TABLE "app"."calendar_event_recurrences" ADD CONSTRAINT "fk_calendar_event_recurrences_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_event_recurrences" ADD CONSTRAINT "fk_calendar_event_recurrences_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_event_attendees" ADD CONSTRAINT "fk_calendar_event_attendees_event_id" FOREIGN KEY ("event_id") REFERENCES "app"."calendar_events"("id") ON DELETE CASCADE;
ALTER TABLE "app"."calendar_event_attendees" ADD CONSTRAINT "fk_calendar_event_attendees_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."calendar_event_attendees" ADD CONSTRAINT "fk_calendar_event_attendees_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_event_attendees" ADD CONSTRAINT "fk_calendar_event_attendees_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_reminders" ADD CONSTRAINT "fk_calendar_reminders_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."calendar_reminders" ADD CONSTRAINT "fk_calendar_reminders_event_id" FOREIGN KEY ("event_id") REFERENCES "app"."calendar_events"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_reminders" ADD CONSTRAINT "fk_calendar_reminders_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_reminders" ADD CONSTRAINT "fk_calendar_reminders_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendar_subscriptions" ADD CONSTRAINT "fk_calendar_calendar_subscriptions_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."calendar_calendar_subscriptions" ADD CONSTRAINT "fk_calendar_calendar_subscriptions_calendar_id" FOREIGN KEY ("calendar_id") REFERENCES "app"."calendar_calendars"("id") ON DELETE CASCADE;
ALTER TABLE "app"."calendar_calendar_subscriptions" ADD CONSTRAINT "fk_calendar_calendar_subscriptions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."calendar_calendar_subscriptions" ADD CONSTRAINT "fk_calendar_calendar_subscriptions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notifications" ADD CONSTRAINT "fk_communication_notifications_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."communication_notifications" ADD CONSTRAINT "fk_communication_notifications_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notifications" ADD CONSTRAINT "fk_communication_notifications_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notifications" ADD CONSTRAINT "fk_communication_notifications_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notification_preferences" ADD CONSTRAINT "fk_communication_notification_preferences_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."communication_notification_preferences" ADD CONSTRAINT "fk_communication_notification_preferences_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notification_preferences" ADD CONSTRAINT "fk_communication_notification_preferences_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notification_preferences" ADD CONSTRAINT "fk_communication_notification_preferences_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notification_deliveries" ADD CONSTRAINT "fk_communication_notification_deliveries_notification_id" FOREIGN KEY ("notification_id") REFERENCES "app"."communication_notifications"("id") ON DELETE CASCADE;
ALTER TABLE "app"."communication_notification_deliveries" ADD CONSTRAINT "fk_communication_notification_deliveries_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_notification_deliveries" ADD CONSTRAINT "fk_communication_notification_deliveries_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_conversations" ADD CONSTRAINT "fk_communication_ai_conversations_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."communication_ai_conversations" ADD CONSTRAINT "fk_communication_ai_conversations_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_conversations" ADD CONSTRAINT "fk_communication_ai_conversations_cohort_id" FOREIGN KEY ("cohort_id") REFERENCES "app"."learning_cohorts"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_conversations" ADD CONSTRAINT "fk_communication_ai_conversations_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_conversations" ADD CONSTRAINT "fk_communication_ai_conversations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_conversations" ADD CONSTRAINT "fk_communication_ai_conversations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_messages" ADD CONSTRAINT "fk_communication_ai_messages_conversation_id" FOREIGN KEY ("conversation_id") REFERENCES "app"."communication_ai_conversations"("id") ON DELETE CASCADE;
ALTER TABLE "app"."communication_ai_messages" ADD CONSTRAINT "fk_communication_ai_messages_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_messages" ADD CONSTRAINT "fk_communication_ai_messages_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_usage" ADD CONSTRAINT "fk_communication_ai_usage_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."communication_ai_usage" ADD CONSTRAINT "fk_communication_ai_usage_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_usage" ADD CONSTRAINT "fk_communication_ai_usage_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."communication_ai_usage" ADD CONSTRAINT "fk_communication_ai_usage_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_2d" ADD CONSTRAINT "fk_content_interactive_2d_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_interactive_2d" ADD CONSTRAINT "fk_content_interactive_2d_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_2d" ADD CONSTRAINT "fk_content_interactive_2d_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_2d" ADD CONSTRAINT "fk_content_interactive_2d_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_hotspots" ADD CONSTRAINT "fk_content_interactive_hotspots_scene_id" FOREIGN KEY ("scene_id") REFERENCES "app"."content_interactive_2d"("id") ON DELETE CASCADE;
ALTER TABLE "app"."content_interactive_hotspots" ADD CONSTRAINT "fk_content_interactive_hotspots_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_hotspots" ADD CONSTRAINT "fk_content_interactive_hotspots_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_hotspots" ADD CONSTRAINT "fk_content_interactive_hotspots_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_interactive_hotspots" ADD CONSTRAINT "fk_content_interactive_hotspots_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_models_3d" ADD CONSTRAINT "fk_content_models_3d_resource_id" FOREIGN KEY ("resource_id") REFERENCES "app"."catalog_resources"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_models_3d" ADD CONSTRAINT "fk_content_models_3d_model_asset_id" FOREIGN KEY ("model_asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_models_3d" ADD CONSTRAINT "fk_content_models_3d_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_models_3d" ADD CONSTRAINT "fk_content_models_3d_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_model_annotations" ADD CONSTRAINT "fk_content_model_annotations_model_id" FOREIGN KEY ("model_id") REFERENCES "app"."content_models_3d"("id") ON DELETE CASCADE;
ALTER TABLE "app"."content_model_annotations" ADD CONSTRAINT "fk_content_model_annotations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_model_annotations" ADD CONSTRAINT "fk_content_model_annotations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulators" ADD CONSTRAINT "fk_content_simulators_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulators" ADD CONSTRAINT "fk_content_simulators_owner_id" FOREIGN KEY ("owner_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_simulators" ADD CONSTRAINT "fk_content_simulators_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulators" ADD CONSTRAINT "fk_content_simulators_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulator_parameters" ADD CONSTRAINT "fk_content_simulator_parameters_simulator_id" FOREIGN KEY ("simulator_id") REFERENCES "app"."content_simulators"("id") ON DELETE CASCADE;
ALTER TABLE "app"."content_simulator_parameters" ADD CONSTRAINT "fk_content_simulator_parameters_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulator_parameters" ADD CONSTRAINT "fk_content_simulator_parameters_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulator_experiments" ADD CONSTRAINT "fk_content_simulator_experiments_simulator_id" FOREIGN KEY ("simulator_id") REFERENCES "app"."content_simulators"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_simulator_experiments" ADD CONSTRAINT "fk_content_simulator_experiments_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulator_experiments" ADD CONSTRAINT "fk_content_simulator_experiments_lesson_id" FOREIGN KEY ("lesson_id") REFERENCES "app"."catalog_lessons"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulator_experiments" ADD CONSTRAINT "fk_content_simulator_experiments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulator_experiments" ADD CONSTRAINT "fk_content_simulator_experiments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulation_runs" ADD CONSTRAINT "fk_content_simulation_runs_experiment_id" FOREIGN KEY ("experiment_id") REFERENCES "app"."content_simulator_experiments"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_simulation_runs" ADD CONSTRAINT "fk_content_simulation_runs_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."content_simulation_runs" ADD CONSTRAINT "fk_content_simulation_runs_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."content_simulation_runs" ADD CONSTRAINT "fk_content_simulation_runs_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_plans" ADD CONSTRAINT "fk_platform_plans_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_plans" ADD CONSTRAINT "fk_platform_plans_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_features" ADD CONSTRAINT "fk_platform_features_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_features" ADD CONSTRAINT "fk_platform_features_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_plan_entitlements" ADD CONSTRAINT "fk_platform_plan_entitlements_plan_id" FOREIGN KEY ("plan_id") REFERENCES "app"."platform_plans"("id") ON DELETE CASCADE;
ALTER TABLE "app"."platform_plan_entitlements" ADD CONSTRAINT "fk_platform_plan_entitlements_feature_id" FOREIGN KEY ("feature_id") REFERENCES "app"."platform_features"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_plan_entitlements" ADD CONSTRAINT "fk_platform_plan_entitlements_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_plan_entitlements" ADD CONSTRAINT "fk_platform_plan_entitlements_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_plan_prices" ADD CONSTRAINT "fk_platform_plan_prices_plan_id" FOREIGN KEY ("plan_id") REFERENCES "app"."platform_plans"("id") ON DELETE CASCADE;
ALTER TABLE "app"."platform_plan_prices" ADD CONSTRAINT "fk_platform_plan_prices_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_plan_prices" ADD CONSTRAINT "fk_platform_plan_prices_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_subscriptions" ADD CONSTRAINT "fk_platform_subscriptions_plan_id" FOREIGN KEY ("plan_id") REFERENCES "app"."platform_plans"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_subscriptions" ADD CONSTRAINT "fk_platform_subscriptions_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_subscriptions" ADD CONSTRAINT "fk_platform_subscriptions_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_subscriptions" ADD CONSTRAINT "fk_platform_subscriptions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_subscriptions" ADD CONSTRAINT "fk_platform_subscriptions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_subscription_usage" ADD CONSTRAINT "fk_platform_subscription_usage_subscription_id" FOREIGN KEY ("subscription_id") REFERENCES "app"."platform_subscriptions"("id") ON DELETE CASCADE;
ALTER TABLE "app"."platform_subscription_usage" ADD CONSTRAINT "fk_platform_subscription_usage_feature_id" FOREIGN KEY ("feature_id") REFERENCES "app"."platform_features"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_subscription_usage" ADD CONSTRAINT "fk_platform_subscription_usage_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_subscription_usage" ADD CONSTRAINT "fk_platform_subscription_usage_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_checkout_orders" ADD CONSTRAINT "fk_platform_checkout_orders_subscription_id" FOREIGN KEY ("subscription_id") REFERENCES "app"."platform_subscriptions"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_checkout_orders" ADD CONSTRAINT "fk_platform_checkout_orders_buyer_person_id" FOREIGN KEY ("buyer_person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_checkout_orders" ADD CONSTRAINT "fk_platform_checkout_orders_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_checkout_orders" ADD CONSTRAINT "fk_platform_checkout_orders_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_checkout_orders" ADD CONSTRAINT "fk_platform_checkout_orders_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_platform_payments" ADD CONSTRAINT "fk_platform_platform_payments_order_id" FOREIGN KEY ("order_id") REFERENCES "app"."platform_checkout_orders"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_platform_payments" ADD CONSTRAINT "fk_platform_platform_payments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_platform_payments" ADD CONSTRAINT "fk_platform_platform_payments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_campaigns" ADD CONSTRAINT "fk_platform_ad_campaigns_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_campaigns" ADD CONSTRAINT "fk_platform_ad_campaigns_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_creatives" ADD CONSTRAINT "fk_platform_ad_creatives_campaign_id" FOREIGN KEY ("campaign_id") REFERENCES "app"."platform_ad_campaigns"("id") ON DELETE CASCADE;
ALTER TABLE "app"."platform_ad_creatives" ADD CONSTRAINT "fk_platform_ad_creatives_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_creatives" ADD CONSTRAINT "fk_platform_ad_creatives_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_creatives" ADD CONSTRAINT "fk_platform_ad_creatives_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_placements" ADD CONSTRAINT "fk_platform_ad_placements_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_placements" ADD CONSTRAINT "fk_platform_ad_placements_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_events" ADD CONSTRAINT "fk_platform_ad_events_campaign_id" FOREIGN KEY ("campaign_id") REFERENCES "app"."platform_ad_campaigns"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_ad_events" ADD CONSTRAINT "fk_platform_ad_events_creative_id" FOREIGN KEY ("creative_id") REFERENCES "app"."platform_ad_creatives"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_ad_events" ADD CONSTRAINT "fk_platform_ad_events_placement_id" FOREIGN KEY ("placement_id") REFERENCES "app"."platform_ad_placements"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."platform_ad_events" ADD CONSTRAINT "fk_platform_ad_events_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_events" ADD CONSTRAINT "fk_platform_ad_events_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."platform_ad_events" ADD CONSTRAINT "fk_platform_ad_events_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "fk_finance_tuition_schedules_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "fk_finance_tuition_schedules_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "fk_finance_tuition_schedules_program_id" FOREIGN KEY ("program_id") REFERENCES "app"."academic_programs"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "fk_finance_tuition_schedules_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "fk_finance_tuition_schedules_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_accounts" ADD CONSTRAINT "fk_finance_student_accounts_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_student_accounts" ADD CONSTRAINT "fk_finance_student_accounts_student_program_id" FOREIGN KEY ("student_program_id") REFERENCES "app"."academic_student_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_student_accounts" ADD CONSTRAINT "fk_finance_student_accounts_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_accounts" ADD CONSTRAINT "fk_finance_student_accounts_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_charges" ADD CONSTRAINT "fk_finance_student_charges_account_id" FOREIGN KEY ("account_id") REFERENCES "app"."finance_student_accounts"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_student_charges" ADD CONSTRAINT "fk_finance_student_charges_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_charges" ADD CONSTRAINT "fk_finance_student_charges_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_charges" ADD CONSTRAINT "fk_finance_student_charges_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_installments" ADD CONSTRAINT "fk_finance_installments_charge_id" FOREIGN KEY ("charge_id") REFERENCES "app"."finance_student_charges"("id") ON DELETE CASCADE;
ALTER TABLE "app"."finance_installments" ADD CONSTRAINT "fk_finance_installments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_installments" ADD CONSTRAINT "fk_finance_installments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_payments" ADD CONSTRAINT "fk_finance_student_payments_account_id" FOREIGN KEY ("account_id") REFERENCES "app"."finance_student_accounts"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_student_payments" ADD CONSTRAINT "fk_finance_student_payments_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_student_payments" ADD CONSTRAINT "fk_finance_student_payments_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_payment_allocations" ADD CONSTRAINT "fk_finance_payment_allocations_payment_id" FOREIGN KEY ("payment_id") REFERENCES "app"."finance_student_payments"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_payment_allocations" ADD CONSTRAINT "fk_finance_payment_allocations_installment_id" FOREIGN KEY ("installment_id") REFERENCES "app"."finance_installments"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_payment_allocations" ADD CONSTRAINT "fk_finance_payment_allocations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_payment_allocations" ADD CONSTRAINT "fk_finance_payment_allocations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarships" ADD CONSTRAINT "fk_finance_scholarships_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_scholarships" ADD CONSTRAINT "fk_finance_scholarships_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarships" ADD CONSTRAINT "fk_finance_scholarships_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarship_applications" ADD CONSTRAINT "fk_finance_scholarship_applications_scholarship_id" FOREIGN KEY ("scholarship_id") REFERENCES "app"."finance_scholarships"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_scholarship_applications" ADD CONSTRAINT "fk_finance_scholarship_applications_student_program_id" FOREIGN KEY ("student_program_id") REFERENCES "app"."academic_student_programs"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_scholarship_applications" ADD CONSTRAINT "fk_finance_scholarship_applications_reviewer_id" FOREIGN KEY ("reviewer_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarship_applications" ADD CONSTRAINT "fk_finance_scholarship_applications_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarship_applications" ADD CONSTRAINT "fk_finance_scholarship_applications_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarship_awards" ADD CONSTRAINT "fk_finance_scholarship_awards_application_id" FOREIGN KEY ("application_id") REFERENCES "app"."finance_scholarship_applications"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_scholarship_awards" ADD CONSTRAINT "fk_finance_scholarship_awards_term_id" FOREIGN KEY ("term_id") REFERENCES "app"."academic_terms"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_scholarship_awards" ADD CONSTRAINT "fk_finance_scholarship_awards_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_scholarship_awards" ADD CONSTRAINT "fk_finance_scholarship_awards_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_financial_documents" ADD CONSTRAINT "fk_finance_financial_documents_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."finance_financial_documents" ADD CONSTRAINT "fk_finance_financial_documents_payment_id" FOREIGN KEY ("payment_id") REFERENCES "app"."finance_student_payments"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_financial_documents" ADD CONSTRAINT "fk_finance_financial_documents_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_financial_documents" ADD CONSTRAINT "fk_finance_financial_documents_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."finance_financial_documents" ADD CONSTRAINT "fk_finance_financial_documents_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_procedures" ADD CONSTRAINT "fk_services_procedures_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_procedures" ADD CONSTRAINT "fk_services_procedures_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_procedures" ADD CONSTRAINT "fk_services_procedures_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_procedure_steps" ADD CONSTRAINT "fk_services_procedure_steps_procedure_id" FOREIGN KEY ("procedure_id") REFERENCES "app"."services_procedures"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_procedure_steps" ADD CONSTRAINT "fk_services_procedure_steps_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_procedure_steps" ADD CONSTRAINT "fk_services_procedure_steps_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_procedure_fields" ADD CONSTRAINT "fk_services_procedure_fields_procedure_id" FOREIGN KEY ("procedure_id") REFERENCES "app"."services_procedures"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_procedure_fields" ADD CONSTRAINT "fk_services_procedure_fields_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_procedure_fields" ADD CONSTRAINT "fk_services_procedure_fields_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "fk_services_requests_procedure_id" FOREIGN KEY ("procedure_id") REFERENCES "app"."services_procedures"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "fk_services_requests_requester_id" FOREIGN KEY ("requester_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "fk_services_requests_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "fk_services_requests_current_step_id" FOREIGN KEY ("current_step_id") REFERENCES "app"."services_procedure_steps"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "fk_services_requests_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "fk_services_requests_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_request_files" ADD CONSTRAINT "fk_services_request_files_request_id" FOREIGN KEY ("request_id") REFERENCES "app"."services_requests"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_request_files" ADD CONSTRAINT "fk_services_request_files_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_request_files" ADD CONSTRAINT "fk_services_request_files_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_request_files" ADD CONSTRAINT "fk_services_request_files_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_request_transitions" ADD CONSTRAINT "fk_services_request_transitions_request_id" FOREIGN KEY ("request_id") REFERENCES "app"."services_requests"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_request_transitions" ADD CONSTRAINT "fk_services_request_transitions_step_id" FOREIGN KEY ("step_id") REFERENCES "app"."services_procedure_steps"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_request_transitions" ADD CONSTRAINT "fk_services_request_transitions_actor_id" FOREIGN KEY ("actor_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_request_transitions" ADD CONSTRAINT "fk_services_request_transitions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_request_transitions" ADD CONSTRAINT "fk_services_request_transitions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_service_offerings" ADD CONSTRAINT "fk_services_service_offerings_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_service_offerings" ADD CONSTRAINT "fk_services_service_offerings_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_service_offerings" ADD CONSTRAINT "fk_services_service_offerings_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_service_memberships" ADD CONSTRAINT "fk_services_service_memberships_offering_id" FOREIGN KEY ("offering_id") REFERENCES "app"."services_service_offerings"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_service_memberships" ADD CONSTRAINT "fk_services_service_memberships_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_service_memberships" ADD CONSTRAINT "fk_services_service_memberships_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_service_memberships" ADD CONSTRAINT "fk_services_service_memberships_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_physical_assets" ADD CONSTRAINT "fk_services_physical_assets_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_physical_assets" ADD CONSTRAINT "fk_services_physical_assets_site_id" FOREIGN KEY ("site_id") REFERENCES "app"."core_organization_sites"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_physical_assets" ADD CONSTRAINT "fk_services_physical_assets_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_physical_assets" ADD CONSTRAINT "fk_services_physical_assets_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "fk_services_asset_reservations_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."services_physical_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "fk_services_asset_reservations_requested_by" FOREIGN KEY ("requested_by") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "fk_services_asset_reservations_approved_by" FOREIGN KEY ("approved_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "fk_services_asset_reservations_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "fk_services_asset_reservations_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_reservation_attendees" ADD CONSTRAINT "fk_services_reservation_attendees_reservation_id" FOREIGN KEY ("reservation_id") REFERENCES "app"."services_asset_reservations"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_reservation_attendees" ADD CONSTRAINT "fk_services_reservation_attendees_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_reservation_attendees" ADD CONSTRAINT "fk_services_reservation_attendees_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_reservation_attendees" ADD CONSTRAINT "fk_services_reservation_attendees_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_asset_loans" ADD CONSTRAINT "fk_services_asset_loans_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."services_physical_assets"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_asset_loans" ADD CONSTRAINT "fk_services_asset_loans_person_id" FOREIGN KEY ("person_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_asset_loans" ADD CONSTRAINT "fk_services_asset_loans_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_asset_loans" ADD CONSTRAINT "fk_services_asset_loans_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_surveys" ADD CONSTRAINT "fk_services_surveys_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_surveys" ADD CONSTRAINT "fk_services_surveys_course_id" FOREIGN KEY ("course_id") REFERENCES "app"."catalog_courses"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_surveys" ADD CONSTRAINT "fk_services_surveys_section_id" FOREIGN KEY ("section_id") REFERENCES "app"."academic_sections"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_surveys" ADD CONSTRAINT "fk_services_surveys_teacher_id" FOREIGN KEY ("teacher_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_surveys" ADD CONSTRAINT "fk_services_surveys_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_surveys" ADD CONSTRAINT "fk_services_surveys_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_questions" ADD CONSTRAINT "fk_services_survey_questions_survey_id" FOREIGN KEY ("survey_id") REFERENCES "app"."services_surveys"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_survey_questions" ADD CONSTRAINT "fk_services_survey_questions_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_questions" ADD CONSTRAINT "fk_services_survey_questions_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_responses" ADD CONSTRAINT "fk_services_survey_responses_survey_id" FOREIGN KEY ("survey_id") REFERENCES "app"."services_surveys"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_survey_responses" ADD CONSTRAINT "fk_services_survey_responses_respondent_id" FOREIGN KEY ("respondent_id") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_responses" ADD CONSTRAINT "fk_services_survey_responses_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_responses" ADD CONSTRAINT "fk_services_survey_responses_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_answers" ADD CONSTRAINT "fk_services_survey_answers_response_id" FOREIGN KEY ("response_id") REFERENCES "app"."services_survey_responses"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_survey_answers" ADD CONSTRAINT "fk_services_survey_answers_question_id" FOREIGN KEY ("question_id") REFERENCES "app"."services_survey_questions"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_survey_answers" ADD CONSTRAINT "fk_services_survey_answers_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_survey_answers" ADD CONSTRAINT "fk_services_survey_answers_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_tickets" ADD CONSTRAINT "fk_services_support_tickets_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_tickets" ADD CONSTRAINT "fk_services_support_tickets_requester_id" FOREIGN KEY ("requester_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_support_tickets" ADD CONSTRAINT "fk_services_support_tickets_assigned_to" FOREIGN KEY ("assigned_to") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_tickets" ADD CONSTRAINT "fk_services_support_tickets_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_tickets" ADD CONSTRAINT "fk_services_support_tickets_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_messages" ADD CONSTRAINT "fk_services_support_messages_ticket_id" FOREIGN KEY ("ticket_id") REFERENCES "app"."services_support_tickets"("id") ON DELETE CASCADE;
ALTER TABLE "app"."services_support_messages" ADD CONSTRAINT "fk_services_support_messages_author_id" FOREIGN KEY ("author_id") REFERENCES "app"."core_people"("id") ON DELETE RESTRICT;
ALTER TABLE "app"."services_support_messages" ADD CONSTRAINT "fk_services_support_messages_asset_id" FOREIGN KEY ("asset_id") REFERENCES "app"."catalog_media_assets"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_messages" ADD CONSTRAINT "fk_services_support_messages_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_support_messages" ADD CONSTRAINT "fk_services_support_messages_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_job_postings" ADD CONSTRAINT "fk_services_job_postings_organization_id" FOREIGN KEY ("organization_id") REFERENCES "app"."core_organizations"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_job_postings" ADD CONSTRAINT "fk_services_job_postings_created_by" FOREIGN KEY ("created_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."services_job_postings" ADD CONSTRAINT "fk_services_job_postings_updated_by" FOREIGN KEY ("updated_by") REFERENCES "app"."core_people"("id") ON DELETE SET NULL;
ALTER TABLE "app"."core_countries" ADD CONSTRAINT "uq_core_countries_iso3" UNIQUE ("iso3");
ALTER TABLE "app"."core_regions" ADD CONSTRAINT "uq_core_regions_country_id_code" UNIQUE ("country_id", "code");
ALTER TABLE "app"."core_provinces" ADD CONSTRAINT "uq_core_provinces_region_id_code" UNIQUE ("region_id", "code");
ALTER TABLE "app"."core_districts" ADD CONSTRAINT "uq_core_districts_province_id_code" UNIQUE ("province_id", "code");
ALTER TABLE "app"."core_profiles" ADD CONSTRAINT "uq_core_profiles_person_id" UNIQUE ("person_id");
ALTER TABLE "app"."core_profiles" ADD CONSTRAINT "uq_core_profiles_username" UNIQUE ("username");
ALTER TABLE "app"."core_user_preferences" ADD CONSTRAINT "uq_core_user_preferences_person_id" UNIQUE ("person_id");
ALTER TABLE "app"."core_organizations" ADD CONSTRAINT "uq_core_organizations_slug" UNIQUE ("slug");
ALTER TABLE "app"."core_organization_sites" ADD CONSTRAINT "uq_core_organization_sites_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."core_organization_memberships" ADD CONSTRAINT "uq_core_organization_memberships_organization_id_person_id" UNIQUE ("organization_id", "person_id");
ALTER TABLE "app"."core_organization_roles" ADD CONSTRAINT "uq_core_organization_roles_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."core_membership_roles" ADD CONSTRAINT "uq_core_membership_roles_membership_id_role_id" UNIQUE ("membership_id", "role_id");
ALTER TABLE "app"."core_organization_settings" ADD CONSTRAINT "uq_core_organization_settings_organization_id" UNIQUE ("organization_id");
ALTER TABLE "app"."core_legal_documents" ADD CONSTRAINT "uq_core_legal_documents_organization_id_docume_3b4ee7b4b41f" UNIQUE ("organization_id", "document_type", "version");
ALTER TABLE "app"."core_legal_acceptances" ADD CONSTRAINT "uq_core_legal_acceptances_document_id_person_id" UNIQUE ("document_id", "person_id");
ALTER TABLE "app"."catalog_categories" ADD CONSTRAINT "uq_catalog_categories_code" UNIQUE ("code");
ALTER TABLE "app"."catalog_tags" ADD CONSTRAINT "uq_catalog_tags_slug" UNIQUE ("slug");
ALTER TABLE "app"."catalog_skills" ADD CONSTRAINT "uq_catalog_skills_name" UNIQUE ("name");
ALTER TABLE "app"."catalog_course_tags" ADD CONSTRAINT "uq_catalog_course_tags_course_id_tag_id" UNIQUE ("course_id", "tag_id");
ALTER TABLE "app"."catalog_course_skills" ADD CONSTRAINT "uq_catalog_course_skills_course_id_skill_id" UNIQUE ("course_id", "skill_id");
ALTER TABLE "app"."catalog_course_instructors" ADD CONSTRAINT "uq_catalog_course_instructors_course_id_person_id" UNIQUE ("course_id", "person_id");
ALTER TABLE "app"."catalog_course_prerequisites" ADD CONSTRAINT "uq_catalog_course_prerequisites_course_id_required_course_id" UNIQUE ("course_id", "required_course_id");
ALTER TABLE "app"."catalog_course_versions" ADD CONSTRAINT "uq_catalog_course_versions_course_id_version_no" UNIQUE ("course_id", "version_no");
ALTER TABLE "app"."catalog_modules" ADD CONSTRAINT "uq_catalog_modules_course_id_sort_order" UNIQUE ("course_id", "sort_order");
ALTER TABLE "app"."catalog_lessons" ADD CONSTRAINT "uq_catalog_lessons_module_id_sort_order" UNIQUE ("module_id", "sort_order");
ALTER TABLE "app"."catalog_lesson_resources" ADD CONSTRAINT "uq_catalog_lesson_resources_lesson_id_resource_id" UNIQUE ("lesson_id", "resource_id");
ALTER TABLE "app"."catalog_learning_path_courses" ADD CONSTRAINT "uq_catalog_learning_path_courses_path_id_course_id" UNIQUE ("path_id", "course_id");
ALTER TABLE "app"."catalog_learning_path_courses" ADD CONSTRAINT "uq_catalog_learning_path_courses_path_id_sort_order" UNIQUE ("path_id", "sort_order");
ALTER TABLE "app"."catalog_collection_items" ADD CONSTRAINT "uq_catalog_collection_items_collection_id_bookmark_id" UNIQUE ("collection_id", "bookmark_id");
ALTER TABLE "app"."learning_cohort_instructors" ADD CONSTRAINT "uq_learning_cohort_instructors_cohort_id_person_id" UNIQUE ("cohort_id", "person_id");
ALTER TABLE "app"."learning_enrollments" ADD CONSTRAINT "uq_learning_enrollments_person_id_cohort_id" UNIQUE ("person_id", "cohort_id");
ALTER TABLE "app"."learning_lesson_progress" ADD CONSTRAINT "uq_learning_lesson_progress_enrollment_id_lesson_id" UNIQUE ("enrollment_id", "lesson_id");
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "uq_learning_resource_progress_enrollment_id_resource_id" UNIQUE ("enrollment_id", "resource_id");
ALTER TABLE "app"."learning_course_progress" ADD CONSTRAINT "uq_learning_course_progress_enrollment_id" UNIQUE ("enrollment_id");
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "uq_learning_study_sessions_person_id_device_session_key" UNIQUE ("person_id", "device_session_key");
ALTER TABLE "app"."learning_learning_events" ADD CONSTRAINT "uq_learning_learning_events_event_key" UNIQUE ("event_key");
ALTER TABLE "app"."learning_course_reviews" ADD CONSTRAINT "uq_learning_course_reviews_person_id_course_id" UNIQUE ("person_id", "course_id");
ALTER TABLE "app"."learning_certificates" ADD CONSTRAINT "uq_learning_certificates_certificate_code" UNIQUE ("certificate_code");
ALTER TABLE "app"."learning_person_badges" ADD CONSTRAINT "uq_learning_person_badges_person_id_badge_id" UNIQUE ("person_id", "badge_id");
ALTER TABLE "app"."assessment_rubric_criteria" ADD CONSTRAINT "uq_assessment_rubric_criteria_rubric_id_sort_order" UNIQUE ("rubric_id", "sort_order");
ALTER TABLE "app"."assessment_question_options" ADD CONSTRAINT "uq_assessment_question_options_question_id_sort_order" UNIQUE ("question_id", "sort_order");
ALTER TABLE "app"."assessment_assessment_questions" ADD CONSTRAINT "uq_assessment_assessment_questions_assessment_id_sort_order" UNIQUE ("assessment_id", "sort_order");
ALTER TABLE "app"."assessment_teams" ADD CONSTRAINT "uq_assessment_teams_cohort_id_name" UNIQUE ("cohort_id", "name");
ALTER TABLE "app"."assessment_team_members" ADD CONSTRAINT "uq_assessment_team_members_team_id_person_id" UNIQUE ("team_id", "person_id");
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "uq_assessment_submissions_assessment_id_person_62066d712cb3" UNIQUE ("assessment_id", "person_id", "attempt_number");
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "uq_assessment_submissions_assessment_id_team_i_abe5a07836f9" UNIQUE ("assessment_id", "team_id", "attempt_number");
ALTER TABLE "app"."assessment_submission_files" ADD CONSTRAINT "uq_assessment_submission_files_submission_id_asset_id" UNIQUE ("submission_id", "asset_id");
ALTER TABLE "app"."assessment_submission_members" ADD CONSTRAINT "uq_assessment_submission_members_submission_id_person_id" UNIQUE ("submission_id", "person_id");
ALTER TABLE "app"."assessment_attempt_answers" ADD CONSTRAINT "uq_assessment_attempt_answers_submission_id_question_id" UNIQUE ("submission_id", "question_id");
ALTER TABLE "app"."academic_faculties" ADD CONSTRAINT "uq_academic_faculties_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."academic_programs" ADD CONSTRAINT "uq_academic_programs_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."academic_curricula" ADD CONSTRAINT "uq_academic_curricula_program_id_code" UNIQUE ("program_id", "code");
ALTER TABLE "app"."academic_curriculum_courses" ADD CONSTRAINT "uq_academic_curriculum_courses_curriculum_id_code" UNIQUE ("curriculum_id", "code");
ALTER TABLE "app"."academic_curriculum_prerequisites" ADD CONSTRAINT "uq_academic_curriculum_prerequisites_curriculu_795601ab7d7a" UNIQUE ("curriculum_course_id", "prerequisite_course_id");
ALTER TABLE "app"."academic_terms" ADD CONSTRAINT "uq_academic_terms_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."academic_student_programs" ADD CONSTRAINT "uq_academic_student_programs_program_id_student_number" UNIQUE ("program_id", "student_number");
ALTER TABLE "app"."academic_admission_applications" ADD CONSTRAINT "uq_academic_admission_applications_application_code" UNIQUE ("application_code");
ALTER TABLE "app"."academic_admission_requirements" ADD CONSTRAINT "uq_academic_admission_requirements_program_id_code" UNIQUE ("program_id", "code");
ALTER TABLE "app"."academic_registrations" ADD CONSTRAINT "uq_academic_registrations_student_program_id_term_id" UNIQUE ("student_program_id", "term_id");
ALTER TABLE "app"."academic_sections" ADD CONSTRAINT "uq_academic_sections_organization_id_term_id_code" UNIQUE ("organization_id", "term_id", "code");
ALTER TABLE "app"."academic_section_instructors" ADD CONSTRAINT "uq_academic_section_instructors_section_id_person_id" UNIQUE ("section_id", "person_id");
ALTER TABLE "app"."academic_section_enrollments" ADD CONSTRAINT "uq_academic_section_enrollments_registration_id_section_id" UNIQUE ("registration_id", "section_id");
ALTER TABLE "app"."academic_class_sessions" ADD CONSTRAINT "uq_academic_class_sessions_section_id_starts_at" UNIQUE ("section_id", "starts_at");
ALTER TABLE "app"."academic_attendance" ADD CONSTRAINT "uq_academic_attendance_class_session_id_person_id" UNIQUE ("class_session_id", "person_id");
ALTER TABLE "app"."academic_gradebook_items" ADD CONSTRAINT "uq_academic_gradebook_items_section_id_title" UNIQUE ("section_id", "title");
ALTER TABLE "app"."academic_gradebook_scores" ADD CONSTRAINT "uq_academic_gradebook_scores_item_id_section_enrollment_id" UNIQUE ("item_id", "section_enrollment_id");
ALTER TABLE "app"."social_communities" ADD CONSTRAINT "uq_social_communities_slug" UNIQUE ("slug");
ALTER TABLE "app"."social_community_members" ADD CONSTRAINT "uq_social_community_members_community_id_person_id" UNIQUE ("community_id", "person_id");
ALTER TABLE "app"."social_community_rules" ADD CONSTRAINT "uq_social_community_rules_community_id_sort_order" UNIQUE ("community_id", "sort_order");
ALTER TABLE "app"."social_group_members" ADD CONSTRAINT "uq_social_group_members_group_id_person_id" UNIQUE ("group_id", "person_id");
ALTER TABLE "app"."social_channel_subscribers" ADD CONSTRAINT "uq_social_channel_subscribers_channel_id_person_id" UNIQUE ("channel_id", "person_id");
ALTER TABLE "app"."social_post_attachments" ADD CONSTRAINT "uq_social_post_attachments_post_id_asset_id" UNIQUE ("post_id", "asset_id");
ALTER TABLE "app"."social_post_reactions" ADD CONSTRAINT "uq_social_post_reactions_post_id_person_id_reaction" UNIQUE ("post_id", "person_id", "reaction");
ALTER TABLE "app"."social_qa_votes" ADD CONSTRAINT "uq_social_qa_votes_answer_id_person_id" UNIQUE ("answer_id", "person_id");
ALTER TABLE "app"."social_chat_members" ADD CONSTRAINT "uq_social_chat_members_room_id_person_id" UNIQUE ("room_id", "person_id");
ALTER TABLE "app"."social_chat_messages" ADD CONSTRAINT "uq_social_chat_messages_room_id_client_message_key" UNIQUE ("room_id", "client_message_key");
ALTER TABLE "app"."social_saved_lists" ADD CONSTRAINT "uq_social_saved_lists_person_id_name" UNIQUE ("person_id", "name");
ALTER TABLE "app"."calendar_event_recurrences" ADD CONSTRAINT "uq_calendar_event_recurrences_event_id" UNIQUE ("event_id");
ALTER TABLE "app"."calendar_event_attendees" ADD CONSTRAINT "uq_calendar_event_attendees_event_id_person_id" UNIQUE ("event_id", "person_id");
ALTER TABLE "app"."calendar_calendar_subscriptions" ADD CONSTRAINT "uq_calendar_calendar_subscriptions_person_id_calendar_id" UNIQUE ("person_id", "calendar_id");
ALTER TABLE "app"."content_interactive_2d" ADD CONSTRAINT "uq_content_interactive_2d_resource_id" UNIQUE ("resource_id");
ALTER TABLE "app"."content_interactive_hotspots" ADD CONSTRAINT "uq_content_interactive_hotspots_scene_id_code" UNIQUE ("scene_id", "code");
ALTER TABLE "app"."content_models_3d" ADD CONSTRAINT "uq_content_models_3d_resource_id" UNIQUE ("resource_id");
ALTER TABLE "app"."content_simulator_parameters" ADD CONSTRAINT "uq_content_simulator_parameters_simulator_id_code" UNIQUE ("simulator_id", "code");
ALTER TABLE "app"."platform_plans" ADD CONSTRAINT "uq_platform_plans_code" UNIQUE ("code");
ALTER TABLE "app"."platform_features" ADD CONSTRAINT "uq_platform_features_code" UNIQUE ("code");
ALTER TABLE "app"."platform_plan_entitlements" ADD CONSTRAINT "uq_platform_plan_entitlements_plan_id_feature_id" UNIQUE ("plan_id", "feature_id");
ALTER TABLE "app"."platform_plan_prices" ADD CONSTRAINT "uq_platform_plan_prices_plan_id_currency_billi_d7e9c6ab7ea7" UNIQUE ("plan_id", "currency", "billing_interval", "effective_from");
ALTER TABLE "app"."platform_subscription_usage" ADD CONSTRAINT "uq_platform_subscription_usage_subscription_id_9978d40be0d0" UNIQUE ("subscription_id", "feature_id", "period_start");
ALTER TABLE "app"."platform_platform_payments" ADD CONSTRAINT "uq_platform_platform_payments_provider_provider_reference" UNIQUE ("provider", "provider_reference");
ALTER TABLE "app"."platform_ad_placements" ADD CONSTRAINT "uq_platform_ad_placements_code" UNIQUE ("code");
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "uq_finance_tuition_schedules_organization_id_term_id_name" UNIQUE ("organization_id", "term_id", "name");
ALTER TABLE "app"."finance_student_accounts" ADD CONSTRAINT "uq_finance_student_accounts_student_program_id_currency" UNIQUE ("student_program_id", "currency");
ALTER TABLE "app"."finance_student_charges" ADD CONSTRAINT "uq_finance_student_charges_account_id_reference_code" UNIQUE ("account_id", "reference_code");
ALTER TABLE "app"."finance_installments" ADD CONSTRAINT "uq_finance_installments_charge_id_installment_number" UNIQUE ("charge_id", "installment_number");
ALTER TABLE "app"."finance_student_payments" ADD CONSTRAINT "uq_finance_student_payments_provider_reference" UNIQUE ("provider_reference");
ALTER TABLE "app"."finance_payment_allocations" ADD CONSTRAINT "uq_finance_payment_allocations_payment_id_installment_id" UNIQUE ("payment_id", "installment_id");
ALTER TABLE "app"."finance_scholarships" ADD CONSTRAINT "uq_finance_scholarships_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."services_procedures" ADD CONSTRAINT "uq_services_procedures_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."services_procedure_steps" ADD CONSTRAINT "uq_services_procedure_steps_procedure_id_step_order" UNIQUE ("procedure_id", "step_order");
ALTER TABLE "app"."services_procedure_fields" ADD CONSTRAINT "uq_services_procedure_fields_procedure_id_field_code" UNIQUE ("procedure_id", "field_code");
ALTER TABLE "app"."services_requests" ADD CONSTRAINT "uq_services_requests_organization_id_tracking_code" UNIQUE ("organization_id", "tracking_code");
ALTER TABLE "app"."services_request_files" ADD CONSTRAINT "uq_services_request_files_request_id_asset_id" UNIQUE ("request_id", "asset_id");
ALTER TABLE "app"."services_service_offerings" ADD CONSTRAINT "uq_services_service_offerings_organization_id_code" UNIQUE ("organization_id", "code");
ALTER TABLE "app"."services_physical_assets" ADD CONSTRAINT "uq_services_physical_assets_organization_id_asset_code" UNIQUE ("organization_id", "asset_code");
ALTER TABLE "app"."services_reservation_attendees" ADD CONSTRAINT "uq_services_reservation_attendees_reservation_id_person_id" UNIQUE ("reservation_id", "person_id");
ALTER TABLE "app"."services_survey_questions" ADD CONSTRAINT "uq_services_survey_questions_survey_id_sort_order" UNIQUE ("survey_id", "sort_order");
ALTER TABLE "app"."services_survey_answers" ADD CONSTRAINT "uq_services_survey_answers_response_id_question_id" UNIQUE ("response_id", "question_id");
ALTER TABLE "app"."core_people" ADD CONSTRAINT "ck_core_people_1" CHECK (status IN ('active','inactive','anonymized'));
ALTER TABLE "app"."core_organizations" ADD CONSTRAINT "ck_core_organizations_1" CHECK (organization_type IN ('university','institute','school','academy','company','other'));
ALTER TABLE "app"."core_organizations" ADD CONSTRAINT "ck_core_organizations_2" CHECK (status IN ('pending','active','suspended','archived'));
ALTER TABLE "app"."catalog_media_assets" ADD CONSTRAINT "ck_catalog_media_assets_1" CHECK (byte_size >= 0);
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "ck_catalog_courses_1" CHECK (course_kind IN ('open','institutional','temporary_private','premium'));
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "ck_catalog_courses_2" CHECK (delivery_mode IN ('asynchronous','live','in_person','hybrid'));
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "ck_catalog_courses_3" CHECK (visibility IN ('public','unlisted','members','private'));
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "ck_catalog_courses_4" CHECK (status IN ('draft','published','archived'));
ALTER TABLE "app"."catalog_courses" ADD CONSTRAINT "ck_catalog_courses_5" CHECK (organization_id IS NOT NULL OR owner_person_id IS NOT NULL);
ALTER TABLE "app"."catalog_course_prerequisites" ADD CONSTRAINT "ck_catalog_course_prerequisites_1" CHECK (course_id <> required_course_id);
ALTER TABLE "app"."catalog_course_versions" ADD CONSTRAINT "ck_catalog_course_versions_1" CHECK (version_no > 0);
ALTER TABLE "app"."catalog_resources" ADD CONSTRAINT "ck_catalog_resources_1" CHECK (resource_type IN ('text','pdf','video','audio','image','link','html_native','interactive_2d','model_3d','simulation','document','other'));
ALTER TABLE "app"."catalog_bookmarks" ADD CONSTRAINT "ck_catalog_bookmarks_1" CHECK (num_nonnulls(course_id,resource_id,external_link_id) = 1);
ALTER TABLE "app"."learning_cohorts" ADD CONSTRAINT "ck_learning_cohorts_1" CHECK (ends_at IS NULL OR starts_at IS NULL OR ends_at >= starts_at);
ALTER TABLE "app"."learning_lesson_progress" ADD CONSTRAINT "ck_learning_lesson_progress_1" CHECK (progress_percent BETWEEN 0 AND 100);
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "ck_learning_resource_progress_1" CHECK (progress_percent BETWEEN 0 AND 100);
ALTER TABLE "app"."learning_resource_progress" ADD CONSTRAINT "ck_learning_resource_progress_2" CHECK (time_seconds >= 0);
ALTER TABLE "app"."learning_course_progress" ADD CONSTRAINT "ck_learning_course_progress_1" CHECK (percent_complete BETWEEN 0 AND 100);
ALTER TABLE "app"."learning_course_progress" ADD CONSTRAINT "ck_learning_course_progress_2" CHECK (active_seconds >= 0);
ALTER TABLE "app"."learning_study_sessions" ADD CONSTRAINT "ck_learning_study_sessions_1" CHECK (active_seconds >= 0);
ALTER TABLE "app"."learning_course_reviews" ADD CONSTRAINT "ck_learning_course_reviews_1" CHECK (rating BETWEEN 1 AND 5);
ALTER TABLE "app"."assessment_rubric_criteria" ADD CONSTRAINT "ck_assessment_rubric_criteria_1" CHECK (max_points >= 0);
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "ck_assessment_assessments_1" CHECK (allowed_attempts >= 1);
ALTER TABLE "app"."assessment_assessments" ADD CONSTRAINT "ck_assessment_assessments_2" CHECK (max_score >= 0);
ALTER TABLE "app"."assessment_assessment_extensions" ADD CONSTRAINT "ck_assessment_assessment_extensions_1" CHECK (num_nonnulls(person_id,team_id) = 1);
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "ck_assessment_submissions_1" CHECK (num_nonnulls(person_id,team_id) = 1);
ALTER TABLE "app"."assessment_submissions" ADD CONSTRAINT "ck_assessment_submissions_2" CHECK (attempt_number > 0);
ALTER TABLE "app"."academic_curriculum_courses" ADD CONSTRAINT "ck_academic_curriculum_courses_1" CHECK (credits >= 0);
ALTER TABLE "app"."academic_curriculum_prerequisites" ADD CONSTRAINT "ck_academic_curriculum_prerequisites_1" CHECK (curriculum_course_id <> prerequisite_course_id);
ALTER TABLE "app"."academic_terms" ADD CONSTRAINT "ck_academic_terms_1" CHECK (ends_on >= starts_on);
ALTER TABLE "app"."academic_section_enrollments" ADD CONSTRAINT "ck_academic_section_enrollments_1" CHECK (attempt_number > 0);
ALTER TABLE "app"."academic_class_sessions" ADD CONSTRAINT "ck_academic_class_sessions_1" CHECK (ends_at > starts_at);
ALTER TABLE "app"."academic_gradebook_items" ADD CONSTRAINT "ck_academic_gradebook_items_1" CHECK (weight_percent BETWEEN 0 AND 100);
ALTER TABLE "app"."social_qa_votes" ADD CONSTRAINT "ck_social_qa_votes_1" CHECK (value IN (-1,1));
ALTER TABLE "app"."social_saved_list_items" ADD CONSTRAINT "ck_social_saved_list_items_1" CHECK (num_nonnulls(community_id,room_id) = 1);
ALTER TABLE "app"."calendar_events" ADD CONSTRAINT "ck_calendar_events_1" CHECK (ends_at > starts_at);
ALTER TABLE "app"."platform_plan_prices" ADD CONSTRAINT "ck_platform_plan_prices_1" CHECK (amount >= 0);
ALTER TABLE "app"."platform_subscriptions" ADD CONSTRAINT "ck_platform_subscriptions_1" CHECK (num_nonnulls(person_id,organization_id) = 1);
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "ck_finance_tuition_schedules_1" CHECK (amount >= 0);
ALTER TABLE "app"."finance_tuition_schedules" ADD CONSTRAINT "ck_finance_tuition_schedules_2" CHECK (installments_count > 0);
ALTER TABLE "app"."finance_student_charges" ADD CONSTRAINT "ck_finance_student_charges_1" CHECK (amount >= 0);
ALTER TABLE "app"."finance_installments" ADD CONSTRAINT "ck_finance_installments_1" CHECK (amount >= 0);
ALTER TABLE "app"."finance_payment_allocations" ADD CONSTRAINT "ck_finance_payment_allocations_1" CHECK (amount > 0);
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "ck_services_asset_reservations_1" CHECK (ends_at > starts_at);
ALTER TABLE "app"."services_asset_reservations" ADD CONSTRAINT "ex_asset_reservations_overlap" EXCLUDE USING gist ("asset_id" WITH =, tstzrange("starts_at", "ends_at", '[)') WITH &&) WHERE ("status" IN ('approved','confirmed','active'));


-- ============================================================================
-- 3. INDICES
-- ============================================================================

CREATE INDEX "idx_core_countries_created_by" ON "app"."core_countries"("created_by");
CREATE INDEX "idx_core_countries_updated_by" ON "app"."core_countries"("updated_by");
CREATE INDEX "idx_core_regions_created_by" ON "app"."core_regions"("created_by");
CREATE INDEX "idx_core_regions_updated_by" ON "app"."core_regions"("updated_by");
CREATE INDEX "idx_core_provinces_created_by" ON "app"."core_provinces"("created_by");
CREATE INDEX "idx_core_provinces_updated_by" ON "app"."core_provinces"("updated_by");
CREATE INDEX "idx_core_districts_created_by" ON "app"."core_districts"("created_by");
CREATE INDEX "idx_core_districts_updated_by" ON "app"."core_districts"("updated_by");
CREATE INDEX "idx_core_people_district_id" ON "app"."core_people"("district_id");
CREATE INDEX "idx_core_profiles_created_by" ON "app"."core_profiles"("created_by");
CREATE INDEX "idx_core_profiles_updated_by" ON "app"."core_profiles"("updated_by");
CREATE INDEX "idx_core_user_preferences_created_by" ON "app"."core_user_preferences"("created_by");
CREATE INDEX "idx_core_user_preferences_updated_by" ON "app"."core_user_preferences"("updated_by");
CREATE INDEX "idx_core_organizations_owner_person_id" ON "app"."core_organizations"("owner_person_id");
CREATE INDEX "idx_core_organizations_created_by" ON "app"."core_organizations"("created_by");
CREATE INDEX "idx_core_organizations_updated_by" ON "app"."core_organizations"("updated_by");
CREATE INDEX "idx_core_organization_sites_district_id" ON "app"."core_organization_sites"("district_id");
CREATE INDEX "idx_core_organization_sites_created_by" ON "app"."core_organization_sites"("created_by");
CREATE INDEX "idx_core_organization_sites_updated_by" ON "app"."core_organization_sites"("updated_by");
CREATE INDEX "idx_core_organization_memberships_person_id" ON "app"."core_organization_memberships"("person_id");
CREATE INDEX "idx_core_organization_memberships_created_by" ON "app"."core_organization_memberships"("created_by");
CREATE INDEX "idx_core_organization_memberships_updated_by" ON "app"."core_organization_memberships"("updated_by");
CREATE INDEX "idx_core_organization_roles_created_by" ON "app"."core_organization_roles"("created_by");
CREATE INDEX "idx_core_organization_roles_updated_by" ON "app"."core_organization_roles"("updated_by");
CREATE INDEX "idx_core_membership_roles_role_id" ON "app"."core_membership_roles"("role_id");
CREATE INDEX "idx_core_membership_roles_created_by" ON "app"."core_membership_roles"("created_by");
CREATE INDEX "idx_core_membership_roles_updated_by" ON "app"."core_membership_roles"("updated_by");
CREATE INDEX "idx_core_organization_settings_created_by" ON "app"."core_organization_settings"("created_by");
CREATE INDEX "idx_core_organization_settings_updated_by" ON "app"."core_organization_settings"("updated_by");
CREATE INDEX "idx_core_organization_invitations_organization_id" ON "app"."core_organization_invitations"("organization_id");
CREATE INDEX "idx_core_organization_invitations_invited_by" ON "app"."core_organization_invitations"("invited_by");
CREATE INDEX "idx_core_organization_invitations_created_by" ON "app"."core_organization_invitations"("created_by");
CREATE INDEX "idx_core_organization_invitations_updated_by" ON "app"."core_organization_invitations"("updated_by");
CREATE INDEX "idx_core_institution_requests_applicant_id" ON "app"."core_institution_requests"("applicant_id");
CREATE INDEX "idx_core_institution_requests_reviewed_by" ON "app"."core_institution_requests"("reviewed_by");
CREATE INDEX "idx_core_institution_requests_created_by" ON "app"."core_institution_requests"("created_by");
CREATE INDEX "idx_core_institution_requests_updated_by" ON "app"."core_institution_requests"("updated_by");
CREATE INDEX "idx_core_legal_documents_created_by" ON "app"."core_legal_documents"("created_by");
CREATE INDEX "idx_core_legal_documents_updated_by" ON "app"."core_legal_documents"("updated_by");
CREATE INDEX "idx_core_legal_acceptances_person_id" ON "app"."core_legal_acceptances"("person_id");
CREATE INDEX "idx_core_legal_acceptances_created_by" ON "app"."core_legal_acceptances"("created_by");
CREATE INDEX "idx_core_legal_acceptances_updated_by" ON "app"."core_legal_acceptances"("updated_by");
CREATE INDEX "idx_core_organization_announcements_organization_id" ON "app"."core_organization_announcements"("organization_id");
CREATE INDEX "idx_core_organization_announcements_created_by" ON "app"."core_organization_announcements"("created_by");
CREATE INDEX "idx_core_organization_announcements_updated_by" ON "app"."core_organization_announcements"("updated_by");
CREATE INDEX "idx_core_audit_logs_organization_id" ON "app"."core_audit_logs"("organization_id");
CREATE INDEX "idx_core_audit_logs_actor_id" ON "app"."core_audit_logs"("actor_id");
CREATE INDEX "idx_core_audit_logs_created_by" ON "app"."core_audit_logs"("created_by");
CREATE INDEX "idx_core_audit_logs_updated_by" ON "app"."core_audit_logs"("updated_by");
CREATE INDEX "idx_catalog_categories_parent_id" ON "app"."catalog_categories"("parent_id");
CREATE INDEX "idx_catalog_categories_created_by" ON "app"."catalog_categories"("created_by");
CREATE INDEX "idx_catalog_categories_updated_by" ON "app"."catalog_categories"("updated_by");
CREATE INDEX "idx_catalog_tags_created_by" ON "app"."catalog_tags"("created_by");
CREATE INDEX "idx_catalog_tags_updated_by" ON "app"."catalog_tags"("updated_by");
CREATE INDEX "idx_catalog_skills_created_by" ON "app"."catalog_skills"("created_by");
CREATE INDEX "idx_catalog_skills_updated_by" ON "app"."catalog_skills"("updated_by");
CREATE INDEX "idx_catalog_media_assets_owner_id" ON "app"."catalog_media_assets"("owner_id");
CREATE INDEX "idx_catalog_media_assets_organization_id" ON "app"."catalog_media_assets"("organization_id");
CREATE INDEX "idx_catalog_media_assets_created_by" ON "app"."catalog_media_assets"("created_by");
CREATE INDEX "idx_catalog_media_assets_updated_by" ON "app"."catalog_media_assets"("updated_by");
CREATE INDEX "idx_catalog_courses_organization_id" ON "app"."catalog_courses"("organization_id");
CREATE INDEX "idx_catalog_courses_owner_person_id" ON "app"."catalog_courses"("owner_person_id");
CREATE INDEX "idx_catalog_courses_category_id" ON "app"."catalog_courses"("category_id");
CREATE INDEX "idx_catalog_courses_thumbnail_id" ON "app"."catalog_courses"("thumbnail_id");
CREATE INDEX "idx_catalog_courses_created_by" ON "app"."catalog_courses"("created_by");
CREATE INDEX "idx_catalog_courses_updated_by" ON "app"."catalog_courses"("updated_by");
CREATE INDEX "idx_catalog_course_tags_tag_id" ON "app"."catalog_course_tags"("tag_id");
CREATE INDEX "idx_catalog_course_tags_created_by" ON "app"."catalog_course_tags"("created_by");
CREATE INDEX "idx_catalog_course_tags_updated_by" ON "app"."catalog_course_tags"("updated_by");
CREATE INDEX "idx_catalog_course_skills_skill_id" ON "app"."catalog_course_skills"("skill_id");
CREATE INDEX "idx_catalog_course_skills_created_by" ON "app"."catalog_course_skills"("created_by");
CREATE INDEX "idx_catalog_course_skills_updated_by" ON "app"."catalog_course_skills"("updated_by");
CREATE INDEX "idx_catalog_course_instructors_person_id" ON "app"."catalog_course_instructors"("person_id");
CREATE INDEX "idx_catalog_course_instructors_created_by" ON "app"."catalog_course_instructors"("created_by");
CREATE INDEX "idx_catalog_course_instructors_updated_by" ON "app"."catalog_course_instructors"("updated_by");
CREATE INDEX "idx_catalog_course_prerequisites_required_course_id" ON "app"."catalog_course_prerequisites"("required_course_id");
CREATE INDEX "idx_catalog_course_prerequisites_created_by" ON "app"."catalog_course_prerequisites"("created_by");
CREATE INDEX "idx_catalog_course_prerequisites_updated_by" ON "app"."catalog_course_prerequisites"("updated_by");
CREATE INDEX "idx_catalog_course_versions_created_by" ON "app"."catalog_course_versions"("created_by");
CREATE INDEX "idx_catalog_course_versions_updated_by" ON "app"."catalog_course_versions"("updated_by");
CREATE INDEX "idx_catalog_modules_created_by" ON "app"."catalog_modules"("created_by");
CREATE INDEX "idx_catalog_modules_updated_by" ON "app"."catalog_modules"("updated_by");
CREATE INDEX "idx_catalog_lessons_created_by" ON "app"."catalog_lessons"("created_by");
CREATE INDEX "idx_catalog_lessons_updated_by" ON "app"."catalog_lessons"("updated_by");
CREATE INDEX "idx_catalog_resources_owner_id" ON "app"."catalog_resources"("owner_id");
CREATE INDEX "idx_catalog_resources_organization_id" ON "app"."catalog_resources"("organization_id");
CREATE INDEX "idx_catalog_resources_asset_id" ON "app"."catalog_resources"("asset_id");
CREATE INDEX "idx_catalog_resources_created_by" ON "app"."catalog_resources"("created_by");
CREATE INDEX "idx_catalog_resources_updated_by" ON "app"."catalog_resources"("updated_by");
CREATE INDEX "idx_catalog_lesson_resources_resource_id" ON "app"."catalog_lesson_resources"("resource_id");
CREATE INDEX "idx_catalog_lesson_resources_created_by" ON "app"."catalog_lesson_resources"("created_by");
CREATE INDEX "idx_catalog_lesson_resources_updated_by" ON "app"."catalog_lesson_resources"("updated_by");
CREATE INDEX "idx_catalog_learning_paths_organization_id" ON "app"."catalog_learning_paths"("organization_id");
CREATE INDEX "idx_catalog_learning_paths_owner_id" ON "app"."catalog_learning_paths"("owner_id");
CREATE INDEX "idx_catalog_learning_paths_created_by" ON "app"."catalog_learning_paths"("created_by");
CREATE INDEX "idx_catalog_learning_paths_updated_by" ON "app"."catalog_learning_paths"("updated_by");
CREATE INDEX "idx_catalog_learning_path_courses_course_id" ON "app"."catalog_learning_path_courses"("course_id");
CREATE INDEX "idx_catalog_learning_path_courses_created_by" ON "app"."catalog_learning_path_courses"("created_by");
CREATE INDEX "idx_catalog_learning_path_courses_updated_by" ON "app"."catalog_learning_path_courses"("updated_by");
CREATE INDEX "idx_catalog_external_libraries_organization_id" ON "app"."catalog_external_libraries"("organization_id");
CREATE INDEX "idx_catalog_external_libraries_logo_asset_id" ON "app"."catalog_external_libraries"("logo_asset_id");
CREATE INDEX "idx_catalog_external_libraries_created_by" ON "app"."catalog_external_libraries"("created_by");
CREATE INDEX "idx_catalog_external_libraries_updated_by" ON "app"."catalog_external_libraries"("updated_by");
CREATE INDEX "idx_catalog_external_library_links_library_id" ON "app"."catalog_external_library_links"("library_id");
CREATE INDEX "idx_catalog_external_library_links_thumbnail_id" ON "app"."catalog_external_library_links"("thumbnail_id");
CREATE INDEX "idx_catalog_external_library_links_created_by" ON "app"."catalog_external_library_links"("created_by");
CREATE INDEX "idx_catalog_external_library_links_updated_by" ON "app"."catalog_external_library_links"("updated_by");
CREATE INDEX "idx_catalog_bookmarks_person_id" ON "app"."catalog_bookmarks"("person_id");
CREATE INDEX "idx_catalog_bookmarks_course_id" ON "app"."catalog_bookmarks"("course_id");
CREATE INDEX "idx_catalog_bookmarks_resource_id" ON "app"."catalog_bookmarks"("resource_id");
CREATE INDEX "idx_catalog_bookmarks_external_link_id" ON "app"."catalog_bookmarks"("external_link_id");
CREATE INDEX "idx_catalog_bookmarks_created_by" ON "app"."catalog_bookmarks"("created_by");
CREATE INDEX "idx_catalog_bookmarks_updated_by" ON "app"."catalog_bookmarks"("updated_by");
CREATE INDEX "idx_catalog_collections_person_id" ON "app"."catalog_collections"("person_id");
CREATE INDEX "idx_catalog_collections_created_by" ON "app"."catalog_collections"("created_by");
CREATE INDEX "idx_catalog_collections_updated_by" ON "app"."catalog_collections"("updated_by");
CREATE INDEX "idx_catalog_collection_items_bookmark_id" ON "app"."catalog_collection_items"("bookmark_id");
CREATE INDEX "idx_catalog_collection_items_created_by" ON "app"."catalog_collection_items"("created_by");
CREATE INDEX "idx_catalog_collection_items_updated_by" ON "app"."catalog_collection_items"("updated_by");
CREATE INDEX "idx_learning_cohorts_course_id" ON "app"."learning_cohorts"("course_id");
CREATE INDEX "idx_learning_cohorts_organization_id" ON "app"."learning_cohorts"("organization_id");
CREATE INDEX "idx_learning_cohorts_created_by" ON "app"."learning_cohorts"("created_by");
CREATE INDEX "idx_learning_cohorts_updated_by" ON "app"."learning_cohorts"("updated_by");
CREATE INDEX "idx_learning_cohort_instructors_person_id" ON "app"."learning_cohort_instructors"("person_id");
CREATE INDEX "idx_learning_cohort_instructors_created_by" ON "app"."learning_cohort_instructors"("created_by");
CREATE INDEX "idx_learning_cohort_instructors_updated_by" ON "app"."learning_cohort_instructors"("updated_by");
CREATE INDEX "idx_learning_enrollments_cohort_id" ON "app"."learning_enrollments"("cohort_id");
CREATE INDEX "idx_learning_enrollments_created_by" ON "app"."learning_enrollments"("created_by");
CREATE INDEX "idx_learning_enrollments_updated_by" ON "app"."learning_enrollments"("updated_by");
CREATE INDEX "idx_learning_lesson_progress_lesson_id" ON "app"."learning_lesson_progress"("lesson_id");
CREATE INDEX "idx_learning_lesson_progress_created_by" ON "app"."learning_lesson_progress"("created_by");
CREATE INDEX "idx_learning_lesson_progress_updated_by" ON "app"."learning_lesson_progress"("updated_by");
CREATE INDEX "idx_learning_resource_progress_resource_id" ON "app"."learning_resource_progress"("resource_id");
CREATE INDEX "idx_learning_resource_progress_created_by" ON "app"."learning_resource_progress"("created_by");
CREATE INDEX "idx_learning_resource_progress_updated_by" ON "app"."learning_resource_progress"("updated_by");
CREATE INDEX "idx_learning_course_progress_created_by" ON "app"."learning_course_progress"("created_by");
CREATE INDEX "idx_learning_course_progress_updated_by" ON "app"."learning_course_progress"("updated_by");
CREATE INDEX "idx_learning_study_sessions_enrollment_id" ON "app"."learning_study_sessions"("enrollment_id");
CREATE INDEX "idx_learning_study_sessions_lesson_id" ON "app"."learning_study_sessions"("lesson_id");
CREATE INDEX "idx_learning_study_sessions_resource_id" ON "app"."learning_study_sessions"("resource_id");
CREATE INDEX "idx_learning_study_sessions_created_by" ON "app"."learning_study_sessions"("created_by");
CREATE INDEX "idx_learning_study_sessions_updated_by" ON "app"."learning_study_sessions"("updated_by");
CREATE INDEX "idx_learning_learning_events_person_id" ON "app"."learning_learning_events"("person_id");
CREATE INDEX "idx_learning_learning_events_enrollment_id" ON "app"."learning_learning_events"("enrollment_id");
CREATE INDEX "idx_learning_learning_events_resource_id" ON "app"."learning_learning_events"("resource_id");
CREATE INDEX "idx_learning_learning_events_created_by" ON "app"."learning_learning_events"("created_by");
CREATE INDEX "idx_learning_learning_events_updated_by" ON "app"."learning_learning_events"("updated_by");
CREATE INDEX "idx_learning_course_notes_person_id" ON "app"."learning_course_notes"("person_id");
CREATE INDEX "idx_learning_course_notes_lesson_id" ON "app"."learning_course_notes"("lesson_id");
CREATE INDEX "idx_learning_course_notes_created_by" ON "app"."learning_course_notes"("created_by");
CREATE INDEX "idx_learning_course_notes_updated_by" ON "app"."learning_course_notes"("updated_by");
CREATE INDEX "idx_learning_course_reviews_course_id" ON "app"."learning_course_reviews"("course_id");
CREATE INDEX "idx_learning_course_reviews_created_by" ON "app"."learning_course_reviews"("created_by");
CREATE INDEX "idx_learning_course_reviews_updated_by" ON "app"."learning_course_reviews"("updated_by");
CREATE INDEX "idx_learning_learning_goals_person_id" ON "app"."learning_learning_goals"("person_id");
CREATE INDEX "idx_learning_learning_goals_created_by" ON "app"."learning_learning_goals"("created_by");
CREATE INDEX "idx_learning_learning_goals_updated_by" ON "app"."learning_learning_goals"("updated_by");
CREATE INDEX "idx_learning_certificate_templates_organization_id" ON "app"."learning_certificate_templates"("organization_id");
CREATE INDEX "idx_learning_certificate_templates_template_asset_id" ON "app"."learning_certificate_templates"("template_asset_id");
CREATE INDEX "idx_learning_certificate_templates_created_by" ON "app"."learning_certificate_templates"("created_by");
CREATE INDEX "idx_learning_certificate_templates_updated_by" ON "app"."learning_certificate_templates"("updated_by");
CREATE INDEX "idx_learning_certificates_person_id" ON "app"."learning_certificates"("person_id");
CREATE INDEX "idx_learning_certificates_course_id" ON "app"."learning_certificates"("course_id");
CREATE INDEX "idx_learning_certificates_organization_id" ON "app"."learning_certificates"("organization_id");
CREATE INDEX "idx_learning_certificates_template_id" ON "app"."learning_certificates"("template_id");
CREATE INDEX "idx_learning_certificates_document_asset_id" ON "app"."learning_certificates"("document_asset_id");
CREATE INDEX "idx_learning_certificates_created_by" ON "app"."learning_certificates"("created_by");
CREATE INDEX "idx_learning_certificates_updated_by" ON "app"."learning_certificates"("updated_by");
CREATE INDEX "idx_learning_badges_organization_id" ON "app"."learning_badges"("organization_id");
CREATE INDEX "idx_learning_badges_icon_asset_id" ON "app"."learning_badges"("icon_asset_id");
CREATE INDEX "idx_learning_badges_created_by" ON "app"."learning_badges"("created_by");
CREATE INDEX "idx_learning_badges_updated_by" ON "app"."learning_badges"("updated_by");
CREATE INDEX "idx_learning_person_badges_badge_id" ON "app"."learning_person_badges"("badge_id");
CREATE INDEX "idx_learning_person_badges_created_by" ON "app"."learning_person_badges"("created_by");
CREATE INDEX "idx_learning_person_badges_updated_by" ON "app"."learning_person_badges"("updated_by");
CREATE INDEX "idx_assessment_rubrics_organization_id" ON "app"."assessment_rubrics"("organization_id");
CREATE INDEX "idx_assessment_rubrics_owner_id" ON "app"."assessment_rubrics"("owner_id");
CREATE INDEX "idx_assessment_rubrics_created_by" ON "app"."assessment_rubrics"("created_by");
CREATE INDEX "idx_assessment_rubrics_updated_by" ON "app"."assessment_rubrics"("updated_by");
CREATE INDEX "idx_assessment_rubric_criteria_created_by" ON "app"."assessment_rubric_criteria"("created_by");
CREATE INDEX "idx_assessment_rubric_criteria_updated_by" ON "app"."assessment_rubric_criteria"("updated_by");
CREATE INDEX "idx_assessment_question_banks_organization_id" ON "app"."assessment_question_banks"("organization_id");
CREATE INDEX "idx_assessment_question_banks_owner_id" ON "app"."assessment_question_banks"("owner_id");
CREATE INDEX "idx_assessment_question_banks_created_by" ON "app"."assessment_question_banks"("created_by");
CREATE INDEX "idx_assessment_question_banks_updated_by" ON "app"."assessment_question_banks"("updated_by");
CREATE INDEX "idx_assessment_questions_bank_id" ON "app"."assessment_questions"("bank_id");
CREATE INDEX "idx_assessment_questions_media_id" ON "app"."assessment_questions"("media_id");
CREATE INDEX "idx_assessment_questions_created_by" ON "app"."assessment_questions"("created_by");
CREATE INDEX "idx_assessment_questions_updated_by" ON "app"."assessment_questions"("updated_by");
CREATE INDEX "idx_assessment_question_options_created_by" ON "app"."assessment_question_options"("created_by");
CREATE INDEX "idx_assessment_question_options_updated_by" ON "app"."assessment_question_options"("updated_by");
CREATE INDEX "idx_assessment_assessments_course_id" ON "app"."assessment_assessments"("course_id");
CREATE INDEX "idx_assessment_assessments_cohort_id" ON "app"."assessment_assessments"("cohort_id");
CREATE INDEX "idx_assessment_assessments_rubric_id" ON "app"."assessment_assessments"("rubric_id");
CREATE INDEX "idx_assessment_assessments_created_by" ON "app"."assessment_assessments"("created_by");
CREATE INDEX "idx_assessment_assessments_updated_by" ON "app"."assessment_assessments"("updated_by");
CREATE INDEX "idx_assessment_assessment_questions_question_id" ON "app"."assessment_assessment_questions"("question_id");
CREATE INDEX "idx_assessment_assessment_questions_created_by" ON "app"."assessment_assessment_questions"("created_by");
CREATE INDEX "idx_assessment_assessment_questions_updated_by" ON "app"."assessment_assessment_questions"("updated_by");
CREATE INDEX "idx_assessment_teams_leader_person_id" ON "app"."assessment_teams"("leader_person_id");
CREATE INDEX "idx_assessment_teams_created_for_assessment_id" ON "app"."assessment_teams"("created_for_assessment_id");
CREATE INDEX "idx_assessment_teams_created_by" ON "app"."assessment_teams"("created_by");
CREATE INDEX "idx_assessment_teams_updated_by" ON "app"."assessment_teams"("updated_by");
CREATE INDEX "idx_assessment_team_members_person_id" ON "app"."assessment_team_members"("person_id");
CREATE INDEX "idx_assessment_team_members_created_by" ON "app"."assessment_team_members"("created_by");
CREATE INDEX "idx_assessment_team_members_updated_by" ON "app"."assessment_team_members"("updated_by");
CREATE INDEX "idx_assessment_assessment_extensions_assessment_id" ON "app"."assessment_assessment_extensions"("assessment_id");
CREATE INDEX "idx_assessment_assessment_extensions_person_id" ON "app"."assessment_assessment_extensions"("person_id");
CREATE INDEX "idx_assessment_assessment_extensions_team_id" ON "app"."assessment_assessment_extensions"("team_id");
CREATE INDEX "idx_assessment_assessment_extensions_created_by" ON "app"."assessment_assessment_extensions"("created_by");
CREATE INDEX "idx_assessment_assessment_extensions_updated_by" ON "app"."assessment_assessment_extensions"("updated_by");
CREATE INDEX "idx_assessment_submissions_person_id" ON "app"."assessment_submissions"("person_id");
CREATE INDEX "idx_assessment_submissions_team_id" ON "app"."assessment_submissions"("team_id");
CREATE INDEX "idx_assessment_submissions_graded_by" ON "app"."assessment_submissions"("graded_by");
CREATE INDEX "idx_assessment_submissions_created_by" ON "app"."assessment_submissions"("created_by");
CREATE INDEX "idx_assessment_submissions_updated_by" ON "app"."assessment_submissions"("updated_by");
CREATE INDEX "idx_assessment_submission_files_asset_id" ON "app"."assessment_submission_files"("asset_id");
CREATE INDEX "idx_assessment_submission_files_created_by" ON "app"."assessment_submission_files"("created_by");
CREATE INDEX "idx_assessment_submission_files_updated_by" ON "app"."assessment_submission_files"("updated_by");
CREATE INDEX "idx_assessment_submission_members_person_id" ON "app"."assessment_submission_members"("person_id");
CREATE INDEX "idx_assessment_submission_members_created_by" ON "app"."assessment_submission_members"("created_by");
CREATE INDEX "idx_assessment_submission_members_updated_by" ON "app"."assessment_submission_members"("updated_by");
CREATE INDEX "idx_assessment_attempt_answers_question_id" ON "app"."assessment_attempt_answers"("question_id");
CREATE INDEX "idx_assessment_attempt_answers_graded_by" ON "app"."assessment_attempt_answers"("graded_by");
CREATE INDEX "idx_assessment_attempt_answers_created_by" ON "app"."assessment_attempt_answers"("created_by");
CREATE INDEX "idx_assessment_attempt_answers_updated_by" ON "app"."assessment_attempt_answers"("updated_by");
CREATE INDEX "idx_assessment_criterion_scores_submission_id" ON "app"."assessment_criterion_scores"("submission_id");
CREATE INDEX "idx_assessment_criterion_scores_criterion_id" ON "app"."assessment_criterion_scores"("criterion_id");
CREATE INDEX "idx_assessment_criterion_scores_person_id" ON "app"."assessment_criterion_scores"("person_id");
CREATE INDEX "idx_assessment_criterion_scores_created_by" ON "app"."assessment_criterion_scores"("created_by");
CREATE INDEX "idx_assessment_criterion_scores_updated_by" ON "app"."assessment_criterion_scores"("updated_by");
CREATE INDEX "idx_assessment_grade_changes_submission_id" ON "app"."assessment_grade_changes"("submission_id");
CREATE INDEX "idx_assessment_grade_changes_changed_by" ON "app"."assessment_grade_changes"("changed_by");
CREATE INDEX "idx_assessment_grade_changes_created_by" ON "app"."assessment_grade_changes"("created_by");
CREATE INDEX "idx_assessment_grade_changes_updated_by" ON "app"."assessment_grade_changes"("updated_by");
CREATE INDEX "idx_academic_faculties_parent_id" ON "app"."academic_faculties"("parent_id");
CREATE INDEX "idx_academic_faculties_created_by" ON "app"."academic_faculties"("created_by");
CREATE INDEX "idx_academic_faculties_updated_by" ON "app"."academic_faculties"("updated_by");
CREATE INDEX "idx_academic_programs_faculty_id" ON "app"."academic_programs"("faculty_id");
CREATE INDEX "idx_academic_programs_created_by" ON "app"."academic_programs"("created_by");
CREATE INDEX "idx_academic_programs_updated_by" ON "app"."academic_programs"("updated_by");
CREATE INDEX "idx_academic_curricula_created_by" ON "app"."academic_curricula"("created_by");
CREATE INDEX "idx_academic_curricula_updated_by" ON "app"."academic_curricula"("updated_by");
CREATE INDEX "idx_academic_curriculum_courses_course_id" ON "app"."academic_curriculum_courses"("course_id");
CREATE INDEX "idx_academic_curriculum_courses_created_by" ON "app"."academic_curriculum_courses"("created_by");
CREATE INDEX "idx_academic_curriculum_courses_updated_by" ON "app"."academic_curriculum_courses"("updated_by");
CREATE INDEX "idx_academic_curriculum_prerequisites_prerequisite_course_id" ON "app"."academic_curriculum_prerequisites"("prerequisite_course_id");
CREATE INDEX "idx_academic_curriculum_prerequisites_created_by" ON "app"."academic_curriculum_prerequisites"("created_by");
CREATE INDEX "idx_academic_curriculum_prerequisites_updated_by" ON "app"."academic_curriculum_prerequisites"("updated_by");
CREATE INDEX "idx_academic_terms_created_by" ON "app"."academic_terms"("created_by");
CREATE INDEX "idx_academic_terms_updated_by" ON "app"."academic_terms"("updated_by");
CREATE INDEX "idx_academic_student_programs_person_id" ON "app"."academic_student_programs"("person_id");
CREATE INDEX "idx_academic_student_programs_curriculum_id" ON "app"."academic_student_programs"("curriculum_id");
CREATE INDEX "idx_academic_student_programs_site_id" ON "app"."academic_student_programs"("site_id");
CREATE INDEX "idx_academic_student_programs_created_by" ON "app"."academic_student_programs"("created_by");
CREATE INDEX "idx_academic_student_programs_updated_by" ON "app"."academic_student_programs"("updated_by");
CREATE INDEX "idx_academic_admission_applications_program_id" ON "app"."academic_admission_applications"("program_id");
CREATE INDEX "idx_academic_admission_applications_person_id" ON "app"."academic_admission_applications"("person_id");
CREATE INDEX "idx_academic_admission_applications_term_id" ON "app"."academic_admission_applications"("term_id");
CREATE INDEX "idx_academic_admission_applications_created_by" ON "app"."academic_admission_applications"("created_by");
CREATE INDEX "idx_academic_admission_applications_updated_by" ON "app"."academic_admission_applications"("updated_by");
CREATE INDEX "idx_academic_admission_requirements_created_by" ON "app"."academic_admission_requirements"("created_by");
CREATE INDEX "idx_academic_admission_requirements_updated_by" ON "app"."academic_admission_requirements"("updated_by");
CREATE INDEX "idx_academic_application_documents_application_id" ON "app"."academic_application_documents"("application_id");
CREATE INDEX "idx_academic_application_documents_requirement_id" ON "app"."academic_application_documents"("requirement_id");
CREATE INDEX "idx_academic_application_documents_asset_id" ON "app"."academic_application_documents"("asset_id");
CREATE INDEX "idx_academic_application_documents_reviewed_by" ON "app"."academic_application_documents"("reviewed_by");
CREATE INDEX "idx_academic_application_documents_created_by" ON "app"."academic_application_documents"("created_by");
CREATE INDEX "idx_academic_application_documents_updated_by" ON "app"."academic_application_documents"("updated_by");
CREATE INDEX "idx_academic_registrations_term_id" ON "app"."academic_registrations"("term_id");
CREATE INDEX "idx_academic_registrations_created_by" ON "app"."academic_registrations"("created_by");
CREATE INDEX "idx_academic_registrations_updated_by" ON "app"."academic_registrations"("updated_by");
CREATE INDEX "idx_academic_sections_course_id" ON "app"."academic_sections"("course_id");
CREATE INDEX "idx_academic_sections_term_id" ON "app"."academic_sections"("term_id");
CREATE INDEX "idx_academic_sections_cohort_id" ON "app"."academic_sections"("cohort_id");
CREATE INDEX "idx_academic_sections_site_id" ON "app"."academic_sections"("site_id");
CREATE INDEX "idx_academic_sections_created_by" ON "app"."academic_sections"("created_by");
CREATE INDEX "idx_academic_sections_updated_by" ON "app"."academic_sections"("updated_by");
CREATE INDEX "idx_academic_section_instructors_person_id" ON "app"."academic_section_instructors"("person_id");
CREATE INDEX "idx_academic_section_instructors_created_by" ON "app"."academic_section_instructors"("created_by");
CREATE INDEX "idx_academic_section_instructors_updated_by" ON "app"."academic_section_instructors"("updated_by");
CREATE INDEX "idx_academic_section_enrollments_section_id" ON "app"."academic_section_enrollments"("section_id");
CREATE INDEX "idx_academic_section_enrollments_created_by" ON "app"."academic_section_enrollments"("created_by");
CREATE INDEX "idx_academic_section_enrollments_updated_by" ON "app"."academic_section_enrollments"("updated_by");
CREATE INDEX "idx_academic_class_sessions_recording_id" ON "app"."academic_class_sessions"("recording_id");
CREATE INDEX "idx_academic_class_sessions_created_by" ON "app"."academic_class_sessions"("created_by");
CREATE INDEX "idx_academic_class_sessions_updated_by" ON "app"."academic_class_sessions"("updated_by");
CREATE INDEX "idx_academic_attendance_person_id" ON "app"."academic_attendance"("person_id");
CREATE INDEX "idx_academic_attendance_marked_by" ON "app"."academic_attendance"("marked_by");
CREATE INDEX "idx_academic_attendance_created_by" ON "app"."academic_attendance"("created_by");
CREATE INDEX "idx_academic_attendance_updated_by" ON "app"."academic_attendance"("updated_by");
CREATE INDEX "idx_academic_gradebook_items_assessment_id" ON "app"."academic_gradebook_items"("assessment_id");
CREATE INDEX "idx_academic_gradebook_items_created_by" ON "app"."academic_gradebook_items"("created_by");
CREATE INDEX "idx_academic_gradebook_items_updated_by" ON "app"."academic_gradebook_items"("updated_by");
CREATE INDEX "idx_academic_gradebook_scores_section_enrollment_id" ON "app"."academic_gradebook_scores"("section_enrollment_id");
CREATE INDEX "idx_academic_gradebook_scores_created_by" ON "app"."academic_gradebook_scores"("created_by");
CREATE INDEX "idx_academic_gradebook_scores_updated_by" ON "app"."academic_gradebook_scores"("updated_by");
CREATE INDEX "idx_academic_grade_appeals_section_enrollment_id" ON "app"."academic_grade_appeals"("section_enrollment_id");
CREATE INDEX "idx_academic_grade_appeals_gradebook_item_id" ON "app"."academic_grade_appeals"("gradebook_item_id");
CREATE INDEX "idx_academic_grade_appeals_resolved_by" ON "app"."academic_grade_appeals"("resolved_by");
CREATE INDEX "idx_academic_grade_appeals_created_by" ON "app"."academic_grade_appeals"("created_by");
CREATE INDEX "idx_academic_grade_appeals_updated_by" ON "app"."academic_grade_appeals"("updated_by");
CREATE INDEX "idx_academic_credit_recognitions_student_program_id" ON "app"."academic_credit_recognitions"("student_program_id");
CREATE INDEX "idx_academic_credit_recognitions_curriculum_course_id" ON "app"."academic_credit_recognitions"("curriculum_course_id");
CREATE INDEX "idx_academic_credit_recognitions_approved_by" ON "app"."academic_credit_recognitions"("approved_by");
CREATE INDEX "idx_academic_credit_recognitions_created_by" ON "app"."academic_credit_recognitions"("created_by");
CREATE INDEX "idx_academic_credit_recognitions_updated_by" ON "app"."academic_credit_recognitions"("updated_by");
CREATE INDEX "idx_academic_academic_records_student_program_id" ON "app"."academic_academic_records"("student_program_id");
CREATE INDEX "idx_academic_academic_records_section_enrollment_id" ON "app"."academic_academic_records"("section_enrollment_id");
CREATE INDEX "idx_academic_academic_records_curriculum_course_id" ON "app"."academic_academic_records"("curriculum_course_id");
CREATE INDEX "idx_academic_academic_records_term_id" ON "app"."academic_academic_records"("term_id");
CREATE INDEX "idx_academic_academic_records_created_by" ON "app"."academic_academic_records"("created_by");
CREATE INDEX "idx_academic_academic_records_updated_by" ON "app"."academic_academic_records"("updated_by");
CREATE INDEX "idx_academic_degree_applications_student_program_id" ON "app"."academic_degree_applications"("student_program_id");
CREATE INDEX "idx_academic_degree_applications_document_id" ON "app"."academic_degree_applications"("document_id");
CREATE INDEX "idx_academic_degree_applications_created_by" ON "app"."academic_degree_applications"("created_by");
CREATE INDEX "idx_academic_degree_applications_updated_by" ON "app"."academic_degree_applications"("updated_by");
CREATE INDEX "idx_social_communities_organization_id" ON "app"."social_communities"("organization_id");
CREATE INDEX "idx_social_communities_owner_id" ON "app"."social_communities"("owner_id");
CREATE INDEX "idx_social_communities_cover_asset_id" ON "app"."social_communities"("cover_asset_id");
CREATE INDEX "idx_social_communities_created_by" ON "app"."social_communities"("created_by");
CREATE INDEX "idx_social_communities_updated_by" ON "app"."social_communities"("updated_by");
CREATE INDEX "idx_social_community_members_person_id" ON "app"."social_community_members"("person_id");
CREATE INDEX "idx_social_community_members_created_by" ON "app"."social_community_members"("created_by");
CREATE INDEX "idx_social_community_members_updated_by" ON "app"."social_community_members"("updated_by");
CREATE INDEX "idx_social_community_join_requests_community_id" ON "app"."social_community_join_requests"("community_id");
CREATE INDEX "idx_social_community_join_requests_person_id" ON "app"."social_community_join_requests"("person_id");
CREATE INDEX "idx_social_community_join_requests_reviewed_by" ON "app"."social_community_join_requests"("reviewed_by");
CREATE INDEX "idx_social_community_join_requests_created_by" ON "app"."social_community_join_requests"("created_by");
CREATE INDEX "idx_social_community_join_requests_updated_by" ON "app"."social_community_join_requests"("updated_by");
CREATE INDEX "idx_social_community_rules_created_by" ON "app"."social_community_rules"("created_by");
CREATE INDEX "idx_social_community_rules_updated_by" ON "app"."social_community_rules"("updated_by");
CREATE INDEX "idx_social_groups_community_id" ON "app"."social_groups"("community_id");
CREATE INDEX "idx_social_groups_created_by" ON "app"."social_groups"("created_by");
CREATE INDEX "idx_social_groups_updated_by" ON "app"."social_groups"("updated_by");
CREATE INDEX "idx_social_group_members_person_id" ON "app"."social_group_members"("person_id");
CREATE INDEX "idx_social_group_members_created_by" ON "app"."social_group_members"("created_by");
CREATE INDEX "idx_social_group_members_updated_by" ON "app"."social_group_members"("updated_by");
CREATE INDEX "idx_social_channels_community_id" ON "app"."social_channels"("community_id");
CREATE INDEX "idx_social_channels_created_by" ON "app"."social_channels"("created_by");
CREATE INDEX "idx_social_channels_updated_by" ON "app"."social_channels"("updated_by");
CREATE INDEX "idx_social_channel_subscribers_person_id" ON "app"."social_channel_subscribers"("person_id");
CREATE INDEX "idx_social_channel_subscribers_created_by" ON "app"."social_channel_subscribers"("created_by");
CREATE INDEX "idx_social_channel_subscribers_updated_by" ON "app"."social_channel_subscribers"("updated_by");
CREATE INDEX "idx_social_posts_community_id" ON "app"."social_posts"("community_id");
CREATE INDEX "idx_social_posts_author_id" ON "app"."social_posts"("author_id");
CREATE INDEX "idx_social_posts_course_id" ON "app"."social_posts"("course_id");
CREATE INDEX "idx_social_posts_resource_id" ON "app"."social_posts"("resource_id");
CREATE INDEX "idx_social_posts_created_by" ON "app"."social_posts"("created_by");
CREATE INDEX "idx_social_posts_updated_by" ON "app"."social_posts"("updated_by");
CREATE INDEX "idx_social_post_attachments_asset_id" ON "app"."social_post_attachments"("asset_id");
CREATE INDEX "idx_social_post_attachments_created_by" ON "app"."social_post_attachments"("created_by");
CREATE INDEX "idx_social_post_attachments_updated_by" ON "app"."social_post_attachments"("updated_by");
CREATE INDEX "idx_social_post_comments_post_id" ON "app"."social_post_comments"("post_id");
CREATE INDEX "idx_social_post_comments_parent_id" ON "app"."social_post_comments"("parent_id");
CREATE INDEX "idx_social_post_comments_author_id" ON "app"."social_post_comments"("author_id");
CREATE INDEX "idx_social_post_comments_created_by" ON "app"."social_post_comments"("created_by");
CREATE INDEX "idx_social_post_comments_updated_by" ON "app"."social_post_comments"("updated_by");
CREATE INDEX "idx_social_post_reactions_person_id" ON "app"."social_post_reactions"("person_id");
CREATE INDEX "idx_social_post_reactions_created_by" ON "app"."social_post_reactions"("created_by");
CREATE INDEX "idx_social_post_reactions_updated_by" ON "app"."social_post_reactions"("updated_by");
CREATE INDEX "idx_social_qa_questions_community_id" ON "app"."social_qa_questions"("community_id");
CREATE INDEX "idx_social_qa_questions_author_id" ON "app"."social_qa_questions"("author_id");
CREATE INDEX "idx_social_qa_questions_accepted_answer_id" ON "app"."social_qa_questions"("accepted_answer_id");
CREATE INDEX "idx_social_qa_questions_created_by" ON "app"."social_qa_questions"("created_by");
CREATE INDEX "idx_social_qa_questions_updated_by" ON "app"."social_qa_questions"("updated_by");
CREATE INDEX "idx_social_qa_answers_question_id" ON "app"."social_qa_answers"("question_id");
CREATE INDEX "idx_social_qa_answers_author_id" ON "app"."social_qa_answers"("author_id");
CREATE INDEX "idx_social_qa_answers_created_by" ON "app"."social_qa_answers"("created_by");
CREATE INDEX "idx_social_qa_answers_updated_by" ON "app"."social_qa_answers"("updated_by");
CREATE INDEX "idx_social_qa_votes_person_id" ON "app"."social_qa_votes"("person_id");
CREATE INDEX "idx_social_qa_votes_created_by" ON "app"."social_qa_votes"("created_by");
CREATE INDEX "idx_social_qa_votes_updated_by" ON "app"."social_qa_votes"("updated_by");
CREATE INDEX "idx_social_reputation_ledger_person_id" ON "app"."social_reputation_ledger"("person_id");
CREATE INDEX "idx_social_reputation_ledger_community_id" ON "app"."social_reputation_ledger"("community_id");
CREATE INDEX "idx_social_reputation_ledger_created_by" ON "app"."social_reputation_ledger"("created_by");
CREATE INDEX "idx_social_reputation_ledger_updated_by" ON "app"."social_reputation_ledger"("updated_by");
CREATE INDEX "idx_social_course_forums_cohort_id" ON "app"."social_course_forums"("cohort_id");
CREATE INDEX "idx_social_course_forums_created_by" ON "app"."social_course_forums"("created_by");
CREATE INDEX "idx_social_course_forums_updated_by" ON "app"."social_course_forums"("updated_by");
CREATE INDEX "idx_social_forum_threads_forum_id" ON "app"."social_forum_threads"("forum_id");
CREATE INDEX "idx_social_forum_threads_author_id" ON "app"."social_forum_threads"("author_id");
CREATE INDEX "idx_social_forum_threads_created_by" ON "app"."social_forum_threads"("created_by");
CREATE INDEX "idx_social_forum_threads_updated_by" ON "app"."social_forum_threads"("updated_by");
CREATE INDEX "idx_social_forum_replies_thread_id" ON "app"."social_forum_replies"("thread_id");
CREATE INDEX "idx_social_forum_replies_author_id" ON "app"."social_forum_replies"("author_id");
CREATE INDEX "idx_social_forum_replies_parent_id" ON "app"."social_forum_replies"("parent_id");
CREATE INDEX "idx_social_forum_replies_created_by" ON "app"."social_forum_replies"("created_by");
CREATE INDEX "idx_social_forum_replies_updated_by" ON "app"."social_forum_replies"("updated_by");
CREATE INDEX "idx_social_chat_rooms_cohort_id" ON "app"."social_chat_rooms"("cohort_id");
CREATE INDEX "idx_social_chat_rooms_group_id" ON "app"."social_chat_rooms"("group_id");
CREATE INDEX "idx_social_chat_rooms_channel_id" ON "app"."social_chat_rooms"("channel_id");
CREATE INDEX "idx_social_chat_rooms_created_by" ON "app"."social_chat_rooms"("created_by");
CREATE INDEX "idx_social_chat_rooms_updated_by" ON "app"."social_chat_rooms"("updated_by");
CREATE INDEX "idx_social_chat_members_person_id" ON "app"."social_chat_members"("person_id");
CREATE INDEX "idx_social_chat_members_created_by" ON "app"."social_chat_members"("created_by");
CREATE INDEX "idx_social_chat_members_updated_by" ON "app"."social_chat_members"("updated_by");
CREATE INDEX "idx_social_chat_messages_sender_id" ON "app"."social_chat_messages"("sender_id");
CREATE INDEX "idx_social_chat_messages_reply_to_id" ON "app"."social_chat_messages"("reply_to_id");
CREATE INDEX "idx_social_chat_messages_asset_id" ON "app"."social_chat_messages"("asset_id");
CREATE INDEX "idx_social_chat_messages_created_by" ON "app"."social_chat_messages"("created_by");
CREATE INDEX "idx_social_chat_messages_updated_by" ON "app"."social_chat_messages"("updated_by");
CREATE INDEX "idx_social_moderation_reports_reporter_id" ON "app"."social_moderation_reports"("reporter_id");
CREATE INDEX "idx_social_moderation_reports_community_id" ON "app"."social_moderation_reports"("community_id");
CREATE INDEX "idx_social_moderation_reports_created_by" ON "app"."social_moderation_reports"("created_by");
CREATE INDEX "idx_social_moderation_reports_updated_by" ON "app"."social_moderation_reports"("updated_by");
CREATE INDEX "idx_social_moderation_actions_report_id" ON "app"."social_moderation_actions"("report_id");
CREATE INDEX "idx_social_moderation_actions_moderator_id" ON "app"."social_moderation_actions"("moderator_id");
CREATE INDEX "idx_social_moderation_actions_created_by" ON "app"."social_moderation_actions"("created_by");
CREATE INDEX "idx_social_moderation_actions_updated_by" ON "app"."social_moderation_actions"("updated_by");
CREATE INDEX "idx_social_bot_agents_organization_id" ON "app"."social_bot_agents"("organization_id");
CREATE INDEX "idx_social_bot_agents_community_id" ON "app"."social_bot_agents"("community_id");
CREATE INDEX "idx_social_bot_agents_created_by" ON "app"."social_bot_agents"("created_by");
CREATE INDEX "idx_social_bot_agents_updated_by" ON "app"."social_bot_agents"("updated_by");
CREATE INDEX "idx_social_bot_runs_agent_id" ON "app"."social_bot_runs"("agent_id");
CREATE INDEX "idx_social_bot_runs_created_by" ON "app"."social_bot_runs"("created_by");
CREATE INDEX "idx_social_bot_runs_updated_by" ON "app"."social_bot_runs"("updated_by");
CREATE INDEX "idx_social_saved_lists_created_by" ON "app"."social_saved_lists"("created_by");
CREATE INDEX "idx_social_saved_lists_updated_by" ON "app"."social_saved_lists"("updated_by");
CREATE INDEX "idx_social_saved_list_items_list_id" ON "app"."social_saved_list_items"("list_id");
CREATE INDEX "idx_social_saved_list_items_community_id" ON "app"."social_saved_list_items"("community_id");
CREATE INDEX "idx_social_saved_list_items_room_id" ON "app"."social_saved_list_items"("room_id");
CREATE INDEX "idx_social_saved_list_items_created_by" ON "app"."social_saved_list_items"("created_by");
CREATE INDEX "idx_social_saved_list_items_updated_by" ON "app"."social_saved_list_items"("updated_by");
CREATE INDEX "idx_calendar_calendars_owner_person_id" ON "app"."calendar_calendars"("owner_person_id");
CREATE INDEX "idx_calendar_calendars_organization_id" ON "app"."calendar_calendars"("organization_id");
CREATE INDEX "idx_calendar_calendars_cohort_id" ON "app"."calendar_calendars"("cohort_id");
CREATE INDEX "idx_calendar_calendars_created_by" ON "app"."calendar_calendars"("created_by");
CREATE INDEX "idx_calendar_calendars_updated_by" ON "app"."calendar_calendars"("updated_by");
CREATE INDEX "idx_calendar_events_calendar_id" ON "app"."calendar_events"("calendar_id");
CREATE INDEX "idx_calendar_events_course_id" ON "app"."calendar_events"("course_id");
CREATE INDEX "idx_calendar_events_section_id" ON "app"."calendar_events"("section_id");
CREATE INDEX "idx_calendar_events_assessment_id" ON "app"."calendar_events"("assessment_id");
CREATE INDEX "idx_calendar_events_created_for_person_id" ON "app"."calendar_events"("created_for_person_id");
CREATE INDEX "idx_calendar_events_created_by" ON "app"."calendar_events"("created_by");
CREATE INDEX "idx_calendar_events_updated_by" ON "app"."calendar_events"("updated_by");
CREATE INDEX "idx_calendar_event_recurrences_created_by" ON "app"."calendar_event_recurrences"("created_by");
CREATE INDEX "idx_calendar_event_recurrences_updated_by" ON "app"."calendar_event_recurrences"("updated_by");
CREATE INDEX "idx_calendar_event_attendees_person_id" ON "app"."calendar_event_attendees"("person_id");
CREATE INDEX "idx_calendar_event_attendees_created_by" ON "app"."calendar_event_attendees"("created_by");
CREATE INDEX "idx_calendar_event_attendees_updated_by" ON "app"."calendar_event_attendees"("updated_by");
CREATE INDEX "idx_calendar_reminders_person_id" ON "app"."calendar_reminders"("person_id");
CREATE INDEX "idx_calendar_reminders_event_id" ON "app"."calendar_reminders"("event_id");
CREATE INDEX "idx_calendar_reminders_created_by" ON "app"."calendar_reminders"("created_by");
CREATE INDEX "idx_calendar_reminders_updated_by" ON "app"."calendar_reminders"("updated_by");
CREATE INDEX "idx_calendar_calendar_subscriptions_calendar_id" ON "app"."calendar_calendar_subscriptions"("calendar_id");
CREATE INDEX "idx_calendar_calendar_subscriptions_created_by" ON "app"."calendar_calendar_subscriptions"("created_by");
CREATE INDEX "idx_calendar_calendar_subscriptions_updated_by" ON "app"."calendar_calendar_subscriptions"("updated_by");
CREATE INDEX "idx_communication_notifications_person_id" ON "app"."communication_notifications"("person_id");
CREATE INDEX "idx_communication_notifications_organization_id" ON "app"."communication_notifications"("organization_id");
CREATE INDEX "idx_communication_notifications_created_by" ON "app"."communication_notifications"("created_by");
CREATE INDEX "idx_communication_notifications_updated_by" ON "app"."communication_notifications"("updated_by");
CREATE INDEX "idx_communication_notification_preferences_person_id" ON "app"."communication_notification_preferences"("person_id");
CREATE INDEX "idx_communication_notification_preferences_organization_id" ON "app"."communication_notification_preferences"("organization_id");
CREATE INDEX "idx_communication_notification_preferences_created_by" ON "app"."communication_notification_preferences"("created_by");
CREATE INDEX "idx_communication_notification_preferences_updated_by" ON "app"."communication_notification_preferences"("updated_by");
CREATE INDEX "idx_communication_notification_deliveries_notification_id" ON "app"."communication_notification_deliveries"("notification_id");
CREATE INDEX "idx_communication_notification_deliveries_created_by" ON "app"."communication_notification_deliveries"("created_by");
CREATE INDEX "idx_communication_notification_deliveries_updated_by" ON "app"."communication_notification_deliveries"("updated_by");
CREATE INDEX "idx_communication_ai_conversations_person_id" ON "app"."communication_ai_conversations"("person_id");
CREATE INDEX "idx_communication_ai_conversations_course_id" ON "app"."communication_ai_conversations"("course_id");
CREATE INDEX "idx_communication_ai_conversations_cohort_id" ON "app"."communication_ai_conversations"("cohort_id");
CREATE INDEX "idx_communication_ai_conversations_organization_id" ON "app"."communication_ai_conversations"("organization_id");
CREATE INDEX "idx_communication_ai_conversations_created_by" ON "app"."communication_ai_conversations"("created_by");
CREATE INDEX "idx_communication_ai_conversations_updated_by" ON "app"."communication_ai_conversations"("updated_by");
CREATE INDEX "idx_communication_ai_messages_conversation_id" ON "app"."communication_ai_messages"("conversation_id");
CREATE INDEX "idx_communication_ai_messages_created_by" ON "app"."communication_ai_messages"("created_by");
CREATE INDEX "idx_communication_ai_messages_updated_by" ON "app"."communication_ai_messages"("updated_by");
CREATE INDEX "idx_communication_ai_usage_person_id" ON "app"."communication_ai_usage"("person_id");
CREATE INDEX "idx_communication_ai_usage_organization_id" ON "app"."communication_ai_usage"("organization_id");
CREATE INDEX "idx_communication_ai_usage_created_by" ON "app"."communication_ai_usage"("created_by");
CREATE INDEX "idx_communication_ai_usage_updated_by" ON "app"."communication_ai_usage"("updated_by");
CREATE INDEX "idx_content_interactive_2d_asset_id" ON "app"."content_interactive_2d"("asset_id");
CREATE INDEX "idx_content_interactive_2d_created_by" ON "app"."content_interactive_2d"("created_by");
CREATE INDEX "idx_content_interactive_2d_updated_by" ON "app"."content_interactive_2d"("updated_by");
CREATE INDEX "idx_content_interactive_hotspots_resource_id" ON "app"."content_interactive_hotspots"("resource_id");
CREATE INDEX "idx_content_interactive_hotspots_course_id" ON "app"."content_interactive_hotspots"("course_id");
CREATE INDEX "idx_content_interactive_hotspots_created_by" ON "app"."content_interactive_hotspots"("created_by");
CREATE INDEX "idx_content_interactive_hotspots_updated_by" ON "app"."content_interactive_hotspots"("updated_by");
CREATE INDEX "idx_content_models_3d_model_asset_id" ON "app"."content_models_3d"("model_asset_id");
CREATE INDEX "idx_content_models_3d_created_by" ON "app"."content_models_3d"("created_by");
CREATE INDEX "idx_content_models_3d_updated_by" ON "app"."content_models_3d"("updated_by");
CREATE INDEX "idx_content_model_annotations_model_id" ON "app"."content_model_annotations"("model_id");
CREATE INDEX "idx_content_model_annotations_created_by" ON "app"."content_model_annotations"("created_by");
CREATE INDEX "idx_content_model_annotations_updated_by" ON "app"."content_model_annotations"("updated_by");
CREATE INDEX "idx_content_simulators_organization_id" ON "app"."content_simulators"("organization_id");
CREATE INDEX "idx_content_simulators_owner_id" ON "app"."content_simulators"("owner_id");
CREATE INDEX "idx_content_simulators_created_by" ON "app"."content_simulators"("created_by");
CREATE INDEX "idx_content_simulators_updated_by" ON "app"."content_simulators"("updated_by");
CREATE INDEX "idx_content_simulator_parameters_created_by" ON "app"."content_simulator_parameters"("created_by");
CREATE INDEX "idx_content_simulator_parameters_updated_by" ON "app"."content_simulator_parameters"("updated_by");
CREATE INDEX "idx_content_simulator_experiments_simulator_id" ON "app"."content_simulator_experiments"("simulator_id");
CREATE INDEX "idx_content_simulator_experiments_course_id" ON "app"."content_simulator_experiments"("course_id");
CREATE INDEX "idx_content_simulator_experiments_lesson_id" ON "app"."content_simulator_experiments"("lesson_id");
CREATE INDEX "idx_content_simulator_experiments_created_by" ON "app"."content_simulator_experiments"("created_by");
CREATE INDEX "idx_content_simulator_experiments_updated_by" ON "app"."content_simulator_experiments"("updated_by");
CREATE INDEX "idx_content_simulation_runs_experiment_id" ON "app"."content_simulation_runs"("experiment_id");
CREATE INDEX "idx_content_simulation_runs_person_id" ON "app"."content_simulation_runs"("person_id");
CREATE INDEX "idx_content_simulation_runs_created_by" ON "app"."content_simulation_runs"("created_by");
CREATE INDEX "idx_content_simulation_runs_updated_by" ON "app"."content_simulation_runs"("updated_by");
CREATE INDEX "idx_platform_plans_created_by" ON "app"."platform_plans"("created_by");
CREATE INDEX "idx_platform_plans_updated_by" ON "app"."platform_plans"("updated_by");
CREATE INDEX "idx_platform_features_created_by" ON "app"."platform_features"("created_by");
CREATE INDEX "idx_platform_features_updated_by" ON "app"."platform_features"("updated_by");
CREATE INDEX "idx_platform_plan_entitlements_feature_id" ON "app"."platform_plan_entitlements"("feature_id");
CREATE INDEX "idx_platform_plan_entitlements_created_by" ON "app"."platform_plan_entitlements"("created_by");
CREATE INDEX "idx_platform_plan_entitlements_updated_by" ON "app"."platform_plan_entitlements"("updated_by");
CREATE INDEX "idx_platform_plan_prices_created_by" ON "app"."platform_plan_prices"("created_by");
CREATE INDEX "idx_platform_plan_prices_updated_by" ON "app"."platform_plan_prices"("updated_by");
CREATE INDEX "idx_platform_subscriptions_plan_id" ON "app"."platform_subscriptions"("plan_id");
CREATE INDEX "idx_platform_subscriptions_person_id" ON "app"."platform_subscriptions"("person_id");
CREATE INDEX "idx_platform_subscriptions_organization_id" ON "app"."platform_subscriptions"("organization_id");
CREATE INDEX "idx_platform_subscriptions_created_by" ON "app"."platform_subscriptions"("created_by");
CREATE INDEX "idx_platform_subscriptions_updated_by" ON "app"."platform_subscriptions"("updated_by");
CREATE INDEX "idx_platform_subscription_usage_feature_id" ON "app"."platform_subscription_usage"("feature_id");
CREATE INDEX "idx_platform_subscription_usage_created_by" ON "app"."platform_subscription_usage"("created_by");
CREATE INDEX "idx_platform_subscription_usage_updated_by" ON "app"."platform_subscription_usage"("updated_by");
CREATE INDEX "idx_platform_checkout_orders_subscription_id" ON "app"."platform_checkout_orders"("subscription_id");
CREATE INDEX "idx_platform_checkout_orders_buyer_person_id" ON "app"."platform_checkout_orders"("buyer_person_id");
CREATE INDEX "idx_platform_checkout_orders_organization_id" ON "app"."platform_checkout_orders"("organization_id");
CREATE INDEX "idx_platform_checkout_orders_created_by" ON "app"."platform_checkout_orders"("created_by");
CREATE INDEX "idx_platform_checkout_orders_updated_by" ON "app"."platform_checkout_orders"("updated_by");
CREATE INDEX "idx_platform_platform_payments_order_id" ON "app"."platform_platform_payments"("order_id");
CREATE INDEX "idx_platform_platform_payments_created_by" ON "app"."platform_platform_payments"("created_by");
CREATE INDEX "idx_platform_platform_payments_updated_by" ON "app"."platform_platform_payments"("updated_by");
CREATE INDEX "idx_platform_ad_campaigns_created_by" ON "app"."platform_ad_campaigns"("created_by");
CREATE INDEX "idx_platform_ad_campaigns_updated_by" ON "app"."platform_ad_campaigns"("updated_by");
CREATE INDEX "idx_platform_ad_creatives_campaign_id" ON "app"."platform_ad_creatives"("campaign_id");
CREATE INDEX "idx_platform_ad_creatives_asset_id" ON "app"."platform_ad_creatives"("asset_id");
CREATE INDEX "idx_platform_ad_creatives_created_by" ON "app"."platform_ad_creatives"("created_by");
CREATE INDEX "idx_platform_ad_creatives_updated_by" ON "app"."platform_ad_creatives"("updated_by");
CREATE INDEX "idx_platform_ad_placements_created_by" ON "app"."platform_ad_placements"("created_by");
CREATE INDEX "idx_platform_ad_placements_updated_by" ON "app"."platform_ad_placements"("updated_by");
CREATE INDEX "idx_platform_ad_events_campaign_id" ON "app"."platform_ad_events"("campaign_id");
CREATE INDEX "idx_platform_ad_events_creative_id" ON "app"."platform_ad_events"("creative_id");
CREATE INDEX "idx_platform_ad_events_placement_id" ON "app"."platform_ad_events"("placement_id");
CREATE INDEX "idx_platform_ad_events_person_id" ON "app"."platform_ad_events"("person_id");
CREATE INDEX "idx_platform_ad_events_created_by" ON "app"."platform_ad_events"("created_by");
CREATE INDEX "idx_platform_ad_events_updated_by" ON "app"."platform_ad_events"("updated_by");
CREATE INDEX "idx_finance_tuition_schedules_term_id" ON "app"."finance_tuition_schedules"("term_id");
CREATE INDEX "idx_finance_tuition_schedules_program_id" ON "app"."finance_tuition_schedules"("program_id");
CREATE INDEX "idx_finance_tuition_schedules_created_by" ON "app"."finance_tuition_schedules"("created_by");
CREATE INDEX "idx_finance_tuition_schedules_updated_by" ON "app"."finance_tuition_schedules"("updated_by");
CREATE INDEX "idx_finance_student_accounts_organization_id" ON "app"."finance_student_accounts"("organization_id");
CREATE INDEX "idx_finance_student_accounts_created_by" ON "app"."finance_student_accounts"("created_by");
CREATE INDEX "idx_finance_student_accounts_updated_by" ON "app"."finance_student_accounts"("updated_by");
CREATE INDEX "idx_finance_student_charges_term_id" ON "app"."finance_student_charges"("term_id");
CREATE INDEX "idx_finance_student_charges_created_by" ON "app"."finance_student_charges"("created_by");
CREATE INDEX "idx_finance_student_charges_updated_by" ON "app"."finance_student_charges"("updated_by");
CREATE INDEX "idx_finance_installments_created_by" ON "app"."finance_installments"("created_by");
CREATE INDEX "idx_finance_installments_updated_by" ON "app"."finance_installments"("updated_by");
CREATE INDEX "idx_finance_student_payments_account_id" ON "app"."finance_student_payments"("account_id");
CREATE INDEX "idx_finance_student_payments_created_by" ON "app"."finance_student_payments"("created_by");
CREATE INDEX "idx_finance_student_payments_updated_by" ON "app"."finance_student_payments"("updated_by");
CREATE INDEX "idx_finance_payment_allocations_installment_id" ON "app"."finance_payment_allocations"("installment_id");
CREATE INDEX "idx_finance_payment_allocations_created_by" ON "app"."finance_payment_allocations"("created_by");
CREATE INDEX "idx_finance_payment_allocations_updated_by" ON "app"."finance_payment_allocations"("updated_by");
CREATE INDEX "idx_finance_scholarships_created_by" ON "app"."finance_scholarships"("created_by");
CREATE INDEX "idx_finance_scholarships_updated_by" ON "app"."finance_scholarships"("updated_by");
CREATE INDEX "idx_finance_scholarship_applications_scholarship_id" ON "app"."finance_scholarship_applications"("scholarship_id");
CREATE INDEX "idx_finance_scholarship_applications_student_program_id" ON "app"."finance_scholarship_applications"("student_program_id");
CREATE INDEX "idx_finance_scholarship_applications_reviewer_id" ON "app"."finance_scholarship_applications"("reviewer_id");
CREATE INDEX "idx_finance_scholarship_applications_created_by" ON "app"."finance_scholarship_applications"("created_by");
CREATE INDEX "idx_finance_scholarship_applications_updated_by" ON "app"."finance_scholarship_applications"("updated_by");
CREATE INDEX "idx_finance_scholarship_awards_application_id" ON "app"."finance_scholarship_awards"("application_id");
CREATE INDEX "idx_finance_scholarship_awards_term_id" ON "app"."finance_scholarship_awards"("term_id");
CREATE INDEX "idx_finance_scholarship_awards_created_by" ON "app"."finance_scholarship_awards"("created_by");
CREATE INDEX "idx_finance_scholarship_awards_updated_by" ON "app"."finance_scholarship_awards"("updated_by");
CREATE INDEX "idx_finance_financial_documents_organization_id" ON "app"."finance_financial_documents"("organization_id");
CREATE INDEX "idx_finance_financial_documents_payment_id" ON "app"."finance_financial_documents"("payment_id");
CREATE INDEX "idx_finance_financial_documents_asset_id" ON "app"."finance_financial_documents"("asset_id");
CREATE INDEX "idx_finance_financial_documents_created_by" ON "app"."finance_financial_documents"("created_by");
CREATE INDEX "idx_finance_financial_documents_updated_by" ON "app"."finance_financial_documents"("updated_by");
CREATE INDEX "idx_services_procedures_created_by" ON "app"."services_procedures"("created_by");
CREATE INDEX "idx_services_procedures_updated_by" ON "app"."services_procedures"("updated_by");
CREATE INDEX "idx_services_procedure_steps_created_by" ON "app"."services_procedure_steps"("created_by");
CREATE INDEX "idx_services_procedure_steps_updated_by" ON "app"."services_procedure_steps"("updated_by");
CREATE INDEX "idx_services_procedure_fields_created_by" ON "app"."services_procedure_fields"("created_by");
CREATE INDEX "idx_services_procedure_fields_updated_by" ON "app"."services_procedure_fields"("updated_by");
CREATE INDEX "idx_services_requests_procedure_id" ON "app"."services_requests"("procedure_id");
CREATE INDEX "idx_services_requests_requester_id" ON "app"."services_requests"("requester_id");
CREATE INDEX "idx_services_requests_current_step_id" ON "app"."services_requests"("current_step_id");
CREATE INDEX "idx_services_requests_created_by" ON "app"."services_requests"("created_by");
CREATE INDEX "idx_services_requests_updated_by" ON "app"."services_requests"("updated_by");
CREATE INDEX "idx_services_request_files_asset_id" ON "app"."services_request_files"("asset_id");
CREATE INDEX "idx_services_request_files_created_by" ON "app"."services_request_files"("created_by");
CREATE INDEX "idx_services_request_files_updated_by" ON "app"."services_request_files"("updated_by");
CREATE INDEX "idx_services_request_transitions_request_id" ON "app"."services_request_transitions"("request_id");
CREATE INDEX "idx_services_request_transitions_step_id" ON "app"."services_request_transitions"("step_id");
CREATE INDEX "idx_services_request_transitions_actor_id" ON "app"."services_request_transitions"("actor_id");
CREATE INDEX "idx_services_request_transitions_created_by" ON "app"."services_request_transitions"("created_by");
CREATE INDEX "idx_services_request_transitions_updated_by" ON "app"."services_request_transitions"("updated_by");
CREATE INDEX "idx_services_service_offerings_created_by" ON "app"."services_service_offerings"("created_by");
CREATE INDEX "idx_services_service_offerings_updated_by" ON "app"."services_service_offerings"("updated_by");
CREATE INDEX "idx_services_service_memberships_offering_id" ON "app"."services_service_memberships"("offering_id");
CREATE INDEX "idx_services_service_memberships_person_id" ON "app"."services_service_memberships"("person_id");
CREATE INDEX "idx_services_service_memberships_created_by" ON "app"."services_service_memberships"("created_by");
CREATE INDEX "idx_services_service_memberships_updated_by" ON "app"."services_service_memberships"("updated_by");
CREATE INDEX "idx_services_physical_assets_site_id" ON "app"."services_physical_assets"("site_id");
CREATE INDEX "idx_services_physical_assets_created_by" ON "app"."services_physical_assets"("created_by");
CREATE INDEX "idx_services_physical_assets_updated_by" ON "app"."services_physical_assets"("updated_by");
CREATE INDEX "idx_services_asset_reservations_asset_id" ON "app"."services_asset_reservations"("asset_id");
CREATE INDEX "idx_services_asset_reservations_requested_by" ON "app"."services_asset_reservations"("requested_by");
CREATE INDEX "idx_services_asset_reservations_approved_by" ON "app"."services_asset_reservations"("approved_by");
CREATE INDEX "idx_services_asset_reservations_created_by" ON "app"."services_asset_reservations"("created_by");
CREATE INDEX "idx_services_asset_reservations_updated_by" ON "app"."services_asset_reservations"("updated_by");
CREATE INDEX "idx_services_reservation_attendees_person_id" ON "app"."services_reservation_attendees"("person_id");
CREATE INDEX "idx_services_reservation_attendees_created_by" ON "app"."services_reservation_attendees"("created_by");
CREATE INDEX "idx_services_reservation_attendees_updated_by" ON "app"."services_reservation_attendees"("updated_by");
CREATE INDEX "idx_services_asset_loans_asset_id" ON "app"."services_asset_loans"("asset_id");
CREATE INDEX "idx_services_asset_loans_person_id" ON "app"."services_asset_loans"("person_id");
CREATE INDEX "idx_services_asset_loans_created_by" ON "app"."services_asset_loans"("created_by");
CREATE INDEX "idx_services_asset_loans_updated_by" ON "app"."services_asset_loans"("updated_by");
CREATE INDEX "idx_services_surveys_organization_id" ON "app"."services_surveys"("organization_id");
CREATE INDEX "idx_services_surveys_course_id" ON "app"."services_surveys"("course_id");
CREATE INDEX "idx_services_surveys_section_id" ON "app"."services_surveys"("section_id");
CREATE INDEX "idx_services_surveys_teacher_id" ON "app"."services_surveys"("teacher_id");
CREATE INDEX "idx_services_surveys_created_by" ON "app"."services_surveys"("created_by");
CREATE INDEX "idx_services_surveys_updated_by" ON "app"."services_surveys"("updated_by");
CREATE INDEX "idx_services_survey_questions_created_by" ON "app"."services_survey_questions"("created_by");
CREATE INDEX "idx_services_survey_questions_updated_by" ON "app"."services_survey_questions"("updated_by");
CREATE INDEX "idx_services_survey_responses_survey_id" ON "app"."services_survey_responses"("survey_id");
CREATE INDEX "idx_services_survey_responses_respondent_id" ON "app"."services_survey_responses"("respondent_id");
CREATE INDEX "idx_services_survey_responses_created_by" ON "app"."services_survey_responses"("created_by");
CREATE INDEX "idx_services_survey_responses_updated_by" ON "app"."services_survey_responses"("updated_by");
CREATE INDEX "idx_services_survey_answers_question_id" ON "app"."services_survey_answers"("question_id");
CREATE INDEX "idx_services_survey_answers_created_by" ON "app"."services_survey_answers"("created_by");
CREATE INDEX "idx_services_survey_answers_updated_by" ON "app"."services_survey_answers"("updated_by");
CREATE INDEX "idx_services_support_tickets_organization_id" ON "app"."services_support_tickets"("organization_id");
CREATE INDEX "idx_services_support_tickets_requester_id" ON "app"."services_support_tickets"("requester_id");
CREATE INDEX "idx_services_support_tickets_assigned_to" ON "app"."services_support_tickets"("assigned_to");
CREATE INDEX "idx_services_support_tickets_created_by" ON "app"."services_support_tickets"("created_by");
CREATE INDEX "idx_services_support_tickets_updated_by" ON "app"."services_support_tickets"("updated_by");
CREATE INDEX "idx_services_support_messages_ticket_id" ON "app"."services_support_messages"("ticket_id");
CREATE INDEX "idx_services_support_messages_author_id" ON "app"."services_support_messages"("author_id");
CREATE INDEX "idx_services_support_messages_asset_id" ON "app"."services_support_messages"("asset_id");
CREATE INDEX "idx_services_support_messages_created_by" ON "app"."services_support_messages"("created_by");
CREATE INDEX "idx_services_support_messages_updated_by" ON "app"."services_support_messages"("updated_by");
CREATE INDEX "idx_services_job_postings_organization_id" ON "app"."services_job_postings"("organization_id");
CREATE INDEX "idx_services_job_postings_created_by" ON "app"."services_job_postings"("created_by");
CREATE INDEX "idx_services_job_postings_updated_by" ON "app"."services_job_postings"("updated_by");
CREATE INDEX "idx_notifications_unread" ON "app"."communication_notifications"("person_id","created_at") WHERE "read_at" IS NULL;
CREATE INDEX "idx_enrollments_active" ON "app"."learning_enrollments"("person_id","cohort_id") WHERE "status" = 'active';
CREATE INDEX "idx_events_start" ON "app"."calendar_events"("starts_at");
CREATE INDEX "idx_chat_room_sent" ON "app"."social_chat_messages"("room_id","sent_at" DESC);
CREATE INDEX "idx_study_events_time" ON "app"."learning_learning_events"("person_id","occurred_at" DESC);
CREATE INDEX "idx_submission_due" ON "app"."assessment_assessments"("due_at") WHERE "status" = 'published';
CREATE INDEX "idx_charge_due" ON "app"."finance_installments"("due_on") WHERE "status" = 'pending';
CREATE INDEX "idx_posts_published" ON "app"."social_posts"("community_id","published_at" DESC) WHERE "status" = 'published';


-- ============================================================================
-- 4. COMENTARIOS: diccionario en PostgreSQL
-- ============================================================================

COMMENT ON TABLE "app"."core_countries" IS 'Países ISO para perfiles y sedes';
COMMENT ON COLUMN "app"."core_countries"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_countries"."iso3" IS 'Dato iso3 de app.core_countries; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_countries"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."core_countries"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_countries"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_countries"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_countries"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_regions" IS 'Departamentos o regiones políticas';
COMMENT ON COLUMN "app"."core_regions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_regions"."country_id" IS 'Vínculo referencial con app.core_countries mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_regions"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."core_regions"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."core_regions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_regions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_regions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_regions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_provinces" IS 'Provincias de una región';
COMMENT ON COLUMN "app"."core_provinces"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_provinces"."region_id" IS 'Vínculo referencial con app.core_regions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_provinces"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."core_provinces"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."core_provinces"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_provinces"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_provinces"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_provinces"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_districts" IS 'Distritos y ubigeos';
COMMENT ON COLUMN "app"."core_districts"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_districts"."province_id" IS 'Vínculo referencial con app.core_provinces mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_districts"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."core_districts"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."core_districts"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_districts"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_districts"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_districts"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_people" IS 'Personas reales independientes de cuentas y roles';
COMMENT ON COLUMN "app"."core_people"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_people"."given_names" IS 'Dato given names de app.core_people; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_people"."family_names" IS 'Dato family names de app.core_people; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_people"."document_type" IS 'Clasificación del documento de identidad o comprobante.';
COMMENT ON COLUMN "app"."core_people"."document_number" IS 'Número del documento identificado.';
COMMENT ON COLUMN "app"."core_people"."birth_date" IS 'Fecha calendario para birth date.';
COMMENT ON COLUMN "app"."core_people"."phone" IS 'Dato phone de app.core_people; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_people"."district_id" IS 'Vínculo referencial con app.core_districts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_people"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."core_people"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_people"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_people"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_people"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_profiles" IS 'Perfil público, biografía y fotografía';
COMMENT ON COLUMN "app"."core_profiles"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_profiles"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."core_profiles"."username" IS 'Nombre de usuario único.';
COMMENT ON COLUMN "app"."core_profiles"."display_name" IS 'Nombre mostrado a otros usuarios.';
COMMENT ON COLUMN "app"."core_profiles"."bio" IS 'Dato bio de app.core_profiles; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_profiles"."avatar_url" IS 'Dirección de acceso a avatar url.';
COMMENT ON COLUMN "app"."core_profiles"."headline" IS 'Dato headline de app.core_profiles; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_profiles"."study_area" IS 'Dato study area de app.core_profiles; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_profiles"."interests" IS 'Configuración estructurada interests validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."core_profiles"."skills" IS 'Configuración estructurada skills validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."core_profiles"."is_public" IS 'Indica si se permite exposición pública del elemento.';
COMMENT ON COLUMN "app"."core_profiles"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_profiles"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_profiles"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_profiles"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_user_preferences" IS 'Preferencias sincronizadas entre dispositivos';
COMMENT ON COLUMN "app"."core_user_preferences"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_user_preferences"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."core_user_preferences"."theme" IS 'Dato theme de app.core_user_preferences; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_user_preferences"."locale" IS 'Dato locale de app.core_user_preferences; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_user_preferences"."timezone" IS 'Dato timezone de app.core_user_preferences; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_user_preferences"."settings" IS 'Opciones configurables de comportamiento.';
COMMENT ON COLUMN "app"."core_user_preferences"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_user_preferences"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_user_preferences"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_user_preferences"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organizations" IS 'Instituciones, academias y otras organizaciones (tenants)';
COMMENT ON COLUMN "app"."core_organizations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organizations"."slug" IS 'Identificador corto usado en direcciones y búsquedas.';
COMMENT ON COLUMN "app"."core_organizations"."legal_name" IS 'Dato legal name de app.core_organizations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organizations"."display_name" IS 'Nombre mostrado a otros usuarios.';
COMMENT ON COLUMN "app"."core_organizations"."organization_type" IS 'Dato organization type de app.core_organizations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organizations"."tax_identifier" IS 'Dato tax identifier de app.core_organizations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organizations"."logo_url" IS 'Dirección de acceso a logo url.';
COMMENT ON COLUMN "app"."core_organizations"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."core_organizations"."owner_person_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_organizations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organizations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organizations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organizations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organization_sites" IS 'Sedes y campus físicos o virtuales';
COMMENT ON COLUMN "app"."core_organization_sites"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organization_sites"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_organization_sites"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."core_organization_sites"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."core_organization_sites"."district_id" IS 'Vínculo referencial con app.core_districts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_organization_sites"."address" IS 'Dato address de app.core_organization_sites; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_sites"."latitude" IS 'Dato latitude de app.core_organization_sites; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_sites"."longitude" IS 'Dato longitude de app.core_organization_sites; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_sites"."is_virtual" IS 'Indicador lógico (is_virtual) utilizado en las reglas de negocio de app.core_organization_sites.';
COMMENT ON COLUMN "app"."core_organization_sites"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_sites"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organization_sites"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organization_sites"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organization_memberships" IS 'Vínculo de persona con una entidad académica';
COMMENT ON COLUMN "app"."core_organization_memberships"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organization_memberships"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_organization_memberships"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."core_organization_memberships"."member_code" IS 'Dato member code de app.core_organization_memberships; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_memberships"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."core_organization_memberships"."joined_at" IS 'Fecha y hora del evento joined con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_memberships"."ended_at" IS 'Fecha y hora del evento ended con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_memberships"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_memberships"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organization_memberships"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organization_memberships"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organization_roles" IS 'Roles configurables por institución';
COMMENT ON COLUMN "app"."core_organization_roles"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organization_roles"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_organization_roles"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."core_organization_roles"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."core_organization_roles"."permissions" IS 'Conjunto configurable de permisos autorizados.';
COMMENT ON COLUMN "app"."core_organization_roles"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_roles"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organization_roles"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organization_roles"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_membership_roles" IS 'Una persona puede tener varios roles en la misma institución';
COMMENT ON COLUMN "app"."core_membership_roles"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_membership_roles"."membership_id" IS 'Vínculo referencial con app.core_organization_memberships mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_membership_roles"."role_id" IS 'Vínculo referencial con app.core_organization_roles mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_membership_roles"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_membership_roles"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_membership_roles"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_membership_roles"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organization_settings" IS 'Configuración aislada por institución';
COMMENT ON COLUMN "app"."core_organization_settings"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organization_settings"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_organization_settings"."settings" IS 'Opciones configurables de comportamiento.';
COMMENT ON COLUMN "app"."core_organization_settings"."branding" IS 'Configuración estructurada branding validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."core_organization_settings"."timezone" IS 'Dato timezone de app.core_organization_settings; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_settings"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_settings"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organization_settings"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organization_settings"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organization_invitations" IS 'Invitaciones institucionales con expiración';
COMMENT ON COLUMN "app"."core_organization_invitations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organization_invitations"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_organization_invitations"."email" IS 'Correo electrónico de acceso o contacto.';
COMMENT ON COLUMN "app"."core_organization_invitations"."invite_token_hash" IS 'Dato invite token hash de app.core_organization_invitations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_invitations"."invited_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_organization_invitations"."expires_at" IS 'Momento de expiración o caducidad.';
COMMENT ON COLUMN "app"."core_organization_invitations"."accepted_at" IS 'Fecha y hora del evento accepted con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_invitations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_invitations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organization_invitations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organization_invitations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_institution_requests" IS 'Solicitud de alta y validación de instituciones';
COMMENT ON COLUMN "app"."core_institution_requests"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_institution_requests"."applicant_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_institution_requests"."requested_name" IS 'Dato requested name de app.core_institution_requests; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_institution_requests"."registration_info" IS 'Configuración estructurada registration info validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."core_institution_requests"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."core_institution_requests"."reviewed_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_institution_requests"."reviewed_at" IS 'Fecha y hora del evento reviewed con zona horaria.';
COMMENT ON COLUMN "app"."core_institution_requests"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_institution_requests"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_institution_requests"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_institution_requests"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_legal_documents" IS 'Versiones de términos, políticas y reglamentos';
COMMENT ON COLUMN "app"."core_legal_documents"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_legal_documents"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_legal_documents"."document_type" IS 'Clasificación del documento de identidad o comprobante.';
COMMENT ON COLUMN "app"."core_legal_documents"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."core_legal_documents"."version" IS 'Dato version de app.core_legal_documents; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_legal_documents"."resource_url" IS 'Dirección de acceso a resource url.';
COMMENT ON COLUMN "app"."core_legal_documents"."published_at" IS 'Momento de publicación o disponibilidad.';
COMMENT ON COLUMN "app"."core_legal_documents"."effective_at" IS 'Fecha y hora del evento effective con zona horaria.';
COMMENT ON COLUMN "app"."core_legal_documents"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_legal_documents"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_legal_documents"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_legal_documents"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_legal_acceptances" IS 'Aceptación trazable de una versión documental';
COMMENT ON COLUMN "app"."core_legal_acceptances"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."document_id" IS 'Vínculo referencial con app.core_legal_documents mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."accepted_at" IS 'Fecha y hora del evento accepted con zona horaria.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."evidence" IS 'Configuración estructurada evidence validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_legal_acceptances"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_organization_announcements" IS 'Comunicados institucionales';
COMMENT ON COLUMN "app"."core_organization_announcements"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_organization_announcements"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_organization_announcements"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."core_organization_announcements"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."core_organization_announcements"."audience" IS 'Dato audience de app.core_organization_announcements; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_organization_announcements"."publish_at" IS 'Fecha y hora del evento publish con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_announcements"."expires_at" IS 'Momento de expiración o caducidad.';
COMMENT ON COLUMN "app"."core_organization_announcements"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_organization_announcements"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_organization_announcements"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_organization_announcements"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."core_audit_logs" IS 'Auditoría sensible: acciones administrativas y cambios';
COMMENT ON COLUMN "app"."core_audit_logs"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."core_audit_logs"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."core_audit_logs"."actor_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."core_audit_logs"."event_type" IS 'Dato event type de app.core_audit_logs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_audit_logs"."object_type" IS 'Dato object type de app.core_audit_logs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_audit_logs"."object_id" IS 'Identificador auxiliar object_id dentro del modelo app.core_audit_logs.';
COMMENT ON COLUMN "app"."core_audit_logs"."occurred_at" IS 'Fecha y hora del evento occurred con zona horaria.';
COMMENT ON COLUMN "app"."core_audit_logs"."ip_hash" IS 'Dato ip hash de app.core_audit_logs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."core_audit_logs"."details" IS 'Configuración estructurada details validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."core_audit_logs"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."core_audit_logs"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."core_audit_logs"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."core_audit_logs"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_categories" IS 'Categorías jerárquicas SIN dependencia circular hacia cursos';
COMMENT ON COLUMN "app"."catalog_categories"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_categories"."parent_id" IS 'Vínculo referencial con app.catalog_categories mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_categories"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."catalog_categories"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."catalog_categories"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_categories"."icon_key" IS 'Identificador del icono de la interfaz.';
COMMENT ON COLUMN "app"."catalog_categories"."color_hex" IS 'Color RGB expresado como seis caracteres hexadecimales.';
COMMENT ON COLUMN "app"."catalog_categories"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_categories"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_categories"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_categories"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_tags" IS 'Etiquetas temáticas';
COMMENT ON COLUMN "app"."catalog_tags"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_tags"."slug" IS 'Identificador corto usado en direcciones y búsquedas.';
COMMENT ON COLUMN "app"."catalog_tags"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."catalog_tags"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_tags"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_tags"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_tags"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_skills" IS 'Habilidades asociables a rutas y cursos';
COMMENT ON COLUMN "app"."catalog_skills"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_skills"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."catalog_skills"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_skills"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_skills"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_skills"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_skills"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_media_assets" IS 'Metadatos de archivos en almacenamiento de objetos';
COMMENT ON COLUMN "app"."catalog_media_assets"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_media_assets"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_media_assets"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."catalog_media_assets"."storage_key" IS 'Dato storage key de app.catalog_media_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_media_assets"."mime_type" IS 'Dato mime type de app.catalog_media_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_media_assets"."byte_size" IS 'Dato byte size de app.catalog_media_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_media_assets"."checksum_sha256" IS 'Dato checksum sha256 de app.catalog_media_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_media_assets"."duration_seconds" IS 'Duración del archivo o contenido audiovisual en segundos.';
COMMENT ON COLUMN "app"."catalog_media_assets"."visibility" IS 'Regla de visibilidad del elemento.';
COMMENT ON COLUMN "app"."catalog_media_assets"."scan_status" IS 'Dato scan status de app.catalog_media_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_media_assets"."alt_text" IS 'Dato alt text de app.catalog_media_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_media_assets"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_media_assets"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_media_assets"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_media_assets"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_courses" IS 'Definición reusable de curso; propietario independiente o institucional';
COMMENT ON COLUMN "app"."catalog_courses"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_courses"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."catalog_courses"."owner_person_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_courses"."category_id" IS 'Vínculo referencial con app.catalog_categories mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_courses"."slug" IS 'Identificador corto usado en direcciones y búsquedas.';
COMMENT ON COLUMN "app"."catalog_courses"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_courses"."summary" IS 'Resumen breve para los listados.';
COMMENT ON COLUMN "app"."catalog_courses"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_courses"."thumbnail_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_courses"."language_code" IS 'Dato language code de app.catalog_courses; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_courses"."course_kind" IS 'Clase de curso: abierto, institucional, premium o temporal.';
COMMENT ON COLUMN "app"."catalog_courses"."delivery_mode" IS 'Modalidad de dictado del curso o sección.';
COMMENT ON COLUMN "app"."catalog_courses"."visibility" IS 'Regla de visibilidad del elemento.';
COMMENT ON COLUMN "app"."catalog_courses"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."catalog_courses"."requires_enrollment" IS 'Indicador lógico (requires_enrollment) utilizado en las reglas de negocio de app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_courses"."published_at" IS 'Momento de publicación o disponibilidad.';
COMMENT ON COLUMN "app"."catalog_courses"."estimated_minutes" IS 'Dato estimated minutes de app.catalog_courses; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_courses"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_courses"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_courses"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_courses"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_course_tags" IS 'Etiquetas de un curso';
COMMENT ON COLUMN "app"."catalog_course_tags"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_course_tags"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_course_tags"."tag_id" IS 'Vínculo referencial con app.catalog_tags mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_course_tags"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_course_tags"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_course_tags"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_course_tags"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_course_skills" IS 'Habilidades que desarrolla un curso';
COMMENT ON COLUMN "app"."catalog_course_skills"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_course_skills"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_course_skills"."skill_id" IS 'Vínculo referencial con app.catalog_skills mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_course_skills"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_course_skills"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_course_skills"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_course_skills"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_course_instructors" IS 'Docentes que pueden ser independientes de una institución';
COMMENT ON COLUMN "app"."catalog_course_instructors"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."is_primary" IS 'Indicador lógico (is_primary) utilizado en las reglas de negocio de app.catalog_course_instructors.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_course_instructors"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_course_prerequisites" IS 'Prerrequisitos entre cursos';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."required_course_id" IS 'Vínculo referencial con app.catalog_courses mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."is_mandatory" IS 'Indicador lógico (is_mandatory) utilizado en las reglas de negocio de app.catalog_course_prerequisites.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_course_prerequisites"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_course_versions" IS 'Versiones publicadas para controlar cambios de contenido';
COMMENT ON COLUMN "app"."catalog_course_versions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_course_versions"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_course_versions"."version_no" IS 'Dato version no de app.catalog_course_versions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_course_versions"."release_notes" IS 'Dato release notes de app.catalog_course_versions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_course_versions"."published_at" IS 'Momento de publicación o disponibilidad.';
COMMENT ON COLUMN "app"."catalog_course_versions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_course_versions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_course_versions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_course_versions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_modules" IS 'Módulos de contenido reutilizable';
COMMENT ON COLUMN "app"."catalog_modules"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_modules"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_modules"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."catalog_modules"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_modules"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_modules"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."catalog_modules"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_modules"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_modules"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_modules"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_lessons" IS 'Submódulos o lecciones por módulo';
COMMENT ON COLUMN "app"."catalog_lessons"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_lessons"."module_id" IS 'Módulo que agrupa lecciones. Clave externa a app.catalog_modules.';
COMMENT ON COLUMN "app"."catalog_lessons"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."catalog_lessons"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_lessons"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_lessons"."estimated_minutes" IS 'Dato estimated minutes de app.catalog_lessons; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_lessons"."is_preview" IS 'Indicador lógico (is_preview) utilizado en las reglas de negocio de app.catalog_lessons.';
COMMENT ON COLUMN "app"."catalog_lessons"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."catalog_lessons"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_lessons"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_lessons"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_lessons"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_resources" IS 'Metadatos de recursos educativos y enlaces';
COMMENT ON COLUMN "app"."catalog_resources"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_resources"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_resources"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."catalog_resources"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."catalog_resources"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_resources"."resource_type" IS 'Dato resource type de app.catalog_resources; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_resources"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_resources"."external_url" IS 'Dirección del recurso alojado fuera de ChemXR.';
COMMENT ON COLUMN "app"."catalog_resources"."duration_seconds" IS 'Duración del archivo o contenido audiovisual en segundos.';
COMMENT ON COLUMN "app"."catalog_resources"."license_type" IS 'Dato license type de app.catalog_resources; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_resources"."is_downloadable" IS 'Indicador lógico (is_downloadable) utilizado en las reglas de negocio de app.catalog_resources.';
COMMENT ON COLUMN "app"."catalog_resources"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."catalog_resources"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_resources"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_resources"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_resources"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_lesson_resources" IS 'Recursos organizados en lecciones';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."lesson_id" IS 'Lección o submódulo de aprendizaje. Clave externa a app.catalog_lessons.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."is_required" IS 'Indicador lógico (is_required) utilizado en las reglas de negocio de app.catalog_lesson_resources.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_lesson_resources"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_learning_paths" IS 'Rutas de aprendizaje libres o institucionales';
COMMENT ON COLUMN "app"."catalog_learning_paths"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."visibility" IS 'Regla de visibilidad del elemento.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_learning_paths"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_learning_path_courses" IS 'Cursos secuenciales dentro de una ruta';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."path_id" IS 'Vínculo referencial con app.catalog_learning_paths mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."is_required" IS 'Indicador lógico (is_required) utilizado en las reglas de negocio de app.catalog_learning_path_courses.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_learning_path_courses"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_external_libraries" IS 'Catálogo curado de fuentes académicas externas';
COMMENT ON COLUMN "app"."catalog_external_libraries"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."homepage_url" IS 'Dirección de acceso a homepage url.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."logo_asset_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."access_type" IS 'Dato access type de app.catalog_external_libraries; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."requires_institution" IS 'Indicador lógico (requires_institution) utilizado en las reglas de negocio de app.catalog_external_libraries.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."is_verified" IS 'Indica si un recurso o identidad fue verificado.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_external_libraries"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_external_library_links" IS 'Secciones o enlaces destacados de una biblioteca';
COMMENT ON COLUMN "app"."catalog_external_library_links"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."library_id" IS 'Vínculo referencial con app.catalog_external_libraries mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."url" IS 'Dirección web de acceso al contenido.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."thumbnail_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_external_library_links"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_bookmarks" IS 'Colección personal de cursos, recursos y enlaces';
COMMENT ON COLUMN "app"."catalog_bookmarks"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."external_link_id" IS 'Vínculo referencial con app.catalog_external_library_links mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."note" IS 'Dato note de app.catalog_bookmarks; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_bookmarks"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_collections" IS 'Listas personales o curadas de recursos';
COMMENT ON COLUMN "app"."catalog_collections"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_collections"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."catalog_collections"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."catalog_collections"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."catalog_collections"."is_public" IS 'Indica si se permite exposición pública del elemento.';
COMMENT ON COLUMN "app"."catalog_collections"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_collections"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_collections"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_collections"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."catalog_collection_items" IS 'Elementos guardados en colecciones';
COMMENT ON COLUMN "app"."catalog_collection_items"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."catalog_collection_items"."collection_id" IS 'Vínculo referencial con app.catalog_collections mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_collection_items"."bookmark_id" IS 'Vínculo referencial con app.catalog_bookmarks mediante su identificador UUID.';
COMMENT ON COLUMN "app"."catalog_collection_items"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."catalog_collection_items"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."catalog_collection_items"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."catalog_collection_items"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."catalog_collection_items"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_cohorts" IS 'Ediciones del curso, incluidas aulas privadas temporales';
COMMENT ON COLUMN "app"."learning_cohorts"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_cohorts"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."learning_cohorts"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."learning_cohorts"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."learning_cohorts"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."learning_cohorts"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."learning_cohorts"."expires_at" IS 'Momento de expiración o caducidad.';
COMMENT ON COLUMN "app"."learning_cohorts"."archived_at" IS 'Fecha y hora del evento archived con zona horaria.';
COMMENT ON COLUMN "app"."learning_cohorts"."max_participants" IS 'Capacidad máxima de participantes por aula o edición.';
COMMENT ON COLUMN "app"."learning_cohorts"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."learning_cohorts"."enrollment_mode" IS 'Regla de incorporación de alumnos a la cohorte.';
COMMENT ON COLUMN "app"."learning_cohorts"."access_code_hash" IS 'Dato access code hash de app.learning_cohorts; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_cohorts"."publication_policy" IS 'Política de publicación o preservación tras el cierre del aula.';
COMMENT ON COLUMN "app"."learning_cohorts"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_cohorts"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_cohorts"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_cohorts"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_cohort_instructors" IS 'Docentes responsables de una edición';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_cohort_instructors"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_enrollments" IS 'Inscripción al curso o a una cohorte; independiente de matrícula oficial';
COMMENT ON COLUMN "app"."learning_enrollments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_enrollments"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_enrollments"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."learning_enrollments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."learning_enrollments"."enrolled_at" IS 'Fecha y hora del evento enrolled con zona horaria.';
COMMENT ON COLUMN "app"."learning_enrollments"."completed_at" IS 'Fecha y hora del evento completed con zona horaria.';
COMMENT ON COLUMN "app"."learning_enrollments"."access_ends_at" IS 'Fecha y hora del evento access ends con zona horaria.';
COMMENT ON COLUMN "app"."learning_enrollments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_enrollments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_enrollments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_enrollments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_lesson_progress" IS 'Estado de avance de lecciones de un alumno';
COMMENT ON COLUMN "app"."learning_lesson_progress"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."enrollment_id" IS 'Vínculo referencial con app.learning_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."lesson_id" IS 'Lección o submódulo de aprendizaje. Clave externa a app.catalog_lessons.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."progress_percent" IS 'Porcentaje de avance, entre 0 y 100.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."first_opened_at" IS 'Fecha y hora del evento first opened con zona horaria.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."last_opened_at" IS 'Fecha y hora del evento last opened con zona horaria.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."completed_at" IS 'Fecha y hora del evento completed con zona horaria.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_lesson_progress"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_resource_progress" IS 'Avance por recurso y usuario';
COMMENT ON COLUMN "app"."learning_resource_progress"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_resource_progress"."enrollment_id" IS 'Vínculo referencial con app.learning_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_resource_progress"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."learning_resource_progress"."progress_percent" IS 'Porcentaje de avance, entre 0 y 100.';
COMMENT ON COLUMN "app"."learning_resource_progress"."time_seconds" IS 'Dato time seconds de app.learning_resource_progress; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_resource_progress"."completed_at" IS 'Fecha y hora del evento completed con zona horaria.';
COMMENT ON COLUMN "app"."learning_resource_progress"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_resource_progress"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_resource_progress"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_resource_progress"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_course_progress" IS 'Resumen materializado de avance, recalculable';
COMMENT ON COLUMN "app"."learning_course_progress"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_course_progress"."enrollment_id" IS 'Vínculo referencial con app.learning_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_course_progress"."percent_complete" IS 'Proporción calculada de requisitos completados (0 a 100).';
COMMENT ON COLUMN "app"."learning_course_progress"."active_seconds" IS 'Segundos de interacción activa estimados, excluyendo pausas.';
COMMENT ON COLUMN "app"."learning_course_progress"."last_activity_at" IS 'Fecha y hora del evento last activity con zona horaria.';
COMMENT ON COLUMN "app"."learning_course_progress"."completed_at" IS 'Fecha y hora del evento completed con zona horaria.';
COMMENT ON COLUMN "app"."learning_course_progress"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_course_progress"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_course_progress"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_course_progress"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_study_sessions" IS 'Sesiones activas medidas sin asumir atención continua';
COMMENT ON COLUMN "app"."learning_study_sessions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_study_sessions"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_study_sessions"."enrollment_id" IS 'Vínculo referencial con app.learning_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_study_sessions"."lesson_id" IS 'Lección o submódulo de aprendizaje. Clave externa a app.catalog_lessons.';
COMMENT ON COLUMN "app"."learning_study_sessions"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."learning_study_sessions"."started_at" IS 'Fecha y hora del evento started con zona horaria.';
COMMENT ON COLUMN "app"."learning_study_sessions"."ended_at" IS 'Fecha y hora del evento ended con zona horaria.';
COMMENT ON COLUMN "app"."learning_study_sessions"."active_seconds" IS 'Segundos de interacción activa estimados, excluyendo pausas.';
COMMENT ON COLUMN "app"."learning_study_sessions"."device_session_key" IS 'Dato device session key de app.learning_study_sessions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_study_sessions"."source" IS 'Dato source de app.learning_study_sessions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_study_sessions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_study_sessions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_study_sessions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_study_sessions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_learning_events" IS 'Eventos de estudio idempotentes y aptos para sincronización offline';
COMMENT ON COLUMN "app"."learning_learning_events"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_learning_events"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_learning_events"."enrollment_id" IS 'Vínculo referencial con app.learning_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_learning_events"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."learning_learning_events"."event_key" IS 'Dato event key de app.learning_learning_events; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_learning_events"."event_type" IS 'Dato event type de app.learning_learning_events; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_learning_events"."occurred_at" IS 'Fecha y hora del evento occurred con zona horaria.';
COMMENT ON COLUMN "app"."learning_learning_events"."received_at" IS 'Fecha y hora del evento received con zona horaria.';
COMMENT ON COLUMN "app"."learning_learning_events"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."learning_learning_events"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_learning_events"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_learning_events"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_learning_events"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_course_notes" IS 'Apuntes privados anclados a una lección';
COMMENT ON COLUMN "app"."learning_course_notes"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_course_notes"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_course_notes"."lesson_id" IS 'Lección o submódulo de aprendizaje. Clave externa a app.catalog_lessons.';
COMMENT ON COLUMN "app"."learning_course_notes"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."learning_course_notes"."position_seconds" IS 'Dato position seconds de app.learning_course_notes; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_course_notes"."is_private" IS 'Indicador lógico (is_private) utilizado en las reglas de negocio de app.learning_course_notes.';
COMMENT ON COLUMN "app"."learning_course_notes"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_course_notes"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_course_notes"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_course_notes"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_course_reviews" IS 'Reseñas con moderación';
COMMENT ON COLUMN "app"."learning_course_reviews"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_course_reviews"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_course_reviews"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."learning_course_reviews"."rating" IS 'Dato rating de app.learning_course_reviews; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_course_reviews"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."learning_course_reviews"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."learning_course_reviews"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_course_reviews"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_course_reviews"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_course_reviews"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_learning_goals" IS 'Metas personales semanales y hábitos';
COMMENT ON COLUMN "app"."learning_learning_goals"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_learning_goals"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_learning_goals"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."learning_learning_goals"."target_count" IS 'Cantidad, correlativo o límite de target count.';
COMMENT ON COLUMN "app"."learning_learning_goals"."target_minutes" IS 'Dato target minutes de app.learning_learning_goals; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_learning_goals"."period_start" IS 'Dato period start de app.learning_learning_goals; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_learning_goals"."period_end" IS 'Dato period end de app.learning_learning_goals; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_learning_goals"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."learning_learning_goals"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_learning_goals"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_learning_goals"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_learning_goals"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_certificate_templates" IS 'Diseños verificables de certificados';
COMMENT ON COLUMN "app"."learning_certificate_templates"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."template_asset_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."verification_template" IS 'Dato verification template de app.learning_certificate_templates; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_certificate_templates"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_certificates" IS 'Certificados emitidos, verificables y revocables';
COMMENT ON COLUMN "app"."learning_certificates"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_certificates"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_certificates"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."learning_certificates"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."learning_certificates"."template_id" IS 'Vínculo referencial con app.learning_certificate_templates mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_certificates"."certificate_code" IS 'Dato certificate code de app.learning_certificates; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_certificates"."issued_at" IS 'Momento de emisión del documento o cargo.';
COMMENT ON COLUMN "app"."learning_certificates"."revoked_at" IS 'Fecha de revocación o cancelación de vigencia.';
COMMENT ON COLUMN "app"."learning_certificates"."document_asset_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_certificates"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_certificates"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_certificates"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_certificates"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_badges" IS 'Catálogo de logros e insignias';
COMMENT ON COLUMN "app"."learning_badges"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_badges"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."learning_badges"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."learning_badges"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."learning_badges"."icon_asset_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_badges"."criteria" IS 'Configuración estructurada criteria validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."learning_badges"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_badges"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_badges"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_badges"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."learning_person_badges" IS 'Insignias obtenidas por un usuario';
COMMENT ON COLUMN "app"."learning_person_badges"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."learning_person_badges"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."learning_person_badges"."badge_id" IS 'Vínculo referencial con app.learning_badges mediante su identificador UUID.';
COMMENT ON COLUMN "app"."learning_person_badges"."awarded_at" IS 'Fecha y hora del evento awarded con zona horaria.';
COMMENT ON COLUMN "app"."learning_person_badges"."reason" IS 'Dato reason de app.learning_person_badges; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."learning_person_badges"."revoked_at" IS 'Fecha de revocación o cancelación de vigencia.';
COMMENT ON COLUMN "app"."learning_person_badges"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."learning_person_badges"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."learning_person_badges"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."learning_person_badges"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_rubrics" IS 'Rúbricas reutilizables para evaluar entregas';
COMMENT ON COLUMN "app"."assessment_rubrics"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_rubrics"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."assessment_rubrics"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_rubrics"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."assessment_rubrics"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."assessment_rubrics"."max_score" IS 'Puntuación máxima que puede obtenerse.';
COMMENT ON COLUMN "app"."assessment_rubrics"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_rubrics"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_rubrics"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_rubrics"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_rubric_criteria" IS 'Criterios, pesos y niveles de desempeño';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."rubric_id" IS 'Rúbrica que define criterios y puntajes. Clave externa a app.assessment_rubrics.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."max_points" IS 'Cantidad, correlativo o límite de max points.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."performance_levels" IS 'Configuración estructurada performance levels validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_rubric_criteria"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_question_banks" IS 'Bancos de preguntas institucionales o personales';
COMMENT ON COLUMN "app"."assessment_question_banks"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_question_banks"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."assessment_question_banks"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_question_banks"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."assessment_question_banks"."visibility" IS 'Regla de visibilidad del elemento.';
COMMENT ON COLUMN "app"."assessment_question_banks"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_question_banks"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_question_banks"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_question_banks"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_questions" IS 'Preguntas de examen, con claves restringidas al backend';
COMMENT ON COLUMN "app"."assessment_questions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_questions"."bank_id" IS 'Vínculo referencial con app.assessment_question_banks mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_questions"."question_type" IS 'Modalidad de pregunta (selección, texto, etc.).';
COMMENT ON COLUMN "app"."assessment_questions"."prompt" IS 'Dato prompt de app.assessment_questions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_questions"."media_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_questions"."solution" IS 'Configuración estructurada solution validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."assessment_questions"."difficulty" IS 'Dato difficulty de app.assessment_questions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_questions"."points" IS 'Puntaje numérico definido por el contexto de evaluación.';
COMMENT ON COLUMN "app"."assessment_questions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_questions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_questions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_questions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_question_options" IS 'Opciones para preguntas de selección';
COMMENT ON COLUMN "app"."assessment_question_options"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_question_options"."question_id" IS 'Vínculo referencial con app.assessment_questions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_question_options"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."assessment_question_options"."label" IS 'Dato label de app.assessment_question_options; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_question_options"."is_correct" IS 'Indicador lógico (is_correct) utilizado en las reglas de negocio de app.assessment_question_options.';
COMMENT ON COLUMN "app"."assessment_question_options"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_question_options"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_question_options"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_question_options"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_assessments" IS 'Exámenes, tareas, proyectos y actividades evaluables';
COMMENT ON COLUMN "app"."assessment_assessments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_assessments"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."assessment_assessments"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."assessment_assessments"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."assessment_assessments"."assessment_type" IS 'Naturaleza de la actividad evaluable: examen, trabajo, tarea u otra.';
COMMENT ON COLUMN "app"."assessment_assessments"."grading_type" IS 'Dato grading type de app.assessment_assessments; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_assessments"."rubric_id" IS 'Rúbrica que define criterios y puntajes. Clave externa a app.assessment_rubrics.';
COMMENT ON COLUMN "app"."assessment_assessments"."instructions" IS 'Dato instructions de app.assessment_assessments; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_assessments"."max_score" IS 'Puntuación máxima que puede obtenerse.';
COMMENT ON COLUMN "app"."assessment_assessments"."allowed_attempts" IS 'Número máximo de intentos permitidos al estudiante.';
COMMENT ON COLUMN "app"."assessment_assessments"."is_group_work" IS 'Indicador lógico (is_group_work) utilizado en las reglas de negocio de app.assessment_assessments.';
COMMENT ON COLUMN "app"."assessment_assessments"."open_at" IS 'Fecha y hora del evento open con zona horaria.';
COMMENT ON COLUMN "app"."assessment_assessments"."due_at" IS 'Fecha y hora límite de cumplimiento o entrega.';
COMMENT ON COLUMN "app"."assessment_assessments"."close_at" IS 'Fecha y hora del evento close con zona horaria.';
COMMENT ON COLUMN "app"."assessment_assessments"."late_policy" IS 'Configuración estructurada late policy validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."assessment_assessments"."settings" IS 'Opciones configurables de comportamiento.';
COMMENT ON COLUMN "app"."assessment_assessments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."assessment_assessments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_assessments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_assessments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_assessments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_assessment_questions" IS 'Preguntas y orden dentro de una evaluación';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."assessment_id" IS 'Evaluación, tarea o examen al que se asocia el dato. Clave externa a app.assessment_assessments.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."question_id" IS 'Vínculo referencial con app.assessment_questions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."points_override" IS 'Dato points override de app.assessment_assessment_questions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_assessment_questions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_teams" IS 'Equipos formados dentro de una cohorte';
COMMENT ON COLUMN "app"."assessment_teams"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_teams"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."assessment_teams"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."assessment_teams"."leader_person_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_teams"."created_for_assessment_id" IS 'Vínculo referencial con app.assessment_assessments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_teams"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_teams"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_teams"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_teams"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_team_members" IS 'Integrantes, roles y permanencia en un equipo';
COMMENT ON COLUMN "app"."assessment_team_members"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_team_members"."team_id" IS 'Vínculo referencial con app.assessment_teams mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_team_members"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."assessment_team_members"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."assessment_team_members"."joined_at" IS 'Fecha y hora del evento joined con zona horaria.';
COMMENT ON COLUMN "app"."assessment_team_members"."left_at" IS 'Fecha y hora del evento left con zona horaria.';
COMMENT ON COLUMN "app"."assessment_team_members"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_team_members"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_team_members"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_team_members"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_assessment_extensions" IS 'Excepciones de fecha o intentos autorizadas';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."assessment_id" IS 'Evaluación, tarea o examen al que se asocia el dato. Clave externa a app.assessment_assessments.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."team_id" IS 'Vínculo referencial con app.assessment_teams mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."new_due_at" IS 'Fecha y hora del evento new due con zona horaria.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."extra_attempts" IS 'Dato extra attempts de app.assessment_assessment_extensions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."reason" IS 'Dato reason de app.assessment_assessment_extensions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_assessment_extensions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_submissions" IS 'Entregas individuales o por equipo con número de intento';
COMMENT ON COLUMN "app"."assessment_submissions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_submissions"."assessment_id" IS 'Evaluación, tarea o examen al que se asocia el dato. Clave externa a app.assessment_assessments.';
COMMENT ON COLUMN "app"."assessment_submissions"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."assessment_submissions"."team_id" IS 'Vínculo referencial con app.assessment_teams mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_submissions"."attempt_number" IS 'Número consecutivo de entrega o intento.';
COMMENT ON COLUMN "app"."assessment_submissions"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."assessment_submissions"."text_answer" IS 'Dato text answer de app.assessment_submissions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_submissions"."submitted_at" IS 'Momento de entrega o presentación de la solicitud.';
COMMENT ON COLUMN "app"."assessment_submissions"."graded_at" IS 'Fecha y hora del evento graded con zona horaria.';
COMMENT ON COLUMN "app"."assessment_submissions"."score" IS 'Puntuación o calificación alcanzada.';
COMMENT ON COLUMN "app"."assessment_submissions"."graded_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_submissions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_submissions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_submissions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_submissions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_submission_files" IS 'Adjuntos presentados con una entrega';
COMMENT ON COLUMN "app"."assessment_submission_files"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_submission_files"."submission_id" IS 'Entrega específica de una evaluación. Clave externa a app.assessment_submissions.';
COMMENT ON COLUMN "app"."assessment_submission_files"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."assessment_submission_files"."display_name" IS 'Nombre mostrado a otros usuarios.';
COMMENT ON COLUMN "app"."assessment_submission_files"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_submission_files"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_submission_files"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_submission_files"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_submission_members" IS 'Integrantes evaluables de una entrega grupal';
COMMENT ON COLUMN "app"."assessment_submission_members"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_submission_members"."submission_id" IS 'Entrega específica de una evaluación. Clave externa a app.assessment_submissions.';
COMMENT ON COLUMN "app"."assessment_submission_members"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."assessment_submission_members"."individual_score" IS 'Dato individual score de app.assessment_submission_members; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_submission_members"."participation_note" IS 'Dato participation note de app.assessment_submission_members; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_submission_members"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_submission_members"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_submission_members"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_submission_members"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_attempt_answers" IS 'Respuestas por pregunta y por intento';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."submission_id" IS 'Entrega específica de una evaluación. Clave externa a app.assessment_submissions.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."question_id" IS 'Vínculo referencial con app.assessment_questions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."answer_payload" IS 'Configuración estructurada answer payload validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."score" IS 'Puntuación o calificación alcanzada.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."graded_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."graded_at" IS 'Fecha y hora del evento graded con zona horaria.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_attempt_answers"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_criterion_scores" IS 'Evaluación detallada contra rúbrica';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."submission_id" IS 'Entrega específica de una evaluación. Clave externa a app.assessment_submissions.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."criterion_id" IS 'Vínculo referencial con app.assessment_rubric_criteria mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."points" IS 'Puntaje numérico definido por el contexto de evaluación.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."comments" IS 'Dato comments de app.assessment_criterion_scores; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_criterion_scores"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."assessment_grade_changes" IS 'Historial de revisión y cambios de nota';
COMMENT ON COLUMN "app"."assessment_grade_changes"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."submission_id" IS 'Entrega específica de una evaluación. Clave externa a app.assessment_submissions.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."previous_score" IS 'Dato previous score de app.assessment_grade_changes; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."new_score" IS 'Dato new score de app.assessment_grade_changes; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."reason" IS 'Dato reason de app.assessment_grade_changes; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."changed_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."changed_at" IS 'Fecha y hora del evento changed con zona horaria.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."assessment_grade_changes"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_faculties" IS 'Facultades, escuelas o unidades académicas por institución';
COMMENT ON COLUMN "app"."academic_faculties"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_faculties"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."academic_faculties"."parent_id" IS 'Vínculo referencial con app.academic_faculties mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_faculties"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_faculties"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."academic_faculties"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_faculties"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_faculties"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_faculties"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_programs" IS 'Carreras, especialidades y programas formales';
COMMENT ON COLUMN "app"."academic_programs"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_programs"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."academic_programs"."faculty_id" IS 'Vínculo referencial con app.academic_faculties mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_programs"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_programs"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."academic_programs"."degree_level" IS 'Dato degree level de app.academic_programs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_programs"."awarded_title" IS 'Dato awarded title de app.academic_programs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_programs"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_programs"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_programs"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_programs"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_programs"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_curricula" IS 'Versiones del plan de estudios por programa';
COMMENT ON COLUMN "app"."academic_curricula"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_curricula"."program_id" IS 'Programa, carrera o especialización institucional. Clave externa a app.academic_programs.';
COMMENT ON COLUMN "app"."academic_curricula"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_curricula"."version_label" IS 'Dato version label de app.academic_curricula; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curricula"."effective_from" IS 'Dato effective from de app.academic_curricula; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curricula"."effective_to" IS 'Dato effective to de app.academic_curricula; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curricula"."required_credits" IS 'Dato required credits de app.academic_curricula; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curricula"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_curricula"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_curricula"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_curricula"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_curricula"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_curriculum_courses" IS 'Asignaturas exigidas o electivas en un plan';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."curriculum_id" IS 'Versión del plan de estudios oficial. Clave externa a app.academic_curricula.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."term_number" IS 'Cantidad, correlativo o límite de term number.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."credits" IS 'Créditos académicos asignados al curso de la malla.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."required" IS 'Bandera de configuración required.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."group_code" IS 'Dato group code de app.academic_curriculum_courses; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."hours_weekly" IS 'Dato hours weekly de app.academic_curriculum_courses; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_curriculum_courses"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_curriculum_prerequisites" IS 'Requisitos de una asignatura de plan para otra';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."curriculum_course_id" IS 'Vínculo referencial con app.academic_curriculum_courses mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."prerequisite_course_id" IS 'Vínculo referencial con app.academic_curriculum_courses mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."minimum_grade" IS 'Dato minimum grade de app.academic_curriculum_prerequisites; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_curriculum_prerequisites"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_terms" IS 'Ciclos y periodos lectivos por institución';
COMMENT ON COLUMN "app"."academic_terms"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_terms"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."academic_terms"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_terms"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."academic_terms"."starts_on" IS 'Fecha calendario para starts on.';
COMMENT ON COLUMN "app"."academic_terms"."ends_on" IS 'Fecha calendario para ends on.';
COMMENT ON COLUMN "app"."academic_terms"."enrollment_starts_on" IS 'Fecha calendario para enrollment starts on.';
COMMENT ON COLUMN "app"."academic_terms"."enrollment_ends_on" IS 'Fecha calendario para enrollment ends on.';
COMMENT ON COLUMN "app"."academic_terms"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_terms"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_terms"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_terms"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_terms"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_student_programs" IS 'Expediente de matrícula de estudiante en programa y plan';
COMMENT ON COLUMN "app"."academic_student_programs"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_student_programs"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."academic_student_programs"."program_id" IS 'Programa, carrera o especialización institucional. Clave externa a app.academic_programs.';
COMMENT ON COLUMN "app"."academic_student_programs"."curriculum_id" IS 'Versión del plan de estudios oficial. Clave externa a app.academic_curricula.';
COMMENT ON COLUMN "app"."academic_student_programs"."site_id" IS 'Vínculo referencial con app.core_organization_sites mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_student_programs"."student_number" IS 'Cantidad, correlativo o límite de student number.';
COMMENT ON COLUMN "app"."academic_student_programs"."admitted_on" IS 'Fecha calendario para admitted on.';
COMMENT ON COLUMN "app"."academic_student_programs"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_student_programs"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_student_programs"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_student_programs"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_student_programs"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_admission_applications" IS 'Postulaciones y admisión institucional';
COMMENT ON COLUMN "app"."academic_admission_applications"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_admission_applications"."program_id" IS 'Programa, carrera o especialización institucional. Clave externa a app.academic_programs.';
COMMENT ON COLUMN "app"."academic_admission_applications"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."academic_admission_applications"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."academic_admission_applications"."application_code" IS 'Dato application code de app.academic_admission_applications; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_admission_applications"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_admission_applications"."decision_at" IS 'Fecha y hora del evento decision con zona horaria.';
COMMENT ON COLUMN "app"."academic_admission_applications"."notes" IS 'Dato notes de app.academic_admission_applications; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_admission_applications"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_admission_applications"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_admission_applications"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_admission_applications"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_admission_requirements" IS 'Requisitos de admisión configurables';
COMMENT ON COLUMN "app"."academic_admission_requirements"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."program_id" IS 'Programa, carrera o especialización institucional. Clave externa a app.academic_programs.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."label" IS 'Dato label de app.academic_admission_requirements; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."is_required" IS 'Indicador lógico (is_required) utilizado en las reglas de negocio de app.academic_admission_requirements.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_admission_requirements"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_application_documents" IS 'Archivos entregados en una postulación';
COMMENT ON COLUMN "app"."academic_application_documents"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_application_documents"."application_id" IS 'Vínculo referencial con app.academic_admission_applications mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_application_documents"."requirement_id" IS 'Vínculo referencial con app.academic_admission_requirements mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_application_documents"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."academic_application_documents"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_application_documents"."reviewed_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_application_documents"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_application_documents"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_application_documents"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_application_documents"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_registrations" IS 'Matrícula formal del estudiante en un periodo';
COMMENT ON COLUMN "app"."academic_registrations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_registrations"."student_program_id" IS 'Vínculo referencial con app.academic_student_programs mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_registrations"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."academic_registrations"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_registrations"."registered_at" IS 'Fecha y hora del evento registered con zona horaria.';
COMMENT ON COLUMN "app"."academic_registrations"."confirmed_at" IS 'Fecha y hora del evento confirmed con zona horaria.';
COMMENT ON COLUMN "app"."academic_registrations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_registrations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_registrations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_registrations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_sections" IS 'Sección y dictado concreto de asignatura en periodo';
COMMENT ON COLUMN "app"."academic_sections"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_sections"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."academic_sections"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."academic_sections"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."academic_sections"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."academic_sections"."site_id" IS 'Vínculo referencial con app.core_organization_sites mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_sections"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."academic_sections"."capacity" IS 'Dato capacity de app.academic_sections; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_sections"."delivery_mode" IS 'Modalidad de dictado del curso o sección.';
COMMENT ON COLUMN "app"."academic_sections"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_sections"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_sections"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_sections"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_sections"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_section_instructors" IS 'Docentes de una sección institucional';
COMMENT ON COLUMN "app"."academic_section_instructors"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_section_instructors"."section_id" IS 'Sección académica impartida en un periodo institucional. Clave externa a app.academic_sections.';
COMMENT ON COLUMN "app"."academic_section_instructors"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."academic_section_instructors"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."academic_section_instructors"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_section_instructors"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_section_instructors"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_section_instructors"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_section_enrollments" IS 'Asignaturas en la matrícula con intentos/retiros';
COMMENT ON COLUMN "app"."academic_section_enrollments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."registration_id" IS 'Vínculo referencial con app.academic_registrations mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."section_id" IS 'Sección académica impartida en un periodo institucional. Clave externa a app.academic_sections.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."attempt_number" IS 'Número consecutivo de entrega o intento.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."withdrawn_at" IS 'Fecha y hora del evento withdrawn con zona horaria.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."final_grade" IS 'Calificación final del estudiante en la asignatura.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."result" IS 'Dato result de app.academic_section_enrollments; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_section_enrollments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_class_sessions" IS 'Clases y sesiones impartidas con fecha y enlace';
COMMENT ON COLUMN "app"."academic_class_sessions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_class_sessions"."section_id" IS 'Sección académica impartida en un periodo institucional. Clave externa a app.academic_sections.';
COMMENT ON COLUMN "app"."academic_class_sessions"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."academic_class_sessions"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."academic_class_sessions"."session_type" IS 'Dato session type de app.academic_class_sessions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_class_sessions"."room" IS 'Dato room de app.academic_class_sessions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_class_sessions"."meeting_url" IS 'Dirección para entrar a una reunión o clase virtual.';
COMMENT ON COLUMN "app"."academic_class_sessions"."recording_id" IS 'Vínculo referencial con app.catalog_resources mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_class_sessions"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_class_sessions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_class_sessions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_class_sessions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_class_sessions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_attendance" IS 'Asistencia por sesión';
COMMENT ON COLUMN "app"."academic_attendance"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_attendance"."class_session_id" IS 'Vínculo referencial con app.academic_class_sessions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_attendance"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."academic_attendance"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_attendance"."marked_at" IS 'Fecha y hora del evento marked con zona horaria.';
COMMENT ON COLUMN "app"."academic_attendance"."marked_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_attendance"."justification" IS 'Dato justification de app.academic_attendance; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_attendance"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_attendance"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_attendance"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_attendance"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_gradebook_items" IS 'Componente de nota oficial de sección';
COMMENT ON COLUMN "app"."academic_gradebook_items"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."section_id" IS 'Sección académica impartida en un periodo institucional. Clave externa a app.academic_sections.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."assessment_id" IS 'Evaluación, tarea o examen al que se asocia el dato. Clave externa a app.assessment_assessments.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."weight_percent" IS 'Peso de este componente dentro de una calificación.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."max_score" IS 'Puntuación máxima que puede obtenerse.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_gradebook_items"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_gradebook_scores" IS 'Notas oficiales por componente y estudiante';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."item_id" IS 'Vínculo referencial con app.academic_gradebook_items mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."section_enrollment_id" IS 'Vínculo referencial con app.academic_section_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."score" IS 'Puntuación o calificación alcanzada.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."published_at" IS 'Momento de publicación o disponibilidad.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_gradebook_scores"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_grade_appeals" IS 'Solicitudes de reconsideración de notas';
COMMENT ON COLUMN "app"."academic_grade_appeals"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."section_enrollment_id" IS 'Vínculo referencial con app.academic_section_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."gradebook_item_id" IS 'Vínculo referencial con app.academic_gradebook_items mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."reason" IS 'Dato reason de app.academic_grade_appeals; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."resolution" IS 'Dato resolution de app.academic_grade_appeals; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."resolved_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."resolved_at" IS 'Fecha y hora del evento resolved con zona horaria.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_grade_appeals"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_credit_recognitions" IS 'Convalidaciones y equivalencias aprobadas';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."student_program_id" IS 'Vínculo referencial con app.academic_student_programs mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."curriculum_course_id" IS 'Vínculo referencial con app.academic_curriculum_courses mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."source_institution" IS 'Dato source institution de app.academic_credit_recognitions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."source_course" IS 'Dato source course de app.academic_credit_recognitions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."recognized_credits" IS 'Dato recognized credits de app.academic_credit_recognitions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."approved_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."approved_at" IS 'Fecha de aprobación del registro.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_credit_recognitions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_academic_records" IS 'Consolidación oficial inmutable por periodo/asignatura';
COMMENT ON COLUMN "app"."academic_academic_records"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_academic_records"."student_program_id" IS 'Vínculo referencial con app.academic_student_programs mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_academic_records"."section_enrollment_id" IS 'Vínculo referencial con app.academic_section_enrollments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_academic_records"."curriculum_course_id" IS 'Vínculo referencial con app.academic_curriculum_courses mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_academic_records"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."academic_academic_records"."final_grade" IS 'Calificación final del estudiante en la asignatura.';
COMMENT ON COLUMN "app"."academic_academic_records"."result" IS 'Dato result de app.academic_academic_records; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_academic_records"."credits_earned" IS 'Créditos efectivamente reconocidos como aprobados.';
COMMENT ON COLUMN "app"."academic_academic_records"."recorded_at" IS 'Fecha y hora del evento recorded con zona horaria.';
COMMENT ON COLUMN "app"."academic_academic_records"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_academic_records"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_academic_records"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_academic_records"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."academic_degree_applications" IS 'Solicitudes de egreso, grados y titulación';
COMMENT ON COLUMN "app"."academic_degree_applications"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."academic_degree_applications"."student_program_id" IS 'Vínculo referencial con app.academic_student_programs mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_degree_applications"."degree_type" IS 'Dato degree type de app.academic_degree_applications; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."academic_degree_applications"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."academic_degree_applications"."submitted_at" IS 'Momento de entrega o presentación de la solicitud.';
COMMENT ON COLUMN "app"."academic_degree_applications"."approved_at" IS 'Fecha de aprobación del registro.';
COMMENT ON COLUMN "app"."academic_degree_applications"."document_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."academic_degree_applications"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."academic_degree_applications"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."academic_degree_applications"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."academic_degree_applications"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_communities" IS 'Comunidades independientes o asignadas a institución';
COMMENT ON COLUMN "app"."social_communities"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_communities"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."social_communities"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_communities"."slug" IS 'Identificador corto usado en direcciones y búsquedas.';
COMMENT ON COLUMN "app"."social_communities"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."social_communities"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."social_communities"."cover_asset_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_communities"."privacy" IS 'Nivel de privacidad o acceso aplicable.';
COMMENT ON COLUMN "app"."social_communities"."join_policy" IS 'Forma de incorporación (libre, aprobación o invitación).';
COMMENT ON COLUMN "app"."social_communities"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_communities"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_communities"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_communities"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_communities"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_community_members" IS 'Membresía de una comunidad y sus permisos';
COMMENT ON COLUMN "app"."social_community_members"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_community_members"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_community_members"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_community_members"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."social_community_members"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_community_members"."joined_at" IS 'Fecha y hora del evento joined con zona horaria.';
COMMENT ON COLUMN "app"."social_community_members"."muted_until" IS 'Dato muted until de app.social_community_members; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_community_members"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_community_members"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_community_members"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_community_members"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_community_join_requests" IS 'Solicitudes de acceso sometidas a aprobación';
COMMENT ON COLUMN "app"."social_community_join_requests"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_community_join_requests"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_community_join_requests"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_community_join_requests"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_community_join_requests"."reviewed_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_community_join_requests"."reviewed_at" IS 'Fecha y hora del evento reviewed con zona horaria.';
COMMENT ON COLUMN "app"."social_community_join_requests"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_community_join_requests"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_community_join_requests"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_community_join_requests"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_community_rules" IS 'Reglas editables y ordenadas';
COMMENT ON COLUMN "app"."social_community_rules"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_community_rules"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_community_rules"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."social_community_rules"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."social_community_rules"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_community_rules"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_community_rules"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_community_rules"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_community_rules"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_groups" IS 'Grupos de conversación bajo una comunidad';
COMMENT ON COLUMN "app"."social_groups"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_groups"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_groups"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."social_groups"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."social_groups"."privacy" IS 'Nivel de privacidad o acceso aplicable.';
COMMENT ON COLUMN "app"."social_groups"."posting_policy" IS 'Restricción de publicación según función del miembro.';
COMMENT ON COLUMN "app"."social_groups"."expires_messages_hours" IS 'Dato expires messages hours de app.social_groups; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_groups"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_groups"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_groups"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_groups"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_group_members" IS 'Integrantes y administradores de grupo';
COMMENT ON COLUMN "app"."social_group_members"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_group_members"."group_id" IS 'Grupo al que se vincula el registro. Clave externa a app.social_groups.';
COMMENT ON COLUMN "app"."social_group_members"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_group_members"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."social_group_members"."mute_until" IS 'Dato mute until de app.social_group_members; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_group_members"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_group_members"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_group_members"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_group_members"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_channels" IS 'Canales de difusión moderados';
COMMENT ON COLUMN "app"."social_channels"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_channels"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_channels"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."social_channels"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."social_channels"."posting_policy" IS 'Restricción de publicación según función del miembro.';
COMMENT ON COLUMN "app"."social_channels"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_channels"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_channels"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_channels"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_channel_subscribers" IS 'Usuarios suscritos a canales';
COMMENT ON COLUMN "app"."social_channel_subscribers"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."channel_id" IS 'Canal de difusión correspondiente. Clave externa a app.social_channels.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."muted" IS 'Bandera de configuración muted.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_channel_subscribers"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_posts" IS 'Publicaciones de comunidades (también programables)';
COMMENT ON COLUMN "app"."social_posts"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_posts"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_posts"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_posts"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."social_posts"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_posts"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."social_posts"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."social_posts"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_posts"."scheduled_at" IS 'Fecha y hora del evento scheduled con zona horaria.';
COMMENT ON COLUMN "app"."social_posts"."published_at" IS 'Momento de publicación o disponibilidad.';
COMMENT ON COLUMN "app"."social_posts"."is_pinned" IS 'Indicador lógico (is_pinned) utilizado en las reglas de negocio de app.social_posts.';
COMMENT ON COLUMN "app"."social_posts"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_posts"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_posts"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_posts"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_post_attachments" IS 'Multimedia de una publicación';
COMMENT ON COLUMN "app"."social_post_attachments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_post_attachments"."post_id" IS 'Vínculo referencial con app.social_posts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_post_attachments"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."social_post_attachments"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."social_post_attachments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_post_attachments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_post_attachments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_post_attachments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_post_comments" IS 'Comentarios anidados de publicaciones';
COMMENT ON COLUMN "app"."social_post_comments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_post_comments"."post_id" IS 'Vínculo referencial con app.social_posts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_post_comments"."parent_id" IS 'Vínculo referencial con app.social_post_comments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_post_comments"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_post_comments"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_post_comments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_post_comments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_post_comments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_post_comments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_post_comments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_post_reactions" IS 'Reacciones una por persona/tipo';
COMMENT ON COLUMN "app"."social_post_reactions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_post_reactions"."post_id" IS 'Vínculo referencial con app.social_posts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_post_reactions"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_post_reactions"."reaction" IS 'Dato reaction de app.social_post_reactions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_post_reactions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_post_reactions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_post_reactions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_post_reactions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_qa_questions" IS 'Preguntas académicas estilo Stack Overflow';
COMMENT ON COLUMN "app"."social_qa_questions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_qa_questions"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_qa_questions"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_qa_questions"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."social_qa_questions"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_qa_questions"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_qa_questions"."accepted_answer_id" IS 'Vínculo referencial con app.social_qa_answers mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_qa_questions"."votes_cache" IS 'Dato votes cache de app.social_qa_questions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_qa_questions"."views_cache" IS 'Dato views cache de app.social_qa_questions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_qa_questions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_qa_questions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_qa_questions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_qa_questions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_qa_answers" IS 'Respuestas a preguntas';
COMMENT ON COLUMN "app"."social_qa_answers"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_qa_answers"."question_id" IS 'Vínculo referencial con app.social_qa_questions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_qa_answers"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_qa_answers"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_qa_answers"."votes_cache" IS 'Dato votes cache de app.social_qa_answers; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_qa_answers"."is_accepted" IS 'Indicador lógico (is_accepted) utilizado en las reglas de negocio de app.social_qa_answers.';
COMMENT ON COLUMN "app"."social_qa_answers"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_qa_answers"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_qa_answers"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_qa_answers"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_qa_votes" IS 'Voto único por persona/respuesta';
COMMENT ON COLUMN "app"."social_qa_votes"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_qa_votes"."answer_id" IS 'Vínculo referencial con app.social_qa_answers mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_qa_votes"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_qa_votes"."value" IS 'Dato value de app.social_qa_votes; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_qa_votes"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_qa_votes"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_qa_votes"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_qa_votes"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_reputation_ledger" IS 'Historial de reputación académica no monetaria';
COMMENT ON COLUMN "app"."social_reputation_ledger"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."reason" IS 'Dato reason de app.social_reputation_ledger; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."points" IS 'Puntaje numérico definido por el contexto de evaluación.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."source_type" IS 'Dato source type de app.social_reputation_ledger; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."source_id" IS 'Identificador auxiliar source_id dentro del modelo app.social_reputation_ledger.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_reputation_ledger"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_course_forums" IS 'Foros pertenecientes a edición de curso, separados de comunidades';
COMMENT ON COLUMN "app"."social_course_forums"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_course_forums"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."social_course_forums"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."social_course_forums"."visibility" IS 'Regla de visibilidad del elemento.';
COMMENT ON COLUMN "app"."social_course_forums"."teacher_only" IS 'Bandera de configuración teacher only.';
COMMENT ON COLUMN "app"."social_course_forums"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_course_forums"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_course_forums"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_course_forums"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_forum_threads" IS 'Debates y dudas por foro académico';
COMMENT ON COLUMN "app"."social_forum_threads"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_forum_threads"."forum_id" IS 'Vínculo referencial con app.social_course_forums mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_forum_threads"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_forum_threads"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."social_forum_threads"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_forum_threads"."is_locked" IS 'Indicador lógico (is_locked) utilizado en las reglas de negocio de app.social_forum_threads.';
COMMENT ON COLUMN "app"."social_forum_threads"."is_pinned" IS 'Indicador lógico (is_pinned) utilizado en las reglas de negocio de app.social_forum_threads.';
COMMENT ON COLUMN "app"."social_forum_threads"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_forum_threads"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_forum_threads"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_forum_threads"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_forum_replies" IS 'Respuestas dentro de un foro de curso';
COMMENT ON COLUMN "app"."social_forum_replies"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_forum_replies"."thread_id" IS 'Vínculo referencial con app.social_forum_threads mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_forum_replies"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_forum_replies"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_forum_replies"."parent_id" IS 'Vínculo referencial con app.social_forum_replies mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_forum_replies"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_forum_replies"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_forum_replies"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_forum_replies"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_chat_rooms" IS 'Salas de chat de cursos, grupos o comunicación directa';
COMMENT ON COLUMN "app"."social_chat_rooms"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_chat_rooms"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."social_chat_rooms"."group_id" IS 'Grupo al que se vincula el registro. Clave externa a app.social_groups.';
COMMENT ON COLUMN "app"."social_chat_rooms"."channel_id" IS 'Canal de difusión correspondiente. Clave externa a app.social_channels.';
COMMENT ON COLUMN "app"."social_chat_rooms"."room_type" IS 'Dato room type de app.social_chat_rooms; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_chat_rooms"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."social_chat_rooms"."posting_policy" IS 'Restricción de publicación según función del miembro.';
COMMENT ON COLUMN "app"."social_chat_rooms"."expires_messages_hours" IS 'Dato expires messages hours de app.social_chat_rooms; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_chat_rooms"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_rooms"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_chat_rooms"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_chat_rooms"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_chat_members" IS 'Participantes de salas de chat';
COMMENT ON COLUMN "app"."social_chat_members"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_chat_members"."room_id" IS 'Sala de conversación correspondiente. Clave externa a app.social_chat_rooms.';
COMMENT ON COLUMN "app"."social_chat_members"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_chat_members"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."social_chat_members"."last_read_at" IS 'Fecha y hora del evento last read con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_members"."muted_until" IS 'Dato muted until de app.social_chat_members; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_chat_members"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_members"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_chat_members"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_chat_members"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_chat_messages" IS 'Mensajes, referencias y metadatos de edición';
COMMENT ON COLUMN "app"."social_chat_messages"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_chat_messages"."room_id" IS 'Sala de conversación correspondiente. Clave externa a app.social_chat_rooms.';
COMMENT ON COLUMN "app"."social_chat_messages"."sender_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_chat_messages"."reply_to_id" IS 'Vínculo referencial con app.social_chat_messages mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_chat_messages"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."social_chat_messages"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."social_chat_messages"."sent_at" IS 'Fecha y hora del evento sent con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_messages"."edited_at" IS 'Fecha y hora del evento edited con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_messages"."deleted_at" IS 'Fecha y hora del evento deleted con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_messages"."client_message_key" IS 'Dato client message key de app.social_chat_messages; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_chat_messages"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_chat_messages"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_chat_messages"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_chat_messages"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_moderation_reports" IS 'Denuncias de contenido o usuarios';
COMMENT ON COLUMN "app"."social_moderation_reports"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_moderation_reports"."reporter_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_moderation_reports"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_moderation_reports"."target_type" IS 'Dato target type de app.social_moderation_reports; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_moderation_reports"."target_id" IS 'Identificador auxiliar target_id dentro del modelo app.social_moderation_reports.';
COMMENT ON COLUMN "app"."social_moderation_reports"."reason" IS 'Dato reason de app.social_moderation_reports; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_moderation_reports"."details" IS 'Dato details de app.social_moderation_reports; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_moderation_reports"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_moderation_reports"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_moderation_reports"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_moderation_reports"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_moderation_reports"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_moderation_actions" IS 'Acciones de moderación auditables';
COMMENT ON COLUMN "app"."social_moderation_actions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_moderation_actions"."report_id" IS 'Vínculo referencial con app.social_moderation_reports mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_moderation_actions"."moderator_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_moderation_actions"."action_type" IS 'Dato action type de app.social_moderation_actions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_moderation_actions"."target_type" IS 'Dato target type de app.social_moderation_actions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_moderation_actions"."target_id" IS 'Identificador auxiliar target_id dentro del modelo app.social_moderation_actions.';
COMMENT ON COLUMN "app"."social_moderation_actions"."reason" IS 'Dato reason de app.social_moderation_actions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_moderation_actions"."expires_at" IS 'Momento de expiración o caducidad.';
COMMENT ON COLUMN "app"."social_moderation_actions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_moderation_actions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_moderation_actions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_moderation_actions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_bot_agents" IS 'Bots declarados y claramente identificados como automatizados';
COMMENT ON COLUMN "app"."social_bot_agents"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_bot_agents"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."social_bot_agents"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_bot_agents"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."social_bot_agents"."agent_type" IS 'Dato agent type de app.social_bot_agents; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_bot_agents"."is_disclosed" IS 'Indicador lógico (is_disclosed) utilizado en las reglas de negocio de app.social_bot_agents.';
COMMENT ON COLUMN "app"."social_bot_agents"."is_enabled" IS 'Indicador lógico (is_enabled) utilizado en las reglas de negocio de app.social_bot_agents.';
COMMENT ON COLUMN "app"."social_bot_agents"."permissions" IS 'Conjunto configurable de permisos autorizados.';
COMMENT ON COLUMN "app"."social_bot_agents"."configuration" IS 'Configuración estructurada configuration validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."social_bot_agents"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_bot_agents"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_bot_agents"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_bot_agents"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_bot_runs" IS 'Actividad y decisiones de moderación automatizada';
COMMENT ON COLUMN "app"."social_bot_runs"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_bot_runs"."agent_id" IS 'Vínculo referencial con app.social_bot_agents mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_bot_runs"."run_type" IS 'Dato run type de app.social_bot_runs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_bot_runs"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."social_bot_runs"."action_summary" IS 'Dato action summary de app.social_bot_runs; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."social_bot_runs"."started_at" IS 'Fecha y hora del evento started con zona horaria.';
COMMENT ON COLUMN "app"."social_bot_runs"."finished_at" IS 'Fecha y hora del evento finished con zona horaria.';
COMMENT ON COLUMN "app"."social_bot_runs"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_bot_runs"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_bot_runs"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_bot_runs"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_saved_lists" IS 'Listas personalizadas de conversaciones y comunidades';
COMMENT ON COLUMN "app"."social_saved_lists"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_saved_lists"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."social_saved_lists"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."social_saved_lists"."color_hex" IS 'Color RGB expresado como seis caracteres hexadecimales.';
COMMENT ON COLUMN "app"."social_saved_lists"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_saved_lists"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_saved_lists"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_saved_lists"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."social_saved_list_items" IS 'Elementos de una lista social';
COMMENT ON COLUMN "app"."social_saved_list_items"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."social_saved_list_items"."list_id" IS 'Vínculo referencial con app.social_saved_lists mediante su identificador UUID.';
COMMENT ON COLUMN "app"."social_saved_list_items"."community_id" IS 'Comunidad en la que ocurre la actividad. Clave externa a app.social_communities.';
COMMENT ON COLUMN "app"."social_saved_list_items"."room_id" IS 'Sala de conversación correspondiente. Clave externa a app.social_chat_rooms.';
COMMENT ON COLUMN "app"."social_saved_list_items"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."social_saved_list_items"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."social_saved_list_items"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."social_saved_list_items"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."social_saved_list_items"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."calendar_calendars" IS 'Agendas personales, de curso o institucionales';
COMMENT ON COLUMN "app"."calendar_calendars"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."calendar_calendars"."owner_person_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_calendars"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."calendar_calendars"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."calendar_calendars"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."calendar_calendars"."color_hex" IS 'Color RGB expresado como seis caracteres hexadecimales.';
COMMENT ON COLUMN "app"."calendar_calendars"."visibility" IS 'Regla de visibilidad del elemento.';
COMMENT ON COLUMN "app"."calendar_calendars"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."calendar_calendars"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."calendar_calendars"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."calendar_calendars"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."calendar_events" IS 'Eventos con origen e información de sesión';
COMMENT ON COLUMN "app"."calendar_events"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."calendar_events"."calendar_id" IS 'Vínculo referencial con app.calendar_calendars mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_events"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."calendar_events"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."calendar_events"."event_type" IS 'Dato event type de app.calendar_events; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."calendar_events"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."calendar_events"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."calendar_events"."location" IS 'Dato location de app.calendar_events; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."calendar_events"."meeting_url" IS 'Dirección para entrar a una reunión o clase virtual.';
COMMENT ON COLUMN "app"."calendar_events"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."calendar_events"."section_id" IS 'Sección académica impartida en un periodo institucional. Clave externa a app.academic_sections.';
COMMENT ON COLUMN "app"."calendar_events"."assessment_id" IS 'Evaluación, tarea o examen al que se asocia el dato. Clave externa a app.assessment_assessments.';
COMMENT ON COLUMN "app"."calendar_events"."is_all_day" IS 'Indicador lógico (is_all_day) utilizado en las reglas de negocio de app.calendar_events.';
COMMENT ON COLUMN "app"."calendar_events"."created_for_person_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_events"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."calendar_events"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."calendar_events"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."calendar_events"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."calendar_events"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."calendar_event_recurrences" IS 'Regla RRULE y excepciones por serie';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."event_id" IS 'Vínculo referencial con app.calendar_events mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."rrule" IS 'Regla de repetición compatible con el formato iCalendar RRULE.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."timezone" IS 'Dato timezone de app.calendar_event_recurrences; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."until_at" IS 'Fecha y hora del evento until con zona horaria.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."excluded_dates" IS 'Configuración estructurada excluded dates validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."calendar_event_recurrences"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."calendar_event_attendees" IS 'Participación e invitaciones a eventos';
COMMENT ON COLUMN "app"."calendar_event_attendees"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."event_id" IS 'Vínculo referencial con app.calendar_events mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."response" IS 'Dato response de app.calendar_event_attendees; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."attended_at" IS 'Fecha y hora del evento attended con zona horaria.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."calendar_event_attendees"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."calendar_reminders" IS 'Recordatorios y agenda personal configurable';
COMMENT ON COLUMN "app"."calendar_reminders"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."calendar_reminders"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."calendar_reminders"."event_id" IS 'Vínculo referencial con app.calendar_events mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_reminders"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."calendar_reminders"."remind_at" IS 'Fecha y hora del evento remind con zona horaria.';
COMMENT ON COLUMN "app"."calendar_reminders"."channel" IS 'Dato channel de app.calendar_reminders; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."calendar_reminders"."completed_at" IS 'Fecha y hora del evento completed con zona horaria.';
COMMENT ON COLUMN "app"."calendar_reminders"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."calendar_reminders"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."calendar_reminders"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."calendar_reminders"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."calendar_reminders"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."calendar_calendar_subscriptions" IS 'Visibilidad personalizada de agendas';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."calendar_id" IS 'Vínculo referencial con app.calendar_calendars mediante su identificador UUID.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."is_visible" IS 'Indicador lógico (is_visible) utilizado en las reglas de negocio de app.calendar_calendar_subscriptions.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."notify" IS 'Bandera de configuración notify.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."calendar_calendar_subscriptions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."communication_notifications" IS 'Bandeja de notificaciones del usuario';
COMMENT ON COLUMN "app"."communication_notifications"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."communication_notifications"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."communication_notifications"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."communication_notifications"."notification_type" IS 'Dato notification type de app.communication_notifications; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notifications"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."communication_notifications"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."communication_notifications"."payload" IS 'Configuración estructurada payload validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."communication_notifications"."read_at" IS 'Momento en que el destinatario leyó la notificación.';
COMMENT ON COLUMN "app"."communication_notifications"."expires_at" IS 'Momento de expiración o caducidad.';
COMMENT ON COLUMN "app"."communication_notifications"."priority" IS 'Dato priority de app.communication_notifications; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notifications"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."communication_notifications"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."communication_notifications"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."communication_notifications"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."communication_notification_preferences" IS 'Preferencias por evento/canal/institución';
COMMENT ON COLUMN "app"."communication_notification_preferences"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."event_type" IS 'Dato event type de app.communication_notification_preferences; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."channel" IS 'Dato channel de app.communication_notification_preferences; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."delivery_mode" IS 'Modalidad de dictado del curso o sección.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."enabled" IS 'Bandera de configuración enabled.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."quiet_hours" IS 'Configuración estructurada quiet hours validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."communication_notification_preferences"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."communication_notification_deliveries" IS 'Intentos de push, correo o avisos';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."notification_id" IS 'Vínculo referencial con app.communication_notifications mediante su identificador UUID.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."channel" IS 'Dato channel de app.communication_notification_deliveries; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."attempts" IS 'Dato attempts de app.communication_notification_deliveries; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."sent_at" IS 'Fecha y hora del evento sent con zona horaria.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."failure_code" IS 'Dato failure code de app.communication_notification_deliveries; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."communication_notification_deliveries"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."communication_ai_conversations" IS 'Conversaciones tutor IA y su contexto explícito';
COMMENT ON COLUMN "app"."communication_ai_conversations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."cohort_id" IS 'Edición o aula concreta del curso, incluso temporal. Clave externa a app.learning_cohorts.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."context_type" IS 'Dato context type de app.communication_ai_conversations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."privacy" IS 'Nivel de privacidad o acceso aplicable.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."communication_ai_conversations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."communication_ai_messages" IS 'Historial limitado del tutor, sujeto a retención';
COMMENT ON COLUMN "app"."communication_ai_messages"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."communication_ai_messages"."conversation_id" IS 'Vínculo referencial con app.communication_ai_conversations mediante su identificador UUID.';
COMMENT ON COLUMN "app"."communication_ai_messages"."role" IS 'Función que desempeña el participante en este contexto.';
COMMENT ON COLUMN "app"."communication_ai_messages"."content" IS 'Dato content de app.communication_ai_messages; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_messages"."model_name" IS 'Dato model name de app.communication_ai_messages; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_messages"."tokens_input" IS 'Dato tokens input de app.communication_ai_messages; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_messages"."tokens_output" IS 'Dato tokens output de app.communication_ai_messages; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_messages"."is_simulated" IS 'Indicador lógico (is_simulated) utilizado en las reglas de negocio de app.communication_ai_messages.';
COMMENT ON COLUMN "app"."communication_ai_messages"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."communication_ai_messages"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."communication_ai_messages"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."communication_ai_messages"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."communication_ai_messages"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."communication_ai_usage" IS 'Consumo de IA y límites por plan';
COMMENT ON COLUMN "app"."communication_ai_usage"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."communication_ai_usage"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."communication_ai_usage"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."communication_ai_usage"."usage_date" IS 'Fecha calendario para usage date.';
COMMENT ON COLUMN "app"."communication_ai_usage"."feature_code" IS 'Dato feature code de app.communication_ai_usage; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_usage"."units" IS 'Dato units de app.communication_ai_usage; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."communication_ai_usage"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."communication_ai_usage"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."communication_ai_usage"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."communication_ai_usage"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."communication_ai_usage"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_interactive_2d" IS 'Escenas nativas 2D con puntos o regiones seleccionables';
COMMENT ON COLUMN "app"."content_interactive_2d"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_interactive_2d"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."content_interactive_2d"."scene_kind" IS 'Dato scene kind de app.content_interactive_2d; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_interactive_2d"."renderer" IS 'Dato renderer de app.content_interactive_2d; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_interactive_2d"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."content_interactive_2d"."scene_data" IS 'Configuración estructurada scene data validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_interactive_2d"."min_app_version" IS 'Dato min app version de app.content_interactive_2d; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_interactive_2d"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."content_interactive_2d"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_interactive_2d"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_interactive_2d"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_interactive_2d"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_interactive_hotspots" IS 'Zonas, coordenadas, regiones y acciones locales en 2D';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."scene_id" IS 'Vínculo referencial con app.content_interactive_2d mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."label" IS 'Dato label de app.content_interactive_hotspots; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."geometry" IS 'Configuración estructurada geometry validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."action_type" IS 'Dato action type de app.content_interactive_hotspots; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."payload" IS 'Configuración estructurada payload validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_interactive_hotspots"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_models_3d" IS 'Metadatos de visualización 3D, sin simulación física implícita';
COMMENT ON COLUMN "app"."content_models_3d"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_models_3d"."resource_id" IS 'Recurso educativo asociado. Clave externa a app.catalog_resources.';
COMMENT ON COLUMN "app"."content_models_3d"."model_asset_id" IS 'Vínculo referencial con app.catalog_media_assets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_models_3d"."format" IS 'Dato format de app.content_models_3d; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_models_3d"."viewer_options" IS 'Configuración estructurada viewer options validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_models_3d"."is_ar_enabled" IS 'Indicador lógico (is_ar_enabled) utilizado en las reglas de negocio de app.content_models_3d.';
COMMENT ON COLUMN "app"."content_models_3d"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_models_3d"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_models_3d"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_models_3d"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_model_annotations" IS 'Etiquetas informativas de modelos 3D';
COMMENT ON COLUMN "app"."content_model_annotations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_model_annotations"."model_id" IS 'Vínculo referencial con app.content_models_3d mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_model_annotations"."label" IS 'Dato label de app.content_model_annotations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_model_annotations"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."content_model_annotations"."anchor" IS 'Configuración estructurada anchor validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_model_annotations"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."content_model_annotations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_model_annotations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_model_annotations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_model_annotations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_simulators" IS 'Laboratorios virtuales 2D, 3D o calculadoras';
COMMENT ON COLUMN "app"."content_simulators"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_simulators"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."content_simulators"."owner_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_simulators"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."content_simulators"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."content_simulators"."simulator_type" IS 'Dato simulator type de app.content_simulators; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulators"."runtime" IS 'Dato runtime de app.content_simulators; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulators"."version" IS 'Dato version de app.content_simulators; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulators"."config" IS 'Configuración estructurada config validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_simulators"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."content_simulators"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_simulators"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_simulators"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_simulators"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_simulator_parameters" IS 'Parámetros medibles/editables y validación de simulador';
COMMENT ON COLUMN "app"."content_simulator_parameters"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."simulator_id" IS 'Vínculo referencial con app.content_simulators mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."label" IS 'Dato label de app.content_simulator_parameters; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."data_type" IS 'Dato data type de app.content_simulator_parameters; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."unit" IS 'Dato unit de app.content_simulator_parameters; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."min_value" IS 'Dato min value de app.content_simulator_parameters; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."max_value" IS 'Cantidad, correlativo o límite de max value.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."default_value" IS 'Configuración estructurada default value validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_simulator_parameters"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_simulator_experiments" IS 'Prácticas o ejercicios guiados';
COMMENT ON COLUMN "app"."content_simulator_experiments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."simulator_id" IS 'Vínculo referencial con app.content_simulators mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."lesson_id" IS 'Lección o submódulo de aprendizaje. Clave externa a app.catalog_lessons.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."instructions" IS 'Dato instructions de app.content_simulator_experiments; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."expected_results" IS 'Configuración estructurada expected results validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_simulator_experiments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."content_simulation_runs" IS 'Ejecuciones con parámetros y resultados reproducibles';
COMMENT ON COLUMN "app"."content_simulation_runs"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."content_simulation_runs"."experiment_id" IS 'Vínculo referencial con app.content_simulator_experiments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."content_simulation_runs"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."content_simulation_runs"."started_at" IS 'Fecha y hora del evento started con zona horaria.';
COMMENT ON COLUMN "app"."content_simulation_runs"."finished_at" IS 'Fecha y hora del evento finished con zona horaria.';
COMMENT ON COLUMN "app"."content_simulation_runs"."input_values" IS 'Configuración estructurada input values validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_simulation_runs"."output_values" IS 'Configuración estructurada output values validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."content_simulation_runs"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."content_simulation_runs"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."content_simulation_runs"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."content_simulation_runs"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."content_simulation_runs"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_plans" IS 'Planes ChemXR: gratuito, básico, intermedio, avanzado';
COMMENT ON COLUMN "app"."platform_plans"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_plans"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."platform_plans"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."platform_plans"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."platform_plans"."target_type" IS 'Dato target type de app.platform_plans; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_plans"."is_active" IS 'Indica si el registro está operativo.';
COMMENT ON COLUMN "app"."platform_plans"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_plans"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_plans"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_plans"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_features" IS 'Catálogo versionado de capacidades de producto';
COMMENT ON COLUMN "app"."platform_features"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_features"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."platform_features"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."platform_features"."value_type" IS 'Dato value type de app.platform_features; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_features"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."platform_features"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_features"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_features"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_features"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_plan_entitlements" IS 'Límites configurables por plan';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."plan_id" IS 'Vínculo referencial con app.platform_plans mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."feature_id" IS 'Vínculo referencial con app.platform_features mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."enabled" IS 'Bandera de configuración enabled.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."limit_numeric" IS 'Dato limit numeric de app.platform_plan_entitlements; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."config" IS 'Configuración estructurada config validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_plan_entitlements"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_plan_prices" IS 'Precios y moneda por ciclo de facturación';
COMMENT ON COLUMN "app"."platform_plan_prices"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_plan_prices"."plan_id" IS 'Vínculo referencial con app.platform_plans mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_plan_prices"."currency" IS 'Moneda de la transacción, en código ISO de tres letras.';
COMMENT ON COLUMN "app"."platform_plan_prices"."billing_interval" IS 'Dato billing interval de app.platform_plan_prices; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_plan_prices"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."platform_plan_prices"."effective_from" IS 'Dato effective from de app.platform_plan_prices; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_plan_prices"."effective_to" IS 'Dato effective to de app.platform_plan_prices; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_plan_prices"."is_active" IS 'Indica si el registro está operativo.';
COMMENT ON COLUMN "app"."platform_plan_prices"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_plan_prices"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_plan_prices"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_plan_prices"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_subscriptions" IS 'Suscripción del usuario o institución a ChemXR';
COMMENT ON COLUMN "app"."platform_subscriptions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_subscriptions"."plan_id" IS 'Vínculo referencial con app.platform_plans mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_subscriptions"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."platform_subscriptions"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."platform_subscriptions"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."platform_subscriptions"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."platform_subscriptions"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."platform_subscriptions"."auto_renew" IS 'Bandera de configuración auto renew.';
COMMENT ON COLUMN "app"."platform_subscriptions"."external_reference" IS 'Dato external reference de app.platform_subscriptions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_subscriptions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_subscriptions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_subscriptions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_subscriptions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_subscription_usage" IS 'Uso agregado de capacidades controladas';
COMMENT ON COLUMN "app"."platform_subscription_usage"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."subscription_id" IS 'Vínculo referencial con app.platform_subscriptions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."feature_id" IS 'Vínculo referencial con app.platform_features mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."period_start" IS 'Dato period start de app.platform_subscription_usage; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."period_end" IS 'Dato period end de app.platform_subscription_usage; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."units_used" IS 'Dato units used de app.platform_subscription_usage; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_subscription_usage"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_checkout_orders" IS 'Orden de adquisición de planes ChemXR';
COMMENT ON COLUMN "app"."platform_checkout_orders"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."subscription_id" IS 'Vínculo referencial con app.platform_subscriptions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."buyer_person_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."currency" IS 'Moneda de la transacción, en código ISO de tres letras.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."amount_due" IS 'Dato amount due de app.platform_checkout_orders; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."external_reference" IS 'Dato external reference de app.platform_checkout_orders; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_checkout_orders"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_platform_payments" IS 'Cobros por planes (no pagos de matrícula)';
COMMENT ON COLUMN "app"."platform_platform_payments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_platform_payments"."order_id" IS 'Vínculo referencial con app.platform_checkout_orders mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_platform_payments"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."platform_platform_payments"."currency" IS 'Moneda de la transacción, en código ISO de tres letras.';
COMMENT ON COLUMN "app"."platform_platform_payments"."provider" IS 'Dato provider de app.platform_platform_payments; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_platform_payments"."provider_reference" IS 'Referencia externa usada para conciliar e impedir duplicados.';
COMMENT ON COLUMN "app"."platform_platform_payments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."platform_platform_payments"."paid_at" IS 'Fecha y hora del evento paid con zona horaria.';
COMMENT ON COLUMN "app"."platform_platform_payments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_platform_payments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_platform_payments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_platform_payments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_ad_campaigns" IS 'Campañas de publicidad permitidas en ChemXR';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."advertiser_name" IS 'Dato advertiser name de app.platform_ad_campaigns; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."budget" IS 'Dato budget de app.platform_ad_campaigns; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."targeting" IS 'Configuración estructurada targeting validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_ad_campaigns"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_ad_creatives" IS 'Piezas, imágenes y URLs de campañas';
COMMENT ON COLUMN "app"."platform_ad_creatives"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."campaign_id" IS 'Vínculo referencial con app.platform_ad_campaigns mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."headline" IS 'Dato headline de app.platform_ad_creatives; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."target_url" IS 'Dirección de acceso a target url.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_ad_creatives"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_ad_placements" IS 'Lugares disponibles para mostrar publicidad';
COMMENT ON COLUMN "app"."platform_ad_placements"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_ad_placements"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."platform_ad_placements"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."platform_ad_placements"."surface" IS 'Dato surface de app.platform_ad_placements; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_ad_placements"."max_frequency_per_day" IS 'Cantidad, correlativo o límite de max frequency per day.';
COMMENT ON COLUMN "app"."platform_ad_placements"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_placements"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_ad_placements"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_ad_placements"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."platform_ad_events" IS 'Impresiones y clics, sin almacenar secretos ni datos sensibles';
COMMENT ON COLUMN "app"."platform_ad_events"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."platform_ad_events"."campaign_id" IS 'Vínculo referencial con app.platform_ad_campaigns mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_ad_events"."creative_id" IS 'Vínculo referencial con app.platform_ad_creatives mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_ad_events"."placement_id" IS 'Vínculo referencial con app.platform_ad_placements mediante su identificador UUID.';
COMMENT ON COLUMN "app"."platform_ad_events"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."platform_ad_events"."event_type" IS 'Dato event type de app.platform_ad_events; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."platform_ad_events"."occurred_at" IS 'Fecha y hora del evento occurred con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_events"."anonymous_session_id" IS 'Identificador auxiliar anonymous_session_id dentro del modelo app.platform_ad_events.';
COMMENT ON COLUMN "app"."platform_ad_events"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."platform_ad_events"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."platform_ad_events"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."platform_ad_events"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_tuition_schedules" IS 'Escalas de pensión/arancel por institución y periodo';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."program_id" IS 'Programa, carrera o especialización institucional. Clave externa a app.academic_programs.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."currency" IS 'Moneda de la transacción, en código ISO de tres letras.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."installments_count" IS 'Cantidad, correlativo o límite de installments count.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_tuition_schedules"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_student_accounts" IS 'Cuenta financiera de un estudiante en la institución';
COMMENT ON COLUMN "app"."finance_student_accounts"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_student_accounts"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."finance_student_accounts"."student_program_id" IS 'Vínculo referencial con app.academic_student_programs mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_student_accounts"."currency" IS 'Moneda de la transacción, en código ISO de tres letras.';
COMMENT ON COLUMN "app"."finance_student_accounts"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."finance_student_accounts"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_student_accounts"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_student_accounts"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_student_accounts"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_student_charges" IS 'Cargos por matrícula, pensión, servicios o trámites';
COMMENT ON COLUMN "app"."finance_student_charges"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_student_charges"."account_id" IS 'Vínculo referencial con app.finance_student_accounts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_student_charges"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."finance_student_charges"."charge_type" IS 'Dato charge type de app.finance_student_charges; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_student_charges"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."finance_student_charges"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."finance_student_charges"."issued_on" IS 'Fecha calendario para issued on.';
COMMENT ON COLUMN "app"."finance_student_charges"."due_on" IS 'Fecha calendario para due on.';
COMMENT ON COLUMN "app"."finance_student_charges"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."finance_student_charges"."reference_code" IS 'Dato reference code de app.finance_student_charges; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_student_charges"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_student_charges"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_student_charges"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_student_charges"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_installments" IS 'Cuotas de un cargo y fechas de vencimiento';
COMMENT ON COLUMN "app"."finance_installments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_installments"."charge_id" IS 'Vínculo referencial con app.finance_student_charges mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_installments"."installment_number" IS 'Cantidad, correlativo o límite de installment number.';
COMMENT ON COLUMN "app"."finance_installments"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."finance_installments"."due_on" IS 'Fecha calendario para due on.';
COMMENT ON COLUMN "app"."finance_installments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."finance_installments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_installments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_installments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_installments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_student_payments" IS 'Recaudaciones institucionales separadas de planes ChemXR';
COMMENT ON COLUMN "app"."finance_student_payments"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_student_payments"."account_id" IS 'Vínculo referencial con app.finance_student_accounts mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_student_payments"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."finance_student_payments"."currency" IS 'Moneda de la transacción, en código ISO de tres letras.';
COMMENT ON COLUMN "app"."finance_student_payments"."payment_method" IS 'Dato payment method de app.finance_student_payments; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_student_payments"."provider_reference" IS 'Referencia externa usada para conciliar e impedir duplicados.';
COMMENT ON COLUMN "app"."finance_student_payments"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."finance_student_payments"."paid_at" IS 'Fecha y hora del evento paid con zona horaria.';
COMMENT ON COLUMN "app"."finance_student_payments"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_student_payments"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_student_payments"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_student_payments"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_payment_allocations" IS 'Imputación de pagos a cuotas (permitir pagos parciales)';
COMMENT ON COLUMN "app"."finance_payment_allocations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."payment_id" IS 'Vínculo referencial con app.finance_student_payments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."installment_id" IS 'Vínculo referencial con app.finance_installments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."amount" IS 'Importe monetario expresado en la moneda indicada.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_payment_allocations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_scholarships" IS 'Becas, descuentos y convenios institucionales';
COMMENT ON COLUMN "app"."finance_scholarships"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_scholarships"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."finance_scholarships"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."finance_scholarships"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."finance_scholarships"."benefit_type" IS 'Dato benefit type de app.finance_scholarships; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_scholarships"."benefit_value" IS 'Dato benefit value de app.finance_scholarships; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_scholarships"."rules" IS 'Configuración estructurada rules validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."finance_scholarships"."is_active" IS 'Indica si el registro está operativo.';
COMMENT ON COLUMN "app"."finance_scholarships"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_scholarships"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_scholarships"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_scholarships"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_scholarship_applications" IS 'Postulaciones a beca/convenio';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."scholarship_id" IS 'Vínculo referencial con app.finance_scholarships mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."student_program_id" IS 'Vínculo referencial con app.academic_student_programs mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."requested_at" IS 'Fecha y hora del evento requested con zona horaria.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."decision_at" IS 'Fecha y hora del evento decision con zona horaria.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."reviewer_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_scholarship_applications"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_scholarship_awards" IS 'Beneficios aprobados aplicados a periodos';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."application_id" IS 'Vínculo referencial con app.finance_scholarship_applications mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."term_id" IS 'Periodo lectivo de la institución. Clave externa a app.academic_terms.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."approved_value" IS 'Dato approved value de app.finance_scholarship_awards; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."starts_on" IS 'Fecha calendario para starts on.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."ends_on" IS 'Fecha calendario para ends on.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_scholarship_awards"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."finance_financial_documents" IS 'Comprobantes y constancias de pago';
COMMENT ON COLUMN "app"."finance_financial_documents"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."finance_financial_documents"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."finance_financial_documents"."payment_id" IS 'Vínculo referencial con app.finance_student_payments mediante su identificador UUID.';
COMMENT ON COLUMN "app"."finance_financial_documents"."document_type" IS 'Clasificación del documento de identidad o comprobante.';
COMMENT ON COLUMN "app"."finance_financial_documents"."series" IS 'Dato series de app.finance_financial_documents; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_financial_documents"."number" IS 'Dato number de app.finance_financial_documents; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."finance_financial_documents"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."finance_financial_documents"."issued_at" IS 'Momento de emisión del documento o cargo.';
COMMENT ON COLUMN "app"."finance_financial_documents"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."finance_financial_documents"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."finance_financial_documents"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."finance_financial_documents"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."finance_financial_documents"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_procedures" IS 'Catálogo de trámites configurables por institución';
COMMENT ON COLUMN "app"."services_procedures"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_procedures"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_procedures"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."services_procedures"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."services_procedures"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."services_procedures"."fee_amount" IS 'Dato fee amount de app.services_procedures; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedures"."response_days" IS 'Dato response days de app.services_procedures; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedures"."requirements" IS 'Configuración estructurada requirements validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."services_procedures"."is_active" IS 'Indica si el registro está operativo.';
COMMENT ON COLUMN "app"."services_procedures"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_procedures"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_procedures"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_procedures"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_procedure_steps" IS 'Etapas y responsables definidos para un trámite';
COMMENT ON COLUMN "app"."services_procedure_steps"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_procedure_steps"."procedure_id" IS 'Vínculo referencial con app.services_procedures mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_procedure_steps"."step_order" IS 'Dato step order de app.services_procedure_steps; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedure_steps"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."services_procedure_steps"."required_role" IS 'Dato required role de app.services_procedure_steps; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedure_steps"."settings" IS 'Opciones configurables de comportamiento.';
COMMENT ON COLUMN "app"."services_procedure_steps"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_procedure_steps"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_procedure_steps"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_procedure_steps"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_procedure_fields" IS 'Campos de formularios administrativos dinámicos';
COMMENT ON COLUMN "app"."services_procedure_fields"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_procedure_fields"."procedure_id" IS 'Vínculo referencial con app.services_procedures mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_procedure_fields"."field_code" IS 'Dato field code de app.services_procedure_fields; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedure_fields"."label" IS 'Dato label de app.services_procedure_fields; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedure_fields"."field_type" IS 'Dato field type de app.services_procedure_fields; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_procedure_fields"."required" IS 'Bandera de configuración required.';
COMMENT ON COLUMN "app"."services_procedure_fields"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."services_procedure_fields"."validation_rules" IS 'Configuración estructurada validation rules validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."services_procedure_fields"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_procedure_fields"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_procedure_fields"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_procedure_fields"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_requests" IS 'Expedientes y solicitudes académicas/administrativas';
COMMENT ON COLUMN "app"."services_requests"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_requests"."procedure_id" IS 'Vínculo referencial con app.services_procedures mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_requests"."requester_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_requests"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_requests"."tracking_code" IS 'Dato tracking code de app.services_requests; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_requests"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_requests"."current_step_id" IS 'Vínculo referencial con app.services_procedure_steps mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_requests"."submitted_at" IS 'Momento de entrega o presentación de la solicitud.';
COMMENT ON COLUMN "app"."services_requests"."closed_at" IS 'Fecha y hora del evento closed con zona horaria.';
COMMENT ON COLUMN "app"."services_requests"."form_data" IS 'Configuración estructurada form data validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."services_requests"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_requests"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_requests"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_requests"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_request_files" IS 'Sustentos adjuntos por trámite';
COMMENT ON COLUMN "app"."services_request_files"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_request_files"."request_id" IS 'Vínculo referencial con app.services_requests mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_request_files"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."services_request_files"."purpose" IS 'Dato purpose de app.services_request_files; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_request_files"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_request_files"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_request_files"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_request_files"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_request_transitions" IS 'Historial de atención y aprobación';
COMMENT ON COLUMN "app"."services_request_transitions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_request_transitions"."request_id" IS 'Vínculo referencial con app.services_requests mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_request_transitions"."step_id" IS 'Vínculo referencial con app.services_procedure_steps mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_request_transitions"."actor_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_request_transitions"."from_status" IS 'Dato from status de app.services_request_transitions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_request_transitions"."to_status" IS 'Dato to status de app.services_request_transitions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_request_transitions"."remarks" IS 'Dato remarks de app.services_request_transitions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_request_transitions"."occurred_at" IS 'Fecha y hora del evento occurred con zona horaria.';
COMMENT ON COLUMN "app"."services_request_transitions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_request_transitions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_request_transitions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_request_transitions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_service_offerings" IS 'Servicios institucionales (gimnasio, comedor, biblioteca, soporte)';
COMMENT ON COLUMN "app"."services_service_offerings"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_service_offerings"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_service_offerings"."code" IS 'Código legible para identificar el registro dentro de su contexto.';
COMMENT ON COLUMN "app"."services_service_offerings"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."services_service_offerings"."service_type" IS 'Dato service type de app.services_service_offerings; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_service_offerings"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."services_service_offerings"."eligibility_rules" IS 'Configuración estructurada eligibility rules validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."services_service_offerings"."is_active" IS 'Indica si el registro está operativo.';
COMMENT ON COLUMN "app"."services_service_offerings"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_service_offerings"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_service_offerings"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_service_offerings"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_service_memberships" IS 'Derechos de uso de un servicio con vigencia';
COMMENT ON COLUMN "app"."services_service_memberships"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_service_memberships"."offering_id" IS 'Vínculo referencial con app.services_service_offerings mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_service_memberships"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."services_service_memberships"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."services_service_memberships"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."services_service_memberships"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_service_memberships"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_service_memberships"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_service_memberships"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_service_memberships"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_physical_assets" IS 'Inventario de libros, tablets, equipos, cubículos y ambientes';
COMMENT ON COLUMN "app"."services_physical_assets"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_physical_assets"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_physical_assets"."site_id" IS 'Vínculo referencial con app.core_organization_sites mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_physical_assets"."asset_code" IS 'Dato asset code de app.services_physical_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_physical_assets"."name" IS 'Denominación visible del registro.';
COMMENT ON COLUMN "app"."services_physical_assets"."asset_type" IS 'Dato asset type de app.services_physical_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_physical_assets"."inventory_status" IS 'Dato inventory status de app.services_physical_assets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_physical_assets"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."services_physical_assets"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_physical_assets"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_physical_assets"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_physical_assets"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_asset_reservations" IS 'Reservas por fecha/hora con autorizaciones y cupos';
COMMENT ON COLUMN "app"."services_asset_reservations"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_asset_reservations"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.services_physical_assets.';
COMMENT ON COLUMN "app"."services_asset_reservations"."requested_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_asset_reservations"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."services_asset_reservations"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."services_asset_reservations"."purpose" IS 'Dato purpose de app.services_asset_reservations; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_asset_reservations"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_asset_reservations"."approved_by" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_asset_reservations"."approved_at" IS 'Fecha de aprobación del registro.';
COMMENT ON COLUMN "app"."services_asset_reservations"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_asset_reservations"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_asset_reservations"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_asset_reservations"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_reservation_attendees" IS 'Participantes de una reserva grupal';
COMMENT ON COLUMN "app"."services_reservation_attendees"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_reservation_attendees"."reservation_id" IS 'Vínculo referencial con app.services_asset_reservations mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_reservation_attendees"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."services_reservation_attendees"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_reservation_attendees"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_reservation_attendees"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_reservation_attendees"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_asset_loans" IS 'Préstamos físicos con vencimiento y devolución';
COMMENT ON COLUMN "app"."services_asset_loans"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_asset_loans"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.services_physical_assets.';
COMMENT ON COLUMN "app"."services_asset_loans"."person_id" IS 'Persona a la que corresponde este registro. Clave externa a app.core_people.';
COMMENT ON COLUMN "app"."services_asset_loans"."loaned_at" IS 'Fecha y hora del evento loaned con zona horaria.';
COMMENT ON COLUMN "app"."services_asset_loans"."due_at" IS 'Fecha y hora límite de cumplimiento o entrega.';
COMMENT ON COLUMN "app"."services_asset_loans"."returned_at" IS 'Fecha y hora del evento returned con zona horaria.';
COMMENT ON COLUMN "app"."services_asset_loans"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_asset_loans"."notes" IS 'Dato notes de app.services_asset_loans; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_asset_loans"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_asset_loans"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_asset_loans"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_asset_loans"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_surveys" IS 'Encuestas mensuales, de docente, curso o institución';
COMMENT ON COLUMN "app"."services_surveys"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_surveys"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_surveys"."course_id" IS 'Curso reusable vinculado a esta entidad. Clave externa a app.catalog_courses.';
COMMENT ON COLUMN "app"."services_surveys"."section_id" IS 'Sección académica impartida en un periodo institucional. Clave externa a app.academic_sections.';
COMMENT ON COLUMN "app"."services_surveys"."teacher_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_surveys"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."services_surveys"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."services_surveys"."survey_type" IS 'Dato survey type de app.services_surveys; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_surveys"."starts_at" IS 'Fecha y hora de inicio, con zona horaria.';
COMMENT ON COLUMN "app"."services_surveys"."ends_at" IS 'Fecha y hora de finalización, con zona horaria.';
COMMENT ON COLUMN "app"."services_surveys"."anonymous" IS 'Indica si se buscan respuestas sin identificar al participante.';
COMMENT ON COLUMN "app"."services_surveys"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_surveys"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_surveys"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_surveys"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_surveys"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_survey_questions" IS 'Preguntas y opciones configurables';
COMMENT ON COLUMN "app"."services_survey_questions"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_survey_questions"."survey_id" IS 'Vínculo referencial con app.services_surveys mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_survey_questions"."sort_order" IS 'Orden relativo de presentación dentro de una colección.';
COMMENT ON COLUMN "app"."services_survey_questions"."prompt" IS 'Dato prompt de app.services_survey_questions; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_survey_questions"."question_type" IS 'Modalidad de pregunta (selección, texto, etc.).';
COMMENT ON COLUMN "app"."services_survey_questions"."options" IS 'Configuración estructurada options validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."services_survey_questions"."is_required" IS 'Indicador lógico (is_required) utilizado en las reglas de negocio de app.services_survey_questions.';
COMMENT ON COLUMN "app"."services_survey_questions"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_survey_questions"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_survey_questions"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_survey_questions"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_survey_responses" IS 'Envíos con anonimización opcional';
COMMENT ON COLUMN "app"."services_survey_responses"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_survey_responses"."survey_id" IS 'Vínculo referencial con app.services_surveys mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_survey_responses"."respondent_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_survey_responses"."submitted_at" IS 'Momento de entrega o presentación de la solicitud.';
COMMENT ON COLUMN "app"."services_survey_responses"."anonymous_token" IS 'Dato anonymous token de app.services_survey_responses; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_survey_responses"."metadata" IS 'Metadatos auxiliares estructurados; no sustituye relaciones formales.';
COMMENT ON COLUMN "app"."services_survey_responses"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_survey_responses"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_survey_responses"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_survey_responses"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_survey_answers" IS 'Respuestas a preguntas de una encuesta';
COMMENT ON COLUMN "app"."services_survey_answers"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_survey_answers"."response_id" IS 'Vínculo referencial con app.services_survey_responses mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_survey_answers"."question_id" IS 'Vínculo referencial con app.services_survey_questions mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_survey_answers"."answer" IS 'Configuración estructurada answer validada por el servicio correspondiente.';
COMMENT ON COLUMN "app"."services_survey_answers"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_survey_answers"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_survey_answers"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_survey_answers"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_support_tickets" IS 'Solicitudes de ayuda y soporte técnico';
COMMENT ON COLUMN "app"."services_support_tickets"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_support_tickets"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_support_tickets"."requester_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_support_tickets"."assigned_to" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_support_tickets"."subject" IS 'Dato subject de app.services_support_tickets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_support_tickets"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."services_support_tickets"."priority" IS 'Dato priority de app.services_support_tickets; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_support_tickets"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_support_tickets"."closed_at" IS 'Fecha y hora del evento closed con zona horaria.';
COMMENT ON COLUMN "app"."services_support_tickets"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_support_tickets"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_support_tickets"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_support_tickets"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_support_messages" IS 'Conversación y archivos en ticket de soporte';
COMMENT ON COLUMN "app"."services_support_messages"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_support_messages"."ticket_id" IS 'Vínculo referencial con app.services_support_tickets mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_support_messages"."author_id" IS 'Vínculo referencial con app.core_people mediante su identificador UUID.';
COMMENT ON COLUMN "app"."services_support_messages"."body" IS 'Contenido textual principal.';
COMMENT ON COLUMN "app"."services_support_messages"."asset_id" IS 'Archivo gestionado en el almacenamiento de objetos. Clave externa a app.catalog_media_assets.';
COMMENT ON COLUMN "app"."services_support_messages"."is_internal" IS 'Indicador lógico (is_internal) utilizado en las reglas de negocio de app.services_support_messages.';
COMMENT ON COLUMN "app"."services_support_messages"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_support_messages"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_support_messages"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_support_messages"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';
COMMENT ON TABLE "app"."services_job_postings" IS 'Bolsa de trabajo institucional y oportunidades';
COMMENT ON COLUMN "app"."services_job_postings"."id" IS 'Identificador UUID interno de la fila.';
COMMENT ON COLUMN "app"."services_job_postings"."organization_id" IS 'Institución o entidad académica responsable; también define alcance de tenant. Clave externa a app.core_organizations.';
COMMENT ON COLUMN "app"."services_job_postings"."company_name" IS 'Dato company name de app.services_job_postings; su significado exacto se determina en las reglas del módulo.';
COMMENT ON COLUMN "app"."services_job_postings"."title" IS 'Título visible en la interfaz o el documento.';
COMMENT ON COLUMN "app"."services_job_postings"."description" IS 'Explicación o descripción del elemento.';
COMMENT ON COLUMN "app"."services_job_postings"."application_url" IS 'Dirección de acceso a application url.';
COMMENT ON COLUMN "app"."services_job_postings"."closes_at" IS 'Fecha y hora del evento closes con zona horaria.';
COMMENT ON COLUMN "app"."services_job_postings"."status" IS 'Estado de ciclo de vida de este elemento.';
COMMENT ON COLUMN "app"."services_job_postings"."created_at" IS 'Fecha de creación registrada con zona horaria.';
COMMENT ON COLUMN "app"."services_job_postings"."updated_at" IS 'Fecha de última modificación de los datos.';
COMMENT ON COLUMN "app"."services_job_postings"."created_by" IS 'Persona que registró el dato, cuando se dispone de su identidad.';
COMMENT ON COLUMN "app"."services_job_postings"."updated_by" IS 'Persona que realizó la última actualización, cuando aplica.';

INSERT INTO "app"."platform_plans" (code,name,description,target_type) VALUES ('free','Gratuito','Plan de introducción','person'),('basic','Básico','Plan configurable','person'),('intermediate','Intermedio','Plan configurable','person'),('advanced','Avanzado','Plan configurable','person') ON CONFLICT (code) DO NOTHING;
INSERT INTO "app"."platform_features" (code,name,value_type,description) VALUES ('private_rooms','Aulas privadas','number','Cantidad de aulas activas'),('room_participants','Participantes por aula','number','Cupo máximo por aula'),('room_retention_days','Retención tras cierre','number','Días para recuperar material'),('storage_gb','Almacenamiento en GB','number','Cuota de almacenamiento'),('ai_queries','Consultas al tutor IA','number','Límite por periodo'),('course_downloads','Descarga offline','boolean','Posibilidad de guardar material'),('simulator_access','Laboratorios y simuladores','boolean','Permiso de uso de simuladores') ON CONFLICT (code) DO NOTHING;

