CREATE SCHEMA "navarch";

CREATE TYPE "address_type" AS ENUM (
  'billing',
  'shipping'
);

CREATE TYPE "status_type" AS ENUM (
  'physical',
  'financial'
);

CREATE TYPE "status_value" AS ENUM (
  'planned',
  'in_transit',
  'invoiced',
  'finalized'
);

CREATE TYPE "contract_type" AS ENUM (
  'frame',
  'spot',
  'moa'
);

CREATE TYPE "assay_type" AS ENUM (
  'planned_inturn',
  'inturn_final',
  'estimate',
  'outurn'
);

CREATE TYPE "invoice_type" AS ENUM (
  'proforma',
  'provisional1',
  'provisional2',
  'provisional3',
  'final'
);

CREATE TYPE "payment_trigger_event" AS ENUM (
  'invoicing_date',
  'assay_date',
  'bill_of_lading_date',
  'final_assay_date',
  'qp_terms'
);

CREATE TABLE "navarch"."customer" (
  "code" varchar(63) UNIQUE PRIMARY KEY,
  "name" varchar(255) NOT NULL,
  "valid_from" timestamp NOT NULL,
  "valid_to" timestamp DEFAULT null,
  "description" text DEFAULT null
);

CREATE TABLE "navarch"."contact" (
  "id" SERIAL PRIMARY KEY,
  "customer_code" varchar(63),
  "first_name" varchar(255),
  "last_name" varchar(255),
  "primary_contact" boolean
);

CREATE TABLE "navarch"."address" (
  "id" SERIAL PRIMARY KEY,
  "line1" varchar(255),
  "line2" varchar(255),
  "city" varchar(127),
  "province" varchar(127),
  "zip" varchar(31),
  "country" varchar(2),
  "phone" integer,
  "type" address_type
);

CREATE TABLE "navarch"."ref_country" (
  "iso2" varchar(2) PRIMARY KEY,
  "iso3" varchar(3),
  "name" varchar(80),
  "description" text,
  "num_code" numeric(3),
  "phone_code" numeric(3)
);

CREATE TABLE "navarch"."customer_address" (
  "id" SERIAL PRIMARY KEY,
  "customer_code" integer,
  "address_type" address_type,
  "address_id" integer,
  "valid_from" date,
  "valid_to" date
);

CREATE TABLE "navarch"."status" (
  "id" integer PRIMARY KEY,
  "type" status_type,
  "status" status_value
);

CREATE TABLE "navarch"."parcel" (
  "id" SERIAL PRIMARY KEY,
  "contract_id" integer,
  "parcel_number" int8,
  "status" integer,
  "shipment" integer,
  "letter_of_credit" integer DEFAULT null
);

CREATE TABLE "navarch"."ref_currency" (
  "id" integer PRIMARY KEY,
  "code" varchar(3),
  "description" varchar(63),
  "symbol" char(3)
);

CREATE TABLE "navarch"."letter_of_credit" (
  "id" SERIAL PRIMARY KEY,
  "advice" text,
  "currency" integer,
  "value" integer,
  "portion" numeric DEFAULT 100,
  "date_received" date DEFAULT null,
  "date_expire" date DEFAULT null
);

CREATE TABLE "navarch"."ref_qp_code" (
  "id" SERIAL PRIMARY KEY,
  "code" varchar(31) UNIQUE
);

CREATE TABLE "navarch"."contract_material" (
  "id" SERIAL PRIMARY KEY,
  "contract_id" integer,
  "material_id" integer,
  "assay_id" integer,
  "is_primary" boolean,
  "required_grade" numeric,
  "required_percentage" numeric,
  "required_quality" numeric,
  "required_quality_unit" integer,
  "required_quantity" numeric,
  "required_quantity_unit" integer,
  "allowance_percent" numeric,
  "payable_percent" numeric,
  "minimum_deduction" numeric,
  "minimum_deduction_unit" integer,
  "splitting_limit" numeric,
  "splitting_limit_unit" integer,
  "penalty" integer
);

CREATE TABLE "navarch"."penalty" (
  "id" SERIAL PRIMARY KEY,
  "penalty_description" text,
  "threshold_unit" numeric,
  "magnitude_unit" numeric,
  "lte_not_lt" boolean DEFAULT true,
  "threshold_1" numeric DEFAULT null,
  "threshold_1_magnitude" numeric DEFAULT null,
  "threshold_2" numeric DEFAULT null,
  "threshold_2_magnitude" numeric DEFAULT null,
  "threshold_3" numeric DEFAULT null,
  "threshold_3_magnitude" numeric DEFAULT null,
  "threshold_4" numeric DEFAULT null,
  "threshold_4_magnitude" numeric DEFAULT null
);

