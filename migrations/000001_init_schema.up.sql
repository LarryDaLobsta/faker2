-- Enable UUID generation (pgcrypto gives gen_random_uuid)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE datasets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  label TEXT,
  seed BIGINT NOT NULL,
  rows_requested INT NOT NULL CHECK (rows_requested > 0),

  gender_filter TEXT,
  marital_status_filter TEXT,
  salary_min NUMERIC(12,2),
  salary_max NUMERIC(12,2),
  age_min INT,
  age_max INT,

  CHECK (salary_min IS NULL OR salary_min >= 0),
  CHECK (salary_max IS NULL OR salary_max >= 0),
  CHECK (age_min IS NULL OR age_min >= 0),
  CHECK (age_max IS NULL OR age_max >= 0),
  CHECK (
    salary_min IS NULL OR salary_max IS NULL OR salary_min <= salary_max
  ),
  CHECK (
    age_min IS NULL OR age_max IS NULL OR age_min <= age_max
  )
);

CREATE TABLE people (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dataset_id UUID NOT NULL REFERENCES datasets(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  first_name TEXT NOT NULL,
  middle_name TEXT,
  last_name TEXT NOT NULL,

  gender TEXT,
  marital_status TEXT,

  age INT CHECK (age IS NULL OR (age >= 0 AND age <= 120)),
  weight_lbs INT CHECK (weight_lbs IS NULL OR weight_lbs >= 0),

  occupation TEXT,
  occupational_pay NUMERIC(12,2) CHECK (occupational_pay IS NULL OR occupational_pay >= 0),

  city TEXT,
  state TEXT,
  zip_code TEXT, -- keep as TEXT to preserve leading zeros

  college_type TEXT,
  college_degree TEXT,
  college_location TEXT
);

-- Critical performance index for "view dataset"
CREATE INDEX idx_people_dataset_id ON people(dataset_id);