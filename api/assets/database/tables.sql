-- Drop the enum type after dropping tables that use it
DROP TYPE IF EXISTS job_status;

-- Recreate the job status enum
CREATE TYPE job_status AS ENUM (
    'queued',
    'running',
    'completed',
    'failed',
    'canceled',
    'retrying'
);

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE,
    name VARCHAR(255),
    given_name VARCHAR(255),
    family_name VARCHAR(255),
    sub VARCHAR(255) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create jobs table
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    docu_sign_account_id VARCHAR(255),
    docu_sign_template_id VARCHAR(255),
    bucket_url VARCHAR(255),
    file_name VARCHAR(255),
    file_hash VARCHAR(255),
    report_id UUID UNIQUE,
    report_generated BOOLEAN DEFAULT FALSE,
    signing_url VARCHAR(255),
    recipients JSONB,
    send_at TIMESTAMP WITH TIME ZONE,
    errors JSONB,
    status job_status DEFAULT 'queued',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create reports table
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID UNIQUE,
    contract_content TEXT,
    final_report JSONB,
    trace_back JSONB,
    version VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_job FOREIGN KEY (job_id) REFERENCES jobs(id)
);

-- Add the foreign key constraint to jobs table for report_id
ALTER TABLE jobs
ADD CONSTRAINT fk_report FOREIGN KEY (report_id) REFERENCES reports(id);