CREATE TABLE "navarch"."ref_event" (
  "id" SERIAL PRIMARY KEY,
  "event" varchar(31),
  "short_desc" varchar(127),
  "description" text DEFAULT null
);

CREATE TABLE "navarch"."treatment_charge_rule" (
  "id" SERIAL PRIMARY KEY,
  "rule" varchar(127),
  "description" text DEFAULT null
);

CREATE TABLE "navarch"."umpire" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(31),
  "description" text DEFAULT null
);

CREATE TABLE "navarch"."contract_umpire" (
  "contract_id" integer,
  "umpire" integer
);

CREATE TABLE "navarch"."contract" (
  "id" SERIAL PRIMARY KEY,
  "type" contract_type,
  "counter_party" integer,
  "agreement_date" date,
  "effective_date" date,
  "expiration_date" date,
  "shipment_period_start" date,
  "shipment_period_end" date,
  "shipment_terms" integer,
  "qp_month" date,
  "qp_code" integer,
  "qp_code_number" int8,
  "is_lc" boolean,
  "bank" varchar(127) DEFAULT null,
  "revrec_rule" integer,
  "risk_transfer" integer,
  "title_transfer" integer,
  "revrec_date" date,
  "default_load_port" integer,
  "destination_port" integer,
  "shipment_size" numeric,
  "treatment_charges" integer,
  "treatment_unit" integer,
  "umpire_rule" text
);

CREATE TABLE "navarch"."assay" (
  "id" SERIAL PRIMARY KEY,
  "exchanged" boolean,
  "type" assay_type,
  "analytical" numeric,
  "unit" integer
);

CREATE TABLE "navarch"."ref_material" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(127),
  "symbol" varchar(127),
  "default_unit" integer,
  "exchanged" boolean
);

CREATE TABLE "navarch"."ref_unit" (
  "id" SERIAL PRIMARY KEY,
  "unit" varchar(31),
  "symbol" char(15),
  "description" text
);

CREATE TABLE "navarch"."shipment" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(24),
  "vessel" integer,
  "origin" integer,
  "destination" integer,
  "plan_date" date,
  "bl_date" date,
  "shipment_date" date,
  "laycan_start" date,
  "laycan_end" date,
  "estimate_arrival_date" date,
  "arrival_date" date,
  "order_number" int8,
  "freight_provider" integer,
  "loading" integer,
  "voyage" integer,
  "inturn_weight" double,
  "inturn_unit" integer,
  "outturn_weight" double,
  "outturn_unit" integer
);

CREATE TABLE "navarch"."vessel" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(127) UNIQUE
);

CREATE TABLE "navarch"."port" (
  "id" SERIAL PRIMARY KEY,
  "short_name" varchar(31),
  "long_name" varchar(63),
  "address" integer
);

CREATE TABLE "navarch"."freight_provider" (
  "id" SERIAL PRIMARY KEY
);

CREATE TABLE "navarch"."shipment_loading" (
  "id" SERIAL PRIMARY KEY
);

CREATE TABLE "navarch"."shipment_voyage" (
  "id" SERIAL PRIMARY KEY
);

CREATE TABLE "navarch"."ref_shipment_term" (
  "id" SERIAL PRIMARY KEY,
  "code" varchar(7),
  "representation" varchar(63),
  "code_text" varchar(127),
  "description" text
);

CREATE TABLE "navarch"."invoice" (
  "id" SERIAL PRIMARY KEY,
  "creation_time" datetime DEFAULT (now()),
  "type" invoice_type,
  "payment_percentage" numeric,
  "payment_days_before_event" int8,
  "payment_trigger_event" integer,
  "pricing_days_before_event" int8,
  "pricing_trigger_event" integer
);

CREATE TABLE "navarch"."payment" (
  "id" SERIAL PRIMARY KEY,
  "payment_for_invoice" integer
);

CREATE INDEX ON "navarch"."contract_umpire" ("contract_id", "umpire");

COMMENT ON TABLE "navarch"."customer" IS 'Buyer details should ideally be slow changing';

