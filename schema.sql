CREATE DATABASE vet_clinic;

-- \c vet_clinic

CREATE TABLE animals (
  id    INT GENERATED ALWAYS AS IDENTITY,
  name  VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  escape_attempts   INT,
  neutered  BIT,
  weight_kg FLOAT,
  PRIMARY KEY (id)
);

ALTER TABLE animals ADD COLUMN species varchar(100);