COMMENT ON COLUMN "navarch"."parcel"."parcel_number" IS 'One contract can have many parcels. This adds order or time history to each one.';

COMMENT ON COLUMN "navarch"."letter_of_credit"."advice" IS 'VERY VERY important';

COMMENT ON COLUMN "navarch"."contract_material"."is_primary" IS 'Indicates if material is the main one being traded in the contract';

COMMENT ON COLUMN "navarch"."contract_material"."required_grade" IS 'This is the required grade, if material is primary material. Actual material grade is found in assay.';

COMMENT ON COLUMN "navarch"."contract_material"."required_percentage" IS 'This is the required percentage, if material is primary material. Actual material percentage is found in assay.';

COMMENT ON COLUMN "navarch"."penalty"."penalty_description" IS 'Silica Analytical Assay % > 1.0 % then 2.00 USD/DMT for each 1 % above 1.0 %
Fractions Prorata';

COMMENT ON COLUMN "navarch"."penalty"."threshold_unit" IS 'TODO: Default to percentage';

COMMENT ON COLUMN "navarch"."penalty"."magnitude_unit" IS 'TODO: Default to USD/DMT';

COMMENT ON COLUMN "navarch"."penalty"."lte_not_lt" IS 'Default to using <= for each threshold level';

COMMENT ON COLUMN "navarch"."penalty"."threshold_1" IS 'Example, at 8%';

COMMENT ON TABLE "navarch"."ref_event" IS 'Distinct events that can be tied to RevRec rules, Risk or Title Transfer rules';

COMMENT ON COLUMN "navarch"."ref_event"."event" IS 'TODO: Apply unique constraint on lower(). eg: loaded, invoiced, unloaded, first payment etc';

COMMENT ON TABLE "navarch"."treatment_charge_rule" IS 'Example: Benchmark minus 69. TODO: Find out more.';

COMMENT ON COLUMN "navarch"."contract"."qp_month" IS 'The month and year to take average of market price that forms the quotational period price. The date doesnt matter';

COMMENT ON COLUMN "navarch"."contract"."qp_code" IS 'Reference table to a standard QP code list';

COMMENT ON COLUMN "navarch"."contract"."qp_code_number" IS 'Number of months for this QP code';

COMMENT ON COLUMN "navarch"."contract"."is_lc" IS 'Indicates if contract requires valid letter_of_credit';

COMMENT ON COLUMN "navarch"."contract"."bank" IS 'Could be tied to customer?';

COMMENT ON COLUMN "navarch"."contract"."revrec_date" IS 'It is a condition, like from first payment received, first issued invoice, etc';

COMMENT ON COLUMN "navarch"."contract"."treatment_unit" IS 'Probably not needed. Usually just currency/weight';

COMMENT ON COLUMN "navarch"."assay"."exchanged" IS 'whether a specific element is in contract or not (element that matters most for this parcel)';

COMMENT ON COLUMN "navarch"."assay"."type" IS 'planned inturn, inturn final, estimate, outurn';

COMMENT ON COLUMN "navarch"."assay"."analytical" IS 'Uses the default_unit';

COMMENT ON COLUMN "navarch"."shipment"."vessel" IS 'Add default to TBA vessel?';

COMMENT ON COLUMN "navarch"."shipment"."plan_date" IS 'Estimated date to complete loading (available for shipping)';

COMMENT ON COLUMN "navarch"."shipment"."bl_date" IS 'The actuale date when loading for shipment is completed';

COMMENT ON COLUMN "navarch"."shipment"."shipment_date" IS 'Never be entered. Calculated. Plan date if no BL date, otherwise BL date';

COMMENT ON COLUMN "navarch"."shipment"."laycan_start" IS 'keep';

COMMENT ON COLUMN "navarch"."shipment"."laycan_end" IS 'keep';

COMMENT ON COLUMN "navarch"."shipment"."estimate_arrival_date" IS 'Estimated discharge port (disport) arrival date';

COMMENT ON COLUMN "navarch"."shipment"."arrival_date" IS 'Actual discharge port (disport) arrival date';

COMMENT ON COLUMN "navarch"."shipment"."order_number" IS 'Calculated.';

COMMENT ON COLUMN "navarch"."shipment"."outturn_unit" IS 'TODO: Default show only one unit per commodity_traded, assume identical for in/out until proven wrong';

COMMENT ON COLUMN "navarch"."vessel"."name" IS 'TODO: Apply lower(name) unique constraint!';

COMMENT ON COLUMN "navarch"."shipment_loading"."id" IS 'May not be needed';

COMMENT ON COLUMN "navarch"."shipment_voyage"."id" IS 'May not be needed';

COMMENT ON COLUMN "navarch"."ref_shipment_term"."id" IS 'May not be needed';

ALTER TABLE "navarch"."contact" ADD FOREIGN KEY ("customer_code") REFERENCES "navarch"."customer" ("code");

ALTER TABLE "navarch"."address" ADD FOREIGN KEY ("country") REFERENCES "navarch"."ref_country" ("iso2");

ALTER TABLE "navarch"."customer_address" ADD FOREIGN KEY ("customer_code") REFERENCES "navarch"."customer" ("code");

ALTER TABLE "navarch"."customer_address" ADD FOREIGN KEY ("address_id") REFERENCES "navarch"."address" ("id");

ALTER TABLE "navarch"."parcel" ADD FOREIGN KEY ("contract_id") REFERENCES "navarch"."contract" ("id");

ALTER TABLE "navarch"."parcel" ADD FOREIGN KEY ("status") REFERENCES "navarch"."status" ("id");

ALTER TABLE "navarch"."parcel" ADD FOREIGN KEY ("shipment") REFERENCES "navarch"."shipment" ("id");

ALTER TABLE "navarch"."parcel" ADD FOREIGN KEY ("letter_of_credit") REFERENCES "navarch"."letter_of_credit" ("id");

ALTER TABLE "navarch"."ref_currency" ADD FOREIGN KEY ("id") REFERENCES "navarch"."letter_of_credit" ("currency");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("contract_id") REFERENCES "navarch"."contract" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("material_id") REFERENCES "navarch"."ref_material" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("assay_id") REFERENCES "navarch"."assay" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("required_quality_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("required_quantity_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("minimum_deduction_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("splitting_limit_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."contract_material" ADD FOREIGN KEY ("penalty") REFERENCES "navarch"."penalty" ("id");

ALTER TABLE "navarch"."penalty" ADD FOREIGN KEY ("threshold_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."penalty" ADD FOREIGN KEY ("magnitude_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."contract_umpire" ADD FOREIGN KEY ("contract_id") REFERENCES "navarch"."contract" ("id");

ALTER TABLE "navarch"."contract_umpire" ADD FOREIGN KEY ("umpire") REFERENCES "navarch"."umpire" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("counter_party") REFERENCES "navarch"."customer" ("code");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("shipment_terms") REFERENCES "navarch"."ref_shipment_term" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("qp_code") REFERENCES "navarch"."ref_qp_code" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("revrec_rule") REFERENCES "navarch"."ref_event" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("risk_transfer") REFERENCES "navarch"."ref_event" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("title_transfer") REFERENCES "navarch"."ref_event" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("default_load_port") REFERENCES "navarch"."port" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("destination_port") REFERENCES "navarch"."port" ("id");

ALTER TABLE "navarch"."contract" ADD FOREIGN KEY ("treatment_charges") REFERENCES "navarch"."treatment_charge_rule" ("id");

ALTER TABLE "navarch"."assay" ADD FOREIGN KEY ("unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."ref_material" ADD FOREIGN KEY ("default_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("vessel") REFERENCES "navarch"."vessel" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("origin") REFERENCES "navarch"."port" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("destination") REFERENCES "navarch"."port" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("freight_provider") REFERENCES "navarch"."freight_provider" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("loading") REFERENCES "navarch"."shipment_loading" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("voyage") REFERENCES "navarch"."shipment_voyage" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("inturn_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."shipment" ADD FOREIGN KEY ("outturn_unit") REFERENCES "navarch"."ref_unit" ("id");

ALTER TABLE "navarch"."port" ADD FOREIGN KEY ("address") REFERENCES "navarch"."address" ("id");

ALTER TABLE "navarch"."invoice" ADD FOREIGN KEY ("payment_trigger_event") REFERENCES "navarch"."ref_event" ("id");

ALTER TABLE "navarch"."invoice" ADD FOREIGN KEY ("pricing_trigger_event") REFERENCES "navarch"."ref_event" ("id");

ALTER TABLE "navarch"."payment" ADD FOREIGN KEY ("payment_for_invoice") REFERENCES "navarch"."invoice" ("id");
